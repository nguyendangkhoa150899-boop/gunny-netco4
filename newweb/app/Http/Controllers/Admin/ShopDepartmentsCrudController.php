<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Admin\Operations\buildxmlOperation;
use App\Http\Requests\ShopGoodsRequest;
use App\Models\ShopGoodsCategory;
use App\Models\ShopGoodsShowList;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class ShopGoodsCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class ShopDepartmentsCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
//    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
//    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
//    use \Backpack\CRUD\app\Http\Controllers\Operations\ShowOperation;
//    use buildxmlOperation;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        $this->crud->setModel(\App\Models\ShopType::class);
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/shopdepartments');
        $this->crud->setEntityNameStrings('Gian hàng', 'Gian hàng');
        $this->crud->orderBy('ID', 'ASC');
    }

    /**
     * Define what happens when the List operation is loaded.
     *
     * @see  https://backpackforlaravel.com/docs/crud-operation-list-entries
     * @return void
     */
    protected function setupListOperation()
    {
        $this->crud->setColumns([
            [
                'name'  => 'ID',
                'label' => 'ID',
                'type'  => 'number',
            ],[
                'name'  => 'Name',
                'label' => 'Name',
                'type'  => 'text',
            ],

        ]);
    }

    /**
     * Define what happens when the Update operation is loaded.
     *
     * @see https://backpackforlaravel.com/docs/crud-operation-update
     * @return void
     */
    protected function setupUpdateOperation()
    {
        $entry = $this->crud->getCurrentEntry();
        $this->crud->setEntityNameStrings($entry->Name, 'Gian hàng');
        $tab = 'Thông tin chung';
        $this->crud->addFields([
            [
                'name' => 'ID',
                'label' => 'ID',
                'type' => 'number',
                'attributes' => [
                    'disabled' => true
                ],
                'tab' => $tab
            ],
            [
                'name' => 'Name',
                'label' => 'Name',
                'type' => 'text',
                'attributes' => [
                    'disabled' => true
                ],
                'tab' => $tab
            ],
        ]);
        $this->crud->addField([
            'name'      => 'items',
            'label'     => 'Vật phẩm',
            'type'      => 'nested_crud',
            'target'    => 'items',
            'model'     => ShopGoodsShowList::class,
            'tab'       => 'Vật phẩm',  // optional
            'modal_size' => 'modal-xl'
        ]);
    }
}
