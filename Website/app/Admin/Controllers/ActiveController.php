<?php

namespace App\Admin\Controllers;

use App\Active;
use App\ActiveAward;
use App\Admin\Forms\AddActiveAward;
use App\Admin\Forms\AddActiveWithItem;
use App\Admin\Forms\Steps\AddActiveStep;
use App\Admin\Forms\Steps\AddActiveItemAwardStep;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Grid;
use Encore\Admin\Layout\Column;
use Encore\Admin\Layout\Content;
use Encore\Admin\Layout\Row;
use Encore\Admin\Widgets\MultipleSteps;

class ActiveController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Quản lý Hoạt động (Giftcode)';

    /*
     * DEPRECATED
     */
    public function showAddActive(Content $content)
    {
        $steps = [
            'active'       => AddActiveStep::class,
            'add-award' => AddActiveItemAwardStep::class,
        ];

        return $content->title('Hoat cmn dong')
            ->body(MultipleSteps::make($steps));

        return $content->title($this->title)
            ->row(function (Row $row){
                $row->column(12, function (Column $column){
                    $column->row(new AddActiveWithItem());
                });
            })
            ->row(function (Row $row){
                $row->column(12, function (Column $column){
                    $grid = new Grid(new ActiveAward());
                    $grid->model()->where('ActiveID', 10);
                    $grid->column('ActiveID','ActiveID');
                    $column->row($grid);
                });

            });
//            ->body(new AddActiveWithItem());
//            ->body(Tab::forms($forms))
    }


    public function editActive(Content $content)
    {
        return $content->title($this->title)
            ->body(new AddActiveWithItem());
    }


}
