<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\QuestGoodsCreateRequest;
use App\Models\QuestGoods;
use App\Models\ShopGoods;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanel;

/**
 * Class QuestGoodsCrudController
 * @package App\Http\Controllers\Admin
 * @property-read CrudPanel $crud
 */
class QuestGoodsCrudController extends CrudController
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
        $this->crud->setModel(\App\Models\QuestGoods::class);
        $QuestID = \Route::current()->parameter('quest_id');
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/quest/'.$QuestID.'/goods');
        //CRUD::setEntityNameStrings('Phần thưởng hoạt động', 'Phần thưởng hoạt động');
        $this->crud->addClause('where', 'QuestID', $QuestID);
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
                'name'  => 'RewardItemID',
                'label' => 'RewardItemID',
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
                'name'  => 'IsSelect',
                'label' => 'Chọn?',
                'type'  => 'check',
            ],
            [
                'name'  => 'RewardItemValid',
                'label' => 'Hạn',
                'type'  => 'number',
            ],
            [
                'name'  => 'RewardItemCount',
                'label' => 'Số lượng',
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
                'name'  => 'IsCount',
                'label' => 'IsCount',
                'type'  => 'check',
            ],
            [
                'name'  => 'IsBind',
                'label' => 'Khóa?',
                'type'  => 'check',
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
        $this->crud->setValidation(QuestGoodsCreateRequest::class);

        $QuestID = \Route::current()->parameter('quest_id');

        $this->crud->addFields([
            [
                'name'  => 'QuestID',
                'label' => "QuestID",
                'type'  => 'hidden',
                'value' => $QuestID
            ],
            [
                'name'  => 'RewardItemID',
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
//                'include_all_form_fields'  => false, // optional - only send the current field through AJAX (for a smaller payload if you're not using multiple chained select2s)
            ],
            [
                'name'  => 'IsSelect',
                'label' => 'Lựa chọn?',
                'type'  => 'checkbox',
            ],
            [
                'name'  => 'RewardItemValid',
                'label' => 'Hạn dùng (ngày)',
                'type'  => 'number',
                'default' => 0,
                'hint' => '0 = vĩnh viễn'
            ],
            [
                'name' => 'RewardItemCount',
                'label'=> 'Số lượng',
                'type' => 'number',
                'default' => 1,
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
                'name' => 'IsCount',
                'label'=> 'IsCount',
                'type' => 'checkbox',
                'default' => 1,
            ],
            [
                'name' => 'IsBind',
                'label'=> 'Khóa',
                'type' => 'checkbox',
                'default' => 1
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
        $items = $request->RewardItemID;
        if (is_array($items)) {
            $data = $this->crud->getStrippedSaveRequest();
            foreach ($items as $item) {
                $data = array_replace($data, ['RewardItemID' => $item]);
                $entry = new QuestGoods($data);
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
        $this->crud->setValidation(QuestGoodsCreateRequest::class);

        $id = \Route::current()->parameter('id');
        $goods = QuestGoods::with('Item')->find($id);
        $item = $goods->Item;
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
                'name'  => 'QuestID',
                'label' => "QuestID",
                'type'  => 'hidden',
            ],
            [
                'name'  => 'RewardItemID',
                'label' => "Item",
                'type'  => 'hidden',
            ],
            [
                'name'  => 'IsSelect',
                'label' => 'Lựa chọn?',
                'type'  => 'checkbox',
            ],
            [
                'name'  => 'RewardItemValid',
                'label' => 'Hạn dùng (ngày)',
                'type'  => 'number',
                'default' => 0,
                'hint' => '0 = vĩnh viễn'
            ],
            [
                'name' => 'RewardItemCount',
                'label'=> 'Số lượng',
                'type' => 'number',
                'default' => 1,
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
                'name' => 'IsCount',
                'label'=> 'IsCount',
                'type' => 'checkbox',
            ],
            [
                'name' => 'IsBind',
                'label'=> 'Khóa',
                'type' => 'checkbox',
                'default' => 1
            ],
        ]);
    }
}
