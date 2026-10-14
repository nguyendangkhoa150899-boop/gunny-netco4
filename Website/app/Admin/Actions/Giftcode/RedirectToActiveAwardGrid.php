<?php

namespace App\Admin\Actions\Giftcode;

use Encore\Admin\Actions\RowAction;
use Illuminate\Database\Eloquent\Model;

class RedirectToActiveAwardGrid extends RowAction
{
    public $name = 'Chỉnh sửa phần thưởng';

    public function href()
    {
        return 'active-award-management?active_id='. $this->getKey();
    }


}
