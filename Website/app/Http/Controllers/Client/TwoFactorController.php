<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\Http\Requests\Client\TwoFactor\SendVerifyCodeRequest;
use App\Mailer;
use App\Member;
use App\Notifications\TwoFactorCodeNotification;
use Carbon\Carbon;
use Illuminate\Http\Request;
use App\Http\Requests\Client\TwoFactor\VerifyTwoFactorRequest;
use Illuminate\Support\Facades\Auth;


class TwoFactorController extends Controller
{
    private function active2FAMode()
    {
        $member = Auth::guard('member')->user();
        if($member->TwoFactorStatus && $member->VerifiedEmail){
            $mailer = new Mailer();
            $member->generateTwoFactorCode();
            $mailer->sendTwoFactorAuthenticateCode($member->Fullname, $member->TwoFactorCode);
//            $member->notify(new TwoFactorCodeNotification());
        }
    }

    public function sendTwoFactorCode(SendVerifyCodeRequest $request)
    {
        $member = $request->user('member');
        $twoFactorCodeExpiresAt = $member->TwoFactorCodeExpiresAt;
        $twoFactorCodeSentTime = Carbon::create($twoFactorCodeExpiresAt)->addMinute();
        $currentTime = Carbon::now()->addMinutes(20);
        if(!$currentTime->gte($twoFactorCodeSentTime)){
            return response()->json(['msg'=>'Lỗi: Vui lòng đợi 1 phút để có thể gửi mã xác thực tiếp theo!'],400);
        }
        $this->active2FAMode();
        return response()->json(['msg'=> 'Đã gửi mã xác thực thành công, vui lòng check Email của bạn'], 200);
    }

    public function showVerifyView(Request $request)
    {
        if($request->user('member')->TwoFactorCode)
            return view('client.2fa.index');
        return redirect(route('home'));
    }

    public function verifyTwoFactorCode(VerifyTwoFactorRequest $request)
    {
        $member = Auth::guard('member')->user();
        if($request->input('code') == $member->TwoFactorCode){
            $member->resetTwoFactorCode();
            return redirect(route('view-account'));
        }
        return back()->withErrors(['msg'=> 'Mã xác thực không chính xác']);
    }

    public function resend()
    {
        return //unused
        $member = Auth::guard('member')->user();
        $member->generateTwoFactorCode();
        $member->notify(new TwoFactorCodeNotification());
        return response()->json(['msg'=> 'Mã xác nhận đã được gửi lại']);
    }

    public function enableTwoFactor(Request $request)
    {
        if(!$request->user('member')->TwoFactorStatus)
            Member::where('UserID', $request->user('member')->UserID)->update(['TwoFactorStatus' => 1 ]);
        return redirect(route('view-account'));
    }

    public function disableTwoFactor(Request $request)
    {
        if($request->user('member')->TwoFactorStatus)
            Member::where('UserID', $request->user('member')->UserID)->update(['TwoFactorStatus' => 0 ]);
        return redirect(route('view-account'));
    }
}
