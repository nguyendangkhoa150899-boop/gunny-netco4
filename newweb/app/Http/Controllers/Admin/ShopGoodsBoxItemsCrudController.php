<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\ActiveAwardCreateRequest;
use App\Http\Requests\ActiveAwardUpdateRequest;
use App\Http\Requests\ActiveRequest;
use App\Models\ActiveAward;
use App\Models\ClothGroupTemplate;
use App\Models\ClothPropertyTemplate;
use App\Models\ShopGoods;
use App\Models\ShopGoodsBox;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Route;

/**
 * Class ActiveCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class ShopGoodsBoxItemsCrudController extends CrudController
{
    use \Onkbear\NestedCrud\app\Http\Controllers\Operations\NestedListOperation;
    use \Onkbear\NestedCrud\app\Http\Controllers\Operations\NestedCreateOperation;
    use \Onkbear\NestedCrud\app\Http\Controllers\Operations\NestedUpdateOperation;
    use \Onkbear\NestedCrud\app\Http\Controllers\Operations\NestedDeleteOperation;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        CRUD::setModel(\App\Models\ShopGoodsBox::class);
        $template_id = \Route::current()->parameter('template_id');
        CRUD::setRoute(config('backpack.base.route_prefix') . '/shopgoods/'.$template_id.'/box_items');
        //CRUD::setEntityNameStrings('Phần thưởng hoạt động', 'Phần thưởng hoạt động');
    }

    /**
     * Define what happens when the List operation is loaded.
     *
     * @see  https://backpackforlaravel.com/docs/crud-operation-list-entries
     * @return void
     */
    protected function setupNestedListOperation()
    {
        $template_id = \Route::current()->parameter('template_id');
        $item = ShopGoods::find($template_id);
        if (!empty($item->Data)) {
            $this->crud->addClause('where', 'ID', $item->Data);
        } else {
            $this->crud->addClause('where', 'ID', 0);
        }
        $this->crud->addColumns([
            [
                'name' => 'AI_ID',
                'label' => 'ID',
                'type' => 'text'
            ],
            [
                'name' => 'TemplateId',
                'label' => 'Mã',
                'type' => 'text'
            ],
            [
                'name'  => 'Image',
                'label' => 'Image',
                'type'  => 'model_function',
                'function_name' => 'ResourceImageColumn',
                'limit' => 999,
            ],
            [
                'name'  => 'ItemName',
                'label' => 'Item',
                'type'  => 'select',
                'entity'    => 'Item',
                'attribute' => 'Name',
                'model'     => ShopGoods::class
            ],
            [
                'name' => 'IsSelect',
                'label' => 'IsSelect',
                'type' => 'check'
            ],
            [
                'name' => 'IsBind',
                'label' => 'IsBind',
                'type' => 'check'
            ],
            [
                'name' => 'ItemValid',
                'label' => 'ItemValid',
                'type' => 'number'
            ],
            [
                'name' => 'ItemCount',
                'label' => 'ItemCount',
                'type' => 'number'
            ],
            [
                'name' => 'StrengthenLevel',
                'label' => 'StrengthenLevel',
                'type' => 'number'
            ],
            [
                'name'  => 'Att-Def-Agi-Luck',
                'label' => 'Att-Def-Agi-Luck',
                'type'  => 'model_function',
                'function_name' => 'combine4Column'
            ],
            [
                'name' => 'Random',
                'label' => 'Random',
                'type' => 'number'
            ],
            [
                'name' => 'IsTips',
                'label' => 'IsTips',
                'type' => 'check'
            ],
            [
                'name' => 'IsLogs',
                'label' => 'IsLogs',
                'type' => 'check'
            ],
        ]);

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
    protected function setupNestedCreateOperation()
    {
//        $this->crud->setValidation(ActiveAwardCreateRequest::class);
        $template_id = \Route::current()->parameter('template_id');
        $item = ShopGoods::find($template_id);
        if (!empty($item->Data)) {
            $data_id = $item->Data;
        } else {
            $data_id = 0;
        }

        $this->crud->addFields([
            [
                'name'  => 'ID',
                'label' => "ID",
                'type'  => 'hidden',
                'value'  => $data_id,
            ],
            [
                'name'  => 'TemplateId',
                'label' => "Item",
                'type'  => 'select2_from_ajax_multiple_with_image',
                'entity'      => 'Item', // the method that defines the relationship in your Model
                'attribute'      => 'apiDisplay',
                'image'      => 'apiDisplayImage',
                'data_source' => url(config('backpack.base.route_prefix', 'admin')."/api/shopgoods"), // url to controller search function (with /{id} should return model)
                'pivot'       => false, // on create&update, do you need to add/delete pivot table entries?

                // OPTIONAL
                'delay' => 500, // the minimum amount of time between ajax requests when searching in the field
                'model'                => ShopGoods::class, // foreign key model
                'placeholder'          => "Select items", // placeholder for the select
                'minimum_input_length' => 4, // minimum characters to type before querying results
                // 'include_all_form_fields'  => false, // optional - only send the current field through AJAX (for a smaller payload if you're not using multiple chained select2s)
            ],
            [
                'name' => 'IsSelect',
                'label' => 'IsSelect',
                'type' => 'checkbox'
            ],
            [
                'name' => 'IsBind',
                'label' => 'IsBind',
                'type' => 'checkbox'
            ],
            [
                'name' => 'ItemValid',
                'label' => 'ItemValid',
                'type' => 'number',
                'default' => 0,
                'hint' => '0 = vĩnh viễn'
            ],
            [
                'name' => 'ItemCount',
                'label' => 'ItemCount',
                'type' => 'number',
                'default' => 1,
            ],
            [
                'name' => 'StrengthenLevel',
                'label' => 'StrengthenLevel',
                'type' => 'number',
                'default' => 0,
            ],
            [
                'name' => 'AttackCompose',
                'label' => 'AttackCompose',
                'type' => 'number',
                'default' => 0,
            ],
            [
                'name' => 'DefendCompose',
                'label' => 'DefendCompose',
                'type' => 'number',
                'default' => 0,
            ],
            [
                'name' => 'AgilityCompose',
                'label' => 'AgilityCompose',
                'type' => 'number',
                'default' => 0,
            ],
            [
                'name' => 'LuckCompose',
                'label' => 'LuckCompose',
                'type' => 'number',
                'default' => 0,
            ],
            [
                'name' => 'Random',
                'label' => 'Random',
                'type' => 'number',
                'default' => 0,
            ],
            [
                'name' => 'IsTips',
                'label' => 'IsTips',
                'type' => 'checkbox'
            ],
            [
                'name' => 'IsLogs',
                'label' => 'IsLogs',
                'type' => 'checkbox'
            ],
        ]);
        /**
         * Fields can be defined using the fluent syntax or array syntax:
         * - CRUD::field('price')->type('number');
         * - CRUD::addField(['name' => 'price', 'type' => 'number']));
         */
    }

    public function nestedStore()
    {
        $this->crud->hasAccessOrFail('create');

        $template_id = \Route::current()->parameter('template_id');
        $item = ShopGoods::find($template_id);
        if (empty($item->Data)) {
            $item->Data = $template_id;
            $item->save();
        }
        // execute the FormRequest authorization and validation, if one is required
        $request = $this->crud->validateRequest();
        $items = $request->TemplateId;
        if (is_array($items)) {
            $ID = $request->ID;
            $IsSelect = $request->IsSelect;
            $IsBind = $request->IsBind;
            $ItemValid = $request->ItemValid;
            $ItemCount = $request->ItemCount;
            $StrengthenLevel = $request->StrengthenLevel;
            $AttackCompose = $request->AttackCompose;
            $DefendCompose = $request->DefendCompose;
            $AgilityCompose = $request->AgilityCompose;
            $LuckCompose = $request->LuckCompose;
            $Random = $request->Random;
            $IsTips = $request->IsTips;
            $IsLogs = $request->IsLogs;

            foreach ($items as $item) {
                $entry = new ShopGoodsBox([
                    'ID' => $ID,
                    'TemplateId' => $item,
                    'IsSelect' => $IsSelect,
                    'IsBind' => $IsBind,
                    'ItemValid' => $ItemValid ?: 0,
                    'ItemCount' => $ItemCount ?: 1,
                    'StrengthenLevel' => $StrengthenLevel ?: 0,
                    'AttackCompose' => $AttackCompose ?: 0,
                    'DefendCompose' => $DefendCompose ?: 0,
                    'AgilityCompose' => $AgilityCompose ?: 0,
                    'LuckCompose' => $LuckCompose ?: 0,
                    'Random' => $Random,
                    'IsTips' => $IsTips,
                    'IsLogs' => $IsLogs,
                ]);
                $entry->save();
            }
            return true;
        } else {
            // insert item in the db
            $entry = $this->crud->create($this->crud->getStrippedSaveRequest());
            $this->data['entry'] = $this->crud->entry = $entry;
            return $entry->getKey();
        }
    }

    /**
     * Define what happens when the Update operation is loaded.
     *
     * @see https://backpackforlaravel.com/docs/crud-operation-update
     * @return void
     */
    protected function setupNestedUpdateOperation()
    {
        $template_id = \Route::current()->parameter('template_id');
        $item = ShopGoods::find($template_id);
        if (!empty($item->Data)) {
            $data_id = $item->Data;
        } else {
            $item->Data = $item->TemplateID;
            $item->save();
            $data_id = $item->Data;
        }
        $id = \Route::current()->parameter('id');
        $itembox = ShopGoodsBox::find($id);
        $item = $itembox->Item;
        $image = $item->ResourceImageColumn();
        $this->crud->image_title = $image;
        $this->crud->entity_name = $item->Name;

        $this->crud->addFields([
            [
                'name'  => 'AI_ID',
                'label' => "AI_ID",
                'type'  => 'hidden',
                'value'  => $id,
            ],
            [
                'name'  => 'ID',
                'label' => "ID",
                'type'  => 'hidden',
                'value'  => $data_id,
            ],
            [
                'name'  => 'TemplateId',
                'label' => "Item",
                'type'  => 'hidden',
                'value'  => $itembox->TemplateId,
            ],
            [
                'name' => 'IsSelect',
                'label' => 'IsSelect',
                'type' => 'checkbox'
            ],
            [
                'name' => 'IsBind',
                'label' => 'IsBind',
                'type' => 'checkbox'
            ],
            [
                'name' => 'ItemValid',
                'label' => 'ItemValid',
                'type' => 'number',
                'default' => 0,
                'hint' => '0 = vĩnh viễn'
            ],
            [
                'name' => 'ItemCount',
                'label' => 'ItemCount',
                'type' => 'number',
                'default' => 1,
            ],
            [
                'name' => 'StrengthenLevel',
                'label' => 'StrengthenLevel',
                'type' => 'number',
                'default' => 0,
            ],
            [
                'name' => 'AttackCompose',
                'label' => 'AttackCompose',
                'type' => 'number',
                'default' => 0,
            ],
            [
                'name' => 'DefendCompose',
                'label' => 'DefendCompose',
                'type' => 'number',
                'default' => 0,
            ],
            [
                'name' => 'AgilityCompose',
                'label' => 'AgilityCompose',
                'type' => 'number',
                'default' => 0,
            ],
            [
                'name' => 'LuckCompose',
                'label' => 'LuckCompose',
                'type' => 'number',
                'default' => 0,
            ],
            [
                'name' => 'Random',
                'label' => 'Random',
                'type' => 'number',
                'default' => 0,
            ],
            [
                'name' => 'IsTips',
                'label' => 'IsTips',
                'type' => 'checkbox'
            ],
            [
                'name' => 'IsLogs',
                'label' => 'IsLogs',
                'type' => 'checkbox'
            ],
        ]);
    }
}
