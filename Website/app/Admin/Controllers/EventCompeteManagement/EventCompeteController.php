<?php

namespace App\Admin\Controllers\EventCompeteManagement;

use App\CategoryEventCompete;
use App\EventCompete;
use App\EventTypeCompete;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;

class EventCompeteController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Sự kiện đua top';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new EventCompete());

        $grid->column('id', __('Id'));
        $grid->column('EventCategory.category_name', __('Danh mục'));
        $grid->column('EventType.type_name', __('Loại đua top'));
        $grid->column('event_name', __('Tên sự kiện đua top'));

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
        $show = new Show(EventCompete::findOrFail($id));

        $show->field('id', __('Id'));
        $show->field('category_event_id', __('Category event id'));
        $show->field('event_type_id', __('Event type id'));
        $show->field('event_name', __('Event name'));
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
        $types = EventTypeCompete::all();
        $categories = CategoryEventCompete::all();

        $selectCategory = [];
        $selectType = [];

        foreach ($types as $type)  { $selectType[$type->id] = $type->type_name; }
        foreach ($categories as $category)  { $selectCategory[$category->id] = $category->category_name; }

        $form = new Form(new EventCompete());

        $form->select('category_event_id', __('Danh mục sự kiện'))->options($selectCategory)->required(true)->rules('required');;
        $form->select('event_type_id', __('Hình thức đua top'))->options($selectType)->required(true)->rules('required');
        $form->text('event_name', __('Tên sự kiện'))->placeholder('Nhập tên sự kiện')->rules('required');

        return $form;
    }
}
