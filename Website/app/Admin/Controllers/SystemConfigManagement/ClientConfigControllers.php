<?php

namespace App\Admin\Controllers\SystemConfigManagement;

use App\Admin\Extensions\Tools\ClearConfigCacheTool;
use App\Config;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;

class ClientConfigControllers extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Cấu hình trang client (Sau khi chỉnh sửa xong phải Xoá Cache)';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new Config());

//        $grid->column('id', __('Id'));
        $grid->column('key', __('Key'));
        $grid->column('description', __('Mô tả'));
        $grid->column('value', __('Tham số'))->editable();
        $grid->perPage(50);

        $grid->disableFilter();
        $grid->disableCreateButton();
        $grid->disableExport();
        $grid->actions(function ($actions){
            $actions->disableView();
//            $actions->disableEdit();
            $actions->disableDelete();

        });
        $grid->tools(function ($tools){
            $tools->append(new ClearConfigCacheTool());
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
        $show = new Show(Config::findOrFail($id));

        $show->field('id', __('Id'));
        $show->field('key', __('Key'));
        $show->field('value', __('Value'));
        $show->field('description', __('Description'));

        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new Config());
        $form->text('key', __('Key'))->disable()->readonly();
        $form->text('description', __('Mô tả'));
        $form->text('value', __('Value'));

        $form->submitted(function (Form $form){
            $form->ignore('key');
        });
        return $form;
    }
}
