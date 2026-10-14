<?php

namespace App\Admin\Controllers;

use App\ActiveAward;
use App\Admin\Forms\SendItemForm;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Grid;
use Encore\Admin\Layout\Column;
use Encore\Admin\Layout\Content;
use Encore\Admin\Layout\Row;
use Encore\Admin\Widgets\Box;

class SendItemController extends AdminController
{
    protected $title = 'Gửi thư';

    public function showSendItemView(Content  $content)
    {
        return $content->title($this->title)
            ->row(function (Row $row){
                $row->column(12, function (Column $column){
                    $column->row( new Box('Gửi thư cho nhân vật từng server', new SendItemForm()));
                });
            });
    }
}
