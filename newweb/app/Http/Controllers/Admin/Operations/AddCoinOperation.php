<?php

namespace App\Http\Controllers\Admin\Operations;

use Illuminate\Support\Facades\Route;

trait AddCoinOperation
{
    /**
     * Define which routes are needed for this operation.
     *
     * @param string $segment    Name of the current entity (singular). Used as first URL segment.
     * @param string $routeName  Prefix of the route name.
     * @param string $controller Name of the current CrudController.
     */
    protected function setupAddCoinRoutes($segment, $routeName, $controller)
    {
        Route::post($segment.'/{id}/addcoin', [
            'as'        => $routeName.'.addcoin',
            'uses'      => $controller.'@addcoin',
            'operation' => 'addcoin',
        ]);
    }

    /**
     * Add the default settings, buttons, etc that this operation needs.
     */
    protected function setupAddCoinDefaults()
    {
        $this->crud->allowAccess('addcoin');

        $this->crud->operation('addcoin', function () {
            $this->crud->loadDefaultOperationSettingsFromConfig();
        });

        $this->crud->operation('list', function () {
            // $this->crud->addButton('top', 'addcoin', 'view', 'crud::buttons.addcoin');
             $this->crud->addButton('line', 'addcoin', 'view', 'crud::buttons.addcoin');
             $this->crud->addButton('line', 'removecoin', 'view', 'crud::buttons.removecoin');
        });
    }

    /**
     * Show the view for performing the operation.
     *
     * @return Response
     */
    public function addcoin()
    {
        $this->crud->hasAccessOrFail('addcoin');

        // prepare the fields you need to show
        $this->data['crud'] = $this->crud;
        $this->data['title'] = $this->crud->getTitle() ?? 'addcoin '.$this->crud->entity_name;

        // load the view
        return view("crud::operations.addcoin", $this->data);
    }
}
