<?php

namespace App\Admin\Controllers\MissionManagement;

use App\DropCondiction;
use App\DropItem;
use App\MissionInfo;
use App\ShopGoods;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;
use Illuminate\Support\Facades\Auth;

class DropItemController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'DropItem';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $dropItem = new DropItem();
        $dropItem->setConnection($currentTank);

        $dropCondiction = DropCondiction::on($currentTank)->get();
        $missionInfo = MissionInfo::on($currentTank)->select('Id','Name')->get();
        $grid = new Grid($dropItem);
        $grid->model()->with('DropCondiction');

        $grid->column('Id', __('Id'));
        $grid->column('DropId', 'DropId')->sortable();
        $grid->column('_Para1_','Para1')->display(function () use ($dropCondiction, $missionInfo){
            $para1 = null;
            //Get all para1
            foreach ($dropCondiction as $drop){
                if($drop->DropID == $this->DropId)
                    $para1 = $drop->Para1;
            }

            $missions = [];

            if($para1){
                $param1 = ltrim($para1, ','); $param1 = rtrim($para1, ',');
                $missions = explode(",",$param1);
            }

            $returnText = null;

            foreach ($missionInfo as $mission){
                if(in_array($mission->Id, $missions)){
                    $returnText .= 'Para1: <b>'.$para1.'</b><br>'.$mission->Name.'<br>';
                }
            }
            return $returnText;

        });
        $grid->column('ItemId','TemplateID');
        $grid->column('_Image_', 'Hình ảnh')->display(function (){
            return $this->ResourceImageColumn();
        });
        $grid->column('_ItemId_', __('Vật phẩm'))->display(function (){
            return $this->Item->Name .' - '.$this->Item->combine4Column();
        });
        $grid->column('ValueDate', __('Hạn dùng'))->display(function ($ValueDate){
            if($ValueDate == 0)
                return 'Vĩnh viễn';
            return $ValueDate.' ngày';
        });
        $grid->column('IsBind', __('Khoá'))->display(function ($IsBind){
            if((int) $IsBind == 0)
                return '<span class="badge btn-success">Không khoá</span>';
            return '<span class="badge btn-danger">Khoá</span>';

        });
        $grid->column('Random', __('Random'));
        $grid->column('BeginData', __('BeginData'));
        $grid->column('EndData', __('EndData'));
//        $grid->column('IsTips', __('IsTips'));
//        $grid->column('IsLogs', __('IsLogs'));
        $grid->quickCreate(function ($create){
            $create->text('DropId')->required();
            $create->select('ItemId')->options()->ajax('/admin/api/load-item');
            $create->text('ValueDate','Hạn')->required();
            $create->text('IsBind','Khoá')->required();
            $create->text('Random','Random')->required();
            $create->text('BeginData','BeginData')->required();
            $create->text('EndData','EndData')->required();
        });

        $grid->expandFilter();
        $grid->filter(function($filter){
            $filter->disableIdFilter();
            $filter->equal('DropId','Loc theo DropId')->integer();

        });
//        $grid->filter(function($filter){
//            $filter->disableIdFilter();
//            $filter->equal('DropId','Tìm kiếm ải phó bản')->select()->ajax('/admin/api/get-mission-info-for-drop');
//
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
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $show = new Show(DropItem::on($currentTank)->findOrFail($id));

        $show->field('Id', __('Id'));
        $show->field('DropId', __('DropId'));
        $show->field('ItemId', __('ItemId'));
        $show->field('ValueDate', __('ValueDate'));
        $show->field('IsBind', __('IsBind'));
        $show->field('Random', __('Random'));
        $show->field('BeginData', __('BeginData'));
        $show->field('EndData', __('EndData'));
        $show->field('IsTips', __('IsTips'));
        $show->field('IsLogs', __('IsLogs'));

        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $dropItem = new DropItem();
        $dropItem->setConnection($currentTank);
        $form = new Form($dropItem);

        $form->number('DropId', __('DropId'))->required();
//        $form->number('ItemId', __('ItemId'));
        $form->select('ItemId', 'Chọn vật phẩm')
            ->options(function ($templateID) use ($currentTank){
                $shopGoods = ShopGoods::on($currentTank)->find($templateID);
                if($shopGoods){
                    return [$shopGoods->TemplateID => $shopGoods->Name];
                }
            })->ajax('/admin/api/load-item');
        $form->number('ValueDate', __('Hạn dùng'))->default(0)->required();
        $form->switch('IsBind', __('Khoá'))->default(0);
        $form->number('Random', __('Random'))->default(0)->required();
        $form->number('BeginData', __('BeginData'))->default(0)->required();
        $form->number('EndData', __('EndData'))->default(0)->required();
        $form->switch('IsTips', __('IsTips'));
        $form->switch('IsLogs', __('IsLogs'));

        return $form;
    }

}
