<?php

namespace App\Http\Controllers\Admin\Operations;

use App\Models\PveInfo;
use App\Models\PveInfoDropItem;
use App\Models\ShopGoods;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanel;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Route;

trait DropItemOperation
{
    /**
     * Define which routes are needed for this operation.
     *
     * @param string $segment    Name of the current entity (singular). Used as first URL segment.
     * @param string $routeName  Prefix of the route name.
     * @param string $controller Name of the current CrudController.
     */
    protected function setupDropItemRoutes($segment, $routeName, $controller)
    {
        Route::get($segment.'/{script}/ajax', [
            'as'        => $routeName.'.dropitem',
            'uses'      => $controller.'@dropitem',
            'operation' => 'dropitem',
        ]);
        Route::get($segment.'/{script}/{drop_condiction}/details', function () {
            return false;
        })->where('drop_condiction', '^((?!ajax).)*$');

        Route::get($segment.'/{script}/{drop_condiction}/{drop_item_id}/edit', [
            'as'        => $routeName.'.edititem',
            'uses'      => $controller.'@edititem',
            'operation' => 'edit',
        ])->where('drop_item_id', '^((?!ajax).)*$');

        Route::put($segment.'/{script}/{drop_condiction}/{drop_item_id}/update', [
            'as'        => $routeName.'.updateitem',
            'uses'      => $controller.'@updateitem',
            'operation' => 'update',
        ])->where('drop_item_id', '^((?!ajax).)*$');

        Route::get($segment.'/{script}/{drop_condiction}/{drop_item_id}/delete', [
            'as'        => $routeName.'.deleteitem',
            'uses'      => $controller.'@deleteitem',
            'operation' => 'delete',
        ])->where('drop_condiction', '^((?!ajax).)*$');

        Route::get($segment.'/{script}/{drop_condiction}/create', [
            'as'        => $routeName.'.createItem',
            'uses'      => $controller.'@createItem',
            'operation' => 'create',
        ])->where('drop_condiction', '^((?!ajax).)*$');

        Route::post($segment.'/{script}/{drop_condiction}/create', [
            'as'        => $routeName.'.storeItem',
            'uses'      => $controller.'@storeItem',
            'operation' => 'create',
        ])->where('drop_condiction', '^((?!ajax).)*$');
    }

    /**
     * Add the default settings, buttons, etc that this operation needs.
     */
    protected function setupDropItemDefaults()
    {
        $this->crud->allowAccess('dropitem');

        $this->crud->operation('dropitem', function () {
            $this->crud->loadDefaultOperationSettingsFromConfig();
        });

        $this->crud->operation('list', function () {
            // $this->crud->addButton('top', 'senditem', 'view', 'crud::buttons.senditem');
            // $this->crud->addButton('line', 'senditem', 'view', 'crud::buttons.senditem');
        });
    }

