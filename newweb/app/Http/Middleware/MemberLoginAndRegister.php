<?php


namespace App\Http\Middleware;


use Closure;
use App\Member;

class MemberLoginAndRegister
{
    public function handle($request, Closure $next)
    {
        $member = new Member();
        if ($member->isLoggedIn()) {
            echo json_encode('Bạn đã đăng nhập rồi!');
            return false;
        }

        return $next($request);
    }
}
