<?php

namespace App\Http\Controllers\Admin;

class MyCrudController extends \Backpack\CRUD\app\Http\Controllers\CrudController
{
    /**
     * @var \App\MyCrudPanel
     */
    public $crud;

    public function __construct()
    {
        if ($this->crud) {
            return;
        }

        // ---------------------------
        // Create the CrudPanel object
        // ---------------------------
        // Used by developers inside their ProductCrudControllers as
        // $this->crud or using the CRUD facade.
        //
        // It's done inside a middleware closure in order to have
        // the complete request inside the CrudPanel object.
        $this->middleware(function ($request, $next) {
            $this->crud = app()->make('MyCrud');
            $this->crud->setRequest($request);

            $this->setupDefaults();
            $this->setup();
            $this->setupConfigurationForCurrentOperation();

            return $next($request);
        });
    }

}
