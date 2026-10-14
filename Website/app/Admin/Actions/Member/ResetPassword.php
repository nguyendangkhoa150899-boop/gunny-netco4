<?php

namespace App\Admin\Actions\Member;

use App\Admin\Controllers\MemberManagement\MemberController;
use App\Http\Requests\Admin\Member\AddCoinRequest;
use Encore\Admin\Actions\RowAction;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class ResetPassword extends RowAction
{
    public $name = 'Reset mật khẩu';

    public function handle(Model $model, Request $request)
    {
        $newPwd = $request->input('newPassword');
        $hashedPwd = Hash::make($newPwd);
        $model->update(['Password' => $hashedPwd]);
        return $this->response()->success('Đã reset mật khẩu.')->refresh();
    }

    public function form()
    {
        $this->text('newPassword','Mật khẩu mới')
            ->placeholder('nhập vào mật khẩu mới')
            ->width('100%')
            ->required()
            ->rules('string|required');
    }


}
