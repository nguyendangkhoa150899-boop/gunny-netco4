<?php

namespace App\Admin\Controllers\FusionManagement;

use App\ItemFusionList;
use App\ShopGoods;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;

class ItemFusionListController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Hiển thị tỉ lệ dung luyện';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new ItemFusionList());
        $grid->model()->orderByDesc('ID');

        $grid->column('ID', __('ID'))->width(45);
        $grid->column('_ImageItem_', 'Ảnh vật phẩm')->display(function (){
            return $this->Item->ResourceImageColumn();
        });
        $grid->column('TemplateID', 'Vật phẩm')->display(function (){
            return $this->Item->Name;
        });
        $grid->column('Show', '% Hiển thị trong game')->editable();
        $grid->column('Real', __('% Thực tế'))->editable();

        $grid->expandFilter();
        $grid->filter(function($filter){
            $filter->disableIdFilter();
            $filter->equal('TemplateID', 'Tìm kiếm vật phẩm')->select()->ajax('/admin/api/load-item');
        });


        $grid->quickCreate(function ($create) {
            $create->select('TemplateID', 'Chọn vật phẩm')->ajax('/admin/api/load-item');
            $create->integer('Show','% Hiển thị');
            $create->integer('Real','% Thực tế');
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
        $show = new Show(ItemFusionList::findOrFail($id));

        $show->field('ID', __('ID'));
        $show->field('TemplateID', __('TemplateID'));
        $show->field('Show', __('Show'));
        $show->field('Real', __('Real'));

        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new ItemFusionList());

        $form->select('TemplateID', 'Chọn vật phẩm')
            ->options(function ($templateID){
                $shopGoods = ShopGoods::find($templateID);
                if($shopGoods){
                    return [$shopGoods->TemplateID => $shopGoods->Name];
                }
            })->ajax('/admin/api/load-item')->required();
        $form->number('Show', '% Hiển thị')->width('100%')->default(0)->required(true);
        $form->number('Real', __('% Thực tế'))->width('100%')->default(0)->required(true);
        $form->disableEditingCheck();
        return $form;
    }
}
