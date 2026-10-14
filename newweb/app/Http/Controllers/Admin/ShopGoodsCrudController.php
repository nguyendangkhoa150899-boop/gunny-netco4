<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\ShopGoodsRequest;
use App\Models\ShopGoodsBox;
use App\Models\ShopGoodsCategory;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class ShopGoodsCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class ShopGoodsCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
//    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
//    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
//    use \Backpack\CRUD\app\Http\Controllers\Operations\ShowOperation;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        CRUD::setModel(\App\Models\ShopGoods::class);
        CRUD::setRoute(config('backpack.base.route_prefix') . '/shopgoods');
        CRUD::setEntityNameStrings('shopgoods', 'shop_goods');
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
                'name'  => 'TemplateID',
                'label' => 'TemplateID',
                'type'  => 'number',
            ],
            [
                'name'  => 'Name',
                'label' => 'Name',
                'type'  => 'text',
            ],
            [
                'name'  => 'Description',
                'label' => 'Description',
                'type'  => 'text',
            ],
            [
                'name'  => 'CategoryID',
                'label' => 'Category',
                'type'  => 'select',
                'entity'    => 'Category',
                'attribute' => 'Name',
                'model'     => ShopGoodsCategory::class
            ],
            [
                'name'  => 'Att-Def-Agi-Luck',
                'label' => 'Att-Def-Agi-Luck',
                'type'  => 'model_function',
                'function_name' => 'combine4Column'
            ],
            [
                'name'  => 'Property7',
                'label' => 'Sát/HG',
                'type'  => 'number',
            ],
            [
                'name'  => 'Image',
                'label' => 'Image',
                'type'  => 'model_function',
                'escaped' => false,
                'limit' => 999,
                'function_name'  => 'ResourceImageColumn',
            ],
        ]);
        $this->crud->orderBy('TemplateID', 'ASC');

        $this->crud->addFilter(
            [
                'type'  => 'select2_multiple',
                'name'  => 'Category',
                'label' => 'Category'
            ],
            function () {
                $categories = ShopGoodsCategory::all();
                $values = [];
                foreach ($categories as $category) {
                    $values[$category->ID] = $category->Name;
                }
                return $values;
            },
            function($values) {
                $this->crud->addClause('whereIn', 'CategoryID', json_decode($values));
            });

        $this->crud->addFilter(
            [
                'type'  => 'text',
                'name'  => 'Attack',
                'label' => 'Attack'
            ],
            false,
            function($value) {
                $this->crud->addClause('where', 'Attack', $value);
            }
        );
        $this->crud->addFilter(
            [
                'type'  => 'text',
                'name'  => 'Defence',
                'label' => 'Defence'
            ],
            false,
            function($value) {
                $this->crud->addClause('where', 'Defence', $value);
            }
        );
        $this->crud->addFilter(
            [
                'type'  => 'text',
                'name'  => 'Agility',
                'label' => 'Agility'
            ],
            false,
            function($value) {
                $this->crud->addClause('where', 'Agility', $value);
            }
        );
        $this->crud->addFilter(
            [
                'type'  => 'text',
                'name'  => 'Luck',
                'label' => 'Luck'
            ],
            false,
            function($value) {
                $this->crud->addClause('where', 'Luck', $value);
            }
        );
        $this->crud->addFilter(
            [
                'type'  => 'text',
                'name'  => 'Property7',
                'label' => 'Sát thương/Hộ giáp'
            ],
            false,
            function($value) {
                $this->crud->addClause('where', 'Property7', $value);
            }
        );

        /**
         * Columns can be defined using the fluent syntax or array syntax:
         * - CRUD::column('price')->type('number');
         * - CRUD::addColumn(['name' => 'price', 'type' => 'number']);
         */
    }

    /**
     * Define what happens when the Create operation is loaded.
     *
     * @see https://backpackforlaravel.com/docs/crud-operation-create
     * @return void
     */
    protected function setupCreateOperation()
    {
        CRUD::setValidation(ShopGoodsRequest::class);

        $this->crud->addFields([
            [
                'name' => 'TemplateID',
                'label' => 'TemplateID',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'CanRecycle',
                'label' => 'CanRecycle',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Name',
                'label' => 'Name',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'text',
            ],
            [
                'name' => 'Remark',
                'label' => 'Remark',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'text',
            ],
            [
                'name' => 'CategoryID',
                'label' => 'CategoryID',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Description',
                'label' => 'Description',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'text',
            ],
            [
                'name' => 'Attack',
                'label' => 'Attack',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Defence',
                'label' => 'Defence',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Agility',
                'label' => 'Agility',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Luck',
                'label' => 'Luck',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Level',
                'label' => 'Level',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Quality',
                'label' => 'Quality',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Pic',
                'label' => 'Pic',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'text',
            ],
            [
                'name' => 'MaxCount',
                'label' => 'MaxCount',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'NeedSex',
                'label' => 'NeedSex',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'NeedLevel',
                'label' => 'NeedLevel',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'CanStrengthen',
                'label' => 'CanStrengthen',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'checkbox',
            ],
            [
                'name' => 'CanCompose',
                'label' => 'CanCompose',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'checkbox',
            ],
            [
                'name' => 'CanDrop',
                'label' => 'CanDrop',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'checkbox',
            ],
            [
                'name' => 'CanEquip',
                'label' => 'CanEquip',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'checkbox',
            ],
            [
                'name' => 'CanUse',
                'label' => 'CanUse',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'checkbox',
            ],
            [
                'name' => 'CanDelete',
                'label' => 'CanDelete',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'checkbox',
            ],
            [
                'name' => 'Script',
                'label' => 'Script',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'text',
            ],
            [
                'name' => 'Data',
                'label' => 'Data',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'text',
            ],
            [
                'name' => 'Colors',
                'label' => 'Colors',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'text',
            ],
            [
                'name' => 'Property1',
                'label' => 'Property1',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Property2',
                'label' => 'Property2',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Property3',
                'label' => 'Property3',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Property4',
                'label' => 'Property4',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Property5',
                'label' => 'Property5',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Property6',
                'label' => 'Property6',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Property7',
                'label' => 'Property7',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Property8',
                'label' => 'Property8',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Valid',
                'label' => 'Valid',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Count',
                'label' => 'Count',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'BindType',
                'label' => 'BindType',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'FusionType',
                'label' => 'FusionType',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'FusionRate',
                'label' => 'FusionRate',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'FusionNeedRate',
                'label' => 'FusionNeedRate',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Hole',
                'label' => 'Hole',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'text',
            ],
            [
                'name' => 'RefineryLevel',
                'label' => 'RefineryLevel',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'ReclaimValue',
                'label' => 'ReclaimValue',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'ReclaimType',
                'label' => 'ReclaimType',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'FloorPrice',
                'label' => 'FloorPrice',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'SuitId',
                'label' => 'SuitId',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'CanTransfer',
                'label' => 'CanTransfer',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Price',
                'label' => 'Price',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
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

        $this->crud->addField([
            'name'      => 'box_items',
            'label'     => '',
            'type'      => 'nested_crud',
            'target'    => 'box_items',
            'model'     => ShopGoodsBox::class,
            'tab'       => 'Items Rương',  // optional
        ]);
    }
}
