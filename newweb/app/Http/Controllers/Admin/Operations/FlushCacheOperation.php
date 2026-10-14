<?php

namespace App\Http\Controllers\Admin\Operations;

use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Route;

trait FlushCacheOperation
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
            'as'        => $routeName.'.flushcache',
            'uses'      => $controller.'@flushcache',
            'operation' => 'flushcache',
        ]);
    }

    /**
     * Add the default settings, buttons, etc that this operation needs.
     */
    protected function setupSendItemDefaults()
    {
        $this->crud->allowAccess('flushcache');

        $this->crud->operation('flushcache', function () {
            $this->crud->loadDefaultOperationSettingsFromConfig();
        });

        $this->crud->operation('list', function () {
            // $this->crud->addButton('top', 'senditem', 'view', 'crud::buttons.senditem');
            // $this->crud->addButton('line', 'senditem', 'view', 'crud::buttons.senditem');
        });
    }

    public function flushcache()
    {
        $this->crud->hasAccessOrFail('flushcache');

        Cache::flush();
        \Alert::success('Flush cache thành công!')->flash();
        return back();
    }
}
