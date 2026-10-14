<?php

namespace App\Admin\Controllers\EventCompeteManagement;

use App\EventTypeCompete;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;

class EventTypeCompeteController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Loại hình đua top';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new EventTypeCompete());

        $grid->column('id', __('Id'));
        $grid->column('type_name', __('Hình thức'));
        $grid->column('type_description', __('Mô tả hình thức'));
//        $grid->column('created_at', __('Created at'));
//        $grid->column('updated_at', __('Updated at'));
        $grid->disableCreateButton();
        $grid->disableBatchActions();
        $grid->disableActions();
        $grid->actions(function ($actions){
            $actions->disableDelete();
            $actions->disableView();
        });

        return $grid;
    }

    /**
     * Make a show builder.
     *
     * @param mixed $id
     * @return Show
     */
    protected function detail($id)
    {
        $show = new Show(EventTypeCompete::findOrFail($id));

        $show->field('id', __('Id'));
        $show->field('type_name', __('Type name'));
        $show->field('type_description', __('Type description'));
//        $show->field('created_at', __('Created at'));
//        $show->field('updated_at', __('Updated at'));

        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new EventTypeCompete());

        $form->text('type_name', __('Hình thức'));
        $form->text('type_description', __('Mô tả hình thức'));

        return $form;
    }
}
