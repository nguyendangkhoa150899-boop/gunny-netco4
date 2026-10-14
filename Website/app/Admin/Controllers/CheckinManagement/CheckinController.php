<?php

namespace App\Admin\Controllers\CheckinManagement;

use App\CheckinGoods;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;
use Illuminate\Http\Request;

class CheckinController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Đăng nhập nhận thưởng';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
//        $e = EventAwardCompete::with(['EventCompete'])->get();
//        dd($e);
        $grid = new Grid(new CheckinGoods());

        $grid->column('Time', __('Lần'));
        $grid->column('_ImageItem_', __('Hình ảnh'))->display(function (){
            return $this->ResourceImageColumn();
        });
        $grid->column('Item.Name', __('Tên vật phẩm'));
        $grid->column('Count', __('Số lượng'));
        $grid->column('ValidDate', __('Hạn'));
        $grid->column('StrengthenLevel', __('Cường hoá'));
        $grid->column('composes', __('Chỉ số'))->display(function (){
            return $this->combine4Column();
        });
        $grid->column('Coin', __('Coin'));
        $grid->column('IsBind', __('Khóa'));
        $grid->column('Status', __('Trạng thái'));

//        $grid->disableCreateButton();

//        $grid->quickCreate(function (Grid\Tools\QuickCreate $create){
//            $create->select('item_id','Vật phẩm')->ajax('/admin/api/load-item');
//            $create->text('amount','Số lượng');
//            $create->text('date','Hạn');
//            $create->text('strengthen','Cường hoá');
//            $create->text('composes','Chỉ số');
//        });
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
        $show = new Show(CheckinGoods::findOrFail($id));

        $show->field('Time', __('Lần'));
        $show->field('ItemID', __('Item id'));
        $show->field('Count', __('Số lượng'));
        $show->field('ValidDate', __('Date'));
        $show->field('StrengthenLevel', __('Strengthen'));
        $show->field('AttackCompose', __('AttackCompose'));
        $show->field('DefendCompose', __('DefendCompose'));
        $show->field('LuckCompose', __('LuckCompose'));
        $show->field('AgilityCompose', __('AgilityCompose'));
        $show->field('IsBind', __('Khóa'));
        $show->field('Coin', __('Coin'));
        $show->field('Status', __('Status'));

        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new CheckinGoods());

        $form->number('Time', __('Lần'));
        $form->select('ItemID', __('Vật phẩm'))->ajax('/admin/api/load-item');
        $form->number('Count', __('Số lượng'))->width('100%')->placeholder('Số lượng vật phẩm');
        $form->number('ValidDate', __('Hạn'))->width('100%')->placeholder('Thời hạn dùng (0 => Vĩnh viễn)');
        $form->number('StrengthenLevel', __('Cường hoá'))->width('100%')->placeholder('Cường hoá: (VD: 12)');
        $form->number('AttackCompose', __('Tấn công'))->width('100%')->placeholder('Chỉ số (VD: 50)');
        $form->number('DefendCompose', __('Phòng thủ'))->width('100%')->placeholder('Chỉ số (VD: 50)');
        $form->number('LuckCompose', __('May mắn'))->width('100%')->placeholder('Chỉ số (VD: 50)');
        $form->number('AgilityCompose', __('Nhanh nhẹn'))->width('100%')->placeholder('Chỉ số (VD: 50)');
        $form->number('Coin', __('Coin'))->width('100%');
        $form->switch('IsBind', __('Khóa'));
        $form->switch('Status', __('Kích hoạt'));

        return $form;
    }
}
