<?php

namespace App\Admin\Controllers\ShopManagement;

use App\Shop;
use App\ShopGoods;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ShopController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Shop';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $shop = new Shop();
        $shop->setConnection($currentTank);

        $grid = new Grid($shop);

        $grid->column('ID', __('ID'))->filter()->sortable();
        $grid->column('ShopID', __('ShopID'));
//        $grid->column('GroupID', __('GroupID'));
        $grid->column('image', __('Hình ảnh'))->display(function (){
            return $this->ResourceImageColumn();
        });
        $grid->column('Item.Name', __('Tên vật phẩm'));
//        $grid->column('BuyType', __('BuyType'));
//        $grid->column('IsContinue', __('IsContinue'));
        $grid->column('IsBind', 'Khoá')->display(function ($IsBind){
            if((int)$IsBind==0){
                return '<span class="badge btn-success">Khoá</span>';
            }
            return '<span class="badge btn-info">Không khoá</span>';
        });
        $grid->column('AUnit', __('Hạn dùng (1)'))->display(function ($AUnit){
            return (int) $AUnit .' ngày';
        })->width(120);
//        $grid->column('IsVouch', __('IsVouch'));
//        $grid->column('Label', __('Label'));
//        $grid->column('Beat', __('Beat'));
        $grid->column('APrice1', __('Hình thức (1)'))->display(function ($APrice){
            return $this->getAPrice1Type();
        })->filter([-1.0 => 'Xu', 11408.0 => 'Huân chương', -4.0 => 'Lễ Kim']);;
        $grid->column('AValue1', __('Giá tiền (1)'))->display(function (){ return $this->getAValue1();});
//        $grid->column('APrice2', __('APrice2'));
//        $grid->column('AValue2', __('AValue2'));
//        $grid->column('APrice3', __('APrice3'));
//        $grid->column('AValue3', __('AValue3'));
        $grid->column('BUnit', __('Hạn dùng (2)'))->display(function (){
            return $this->getBUnit();
        });
        $grid->column('BPrice1', __('Hình thức (2)'))->display(function (){
            return $this->getBPrice1Type();
        })->filter([-1.0 => 'Xu', 11408.0 => 'Huân chương', -4.0 => 'Lễ Kim']);
        $grid->column('BValue1', __('Giá tiền (2)'))->display(function (){return $this->getBValue1();});
//        $grid->column('BPrice2', __('BPrice2'));
//        $grid->column('BValue2', __('BValue2'));
//        $grid->column('BPrice3', __('BPrice3'));
//        $grid->column('BValue3', __('BValue3'));
        $grid->column('CUnit', __('Hạn dùng (3)'))->display(function (){ return $this->getCUnit();});
        $grid->column('CPrice1', __('Hình thức (3)'))->display(function (){
            return $this->getCPrice1Type();
        })->filter([-1.0 => 'Xu', 11408.0 => 'Huân chương', -4.0 => 'Lễ Kim']);;
        $grid->column('CValue1', __('Giá tiền (3)'))->display(function (){return $this->getCValue1();});;
