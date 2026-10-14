<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\EventRewardGoodsRequest;
use App\Http\Requests\EventRewardInfoRequest;
use App\Models\PveInfoHards;
use App\Models\PveInfo;
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
class PveTemplateCrudController extends CrudController
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
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/pveinfo/'.$PveId.'/templates');
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
            $item->ID = 'SimpleTemplateIds';
            $item->name = 'Dễ';
            $entries->push($item);
        }
        if (!empty($pveInfo->NormalGameScript)) {
            $item = new PveInfoHards();
            $item->ID = 'NormalTemplateIds';
            $item->name = 'Thường';
            $entries->push($item);
        }
        if (!empty($pveInfo->HardGameScript)) {
            $item = new PveInfoHards();
            $item->ID = 'HardTemplateIds';
            $item->name = 'Khó';
            $entries->push($item);
        }
        if (!empty($pveInfo->TerrorGameScript)) {
            $item = new PveInfoHards();
            $item->ID = 'TerrorTemplateIds';
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
        $crud->setModel(PveInfoTemplates::class); //set model for relationship & data query
//        $crud->setRoute(config('backpack.base.route_prefix') . '/pveinfo/'.$PveId.'/templates');
        //of course, fields for the form are needed here
        $crud->addColumns([
            [
                'name'      => 'row_number',
                'type'      => 'number',
                'label'     => '#',
                'orderable' => false,
            ],
            [
                'name'  => 'TemplateID',
                'label' => 'TemplateID',
                'type'  => 'number',
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
                'name'  => 'Image',
                'label' => 'Image',
                'type'  => 'model_function',
                'function_name' => 'ResourceImageColumn',
                'limit' => 999,
            ],
        ]);
        $crud->setOperationSetting('nestedDetailsModelClass', PveInfoHards::class, 'detailsRow');
        $crud->setRoute(config('backpack.base.route_prefix') . '/pveinfo/'.$pve_id.'/templates/'.$hard_level);
        $crud->setListView('nested_crud::details_row_nested_list');
        $crud->addButton('line', 'nested_list_details_row_delete', 'view', 'nested_crud::buttons.details_row_delete');
        $crud->setupDefaultSaveActions();
        $crud->allowAccess('create');

        $pveInfo = PveInfo::find($pve_id);
        $templates = $pveInfo[$hard_level];
        $templates = explode(',', $templates);
        $data = [];
        $entries = new Collection();
        foreach ($templates as $i => $template) {
            $item = new PveInfoTemplates();
            $item->TemplateID = $template;
            $item->row_number = $i+1;
            $item->parentEntryId = $hard_level;
            $item->load('Item');
            $entries->push($item);
        }
        $data['entries'] = $entries;
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

        Route::get($segment.'/{hard_level}/{template_id}/delete', [
            'as'        => $routeName.'@deleteGoods',
            'uses'      => $controller.'@deleteGoods',
            'operation' => 'delete',
        ])->where('hard_level', '^((?!ajax).)*$');

        Route::get($segment.'/{hard_level}/create', [
            'as'        => $routeName.'@createGoods',
            'uses'      => $controller.'@createGoods',
            'operation' => 'create',
        ])->where('hard_level', '^((?!ajax).)*$');

        Route::post($segment.'/{hard_level}/create', [
            'as'        => $routeName.'@storeGoods',
            'uses'      => $controller.'@storeGoods',
            'operation' => 'create',
        ])->where('hard_level', '^((?!ajax).)*$');
    }

    public function deleteGoods($pve_id, $hard_level, $template_id)
    {
        $pveInfo = PveInfo::find($pve_id);
        $templates = $pveInfo[$hard_level];
        $templates = explode(',', $templates);
        unset($templates[array_search($template_id, $templates)]);
        $pveInfo[$hard_level] = implode(',', $templates);
        return $pveInfo->save();
    }

    public function createGoods($pve_id, $hard_level)
    {
        $crud = app()->make('crud'); //make instance
        $crud->setModel(PveInfoTemplates::class); //set model for relationship & data query
        //of course, fields for the form are needed here
        $crud->addFields([
            [
                'name'  => 'TemplateID',
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

    public function storeGoods($pve_id, $hard_level)
    {
        $pveInfo = PveInfo::find($pve_id);
        $templates = $pveInfo[$hard_level];
        $templates = explode(',', $templates);
        $request = request();
        $items = $request->TemplateID;
        if (is_array($items)) {
            $templates = array_merge($templates, $items);
        } else {
            $templates[] = $items;
        }
        $pveInfo[$hard_level] = implode(',', $templates);
        if ($pveInfo->save()) {
            return 1;
        }
        return 0;
    }
}
