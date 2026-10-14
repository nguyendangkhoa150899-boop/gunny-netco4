<?php

namespace App\Admin\Controllers\ActiveManagement;

use App\Active;
use App\ActiveAward;
use App\Admin\Extensions\Tools\QuickInsertActiveAward;
use App\ShopGoods;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ActiveAwardController extends AdminController
{
    protected $currentTank = "x";
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Danh sách tất cả phần thưởng hoạt động (Giftcode)';


    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {

        $currentTank = Auth::guard('admin')->user()->current_tank;
        $activeAward = new ActiveAward();
        $activeAward->setConnection($currentTank);

        $req = Request::capture();
        $activeID = $req->input('ActiveID');
        $actives = Active::on($currentTank)->get();
        $valuesActive = [];
        foreach ($actives as $active) {
            $valuesActive[$active->ActiveID] = $active->Title . ' - (ID = '.$active->ActiveID.')';
        }

        $grid = new Grid($activeAward);
        $grid->setTitle('['.$currentTank.']');



        $grid->column('ActiveID','GiftCode ID');
        $grid->column('image', __('Hình ảnh'))->display(function (){
            return $this->ResourceImageColumn();
        });
        $grid->column('Item.Name','Vật phẩm');
        $grid->column('Count', 'Số lượng')->editable();
        $grid->column('ValidDate', 'ValidDate')->editable();
        $grid->column('StrengthenLevel', 'Cường hoá')->editable();
        $grid->column('AttackCompose', 'Tấn công')->editable();
        $grid->column('DefendCompose', 'Phòng thủ')->editable();
        $grid->column('LuckCompose', 'May mắn')->editable();
        $grid->column('AgilityCompose', 'Nhanh nhẹn')->editable();
        $grid->column('Gold', 'Vàng')->editable();
        $grid->column('Money', 'Xu')->editable();
        $grid->column('Sex', 'Giới tính')->editable();
        $grid->column('Mark', 'Mark')->editable();

        $grid->expandFilter();
        $grid->disableCreateButton();
        $grid->filter(function ($filter) use ($valuesActive){
            $filter->disableIdFilter();
            $filter->equal('ActiveID', 'Lựa chọn hoạt động (Giftcode)')->select($valuesActive);
        });

        $grid->quickCreate(function (Grid\Tools\QuickCreate $create) use ($valuesActive, $activeID, $currentTank){

            $create->select('ActiveID', 'Chọn hoạt động')->default($activeID != null || $activeID != "" ? $activeID : null)->options($valuesActive);

            $create->select('ItemID', 'Chọn vật phẩm')
                ->options(function ($templateID) use($currentTank){
                    $shopGoods = ShopGoods::on($currentTank)->find($templateID);
                    if($shopGoods){
                        return [$shopGoods->TemplateID => $shopGoods->Name];
                    }
                })->ajax('/admin/api/load-item');
//            $create->integer('ValidDate', 'ValidDate')->default(0);
//            $create->integer('StrengthenLevel', 'StrengthenLevel')->default(0);
//            $create->integer('AttackCompose', 'AttackCompose')->default(0);
//            $create->integer('DefendCompose', 'DefendCompose')->default(0);
//            $create->integer('LuckCompose', 'LuckCompose')->default(0);
//            $create->integer('AgilityCompose', 'AgilityCompose')->default(0);
//            $create->integer('Gold', 'Gold')->default(0);
//            $create->integer('Money', 'Money')->default(0);
            $create->Select('Sex', 'Giới tính')->options([0=> 'Cả 2', 1 => 'Nam', 'Nữ'])->value(0);
            $create->integer('Count', 'Số lượng')->required();
//            $create->integer('Mark', 'Mark')->default(0);
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
        //Set on connection Tank
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $show = new Show(ActiveAward::on($currentTank)->findOrFail($id));

        $show->field('ID', __('ID'));
        $show->field('ActiveID', __('ActiveID'));
        $show->field('ItemID', __('ItemID'));
        $show->field('Count', __('Count'));
        $show->field('ValidDate', __('ValidDate'));
        $show->field('StrengthenLevel', __('StrengthenLevel'));
        $show->field('AttackCompose', __('AttackCompose'));
        $show->field('DefendCompose', __('DefendCompose'));
        $show->field('LuckCompose', __('LuckCompose'));
        $show->field('AgilityCompose', __('AgilityCompose'));
        $show->field('Gold', __('Gold'));
        $show->field('Money', __('Money'));
        $show->field('Sex', __('Sex'));
        $show->field('Mark', __('Mark'));

        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        //Set on connection Tank
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $activeAward = new ActiveAward();
        $activeAward->setConnection($currentTank);

        $form = new Form($activeAward);

        $form->number('ActiveID', __('ActiveID'));
        $form->select('ItemID', __('ItemID'))->options(function ($templateID) use ($currentTank){
            $shopGoods = ShopGoods::on($currentTank)->find($templateID);
            if($shopGoods){
                return [$shopGoods->TemplateID => $shopGoods->Name];
            }
        })->ajax('/admin/api/load-item');
        $form->number('Count', __('Count'))->default(1);
        $form->number('ValidDate', __('ValidDate'));
        $form->number('StrengthenLevel', __('StrengthenLevel'));
        $form->number('AttackCompose', __('AttackCompose'));
        $form->number('DefendCompose', __('DefendCompose'));
        $form->number('LuckCompose', __('LuckCompose'));
        $form->number('AgilityCompose', __('AgilityCompose'));
        $form->number('Gold', __('Gold'));
        $form->number('Money', __('Money'));
        $form->number('Sex', __('Sex'));
        $form->select('Sex', __('Sex'))->options([ 0=> 'Cả 2', 1 => 'Nam', 'Nữ']);
        $form->number('Mark', __('Mark'));

        return $form;
    }
}
