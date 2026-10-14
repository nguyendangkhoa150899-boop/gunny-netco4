<?php

namespace App\Admin\Controllers;

use App\LoginAwardItemTemplate;
use App\ShopGoods;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;
use Illuminate\Support\Facades\Auth;

class Login7DaysAwardItem extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Quà 7 ngày đăng nhập';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new LoginAwardItemTemplate());

        $days = []; for($i = 1; $i <= 7; $i++){$days[$i]='Ngày '.$i;}

        $grid->column('ID', __('ID'));
        $grid->column('Count', __('Ngày'));
        $grid->column('RewardItemID', __('RewardItemID'));
        $grid->column('ItemImage', __('Hình ảnh'))->display(function (){
            return $this->Reward->ResourceImageColumn();
        });
        $grid->column('Item', __('Vật phẩm'))->display(function (){
            return $this->Reward->Name;
        });
        $grid->column('IsSelect', __('Chỉ nhận 1 vật phẩm'))->display(function ($isSelect){
            switch ($isSelect){
                case 0:
                    return '<span class="badge btn-success">Nhận tất cả</span>';
                case 1:
                    return '<span class="badge btn-danger">Chọn vật phẩm</span>';
            }
        });
        $grid->column('IsBind', __('Khoá'))->display(function ($isBind){
            switch ($isBind){
                case 0:
                    return '<span class="badge btn-success">Không khoá</span>';
                case 1:
                    return '<span class="badge btn-danger">Khoá</span>';
            }
        });
        $grid->column('RewardItemValid', __('Hạn'))->editable();
        $grid->column('RewardItemCount', __('Số lượng'))->editable();
        $grid->column('StrengthenLevel', __('Cường hoá'))->editable();
        $grid->column('AttackCompose', __('HT Tấn công'))->editable();
        $grid->column('DefendCompose', __('HT Phòng thủ'))->editable();
        $grid->column('AgilityCompose', __('HT Nhanh nhẹn'))->editable();
        $grid->column('LuckCompose', __('HT May mắn'))->editable();

        $grid->expandFilter();
        $grid->filter(function($filter) use ($days){
            $filter->disableIdFilter();
            $filter->equal('Count', 'Chọn ngày')->select($days);
            $filter->equal('RewardItemID', 'Tìm kiếm vật phẩm')->select()->ajax('/admin/api/load-item');
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
        $show = new Show(LoginAwardItemTemplate::findOrFail($id));

        $show->field('ID', __('ID'));
        $show->field('Count', __('Count'));
        $show->field('RewardItemID', __('RewardItemID'));
        $show->field('IsSelect', __('IsSelect'));
        $show->field('IsBind', __('IsBind'));
        $show->field('RewardItemValid', __('RewardItemValid'));
        $show->field('RewardItemCount', __('RewardItemCount'));
        $show->field('StrengthenLevel', __('StrengthenLevel'));
        $show->field('AttackCompose', __('AttackCompose'));
        $show->field('DefendCompose', __('DefendCompose'));
        $show->field('AgilityCompose', __('AgilityCompose'));
        $show->field('LuckCompose', __('LuckCompose'));

        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new LoginAwardItemTemplate());
        $currentTank = Auth::guard('admin')->user()->current_tank;

        $newId = (int) LoginAwardItemTemplate::max('ID');
        $newId += 1;
        $days = []; for($i = 1; $i <= 7; $i++){$days[$i]='Ngày '.$i;}

//        $form->number('ID');
        if($form->isCreating())
            $form->number('ID', __('ID'))
                ->value($newId)
                ->width('100%')
                ->help('ID không được trùng')
                ->rules('required|unique:'.$currentTank.'.Login_Award_Item_Template', ['unique'=>'ID đã được sử dụng']);
        else
            $form->number('ID', __('ID'))->width('100%')->help('ID không được trùng');
        $form->select('RewardItemID', 'Chọn vật phẩm')
            ->options(function ($templateID){
                $shopGoods = ShopGoods::find($templateID);
                if($shopGoods){
                    return [$shopGoods->TemplateID => $shopGoods->Name];
                }
            })->ajax('/admin/api/load-item')->required();
        $form->select('Count', __('Ngày nhận'))->width('100%')->options($days)->required();
        $form->switch('IsSelect', __('IsSelect'))->width('100%')->default(0);
        $form->switch('IsBind', __('Khoá'))->width('100%')->default(1)->readonly();
        $form->number('RewardItemValid', __('Hạn'))->width('100%')->default(0)->required(true);
        $form->number('RewardItemCount', __('Số lượng'))->width('100%')->default(1)->required(true);
        $form->number('StrengthenLevel', __('Cường hoá'))->width('100%')->default(0)->required(true);
        $form->number('AttackCompose', __('HT Tấn công'))->width('100%')->default(0)->required(true);
        $form->number('DefendCompose', __('HT Phòng thủ'))->width('100%')->default(0)->required(true);
        $form->number('AgilityCompose', __('HT Nhanh nhẹn'))->width('100%')->default(0)->required(true);
        $form->number('LuckCompose', __('HT May mắn'))->width('100%')->default(0)->required(true);
        $form->disableEditingCheck();
        return $form;
    }
}
