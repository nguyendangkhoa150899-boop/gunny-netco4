<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\ActiveAwardCreateRequest;
use App\Http\Requests\ActiveAwardUpdateRequest;
use App\Http\Requests\ActiveRequest;
use App\Models\ActiveAward;
use App\Models\ClothGroupTemplate;
use App\Models\ClothPropertyTemplate;
use App\Models\ShopGoods;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;
use Illuminate\Support\Facades\DB;

/**
 * Class ActiveCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class ClothGroupTemplatesCrudController extends CrudController
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
        CRUD::setModel(\App\Models\ClothGroupTemplate::class);
        $group_id = \Route::current()->parameter('group_id');
        CRUD::setRoute(config('backpack.base.route_prefix') . '/avatargroup/'.$group_id.'/templates');
        //CRUD::setEntityNameStrings('Phần thưởng hoạt động', 'Phần thưởng hoạt động');
        CRUD::addClause('where', 'ID', $group_id);
    }

    /**
     * Define what happens when the List operation is loaded.
     *
     * @see  https://backpackforlaravel.com/docs/crud-operation-list-entries
     * @return void
     */
    protected function setupNestedListOperation()
    {
        $this->crud->addColumns([
            [
                'name'  => 'ItemID',
                'label' => 'ItemID',
                'type'  => 'number',
            ],
            [
                'name'  => 'TemplateID',
                'label' => 'TemplateID',
                'type'  => 'text',
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
                'name'  => 'Sex',
                'label' => 'Sex',
                'type'  => 'model_function',
                'function_name' => 'getSexText'
            ],
            [
                'name'  => 'Cost',
                'label' => 'Cost',
                'type'  => 'number',
            ],
            [
                'name'  => 'Type',
                'label' => 'Type',
                'type'  => 'model_function',
                'function_name' => 'getTypeText'
            ],
            [
                'name'  => 'OtherTemplateID',
                'label' => 'OtherTemplateID',
                'type'  => 'text',
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

        $GroupId = \Route::current()->parameter('group_id');
        $group = ClothPropertyTemplate::findOrFail($GroupId);
//        $lastItem = ClothGroupTemplate::all()->last();

        $this->crud->addFields([
//            [
//                'name'  => 'ItemID',
//                'label' => "ItemID",
//                'type'  => 'number',
//                'default' => $lastItem->ItemID + 1
//            ],
            [
                'name'  => 'ID',
                'label' => "ID",
                'type'  => 'hidden',
                'value'  => $GroupId,
            ],
            [
                'name'  => 'TemplateID',
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
                'name'  => 'Sex',
                'label' => 'Sex',
                'type'        => 'select_from_array',
                'options'     => [1 => 'Nam', 2 => 'Nữ', 3 => 'Cả 2'],
                'allows_null' => false,
                'default'     => 1,
            ],
            [
                'name' => 'Description',
                'label'=> 'Description',
                'type' => 'number',
                'default' => 1,
                'hint' => 'Chưa biết ý nghĩa, để tạm 1'
            ],
            [
                'name' => 'Cost',
                'label'=> 'Cost',
                'type' => 'number',
                'default' => 20000,
                'hint' => 'Số vàng cần để kích hoạt'
            ],
            [
                'name' => 'Type',
                'label'=> 'Type',
                'type'        => 'select_from_array',
                'options'     => [1 => 'Trang phục', 2 => 'Vũ khí'],
                'allows_null' => false,
                'default'     => $group->Type,
                'hint' => 'Type của bộ'
            ],
            [
                'name' => 'OtherTemplateID',
                'label'=> 'OtherTemplateID',
                'type' => 'text',
                'hint' => 'Tạm thời để trống'
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

        // execute the FormRequest authorization and validation, if one is required
        $request = $this->crud->validateRequest();
        $items = $request->TemplateID;
        $lastItem = ClothGroupTemplate::all()->last();
        //DB::unprepared('SET IDENTITY_INSERT [EasyGunny_Server].[dbo].['.$lastItem->getTable().'] ON');
//        $index = $lastItem->ItemID + 1;
        if (is_array($items)) {
//            $ItemID = $index++;
            $ID = $request->ID;
            $Sex = $request->Sex;
            $Description = $request->Description;
            $Cost = $request->Cost;
            $Type = $request->Type;
            $OtherTemplateID = $request->OtherTemplateID;

            foreach ($items as $item) {
                $entry = new ClothGroupTemplate([
//                    'ItemID' => $ItemID,
                    'ID' => $ID,
                    'TemplateID' => $item,
                    'Sex' => $Sex,
                    'Description' => $Description,
                    'Cost' => $Cost,
                    'Type' => $Type,
                    'OtherTemplateID' => $OtherTemplateID,
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
        $this->crud->setValidation(ActiveAwardUpdateRequest::class);

        $GroupId = \Route::current()->parameter('group_id');
        $group = ClothPropertyTemplate::findOrFail($GroupId);
        $TemplateId = \Route::current()->parameter('id');
        $template = ClothGroupTemplate::with('Item')->find($TemplateId);
        $item = $template->Item;
        $image = $item->ResourceImageColumn();
        $this->crud->image_title = $image;
        $this->crud->entity_name = $item->Name;

        $this->crud->addFields([
            [
                'name'  => 'ItemID',
                'label' => "ItemID",
                'type'  => 'number',
            ],
            [
                'name'  => 'ID',
                'label' => "ID",
                'type'  => 'hidden',
                'value'  => $GroupId,
            ],
            [
                'name'  => 'TemplateID',
                'label' => "Item",
                'type'  => 'hidden',
            ],
            [
                'name'  => 'Sex',
                'label' => 'Sex',
                'type'        => 'select_from_array',
                'options'     => [1 => 'Nam', 2 => 'Nữ', 3 => 'Cả 2'],
                'allows_null' => false,
                'default'     => 1,
            ],
            [
                'name' => 'Description',
                'label'=> 'Description',
                'type' => 'number',
                'default' => 1,
                'hint' => 'Chưa biết ý nghĩa, để tạm 1'
            ],
            [
                'name' => 'Cost',
                'label'=> 'Cost',
                'type' => 'number',
                'default' => 20000,
                'hint' => 'Số vàng cần để kích hoạt'
            ],
            [
                'name' => 'Type',
                'label'=> 'Type',
                'type'        => 'select_from_array',
                'options'     => [1 => 'Trang phục', 2 => 'Vũ khí'],
                'allows_null' => false,
                'default'     => $group->Type,
                'hint' => 'Type của bộ'
            ],
            [
                'name' => 'OtherTemplateID',
                'label'=> 'OtherTemplateID',
                'type' => 'text',
                'hint' => 'Tạm thời để trống'
            ],
        ]);
    }
}
