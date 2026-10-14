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
class UserMessagesCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\ShowOperation;

    protected $columns = [
        [
            'name'  => 'Sender',
            'label' => 'Người gửi',
            'type'  => 'text',
            'orderable' => false
        ],
        [
            'name'  => 'Receiver',
            'label' => 'Người nhận',
            'type'  => 'text',
            'orderable' => false
        ],
        [
            'name'  => 'Title',
            'label' => 'Tiêu đề',
            'type'  => 'text',
            'orderable' => false
        ],
        [
            'name'  => 'Remark',
            'label' => 'Remark',
            'type'  => 'text',
            'orderable' => false
        ],
        [
            'name'  => 'AnnexRemark',
            'label' => 'Đính kèm',
            'type'  => 'text',
            'orderable' => false
        ],
        [
            'name'  => 'SendDate',
            'label' => 'Ngày gửi',
            'type'  => 'text',
        ],
        [
            'name'  => 'SendTime',
            'label' => 'Ngày nhận',
            'type'  => 'text',
        ],
    ];
    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        CRUD::setModel(\App\Models\UserMessage::class);
        CRUD::setRoute(config('backpack.base.route_prefix') . '/user_messages');
        CRUD::setEntityNameStrings('user_messages', 'user_messages');
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
        $this->crud->orderBy('ID', 'DESC');
        $this->crud->addFilter([
            'type'  => 'text',
            'name'  => 'ReceiverID',
            'label' => 'ID nhận'
        ],
            false,
            function($value) { // if the filter is active
                $this->crud->addClause('where', 'ReceiverID', '=', $value);
            });
        $this->crud->addFilter([
            'type'  => 'text',
            'name'  => 'Receiver',
            'label' => 'Tên nhận'
        ],
            false,
            function($value) { // if the filter is active
                $this->crud->addClause('where', 'Receiver', 'LIKE', "%$value%");
            });
        $this->crud->addFilter([
            'type'  => 'text',
            'name'  => 'SenderID',
            'label' => 'ID gửi'
        ],
            false,
            function($value) { // if the filter is active
                $this->crud->addClause('where', 'SenderID', '=', $value);
            });
        $this->crud->addFilter([
            'type'  => 'text',
            'name'  => 'Sender',
            'label' => 'Tên gửi'
        ],
            false,
            function($value) { // if the filter is active
                $this->crud->addClause('where', 'Sender', 'LIKE', "%$value%");
            });
        /**
         * Columns can be defined using the fluent syntax or array syntax:
         * - CRUD::column('price')->type('number');
         * - CRUD::addColumn(['name' => 'price', 'type' => 'number']);
         */
    }

//    protected function setupShowOperation()
//    {
//        $this->crud->addColumns($this->columns);
//    }
}
