<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Admin\Operations\CreateAllXmlOperation;
use App\Http\Requests\SendItemRequest;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class SendItemCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class CreateAllXmlController extends CrudController
{
    use CreateAllXmlOperation;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        //CRUD::setModel(\App\Models\SendItem::class);
        CRUD::setRoute(config('backpack.base.route_prefix') . '/createallxml');
        //CRUD::setEntityNameStrings('senditem', 'send_items');
    }

}
