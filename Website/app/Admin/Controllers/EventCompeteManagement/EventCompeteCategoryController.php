<?php

namespace App\Admin\Controllers\EventCompeteManagement;

use App\CategoryEventCompete;
use App\ServerList;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;

class EventCompeteCategoryController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Quản lý danh mục sự kiện (Đua TOP)';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new CategoryEventCompete());

        $grid->column('id', __('Id'));
        $grid->column('server_id','Server');
        $grid->column('category_name', __('Danh mục'));
//        $grid->column('description', __('Mô tả'));
        $grid->column('start_time', __('Thời gian bắt đầu'))->display(function ($start_time){
            return date('H:i A - d-m-Y', strtotime($start_time));
        });
        $grid->column('end_time', __('Thời gian kết thúc'))->display(function ($end_time){
            return date('H:i A - d-m-Y', strtotime($end_time));
        });
//        $grid->column('is_active', __('Trạng thái'))->display(function ($is_active){
//            if($is_active == 1)
//                return '<span class="badge btn-success">Kích hoạt</span>';
//            return '<span class="badge btn-danger">Không hoạt động</span>';
//        });
        $grid->column('is_show_popup', __('Hiển thị Popup'))->display(function ($is_show_popup){
            if($is_show_popup == 1)
                return '<span class="badge btn-success">Hiển thị</span>';
            return '<span class="badge btn-danger">Không hiển thị</span>';
        });
        $grid->column('image', __('Hình ảnh'))->display(function (){
            return $this->getImage();
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
        $show = new Show(CategoryEventCompete::findOrFail($id));

        $show->field('id', __('Id'));
        $show->field('server_id', __('Server'));
        $show->field('category_name', __('Danh mục đua top'));
        $show->field('description', __('Description'));
        $show->field('start_time', __('Start time'));
        $show->field('end_time', __('End time'));
//        $show->field('is_active', __('Is active'));
        $show->field('is_show_popup', __('Is show popup'));
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
        $form = new Form(new CategoryEventCompete());

        $serverList  = ServerList::all();
        $servers = [];
        foreach ($serverList as $server)
        {
            $servers[$server->ServerID] = $server->ServerName;
        }

        $form->text('category_name', __('Danh mục đua top'))->required(true);
        $form->select('server_id', 'Máy chủ')->options($servers);
        $form->ckeditor('description', __('Mô tả sự kiện'));
        $form->datetime('start_time', __('Thời gian bắt đầu'))->default(date('Y-m-d H:i:s'))->required(true);;
        $form->datetime('end_time', __('Thời gian kết thúc'))->default(date('Y-m-d H:i:s'))->required(true);;
//        $form->switch('is_active', __('Kích hoạt'))->default(1);
        $form->switch('is_show_popup', __('Hiện popup'))->default(1);
        $form->image('image', __('Hình ảnh'));

        return $form;
    }
}
