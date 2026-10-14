<?php

namespace App\Admin\Extensions\Tools\Quest;

use App\Admin\Forms\AddActiveAward;
use Encore\Admin\Admin;
use Encore\Admin\Grid\Tools\AbstractTool;
use Illuminate\Support\Facades\Request;

class RedirectToCreateMultipleQuestGoods extends AbstractTool
{
    protected function script()
    {

    }

    public function render()
    {
        return view('admin.tools.quest.create-multiple-quest-goods');
    }
}
