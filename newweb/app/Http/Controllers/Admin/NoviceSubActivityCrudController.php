<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\EventRewardGoodsRequest;
use App\Http\Requests\EventRewardInfoRequest;
use App\Models\ActiveAward;
use App\Models\EventRewardGoods;
use App\Models\ShopGoods;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Route;

/**
 * Class ActiveCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class NoviceSubActivityCrudController extends CrudController
{
    use \Onkbear\NestedCrud\app\Http\Controllers\Operations\NestedListOperation;
    use \Onkbear\NestedCrud\app\Http\Controllers\Operations\NestedCreateOperation;
    use \Onkbear\NestedCrud\app\Http\Controllers\Operations\NestedUpdateOperation;
    use \Onkbear\NestedCrud\app\Http\Controllers\Operations\NestedDeleteOperation;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        $this->crud->setModel(\App\Models\EventRewardInfo::class);
        $ActivityId = \Route::current()->parameter('activity_id');
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/noviceactivity/'.$ActivityId.'/subactivity');
        $this->crud->addClause('where', 'ActivityType', $ActivityId);
//        $this->crud->orderBy('SubActivityType');
//        $this->crud->groupBy('SubActivityType');
//        $this->crud->query->select(['SubActivityType', 'ActivityType']);
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
        $this->crud->setOperationSetting('nestedDetailsButtonKey', 'SubActivityType');
        $this->crud->addColumns([
            [
                'name'  => 'SubActivityType',
                'label' => 'Điều kiện - number',
                'type'  => 'number',
            ],
            [
                'name'  => 'label',
                'label' => 'Điều kiện - text',
                'type'  => 'model_function',
                'function_name' => 'getCondictionText'
            ],
        ]);
    }

    public function showDetailsRow($activity_id, $subactivity_id)
    {
        $crud = app()->make('crud'); //make instance
        $crud->setModel(EventRewardGoods::class); //set model for relationship & data query
        $crud->entry = \App\Models\EventRewardInfo::findOrFail($activity_id);
        //don't know
        $crud->setOperationSetting('fields', $crud->getUpdateFields());
        //save actions for the form
        $crud->setupDefaultSaveActions();
        $crud->setRoute(config('backpack.base.route_prefix') . '/noviceactivity/'.$activity_id.'/subactivity/'.$subactivity_id);
        //set the view for this update operation
        //it's depend on nested_crud update operation
        $crud->setListView('nested_crud::details_row_nested_list');
        $crud->hasAccessOrFail('list');
        $crud->addColumns([
            [
                'name'  => 'TemplateId',
                'label' => 'TemplateId',
                'type'  => 'number',
            ],
            [
                'name'  => 'Image',
                'label' => 'Image',
                'type'  => 'model_function',
                'function_name' => 'ResourceImageColumn',
                'limit' => 999,
            ],
            [
                'name'  => 'ItemID',
                'label' => 'Item',
                'type'  => 'select',
                'entity'    => 'Item',
                'attribute' => 'Name',
                'model'     => ShopGoods::class
            ],
            [
                'name'  => 'ValidDate',
                'label' => 'Hạn',
                'type'  => 'number',
            ],
            [
                'name'  => 'Count',
                'label' => 'Số lượng',
                'type'  => 'number',
            ],
            [
                'name'  => 'StrengthLevel',
                'label' => '+',
                'type'  => 'number',
            ],
            [
                'name'  => 'Compose',
                'label' => 'Compose',
                'type'  => 'model_function',
                'function_name' => 'combine4Column'
            ],
            [
                'name'  => 'IsBind',
                'label' => 'Khóa?',
                'type'  => 'check',
            ],
        ]);
        $crud->setOperationSetting('nestedDetailsModelClass', EventRewardGoods::class, 'detailsRow');
        $crud->addButton('line', 'nested_list_details_row_edit', 'view', 'nested_crud::buttons.details_row_edit'); //must after set model class
        $crud->addButton('line', 'nested_list_details_row_delete', 'view', 'nested_crud::buttons.details_row_delete');
        $data = [];
        $data['entries'] = EventRewardGoods::where('ActivityType', $activity_id)->where('SubActivityType', $subactivity_id)->get();
        $data['crud'] = $crud;
        $data['parentEntryId'] = $subactivity_id;

        return view($crud->getListView(), $data);
    }

    /**
     * Define what happens when the Create operation is loaded.
     *
     * @see https://backpackforlaravel.com/docs/crud-operation-create
     * @return void
     */
    protected function setupNestedCreateOperation()
    {
        $this->crud->setModel(\App\Models\EventRewardInfo::class);
        $this->crud->setValidation(EventRewardInfoRequest::class);

        $ActiveId = \Route::current()->parameter('activity_id');

        $this->crud->addFields([
            [
                'name'  => 'ActivityType',
                'label' => "ActivityType",
                'type'  => 'hidden',
                'value' => $ActiveId
            ],
            [
                'name'  => 'SubActivityType',
                'label' => "SubActivityType",
                'type'  => 'number',
                'hint' => 'Số thứ tự của mốc thưởng'
            ],
            [
                'name'  => 'Condition',
                'label' => 'Condition',
                'type'  => 'number',
                'hint' => 'Điều kiện nhận thưởng',
            ],
        ]);
        /**
         * Fields can be defined using the fluent syntax or array syntax:
         * - CRUD::field('price')->type('number');
         * - CRUD::addField(['name' => 'price', 'type' => 'number']));
         */
    }

    /**
     * Define what happens when the Update operation is loaded.
     *
     * @see https://backpackforlaravel.com/docs/crud-operation-update
     * @return void
     */
    protected function setupNestedUpdateOperation()
    {
        $this->setupNestedCreateOperation();
    }

    protected function setupNestedDetailsRowRoutes($segment, $routeName, $controller)
    {
        Route::get($segment.'/{subactivity_id}/details', [
            'as'        => $routeName.'.showDetailsRow',
            'uses'      => $controller.'@showDetailsRow',
            'operation' => 'list',
        ]);

        Route::get($segment.'/{subactivity_id}/{goods_id}/delete', [
            'as'        => $routeName.'@deleteGoods',
            'uses'      => $controller.'@deleteGoods',
            'operation' => 'delete',
        ])->where('subactivity_id', '^((?!ajax).)*$');

        Route::get($segment.'/{subactivity_id}/{goods_id}/edit', [
            'as'        => $routeName.'@editGoods',
            'uses'      => $controller.'@editGoods',
            'operation' => 'edit',
        ])->where('subactivity_id', '^((?!ajax).)*$');

        Route::put($segment.'/{subactivity_id}/{goods_id}/update', [
            'as'        => $routeName.'@updateGoods',
            'uses'      => $controller.'@updateGoods',
            'operation' => 'update',
        ])->where('subactivity_id', '^((?!ajax).)*$');

        Route::get($segment.'/ajax/create', [
            'as'        => $routeName.'@nestedCreate',
            'uses'      => $controller.'@nestedCreate',
            'operation' => 'create',
        ]);

        Route::get($segment.'/{subactivity_id}/create', [
            'as'        => $routeName.'@createGoods',
            'uses'      => $controller.'@createGoods',
            'operation' => 'create',
        ]);

        Route::post($segment.'/{subactivity_id}/create', [
            'as'        => $routeName.'@storeGoods',
            'uses'      => $controller.'@storeGoods',
            'operation' => 'create',
        ]);
    }

    public function deleteGoods($id, $subactivity_id, $goods_id)
    {
        $item = EventRewardGoods::where('ActivityType', $id)->where('SubActivityType', $subactivity_id)->where('ID', $goods_id)->firstOrFail();
        return $item->delete();
    }

    public function createGoods($id, $subactivity_id)
    {
        $crud = app()->make('crud'); //make instance
        $crud->setModel(EventRewardGoods::class); //set model for relationship & data query
        //of course, fields for the form are needed here
        $crud->addFields([
            [
                'name'  => 'ActivityType',
                'label' => "ActivityType",
                'type'  => 'hidden',
                'value' => $id
            ],
            [
                'name'  => 'SubActivityType',
                'label' => "SubActivityType",
                'type'  => 'hidden',
                'value' => $subactivity_id
            ],
            [
                'name'  => 'TemplateId',
                'label' => 'TemplateId',
                'type'  => 'select2_from_ajax_multiple_with_image_details_row',
                'entity'      => 'Item', // the method that defines the relationship in your Model
                'attribute'      => 'apiDisplay',
                'image'      => 'apiDisplayImage',
                'data_source' => url(config('backpack.base.route_prefix', 'admin')."/api/shopgoods"), // url to controller search function (with /{id} should return model)
                'pivot'       => false, // on create&update, do you need to add/delete pivot table entries?

                // OPTIONAL
                'delay' => 500, // the minimum amount of time between ajax requests when searching in the field
                'model'                => ShopGoods::class, // foreign key model
                'placeholder'          => "Select items", // placeholder for the select
                'minimum_input_length' => 4, // minimum characters to type before querying results
                'value' => false
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

    public function editGoods($id, $subactivity_id, $goods_id)
    {
        //Let create a new crud instance for this specific operation
        $crud = app()->make('crud'); //make instance
        $crud->setModel(EventRewardGoods::class); //set model for relationship & data query
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
        //save actions for the form
        $crud->setupDefaultSaveActions();
        //set the view for this update operation
        //it's depend on nested_crud update operation
        $crud->setUpdateView('nested_crud::modals.edit');

        //and here we go
        $goods = EventRewardGoods::find($goods_id);
        $item = $goods->Item;
        $image = $item->ResourceImageColumn();
        $crud->image_title = $image;
        $crud->entity_name = $item->Name;

        // get the info for that entry
        $data['entry'] = $crud->getEntry($goods_id);
        $data['crud'] = $crud;
        $data['saveAction'] = $crud->getSaveAction();
        $data['title'] = $crud->getTitle() ?? trans('backpack::crud.edit').' '.$crud->entity_name;
        $data['id'] = $goods_id;
        return view($crud->getEditView(), $data);
    }

    public function updateGoods($id, $subactivity_id, $goods_id)
    {
        $crud = app()->make('crud'); //make instance
        $crud->setModel(EventRewardGoods::class); //set model for relationship & data query
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
        $crud->setValidation(EventRewardGoodsRequest::class);

        $request = $crud->validateRequest();
        // update the row in the db
        $item = $crud->update(
            $request->get($crud->model->getKeyName()),
            $crud->getStrippedSaveRequest()
        );
        $crud->entry = $item;
        return $item->getKey();
    }

    public function storeGoods($id, $subactivity_id)
    {
        $crud = app()->make('crud'); //make instance
        $crud->setModel(EventRewardGoods::class); //set model for relationship & data query
        //of course, fields for the form are needed here
        $crud->addFields([
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
                'type'  => 'select2_from_ajax_multiple_with_image_details_row',
                'entity'      => 'Item', // the method that defines the relationship in your Model
                'attribute'      => 'apiDisplay',
                'image'      => 'apiDisplayImage',
                'data_source' => url(config('backpack.base.route_prefix', 'admin')."/api/shopgoods"), // url to controller search function (with /{id} should return model)
                'pivot'       => false, // on create&update, do you need to add/delete pivot table entries?

                // OPTIONAL
                'delay' => 500, // the minimum amount of time between ajax requests when searching in the field
                'model'                => ShopGoods::class, // foreign key model
                'placeholder'          => "Select items", // placeholder for the select
                'minimum_input_length' => 4, // minimum characters to type before querying results
                'value' => false
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
        $crud->setRequest(request());
        $crud->setValidation(EventRewardGoodsRequest::class);

        $request = $crud->validateRequest();
        $items = $request->TemplateId;
        if (is_array($items)) {
            DB::connection((new EventRewardGoods)->getConnectionName())->beginTransaction();
            $data = [
                'ActivityType' => $request->ActivityType,
                'SubActivityType' => $request->SubActivityType,
                'Count' => $request->Count,
                'ValidDate' => $request->ValidDate,
                'StrengthLevel' => $request->StrengthLevel,
                'AttackCompose' => $request->AttackCompose,
                'DefendCompose' => $request->DefendCompose,
                'LuckCompose' => $request->LuckCompose,
                'AgilityCompose' => $request->AgilityCompose,
                'isBind' => $request->isBind,
            ];
            foreach ($items as $templateId) {
                $data['TemplateId'] = $templateId;
                $entry = new EventRewardGoods($data);
                if (!$entry->save()) {
                    DB::connection((new EventRewardGoods)->getConnectionName())->rollBack();
                    return response()->json(['message' => 'error'], 500);
                }
            }
            DB::connection((new EventRewardGoods)->getConnectionName())->commit();
            return 1;
        } else {
            // insert item in the db
            $item = $crud->create($crud->getStrippedSaveRequest());
            $data['entry'] = $crud->entry = $item;
            return $item->getKey();
        }
    }
}
