<?php

namespace App\Admin\Actions\Quest;

use Encore\Admin\Actions\RowAction;
use Illuminate\Http\Request;

class AddQuestGoods extends RowAction
{
    protected $selector = '.redirect-edit-action';
    public $name = "Thêm phần thưởng";

    /**
     * @return  string
     */
    public function href()
    {
        return 'create-multiple-quest-goods?questId='.$this->getKey();
    }

    public function html()
    {
        return <<<HTML
        <a class="btn btn-sm btn-default redirect-edit-action"></a>
HTML;
    }
}
