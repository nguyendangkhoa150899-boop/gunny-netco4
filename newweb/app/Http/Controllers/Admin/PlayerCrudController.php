<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\PlayerRequest;
use App\Models\Consortia;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;
use Illuminate\Support\Arr;
use Illuminate\Support\Facades\DB;

/**
 * Class PlayerCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class PlayerCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
//    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
    //use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
    //use \Backpack\CRUD\app\Http\Controllers\Operations\ShowOperation;

    protected $columns = [
        [
            'name'  => 'UserID',
            'label' => 'UserID',
            'type'  => 'number',
        ],
        [
            'name'  => 'UserName',
            'label' => 'UserName',
            'type'  => 'text',
        ],
        [
            'name'  => 'NickName',
            'label' => 'NickName',
            'type'  => 'text',
        ],
        [
            'name'  => 'Grade',
            'label' => 'Grade',
            'type'  => 'number',
        ],
        [
            'name'  => 'Win',
            'label' => 'Win',
            'type'  => 'number',
        ],
        [
            'name'  => 'Total',
            'label' => 'Total',
            'type'  => 'number',
        ],
        [
            'name'  => 'Money',
            'label' => 'Money',
            'type'  => 'number',
        ],
    ];
    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        CRUD::setModel(\App\Models\Player::class);
        CRUD::setRoute(config('backpack.base.route_prefix') . '/player');
        CRUD::setEntityNameStrings('player', 'players');
    }

    /**
     * Define what happens when the List operation is loaded.
     *
     * @see  https://backpackforlaravel.com/docs/crud-operation-list-entries
     * @return void
     */
    protected function setupListOperation()
    {
        $this->crud->addColumns($this->columns); // columns
        $this->crud->orderBy('UserID', 'ASC');

        /**
         * Columns can be defined using the fluent syntax or array syntax:
         * - CRUD::column('price')->type('number');
         * - CRUD::addColumn(['name' => 'price', 'type' => 'number']);
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
        $this->crud->addFields([
            [
                'name'  => 'UserID',
                'label' => "UserID",
                'type'  => 'hidden',
            ],
            [
                'name'  => 'UserName',
                'label' => "UserName",
                'type'  => 'text',
                'tab' => 'Thông tin chung',
            ],
            [
                'name'  => 'NickName',
                'label' => "NickName",
                'type'  => 'text',
                'tab' => 'Thông tin chung',
            ],
            [
                'name'  => 'UserName',
                'label' => "UserName",
                'type'  => 'text',
                'tab' => 'Thông tin chung',
            ],
            [
                'name'  => 'Sex',
                'label' => "Sex",
                'type' => 'select_from_array',
                'options' => [0 => 'Nữ', 1 => 'Nam'],
                'allows_null' => false,
                'tab' => 'Thông tin chung',
            ],
            [
                'name'  => 'Grade',
                'label' => "Grade",
                'type'  => 'number',
                'tab' => 'Thông tin chung',
            ],
            [
                'name'  => 'Win',
                'label' => "Win",
                'type'  => 'number',
                'tab' => 'Thông tin chung',
            ],
            [
                'name'  => 'Total',
                'label' => "Total war",
                'type'  => 'number',
                'tab' => 'Thông tin chung',
            ],
            [
                'name'  => 'GP',
                'label' => "GP (Exp)",
                'type'  => 'number',
                'tab' => 'Thông tin chung',
            ],
            [
                'name'  => 'Money',
                'label' => "Money",
                'type'  => 'number',
                'tab' => 'Thông tin chung',
            ],
            [
                'name'  => 'OnlineTime',
                'label' => "OnlineTime",
                'type'  => 'number',
                'tab' => 'Thông tin chung',
            ],
            [
                'name'  => 'Consortia',
                'label' => "Consortia",
                'type'  => 'select2',
                'entity'    => 'Consortia',
                'attribute' => 'ConsortiaName',
                'model'     => Consortia::class,
                'allows_null' => true,
                'tab' => 'Thông tin chung',
            ],
        ]);
    }

    protected function setupShowOperation()
    {

    }

    public function show($id)
    {

    }

    public function search()
    {
        $this->crud->hasAccessOrFail('list');

        $this->crud->applyUnappliedFilters();

        $totalRows = $this->crud->model->count();
        $filteredRows = $this->crud->query->toBase()->getCountForPagination();
        $startIndex = request()->input('start') ?: 0;
        // if a search term was present
        if (request()->input('search') && request()->input('search')['value']) {
            // filter the results accordingly
            $this->crud->applySearchTerm(request()->input('search')['value']);
            // recalculate the number of filtered rows
            $filteredRows = $this->crud->count();
        }
        // start the results according to the datatables pagination
        if (request()->input('start')) {
            $this->crud->skip((int) request()->input('start'));
        }
        // limit the number of results according to the datatables pagination
        if (request()->input('length')) {
            $this->crud->take((int) request()->input('length'));
        }
        // overwrite any order set in the setup() method with the datatables order
        if (request()->input('order')) {
            // clear any past orderBy rules
            $this->crud->query->getQuery()->orders = null;
            foreach ((array) request()->input('order') as $order) {
                $column_number = (int) $order['column'];
                $column_direction = (strtolower((string) $order['dir']) == 'asc' ? 'ASC' : 'DESC');
                $column = $this->crud->findColumnById($column_number);
                if ($column['tableColumn'] && ! isset($column['orderLogic'])) {
                    // apply the current orderBy rules
                    $this->crud->orderByWithPrefix($column['name'], $column_direction);
                }

                // check for custom order logic in the column definition
                if (isset($column['orderLogic'])) {
                    $this->crud->customOrderBy($column, $column_direction);
                }
            }
        }
        $this->crud->query->getQuery()->select(array_column($this->columns, 'name'));

        // show newest items first, by default (if no order has been set for the primary column)
        // if there was no order set, this will be the only one
        // if there was an order set, this will be the last one (after all others were applied)
        // Note to self: `toBase()` returns also the orders contained in global scopes, while `getQuery()` don't.
        $orderBy = $this->crud->query->toBase()->orders;
        $table = $this->crud->model->getTable();
        $key = $this->crud->model->getKeyName();

        $hasOrderByPrimaryKey = collect($orderBy)->some(function ($item) use ($key, $table) {
            return (isset($item['column']) && $item['column'] === $key)
                || (isset($item['sql']) && str_contains($item['sql'], "$table.$key"));
        });

        if (! $hasOrderByPrimaryKey) {
            $this->crud->orderByWithPrefix($this->crud->model->getKeyName(), 'DESC');
        }

        $entries = $this->crud->getEntries();

        return $this->crud->getEntriesAsJsonForDatatables($entries, $totalRows, $filteredRows, $startIndex);
    }

    public function edit($id)
    {
        $this->crud->hasAccessOrFail('update');
        // get entry ID from Request (makes sure its the last ID for nested resources)
        $id = $this->crud->getCurrentEntryId() ?? $id;
        $entry = $this->crud->getModel()->select('UserID', 'UserName', 'NickName', 'Date', 'IsConsortia', 'ConsortiaID', 'Sex', 'Win', 'Total', 'Escape', 'GP', 'Honor', 'Gold', 'Money', 'Style', 'Colors', 'Hide', 'Grade', 'State', 'ActiveIP', 'Skin', 'Offer', 'IsExist', 'OnlineTime', 'IsMarried', 'SpouseID', 'SpouseName', 'MarryInfoID', 'IsCreatedMarryRoom', 'PasswordTwo', 'SelfMarryRoomID', 'IsGotRing', 'GiftToken', 'PvePermission', 'FightLabPermission', 'FightPower', 'AchievementPoint', 'IsShowConsortia', 'masterID', 'masterOrApprentices', 'graduatesCount', 'Medal', 'Score', 'badLuckNumber', 'LastGetEgg', 'IsFistGetPet', 'LastRefreshPet', 'petScore', 'honorId', 'LoginDevice')
            ->findOrFail($id);
        $this->crud->entry = $entry;
        $this->crud->setOperationSetting('fields', $this->crud->getUpdateFields());
        // get the info for that entry
        $this->data['entry'] = $entry;
        $this->data['crud'] = $this->crud;
        $this->data['saveAction'] = $this->crud->getSaveAction();
        $this->data['title'] = $this->crud->getTitle() ?? trans('backpack::crud.edit').' '.$this->crud->entity_name;

        $this->data['id'] = $id;

        // load the view from /resources/views/vendor/backpack/crud/ if it exists, otherwise load the one in the package
        return view($this->crud->getEditView(), $this->data);
    }

    public function update()
    {
        $this->crud->hasAccessOrFail('update');

        // execute the FormRequest authorization and validation, if one is required
        $request = $this->crud->validateRequest();
        // update the row in the db
        $item = $this->crudUpdate($request->get($this->crud->model->getKeyName()),
            $this->crud->getStrippedSaveRequest());
        $this->data['entry'] = $this->crud->entry = $item;

        // show a success message
        \Alert::success(trans('backpack::crud.update_success'))->flash();

        // save the redirect choice for next time
        $this->crud->setSaveAction();

        return $this->crud->performSaveAction($item->getKey());
    }

    public function crudUpdate($id, $data)
    {
        $data = $this->crud->decodeJsonCastedAttributes($data);
        $data = $this->crud->compactFakeFields($data);
        $item = $this->crud->getModel()->select('UserID', 'UserName', 'NickName', 'Date', 'IsConsortia', 'ConsortiaID', 'Sex', 'Win', 'Total', 'Escape', 'GP', 'Honor', 'Gold', 'Money', 'Style', 'Colors', 'Hide', 'Grade', 'State', 'ActiveIP', 'Skin', 'Offer', 'IsExist', 'OnlineTime', 'IsMarried', 'SpouseID', 'SpouseName', 'MarryInfoID', 'IsCreatedMarryRoom', 'PasswordTwo', 'SelfMarryRoomID', 'IsGotRing', 'GiftToken', 'PvePermission', 'FightLabPermission', 'FightPower', 'AchievementPoint', 'IsShowConsortia', 'masterID', 'masterOrApprentices', 'graduatesCount', 'Medal', 'Score', 'badLuckNumber', 'LastGetEgg', 'IsFistGetPet', 'LastRefreshPet', 'petScore', 'honorId', 'LoginDevice')
            ->findOrFail($id);

        $this->crud->createRelations($item, $data);

        // omit the n-n relationships when updating the eloquent item
        $nn_relationships = Arr::pluck($this->crud->getRelationFieldsWithPivot(), 'name');

        $data = Arr::except($data, $nn_relationships);

        $updated = $item->update($data);

        return $item;
    }
}
