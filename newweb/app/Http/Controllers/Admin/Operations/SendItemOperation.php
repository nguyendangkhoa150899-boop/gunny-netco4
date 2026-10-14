<?php

namespace App\Http\Controllers\Admin\Operations;

use Illuminate\Support\Facades\Route;

trait SendItemOperation
{
    /**
     * Define which routes are needed for this operation.
     *
     * @param string $segment    Name of the current entity (singular). Used as first URL segment.
     * @param string $routeName  Prefix of the route name.
     * @param string $controller Name of the current CrudController.
     */
    protected function setupSendItemRoutes($segment, $routeName, $controller)
    {
        Route::get($segment, [
            'as'        => $routeName.'.senditem',
            'uses'      => $controller.'@senditem',
            'operation' => 'senditem',
        ]);
    }

    /**
     * Add the default settings, buttons, etc that this operation needs.
     */
    protected function setupSendItemDefaults()
    {
        $this->crud->allowAccess('senditem');

        $this->crud->operation('senditem', function () {
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
    public function senditem()
    {
        $this->crud->hasAccessOrFail('senditem');

        // prepare the fields you need to show
        $this->data['crud'] = $this->crud;
        $this->data['title'] = $this->crud->getTitle() ?? 'senditem '.$this->crud->entity_name;

        // load the view
        return view("crud::operations.senditem", $this->data);
    }
}
