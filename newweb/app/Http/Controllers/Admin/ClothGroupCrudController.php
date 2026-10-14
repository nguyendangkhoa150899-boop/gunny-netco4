<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Admin\Operations\buildxmlOperation;
use App\Http\Requests\MemberRequest;
use App\Http\Requests\AddCoinRequest;
use App\Http\Requests\BanMemberRequest;
use App\Http\Requests\QuestRequest;
use App\Models\BanMemberReason;
use App\Models\ClothGroupTemplate;
use App\Models\CoinLog;
use App\Models\Member;
use App\Models\Quest;
use App\Models\QuestCondiction;
use App\Models\QuestGoods;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;
use App\Models\Setting;
use Illuminate\Support\Facades\DB;

/**
 * Class MemberCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class ClothGroupCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
    use buildxmlOperation;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        $this->crud->setModel(\App\Models\ClothPropertyTemplate::class);
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/avatargroup');
        $this->crud->setEntityNameStrings('Bộ phụ kiện', 'Bộ phụ kiện');
        //$this->crud->allowAccess(['addcoin', 'bulkBanMember']);
        //$this->crud->denyAccess(['update', 'create', 'delete', 'memhistory', 'banmember']);
        $this->crud->allowAccess('buildxml');
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
                'name' => 'ID',
                'label' => 'ID',
                'type' => 'text'
            ],
            [
                'name' => 'Sex',
                'label' => 'Sex',
                'type' => 'model_function',
                'function_name' => 'getSexText'
            ],
            [
                'name' => 'Name',
                'label' => 'Name',
                'type' => 'text'
            ],
            [
                'name' => 'Attack',
                'label' => 'Attack',
                'type' => 'number'
            ],
            [
                'name' => 'Defend',
                'label' => 'Defend',
                'type' => 'number'
            ],
            [
                'name' => 'Agility',
                'label' => 'Agility',
                'type' => 'number'
            ],
            [
                'name' => 'Luck',
                'label' => 'Luck',
                'type' => 'number'
            ],
            [
                'name' => 'Blood',
                'label' => 'Blood',
                'type' => 'number'
            ],
            [
                'name' => 'Damage',
                'label' => 'Damage',
                'type' => 'number'
            ],
            [
                'name' => 'HoGiap',
                'label' => 'HoGiap',
                'type' => 'number'
            ],
            [
                'name' => 'Cost',
                'label' => 'Cost',
                'type' => 'number'
            ],
            [
                'name' => 'Type',
                'label' => 'Type',
                'type' => 'model_function',
                'function_name' => 'getTypeText'
            ],
            [
                'name' => 'Disabled',
                'label' => 'Disabled',
                'type' => 'check'
            ],
        ]);
        $this->crud->addFilter([
            'type'  => 'dropdown',
            'name'  => 'Type',
            'label' => 'Type'
        ], [
            1 => 'Trang phục',
            2 => 'Vũ khí',
        ],
            function($value) { // if the filter is active
                $this->crud->addClause('where', 'Type', $value);
            });
    }

    /**
     * Define what happens when the Create operation is loaded.
     *
     * @see https://backpackforlaravel.com/docs/crud-operation-create
     * @return void
     */
    protected function setupCreateOperation()
    {
        //$this->crud->setValidation(QuestRequest::class);

        //general information
        $tabGeneral = 'Thông tin bộ';
        $this->crud->addFields([
            [
                'name' => 'ID',
                'label' => 'ID',
                'type' => 'number',
                'tab' => $tabGeneral
            ],
            [
                'name' => 'Sex',
                'label' => 'Sex',
                'type' => 'number',
                'hint' => '1: Nam, 2,: Nữ, 3: Cả 2',
                'tab' => $tabGeneral
            ],
            [
                'name' => 'Name',
                'label' => 'Name',
                'type' => 'text',
                'tab' => $tabGeneral
            ],
            [
                'name' => 'Attack',
                'label' => 'Attack',
                'type' => 'number',
                'tab' => $tabGeneral
            ],
            [
                'name' => 'Defend',
                'label' => 'Defend',
                'type' => 'number',
                'tab' => $tabGeneral
            ],
            [
                'name' => 'Agility',
                'label' => 'Agility',
                'type' => 'number',
                'tab' => $tabGeneral
            ],
            [
                'name' => 'Luck',
                'label' => 'Luck',
                'type' => 'number',
                'tab' => $tabGeneral
            ],
            [
                'name' => 'Blood',
                'label' => 'Blood',
                'type' => 'number',
                'tab' => $tabGeneral
            ],
            [
                'name' => 'Damage',
                'label' => 'Damage',
                'type' => 'number',
                'tab' => $tabGeneral
            ],
            [
                'name' => 'HoGiap',
                'label' => 'HoGiap',
                'type' => 'number',
                'tab' => $tabGeneral
            ],
            [
                'name' => 'Cost',
                'label' => 'Cost',
                'type' => 'number',
                'tab' => $tabGeneral
            ],
            [
                'name' => 'Type',
                'label' => 'Type',
                'type' => 'number',
                'hint' => '1: Phụ ki,ện trang phục, 2: Vũ khí',
                'tab' => $tabGeneral
            ],
            [
                'name' => 'Disabled',
                'label' => 'Disabled',
                'type' => 'checkbox',
                'tab' => $tabGeneral
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
    protected function setupUpdateOperation()
    {
        $entry = $this->crud->getCurrentEntry();
        $this->crud->setEntityNameStrings(trans('admin.game.quest.title_single') . ' ' . $entry->Title, trans('admin.game.quest.title_multi'));
        $this->setupCreateOperation();

        $tabAward2 = 'Phụ kiện';
        $this->crud->addField([
            'name'      => 'templates',
            'label'     => '',
            'type'      => 'nested_crud',
            'target'    => 'templates',
            'model'     => ClothGroupTemplate::class,
            'tab'       => $tabAward2,  // optional
        ]);
    }

    public function buildxml()
    {
        $content = file_get_contents(
            trim(env('REQUEST_URL'), '/') . "/clothpropertytemplateinfo.ashx"
        );
        if ($content === "Build:clothpropertytemplateinfo.xml,Success!") {
            \Alert::success('Cập nhật clothpropertytemplateinfo thành công!')->flash();
        } else {
            \Alert::error('Cập nhật thất bại, kiểm tra lại cấu hình!')->flash();
        }
        $content = file_get_contents(
            trim(env('REQUEST_URL'), '/') . "/clothgrouptemplateinfo.ashx"
        );
        if ($content === "Build:clothgrouptemplateinfo.xml,Success!") {
            \Alert::success('Cập nhật clothgrouptemplateinfo thành công!')->flash();
        } else {
            \Alert::error('Cập nhật thất bại, kiểm tra lại cấu hình!')->flash();
        }
        return back();
    }
}
