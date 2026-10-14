<?php

namespace App\Admin\Controllers\ShopGoodsManagement;

use App\ShopGoodsCategory;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;
use Illuminate\Support\Facades\Auth;

class ShopGoodsCategoryController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'ShopGoodsCategory';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $shopGoodCategory = new ShopGoodsCategory();
        $shopGoodCategory->setConnection($currentTank);

        $grid = new Grid($shopGoodCategory);

        $grid->column('ID', __('ID'));
        $grid->column('Name', __('Name'));
        $grid->column('Place', __('Place'));
        $grid->column('Remark', __('Remark'));

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
        $show = new Show(ShopGoodsCategory::on($currentTank)->findOrFail($id));

        $show->field('ID', __('ID'));
        $show->field('Name', __('Name'));
        $show->field('Place', __('Place'));
        $show->field('Remark', __('Remark'));

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
        $shopGoodCategory = new ShopGoodsCategory();
        $shopGoodCategory->setConnection($currentTank);

        $form = new Form($shopGoodCategory);

        $form->text('Name', __('Name'));
        $form->number('Place', __('Place'));
        $form->text('Remark', __('Remark'));

        return $form;
    }
}
