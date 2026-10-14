<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\CardChargedRequest;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class CardChargedCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class CardChargedCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        CRUD::setModel(\App\Models\CardCharged::class);
        CRUD::setRoute(config('backpack.base.route_prefix') . '/cardcharged');
        CRUD::setEntityNameStrings('cardcharged', trans('cardcharged.card_chargeds'));
    }

    /**
     * Define what happens when the List operation is loaded.
     *
     * @see  https://backpackforlaravel.com/docs/crud-operation-list-entries
     * @return void
     */
    protected function setupListOperation()
    {
        $columns = [
            [
                'name'  => 'UserName',
                'label' => trans('member.Email'),
                'type'  => 'text',
            ],
            [
                'name'  => 'NameCard',
                'label' => trans('cardcharged.NameCard'),
                'type'  => 'text',
            ],
            [
                'name'  => 'Money',
                'label' => trans('cardcharged.Money'),
                'type'  => 'number',
            ],
            [
                'name'  => 'Seri',
                'label' => trans('cardcharged.Seri'),
                'type'  => 'text'
            ],
            [
                'name'  => 'Passcard',
                'label' => trans('cardcharged.Passcard'),
                'type'  => 'text'
            ],
        ];
        if (backpack_user()->hasRole('Administrators')) {
            $columns[] = [
                'name'  => 'TaskID',
                'label' => trans('cardcharged.TaskID'),
                'type'  => 'text'
            ];
        }
        $columns[] = [
            'name'  => 'Timer',
            'label' => trans('cardcharged.Timer'),
            'type'  => 'text'
        ];
        $columns[] = [
            'name'  => 'status',
            'label' => trans('cardcharged.Status'),
            'type'  => 'text',
            'escaped' => false
        ];
        $this->crud->setColumns($columns);
        //$this->crud->orderBy('Timer', 'DESC');
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

        if ($hasOrderByPrimaryKey) {
            $this->crud->orderByWithPrefix($this->crud->model->getKeyName(), 'DESC');
        }

        $entries = $this->crud->getEntries();

        return $this->crud->getEntriesAsJsonForDatatables($entries, $totalRows, $filteredRows, $startIndex);
    }
}
