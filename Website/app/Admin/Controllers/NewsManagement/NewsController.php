<?php

namespace App\Admin\Controllers\NewsManagement;

use App\News;
use Carbon\Carbon;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;

class NewsController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Danh sách bài viết';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new News());

        $grid->column('NewsID', __('NewsID'));
        $grid->column('Title', __('Tiêu đề'));
        $grid->column('Type', __('Loại tin tức'))->display(function ($type){
            switch ((int)$type){
                case 1:
                    return '<span class="badge btn-warning">Thông báo</span>';
                case 2:
                    return '<span class="badge btn-info">Tin Tức</span>';
                case 3:
                    return '<span class="badge btn-success">Sự kiện</span>';
                default:
                    return '<span class="badge btn-danger">Không xác định</span>';
            }
        })->filter([
            1 => "Thông báo",
            2 => "Tin tức",
            3 => "Sự kiện",
            4 => "Không xác định"
        ]);
//        $grid->column('TimeCreate', __('Thời gian tạo'));
//        $grid->column('Link', __('Đường dẫn'));
        $grid->disableExport();
        $grid->disableFilter();
        $grid->quickSearch('Title');
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
        $show = new Show(News::findOrFail($id));

        $show->field('NewsID', __('NewsID'));
        $show->field('Title', __('Title'));
        $show->Type()->unescape()->as(function ($type){
            switch ((int)$type){
                case 1:
                    return '<span class="badge btn-warning">Thông báo</span>';
                case 2:
                    return '<span class="badge btn-info">Tin Tức</span>';
                case 3:
                    return '<span class="badge btn-success">Sự kiện</span>';
                default:
                    return '<span class="badge btn-danger">Không xác định</span>';
            }
        });

        $show->Content()->unescape()->as(function ($content) {
            return $content;
        });
//        $show->field('Content', __('Nội dung'));
//        $show->field('TimeCreate', __('TimeCreate'));
//        $show->field('Link', __('Link'));
        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new News());

        $form->text('Title', __('Tiêu đề'))->placeholder('Nhập tiêu đề bài viết')->required();
        $form->select('Type', 'Loại tin tức')->options([1 => 'Thông báo', 2 => 'Tin tức', 3 => 'Sự kiện'])->required();
        $form->ckeditor('Content')->options(['lang' => 'vn', 'height' => 450])->required();
        $form->hidden('TimeCreate', __('TimeCreate'))->value(Carbon::now()->timestamp)->required();
//        $form->setView('');
        return $form;
    }
}
