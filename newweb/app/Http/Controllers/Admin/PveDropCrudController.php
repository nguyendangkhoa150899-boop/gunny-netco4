<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Admin\Operations\DropItemOperation;
use App\Models\PveInfoDropItem;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanel;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Route;

/**
 * Class ActiveCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class PveDropCrudController extends CrudController
{
    use DropItemOperation;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        $this->crud->setModel(PveInfoDropItem::class);
        $PveId = \Route::current()->parameter('pve_id');
        $HardLevel = \Route::current()->parameter('hard_level');
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/pveinfo/'.$PveId.'/drops/'.$HardLevel);
    }
}
