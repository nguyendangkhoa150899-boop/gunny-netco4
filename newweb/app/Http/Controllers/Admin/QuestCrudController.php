<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Admin\Operations\buildxmlOperation;
use App\Http\Requests\MemberRequest;
use App\Http\Requests\AddCoinRequest;
use App\Http\Requests\BanMemberRequest;
use App\Http\Requests\QuestRequest;
use App\Models\BanMemberReason;
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
class QuestCrudController extends CrudController
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
        $this->crud->setModel(\App\Models\Quest::class);
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/quest');
        $this->crud->setEntityNameStrings(trans('admin.game.quest.title_single'), trans('admin.game.quest.title_multi'));
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
                'name'  => 'ID',
                'label' => 'ID',
                'type'  => 'number',
            ],
            [
                'name'  => 'Title',
                'label' => trans('admin.game.quest.labels.Title'),
                'type'  => 'text',
            ],
            [
                'name'  => 'QuestID',
                'label' => trans('admin.game.quest.labels.QuestID'),
                'type'  => 'model_function',
                'function_name' => 'QuestType'
            ],
            [
                'name'  => 'RewardGP',
                'label' => trans('admin.game.quest.labels.RewardGP'),
                'type'  => 'text'
            ],
            [
                'name'  => 'RewardGold',
                'label' => trans('admin.game.quest.labels.RewardGold'),
                'type'  => 'text'
            ],
            [
                'name'  => 'RewardMedal',
                'label' => trans('admin.game.quest.labels.RewardMedal'),
                'type'  => 'text'
            ],
            [
                'name'  => 'RewardGiftToken',
                'label' => trans('admin.game.quest.labels.RewardGiftToken'),
                'type'  => 'text'
            ],
            [
                'name'  => 'NeedMinLevel',
                'label' => trans('admin.game.quest.labels.NeedMinLevel'),
                'type'  => 'number'
            ],
            [
                'name'  => 'NeedMaxLevel',
                'label' => trans('admin.game.quest.labels.NeedMaxLevel'),
                'type'  => 'number'
            ],
            /*[
                'name'  => 'PreQuestID',
                'label' => trans('admin.game.quest.labels.PreQuestID'),
                'type' => 'select',
                'entity'    => 'PreQuest', // the method that defines the relationship in your Model
                'attribute' => 'Title', // foreign key attribute that is shown to user
                'model'     => Quest::class, // foreign key model
            ],
            [
                'name'  => 'NextQuestID',
                'label' => trans('admin.game.quest.labels.NextQuestID'),
                'type' => 'select',
                'entity'    => 'NextQuest', // the method that defines the relationship in your Model
                'attribute' => 'Title', // foreign key attribute that is shown to user
                'model'     => Quest::class, // foreign key model
            ],*/
            [
                'name'  => 'StartDate',
                'label' => trans('admin.game.quest.labels.StartDate'),
                'type'  => 'date',
                'format' => 'DD/MM/YYYY'
            ],
            [
                'name'  => 'EndDate',
                'label' => trans('admin.game.quest.labels.EndDate'),
                'type'  => 'date',
                'format' => 'DD/MM/YYYY'
            ],
        ]);

        $this->crud->addFilter(
            [
                'type'  => 'select2_multiple',
                'name'  => 'QuestID',
                'label' => 'Loại nhiệm vụ'
            ],
            function () {
                return \App\Models\Quest::QuestTypes();
            },
            function($values) {
                $this->crud->addClause('whereIn', 'QuestID', json_decode($values));
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
        $this->crud->setValidation(QuestRequest::class);

        //general information
        $tabGeneral = 'Thông tin nhiệm vụ';
        $this->crud->addFields([
            [
                'name' => 'ID',
                'label' => 'ID',
                'type' => 'number',
                'hint' => 'Current Last ID: '.Quest::select('ID')->orderBy('ID', 'DESC')->first()->ID,
                'tab' => $tabGeneral,
            ],
            [
                'name' => 'Title',
                'label' => trans('admin.game.quest.labels.Title'),
                'type' => 'text',
                'tab' => $tabGeneral,
            ],
            [
                'name' => 'QuestID',
                'label' => trans('admin.game.quest.labels.QuestID'),
                'type' => 'select_from_array',
                'options' => Quest::QuestTypes(),
                'allows_null' => false,
                'tab' => $tabGeneral,
            ],
            [
                'name' => 'Detail',
                'label' => trans('admin.game.quest.labels.Detail'),
                'type' => 'textarea',
                'tab' => $tabGeneral,
            ],
            [
                'name' => 'Objective',
                'type' => 'hidden',
                'default' => '',
                'tab' => $tabGeneral,
            ],
            [
                'name' => 'NeedMinLevel',
                'label' => trans('admin.game.quest.labels.NeedMinLevelFull'),
                'type' => 'number',
                'default' => 0,
                'tab' => $tabGeneral,
            ],
            [
                'name' => 'NeedMaxLevel',
                'label' => trans('admin.game.quest.labels.NeedMaxLevelFull'),
                'type' => 'number',
                'default' => 0,
                'tab' => $tabGeneral,
            ],
            [
                'name' => 'PreQuestID',
                'label' => trans('admin.game.quest.labels.PreQuestIDFull'),
                'type' => 'text',
                'default' => '0,',
                'hint' => 'Nhiệm vụ cần thực hiện trước khi có nhiệm vụ này',
                'tab' => $tabGeneral,
            ],
            [
                'name' => 'NextQuestID',
                'label' => trans('admin.game.quest.labels.NextQuestIDFull'),
                'type' => 'text',
                'default' => '0,',
                'hint' => 'Nhiệm vụ có sau khi nhiệm vụ này hoàn thành',
                'tab' => $tabGeneral,
            ],
            [
                'name' => 'IsOther',
                'label' => 'IsOther',
                'type' => 'number',
                'default' => 0,
                'hint' => '0 = default, 1 = nv liên quan Guild, 2 = nv liên quan kết hôn, 4 = nv liên quan bạn bè',
                'tab' => $tabGeneral,
            ],
            [
                'name' => 'CanRepeat',
                'label' => trans('admin.game.quest.labels.CanRepeat'),
                'type' => 'checkbox',
                'default' => 0,
                'tab' => $tabGeneral,
            ],
            [
                'name' => 'RepeatInterval',
                'label' => 'RepeatInterval',
                'type' => 'number',
                'default' => 1,
                'hint' => 'Chưa biết để làm gì, bổ sung sau',
                'tab' => $tabGeneral,
            ],
            [
                'name' => 'RepeatMax',
                'label' => trans('admin.game.quest.labels.RepeatMax'),
                'type' => 'number',
                'default' => 1,
                'tab' => $tabGeneral,
            ],
            [
                'name' => 'separator',
                'label' => trans('admin.game.quest.labels.TimeDivider'),
                'type' => 'divider',
                'tab' => $tabGeneral,
            ],
            [
                'name' => 'StartDate',
                'label' => trans('admin.game.quest.labels.StartDate'),
                'type' => 'date',
                'default' => date('d/m/Y'),
                'format' => 'DD/MM/YYYY',
                'tab' => $tabGeneral,
            ],
            [
                'name' => 'EndDate',
                'label' => trans('admin.game.quest.labels.EndDate'),
                'type' => 'date',
                'default' => date('Y-m-d'),
                'format' => 'DD/MM/YYYY',
                'tab' => $tabGeneral,
            ],
        ]);

        //awards
        $tabAward1 = 'Phần thưởng';
        $this->crud->addFields([
            [
                'name' => 'RewardGold',
                'label' => trans('admin.game.quest.labels.RewardGold'),
                'type' => 'number',
                'default' => 0,
                'tab' => $tabAward1,
            ],
            [
                'name' => 'RewardGP',
                'label' => trans('admin.game.quest.labels.RewardGP'),
                'type' => 'number',
                'default' => 0,
                'tab' => $tabAward1,
            ],
            [
                'name' => 'RewardGiftToken',
                'label' => trans('admin.game.quest.labels.RewardGiftToken'),
                'type' => 'number',
                'default' => 0,
                'tab' => $tabAward1,
            ],
            [
                'name' => 'RewardOffer',
                'label' => trans('admin.game.quest.labels.RewardOffer'),
                'type' => 'number',
                'default' => 0,
                'tab' => $tabAward1,
            ],
            [
                'name' => 'RewardMedal',
                'label' => trans('admin.game.quest.labels.RewardMedalFull'),
                'type' => 'number',
                'default' => 0,
                'tab' => $tabAward1,
            ],
            [
                'name' => 'RewardMoney',
                'label' => trans('admin.game.quest.labels.RewardMoney'),
                'type' => 'number',
                'default' => 0,
                'tab' => $tabAward1,
            ],
            [
                'name' => 'RewardRiches',
                'label' => trans('admin.game.quest.labels.RewardRiches'),
                'type' => 'number',
                'default' => 0,
                'tab' => $tabAward1,
            ],
            [
                'name' => 'RewardBuffID',
                'label' => trans('admin.game.quest.labels.RewardBuffID'),
                'type' => 'number',
                'default' => 0,
                'tab' => $tabAward1,
            ],
            [
                'name' => 'RewardBuffDate',
                'label' => trans('admin.game.quest.labels.RewardBuffDate'),
                'type' => 'number',
                'default' => 0,
                'tab' => $tabAward1,
            ],
            [
                'name' => 'Rands',
                'label' => trans('admin.game.quest.labels.Rands'),
                'type' => 'number',
                'default' => 0,
                'suffix' => '.00',
                'tab' => $tabAward1,
            ],
            [
                'name' => 'RandDouble',
                'label' => trans('admin.game.quest.labels.RandDouble'),
                'type' => 'number',
                'default' => 0,
                'hint' => 'Thông tin này chỉ ảnh hưởng khi nv xanh được kích hoạt',
                'tab' => $tabAward1,
            ],
            [
                'name' => 'TimeMode',
                'label' => trans('admin.game.quest.labels.TimeMode'),
                'type' => 'number',
                'default' => 0,
                'hint' => 'Không biết là gì, add vào cho có',
                'tab' => $tabAward1,
            ],
            [
                'name' => 'MapID',
                'label' => trans('admin.game.quest.labels.MapID'),
                'type' => 'number',
                'default' => 0,
                'hint' => 'Không biết là gì, add vào cho có',
                'tab' => $tabAward1,
            ],
            [
                'name' => 'AutoEquip',
                'label' => trans('admin.game.quest.labels.AutoEquip'),
                'type' => 'number',
                'default' => 0,
                'hint' => 'Không biết là gì, add vào cho có',
                'tab' => $tabAward1,
            ],
            [
                'name' => 'Rank',
                'label' => trans('admin.game.quest.labels.Rank'),
                'type' => 'text',
                'default' => "",
                'hint' => 'Không biết là gì, add vào cho có',
                'tab' => $tabAward1,
            ],
            [
                'name' => 'StarLev',
                'label' => trans('admin.game.quest.labels.StarLev'),
                'type' => 'number',
                'default' => 0,
                'hint' => 'Không biết là gì, add vào cho có',
                'tab' => $tabAward1,
            ],
            [
                'name' => 'NotMustCount',
                'label' => trans('admin.game.quest.labels.NotMustCount'),
                'type' => 'number',
                'default' => 0,
                'hint' => 'Không biết là gì, add vào cho có',
                'tab' => $tabAward1,
            ],
        ]);

        /**
         * Fields can be defined using the fluent syntax or array syntax:
         * - CRUD::field('price')->type('number');
         * - CRUD::addField(['name' => 'price', 'type' => 'number']));
         */
    }

    public function store()
    {
        $this->crud->hasAccessOrFail('create');

        // execute the FormRequest authorization and validation, if one is required
        $request = $this->crud->validateRequest();
        $data = $this->crud->getStrippedSaveRequest();
        if (!empty($data['StartDate'])) {
            $data['StartDate'] = date('Y-m-d 00:00:00.000', strtotime($data['StartDate']));
        }
        if (!empty($data['EndDate'])) {
            $data['EndDate'] = date('Y-m-d 23:59:59.000', strtotime($data['EndDate']));
        }
        // insert item in the db
        $item = $this->crud->create($data);
        $this->data['entry'] = $this->crud->entry = $item;

        // show a success message
        \Alert::success(trans('backpack::crud.insert_success'))->flash();

        // save the redirect choice for next time
        $this->crud->setSaveAction();

        return $this->crud->performSaveAction($item->getKey());
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

        $tabAward2 = 'Phần thưởng (Item)';
        $this->crud->addField([
            'name'      => 'goods',
            'label'     => '',
            'type'      => 'nested_crud',
            'target'    => 'goods',
            'model'     => QuestGoods::class,
            'tab'       => $tabAward2,  // optional
        ]);

        $tabAward3 = 'Condiction';
        $this->crud->addField([
            'name'      => 'condiction',
            'label'     => '',
            'type'      => 'nested_crud',
            'target'    => 'condiction',
            'model'     => QuestCondiction::class,
            'tab'       => $tabAward3,
        ]);
    }

    public function update()
    {
        $this->crud->hasAccessOrFail('update');

        // execute the FormRequest authorization and validation, if one is required
        $request = $this->crud->validateRequest();
        $data = $this->crud->getStrippedSaveRequest();
        if (!empty($data['StartDate'])) {
            $data['StartDate'] = date('Y-m-d 00:00:00.000', strtotime($data['StartDate']));
        }
        if (!empty($data['EndDate'])) {
            $data['EndDate'] = date('Y-m-d 23:59:59.000', strtotime($data['EndDate']));
        }
        // update the row in the db
        $item = $this->crud->update($request->get($this->crud->model->getKeyName()), $data);
        $this->data['entry'] = $this->crud->entry = $item;

        // show a success message
        \Alert::success(trans('backpack::crud.update_success'))->flash();

        // save the redirect choice for next time
        $this->crud->setSaveAction();

        return $this->crud->performSaveAction($item->getKey());
    }

    public function buildxml()
    {
        $content = file_get_contents(
            trim(env('REQUEST_URL'), '/') . "/QuestList.ashx"
        );
        if ($content === "Build:QuestList.xml,Success!") {
            \Alert::success('Cập nhật QuestList thành công!')->flash();
        } else {
            \Alert::error('Cập nhật thất bại, kiểm tra lại cấu hình!')->flash();
        }
        return back();
    }
}
