<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Admin\Operations\buildxmlOperation;
use App\Http\Requests\EventRewardInfoRequest;
use App\Http\Requests\NoviceActivityTypeCreateRequest;
use App\Models\ActiveAward;
use App\Models\EventRewardInfo;
use App\Models\EventRewardInfoNested;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class ActiveCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class NoviceActivityCrudController extends CrudController
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
        $this->crud->setModel(\App\Models\EventReward::class);
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/noviceactivity');
        $this->crud->setEntityNameStrings('hấp dẫn', 'Hấp dẫn');
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
                'name'  => 'ID',
                'label' => 'Loại hấp dẫn',
                'type'  => 'number',
            ],
            [
                'name'  => 'Label',
                'label' => 'Tên loại hấp dẫn',
                'type'  => 'text',
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
        $entry = $this->crud->getCurrentEntry();
        $this->crud->setEntityNameStrings($entry->Label, 'Hấp dẫn');
        $tab1 = 'Thông tin chung';
        $this->crud->addFields([
            [
                'name'  => 'ID',
                'label' => 'Loại hấp dẫn',
                'type'  => 'number',
                'attributes' => [
                    'disabled' => 'disabled',
                ],
                'tab' => $tab1
            ],
            [
                'name'  => 'Label',
                'label' => 'Tên loại hấp dẫn',
                'type'  => 'text',
                'attributes' => [
                    'disabled' => 'disabled',
                ],
                'tab' => $tab1
            ],
        ]);

        $tabAward2 = 'Mốc thưởng';
        $this->crud->addField([
            'name'      => 'subactivity',
            'label'     => $tabAward2,
            'type'      => 'nested_crud',
            'target'    => 'subactivity',
            'model'     => EventRewardInfo::class,
            'tab'       => $tabAward2,  // optional
        ]);
    }

    public function buildxml()
    {
        $content = file_get_contents(
            trim(env('REQUEST_URL'), '/') . "/eventrewarditemlist.ashx"
        );
        if ($content === "Build:eventrewarditemlist.xml,Success!") {
            \Alert::success('Cập nhật Novice Activity thành công!')->flash();
        } else {
            \Alert::error('Cập nhật thất bại, kiểm tra lại cấu hình!')->flash();
        }
        return back();
    }
}
