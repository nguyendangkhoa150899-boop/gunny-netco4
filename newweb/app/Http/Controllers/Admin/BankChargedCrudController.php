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
class BankChargedCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        CRUD::setModel(\App\Models\PaymentACBHistory::class);
        CRUD::setRoute(config('backpack.base.route_prefix') . '/bankcharged');
        CRUD::setEntityNameStrings('bankcharged', 'Lịch sử nạp ACB');
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
                'name' => 'transactionID',
                'label' => 'Transaction',
                'type' => 'text',
            ],
            [
                'name' => 'amount',
                'label' => 'Số tiền',
                'type' => 'number',
            ],
            [
                'name' => 'description',
                'label' => 'Nội dung',
                'type' => 'text',
                'limit' => 70
            ],
            [
                'name' => 'created_at',
                'label' => 'Thời gian',
                'type' => 'text',
            ],
        ];
        $this->crud->setColumns($columns);
        $this->crud->orderBy('created_at', 'DESC');
    }
}
