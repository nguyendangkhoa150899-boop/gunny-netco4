<?php

namespace App\Admin\Controllers\SystemConfigManagement;

use App\Admin\Extensions\Tools\ClearSlideCacheTool;
use App\Slide;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;

class SlideController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Cấu hình trang slide';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new Slide());

        $grid->column('title', __('Tiêu đề'))->editable();
        $grid->column('link', __('Link'))->editable();
        $grid->column('image', __('Image'))->display(function ($image){
            return '<img src="/storage/'.$image.'" height="100" width="250"  />';
        });

        $grid->tools(function ($tools){
            $tools->append(new ClearSlideCacheTool());
        });

        $grid->disableBatchActions();
        $grid->disableCreateButton();
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
        $show = new Show(Slide::findOrFail($id));

        $show->field('id', __('Id'));
        $show->field('title', __('Title'));
        $show->field('link', __('Link'));
        $show->field('image', __('Image'));
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
        $form = new Form(new Slide());

        $form->text('title', __('Title'));
        $form->text('link', __('Link'));
        $form->image('image', __('Image'));

        return $form;
    }

}
