<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\ItemStrengthenRequest;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class ItemStrengthenCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class ItemStrengthenCrudController extends CrudController
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
        CRUD::setModel(\App\Models\ItemStrengthen::class);
        CRUD::setRoute(config('backpack.base.route_prefix') . '/itemstrengthen');
        CRUD::setEntityNameStrings('itemstrengthen', 'Tỉ lệ cường hóa');
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
                'name'  => 'StrengthenLevel',
                'label' => 'Cấp độ',
            ],
            [
                'name'  => 'Rock',
                'label' => 'Tỉ lệ chung',
            ],
            [
                'name'  => 'Rock1',
                'label' => 'Tỉ lệ ô đá 1',
            ],
            [
                'name'  => 'Rock2',
                'label' => 'Tỉ lệ ô đá 2',
            ],
            [
                'name'  => 'Rock3',
                'label' => 'Tỉ lệ ô đá 3',
            ],
            [
                'name'  => 'StoneLevelMin',
                'label' => 'Cấp độ đá tối thiểu',
            ],

        ]);
        
        $this->crud->orderBy('StrengthenLevel', 'ASC');

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

        $this->crud->setValidation(ItemStrengthenRequest::class);

        $tab = 'Thông tin chung';
        $this->crud->addFields([
            [
                'name' => 'StrengthenLevel',
                'label' => 'Cấp độ',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Rock',
                'label' => 'Tỉ lệ chung',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Random',
                'label' => 'Tỉ lệ mặc định',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Rock1',
                'label' => 'Tỉ lệ ô đá 1',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Rock2',
                'label' => 'Tỉ lệ ô đá 2',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'Rock3',
                'label' => 'Tỉ lệ ô đá 3',
                'value' => null,
                'default' => null,
                'tab' => 'Properties',
                'type' => 'number',
            ],
            [
                'name' => 'StoneLevelMin',
                'label' => 'Cấp độ đá tối thiểu',
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
