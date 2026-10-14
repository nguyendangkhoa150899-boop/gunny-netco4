<?php

namespace App\Admin\Controllers\ShopBoxManagement;

use App\Admin\Actions\ShopGoodsBox\DeleteShopGoodsBoxItemAction;
use App\ShopGoods;
use App\ShopGoodsBox;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;

class ShopGoodsBoxController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Quản lý rương & vật phẩm rương';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $shopGoodsBox = new ShopGoodsBox();
        $shopGoodsBox->setPrimaryKey('fake');

        $grid = new Grid($shopGoodsBox);
        $grid->model()->orderByDesc("ID");

        $grid->column('ID', __('ID Rương'));
        $grid->column('_ImageBox_', 'Ảnh Rương')->display(function (){
            return $this->ResourceImageColumnForId();
        });
        $grid->column('_BoxItemId_','Rương')->display(function (){
            if($this->BoxItem != null){
                return $this->BoxItem->Name;
            }
            return 'Không có rương';
        });

        $grid->column('_Image_', 'Hình ảnh')->display(function (){
            if($this->ResourceImageColumn() != null){
                return $this->ResourceImageColumn();
            }
            return 'Không tồn tại vật phẩm';
        });
        $grid->column('TemplateId', 'Vật phẩm')->display(function (){
            if($this->Item->Name){
                return $this->Item->Name;
            }
            return 'Chưa xác định';
        });

        $grid->column('IsSelect', __('Kiểu nhận'))->help('0 => Nhận random | 1 => Nhận toàn bộ')->display(function ($isSelect){
            return $isSelect == 1 ? '<span class="badge btn-info">Nhận toàn bộ</span>' : '<span class="badge btn-primary">Nhận ngẫu nhiên</span>';
        });
        $grid->column('IsBind', __('Khoá'))->display(function ($isBind){
            return $isBind == 1 ? '<span class="badge btn-danger">Khoá</span>' : '<span class="badge btn-success">Không khoá</span>';
        });
        $grid->column('ItemValid', __('Hạn'));
        $grid->column('ItemCount', __('Số lượng'));
        $grid->column('StrengthenLevel', __('Cường hoá'));
        $grid->column('AttackCompose', __('HT Tấn công'));
        $grid->column('DefendCompose', __('HT Phòng thủ'));
        $grid->column('AgilityCompose', __('HT Nhanh nhẹn'));
        $grid->column('LuckCompose', __('HT May mắn'));
        $grid->column('Random', __('Random'));
//        $grid->column('IsTips', __('IsTips'));
//        $grid->column('IsLogs', __('IsLogs'));


        $grid->actions(function ($actions){
            $actions->disableDelete();
            $actions->disableEdit();
            $actions->add(new DeleteShopGoodsBoxItemAction());

        });

        $grid->expandFilter();

        $grid->filter(function ($filter){
            $filter->disableIdFilter();
            $filter->equal('ID', 'Tìm kiếm rương')->select(['key'=>'value'])->ajax('api/load-item');
            $filter->equal('TemplateId', 'Tìm kiếm vật phẩm')->select(['key'=>'value'])->ajax('api/load-item');
        });

        $grid->quickCreate(function (Grid\Tools\QuickCreate $create) {

            $create->select('ID', 'Chọn rương')
                ->options(function ($templateID){
                    $shopGoods = ShopGoods::find($templateID);
                    if($shopGoods){
                        return [$shopGoods->TemplateID => $shopGoods->Name];
                    }
                })->ajax('/admin/api/load-item');
            $create->select('TemplateId', 'Chọn vật phẩm')
                ->options(function ($templateID){
                    $shopGoods = ShopGoods::find($templateID);
                    if($shopGoods){
                        return [$shopGoods->TemplateID => $shopGoods->Name];
                    }
                })->ajax('/admin/api/load-item');
            $create->select('IsSelect', 'Kiểu nhận')->options([0=>'Nhận ngẫu nhiên', 1=> 'Nhận tất cả']);
            $create->select('IsBind', 'Khoá')->options([0=>'Không khoá', 1=> 'Khoá'])->default(1);
            $create->text('ItemCount', 'Số lượng');
            $create->text('Random', 'Random');

            $create->text('StrengthenLevel', __('StrengthenLevel'))->default(0)->style('display','none');
            $create->text('AttackCompose', __('AttackCompose'))->default(0)->style('display','none');
            $create->text('DefendCompose', __('DefendCompose'))->default(0)->style('display','none');
            $create->text('AgilityCompose', __('AgilityCompose'))->default(0)->style('display','none');
            $create->text('LuckCompose', __('LuckCompose'))->default(0)->style('display','none');
            $create->text('IsTips', __('IsTips'))->default(0)->style('display','none');
            $create->text('IsLogs', __('IsLogs'))->default(0)->style('display','none');

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
        $show = new Show(ShopGoodsBox::findOrFail($id));

        $show->field('ID', __('ID'));
        $show->field('TemplateId', __('TemplateId'));
        $show->field('IsSelect', __('IsSelect'));
        $show->field('IsBind', __('IsBind'));
        $show->field('ItemValid', __('ItemValid'));
        $show->field('ItemCount', __('ItemCount'));
        $show->field('StrengthenLevel', __('StrengthenLevel'));
        $show->field('AttackCompose', __('AttackCompose'));
        $show->field('DefendCompose', __('DefendCompose'));
        $show->field('AgilityCompose', __('AgilityCompose'));
        $show->field('LuckCompose', __('LuckCompose'));
        $show->field('Random', __('Random'));
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
        $form = new Form(new ShopGoodsBox());

        $form->select('ID', 'Chọn rương')->options(function ($templateID) {
            $shopGoods = ShopGoods::find($templateID);
            if($shopGoods){
                return [$shopGoods->TemplateID => $shopGoods->Name];
            }
        })->ajax('/admin/api/load-item')->required();

        $form->select('TemplateId', 'Chọn vật phẩm')->options(function ($templateID) {
            $shopGoods = ShopGoods::find($templateID);
            if($shopGoods){
                return [$shopGoods->TemplateID => $shopGoods->Name];
            }
        })->ajax('/admin/api/load-item')->required();


        $form->select('IsSelect', __('Kiểu nhận'))->options([0=>'Nhận ngẫu nhiên', 1=>'Nhận toàn bộ'])->required()->width('100%');
        $form->switch('IsBind', __('Khoá'))->default(1)->width('100%');
        $form->number('ItemValid', __('Hạn'))->width('100%')->default(0)->help('0 là vĩnh viễn');
        $form->number('ItemCount', __('Số lượng'))->width('100%')->default(1);
        $form->number('Random', __('Random'))->width('100%')->default(0);
        $form->number('StrengthenLevel', __('Cường hoá'))->width('100%')->default(0);
        $form->number('AttackCompose', __('HT Tấn công'))->width('100%')->default(0);
        $form->number('DefendCompose', __('HT Phòng thủ'))->width('100%')->default(0);
        $form->number('AgilityCompose', __('HT Nhanh nhẹn'))->width('100%')->default(0);
        $form->number('LuckCompose', __('HT May mắn'))->width('100%')->default(0);
        $form->number('IsTips', __('IsTips'))->width('100%')->default(0);
        $form->switch('IsLogs', __('IsLogs'))->width('100%')->default(0);

        $form->disableEditingCheck();
        return $form;
    }
}
