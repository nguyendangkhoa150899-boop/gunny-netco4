<?php

namespace App\Admin\Actions\Member;

use App\Admin\Controllers\MemberManagement\MemberController;
use App\Http\Requests\Admin\Member\AddCoinRequest;
use Encore\Admin\Actions\RowAction;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;

class RechargeMoney extends RowAction
{
    public $name = 'Nạp tiền';

    public function handle(Model $model, Request $request)
    {
        // $model ...

        // Get the `Coin` value in the form
        $coin = $request->input('Coin');

        $memberController = new MemberController;
        if($memberController->addCoinToMember($model, $request))
            return $this->response()->success('Nạp coin thành công.')->refresh();
        return $this->response()->error('Nạp coin không thành công.')->refresh();

    }

    public function form()
    {
        $this->text('Coin','Nạp tiền (Coin) cho tài khoản')
            ->placeholder('Nhập vào số tiền (đ)')
            ->width('100%')
            ->required()
            ->rules('integer|required');
        $this->text('Bonus','Khuyến mãi cá nhân (VD: 10% thì nhập 10)')
            ->placeholder('Nhập % khuyến mãi')
            ->default(0)
            ->width('100%')
            ->required()
            ->rules('integer|required');

    }


}
