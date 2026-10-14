<?php

namespace App\Admin\Actions\Member;

use App\Admin\Controllers\MemberManagement\MemberController;
use App\Http\Requests\Admin\Member\AddCoinRequest;
use Encore\Admin\Actions\RowAction;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;

class BanOrUnbanMember extends RowAction
{
    public $name = 'Khoá TK/Mở TK';

    public function handle(Model $model, Request $request)
    {
        // $model ...
//        dd($model);
        $isBan = $model->IsBan;
        $model->IsBan = !$model->IsBan;
        if($model->save()){
            if($isBan == 0)
                return $this->response()->success('Khoá tài khoản thành công!')->refresh();
            else
                return $this->response()->success('Mở khoá tài khoản thành công!')->refresh();
        }
        return $this->response()->error('Thao tác không thành công! Vui lòng liên hệ Admin!')->refresh();

    }

    public function dialog()
    {
        $this->confirm('Bạn có chắc muốn khoá/mở khoá tài khoản này?');
    }



}
