<?php

namespace App\Admin\Controllers\ShopGoodsManagement;

use App\Shop;
use App\ShopGoods;
use App\ShopGoodsCategory;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ShopGoodsController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'ShopGoods';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        //Helpers
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $shopGoods = new ShopGoods();
        $shopGoods->setConnection($currentTank);

        $categories = ShopGoodsCategory::on($currentTank)->get();
        $valuesCategories = [];
        foreach ($categories as $category) {
            $valuesCategories[$category->ID] = $category->Name;
        }


        $grid = new Grid($shopGoods);

        $grid->column('TemplateID', __('ID'))->width(50)->filter();

        $grid->column('CategoryID', __('Danh mục'))->display(function ($CategoryID) use($currentTank){
            $category = ShopGoodsCategory::on($currentTank)->find($CategoryID);
            if($category){
                return $category->Name;
            }
            return "Không xác định";
        })->filter($valuesCategories);
        $grid->column('Name', __('Tên vật phẩm'));
        $grid->column('Description', __('Mô tả'));
        $grid->column('image', __('Hình ảnh'))->display(function (){
            return $this->ResourceImageColumn();
        });
        $grid->column('chi_so',__('Chỉ số'))->help('Tấn công-Phòng thủ-Nhanh nhẹn-May mắn')->display(function(){ return $this->combine4Column(); });
        $grid->column('Property7', __('Sát thương/Hộ giáp'))->filter()->sortable();

        $grid->quickSearch('TemplateID', 'Name', 'Description');
        $grid->disableFilter();
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
        $show = new Show(ShopGoods::on($currentTank)->findOrFail($id));

        $show->field('TemplateID', __('TemplateID'));
        $show->field('CanRecycle', __('CanRecycle'));
        $show->field('Name', __('Name'));
        $show->field('Remark', __('Remark'));
        $show->field('CategoryID', __('CategoryID'));
        $show->field('Description', __('Description'));
        $show->field('Attack', __('Attack'));
        $show->field('Defence', __('Defence'));
        $show->field('Agility', __('Agility'));
        $show->field('Luck', __('Luck'));
        $show->field('Level', __('Level'));
        $show->field('Quality', __('Quality'));
        $show->field('Pic', __('Pic'));
        $show->field('MaxCount', __('MaxCount'));
        $show->field('NeedSex', __('NeedSex'));
        $show->field('NeedLevel', __('NeedLevel'));
        $show->field('CanStrengthen', __('CanStrengthen'));
        $show->field('CanCompose', __('CanCompose'));
        $show->field('CanDrop', __('CanDrop'));
        $show->field('CanEquip', __('CanEquip'));
        $show->field('CanUse', __('CanUse'));
        $show->field('CanDelete', __('CanDelete'));
        $show->field('Script', __('Script'));
        $show->field('Data', __('Data'));
        $show->field('Colors', __('Colors'));
        $show->field('Property1', __('Property1'));
        $show->field('Property2', __('Property2'));
        $show->field('Property3', __('Property3'));
        $show->field('Property4', __('Property4'));
        $show->field('Property5', __('Property5'));
        $show->field('Property6', __('Property6'));
        $show->field('Property7', __('Property7'));
        $show->field('Property8', __('Property8'));
        $show->field('Valid', __('Valid'));
        $show->field('Count', __('Count'));
        $show->field('AddTime', __('AddTime'));
        $show->field('BindType', __('BindType'));
        $show->field('FusionType', __('FusionType'));
        $show->field('FusionRate', __('FusionRate'));
        $show->field('FusionNeedRate', __('FusionNeedRate'));
        $show->field('Hole', __('Hole'));
        $show->field('RefineryLevel', __('RefineryLevel'));
        $show->field('ReclaimValue', __('ReclaimValue'));
        $show->field('ReclaimType', __('ReclaimType'));
        $show->field('FloorPrice', __('FloorPrice'));
        $show->field('SuitId', __('SuitId'));
        $show->field('CanTransfer', __('CanTransfer'));
        $show->field('Price', __('Price'));

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
        $shopGoods = new ShopGoods();
        $shopGoods->setConnection($currentTank);
        $form = new Form($shopGoods);

        $form->number('CanRecycle', __('CanRecycle'));
        $form->text('Name', __('Name'));
        $form->text('Remark', __('Remark'));
        $form->number('CategoryID', __('CategoryID'));
        $form->text('Description', __('Description'));
        $form->number('Attack', __('Attack'));
        $form->number('Defence', __('Defence'));
        $form->number('Agility', __('Agility'));
        $form->number('Luck', __('Luck'));
        $form->number('Level', __('Level'));
        $form->number('Quality', __('Quality'));
        $form->text('Pic', __('Pic'));
        $form->number('MaxCount', __('MaxCount'));
        $form->number('NeedSex', __('NeedSex'));
        $form->number('NeedLevel', __('NeedLevel'));
        $form->switch('CanStrengthen', __('CanStrengthen'));
        $form->switch('CanCompose', __('CanCompose'));
        $form->switch('CanDrop', __('CanDrop'));
        $form->switch('CanEquip', __('CanEquip'));
        $form->switch('CanUse', __('CanUse'));
        $form->switch('CanDelete', __('CanDelete'));
        $form->text('Script', __('Script'));
        $form->text('Data', __('Data'));
        $form->text('Colors', __('Colors'));
        $form->number('Property1', __('Property1'));
        $form->number('Property2', __('Property2'));
        $form->number('Property3', __('Property3'));
        $form->number('Property4', __('Property4'));
        $form->number('Property5', __('Property5'));
        $form->number('Property6', __('Property6'));
        $form->number('Property7', __('Property7'));
        $form->number('Property8', __('Property8'));
        $form->number('Valid', __('Valid'));
        $form->number('Count', __('Count'))->default(1);
        $form->datetime('AddTime', __('AddTime'))->default(date('Y-m-d H:i:s'));
        $form->number('BindType', __('BindType'));
        $form->number('FusionType', __('FusionType'));
        $form->number('FusionRate', __('FusionRate'));
        $form->number('FusionNeedRate', __('FusionNeedRate'));
        $form->text('Hole', __('Hole'));
        $form->number('RefineryLevel', __('RefineryLevel'));
        $form->number('ReclaimValue', __('ReclaimValue'));
        $form->number('ReclaimType', __('ReclaimType'));
        $form->number('FloorPrice', __('FloorPrice'));
        $form->number('SuitId', __('SuitId'));
        $form->number('CanTransfer', __('CanTransfer'))->default(1);
        $form->number('Price', __('Price'));

        return $form;
    }

    public function loadItemList(Request $request)
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $q = $request->get('q');
        $shopGoods = ShopGoods::on($currentTank)->where('Name','like', "%$q%")->paginate();
        $shopGoods->getCollection()->transform(function ($value) {
            return [
                'id'=> $value->TemplateID,
                'text' => $value->ResourceImageSelectColumn() . ' ' . $value->Name . ' (ID: '.$value->TemplateID.' - '.$value->combine4Column(). ')',
            ];
        });
        return $shopGoods;
    }
}
