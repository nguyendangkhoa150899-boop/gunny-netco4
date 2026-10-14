<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Admin\Operations\buildxmlOperation;
use App\Http\Requests\ConsortiaLevelCreateRequest;
use App\Http\Requests\EventRewardInfoRequest;
use App\Http\Requests\NoviceActivityTypeCreateRequest;
use App\Models\ActiveAward;
use App\Models\ConsortiaTaskConfig;
use App\Models\ConsortiaTaskReward;
use App\Models\EventRewardInfo;
use App\Models\EventRewardInfoNested;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class ActiveCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class ConsortiaLevelCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
//    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
//    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
    use buildxmlOperation;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        $this->crud->setModel(\App\Models\ConsortiaLevel::class);
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/consortialevels');
        $this->crud->setEntityNameStrings('cấp guild', 'Cấp guild');
    }

    /**
     * Define what happens when the List operation is loaded.
     *
     * @see  https://backpackforlaravel.com/docs/crud-operation-list-entries
     * @return void
     */
    protected function setupListOperation()
    {
//        $this->crud->enableDetailsRow();
        $this->crud->addColumns([
            [
                'name' => 'Level',
                'label' => 'Cấp',
                'type' => 'number',
            ],
            [
                'name' => 'Riches',
                'label' => 'Tài sản',
                'type' => 'number',
            ],
            [
                'name' => 'Deduct',
                'label' => 'Duy trì',
                'type' => 'number',
            ],
            [
                'name' => 'NeedGold',
                'label' => 'Gold',
                'type' => 'number',
            ],
            [
                'name' => 'Count',
                'label' => 'Số người',
                'type' => 'number',
            ],
            [
                'name' => 'StoreRiches',
                'label' => 'TS Két',
                'type' => 'number',
            ],
            [
                'name' => 'SmithRiches',
                'label' => 'TS Rèn',
                'type' => 'number',
            ],
            [
                'name' => 'ShopRiches',
                'label' => 'TS Shop',
                'type' => 'number',
            ],
            [
                'name' => 'BufferRiches',
                'label' => 'TS Kỹ năng',
                'type' => 'number',
            ],
            [
                'name' => 'KickMax',
                'label' => 'KickMax',
                'type' => 'number',
            ],
            [
                'name' => 'BossCount',
                'label' => 'BossCount',
                'type' => 'number',
            ],
        ]);

        /**
         * Columns can be defined using the fluent syntax or array syntax:
         * - CRUD::column('price')->type('number');
         * - CRUD::addColumn(['name' => 'price', 'type' => 'number']);
         */
    }

    /**
     * Define what happens when the Create operation is loaded.
     *
     * @see https://backpackforlaravel.com/docs/crud-operation-create
     * @return void
     */
    protected function setupUpdateOperation()
    {
        $this->crud->setValidation(ConsortiaLevelCreateRequest::class);
        $tab1 = 'Thông tin chung';
        $this->crud->addFields([
            [
                'name' => 'Level',
                'label' => 'Cấp',
                'type' => 'number',
                'attributes' => [
                    'disabled' => 'disabled',
                ],
                'tab' => $tab1
            ],
            [
                'name' => 'Riches',
                'label' => 'Tài sản',
                'type' => 'number',
                'hint' => 'Là số tài sản cần có để nâng lên cấp này',
                'tab' => $tab1
            ],
            [
                'name' => 'Deduct',
                'label' => 'Phí duy trì',
                'type' => 'number',
                'tab' => $tab1
            ],
            [
                'name' => 'NeedGold',
                'label' => 'Gold',
                'type' => 'number',
                'hint' => 'Là số Vàng cần có để nâng lên cấp này',
                'tab' => $tab1
            ],
            [
                'name' => 'Count',
                'label' => 'Số người tối đa',
                'type' => 'number',
                'tab' => $tab1
            ],
            [
                'name' => 'StoreRiches',
                'label' => 'Tài sản Két',
                'type' => 'number',
                'hint' => 'Là số tài sản cần có để nâng két guild lên cấp này',
                'tab' => $tab1
            ],
            [
                'name' => 'SmithRiches',
                'label' => 'Tài sản Rèn',
                'type' => 'number',
                'hint' => 'Là số tài sản cần có để nâng rèn guild lên cấp này',
                'tab' => $tab1
            ],
            [
                'name' => 'ShopRiches',
                'label' => 'Tài sản Shop',
                'type' => 'number',
                'hint' => 'Là số tài sản cần có để nâng Shop guild lên cấp này',
                'tab' => $tab1
            ],
            [
                'name' => 'BufferRiches',
                'label' => 'Tài sản Kỹ năng',
                'type' => 'number',
                'hint' => 'Là số tài sản cần có để nâng Kỹ năng guild lên cấp này',
                'tab' => $tab1
            ],
            [
                'name' => 'KickMax',
                'label' => 'KickMax',
                'type' => 'number',
                'hint' => 'Số người kick tối đa trong 1 ngày',
                'tab' => $tab1
            ],
            [
                'name' => 'BossCount',
                'label' => 'BossCount',
                'type' => 'number',
                'hint' => 'Số lần đánh boss tối đa trong 1 ngày',
                'tab' => $tab1
            ],
        ]);

        $tabAward2 = 'Sứ mệnh Guild (Điều kiện)';
        $this->crud->addField([
            'name'      => 'tasks',
            'label'     => '',
            'type'      => 'nested_crud',
            'target'    => 'tasks',
            'model'     => ConsortiaTaskConfig::class,
            'tab'       => $tabAward2,  // optional
        ]);

        $tabAward3 = 'Sứ mệnh Guild (Phần thưởng)';
        $this->crud->addField([
            'name'      => 'rewards',
            'label'     => '',
            'type'      => 'nested_crud',
            'target'    => 'rewards',
            'model'     => ConsortiaTaskReward::class,
            'tab'       => $tabAward3,  // optional
        ]);
    }

    public function buildxml()
    {
        $content = file_get_contents(
            trim(env('REQUEST_URL'), '/') . "/ConsortiaLevelList.ashx"
        );
        if ($content === "Build:ConsortiaLevelList.xml,Success!") {
            \Alert::success('Cập nhật ConsortiaLevelList thành công!')->flash();
        } else {
            \Alert::error('Cập nhật thất bại, kiểm tra lại cấu hình!')->flash();
        }
        return back();
    }
}
