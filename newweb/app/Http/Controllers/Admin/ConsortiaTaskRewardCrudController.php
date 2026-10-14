<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\ActiveAwardCreateRequest;
use App\Http\Requests\ActiveAwardUpdateRequest;
use App\Http\Requests\ActiveRequest;
use App\Http\Requests\ConsortiaRewardCreateRequest;
use App\Models\ActiveAward;
use App\Models\ConsortiaTaskReward;
use App\Models\ShopGoods;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;
use Illuminate\Support\Facades\DB;

/**
 * Class ActiveCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class ConsortiaTaskRewardCrudController extends CrudController
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
        CRUD::setModel(\App\Models\ConsortiaTaskReward::class);
        $level = \Route::current()->parameter('level');
        CRUD::setRoute(config('backpack.base.route_prefix') . '/consortialevels/'.$level.'/rewards');
        //CRUD::setEntityNameStrings('Phần thưởng hoạt động', 'Phần thưởng hoạt động');
        CRUD::addClause('where', 'Lv', $level);
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
                'name'  => 'ItemID',
                'label' => 'Item',
                'type'  => 'select',
                'entity'    => 'Item',
                'attribute' => 'Name',
                'model'     => ShopGoods::class
            ],
            [
                'name'  => 'Count',
                'label' => 'Count',
                'type'  => 'number',
            ],
            [
                'name'  => 'ValidDate',
                'label' => 'Date',
                'type'  => 'number',
            ],
            [
                'name'  => 'StrengthenLevel',
                'label' => '+',
                'type'  => 'number',
            ],
            [
                'name'  => 'Compose',
                'label' => 'Compose',
                'type'  => 'model_function',
                'function_name' => 'combine4Column'
            ],
            [
                'name'  => 'IsBind',
                'label' => 'Khóa?',
                'type'  => 'boolean',
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
        $this->crud->setValidation(ConsortiaRewardCreateRequest::class);

        $level = \Route::current()->parameter('level');

        $this->crud->addFields([
            [
                'name'  => 'Lv',
                'label' => "Lv",
                'type'  => 'hidden',
                'value' => $level
            ],
            [
                'name'  => 'ItemID',
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
                'name'  => 'Count',
                'label' => 'Count',
                'type'  => 'number',
                'default' => 1,
            ],
            [
                'name' => 'ValidDate',
                'label'=> 'ValidDate',
                'type' => 'number',
                'default' => 0,
            ],
            [
                'name' => 'StrengthenLevel',
                'label'=> 'StrengthenLevel',
                'type' => 'number',
                'default' => 0,
            ],
            [
                'name' => 'AttackCompose',
                'label'=> 'AttackCompose',
                'type' => 'number',
                'default' => 0,
            ],
            [
                'name' => 'DefendCompose',
                'label'=> 'DefendCompose',
                'type' => 'number',
                'default' => 0,
            ],
            [
                'name' => 'LuckCompose',
                'label'=> 'LuckCompose',
                'type' => 'number',
                'default' => 0,
            ],
            [
                'name' => 'AgilityCompose',
                'label'=> 'AgilityCompose',
                'type' => 'number',
                'default' => 0,
            ],
            [
                'name'  => 'IsBind',
                'label' => 'Khóa?',
                'type'  => 'boolean',
                'default' => 1,
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
        $items = $request->ItemID;
        if (is_array($items)) {
            DB::connection((new ConsortiaTaskReward)->getConnectionName())->beginTransaction();
            $data = [
                'Lv' => $request->Lv,
                'Count' => $request->Count,
                'ValidDate' => $request->ValidDate,
                'StrengthenLevel' => $request->StrengthenLevel,
                'AttackCompose' => $request->AttackCompose,
                'DefendCompose' => $request->DefendCompose,
                'LuckCompose' => $request->LuckCompose,
                'AgilityCompose' => $request->AgilityCompose,
                'isBind' => $request->isBind,
            ];
            foreach ($items as $item) {
                $data['ItemID'] = $item;
                $entry = new ConsortiaTaskReward($data);
                if (!$entry->save()) {
                    DB::connection((new ConsortiaTaskReward)->getConnectionName())->rollBack();
                    return response()->json(['message' => 'error'], 500);
                }
            }
            DB::connection((new ConsortiaTaskReward)->getConnectionName())->commit();
            return 1;
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
        $this->crud->setValidation(ConsortiaRewardCreateRequest::class);

        $level = \Route::current()->parameter('level');
        $rewardId = \Route::current()->parameter('id');
        $reward = ConsortiaTaskReward::with('Item')->find($rewardId);
        $item = $reward->Item;
        $image = $item->ResourceImageColumn();
        $this->crud->image_title = $image;
        $this->crud->entity_name = $item->Name;

        $this->crud->addFields([
            [
                'name'  => 'ID',
                'label' => "ID",
                'type'  => 'hidden',
            ],
            [
                'name'  => 'Lv',
                'label' => "Lv",
                'type'  => 'hidden',
            ],
            [
                'name'  => 'ItemID',
                'label' => "ItemID",
                'type'  => 'hidden',
            ],
            [
                'name'  => 'Count',
                'label' => 'Count',
                'type'  => 'number',
            ],
            [
                'name' => 'ValidDate',
                'label'=> 'ValidDate',
                'type' => 'number',
            ],
            [
                'name' => 'StrengthenLevel',
                'label'=> 'StrengthenLevel',
                'type' => 'number',
            ],
            [
                'name' => 'AttackCompose',
                'label'=> 'AttackCompose',
                'type' => 'number',
            ],
            [
                'name' => 'DefendCompose',
                'label'=> 'DefendCompose',
                'type' => 'number',
            ],
            [
                'name' => 'LuckCompose',
                'label'=> 'LuckCompose',
                'type' => 'number',
            ],
            [
                'name' => 'AgilityCompose',
                'label'=> 'AgilityCompose',
                'type' => 'number',
            ],
            [
                'name'  => 'IsBind',
                'label' => 'Khóa?',
                'type'  => 'boolean',
            ],
        ]);
    }
}
