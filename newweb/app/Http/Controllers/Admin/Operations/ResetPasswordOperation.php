<?php

namespace App\Http\Controllers\Admin\Operations;

use Illuminate\Support\Facades\Route;

trait ResetPasswordOperation
{
    /**
     * Define which routes are needed for this operation.
     *
     * @param string $segment    Name of the current entity (singular). Used as first URL segment.
     * @param string $routeName  Prefix of the route name.
     * @param string $controller Name of the current CrudController.
     */
    protected function setupResetPasswordRoutes($segment, $routeName, $controller)
    {
        Route::post($segment.'/{id}/resetPassword', [
            'as'        => $routeName.'.resetPassword',
            'uses'      => $controller.'@resetPassword',
            'operation' => 'resetpassword',
        ]);
    }

    /**
     * Add the default settings, buttons, etc that this operation needs.
     */
    protected function setupResetPasswordDefaults()
    {
        $this->crud->allowAccess('resetpassword');

        $this->crud->operation('resetpassword', function () {
            $this->crud->loadDefaultOperationSettingsFromConfig();
        });

        $this->crud->operation('list', function () {
            // $this->crud->addButton('top', 'addcoin', 'view', 'crud::buttons.addcoin');
             $this->crud->addButton('line', 'resetpassword', 'view', 'crud::buttons.resetpassword');
        });
    }

    /**
     * Show the view for performing the operation.
     *
     * @return Response
     */
    public function resetpassword()
    {
        $this->crud->hasAccessOrFail('resetpassword');

        return;
    }
}
