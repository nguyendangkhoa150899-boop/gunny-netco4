<?php

namespace App\Http\Controllers\Admin;

use App\Models\PveInfoHards;
use App\Models\PveInfo;
use App\Models\PveInfoMissions;
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
class PveMissionCrudController extends CrudController
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
        $this->crud->setModel(PveInfoHards::class);
        $PveId = \Route::current()->parameter('pve_id');
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/pveinfo/'.$PveId.'/missions');
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
        $this->crud->setOperationSetting('nestedDetailsButtonKey', 'ID');
        $this->crud->addColumns([
            [
                'name'      => 'row_number',
                'type'      => 'nested_crud_row_number',
                'label'     => '#',
                'orderable' => false,
            ],
            [
                'name'  => 'name',
                'label' => 'Độ khó',
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
            $item = new PveInfoHards();
            $item->ID = 'SimpleGameScript';
            $item->name = 'Dễ';
            $entries->push($item);
        }
        if (!empty($pveInfo->NormalGameScript)) {
            $item = new PveInfoHards();
            $item->ID = 'NormalGameScript';
            $item->name = 'Thường';
            $entries->push($item);
        }
        if (!empty($pveInfo->HardGameScript)) {
            $item = new PveInfoHards();
            $item->ID = 'HardGameScript';
            $item->name = 'Khó';
            $entries->push($item);
        }
        if (!empty($pveInfo->TerrorGameScript)) {
            $item = new PveInfoHards();
            $item->ID = 'TerrorGameScript';
            $item->name = 'Anh hùng';
            $entries->push($item);
        }
        $this->data['entries'] = $entries;
        $this->data['crud'] = $this->crud;

        return view($this->crud->getListView(), $this->data);
    }

    public function showDetailsRow($pve_id, $hard_level)
    {
        /** @var CrudPanel $crud */
        $crud = app()->make('crud'); //make instance
        $crud->setModel(PveInfoMissions::class); //set model for relationship & data query
//        $crud->setRoute(config('backpack.base.route_prefix') . '/pveinfo/'.$PveId.'/templates');
        $crud->setRoute(config('backpack.base.route_prefix') . '/pveinfo/'.$pve_id.'/missions/'.$hard_level);
        //of course, fields for the form are needed here
        $crud->addColumns([
            [
                'name' => 'Id',
                'label' => 'Id',
                'type' => 'text',
            ],
            [
                'name' => 'Name',
                'label' => 'Name',
                'type' => 'text',
            ],
            [
                'name' => 'Script',
                'label' => 'Script',
                'type' => 'text',
            ],
            [
                'name' => 'Param1',
                'label' => 'Param1',
                'type' => 'number',
            ],
            [
                'name' => 'Param2',
                'label' => 'Param2',
                'type' => 'number',
            ],
            [
                'name' => 'TakeCard',
                'label' => 'TakeCard',
                'type' => 'check',
            ],
        ]);
        $crud->allowAccess('update');
        $crud->denyAccess('delete');
        $crud->setOperationSetting('nestedDetailsModelClass', PveInfoMissions::class, 'detailsRow');
        $crud->setListView('nested_crud::details_row_nested_list');
        $crud->addButton('line', 'nested_list_details_row_edit', 'view', 'nested_crud::buttons.details_row_edit');
        $crud->setupDefaultSaveActions();

        /** @var PveInfo $pveInfo */
        $pveInfo = PveInfo::find($pve_id);
        $script = $pveInfo[$hard_level];
        $missions = $pveInfo->getPveMissions($script);
        foreach ($missions as $mission) {
            $mission->parentEntryId = $hard_level;
        }
        $data['entries'] = $missions;
        $data['crud'] = $crud;
        $data['saveAction'] = $crud->getSaveAction();
        $data['title'] = $crud->getTitle() ?? trans('backpack::crud.add').' '.$crud->entity_name;
        $data['parentEntryId'] = $hard_level;
        return view($this->crud->getListView(), $data);
    }

    protected function setupNestedDetailsRowRoutes($segment, $routeName, $controller)
    {
        Route::get($segment.'/{hard_level}/details', [
            'as'        => $routeName.'.showDetailsRow',
            'uses'      => $controller.'@showDetailsRow',
            'operation' => 'list',
        ]);

        Route::get($segment.'/{hard_level}/{mission_id}/edit', [
            'as'        => $routeName.'@editMission',
            'uses'      => $controller.'@editMission',
            'operation' => 'edit',
        ])->where('hard_level', '^((?!ajax).)*$');

        Route::put($segment.'/{hard_level}/{mission_id}/update', [
            'as'        => $routeName.'@updateMission',
            'uses'      => $controller.'@updateMission',
            'operation' => 'update',
        ])->where('hard_level', '^((?!ajax).)*$');
    }

    public function editMission($pve_id, $hard_level, $mission_id)
    {
        //Let create a new crud instance for this specific operation
        $crud = app()->make('crud'); //make instance
        $crud->setModel(PveInfoMissions::class); //set model for relationship & data query
        //of course, fields for the form are needed here
        $crud->addFields([
            [
                'name' => 'Id',
                'label' => 'Id',
                'type' => 'number',
            ],
            [
                'name' => 'Name',
                'label' => 'Name',
                'type' => 'text',
            ],
            [
                'name' => 'TotalCount',
                'label' => 'TotalCount',
                'type' => 'number',
                'hint' => 'Số quái/boss cần đánh bại',
            ],
            [
                'name' => 'TotalTurn',
                'label' => 'TotalTurn',
                'type' => 'number',
                'hint' => 'Số turn tối đa',
            ],
            [
                'name' => 'Script',
                'label' => 'Script',
                'type' => 'text',
            ],
            [
                'name' => 'Success',
                'label' => 'Success',
                'type' => 'text',
            ],
            [
                'name' => 'Failure',
                'label' => 'Failure',
                'type' => 'text',
            ],
            [
                'name' => 'Description',
                'label' => 'Description',
                'type' => 'text',
            ],
            [
                'name' => 'IncrementDelay',
                'label' => 'IncrementDelay',
                'type' => 'text',
            ],
            [
                'name' => 'Delay',
                'label' => 'Delay',
                'type' => 'text',
            ],
            [
                'name' => 'Title',
                'label' => 'Title',
                'type' => 'text',
            ],
            [
                'name' => 'Param1',
                'label' => 'Param1',
                'type' => 'text',
            ],
            [
                'name' => 'Param2',
                'label' => 'Param2',
                'type' => 'text',
            ],
            [
                'name' => 'TakeCard',
                'label' => 'TakeCard',
                'type' => 'checkbox',
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
        $mission = PveInfoMissions::find($mission_id);
        $crud->image_title = $mission->Name;

        // get the info for that entry
        $data['entry'] = $crud->getEntry($mission_id);
        $data['crud'] = $crud;
        $data['saveAction'] = $crud->getSaveAction();
        $data['title'] = $crud->getTitle() ?? trans('backpack::crud.edit').' '.$crud->entity_name;
        $data['id'] = $mission_id;
        return view($crud->getEditView(), $data);
    }

    public function updateMission($pve_id, $hard_level, $mission_id)
    {
        $crud = app()->make('crud'); //make instance
        $crud->setModel(PveInfoMissions::class); //set model for relationship & data query
        //of course, fields for the form are needed here
        $crud->addFields([
            [
                'name'  => 'ID',
                'label' => "ID",
                'type'  => 'hidden',
            ],
            [
                'name'  => 'ActivityType',
                'label' => "ActivityType",
                'type'  => 'hidden',
            ],
            [
                'name'  => 'SubActivityType',
                'label' => "SubActivityType",
                'type'  => 'hidden',
            ],
            [
                'name'  => 'TemplateId',
                'label' => 'TemplateId',
                'type' => 'hidden'
            ],
            [
                'name'  => 'ValidDate',
                'label' => 'Hạn sử dụng',
                'type'  => 'number',
            ],
            [
                'name'  => 'Count',
                'label' => 'Số lượng',
                'type'  => 'number',
            ],
            [
                'name'  => 'StrengthLevel',
                'label' => 'Cấp cường hóa',
                'type'  => 'number',
            ],
            [
                'name' => 'AttackCompose',
                'label'=> 'AttackCompose',
                'type' => 'number',
            ],
            [
                'name' => 'DefendCompose',
                'label'=> 'DefendCompose',
                'type' => 'number',
            ],
            [
                'name' => 'LuckCompose',
                'label'=> 'LuckCompose',
                'type' => 'number',
            ],
            [
                'name' => 'AgilityCompose',
                'label'=> 'AgilityCompose',
                'type' => 'number',
            ],
            [
                'name'  => 'IsBind',
                'label' => 'Khóa?',
                'type'  => 'boolean',
            ],
        ]);
        //don't know
        $crud->setOperationSetting('fields', $crud->getUpdateFields());
        $crud->setRequest(request());
        //$crud->setValidation(EventRewardGoodsRequest::class);

        $request = $crud->validateRequest();
        // update the row in the db
        $item = $crud->update(
            $request->get($crud->model->getKeyName()),
            $crud->getStrippedSaveRequest()
        );
        $crud->entry = $item;
        return $item->getKey();
    }
}
