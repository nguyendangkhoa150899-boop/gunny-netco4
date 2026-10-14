<?php

namespace App\Admin\Controllers\MissionManagement;

use App\DropCondiction;
use App\MissionInfo;
use Encore\Admin\Admin;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Form\NestedForm;
use Encore\Admin\Grid;
use Encore\Admin\Grid\Tools\QuickCreate;
use Encore\Admin\Show;
use Illuminate\Support\Facades\Auth;

class DropConditionController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Thiết lập phó bản rơi đồ (DropCondiction)';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $dropCondictionModel = new DropCondiction();
        $dropCondictionModel->setConnection($currentTank);

        $dropCondiction = DropCondiction::on($currentTank)->get();
        $missionInfo = MissionInfo::on($currentTank)->get();

        $grid = new Grid($dropCondictionModel);

        $grid->column('DropID', __('DropID'))->sortable()->filter();
        $grid->column('CondictionType', __('CondictionType'))->editable()->filter([ 5 => 'Phó bản']);
        $grid->column('_PhoBan)','Phó bản (Sau khi chỉnh sửa trực tiếp, F5 để hiện lại tên PB)')->display(function () use ($missionInfo){
            $missions = [];
            $para1 = $this->Para1;
            if($para1){
                $param1 = ltrim($para1, ','); $param1 = rtrim($para1, ',');
                $missions = explode(",",$param1);
            }

            $returnText = null;

            foreach ($missionInfo as $mission){
                if(in_array($mission->Id, $missions)){
                    $returnText .= $mission->Name.'<br>';
                }
            }
            return $returnText;
        });
        $grid->column('Para1', 'Para1')->sortable()->editable();
        $grid->column('Para2', __('Para2'))->sortable()->editable();

        $grid->quickCreate(function ( QuickCreate $create){
            $create->text('DropID', 'DropID');
            $create->select('CondictionType', 'CondictionType')->options( [5=> 'Loại phó bản'] )->default(5)->required();
            $create->text('Para1', 'Para1')->required();
            $create->text('Para2', 'Para2')->required();
        });

        $grid->expandFilter();
        $grid->filter(function($filter){
            $filter->disableIdFilter();
            $filter->equal('DropId','Tìm kiếm điều kiện phó bản đã tồn tại')->select()->ajax('/admin/api/get-mission-info-for-drop');

        });
//        Admin::script('$(".submit").hide();');



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
        $show = new Show(DropCondiction::on($currentTank)->findOrFail($id));

        $show->field('DropID', __('DropID'));
        $show->field('CondictionType', __('CondictionType'));
        $show->field('Para1', __('Para1'));
        $show->field('Para2', __('Para2'));
        $show->field('Detail', __('Detail'));

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
        $dropCondictionModel = new DropCondiction();
        $dropCondictionModel->setConnection($currentTank);
        $form = new Form(new $dropCondictionModel);

        $form->number('DropID', __('DropID'));
        $form->number('CondictionType', __('CondictionType'));
        $form->text('Para1', __('Para1'));
        $form->text('Para2', __('Para2'));
        $form->text('Detail', __('Detail'));

//        // Subtable fields
//        $form->hasMany('DropItem', function (NestedForm $form) {
//            $form->text('ItemId');
//            $form->text('Random');
//            $form->text('IsBind');
//        });
        return $form;
    }
}
