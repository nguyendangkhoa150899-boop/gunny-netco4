<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\TopRacingEventRequest;
use App\Models\TopRacingEvent;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class TopRacingEventCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class TopRacingEventCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation { store as public traitstore; }
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation { update as public traitupdate; }
    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
//    use \Backpack\CRUD\app\Http\Controllers\Operations\ShowOperation;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        CRUD::setModel(\App\Models\TopRacingEvent::class);
        CRUD::setRoute(config('backpack.base.route_prefix') . '/topracingevent');
        CRUD::setEntityNameStrings('topracingevent', 'top_racing_events');
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
                'name' => 'begin_time',
                'label' => 'Begin Date',
                'type' => 'date'
            ],
            [
                'name' => 'end_time',
                'label' => 'End Date',
                'type' => 'date'
            ],
            [
                'name' => 'active',
                'label' => 'Active',
                'type' => 'check'
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
    protected function setupCreateOperation()
    {
        CRUD::setValidation(TopRacingEventRequest::class);

        $this->crud->addFields([
            [
                'name' => 'id',
                'type' => 'hidden'
            ],
            [
                'name' => 'name',
                'label' => 'Name',
                'type' => 'text'
            ],
            [
                'name' => 'slug',
                'label' => 'Slug',
                'type' => 'text'
            ],
            [
                'name' => 'description',
                'label' => 'Description',
                'type' => 'textarea'
            ],
            [
                'name' => ['begin_time', 'end_time'],
                'label' => 'Time',
                'type' => 'date_range',
                'date_range_options' => [
                    'timePicker' => false,
                    'locale' => ['format' => 'DD/MM/YYYY']
                ]
            ],
            [
                'name' => 'active',
                'label' => 'Active',
                'type' => 'checkbox'
            ],
            [
                'name' => 'image',
                'label' => 'Popup image',
                'type' => 'image'
            ],
            [
                'name' => 'is_popup',
                'label' => 'Show popup on Home?',
                'type' => 'checkbox'
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

    public function store()
    {
        $this->crud->hasAccessOrFail('create');

        // execute the FormRequest authorization and validation, if one is required
        $request = $this->crud->validateRequest();

        if (!empty($request->get('is_popup'))) {
            $events = TopRacingEvent::currentPopingUpEvents();
            if (!empty($events) && $events->count()) {
                foreach ($events as $event) {
                    $event->is_popup = 0;
                    $event->save();
                }
            }
        }
        return $this->traitstore();
    }

    public function update()
    {
        $this->crud->hasAccessOrFail('update');

        // execute the FormRequest authorization and validation, if one is required
        $request = $this->crud->validateRequest();

        if (!empty($request->get('is_popup'))) {
            $events = TopRacingEvent::currentPopingUpEvents();
            if (!empty($events) && $events->count()) {
                foreach ($events as $event) {
                    if ($event->id != $request->get('id')) {
                        $event->is_popup = 0;
                        $event->save();
                    }
                }
            }
        }
        return $this->traitupdate();
    }
}
