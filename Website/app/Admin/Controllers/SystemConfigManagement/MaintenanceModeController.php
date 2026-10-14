<?php

namespace App\Admin\Controllers\SystemConfigManagement;

use App\MaintenanceMode;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;

class MaintenanceModeController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Cài đặt IP bảo trì';

    protected $mode = [0 => 'Không dùng AntiDDOS', 1 => 'Dùng AntiDDOS'];

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new MaintenanceMode());

//        $grid->column('id', __('Id'));
        $grid->column('mode', __('Chế độ'))->editable('select', $this->mode);
        $grid->column('ip_whitelist', __('IP được phép truy cập'))->editable();
        $grid->column('owner_ip', __('Tên chủ IP'))->editable();
        $grid->column('ip_real_headers_param', __('Tiền tố để lấy IP gốc'));
//        $grid->column('created_at', __('Created at'));
//        $grid->column('updated_at', __('Updated at'));

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
        $show = new Show(MaintenanceMode::findOrFail($id));

        $show->field('id', __('Id'));
        $show->field('mode', __('Chế độ'));
        $show->field('ip_whitelist', __('Ip whitelist'));
        $show->field('owner_ip', __('Owner ip'));
        $show->field('ip_real_headers_param', __('Ip real headers param'));
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
        $form = new Form(new MaintenanceMode());
        $form->setTitle('Thêm IP Whitelist');
        $form->select('mode', __('Chế độ'))->options($this->mode)->default(1);
        $form->ip('ip_whitelist', 'IP cho phép');
        $form->text('owner_ip', __('Người sở hữu IP'));
        $form->text('ip_real_headers_param', __('Tiền tố để lấy IP gốc'))->default('x-real-ip')->help('Để trống nếu hiện tại không dùng antiddos.vn ');

        return $form;
    }
}
