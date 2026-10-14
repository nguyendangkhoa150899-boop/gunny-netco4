<?php

namespace App\Http\Controllers;

use App\ForgotPassAttempt;
use App\Http\Requests\ForgotPassChangePasswordRequest;
use App\Http\Requests\ForgotPassRequest;
use App\Http\Requests\LoginCodeRequest;
use App\Mailer;
use App\Member;
use App\Http\Requests\MemberRegisterRequest;
use App\Http\Requests\MemberLoginRequest;
use App\TwoFactor;

class AuthController extends Controller
{

    public function register(MemberRegisterRequest $request)
    {
        $email = $request->username;
        $email = strtolower($email);
        $existedMember = Member::where('Email', $email)->get();
        if (!empty($existedMember) && $existedMember->count()) {
            $this->error('Tài khoản đã tồn tại!');
        }
        $real_email = $request->email;
        if (!empty($real_email)) {
            $existedMember = Member::where('Fullname', $real_email)->get();
            if (!empty($existedMember) && $existedMember->count()) {
                $this->error('Email đã được sử dụng!');
            }
        }
        $password = md5($request->password);
        $member = new Member();
        $member->Email = $email;
        $member->Password = $password;
        $member->Money = 0;
        $member->TimeCreate = time();
        $member->IPCreate = $request->ip();
        $member->MoneyLock = 0;
        $member->Fullname = $real_email;
        if ($member->save()) {
            $this->success('Đăng ký thành công!');
        }
        $this->error('Không thể đăng ký tài khoản mới vào lúc này, vui lòng quay lại sau!');
    }

    public function refreshCaptcha()
    {
        echo json_encode(['url' => captcha_src()]);
        return;
    }

    public function login(MemberLoginRequest $request)
    {
        $email = $request->username;
        $password = $request->password;
        $existedMember = Member::where('Email', $email)
            ->where('Password', md5($password))
            ->get();
        if (!empty($existedMember) && $existedMember->count()) {
            $member = $existedMember->first();
            if ($member->IsBan) {
                $this->error('Tài khoản của bạn đã bị khóa!');
            }
            if (!empty($member['2fa']) && !empty($member->Fullname)) {
                $this->setSession('2fa_member_id', $member->UserID);
                $sent_status = $this->sendCode();
                if ($sent_status === 0) {
                    $this->success(sensorEmail($member->Fullname), [], 2);
                }
                if ($sent_status === 1) {
                    $this->error('Có lỗi xảy ra, vui lòng thử lại hoặc liên hệ quản trị viên để được trợ giúp!');
                }
                if ($sent_status === 2) {
                    $this->error('Không thể gửi email, thử lại hoặc liên hệ quản trị viên để được trợ giúp!');
                }
            }
            //fix for error of over time
            $member->Email = strtolower($member->Email);
            $member->save();
            $member->login();
            $this->success('Đăng nhập thành công!');
        }
        $this->error('Sai tài khoản hoặc mật khẩu!');
    }

    public function loginCode2Fa(LoginCodeRequest $request)
    {
        $code = $request->code;
        $member_id = $this->getSession('2fa_member_id');
        if (empty($member_id)) {
            $this->error('Yêu cầu không hợp lệ!!');
        }
        $existed2facode = TwoFactor::where('MemberID', $member_id)
            ->where('code', md5($code))
            ->where('status', 0)
            ->orderBy('created_at', 'DESC')
            ->get();
        if (!empty($existed2facode) && $existed2facode->count()) {
            $last2fa = $existed2facode->first();
            $last_time = strtotime($last2fa->created_at);
            $time = strtotime('now') - $last_time;
            if ($time < env('2FA_CODE_EXPIRES', 120)) {
                $last2fa->status = 1;
                if ($last2fa->save()) {
                    $member = Member::findOrFail($member_id);
                    $member->login();
                    $this->unsetSession('2fa_member_id');
                    $this->success('Đăng nhập thành công!');
                }
                $this->error('Có lỗi xảy ra, vui lòng thử lại hoặc liên hệ quản trị viên để được trợ giúp!');
            }
            foreach ($existed2facode as $item) {
                $item->status = 2;
                $item->save();
            }
            $this->error('Mã hết hiệu lực!');
        }
        $this->error('Yêu cầu không hợp lệ!');
    }

    public function loginResendCode2Fa()
    {
        $member_id = $this->getSession('2fa_member_id');
        if (empty($member_id)) {
            $this->error('Yêu cầu không hợp lệ!');
        }
        $existed2facode = TwoFactor::where('MemberID', $member_id)
            ->where('status', 0)
            ->orderBy('created_at', 'DESC')
            ->get();
        if (!empty($existed2facode) && $existed2facode->count()) {
            $last2fa = $existed2facode->first();
            $last_time = strtotime($last2fa->created_at);
            $time = strtotime('now') - $last_time;
            if ($time > env('2FA_WAITING_TIME_TO_RESEND', 60)) {
                foreach ($existed2facode as $item) {
                    $item->status = 2;
                    $item->save();
                }
                $sent_status = $this->sendCode();
                if ($sent_status === 0) {
                    $this->success('Gửi lại mã đăng nhập thành công!');
                }
                if ($sent_status === 1) {
                    $this->error('Có lỗi xảy ra, vui lòng thử lại hoặc liên hệ quản trị viên để được trợ giúp!');
                }
                if ($sent_status === 2) {
                    $this->error('Không thể gửi email, thử lại hoặc liên hệ quản trị viên để được trợ giúp!');
                }
            }
            $rest_time = env('2FA_WAITING_TIME_TO_RESEND', 60) - $time;
            $this->error('Hãy đợi ' . intval($rest_time/60).':'.intval($rest_time%60).'s nữa rồi thử lại!');
        }
        $this->error('Yêu cầu không hợp lệ!');
    }

