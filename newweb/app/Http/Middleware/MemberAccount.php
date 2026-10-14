<?php


namespace App\Http\Middleware;


use Closure;
use App\Member;

class MemberAccount
{
    public function handle($request, Closure $next)
    {
        $member = new Member();

        if (!$member->isLoggedIn()) {
            return redirect('/');
        }

        return $next($request);
    }
}
