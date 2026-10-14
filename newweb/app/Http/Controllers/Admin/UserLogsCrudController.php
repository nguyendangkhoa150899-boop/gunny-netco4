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
class UserLogsCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;

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
            'orderable' => false
        ],
        [
            'name'  => 'NickName',
            'label' => 'NickName',
            'type'  => 'text',
            'orderable' => false
        ],
        [
            'name'  => 'Type',
            'label' => 'Type',
            'type'  => 'text',
            'orderable' => false
        ],
        [
            'name'  => 'Content',
            'label' => 'Content',
            'type'  => 'text',
            'orderable' => false
        ],
        [
            'name'  => 'TimeCreate',
            'label' => 'TimeCreate',
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
        CRUD::setModel(\App\Models\UserLogs::class);
        CRUD::setRoute(config('backpack.base.route_prefix') . '/user_logs');
        CRUD::setEntityNameStrings('user_logs', 'user_logs');
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
            'name'  => 'UserID',
            'label' => 'UserID'
        ],
            false,
            function($value) { // if the filter is active
                $this->crud->addClause('where', 'ReceiverID', '=', $value);
            });
        $this->crud->addFilter([
            'type'  => 'text',
            'name'  => 'UserName',
            'label' => 'UserName'
        ],
            false,
            function($value) { // if the filter is active
                $this->crud->addClause('where', 'Receiver', 'LIKE', "%$value%");
            });
        $this->crud->addFilter([
            'type'  => 'text',
            'name'  => 'NickName',
            'label' => 'NickName'
        ],
            false,
            function($value) { // if the filter is active
                $this->crud->addClause('where', 'SenderID', '=', $value);
            });
        $this->crud->addFilter([
            'type'  => 'text',
            'name'  => 'Type',
            'label' => 'Type'
        ],
            false,
            function($value) { // if the filter is active
                $this->crud->addClause('where', 'Sender', 'LIKE', "%$value%");
            });
    }

//    protected function setupShowOperation()
//    {
//        $this->crud->addColumns($this->columns);
//    }
}
