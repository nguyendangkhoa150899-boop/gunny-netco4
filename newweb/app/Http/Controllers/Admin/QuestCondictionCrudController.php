<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\QuestCondictionCreateRequest;
use App\Http\Requests\QuestGoodsCreateRequest;
use App\Models\QuestCondiction;
use App\Models\QuestGoods;
use App\Models\ShopGoods;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanel;

/**
 * Class QuestGoodsCrudController
 * @package App\Http\Controllers\Admin
 * @property-read CrudPanel $crud
 */
class QuestCondictionCrudController extends CrudController
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
        $this->crud->setModel(\App\Models\QuestCondiction::class);
        $QuestID = \Route::current()->parameter('quest_id');
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/quest/'.$QuestID.'/condiction');
        //CRUD::setEntityNameStrings('Phần thưởng hoạt động', 'Phần thưởng hoạt động');
        $this->crud->addClause('where', 'QuestID', $QuestID);
        $this->crud->orderBy('CondictionID', 'ASC');
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
                'name'  => 'CondictionID',
                'label' => 'CondictionID',
                'type'  => 'number',
            ],
            [
                'name'  => 'CondictionTitle',
                'label' => 'CondictionTitle',
                'type'  => 'text',
            ],
            [
                'name'  => 'Para1',
                'label' => 'Para1',
                'type'  => 'number',
            ],
            [
                'name'  => 'Para2',
                'label' => 'Para2',
                'type'  => 'number',
            ],
            [
                'name'  => 'isOpitional',
                'label' => 'isOpitional',
                'type'  => 'check',
            ]
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
        $this->crud->setValidation(QuestCondictionCreateRequest::class);

        $QuestID = \Route::current()->parameter('quest_id');

        $this->crud->addFields([
            [
                'name'  => 'QuestID',
                'label' => "QuestID",
                'type'  => 'hidden',
                'value' => $QuestID
            ],
            [
                'name'  => 'CondictionType',
                'label' => 'Loại điều kiện',
                'type'        => 'select2_from_array',
                'options'     => QuestCondiction::CondictionText(),
                'allows_null' => false,
                'default'     => 0,
                'parent' => 'createModalQuestCondiction'
            ],
            [
                'name'  => 'CondictionID',
                'label' => 'Thứ tự của điều kiện',
                'type'        => 'number',
                'default'     => 0,
            ],
            [
                'name'  => 'CondictionTitle',
                'label' => 'Tiêu đề điều kiện',
                'type'  => 'text',
                'default' => '',
                'maxlength' => 150
            ],
            [
                'name' => 'Para1',
                'label'=> 'Para1',
                'type' => 'number',
                'default' => 0,
                'hint' => 'ID của vật phẩm/NPC/Phó bản'
            ],
            [
                'name' => 'Para2',
                'label'=> 'Para2',
                'type' => 'number',
                'default' => 0,
                'hint' => 'Số lần hoàn thành/điều kiện hoàn thành'
            ],
            [
                'name' => 'isOpitional',
                'label'=> 'isOpitional',
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
    protected function setupNestedUpdateOperation()
    {
        $this->crud->setValidation(QuestCondictionCreateRequest::class);

        $id = \Route::current()->parameter('id');
        $condiction = QuestCondiction::find($id);
        $this->crud->entity_name = $condiction->CondictionTitle;

        $this->crud->addFields([
            [
                'name'  => 'QuestID',
                'label' => "QuestID",
                'type'  => 'hidden',
            ],
            [
                'name'  => 'CondictionType',
                'label' => 'Loại điều kiện',
                'type'        => 'select2_from_array',
                'options'     => QuestCondiction::CondictionText(),
                'allows_null' => false,
                'default'     => 0,
                'parent' => 'editModalQuestCondiction'
            ],
            [
                'name'  => 'CondictionID',
                'label' => 'Thứ tự của điều kiện',
                'type'        => 'number',
                'default'     => 0,
            ],
            [
                'name'  => 'CondictionTitle',
                'label' => 'Tiêu đề điều kiện',
                'type'  => 'text',
                'default' => '',
                'maxlength' => 150
            ],
            [
                'name' => 'Para1',
                'label'=> 'Para1',
                'type' => 'number',
                'default' => 0,
                'hint' => 'ID của vật phẩm/NPC/Phó bản'
            ],
            [
                'name' => 'Para2',
                'label'=> 'Para2',
                'type' => 'number',
                'default' => 0,
                'hint' => 'Số lần hoàn thành/điều kiện hoàn thành'
            ],
            [
                'name' => 'isOpitional',
                'label'=> 'isOpitional',
                'type' => 'checkbox',
                'default' => 0
            ],
        ]);
    }
}
