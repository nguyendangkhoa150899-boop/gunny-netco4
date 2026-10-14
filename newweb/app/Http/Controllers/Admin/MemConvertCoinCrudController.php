<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\CardChargedRequest;
use App\Models\Member;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class CardChargedCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class MemConvertCoinCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        CRUD::setModel(\App\Models\MemHistory::class);
        CRUD::setRoute(config('backpack.base.route_prefix') . '/memconvertcoin');
        CRUD::setEntityNameStrings('memconvertcoin', 'Lịch sử chuyển xu');
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
                'name' => 'Email',
                'type' => 'relationship',
                'label'        => 'Tài khoản',
                'attribute' => 'Email',
                'entity'    => 'Member',
                'model'     => Member::class
            ],
            [
                'name' => 'Value',
                'label' => 'Coin',
                'type' => 'number',
            ],
            [
                'name' => 'Content',
                'label' => 'Nội dung',
                'type' => 'text',
                'limit' => 70
            ],
            [
                'name' => 'time',
                'label' => 'Thời gian',
                'type' => 'model_function',
                'function_name' => 'created_at'
            ],
        ];
        $this->crud->setColumns($columns);
        $this->crud->orderBy('TimeCreate', 'DESC');
        $this->crud->addClause('where', 'TypeCode', 3);
    }
}
