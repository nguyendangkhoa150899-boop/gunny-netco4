<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\TopRacingRequest;
use App\Models\TopRacingAward;
use App\Models\TopRacingEvent;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class TopRacingCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class TopRacingCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
//    use \Backpack\CRUD\app\Http\Controllers\Operations\ShowOperation;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        CRUD::setModel(\App\Models\TopRacing::class);
        CRUD::setRoute(config('backpack.base.route_prefix') . '/topracing');
        CRUD::setEntityNameStrings('hạng mục', 'Hạng mục đua top');
    }

    /**
     * Define what happens when the List operation is loaded.
     *
     * @see  https://backpackforlaravel.com/docs/crud-operation-list-entries
     * @return void
     */
    protected function setupListOperation()
    {
        $this->crud->addColumns([
            [
                'name' => 'id',
                'label' => 'ID',
                'type' => 'number'
            ],
            [
                'name' => 'name',
                'label' => 'Name',
                'type' => 'text'
            ],
            [
                'name' => 'event_id',
                'label' => 'Event',
                'type' => 'select',
                'entity'    => 'topRacingEvent', // the method that defines the relationship in your Model
                'attribute' => 'name', // foreign key attribute that is shown to user
                'model'     => TopRacingEvent::class, // foreign key model
            ],
            [
                'name' => 'show',
                'label' => 'Is Show',
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
    protected function setupCreateOperation()
    {
        CRUD::setValidation(TopRacingRequest::class);

        $this->crud->addFields([
            [
                'name' => 'id',
                'type' => 'hidden',
            ],
            [
                'name' => 'name',
                'label' => 'Name',
                'type' => 'text',
            ],
            [
                'name' => 'event_id',
                'label' => 'Event',
                'type' => 'select2',
                'entity'    => 'topRacingEvent', // the method that defines the relationship in your Model
                'model'     => TopRacingEvent::class, // foreign key model
                'attribute' => 'name', // foreign key attribute that is shown to user
                'allows_null' => false,
            ],
            [
                'name' => 'show',
                'label' => 'Is Show',
                'type' => 'checkbox',
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
            'name'      => 'awards',
            'label'     => 'Phần thưởng',
            'type'      => 'nested_crud',
            'target'    => 'award',
            'model'     => TopRacingAward::class,
            'tab'       => 'Phần thưởng',  // optional
        ]);
    }
}
