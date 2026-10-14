<?php

namespace App\Http\Middleware;

use App\Notifications\TwoFactorCodeNotification;
use Closure;
use Illuminate\Auth\Middleware\Authenticate as Middleware;
use Illuminate\Support\Facades\Auth;

class Authenticate extends Middleware
{
    /**
     * Get the path the user should be redirected to when they are not authenticated.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return string|null
     */
    protected function redirectTo($request)
    {

        if (! $request->expectsJson()) {
            $ref = \Request::getRequestUri();
            session(['ref' => $ref, 'flashMessage' => 'Vui lòng đăng nhập để tiếp tục']);
            return route('home');
        }
    }
//
//    public function handle($request, Closure $next, ...$guards)
//    {
//        $member = Auth::guard('member')->user();
//        if(Auth::guard('member')->check() && $member->TwoFactorCode && $member->TwoFactorStatus && $member->VerifiedEmail)
//        {
//            return redirect(route('verify-2fa'));
//        }
//
//        return $next($request);
//    }
}
