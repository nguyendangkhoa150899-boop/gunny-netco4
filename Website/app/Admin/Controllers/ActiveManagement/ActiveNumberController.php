<?php

namespace App\Admin\Controllers\ActiveManagement;

use App\Active;
use App\ActiveNumber;
use App\ServerList;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;
use Illuminate\Support\Facades\Auth;

class ActiveNumberController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Quản lý mã GiftCode';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $actives = Active::on($currentTank)->get();
        $server = ServerList::where('TankConnection', $currentTank)->firstOrFail();
        $serverConnection = $server->Connection;

        $activeNumber = new ActiveNumber();
        $activeNumber->setConnection($serverConnection);

        $grid = new Grid($activeNumber);
        $grid->model()->where('PullDown', '=','0');

        $grid->column('AwardID', __('Mã GiftCode'))->filter();
        $grid->column('ActiveID', __('Sự kiện'))->display(function ($activeID) use ($actives){
            foreach ($actives as $active){
                if($activeID == $active->ActiveID)
                    return $active->Title;
            }
            return 'Không xác định';
        });
        $grid->column('PullDown', __('Trạng thái'))->display(function ($pullDown){
            return $pullDown == 1 ? '<span class="badge btn-danger">Đã sử dụng</span>' : '<span class="badge btn-success">Chưa sử dụng</span>';
        })->filter([ 0 => 'Chưa sử dụng',1 => 'Đã sử dụng']);
        $grid->column('GetDate', __('Ngày tạo/Ngày dùng'))->display(function ($originDate){
            return date("H:i d-m-Y", strtotime($originDate));
        })->filter('date');
//        $grid->column('UserID', __('UserID'));
//        $grid->column('Mark', __('Mark'));
//        $grid->column('Creator', __('Creator'));
        $grid->quickSearch('AwardID');
        $grid->disableCreateButton();

        $grid->expandFilter();
        $grid->filter(function ($filter) use($actives){
            $acticeValues = [];
            foreach ($actives as $active){ $acticeValues[$active->ActiveID] = $active->Title; }
            $filter->equal('ActiveID','Tìm kiếm sự kiện')->select($acticeValues);
            $filter->disableIdFilter();
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
        $show = new Show(ActiveNumber::findOrFail($id));

        $show->field('AwardID', __('AwardID'));
        $show->field('ActiveID', __('ActiveID'));
        $show->field('PullDown', __('PullDown'));
        $show->field('GetDate', __('GetDate'));
        $show->field('UserID', __('UserID'));
        $show->field('Mark', __('Mark'));
        $show->field('Creator', __('Creator'));

        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new ActiveNumber());

        $form->number('ActiveID', __('ActiveID'));
        $form->switch('PullDown', __('PullDown'));
        $form->datetime('GetDate', __('GetDate'))->default(date('Y-m-d H:i:s'));
        $form->number('UserID', __('UserID'));
        $form->number('Mark', __('Mark'));
        $form->number('Creator', __('Creator'));

        return $form;
    }
}
