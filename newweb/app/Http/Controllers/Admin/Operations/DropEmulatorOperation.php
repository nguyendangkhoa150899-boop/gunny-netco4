<?php

namespace App\Http\Controllers\Admin\Operations;

use Illuminate\Support\Facades\Route;

trait DropEmulatorOperation
{
    /**
     * Define which routes are needed for this operation.
     *
     * @param string $segment    Name of the current entity (singular). Used as first URL segment.
     * @param string $routeName  Prefix of the route name.
     * @param string $controller Name of the current CrudController.
     */
    protected function setupDropEmulatorRoutes($segment, $routeName, $controller)
    {
        Route::get($segment, [
            'as'        => $routeName.'.dropemulator',
            'uses'      => $controller.'@dropemulator',
            'operation' => 'dropemulator',
        ]);
    }

    /**
     * Add the default settings, buttons, etc that this operation needs.
     */
    protected function setupDropEmulatorDefaults()
    {
        $this->crud->allowAccess('dropemulator');

        $this->crud->operation('dropemulator', function () {
            $this->crud->loadDefaultOperationSettingsFromConfig();
        });

        $this->crud->operation('list', function () {
            // $this->crud->addButton('top', 'senditem', 'view', 'crud::buttons.senditem');
            // $this->crud->addButton('line', 'senditem', 'view', 'crud::buttons.senditem');
        });
    }

    /**
     * Show the view for performing the operation.
     *
     * @return Response
     */
    public function dropemulator()
    {
        $this->crud->hasAccessOrFail('dropemulator');

        // prepare the fields you need to show
        $this->data['crud'] = $this->crud;
        $this->data['title'] = $this->crud->getTitle() ?? 'dropemulator '.$this->crud->entity_name;

        // load the view
        return view("crud::operations.dropemulator", $this->data);
    }
}
