<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\TopRacingAwardRequest;
use App\Models\ShopGoods;
use App\Models\TopRacing;
use App\Models\TopRacingAward;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class TopRacingAwardCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class TopRacingAwardCrudController extends CrudController
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
        CRUD::setModel(\App\Models\TopRacingAward::class);
        $topRacingId = \Route::current()->parameter('top_racing_id');
        CRUD::setRoute(config('backpack.base.route_prefix') . '/topracing/'.$topRacingId.'/award');
//        CRUD::setEntityNameStrings('Phần thưởng đua top', 'Phần thưởng đua top');
        CRUD::addClause('where', 'top_id', $topRacingId);
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
                'name' => 'rank',
                'label' => '#',
                'type' => 'text'
            ],
            [
                'name' => 'item_id',
                'label' => 'Item',
                'type' => 'select',
                'entity'    => 'Item', // the method that defines the relationship in your Model
                'attribute' => 'Name', // foreign key attribute that is shown to user
                'model'     => ShopGoods::class, // foreign key model
            ],
            [
                'name' => 'count',
                'label' => 'Count',
                'type' => 'number'
            ],
            [
                'name' => 'date',
                'label' => 'Date',
                'type' => 'number'
            ],
            [
                'name' => 'composes',
                'label' => 'Compose',
                'type' => 'text'
            ],
            [
                'name'  => 'Image',
                'label' => 'Image',
                'type'  => 'model_function',
                'function_name' => 'ResourceImageColumn',
                'limit' => 999,
            ],
            [
                'name' => 'enabled',
                'label' => 'Enabled',
                'type' => 'check'
            ],
        ]);
        $this->crud->orderBy('rank');
        $this->crud->orderBy('stt');

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
        $this->crud->setValidation(TopRacingAwardRequest::class);
        $TopRacingId = \Route::current()->parameter('top_racing_id');

        $this->crud->addFields([
            [
                'name' => 'id',
                'type' => 'hidden'
            ],
            [
                'name' => 'top_id',
                'type' => 'hidden',
                'value' => $TopRacingId
            ],
            [
                'name' => 'rank',
                'label' => '#',
                'type' => 'text'
            ],
            [
                'name'  => 'item_id',
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
                'name' => 'count',
                'label' => 'Count',
                'type' => 'number'
            ],
            [
                'name' => 'date',
                'label' => 'Date',
                'type' => 'number'
            ],
            [
                'name' => 'composes',
                'label' => 'Compose',
                'type' => 'text'
            ],
            [
                'name' => 'stt',
                'label' => 'STT',
                'type' => 'number'
            ],
            [
                'name' => 'enabled',
                'label' => 'Enabled',
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
    protected function setupNestedUpdateOperation()
    {
        $this->crud->setValidation(TopRacingAwardRequest::class);
        $TopRacingId = \Route::current()->parameter('top_racing_id');
        $awardId = \Route::current()->parameter('id');
        $award = TopRacingAward::with('Item')->find($awardId);
        $item = $award->Item;
        $image = $item->ResourceImageColumn();
        $this->crud->image_title = $image;
        $this->crud->entity_name = $item->Name;

        $this->crud->addFields([
            [
                'name' => 'id',
                'type' => 'hidden',
                //'value' => $awardId
            ],
            [
                'name' => 'top_id',
                'type' => 'hidden',
                //'value' => $TopRacingId
            ],
            [
                'name' => 'rank',
                'label' => '#',
                'type' => 'text'
            ],
            [
                'name'  => 'item_id',
                'label' => "ItemID",
                'type'  => 'hidden',
            ],
            [
                'name' => 'count',
                'label' => 'Count',
                'type' => 'number'
            ],
            [
                'name' => 'date',
                'label' => 'Date',
                'type' => 'number'
            ],
            [
                'name' => 'composes',
                'label' => 'Compose',
                'type' => 'text'
            ],
            [
                'name' => 'stt',
                'label' => 'STT',
                'type' => 'number'
            ],
            [
                'name' => 'enabled',
                'label' => 'Enabled',
                'type' => 'checkbox'
            ],
        ]);
    }

    public function nestedStore()
    {
        $this->crud->hasAccessOrFail('create');

        // execute the FormRequest authorization and validation, if one is required
        $request = $this->crud->validateRequest();
        $items = $request->get('item_id');
        if (is_array($items)) {
            $top_id = $request->get('top_id');
            $count = $request->get('count');
            $rank = $request->get('rank');
            $date = $request->get('date');
            $composes = $request->get('composes');
            $enabled = $request->get('enabled');
            $stt = $request->get('stt');

            foreach ($items as $item) {
                $entry = new TopRacingAward([
                    'top_id' => $top_id,
                    'rank' => $rank,
                    'item_id' => $item,
                    'count' => $count,
                    'date' => $date,
                    'composes' => $composes,
                    'enabled' => $enabled,
                    'stt' => $stt,
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

    public function nestedUpdate()
    {
        $this->crud->hasAccessOrFail('update');

        // execute the FormRequest authorization and validation, if one is required
        $request = $this->crud->validateRequest();
        $entry = TopRacingAward::findOrFail($request->get('id'));
        $entry->rank = $request->get('rank');
        $entry->count = $request->get('count');
        $entry->date = $request->get('date');
        $entry->composes = $request->get('composes');
        $entry->enabled = $request->get('enabled');
        $entry->stt = $request->get('stt');
        $entry->save();
        $this->crud->entry = $entry;
        return $entry->getKey();
    }
}
