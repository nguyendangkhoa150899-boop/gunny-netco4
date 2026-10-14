<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\ActiveAwardCreateRequest;
use App\Http\Requests\ActiveAwardUpdateRequest;
use App\Http\Requests\ActiveRequest;
use App\Http\Requests\ConsortiaTaskCreateRequest;
use App\Models\ActiveAward;
use App\Models\ConsortiaTaskConfig;
use App\Models\QuestCondiction;
use App\Models\ShopGoods;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class ActiveCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class ConsortiaTaskCrudController extends CrudController
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
        $this->crud->setModel(\App\Models\ConsortiaTaskConfig::class);
        $level = \Route::current()->parameter('level');
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/consortialevels/'.$level.'/tasks');
        $this->crud->addClause('where', 'Level', $level);
        $this->crud->limit(999);
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
                'name'      => 'row_number',
                'type'      => 'nested_crud_row_number',
                'label'     => '#',
                'orderable' => false,
            ],
            [
                'name'  => 'CondictionTitle',
                'label' => 'CondictionTitle',
                'type'  => 'text',
            ],
            [
                'name'  => 'CondictionType',
                'label' => 'CondictionType',
                'type'  => 'model_function',
                'function_name' => 'CondictionTypeText'
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
        $this->crud->setValidation(ConsortiaTaskCreateRequest::class);

        $level = \Route::current()->parameter('level');

        $this->crud->addFields([
            [
                'name'  => 'Level',
                'label' => "Level",
                'type'  => 'hidden',
                'value' => $level
            ],
            [
                'name'  => 'CondictionTitle',
                'label' => "CondictionTitle",
                'type'  => 'text',
            ],
            [
                'name'  => 'CondictionType',
                'label' => 'CondictionType',
                'type'        => 'select2_from_array',
                'options'     => QuestCondiction::CondictionText(),
                'allows_null' => false,
                'default'     => 0,
                'parent' => 'createModalConsortiaTaskConfig'
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
        $this->crud->setValidation(ConsortiaTaskCreateRequest::class);

        $level = \Route::current()->parameter('level');
        $id = \Route::current()->parameter('id');
        $task = ConsortiaTaskConfig::find($id);
        $this->crud->entity_name = $task->CondictionTitle;

        $this->crud->addFields([
            [
                'name'  => 'Level',
                'label' => "Level",
                'type'  => 'hidden',
                'value' => $level
            ],
            [
                'name'  => 'CondictionTitle',
                'label' => "CondictionTitle",
                'type'  => 'text',
            ],
            [
                'name'  => 'CondictionType',
                'label' => 'CondictionType',
                'type'        => 'select2_from_array',
                'options'     => QuestCondiction::CondictionText(),
                'allows_null' => false,
                'default'     => 0,
                'parent' => 'editModalConsortiaTaskConfig'
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
        ]);
    }
}
