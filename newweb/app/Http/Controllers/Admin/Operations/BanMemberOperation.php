<?php

namespace App\Http\Controllers\Admin\Operations;

use Illuminate\Support\Facades\Route;

trait BanMemberOperation
{
    /**
     * Define which routes are needed for this operation.
     *
     * @param string $segment    Name of the current entity (singular). Used as first URL segment.
     * @param string $routeName  Prefix of the route name.
     * @param string $controller Name of the current CrudController.
     */
    protected function setupBanMemberRoutes($segment, $routeName, $controller)
    {
        Route::get($segment.'/{id}/banmember', [
            'as'        => $routeName.'.banmember',
            'uses'      => $controller.'@banmember',
            'operation' => 'banmember',
        ]);
    }

    /**
     * Add the default settings, buttons, etc that this operation needs.
     */
    protected function setupBanMemberDefaults()
    {
        $this->crud->allowAccess('banmember');

        $this->crud->operation('banmember', function () {
            $this->crud->loadDefaultOperationSettingsFromConfig();
        });

        $this->crud->operation('list', function () {
            // $this->crud->addButton('top', 'banmember', 'view', 'crud::buttons.banmember');
             $this->crud->addButton('line', 'banmember', 'view', 'crud::buttons.banmember');
        });
    }

    /**
     * Show the view for performing the operation.
     *
     * @return Response
     */
    public function banmember()
    {
        $this->crud->hasAccessOrFail('banmember');

        // prepare the fields you need to show
        $this->data['crud'] = $this->crud;
        $this->data['title'] = $this->crud->getTitle() ?? 'banmember '.$this->crud->entity_name;

        // load the view
        return view("crud::operations.banmember", $this->data);
    }
}
