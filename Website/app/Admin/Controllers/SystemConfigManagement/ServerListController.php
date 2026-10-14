<?php

namespace App\Admin\Controllers\SystemConfigManagement;

use App\Admin\Extensions\Tools\ClearServerListCacheTool;
use App\ServerList;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;

class ServerListController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Cấu hình máy chủ game (Sau khi chỉnh sửa xong phải Xoá Cache)';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new ServerList());

        $grid->column('ServerID', __('ServerID'))->editable();
        $grid->column('Status', __('Trạng thái'))->editable('select', [0 => 'Bảo trì', 1 => 'Hoạt động', 2 => 'Sắp ra mắt']);
        $grid->column('ServerName', __('Tên Server'))->editable();
        $grid->column('Host', __('Host'))->editable();
        $grid->column('Username', __('Username'))->editable();
        $grid->column('Password', __('Password'))->editable();
        $grid->column('Database', __('Database'))->editable();
        $grid->column('Connection', __('Connection'))->editable();
        $grid->column('LinkCenter', __('LinkCenter'))->editable();
        $grid->column('LinkRequest', __('LinkRequest'))->editable();
        $grid->column('LinkConfig', __('LinkConfig'))->editable();

        $grid->tools(function ($tools){
            $tools->append(new ClearServerListCacheTool());
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
        $show = new Show(ServerList::findOrFail($id));

        $show->field('ServerID', __('ServerID'));
        $show->field('ServerName', __('ServerName'));
        $show->field('Host', __('Host'));
        $show->field('Username', __('Username'));
        $show->field('Password', __('Password'));
        $show->field('Database', __('Database'));
        $show->field('Connection', __('Connection'));
        $show->field('LinkCenter', __('LinkCenter'));
        $show->field('LinkRequest', __('LinkRequest'));
        $show->field('LinkConfig', __('LinkConfig'));

        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new ServerList());

        $form->text('ServerName', __('ServerName'));
        $form->select('Status')->options([0 => 'Bảo trì', 1 => 'Hoạt động', 2 => 'Sắp ra mắt']);
        $form->text('Host', __('Host'));
        $form->text('Username', __('Username'));
        $form->password('Password', __('Password'));
        $form->text('Database', __('Database'));
        $form->text('Connection', __('Connection'));
        $form->text('LinkCenter', __('LinkCenter'));
        $form->text('LinkRequest', __('LinkRequest'));
        $form->text('LinkConfig', __('LinkConfig'));

        return $form;
    }
}
