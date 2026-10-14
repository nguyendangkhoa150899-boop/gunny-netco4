<?php

namespace App\Admin\Controllers\MemberManagement;

use App\MemberHistory;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;

class MemberHistoryController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Lịch sử đổi coin';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new MemberHistory());
        $grid->model()->orderByDesc('ID');

        $grid->column('ID', __('ID'));
//        $grid->column('UserID', 'UserID');
        $grid->column('_UserName_','Tài khoản')->display(function (){
            if($this->Member != null)
                return $this->Member->Email;
            return '<span style="color: red;font-weight: bold">Không xác định</span>';
        });

        $grid->column('Type', __('Loại'))->filter(['Chuyển xu'=>'Chuyển xu', 'Đổi tên' => 'Đổi tên']);
//        $grid->column('TypeCode', __('TypeCode'));
        $grid->column('Content', __('Nội dung'));
        $grid->column('Value', __('Giá trị'))->display(function ($value){
            return number_format($value, 0,',','.');
        })->filter()->sortable();
        $grid->column('TimeCreate', __('Thời gian'))->display(function ($timeCreate){
            return date('H:i d-m-Y', $timeCreate);
        });
        $grid->column('IPCreate', __('IP'))->filter();

        $grid->disableCreateButton();
        $grid->disableBatchActions();
        $grid->disableActions();

        $grid->expandFilter();
        $grid->filter(function ($filter){
            $filter->disableIdFilter();
            $filter->equal('UserID', 'Tìm tài khoản')->select()->ajax('/admin/api/get-list-member');

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
        $show = new Show(MemberHistory::findOrFail($id));

        $show->field('ID', __('ID'));
        $show->field('UserID', __('UserID'));
        $show->field('Type', __('Type'));
        $show->field('TypeCode', __('TypeCode'));
        $show->field('Content', __('Content'));
        $show->field('Value', __('Value'));
        $show->field('TimeCreate', __('TimeCreate'));
        $show->field('IPCreate', __('IPCreate'));

        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new MemberHistory());

        $form->number('UserID', __('UserID'));
        $form->text('Type', __('Type'));
        $form->number('TypeCode', __('TypeCode'));
        $form->text('Content', __('Content'));
        $form->number('Value', __('Value'));
        $form->number('TimeCreate', __('TimeCreate'));
        $form->text('IPCreate', __('IPCreate'));

        return $form;
    }
}