    protected function sendCode($type = 'twofactor')
    {
        $mailer = new Mailer();
        if ($type == 'twofactor') {
            $twofa = new TwoFactor();
            $member_id = $this->getSession('2fa_member_id');
            $member = Member::findOrFail($member_id);
            $mail_sent = $mailer->TwoFactorAuthentication($member->Fullname);
        } else if ($type == 'forgotpass') {
            $twofa = new ForgotPassAttempt();
            $member_id = $this->getSession('forgotpass_member_id');
            $member = Member::findOrFail($member_id);
            $mail_sent = $mailer->ForgotPass($member->Fullname);
        }
        if ($mail_sent['success']) {
            $twofa->MemberID = $member->UserID;
            $twofa->code = md5($mail_sent['code']);
            $twofa->status = 0;
            if (!$twofa->save()) {
                return 1; //error when save
            }
            return 0; //success
        }
        return 2; //cannot send mail
    }

    public function logout()
    {
        $m = new Member();
        $m->logout();
        return redirect('/');
    }

    public function forgotPass(ForgotPassRequest $request)
    {
        $email = $request->email;
        $member = Member::where('Fullname', $email)
            ->first();
        if (!empty($member)) {
            $attempts = ForgotPassAttempt::where("MemberID", $member->UserID)
                ->where('status', 0)
                ->orderBy('created_at', 'DESC')
                ->get();
            if (!empty($attempts) && $attempts->count()) {
                $last_attempt = $attempts->first();
                $time = strtotime('now') - strtotime($last_attempt->created_at);
                if ($time < env('2FA_WAITING_TIME_TO_RESEND', 60)) {
                    $minute = intval((env('2FA_WAITING_TIME_TO_RESEND', 60) - $time)/60);
                    $second = intval((env('2FA_WAITING_TIME_TO_RESEND', 60) - $time)%60);
                    $this->error('Thử lại sau '.$minute.':'.$second.'s');
                }
                foreach ($attempts as $attempt) {
                    $attempt->status = 2;
                    $attempt->save();
                }
            }
            $this->setSession('forgotpass_member_id', $member->UserID);
            $this->setSession('forgotpass_member_id_valid', 0);
            $sent_status = $this->sendCode('forgotpass');
            if ($sent_status === 0) {
                $this->success($member->Fullname);
            }
            if ($sent_status === 1) {
                $this->error('Có lỗi xảy ra, vui lòng thử lại hoặc liên hệ quản trị viên để được trợ giúp!');
            }
            if ($sent_status === 2) {
                $this->error('Không thể gửi email, thử lại hoặc liên hệ quản trị viên để được trợ giúp!');
            }
        }
    }

    public function forgotPassCode2Fa(LoginCodeRequest $request)
    {
        $code = $request->code;
        $member_id = $this->getSession('forgotpass_member_id');
        if (empty($member_id)) {
            $this->error('Yêu cầu không hợp lệ!!');
        }
        $existed2facode = ForgotPassAttempt::where('MemberID', $member_id)
            ->where('code', md5($code))
            ->where('status', 0)
            ->orderBy('created_at', 'DESC')
            ->get();
        if (!empty($existed2facode) && $existed2facode->count()) {
            $last2fa = $existed2facode->first();
            $last_time = strtotime($last2fa->created_at);
            $time = strtotime('now') - $last_time;
            foreach ($existed2facode as $item) {
                if ($item->id == $last2fa->id) {
                    continue;
                }
                $item->status = 2;
                $item->save();
            }
            if ($time < env('2FA_CODE_EXPIRES', 120)) {
                $last2fa->status = 1;
                if ($last2fa->save()) {
                    $this->setSession('forgotpass_member_id_valid', 1);
                    $this->success('');
                }
                $this->error('Có lỗi xảy ra, vui lòng thử lại hoặc liên hệ quản trị viên để được trợ giúp!');
            }
            foreach ($existed2facode as $item) {
                $item->status = 2;
                $item->save();
            }
            $this->error('Mã hết hiệu lực!');
        }
        $this->error('Yêu cầu không hợp lệ!');
    }

    public function changePass(ForgotPassChangePasswordRequest $request)
    {
        $password = $request->password;
        $member_id = $this->getSession('forgotpass_member_id');
        $valid = $this->getSession('forgotpass_member_id_valid');
        if (empty($member_id) || empty($valid)) {
            $this->error('Yêu cầu không hợp lệ!!');
        }
        $member = Member::find($member_id);
        if (!empty($member)) {
            if ($member->Password == md5($password)) {
                $this->error('Vui lòng không sử dụng mật khẩu cũ!');
            }
            $member->Password = md5($password);
            if ($member->save()) {
                $this->unsetSession('forgotpass_member_id');
                $this->unsetSession('forgotpass_member_id_valid');
                $this->success('Đổi mật khẩu thành công!');
            }
            $this->error("Có lỗi hệ thống, vui lòng thử lại hoặc liên hệ quản trị viên để được hỗ trợ!");
        }
        $this->error('Tài khoản không tồn tại!');
    }
}
