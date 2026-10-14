<?php

namespace App\Http\Controllers\Admin\Operations;

use App\Models\ServerList;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Route;

trait CreateAllXmlOperation
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
            'as'        => $routeName.'.createallxml',
            'uses'      => $controller.'@createallxml',
            'operation' => 'createallxml',
        ]);
    }

    /**
     * Add the default settings, buttons, etc that this operation needs.
     */
    protected function setupSendItemDefaults()
    {
        $this->crud->allowAccess('createallxml');

        $this->crud->operation('createallxml', function () {
            $this->crud->loadDefaultOperationSettingsFromConfig();
        });

        $this->crud->operation('list', function () {
            // $this->crud->addButton('top', 'senditem', 'view', 'crud::buttons.senditem');
            // $this->crud->addButton('line', 'senditem', 'view', 'crud::buttons.senditem');
        });
    }

    public function createallxml()
    {
        $this->crud->hasAccessOrFail('createallxml');
        $servers = ServerList::all();
        $contents = [];
        if (!empty($servers) && $servers->count()) {
            foreach ($servers as $server) {
                $content = file_get_contents(trim($server->LinkRequest, '/') . "/createallxml.ashx");
                if ($content != 'IP is not valid!') {
                    $content = str_replace('!Build', '!<br>Build', $content);
                }
                $contents[$server->ServerName] = $content;
            }
        }

        return view("crud::operations.createallxml", ['contents' => $contents]);
    }
}
