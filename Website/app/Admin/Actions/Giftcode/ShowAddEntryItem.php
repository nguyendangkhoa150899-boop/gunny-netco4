<?php

namespace App\Admin\Actions\Giftcode;

use Encore\Admin\Actions\RowAction;
use Illuminate\Database\Eloquent\Model;

class ShowAddEntryItem extends RowAction
{
    public $name = 'Phần thưởng';

    public function handle(Model $model)
    {
        // $model ...

        return $this->response()->success('Success message.')->refresh();
    }

    public function form()
    {
        $this->text('Coin', 'Nạp tiền (Coin) cho tài khoản')
            ->placeholder('Nhập vào số tiền (đ)')
            ->width('100%')
            ->required()
            ->rules('integer|required');
    }
}
