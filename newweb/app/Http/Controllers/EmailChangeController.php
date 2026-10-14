<?php


namespace App\Http\Controllers;


use App\EmailChangeAttempt;
use App\Http\Requests\ChangeEmailCodeRequest;
use App\Http\Requests\ChangeEmailRequest;
use App\Mailer;
use App\Member;

class EmailChangeController extends Controller
{
    public function emailChangePost(ChangeEmailRequest $request)
    {
        $real_email = $request->email;
        $password = $request->password;
        $member = $this->getCurrentMember();
        if ($member->Password != md5($password)) {
            $this->error('Mật khẩu không đúng!');
        }
        if ($member->Fullname == $real_email) {
            $this->error('Không được dùng email cũ!');
        }
        $existedMember = Member::where('Fullname', $real_email)
            ->where('UserID', '!=', $member->UserID)
            ->get();
        if (!empty($existedMember) && $existedMember->count()) {
            $this->error('Email đã được sử dụng!');
        }
        if (!empty($member['VerifiedEmail']) && $member->Fullname) {
            $attempt = new EmailChangeAttempt();
            $mailer = new Mailer();
            $mail_sent = $mailer->TwoFactorAuthentication($member->Fullname);
            if ($mail_sent['success']) {
                $attempt->MemberID = $member->UserID;
                $attempt->old_email = $member->Fullname;
                $attempt->new_email = $real_email;
                $attempt->code_hash = md5($mail_sent['code']);
                $attempt->noticed = 0;
                $attempt->status = 0;
                if (!$attempt->save()) {
                    $this->error('Có lỗi xảy ra, vui lòng thử lại hoặc liên hệ quản trị viên để được trợ giúp!');
                }
                $this->success('Email hợp lệ, tuy nhiên bạn cần phải xác thực bằng email cũ!', [], 2);
            } else {
                $this->error('Chúng tôi không thể gửi email xác thực cho bạn, vui lòng thử lại hoặc liên hệ quản trị viên để được trợ giúp!');
            }
        }
        $member->Fullname = $real_email;
        $member['2fa'] = 0;
        $member->VerifiedEmail = 0;
        if ($member->save()) {
            $this->success('Đổi email thành công!');
        }
        $this->error('Có lỗi xảy ra, vui lòng liện hệ quản trị viên để được trợ giúp!');
    }

    public function emailChangeResendCode()
    {
        $m = new Member();
        $member = $m->current();
        if (!empty($member['2fa']) && $member->Fullname) {
            $attempt = EmailChangeAttempt::where('MemberID', $member->UserID)
                ->where('status', 0)
                ->orderBy('created_at', 'DESC')
                ->get();
            if (!empty($attempt) && $attempt->count()) {
                $last_attempt = $attempt->first();
                $last_time = strtotime($last_attempt->created_at);
                $time = strtotime('now') - $last_time;
                if ($time < env('2FA_WAITING_TIME_TO_RESEND', 60)) {
                    $this->error('Hãy đợi ' . intval((env('2FA_WAITING_TIME_TO_RESEND', 60) - $time)/60).':'.((env('2FA_WAITING_TIME_TO_RESEND', 60) - $time)%60).'s nữa rồi thử lại!');
                }
                foreach ($attempt as $item) {
                    $item->status = 2;
                    $item->save();
                }
            }
            $attempt = new EmailChangeAttempt();
            $mailer = new Mailer();
            $mail_sent = $mailer->TwoFactorAuthentication($member->Fullname);
            if ($mail_sent['success']) {
                $attempt->MemberID = $member->UserID;
                $attempt->old_email = $member->Fullname;
                $attempt->new_email = $last_attempt->new_email;
                $attempt->code_hash = md5($mail_sent['code']);
                $attempt->noticed = 0;
                $attempt->status = 0;
                if (!$attempt->save()) {
                    $this->error('Có lỗi xảy ra, vui lòng thử lại hoặc liên hệ quản trị viên để được trợ giúp!');
                }
                $this->success('Gửi lại code thành công!');
            } else {
                $this->error('Chúng tôi không thể gửi email xác thực cho bạn, vui lòng thử lại hoặc liên hệ quản trị viên để được trợ giúp!');
            }
        }
        $this->error('Bạn chưa bật 2FA!');
    }

    public function emailChangeCodePost(ChangeEmailCodeRequest $request)
    {
        $m = new Member();
        $member = $m->current();
        $code = $request->code;
        if (!empty($member['VerifiedEmail']) && $member->Fullname) {
            $attempt = EmailChangeAttempt::where('MemberID', $member->UserID)
                ->where('status', 0)
                ->where('code_hash', md5($code))
                ->orderBy('created_at', 'DESC')
                ->get();
            if (!empty($attempt) && $attempt->count()) {
                $last_attempt = $attempt->first();
                $last_time = strtotime($last_attempt->created_at);
                $time = strtotime('now') - $last_time;
                $last_attempt->status = 2;
                $last_attempt->save();
                if ($time > env('2FA_WAITING_TIME_TO_RESEND', 300)) {
                    echo json_encode(['success' => false, 'message' => 'Mã đã hết hạn!']);
                    return;
                }
                $member->Fullname = $last_attempt->new_email;
                $member['2fa'] = 0;
                $member->VerifiedEmail = 0;
                if ($member->save()) {
                    echo json_encode(['success' => true, 'message' => 'Đổi email thành công!']);
                    return;
                }
                echo json_encode(['success' => false, 'message' => 'Có lỗi xảy ra, vui lòng liện hệ quản trị viên để được trợ giúp!']);
                return;
            }
        }
        echo json_encode(['success' => false, 'message' => 'Yêu cầu không hợp lệ!']);
        return;
    }
}
