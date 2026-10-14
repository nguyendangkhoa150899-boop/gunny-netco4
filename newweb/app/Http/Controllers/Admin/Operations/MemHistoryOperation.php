<?php

namespace App\Http\Controllers\Admin\Operations;

use Illuminate\Support\Facades\Route;

trait MemHistoryOperation
{
    /**
     * Define which routes are needed for this operation.
     *
     * @param string $segment    Name of the current entity (singular). Used as first URL segment.
     * @param string $routeName  Prefix of the route name.
     * @param string $controller Name of the current CrudController.
     */
    protected function setupMemHistoryRoutes($segment, $routeName, $controller)
    {
        Route::get($segment.'/{id}/memhistory', [
            'as'        => $routeName.'.memhistory',
            'uses'      => $controller.'@memhistory',
            'operation' => 'memhistory',
        ]);
    }

    /**
     * Add the default settings, buttons, etc that this operation needs.
     */
    protected function setupMemHistoryDefaults()
    {
        $this->crud->allowAccess('memhistory');

        $this->crud->operation('memhistory', function () {
            $this->crud->loadDefaultOperationSettingsFromConfig();
        });

        $this->crud->operation('list', function () {
//             $this->crud->addButton('top', 'memhistory', 'view', 'crud::buttons.memhistory');
             $this->crud->addButton('line', 'memhistory', 'view', 'crud::buttons.memhistory');
        });
    }

    /**
     * Show the view for performing the operation.
     *
     * @return Response
     */
    public function memhistory()
    {
        $this->crud->hasAccessOrFail('memhistory');

        // prepare the fields you need to show
        $this->data['crud'] = $this->crud;
        $this->data['title'] = $this->crud->getTitle() ?? 'memhistory '.$this->crud->entity_name;

        // load the view
        return view("crud::operations.memhistory", $this->data);
    }
}