    /**
     * Show the view for performing the operation.
     *
     * @return Response
     */
    public function dropitem()
    {
        $PveId = \Route::current()->parameter('pve_id');
        $GameScript = \Route::current()->parameter('script');
        $pveInfo = PveInfo::find($PveId);
        $script = $pveInfo[$GameScript];
        $missions = $pveInfo->getPveMissions($script);
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/pveinfo/'.$PveId.'/drops/'.$GameScript);

        $this->data['parentEntries'] = $missions;
        $this->crud->addColumns([
            [
                'name' => 'Id',
                'label' => 'Id',
                'type' => 'number',
            ],
//            [
//                'name' => 'DropId',
//                'label' => 'DropId',
//                'type' => 'number',
//            ],
            [
                'name'  => 'Item',
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
                'name' => 'ValueDate',
                'label' => 'Date',
                'type' => 'text',
            ],
            [
                'name' => 'IsBind',
                'label' => 'Bind',
                'type' => 'check',
            ],
            [
                'name' => 'Random',
                'label' => 'Rand',
                'type' => 'number',
                'sortable' => true
            ],
            [
                'name' => 'BeginData',
                'label' => 'Begin',
                'type' => 'number',
            ],
            [
                'name' => 'EndData',
                'label' => 'End',
                'type' => 'number',
            ],
            [
                'name' => 'IsTips',
                'label' => 'Tips',
                'type' => 'check',
            ],
//            [
//                'name' => 'IsLogs',
//                'label' => 'IsLogs',
//                'type' => 'check',
//            ],
        ]);
        $this->crud->setOperationSetting('nestedDetailsModelClass', PveInfoDropItem::class, 'detailsRow');
        $this->crud->allowAccess(['update', 'create', 'delete']);
        $this->crud->addButton('line', 'nested_list_details_row_edit', 'view', 'nested_crud::buttons.details_row_edit'); //must after set model class
        $this->crud->addButton('line', 'nested_list_details_row_delete', 'view', 'nested_crud::buttons.details_row_delete');
        // prepare the fields you need to show
        $this->data['crud'] = $this->crud;
//        $this->data['title'] = $this->crud->getTitle() ?? 'dropitem '.$this->crud->entity_name;
        $this->data['parentEntryScript'] = $GameScript;

        // load the view
        return view("crud::operations.dropitem", $this->data);
    }

