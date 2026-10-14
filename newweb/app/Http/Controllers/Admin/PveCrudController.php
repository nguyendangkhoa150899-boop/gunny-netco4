<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Admin\Operations\ActiveAwardOperation;
use App\Http\Controllers\Admin\Operations\buildxmlOperation;
use App\Http\Controllers\Admin\Operations\CreateGiftCodeOperation;
use App\Http\Requests\ActiveRequest;
use App\Models\Active;
use App\Models\ActiveAward;
use App\Models\PveInfo;
use App\Models\PveInfoDropCondiction;
use App\Models\PveInfoDropItem;
use App\Models\PveInfoHards;
use App\Models\PveInfoMissions;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class ActiveCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class PveCrudController extends CrudController
{
    //use ActiveAwardOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
    use buildxmlOperation;
    //use CreateGiftCodeOperation;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        $this->crud->setModel(\App\Models\PveInfo::class);
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/pveinfo');
        $this->crud->setEntityNameStrings('phó bản', 'Phó bản');
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
        $this->crud->addColumns([
            [
                'name'  => 'ID',
                'label' => 'ID',
                'type'  => 'number',
            ],
            [
                'name'  => 'Name',
                'label' => 'Name',
                'type'  => 'text',
            ],
            [
                'name'  => 'Type',
                'label' => 'Type',
                'type'  => 'model_function',
                'function_name' => 'getTypeText'
            ],
            [
                'name'  => 'LevelLimits',
                'label' => 'LevelLimits',
                'type'  => 'number',
            ],
            [
                'name'  => 'Ordering',
                'label' => 'Ordering',
                'type'  => 'number',
            ],
            [
                'name'  => 'CanOpenBoss',
                'label' => 'CanOpenBoss',
                'type'  => 'check',
            ],
            [
                'name'  => 'Disabled',
                'label' => 'Disabled',
                'type'  => 'check',
            ],
        ]);
    }

    /**
     * Define what happens when the Create operation is loaded.
     *
     * @see https://backpackforlaravel.com/docs/crud-operation-create
     * @return void
     */
    protected function setupCreateOperation()
    {
        $this->crud->setValidation(ActiveRequest::class);

        $tab = 'Thông tin chung';
        $this->crud->addFields([
            [
                'name' => 'ID',
                'label' => 'ID',
                'type' => 'number',
                'tab' => $tab
            ],
            [
                'name' => 'Name',
                'label' => 'Name',
                'type' => 'text',
                'tab' => $tab
            ],
            [
                'name' => 'Type',
                'label' => 'Type',
                'type' => 'text',
                'default' => 4,
                'hint' => implode(', ', array_map(function($k, $v){
                    return "$k = $v";
                }, array_keys(PveInfo::PveTypes()), array_values(PveInfo::PveTypes()))),
                'tab' => $tab
            ],
            [
                'name' => 'LevelLimits',
                'label' => 'LevelLimits',
                'type' => 'number',
                'tab' => $tab
            ],
            [
                'name' => 'Pic',
                'label' => 'Pic',
                'type' => 'text',
                'tab' => $tab
            ],
            [
                'name' => 'Description',
                'label' => 'Description',
                'type' => 'textarea',
                'tab' => $tab
            ],
            [
                'name' => 'SimpleGameScript',
                'label' => 'SimpleGameScript',
                'type' => 'text',
                'hint' => 'Script cho ải dễ, ko phận sự để yên',
                'tab' => $tab
            ],
            [
                'name' => 'NormalGameScript',
                'label' => 'NormalGameScript',
                'type' => 'text',
                'hint' => 'Script cho ải thường, ko phận sự để yên',
                'tab' => $tab
            ],
            [
                'name' => 'HardGameScript',
                'label' => 'HardGameScript',
                'type' => 'text',
                'hint' => 'Script cho ải khó, ko phận sự để yên',
                'tab' => $tab
            ],
            [
                'name' => 'TerrorGameScript',
                'label' => 'TerrorGameScript',
                'type' => 'text',
                'hint' => 'Script cho ải anh hùng, ko phận sự để yên',
                'tab' => $tab
            ],
            [
                'name' => 'Ordering',
                'label' => 'Ordering',
                'type' => 'text',
                'tab' => $tab
            ],
            [
                'name' => 'AdviceTips',
                'label' => 'Level đề nghị',
                'type' => 'text',
                'hint' => 'Các độ khó cách nhau bởi dấu |',
                'tab' => $tab
            ],
            [
                'name' => 'BossFightNeedMoney',
                'label' => 'Số xu mở ải cuối',
                'type' => 'text',
                'hint' => 'Các độ khó cách nhau bởi dấu |',
                'tab' => $tab
            ],
            [
                'name' => 'FightPower',
                'label' => 'Lực chiến đề nghị',
                'type' => 'text',
                'hint' => 'Các độ khó cách nhau bởi dấu |',
                'tab' => $tab
            ],
            [
                'name' => 'Disabled',
                'label' => 'Disabled',
                'type' => 'checkbox',
                'hint' => 'tick = ẩn, /hiện',
                'tab' => $tab
            ],
            [
                'name' => 'CanOpenBoss',
                'label' => 'CanOpenBoss',
                'type' => 'checkbox',
                'hint' => 'cho phép mở ải cuối',
                'tab' => $tab
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
        $this->setupCreateOperation();
        $pveInfo = $this->crud->getCurrentEntry();
        $this->crud->entity_name = $pveInfo->Name;
        $this->crud->addField([
            'name'      => 'templates',
            'label'     => 'Items',
            'type'      => 'nested_crud',
            'target'    => 'templates',
            'model'     => PveInfoHards::class,
            'tab'       => 'Items',  // optional
        ]);
        $this->crud->addField([
            'name'      => 'missions',
            'label'     => 'Missions',
            'type'      => 'nested_crud',
            'target'    => 'missions',
            'model'     => PveInfoMissions::class,
            'tab'       => 'Missions',  // optional
        ]);
        $this->crud->addField([
            'name'      => 'condictions',
            'label'     => 'DropCondictions',
            'type'      => 'nested_crud',
            'target'    => 'condictions',
            'model'     => PveInfoDropCondiction::class,
            'tab'       => 'DropCondictions',  // optional
        ]);

        if (!empty($pveInfo->SimpleGameScript)) {
            $this->crud->addField([
                'name'      => 'dropSimpleGameScript',
                'label'     => 'Items',
                'type'      => 'nested_crud',
                'target'    => 'drops/SimpleGameScript',
                'model'     => PveInfoDropItem::class,
                'tab'       => 'Drop(simple)',  // optional
            ]);
        }
        if (!empty($pveInfo->NormalGameScript)) {
            $this->crud->addField([
                'name'      => 'dropNormalGameScript',
                'label'     => 'Items',
                'type'      => 'nested_crud',
                'target'    => 'drops/NormalGameScript',
                'model'     => PveInfoDropItem::class,
                'tab'       => 'Drop(normal)',  // optional
            ]);
        }
        if (!empty($pveInfo->HardGameScript)) {
            $this->crud->addField([
                'name'      => 'dropHardGameScript',
                'label'     => 'Items',
                'type'      => 'nested_crud',
                'target'    => 'drops/HardGameScript',
                'model'     => PveInfoDropItem::class,
                'tab'       => 'Drop(hard)',  // optional
            ]);
        }
        if (!empty($pveInfo->TerrorGameScript)) {
            $this->crud->addField([
                'name'      => 'dropTerrorGameScript',
                'label'     => 'Items',
                'type'      => 'nested_crud',
                'target'    => 'drops/TerrorGameScript',
                'model'     => PveInfoDropItem::class,
                'tab'       => 'Drop(terror)',  // optional
            ]);
        }

    }

    public function buildxml()
    {
        $content = file_get_contents(
            trim(env('REQUEST_URL'), '/') . "/ActiveList.ashx"
        );
        if ($content === "Build:ActiveList.xml,Success!") {
            \Alert::success('Cập nhật ActiveList thành công!')->flash();
        } else {
            \Alert::error('Cập nhật thất bại, kiểm tra lại cấu hình!')->flash();
        }
        return back();
    }
}
