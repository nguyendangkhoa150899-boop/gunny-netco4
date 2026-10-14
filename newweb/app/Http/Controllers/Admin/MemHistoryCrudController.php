<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\MemHistoryRequest;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class MemHistoryCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class MemHistoryCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        CRUD::setModel(\App\Models\CoinLog::class);
        CRUD::setRoute(config('backpack.base.route_prefix') . '/memhistory');
        CRUD::setEntityNameStrings('memhistory', 'mem_histories');
    }

    /**
     * Define what happens when the List operation is loaded.
     *
     * @see  https://backpackforlaravel.com/docs/crud-operation-list-entries
     * @return void
     */
    protected function setupListOperation()
    {
        $this->crud->setColumns([
            [
                'name'         => 'MemberUserName', // name of relationship method in the model
                'type'         => 'select',
                'label'        => trans('member.Email'), // Table column heading
                'attribute' => 'Email', // foreign key attribute that is shown to user
                'model' => "App\Models\CoinLogMember",
                'entity' => 'CoinLogMember',
//                'searchLogic' => function ($query, $column, $searchTerm) {
//                    $query->orWhereHas('Member', function ($q) use ($column, $searchTerm) {
//                        $q->where('name', 'like', '%'.$searchTerm.'%')
//                            ->orWhereDate('depart_at', '=', date($searchTerm));
//                    });
//                }
            ],
            [
                'name'  => 'Value',
                'label' => trans('memhistory.Value'),
                'type'  => 'number',
            ],
            [
                'name'  => 'Bonus',
                'label' => trans('memhistory.bonus'),
                'type'  => 'number',
            ],
            [
                'name'  => 'Description',
                'label' => trans('memhistory.Description'),
                'type'  => 'text'
            ],
            [
                'name'         => 'User', // name of relationship method in the model
                'type'         => 'relationship',
                'label'        => trans('memhistory.User'), // Table column heading
                'attribute' => 'name', // foreign key attribute that is shown to user
            ],
            [
                'name'  => 'created_at',
                'label' => trans('memhistory.Time'),
                'type'  => 'text',
            ],
        ]);
    }
}
