<?php

namespace App\Admin\Actions\Giftcode;

use App\Admin\Controllers\ActiveManagement\GiftCodeController;
use App\Admin\Controllers\MemberManagement\MemberController;
use App\Http\Requests\Admin\Member\AddCoinRequest;
use Encore\Admin\Actions\RowAction;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;

class GenerateGiftCode extends RowAction
{
    public $name = 'Gen Giftcode';

    public function handle(Model $model, Request $request)
    {
        // $model ...

        // Get the `Coin` value in the form
        $gifcodeController = new GiftCodeController();
        if($gifcodeController->generateGiftCode($model, $request))
            return $this->response()->success('Tạo Giftcode thành công.')->refresh();
        return $this->response()->error('Tạo Giftcode không thành công.')->refresh();

    }

    public function form()
    {
        $this->text('Prefix','Tiền tố GiftCode (Ví dụ: GOGUN => GOGUNFHE2J32KE9RE)')
            ->placeholder('Nhập vào tiền tố GiftCode')
            ->width('100%');
        $this->text('Amount','Số lượng')->placeholder("Nhập vào số lượng giftcode sẽ tạo")
            ->default(1)
            ->required()
            ->rules('integer|required|min:1')
            ->width('100%');
    }


}