    public function edititem($pve_id, $script, $drop_condiction, $drop_item_id)
    {
        //Let create a new crud instance for this specific operation
        /** @var CrudPanel $crud */
        $crud = app()->make('crud'); //make instance
        $crud->setModel(PveInfoDropItem::class); //set model for relationship & data query
        //of course, fields for the form are needed here
        $crud->addFields([
            [
                'name' => 'Id',
                'label' => 'Id',
                'type' => 'hidden',
            ],
            [
                'name' => 'DropId',
                'label' => 'DropId',
                'type' => 'hidden',
            ],
            [
                'name' => 'ItemId',
                'label' => 'ItemId',
                'type' => 'hidden',
            ],
            [
                'name' => 'ValueDate',
                'label' => 'Hạn sử dụng (ngày)',
                'type' => 'number',
            ],
            [
                'name' => 'IsBind',
                'label' => 'IsBind',
                'type' => 'checkbox',
            ],
            [
                'name' => 'Random',
                'label' => 'Random',
                'type' => 'number',
            ],
            [
                'name' => 'BeginData',
                'label' => 'BeginData',
                'type' => 'number',
            ],
            [
                'name' => 'EndData',
                'label' => 'EndData',
                'type' => 'number',
            ],
            [
                'name' => 'IsTips',
                'label' => 'IsTips',
                'type' => 'checkbox',
            ],
            [
                'name' => 'IsLogs',
                'label' => 'IsLogs',
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
        $crud->allowAccess(['update', 'create', 'delete']);

        //and here we go
        $drop = PveInfoDropItem::find($drop_item_id);
        $item = $drop->Item;
        $image = $item->ResourceImageColumn();
        $crud->image_title = $image;
        $crud->entity_name = $item->Name;

        // get the info for that entry
        $data['entry'] = $drop;
        $data['crud'] = $crud;
        $data['saveAction'] = $crud->getSaveAction();
        $data['title'] = $crud->getTitle() ?? trans('backpack::crud.edit').' '.$crud->entity_name;
        $data['id'] = $drop_item_id;
        return view($crud->getEditView(), $data);
    }

    public function updateitem($pve_id, $script, $drop_condiction, $drop_item_id)
    {
        /** @var PveInfoDropItem $drop */
        $drop = PveInfoDropItem::findOrFail($drop_item_id);
        $request = request();
        $drop->ValueDate = $request->input('ValueDate');
        $drop->IsBind = $request->input('IsBind');
        $drop->Random = $request->input('Random');
        $drop->BeginData = $request->input('BeginData');
        $drop->EndData = $request->input('EndData');
        $drop->IsTips = $request->input('IsTips');
        $drop->IsLogs = $request->input('IsLogs');
        if ($drop->save()) {
            return response()->json(['data' => $script]);
        }
        return 0;
    }

    public function deleteitem($pve_id, $script, $drop_condiction, $drop_item_id)
    {
        /** @var PveInfoDropItem $drop */
        $drop = PveInfoDropItem::findOrFail($drop_item_id);
        if ($drop->delete()) {
            return 1;
        }
        return 0;
    }

    public function createItem($pve_id, $script, $drop_condiction)
    {
        /** @var CrudPanel $crud */
        $crud = app()->make('crud'); //make instance
        $crud->setModel(PveInfoDropItem::class); //set model for relationship & data query
        //of course, fields for the form are needed here
        $crud->addFields([
            [
                'name' => 'DropId',
                'label' => 'DropId',
                'type' => 'number',
                'value' => $drop_condiction,
                'attributes' => [
                    'disabled' => true
                ]
            ],
            [
                'name'  => 'ItemId',
                'label' => "Item",
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
                // 'include_all_form_fields'  => false, // optional - only send the current field through AJAX (for a smaller payload if you're not using multiple chained select2s)
            ],
            [
                'name' => 'ValueDate',
                'label' => 'Hạn sử dụng',
                'type' => 'number',
                'default' => 0,
            ],
            [
                'name' => 'Random',
                'label' => 'Random',
                'type' => 'number',
                'default' => 0,
            ],
            [
                'name' => 'BeginData',
                'label' => 'BeginData',
                'type' => 'number',
                'default' => 1,
            ],
            [
                'name' => 'EndData',
                'label' => 'EndData',
                'type' => 'number',
                'default' => 1,
            ],
            [
                'name' => 'IsBind',
                'label' => 'Khóa',
                'type' => 'checkbox',
            ],
            [
                'name' => 'IsTips',
                'label' => 'IsTips',
                'type' => 'checkbox',
                'hint' => 'Hiện thông báo khi người chơi mở được'
            ],
            [
                'name' => 'IsLogs',
                'label' => 'IsLogs',
                'type' => 'checkbox',
            ],
        ]);
        //don't know
//        $crud->setOperationSetting('fields', $crud->getUpdateFields());
        //save actions for the form
        $crud->setupDefaultSaveActions();
        //set the view for this update operation
        //it's depend on nested_crud update operation
        $crud->setCreateView('nested_crud::modals.create');
        $crud->allowAccess(['create']);

        $data = [];
        $data['crud'] = $crud;
        $data['saveAction'] = $crud->getSaveAction();
        $data['title'] = $crud->getTitle() ?? trans('backpack::crud.add').' '.$crud->entity_name;
        return view($crud->getCreateView(), $data);
    }

    public function storeItem($pve_id, $script, $drop_condiction)
    {
        /** @var PveInfoDropItem $drop */

        $request = request();
        $itemIds = $request->input('ItemId');
        $data = [];
        $data['DropId'] = $drop_condiction;
        $data['ValueDate'] = $request->input('ValueDate');
        $data['IsBind'] = $request->input('IsBind');
        $data['Random'] = $request->input('Random');
        $data['BeginData'] = $request->input('BeginData');
        $data['EndData'] = $request->input('EndData');
        $data['IsTips'] = $request->input('IsTips');
        $data['IsLogs'] = $request->input('IsLogs');
        if (is_array($itemIds)) {
            DB::connection((new PveInfoDropItem())->getConnectionName())->beginTransaction();
            foreach ($itemIds as $itemId) {
                $drop = new PveInfoDropItem(array_merge(['ItemId' => $itemId], $data));
                if (!$drop->save()) {
                    DB::connection($drop->getConnectionName())->rollBack();
                    return response()->json(['message' => 'Server Error Drop!', 500]);
                }
            }
            DB::connection((new PveInfoDropItem())->getConnectionName())->commit();
            return response()->json(['data' => $script]);
        } else {
            $drop = new PveInfoDropItem(array_merge(['ItemId' => $itemIds], $data));
            if ($drop->save()) {
                return response()->json(['data' => $script]);
            }
        }
        return 0;
    }
}
