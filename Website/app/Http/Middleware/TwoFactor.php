<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\Auth;

class TwoFactor
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
        if($member->TwoFactorCode && $member->TwoFactorStatus)
        {
//            if($member->TwoFactorCodeExpiresAt->lt(now()))
//            {
//                $member->resetTwoFactorCode();
//                auth()->logout();
//                return redirect()->route('/')->withMessage('The two factor code has expired. Please login again.');
//            }
            if(!$request->is('verify*'))
            {
                return redirect()->route('verify-2fa');
            }
        }

        return $next($request);
    }
}