//        $grid->column('CPrice2', __('CPrice2'));
//        $grid->column('CValue2', __('CValue2'));
//        $grid->column('CPrice3', __('CPrice3'));
//        $grid->column('Sort', __('Sort'));
//        $grid->column('CValue3', __('CValue3'));
//        $grid->column('IsCheap', __('IsCheap'));
//        $grid->column('LimitCount', __('LimitCount'));
//        $grid->column('StartDate', __('StartDate'));
//        $grid->column('EndDate', __('EndDate'));
//        $grid->column('LimitGrade', __('LimitGrade'));
//        $grid->column('CanBuy', __('CanBuy'));

        $grid->expandFilter();
        $grid->filter(function ($filter){
            $filter->disableIdFilter();
            $filter->equal('TemplateID','Tên vật phẩm')->select(['key' => 'value'])->ajax('/admin/api/load-item');

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
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $show = new Show(Shop::on($currentTank)->findOrFail($id));

        $show->field('ID', __('ID'));
        $show->field('ShopID', __('ShopID'));
        $show->field('GroupID', __('GroupID'));
        $show->field('TemplateID', __('TemplateID'));
        $show->field('BuyType', __('BuyType'));
        $show->field('IsContinue', __('IsContinue'));
        $show->field('IsBind', __('IsBind'));
        $show->field('IsVouch', __('IsVouch'));
        $show->field('Label', __('Label'));
        $show->field('Beat', __('Beat'));
        $show->field('AUnit', __('AUnit'));
        $show->field('APrice1', __('APrice1'));
        $show->field('AValue1', __('AValue1'));
        $show->field('APrice2', __('APrice2'));
        $show->field('AValue2', __('AValue2'));
        $show->field('APrice3', __('APrice3'));
        $show->field('AValue3', __('AValue3'));
        $show->field('BUnit', __('BUnit'));
        $show->field('BPrice1', __('BPrice1'));
        $show->field('BValue1', __('BValue1'));
        $show->field('BPrice2', __('BPrice2'));
        $show->field('BValue2', __('BValue2'));
        $show->field('BPrice3', __('BPrice3'));
        $show->field('BValue3', __('BValue3'));
        $show->field('CUnit', __('CUnit'));
        $show->field('CPrice1', __('CPrice1'));
        $show->field('CValue1', __('CValue1'));
        $show->field('CPrice2', __('CPrice2'));
        $show->field('CValue2', __('CValue2'));
        $show->field('CPrice3', __('CPrice3'));
        $show->field('Sort', __('Sort'));
        $show->field('CValue3', __('CValue3'));
        $show->field('IsCheap', __('IsCheap'));
        $show->field('LimitCount', __('LimitCount'));
        $show->field('StartDate', __('StartDate'));
        $show->field('EndDate', __('EndDate'));
        $show->field('LimitGrade', __('LimitGrade'));
        $show->field('CanBuy', __('CanBuy'));

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
        $shop = new Shop();
        $shop->setConnection($currentTank);
        $form = new Form($shop);

        $form->decimal('ID', __('ID'));
        $form->decimal('ShopID', __('ShopID'));
        $form->decimal('GroupID', __('GroupID'));
        $form->select('TemplateID')->options(function ($templateID) use ($currentTank){
        $shopGoods = ShopGoods::on($currentTank)->find($templateID);
            if($shopGoods){
                return [$shopGoods->TemplateID => $shopGoods->Name];
            }
        })->ajax('/admin/api/load-shop-with-relation');
        $form->decimal('BuyType', __('BuyType'));
        $form->switch('IsContinue', __('IsContinue'));
        $form->decimal('IsBind', __('IsBind'));
        $form->decimal('IsVouch', __('IsVouch'));
        $form->decimal('Label', __('Label'));
        $form->decimal('Beat', __('Beat'));
        $form->decimal('AUnit', __('AUnit'));
        $form->decimal('APrice1', __('APrice1'));
        $form->decimal('AValue1', __('AValue1'));
        $form->decimal('APrice2', __('APrice2'));
        $form->decimal('AValue2', __('AValue2'));
        $form->decimal('APrice3', __('APrice3'));
        $form->decimal('AValue3', __('AValue3'));
        $form->decimal('BUnit', __('BUnit'));
        $form->decimal('BPrice1', __('BPrice1'));
        $form->decimal('BValue1', __('BValue1'));
        $form->decimal('BPrice2', __('BPrice2'));
        $form->decimal('BValue2', __('BValue2'));
        $form->decimal('BPrice3', __('BPrice3'));
        $form->decimal('BValue3', __('BValue3'));
        $form->decimal('CUnit', __('CUnit'));
        $form->decimal('CPrice1', __('CPrice1'));
        $form->decimal('CValue1', __('CValue1'));
        $form->decimal('CPrice2', __('CPrice2'));
        $form->decimal('CValue2', __('CValue2'));
        $form->decimal('CPrice3', __('CPrice3'));
        $form->decimal('Sort', __('Sort'));
        $form->decimal('CValue3', __('CValue3'));
        $form->switch('IsCheap', __('IsCheap'));
        $form->decimal('LimitCount', __('LimitCount'));
        $form->datetime('StartDate', __('StartDate'))->default(date('Y-m-d H:i:s'));
        $form->datetime('EndDate', __('EndDate'))->default(date('Y-m-d H:i:s'));
        $form->number('LimitGrade', __('LimitGrade'));
        $form->switch('CanBuy', __('CanBuy'));

        return $form;
    }

    public function loadShopWithRelation(Request $request)
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;

        $q = $request->get('q');
        $shop = ShopGoods::on($currentTank)->with('Shop')->where('Name','like', "%$q%")->paginate();
        $shop->getCollection()->transform(function ($value) {
            if($value->Shop == null){
                return response();
            }
            else{
                return [
                    'id'=> (int)$value->Shop->ID,
                    'text' => $value->ResourceImageSelectColumn() . ' ' . $value->Name . ' (ID: '.$value->TemplateID.' - '.$value->combine4Column(). ')',
                ];
            }
        });
        return $shop;
    }
}
