<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\Http\Requests\Client\ForgotPassword\ResetPasswordRequest;
use App\Http\Requests\Client\ForgotPassword\SendForgotPasswordEmailRequest;
use App\Mailer;
use App\Member;
use App\Notifications\ForgotPasswordNotification;
use App\PasswordReset;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class ForgotPasswordController extends Controller
{
    public function showForgotPassword()
    {
        return view('client.forgot-password.forgot-password');
    }

    public function sendForgotPasswordEmail(SendForgotPasswordEmailRequest $request)
    {
        $username = $request->input('username');
        $member = Member::where('Email', $username)->first();
        if($member) {
            $token = Str::random(65);
            $url = route('view-change-password-by-forgot') . '?token=' . $token;
            $mailer = new Mailer();

            $passwordReset = PasswordReset::where('email', $member->Fullname)->first();

            if ($passwordReset) {
                $latestSentTime = Carbon::create($passwordReset->created_at)->addMinute(1);
                if (!Carbon::now()->gte($latestSentTime))
                    return response()->json(['msg' => 'Vui lòng đợi 1 phút để gửi email tiếp theo.'], 400);
                $sentStatusS1 = $mailer->sendForgotPasswordMail($member->Fullname, $url);
                if ($sentStatusS1['success']) {
                    PasswordReset::where('email', $member->Fullname)->update(['token' => $token, 'created_at' => now()]);
                    return response()->json(['msg' => 'Đã gửi thư lấy lại mật khẩu. Vui lòng kiểm tra hòm thư (Cả trong Spam)']);
                } else return response()->json(['msg' => 'Lỗi hệ thống, vui lòng liên hệ quản trị viên'], 400);
            } else {
                PasswordReset::create(['email' => $member->Fullname, 'token' => $token, 'created_at' => now()]);
                $sentStatusS2 = $mailer->sendForgotPasswordMail($member->Fullname, $url);
                if ($sentStatusS2['success']) {
                    PasswordReset::where('email', $member->Fullname)->update(['token' => $token, 'created_at' => now()]);
                    return response()->json(['msg' => 'Đã gửi thư lấy lại mật khẩu. Vui lòng kiểm tra hòm thư (Cả trong Spam)']);
                } else return response()->json(['msg' => 'Lỗi hệ thống, vui lòng liên hệ quản trị viên'], 400);
            }
        }
        return response()->json(['msg' => 'Không tìm thấy tài khoản tương ứng'],400);
    }

    public function showChangePasswordView(Request $request)
    {
        $token = $request->input('token');
        if($request->input('token')){
            if(PasswordReset::where('token', $token)->exists()){
                return view('client.forgot-password.verify-forgot-password-from-mail');
            }
        }
        $title = "LẤY LẠI MẬT KHẨU QUA EMAIL";
        return view('client.invalid',compact('title'));
    }

    public function resetPassword(ResetPasswordRequest $request)
    {
        $token = $request->input('token');
        $password = $request->input('password');
        $passwordReset = PasswordReset::where('token', $token)->first();
        if($passwordReset){
            $hashedPassword = Hash::make($password);
            $email = $passwordReset->email;
            Member::where('Fullname', $email)->update(['Password' => $hashedPassword]);
            PasswordReset::where('token', $token)->delete();
            return response()->json(['msg'=> 'Khôi phục mật khẩu thành công.']);
        }
        return response()->json(['msg'=> 'Không hợp lệ.'], 400);
    }
}
