<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\EventRewardGoodsRequest;
use App\Http\Requests\EventRewardInfoRequest;
use App\Http\Requests\PveDropCondictionRequest;
use App\Models\PveInfoDropCondiction;
use App\Models\PveInfoHards;
use App\Models\PveInfo;
use App\Models\PveInfoMissions;
use App\Models\PveInfoTemplates;
use App\Models\ShopGoods;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanel;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Route;

/**
 * Class ActiveCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class PveDropCondictionCrudController extends CrudController
{
    use \Onkbear\NestedCrud\app\Http\Controllers\Operations\NestedListOperation;
//    use \Onkbear\NestedCrud\app\Http\Controllers\Operations\NestedCreateOperation;
//    use \Onkbear\NestedCrud\app\Http\Controllers\Operations\NestedUpdateOperation;
//    use \Onkbear\NestedCrud\app\Http\Controllers\Operations\NestedDeleteOperation;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        $this->crud->setModel(PveInfoDropCondiction::class);
        $PveId = \Route::current()->parameter('pve_id');
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/pveinfo/'.$PveId.'/condictions');
    }

    /**
     * Define what happens when the List operation is loaded.
     *
     * @see  https://backpackforlaravel.com/docs/crud-operation-list-entries
     * @return void
     */
    protected function setupNestedListOperation()
    {
        $this->crud->enableDetailsRow();
//        $this->crud->setOperationSetting('nestedDetailsButtonKey', 'Id');
        $this->crud->addColumns([
            [
                'name'      => 'row_number',
                'type'      => 'nested_crud_row_number',
                'label'     => '#',
                'orderable' => false,
            ],
            [
                'name'  => 'Id',
                'label' => 'Id',
                'type'  => 'number',
            ],
            [
                'name'  => 'Name',
                'label' => 'Name',
                'type'  => 'text',
            ],
        ]);
    }

    public function nestedList()
    {
        $this->crud->hasAccessOrFail('list');

        $PveId = \Route::current()->parameter('pve_id');
        $pveInfo = PveInfo::find($PveId);
        $entries = new Collection();
        if (!empty($pveInfo->SimpleGameScript)) {
            $entries = $entries->merge($pveInfo->SimpleMissions());
        }
        if (!empty($pveInfo->NormalGameScript)) {
            $entries = $entries->merge($pveInfo->NormalMissions());
        }
        if (!empty($pveInfo->HardGameScript)) {
            $entries = $entries->merge($pveInfo->HardMissions());
        }
        if (!empty($pveInfo->TerrorGameScript)) {
            $entries = $entries->merge($pveInfo->TerrorMissions());
        }
        $this->data['entries'] = $entries;
        $this->data['crud'] = $this->crud;

        return view($this->crud->getListView(), $this->data);
    }

    public function showDetailsRow($pve_id, $missioninfo_id)
    {
        /** @var CrudPanel $crud */
        $crud = app()->make('crud'); //make instance
        $crud->setModel(PveInfoDropCondiction::class); //set model for relationship & data query
        $crud->setRoute(config('backpack.base.route_prefix') . '/pveinfo/'.$pve_id.'/missions/'.$missioninfo_id);
        //of course, fields for the form are needed here
        $crud->addColumns([
            [
                'name'      => 'row_number',
                'type'      => 'number',
                'label'     => '#',
                'orderable' => false,
            ],
            [
                'name'  => 'DropID',
                'label' => 'DropID',
                'type'  => 'number',
            ],
            [
                'name'  => 'CondictionType',
                'label' => 'CondictionType',
                'type'  => 'number',
            ],
            [
                'name'  => 'Para1',
                'label' => 'Para1',
                'type'  => 'text',
            ],
            [
                'name'  => 'Para2',
                'label' => 'Para2',
                'type'  => 'text',
            ],
        ]);
        $crud->setOperationSetting('nestedDetailsModelClass', PveInfoDropCondiction::class, 'detailsRow');
        $crud->setListView('nested_crud::details_row_nested_list');
        $crud->addButton('line', 'nested_list_details_row_edit', 'view', 'nested_crud::buttons.details_row_edit');
        $crud->addButton('line', 'nested_list_details_row_delete', 'view', 'nested_crud::buttons.details_row_delete');
        $crud->setupDefaultSaveActions();
        $crud->allowAccess(['update', 'create']);

        $missionInfo = PveInfoMissions::find($missioninfo_id);
        $condictions = $missionInfo->Condictions();
        foreach ($condictions as $condiction) {
            $condiction->parentEntryId = $missioninfo_id;
        }
        $data['entries'] = $condictions;
        $data['crud'] = $crud;
        $data['saveAction'] = $crud->getSaveAction();
        $data['title'] = $crud->getTitle() ?? trans('backpack::crud.add').' '.$crud->entity_name;
        $data['parentEntryId'] = $missioninfo_id;
        return view($this->crud->getListView(), $data);
    }

    protected function setupNestedDetailsRowRoutes($segment, $routeName, $controller)
    {
        Route::get($segment.'/{missioninfo_id}/details', [
            'as'        => $routeName.'.showDetailsRow',
            'uses'      => $controller.'@showDetailsRow',
            'operation' => 'list',
        ]);

        Route::get($segment.'/{missioninfo_id}/{condiction}/delete', [
            'as'        => $routeName.'@deleteCondiction',
            'uses'      => $controller.'@deleteCondiction',
            'operation' => 'delete',
        ])->where('missioninfo_id', '^((?!ajax).)*$');

        Route::get($segment.'/{missioninfo_id}/{condiction}/edit', [
            'as'        => $routeName.'@editCondiction',
            'uses'      => $controller.'@editCondiction',
            'operation' => 'edit',
        ])->where('missioninfo_id', '^((?!ajax).)*$');

        Route::put($segment.'/{missioninfo_id}/{condiction}/update', [
            'as'        => $routeName.'@updateCondiction',
            'uses'      => $controller.'@updateCondiction',
            'operation' => 'update',
        ])->where('missioninfo_id', '^((?!ajax).)*$');

        Route::get($segment.'/{missioninfo_id}/create', [
            'as'        => $routeName.'@createCondiction',
            'uses'      => $controller.'@createCondiction',
            'operation' => 'create',
        ])->where('missioninfo_id', '^((?!ajax).)*$');

        Route::post($segment.'/{missioninfo_id}/create', [
            'as'        => $routeName.'@storeCondiction',
            'uses'      => $controller.'@storeCondiction',
            'operation' => 'create',
        ]);
    }

    public function deleteCondiction($pve_id, $missioninfo_id, $condiction)
    {
        $condiction = PveInfoDropCondiction::find($condiction);
        return $condiction->delete();
    }

    public function editCondiction($pve_id, $condiction)
    {
        //Let create a new crud instance for this specific operation
        $crud = app()->make('crud'); //make instance
        $crud->setModel(PveInfoDropCondiction::class); //set model for relationship & data query
        //of course, fields for the form are needed here
        $crud->addFields([
            [
                'name'  => 'DropID',
                'label' => "DropID",
                'type'  => 'number',
                'attributes' => [
                    'disabled' => true
                ]
            ],
            [
                'name'  => 'CondictionType',
                'label' => "CondictionType",
                'type'  => 'number',
            ],
            [
                'name'  => 'Para1',
                'label' => "Para1",
                'type'  => 'text',
            ],
            [
                'name'  => 'Para2',
                'label' => "Para2",
                'type'  => 'text',
            ],
            [
                'name'  => 'Detail',
                'label' => "Detail",
                'type'  => 'textarea',
            ],
        ]);
        //don't know
        $crud->setOperationSetting('fields', $crud->getUpdateFields());
        //save actions for the form
        $crud->setupDefaultSaveActions();
        //set the view for this update operation
        //it's depend on nested_crud update operation
        $crud->setUpdateView('nested_crud::modals.edit');

        //and here we go
        // get the info for that entry
        $data['entry'] = $crud->getEntry($condiction);
        $data['crud'] = $crud;
        $data['saveAction'] = $crud->getSaveAction();
        $data['title'] = $crud->getTitle() ?? trans('backpack::crud.edit').' '.$crud->entity_name;
        $data['id'] = $condiction;
        return view($crud->getEditView(), $data);
    }

    public function updateCondiction($pve_id, $condiction)
    {
        $crud = app()->make('crud'); //make instance
        $crud->setModel(PveInfoDropCondiction::class); //set model for relationship & data query
        //of course, fields for the form are needed here
        $crud->addFields([
            [
                'name'  => 'DropID',
                'label' => "DropID",
                'type'  => 'number',
                'attributes' => [
                    'disabled' => true
                ]
            ],
            [
                'name'  => 'CondictionType',
                'label' => "CondictionType",
                'type'  => 'number',
            ],
            [
                'name'  => 'Para1',
                'label' => "Para1",
                'type'  => 'text',
            ],
            [
                'name'  => 'Para2',
                'label' => "Para2",
                'type'  => 'text',
            ],
            [
                'name'  => 'Detail',
                'label' => "Detail",
                'type'  => 'textarea',
            ],
        ]);
        //don't know
        $crud->setOperationSetting('fields', $crud->getUpdateFields());
        $crud->setRequest(request());
        $crud->setValidation(PveDropCondictionRequest::class);

        $request = $crud->validateRequest();
        // update the row in the db
        $item = $crud->update(
            $request->get($crud->model->getKeyName()),
            $crud->getStrippedSaveRequest()
        );
        $crud->entry = $item;
        return $item->getKey();
    }

    public function createCondiction($pve_id, $hard_level)
    {
        $crud = app()->make('crud'); //make instance
        $crud->setModel(PveInfoDropCondiction::class); //set model for relationship & data query
        //of course, fields for the form are needed here
        $crud->addFields([
            [
                'name'  => 'DropID',
                'label' => "DropID",
                'type'  => 'number',
            ],
            [
                'name'  => 'CondictionType',
                'label' => "CondictionType",
                'type'  => 'number',
            ],
            [
                'name'  => 'Para1',
                'label' => "Para1",
                'type'  => 'text',
            ],
            [
                'name'  => 'Para2',
                'label' => "Para2",
                'type'  => 'text',
            ],
            [
                'name'  => 'Detail',
                'label' => "Detail",
                'type'  => 'textarea',
            ],
        ]);
        //don't know
//        $crud->setOperationSetting('fields', $crud->getUpdateFields());
        //save actions for the form
        $crud->setupDefaultSaveActions();
        //set the view for this update operation
        //it's depend on nested_crud update operation
        $crud->setCreateView('nested_crud::modals.create');

        $data = [];
        $data['crud'] = $crud;
        $data['saveAction'] = $crud->getSaveAction();
        $data['title'] = $crud->getTitle() ?? trans('backpack::crud.add').' '.$crud->entity_name;
        return view($crud->getCreateView(), $data);
    }

    public function storeCondiction($pve_id, $hard_level)
    {
        $crud = app()->make('crud'); //make instance
        $crud->setModel(PveInfoDropCondiction::class);
        $crud->setValidation(PveDropCondictionRequest::class);
        // execute the FormRequest authorization and validation, if one is required
        $request = $crud->validateRequest();
        $crud->addFields([
            [
                'name'  => 'DropID',
                'label' => "DropID",
                'type'  => 'number',
            ],
            [
                'name'  => 'CondictionType',
                'label' => "CondictionType",
                'type'  => 'number',
            ],
            [
                'name'  => 'Para1',
                'label' => "Para1",
                'type'  => 'text',
            ],
            [
                'name'  => 'Para2',
                'label' => "Para2",
                'type'  => 'text',
            ],
            [
                'name'  => 'Detail',
                'label' => "Detail",
                'type'  => 'textarea',
            ],
        ]);

        // insert item in the db
        $item = $crud->create($crud->getStrippedSaveRequest());
        return $item->getKey();
    }
}
