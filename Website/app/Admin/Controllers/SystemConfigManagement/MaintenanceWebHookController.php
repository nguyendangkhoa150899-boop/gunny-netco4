<?php

namespace App\Admin\Controllers\SystemConfigManagement;

use App\MaintenanceWebHook;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;

class MaintenanceWebHookController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'MaintenanceWebHook';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new MaintenanceWebHook());

//        $grid->column('id', __('Id'));
        $grid->column('webhook_url', __('Webhook url'))->editable();
        $grid->column('is_active', __('Is active'));

        $grid->disableBatchActions();
        $grid->disableCreateButton();
        $grid->actions(function($actions){
            $actions->disableDelete();
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
        $show = new Show(MaintenanceWebHook::findOrFail($id));

        $show->field('id', __('Id'));
        $show->field('webhook_url', __('Webhook url'));
        $show->field('is_active', __('Is active'));

        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new MaintenanceWebHook());

        $form->text('webhook_url', __('Webhook url'));
        $form->number('is_active', __('Is active'));

        return $form;
    }
}
