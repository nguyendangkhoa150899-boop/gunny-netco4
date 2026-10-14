<?php

namespace App\Http\Controllers\Admin\Operations;

use Illuminate\Support\Facades\Route;

trait buildxmlOperation
{
    /**
     * Define which routes are needed for this operation.
     *
     * @param string $segment    Name of the current entity (singular). Used as first URL segment.
     * @param string $routeName  Prefix of the route name.
     * @param string $controller Name of the current CrudController.
     */
    protected function setupbuildxmlRoutes($segment, $routeName, $controller)
    {
        Route::get($segment.'/buildxml', [
            'as'        => $routeName.'.buildxml',
            'uses'      => $controller.'@buildxml',
            'operation' => 'buildxml',
        ]);
    }

    /**
     * Add the default settings, buttons, etc that this operation needs.
     */
    protected function setupbuildxmlDefaults()
    {
        $this->crud->allowAccess('buildxml');

        $this->crud->operation('buildxml', function () {
            $this->crud->loadDefaultOperationSettingsFromConfig();
        });

        $this->crud->operation('list', function () {
             $this->crud->addButton('top', 'buildxml', 'view', 'crud::buttons.buildxml');
        });
    }

    /**
     * Show the view for performing the operation.
     *
     * @return Response
     */
    public function buildxml()
    {
        $this->crud->hasAccessOrFail('buildxml');

        // prepare the fields you need to show
        $this->data['crud'] = $this->crud;
        $this->data['title'] = $this->crud->getTitle() ?? 'buildxml '.$this->crud->entity_name;

        // load the view
        return view("crud::operations.buildxml", $this->data);
    }
}
