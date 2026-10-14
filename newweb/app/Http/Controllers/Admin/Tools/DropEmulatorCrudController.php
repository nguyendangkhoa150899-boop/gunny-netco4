<?php

namespace App\Http\Controllers\Admin\Tools;

use App\Http\Controllers\Admin\Operations\DropEmulatorOperation;
use App\Http\Requests\SendItemRequest;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class SendItemCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class DropEmulatorCrudController extends CrudController
{
    use DropEmulatorOperation;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        CRUD::setModel(\App\Models\DropEmulator::class);
        CRUD::setRoute(config('backpack.base.route_prefix') . '/dropemulator');
        CRUD::setEntityNameStrings('dropemulator', 'Giả lập Drop');
    }

    /**
     * Define what happens when the Create operation is loaded.
     *
     * @see https://backpackforlaravel.com/docs/crud-operation-create
     * @return void
     */

}
