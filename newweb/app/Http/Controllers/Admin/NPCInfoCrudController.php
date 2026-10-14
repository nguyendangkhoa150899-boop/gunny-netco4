<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\NPCInfoRequest;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class NPCInfoCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class NPCInfoCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
//    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
//    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\ShowOperation;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        CRUD::setModel(\App\Models\NPCInfo::class);
        CRUD::setRoute(config('backpack.base.route_prefix') . '/npcinfo');
        CRUD::setEntityNameStrings('npcinfo', 'Cấu hình NPC');
    }

    /**
     * Define what happens when the List operation is loaded.
     *
     * @see  https://backpackforlaravel.com/docs/crud-operation-list-entries
     * @return void
     */
    protected function setupListOperation()
    {
        CRUD::setFromDb(); // columns
        $this->crud->setColumns([
            [
                'name'  => 'ID',
                'label' => 'ID',
            ],
            [
                'name'  => 'Name',
                'label' => 'Tên',
            ],
            [
                'name'  => 'Level',
                'label' => 'Cấp NPC',
            ],
            [
                'name'  => 'Blood',
                'label' => 'Máu',
            ],
            [
                'name'  => 'MoveMin',
                'label' => 'Tốc độ di chuyển(min)',
            ],
            [
                'name'  => 'MoveMax',
                'label' => 'Tốc độ di chuyển(max)',
            ],
            [
                'name'  => 'BaseDamage',
                'label' => 'Sát thương cơ bản',
            ],
            [
                'name'  => 'BaseGuard',
                'label' => 'Giáp cơ bản',
            ],
            [
                'name'  => 'Defence',
                'label' => 'Phòng thủ',
            ],
            [
                'name'  => 'Agility',
                'label' => 'Nhanh nhẹn',
            ],
            [
                'name'  => 'Lucky',
                'label' => 'May mắn',
            ],
            [
                'name'  => 'Attack',
                'label' => 'Tấn công',
            ],

        ]);
        
        $this->crud->orderBy('ID', 'ASC');

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

        $this->crud->setValidation(NPCInfoRequest::class);

        $tab = 'Thông tin chung';
        $this->crud->addFields([
            [
                'name' => 'Name',
                'label' => 'Tên',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'text',
            ],
            [
                'name' => 'Blood',
                'label' => 'Máu',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'BaseDamage',
                'label' => 'Sát thương cơ bản',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'BaseGuard',
                'label' => 'Giáp cơ bản',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Defence',
                'label' => 'Phòng thủ',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Agility',
                'label' => 'Nhanh nhẹn',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Lucky',
                'label' => 'May mắn',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Attack',
                'label' => 'Tấn công',
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
    }

}
