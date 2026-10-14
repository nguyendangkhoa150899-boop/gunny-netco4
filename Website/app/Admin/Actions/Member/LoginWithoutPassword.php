<?php

namespace App\Admin\Actions\Member;

use App\Admin\Controllers\MemberManagement\MemberController;
use App\Http\Requests\Admin\Member\AddCoinRequest;
use Encore\Admin\Actions\RowAction;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class LoginWithoutPassword extends RowAction
{
    public $name = 'Đăng nhập';

    public function handle(Model $model, Request $request)
    {
        $userId = $this->getKey();
        Auth::guard('member')->logout();
        Auth::guard('member')->loginUsingId($userId);
        return $this->response()->success('Đăng nhập vào tài khoản thành công! Mở trang chủ mới để sử dụng phiên đăng nhập');
    }

    public function dialog()
    {
        $this->confirm('Bạn có chắc muốn đăng nhập vào tài khoản này?');
    }

}
