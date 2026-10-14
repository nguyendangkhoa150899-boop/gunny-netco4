<?php

namespace App\Admin\Controllers\MemberManagement;

use App\LogCardCham;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;

class HistoryCardRecharge extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Lịch sử nạp thẻ cào (Người dùng tự nạp)';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new LogCardCham());

        $grid->model()->orderByDesc('Timer');
        $grid->column('UserName', __('Tài khoản'));
        $grid->column('NameCard', __('Loại thẻ cào'));
        $grid->column('Money', __('Giá trị thẻ'))->display(function ($value){
            return number_format($value, 0, ',','.').'đ';
        })->sortable();
        $grid->column('Seri', __('Số Seri'));
        $grid->column('Passcard', __('Mã thẻ'));
        $grid->column('Timer', __('Thời gian nạp'))->sortable()->filter('date');
        $grid->column('status', __('Trạng thái'))->display(function ($value){
            return $value;
        })->filter([
            0      => 'Đang xử lý',
            1      => 'Thành công',
            2      => 'Thất bại',
            3      => 'Sai mệnh giá'
        ]);

        $grid->disableCreateButton();
        $grid->disableActions();
        $grid->disableExport();

        $grid->disableFilter();
        $grid->quickSearch('Seri', 'Passcard', 'Timer', 'Username', 'NameCard');
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
        $show = new Show(LogCardCham::findOrFail($id));

        $show->field('UserName', __('UserName'));
        $show->field('NameCard', __('NameCard'));
        $show->field('Money', __('Money'));
        $show->field('Seri', __('Seri'));
        $show->field('Passcard', __('Passcard'));
        $show->field('Timer', __('Timer'));
        $show->field('Active', __('Active'));
        $show->field('Success', __('Success'));
        $show->field('TaskID', __('TaskID'));
        $show->field('status', __('Status'));

        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new LogCardCham());

        $form->text('UserName', __('UserName'));
        $form->text('NameCard', __('NameCard'));
        $form->number('Money', __('Money'));
        $form->text('Seri', __('Seri'));
        $form->text('Passcard', __('Passcard'));
        $form->text('Timer', __('Timer'));
        $form->switch('Active', __('Active'));
        $form->switch('Success', __('Success'));
        $form->number('status', __('Status'));

        return $form;
    }
}
