<?php

namespace App\Admin\Controllers\MemberManagement;

use App\CoinLog;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;

class HistoryStaffRecharge extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Lịch sử nạp (Admin)';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new CoinLog());
        $grid->model()->orderByDesc('created_at');

        $grid->column('MemberUserName', __('Tài khoản nạp'))->filter('like')->sortable();
        $grid->column('admin.name', __('Người thực hiện'));
        $grid->column('Bonus', __('Khuyến mãi'))->display(function ($value){
            return number_format($value,0,',', '.').'đ';
        })->sortable();
        $grid->column('Value',__('Giá trị'))->display(function ($value){
            return number_format($value,0,',', '.').'đ';
        })->sortable();
        $grid->column('Description', __('Nội dung'));
        $grid->column('created_at', __('Thời gian'))->sortable()->filter('date');

        $grid->disableCreateButton();
        $grid->disableActions();
        $grid->disableFilter();


        $grid->quickSearch( function($model, $query){
           $model->whereHas('admin', function ($q) use ($query){
               $q->where("name", 'like', '%'.$query.'%');
           })->orWhere('MemberUserName', 'like', "%{$query}%")
               ->orWhere('Value', 'like', "%{$query}%");
        });
        $grid->disableBatchActions();
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
        $show = new Show(CoinLog::findOrFail($id));

        $show->field('id', __('Id'));
        $show->field('MemberID', __('MemberID'));
        $show->field('UserID', __('UserID'));
        $show->field('Bonus', __('Bonus'));
        $show->field('Value', __('Value'));
        $show->field('Description', __('Description'));
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
        $form = new Form(new CoinLog());

        $form->text('MemberID', __('MemberID'));
        $form->text('UserID', __('UserID'));
        $form->number('Bonus', __('Bonus'));
        $form->number('Value', __('Value'));
        $form->text('Description', __('Description'));

        return $form;
    }
}
