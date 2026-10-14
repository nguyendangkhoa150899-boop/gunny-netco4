<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\ActiveAwardCreateRequest;
use App\Http\Requests\ActiveAwardUpdateRequest;
use App\Http\Requests\ActiveRequest;
use App\Http\Requests\ShopDepartmentItemCreateRequest;
use App\Models\ActiveAward;
use App\Models\Shop;
use App\Models\ShopGoods;
use App\Models\ShopGoodsShowList;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class ActiveCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class ShopDepartmentItemsCrudController extends CrudController
{
    use \Onkbear\NestedCrud\app\Http\Controllers\Operations\NestedListOperation;
    use \Onkbear\NestedCrud\app\Http\Controllers\Operations\NestedCreateOperation;
//    use \Onkbear\NestedCrud\app\Http\Controllers\Operations\NestedUpdateOperation;
    use \Onkbear\NestedCrud\app\Http\Controllers\Operations\NestedDeleteOperation;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        $this->crud->setModel(\App\Models\ShopGoodsShowList::class);
        $department_id = \Route::current()->parameter('department_id');
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/shopdepartments/'.$department_id.'/items');
        $this->crud->addClause('where', 'Type', $department_id);
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
                'name'  => 'ID',
                'label' => 'ID',
                'type'  => 'number',
            ],
            [
                'name'  => 'Image',
                'label' => 'Image',
                'type'  => 'model_function',
                'function_name' => 'ResourceImageColumn',
                'limit' => 999,
            ],
            [
                'name'  => 'Item_Name',
                'label' => 'Item Name',
                'type'  => 'model_function',
                'function_name' => 'ItemName',
                'limit' => 999,
            ],
            [
                'name'  => 'ShopId',
                'label' => 'Shop Item ID',
                'type'  => 'number',
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
        $this->crud->setValidation(ShopDepartmentItemCreateRequest::class);

        $department_id = \Route::current()->parameter('department_id');

//        $displayFields = Shop::apiSelectionDisplayFields();
//        $columnHint = 'ShopItem/Name/';
//        $columnHint .= implode('/', array_keys($displayFields));
        $this->crud->addFields([
            [
                'name'  => 'Type',
                'label' => "Type",
                'type'  => 'hidden',
                'value' => $department_id
            ],
            [
                'name'  => 'ShopId',
                'label' => "Shop Item",
                'type'  => 'select2_from_ajax_multiple_with_image',
                'entity'      => 'ShopItem', // the method that defines the relationship in your Model
                'attribute'      => 'apiDisplay',
                'image'      => 'apiDisplayImage',
                'data_source' => url(config('backpack.base.route_prefix', 'admin')."/api/shopitem"), // url to controller search function (with /{id} should return model)
                'pivot'       => false, // on create&update, do you need to add/delete pivot table entries?

                // OPTIONAL
                'delay' => 500, // the minimum amount of time between ajax requests when searching in the field
                'model'                => Shop::class, // foreign key model
                'placeholder'          => "Select items", // placeholder for the select
                'minimum_input_length' => 4, // minimum characters to type before querying results
                // 'include_all_form_fields'  => false, // optional - only send the current field through AJAX (for a smaller payload if you're not using multiple chained select2s)
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
        $items = $request->ShopId;
        if (is_array($items)) {
            $Type = $request->Type;
            foreach ($items as $item) {
                $entry = new ShopGoodsShowList([
                    'Type' => intval($Type),
                    'ShopId' => intval($item)
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
}
