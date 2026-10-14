<?php

namespace App\Admin\Controllers\SystemConfigManagement;

use App\Setting;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;

class SettingController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Cấu hình thanh toán & cấu hình game';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new Setting());

        $grid->column('ID', __('ID'));
        $grid->column('Key', __('Key'));
        $grid->column('Name', __('Name'));
        $grid->column('Description', __('Description'))->editable();
        $grid->column('Value', __('Value'))->editable();
        $grid->column('Field', __('Field'));
        $grid->column('Active', __('Active'));
        $grid->column('created_at', __('Created at'));
        $grid->column('updated_at', __('Updated at'));

        $grid->disableCreateButton();
        $grid->disableFilter();
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
        $show = new Show(Setting::findOrFail($id));

        $show->field('ID', __('ID'));
        $show->field('Key', __('Key'));
        $show->field('Name', __('Name'));
        $show->field('Description', __('Description'));
        $show->field('Value', __('Value'));
        $show->field('Field', __('Field'));
        $show->field('Active', __('Active'));
        $show->field('created_at', __('Created at'));
        $show->field('updated_at', __('Updated at'));

        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new Setting());

        $form->text('Key','Key')->disable()->readonly();
        $form->text('Name', __('Name'));
        $form->text('Description', __('Mô tả'));
        $form->text('Value', __('Value'));
        $form->text('Field', __('Field'));
        $form->number('Active', __('Active'));
        $form->submitted(function (Form $form){
            $form->ignore('Key');
        });
        return $form;
    }
}
