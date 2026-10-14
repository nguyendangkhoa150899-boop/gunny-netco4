<?php

namespace App\Admin\Controllers\ShopManagement;

use App\Admin\Actions\ShopGoodsShowList\DeleteShopGoodsShowListItemAction;
use App\Admin\Forms\EditShopGoodsShowListForm;
use App\ShopGoodsShowList;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Layout\Content;
use Encore\Admin\Show;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class ShopGoodsShowListController extends AdminController
{
    private $listFilter =  [
        1 => 'Xu - Mới (Nam)',
        2 => 'Xu - Mới (Nữ)',
        3 => 'Xu - Ưu đãi (Nam)',
        4 => 'Xu - Ưu đãi (Nữ)',
        5 => 'Xu - Vũ khí (Nam)',
        6 => 'Xu - Vũ khí (Nữ)',
        7 => 'Xu - Quần áo (Nam)',
        8 => 'Xu - Quần áo (Nữ)',
        9 => 'Xu - Nón (Nam)',
        10 => 'Xu - Nón (Nữ)',
        11 => 'Xu - Kính (Nam)',
        12 => 'Xu - Kính (Nữ)',
        13 => 'Xu - Trang sức (Nam)',
        14 => 'Xu - Trang sức (Nữ)',
        15 => 'Xu - Set quần áo (Nam)',
        16 => 'Xu - Set quần áo (Nữ)',
        17 => 'Xu - Tóc (Nam)',
        18 => 'Xu - Tóc (Nữ)',
        19 => 'Xu - Cánh (Nam)',
        20 => 'Xu - Cánh (Nữ)',
        21 => 'Xu - Mắt (Nam)',
        22 => 'Xu - Mắt (Nữ)',
        23 => 'Xu - Mặt (Nam)',
        24 => 'Xu - Mặt (Nữ)',
        25 => 'Xu - Đạo cụ chức năng (Nam)',
        26 => 'Xu - Đạo cụ chức năng (Nữ)',
        27 => 'Xu - Bong bóng (Nam)',
        28 => 'Xu - Bong bóng (Nữ)',
        29 => 'Lễ Kim - Tất cả (Nam)',
        30 => 'Lễ Kim - Tất cả (Nữ)',
        31 => 'Lễ Kim - Trang phục (Nam)',
        32 => 'Lễ Kim - Trang phục (Nữ)',
        33 => 'Lễ kim - Vũ khí (Nam)',
        34 => 'Lễ kim - Vũ khí (Nữ)',
        35 => 'Lễ kim - Làm đẹp (Nam)',
        36 => 'Lễ kim - Làm đẹp (Nữ)',
        37 => 'Xu - Đạo cụ (Nam)',
        38 => 'Xu - Đạo cụ (Nữ)',
        39 => 'Huân chương - Tất cả (Nam)',
        40 => 'Huân chương - Tất cả (Nữ)',
        41 => 'Huân chương - Trang phục (Nam)',
        42 => 'Huân chương - Trang phục (Nữ)',
        43 => 'Huân chương - Vũ khí (Nam)',
        44 => 'Huân chương - Vũ khí (Nữ)',
        45 => 'Huân chương - Làm đẹp (Nam)',
        46 => 'Huân chương - Làm đẹp (Nữ)',
        47 => 'Huân chương - Đạo cụ (Nam)',
        48 => 'Huân chương - Đạo cụ (Nữ)',
        49 => 'RECHARGE',
        63 => 'Xu - HotSale (Nam)',
        64 => 'Xu - HotSale (Nữ)',
        65 => 'Xu - Nhận miễn phí (Nam)',
        66 => 'Xu - Nhận miễn phí (Nữ)',
        67 => 'Xu - Mua nhiều (Nam)',
        68 => 'Xu - Mua nhiều (Nữ)'
    ];

    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Quản lý cửa hàng (ShowList)';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $shopGoodsShowList = new ShopGoodsShowList();
        $shopGoodsShowList->setConnection($currentTank);

        $grid = new Grid($shopGoodsShowList);
        $grid->setTitle('Quản lý các mục cửa hàng vật phẩm');
        $grid->column('Type', __('Loại'))->display(function (){
            return $this->getTypeShop();
        });
        $grid->column('Shop.TemplateID', 'Hình ảnh')->display(function (){
            return $this->Shop->ResourceImageColumn();
        });
        $grid->column('_ItemName_', 'Tên vật phẩm')->display(function (){
            return $this->Shop->Item->Name;
        });
        $grid->column('ShopId', __('ShopId'));

        $grid->filter(function ($filter) use ($grid){
            $filter->expand();
            $filter->disableIdFilter();

            $filter->in('Type','Loại')->multipleSelect($this->listFilter);
            $filter->equal('ShopId','Tên vật phẩm')->select()->ajax('/admin/api/load-shop-with-relation');
        });

        $grid->actions(function ($actions) use ($grid) {
            $actions->disableView();
            $actions->disableEdit();
            $actions->disableDelete();

//            $actions->add(new EditShopGoodsShowListAction());
            $actions->add(new DeleteShopGoodsShowListItemAction());
        });

        $grid->disableBatchActions();

        $grid->batchActions(function ($batch) {
            $batch->disableDelete();
//            $batch->add(new BatchDeleteItem());
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
        $show = new Show(ShopGoodsShowList::on($currentTank)->findOrFail($id));

        $show->field('Type', __('Type'));
        $show->field('ShopId', __('ShopId'));

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
        $shopGoodsShowList = new ShopGoodsShowList();
        $shopGoodsShowList->setConnection($currentTank);

        $form = new Form($shopGoodsShowList);

        $form->multipleSelect('Type', __('Type'))->options($this->listFilter);
        $form->select('ShopId','Vật phẩm cần thêm')->options()->ajax('/admin/api/load-shop-with-relation');

        $form->submitted(function (Form $form){
//            $form->ignore('ShopId');
//            $form->ignore('Type');
        });

        $form->saving(function (Form $form) use ($currentTank) {

            if($form->isCreating()){
                $types = $form->Type;
                $shopId = $form->ShopId;
                if((is_array($types) && sizeof($types) > 0)){
                    for ($i = 0; $i < sizeof($types) - 1; $i++ ){
                        $showList[] = [
                            'ShopId' => $shopId,
                            'Type' => $types[$i],
                        ];
                    }
                    DB::connection($currentTank)->table('ShopGoodsShowList')->insert($showList);
                }
            }
            else {
                dd("EDIT");
            }
            admin_toastr('Thêm vật phẩm vào Shop thành công', 'success');
            return redirect('admin/showlist-management');
        });
        return $form;
    }

    public function showEditView(Content $content)
    {
        return $content
            ->title('Edit vật phẩm ở Shop')
            ->body(new EditShopGoodsShowListForm());
    }

}
