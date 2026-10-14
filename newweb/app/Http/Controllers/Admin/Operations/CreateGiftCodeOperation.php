<?php

namespace App\Http\Controllers\Admin\Operations;

use Illuminate\Support\Facades\Route;

trait CreateGiftCodeOperation
{
    /**
     * Define which routes are needed for this operation.
     *
     * @param string $segment    Name of the current entity (singular). Used as first URL segment.
     * @param string $routeName  Prefix of the route name.
     * @param string $controller Name of the current CrudController.
     */
    protected function setupCreateGiftCodeRoutes($segment, $routeName, $controller)
    {
//        Route::get($segment.'/{id}/creategiftcode', [
//            'as'        => $routeName.'.creategiftcode',
//            'uses'      => $controller.'@creategiftcode',
//            'operation' => 'creategiftcode',
//        ]);
    }

    /**
     * Add the default settings, buttons, etc that this operation needs.
     */
    protected function setupCreateGiftCodeDefaults()
    {
        $this->crud->allowAccess('creategiftcode');

        $this->crud->operation('creategiftcode', function () {
            $this->crud->loadDefaultOperationSettingsFromConfig();
        });

        $this->crud->operation('list', function () {
            // $this->crud->addButton('top', 'creategiftcode', 'view', 'crud::buttons.creategiftcode');
             $this->crud->addButton('line', 'creategiftcode', 'view', 'crud::buttons.creategiftcode');
        });
    }

    /**
     * Show the view for performing the operation.
     *
     * @return Response
     */
    public function creategiftcode($id)
    {
        $this->crud->hasAccessOrFail('creategiftcode');

        // prepare the fields you need to show
        $this->data['crud'] = $this->crud;
        $this->data['title'] = $this->crud->getTitle() ?? 'creategiftcode '.$this->crud->entity_name;

        // load the view
//        return view("crud::operations.creategiftcode", $this->data);
    }
}
