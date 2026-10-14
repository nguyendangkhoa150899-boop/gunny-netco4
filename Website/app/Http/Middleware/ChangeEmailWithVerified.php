<?php

namespace App\Http\Middleware;

use App\EmailVerify;
use Closure;

class ChangeEmailWithVerified
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        $member = $request->user('member');
        if(EmailVerify::where('Email', $member->Fullname)->exist()){

        }
//        if($member->TwoFactorCode && $member->TwoFactorStatus)
//        {
////            if($member->TwoFactorCodeExpiresAt->lt(now()))
////            {
////                $member->resetTwoFactorCode();
////                auth()->logout();
////                return redirect()->route('/')->withMessage('The two factor code has expired. Please login again.');
////            }
//            if(!$request->is('verify*'))
//            {
//                return redirect()->route('verify-2fa');
//            }
//        }
        return $next($request);
    }
}
