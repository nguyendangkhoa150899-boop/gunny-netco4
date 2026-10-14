<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Admin\Operations\buildxmlOperation;
use App\Http\Requests\ShopGoodsRequest;
use App\Models\ShopGoods;
use App\Models\ShopGoodsCategory;
use App\Models\ShopType;
use App\Traits\Search;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class ShopGoodsCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class ShopItemsCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
//    use \Backpack\CRUD\app\Http\Controllers\Operations\ShowOperation;
    use buildxmlOperation;
    use \Backpack\CRUD\app\Library\CrudPanel\Traits\Search;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        CRUD::setModel(\App\Models\Shop::class);
        CRUD::setRoute(config('backpack.base.route_prefix') . '/shopitems');
        CRUD::setEntityNameStrings('Vật phẩm Shop', 'Vật phẩm Shop');
    }

    /**
     * Define what happens when the List operation is loaded.
     *
     * @see  https://backpackforlaravel.com/docs/crud-operation-list-entries
     * @return void
     */
    protected function setupListOperation()
    {
        $this->crud->setColumns([
            [
                'name'  => 'ID',
                'label' => 'ID',
                'type'  => 'number',
            ],[
                'name'  => 'ShopID',
                'label' => 'ShopID',
                'type'  => 'number',
            ],
            [
                'name'  => 'Name',
                'label' => 'Name',
                'type' => 'relationship',
                'entity' => 'Item', // the method that defines the relationship in your Model
                'attribute' => 'Name',
                'searchLogic' => function ( $query, $column, $searchTerm ) {
                    $query->orWhereHas($column['entity'], function ($q) use ($column, $searchTerm) {
                        $q->where($this->getColumnWithTableNamePrefixed($q, $column['attribute']), 'like', '%'.$searchTerm.'%');
                    });
                }
            ],
            [
                'name'  => 'AUnit',
                'label' => 'Hạn dùng(1)',
                'type'  => 'number',
            ],
            [
                'name'  => 'APrice1',
                'label' => 'Hình thức(1)',
                'type'  => 'model_function',
                'function_name'    => 'getAPrice1Type',
            ],
            [
                'name'  => 'AValue1',
                'label' => 'Giá tiền(1)',
                'type'  => 'model_function',
                'function_name'    => 'getAValue1',
            ],
            [
                'name'  => 'Image',
                'label' => 'Image',
                'type'  => 'model_function',
                'escaped' => false,
                'limit' => 999,
                'function_name'  => 'ResourceImageColumn',
            ],
            [
                'name'  => 'ShopName',
                'label' => 'ShopName',
                'type' => 'model_function',
                'function_name' => 'Department', // the method that defines the relationship in your Model
//                'attribute' => 'Type',
            ],
        ]);
        $this->crud->orderBy('TemplateID', 'ASC');

        $this->crud->addFilter(
            [
                'type'  => 'select2_multiple',
                'name'  => 'APrice1',
                'label' => 'Hình thức'
            ],
            function () {
                return [
                    -1 => 'Xu',
                    11408 => 'Huân chương',
                    -4 => 'Lễ Kim',
                    -3 => 'Công trạng',
                    -6 => 'Vàng mê cung',
                ];
            },
            function($values) {
                $this->crud->addClause('whereIn', 'APrice1', json_decode($values));
            });
        $this->crud->addFilter(
            [
                'type'  => 'select2_multiple',
                'name'  => 'ShopName',
                'label' => 'ShopName'
            ],
            function () {
                return ShopType::all()->keyBy('ID')->pluck('Name', 'ID')->toArray();
            },
            function($values) {
                $this->crud->query = $this->crud->query->whereHas('DepartmentType', function ($query) use ($values) {
                    $query->whereIn('Type', json_decode($values, true));
                });
            });
    }

    /**
     * Define what happens when the Create operation is loaded.
     *
     * @see https://backpackforlaravel.com/docs/crud-operation-create
     * @return void
     */
    protected function setupCreateOperation()
    {
        $this->crud->setValidation(ShopGoodsRequest::class);

        $this->crud->addFields([
            [
                'name' => 'ID',
                'label' => 'ID',
                'type' => 'number',
            ],
            [
                'name' => 'ShopID',
                'label' => 'ShopID',
                'type' => 'number',
                'default' => 1,
                'hint' => '1 - shop xu, 3 - shop lễ kim, 4 - shop huân chương, 20 - shop miễn phí',
            ],
            [
                'name' => 'GroupID',
                'label' => 'GroupID',
                'type' => 'number',
                'default' => 0,
                'hint' => 'ko biết là gì, mặc định để 0',
            ],
            [
                'name'  => 'TemplateID',
                'label' => 'TemplateID',
                'type'  => 'select2_from_ajax_multiple_with_image',
                'entity'      => 'Item', // the method that defines the relationship in your Model
                'attribute'      => 'apiDisplay',
                'image'      => 'apiDisplayImage',
                'data_source' => url(config('backpack.base.route_prefix', 'admin')."/api/shopgoods"), // url to controller search function (with /{id} should return model)
                'pivot'       => false, // on create&update, do you need to add/delete pivot table entries?
                'hint' => 'Chọn duy nhất 1 item',

                // OPTIONAL
                'delay' => 500, // the minimum amount of time between ajax requests when searching in the field
                'model'                => ShopGoods::class, // foreign key model
                'placeholder'          => "Select items", // placeholder for the select
                'minimum_input_length' => 4, // minimum characters to type before querying results
                'value' => false
            ],
            [
                'name' => 'BuyType',
                'label' => 'BuyType',
                'type' => 'number',
                'default' => 1,
                'hint' => '1 là mua theo ngày, 0 là mua theo số lượng',
            ],
            [
                'name' => 'IsContinue',
                'label' => 'IsContinue',
                'type' => 'checkbox',
                'default' => 1,
                'hint' => 'Không biết là gì, mặc định check theo số đông',
            ],
            [
                'name' => 'IsBind',
                'label' => 'Khóa',
                'type' => 'checkbox',
                'default' => 1,
            ],
            [
                'name' => 'IsVouch',
                'label' => 'IsVouch',
                'type' => 'number',
                'default' => 0,
                'hint' => 'Không biết là gì, mặc định 0 theo số đông',
            ],
            [
                'name' => 'Label',
                'label' => 'Label',
                'type' => 'number',
                'default' => 0,
                'hint' => '6 nếu món đồ có giới hạn mua, 7 nếu món đồ là shop miễn phí, còn lại thì để 1',
            ],
            [
                'name' => 'Beat',
                'label' => 'Beat',
                'type' => 'number',
                'default' => 1,
                'hint' => 'ảnh hưởng gì đó đến giá cả, mặc định = 1',
            ],
            [
                'name' => 'AUnit',
                'label' => 'AUnit',
                'type' => 'number',
                'default' => 0,
                'hint' => 'Số lượng/Ngày (phụ thuộc vào giá trị BuyType = 0/1), -1 để tạm thời disable sản phẩm',
            ],
            [
                'name' => 'APrice1',
                'label' => 'APrice1',
                'type' => 'number',
                'default' => -1,
                'hint' => 'Loại giá (-1 = xu, -3 = công trạng, -4 = lễ kim, -6 = vàng mê cung, 11408 = huân chương)',
            ],
            [
                'name' => 'AValue1',
                'label' => 'AValue1',
                'type' => 'number',
                'default' => 0,
                'hint' => 'Giá vật phẩm',
            ],
            [
                'name' => 'APrice2',
                'label' => 'APrice2',
                'type' => 'number',
                'default' => -1,
                'hint' => 'Loại giá (-1 = xu, -3 = công trạng, -4 = lễ kim, -6 = vàng mê cung, 11408 = huân chương)',
            ],
            [
                'name' => 'AValue2',
                'label' => 'AValue2',
                'type' => 'number',
                'default' => 0,
                'hint' => 'Giá vật phẩm',
            ],
            [
                'name' => 'APrice3',
                'label' => 'APrice3',
                'type' => 'number',
                'default' => -1,
                'hint' => 'Loại giá (-1 = xu, -3 = công trạng, -4 = lễ kim, -6 = vàng mê cung, 11408 = huân chương)',
            ],
            [
                'name' => 'AValue3',
                'label' => 'AValue3',
                'type' => 'number',
                'default' => 0,
                'hint' => 'Giá vật phẩm',
            ],
            [
                'name' => 'BUnit',
                'label' => 'BUnit',
                'type' => 'number',
                'default' => 0,
                'hint' => 'Số lượng/Ngày (phụ thuộc vào giá trị BuyType = 0/1), -1 để tạm thời disable sản phẩm',
            ],
            [
                'name' => 'BPrice1',
                'label' => 'BPrice1',
                'type' => 'number',
                'default' => -1,
                'hint' => 'Loại giá (-1 = xu, -3 = công trạng, -4 = lễ kim, -6 = vàng mê cung, 11408 = huân chương)',
            ],
            [
                'name' => 'BValue1',
                'label' => 'BValue1',
                'type' => 'number',
                'default' => 0,
                'hint' => 'Giá vật phẩm',
            ],
            [
                'name' => 'BPrice2',
                'label' => 'BPrice2',
                'type' => 'number',
                'default' => -1,
                'hint' => 'Loại giá (-1 = xu, -3 = công trạng, -4 = lễ kim, -6 = vàng mê cung, 11408 = huân chương)',
            ],
            [
                'name' => 'BValue2',
                'label' => 'BValue2',
                'type' => 'number',
                'default' => 0,
                'hint' => 'Giá vật phẩm',
            ],
            [
                'name' => 'BPrice3',
                'label' => 'BPrice3',
                'type' => 'number',
                'default' => -1,
                'hint' => 'Loại giá (-1 = xu, -3 = công trạng, -4 = lễ kim, -6 = vàng mê cung, 11408 = huân chương)',
            ],
            [
                'name' => 'BValue3',
                'label' => 'BValue3',
                'type' => 'number',
                'default' => 0,
                'hint' => 'Giá vật phẩm',
            ],
            [
                'name' => 'CUnit',
                'label' => 'CUnit',
                'type' => 'number',
                'default' => 0,
                'hint' => 'Số lượng/Ngày (phụ thuộc vào giá trị BuyType = 0/1), -1 để tạm thời disable sản phẩm',
            ],
            [
                'name' => 'CPrice1',
                'label' => 'CPrice1',
                'type' => 'number',
                'default' => -1,
                'hint' => 'Loại giá (-1 = xu, -3 = công trạng, -4 = lễ kim, -6 = vàng mê cung, 11408 = huân chương)',
            ],
            [
                'name' => 'CValue1',
                'label' => 'CValue1',
                'type' => 'number',
                'default' => 0,
                'hint' => 'Giá vật phẩm',
            ],
            [
                'name' => 'CPrice2',
                'label' => 'CPrice2',
                'type' => 'number',
                'default' => -1,
                'hint' => 'Loại giá (-1 = xu, -3 = công trạng, -4 = lễ kim, -6 = vàng mê cung, 11408 = huân chương)',
            ],
            [
                'name' => 'CValue2',
                'label' => 'CValue2',
                'type' => 'number',
                'default' => 0,
                'hint' => 'Giá vật phẩm',
            ],
            [
                'name' => 'CPrice3',
                'label' => 'CPrice3',
                'type' => 'number',
                'default' => -1,
                'hint' => 'Loại giá (-1 = xu, -3 = công trạng, -4 = lễ kim, -6 = vàng mê cung, 11408 = huân chương)',
            ],
            [
                'name' => 'CValue3',
                'label' => 'CValue3',
                'type' => 'number',
                'default' => 0,
                'hint' => 'Giá vật phẩm',
            ],
            [
                'name' => 'Sort',
                'label' => 'Sort',
                'type' => 'number',
            ],
            [
                'name' => 'IsCheap',
                'label' => 'Khuyến mãi?',
                'type' => 'checkbox',
            ],
            [
                'name' => 'LimitCount',
                'label' => 'LimitCount',
                'type' => 'number',
                'default' => -1,
                'hint' => 'Số lượng có hạn, nhanh chân kẻo hết, -1 là vô hạn'
            ],
            [
                'name' => 'StartDate',
                'label' => 'StartDate',
                'type' => 'date',
                'default' => date('d/m/Y'),
                'format' => 'DD/MM/YYYY',
            ],
            [
                'name' => 'EndDate',
                'label' => 'EndDate',
                'type' => 'date',
                'default' => date('d/m/Y'),
                'format' => 'DD/MM/YYYY',
            ],
            [
                'name' => 'LimitGrade',
                'label' => 'Cấp tối đa',
                'type' => 'number',
                'default' => 0
            ],
            [
                'name' => 'CanBuy',
                'label' => 'CanBuy',
                'type' => 'checkbox',
                'default' => 0
            ],
        ]);

        /**
         * Fields can be defined using the fluent syntax or array syntax:
         * - CRUD::field('price')->type('number');
         * - CRUD::addField(['name' => 'price', 'type' => 'number']));
         */
    }

    /**
     * Define what happens when the Update operation is loaded.
     *
     * @see https://backpackforlaravel.com/docs/crud-operation-update
     * @return void
     */
    protected function setupUpdateOperation()
    {
        $this->setupCreateOperation();
    }

    public function buildxml()
    {
        $content = file_get_contents(
            trim(env('REQUEST_URL'), '/') . "/ShopItemList.ashx"
        );
        if ($content === "Build:ShopItemList.xml,Success!") {
            \Alert::success('Cập nhật ShopItemList thành công!')->flash();
        } else {
            \Alert::error('Cập nhật thất bại, kiểm tra lại cấu hình!')->flash();
        }
        return back();
    }
}
