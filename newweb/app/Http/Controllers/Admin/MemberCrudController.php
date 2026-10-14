<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\MemberRequest;
use App\Http\Requests\AddCoinRequest;
use App\Http\Requests\BanMemberRequest;
use App\Http\Requests\RessetPasswordRequest;
use App\Models\BanMemberReason;
use App\Models\CoinLog;
use App\Models\Member;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;
use App\Models\Setting;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Hash;

/**
 * Class MemberCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class MemberCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
    use \App\Http\Controllers\Admin\Operations\AddCoinOperation;
    use \App\Http\Controllers\Admin\Operations\MemHistoryOperation;
    use \App\Http\Controllers\Admin\Operations\BanMemberOperation;
    use \App\Http\Controllers\Admin\Operations\ResetPasswordOperation;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        $this->crud->setModel(\App\Models\Member::class);
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/member');
        $this->crud->setEntityNameStrings(trans('member.member'), trans('member.members'));
        $this->crud->allowAccess(['addcoin', 'bulkBanMember', 'ressetpassword']);
        $this->crud->denyAccess(['update', 'create', 'delete', 'memhistory', 'banmember']);
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
                'name'  => 'UserID',
                'label' => trans('member.UserID'),
                'type'  => 'text',
            ],
            [
                'name'  => 'Email',
                'label' => trans('member.Email'),
                'type'  => 'text',
            ],
            [
                'name'  => 'Money',
                'label' => trans('member.Money'),
                'type'  => 'number',
            ],
            [
                'name'  => 'IsBan',
                'label' => trans('member.IsBan'),
                'type'  => 'check'
            ],
            [
                'name'  => 'reason',
                'label' => trans('member.BanReason'),
                'type'  => 'model_function',
                'function_name' => 'BanReason'
            ],
            [
                'name'  => 'IPCreate',
                'label' => trans('member.IPCreate'),
                'type'  => 'text'
            ],
            [
                'name'  => 'TotalCharged',
                'label' => 'Nạp',
                'type'  => 'model_function',
                'function_name' => 'getTotalCharged'
            ],
        ]);
        $this->crud->enableBulkActions();
        $this->crud->addButton('top', 'bulk_ban_member', 'view', 'crud::buttons.bulk_ban_member');
    }

    /**
     * Define what happens when the Create operation is loaded.
     *
     * @see https://backpackforlaravel.com/docs/crud-operation-create
     * @return void
     */
    protected function setupCreateOperation()
    {
        $this->crud->setValidation(MemberRequest::class);

        $this->crud->setFromDb(); // fields

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
        $this->setupCreateOperation();
    }

    public function addcoin(AddCoinRequest $request)
    {
        $money = $request->input('money');
        $money = floatval($money);
        if (empty($money)) {
            echo json_encode(['success' => 0]);
            return;
        }
        $member_id = $request->route('id');
        $member = Member::findOrFail($member_id);
        $settings = Setting::get('he-so-atm');
        $bonus = Setting::get('khuyen-mai-nap-coin');
        if ($money > 0) {
            if ($member->getTotalCharged() > 0) {
            } else {
                $bonus = Setting::get('khuyen-mai-nap-lan-dau');
            }
            $member->Money += round($money * floatval($settings) * floatval(max($bonus / 100 + 1, 1)));
        } else {
            $member->Money -= round(abs($money));
            if ($member->Money < 0) {
                $money -= $member->Money;
            }
            $member->Money = max(0, $member->Money);
        }
        if (empty($money)) {
            echo json_encode(['success' => 0]);
            return;
        }

        $coinLog = new CoinLog();
        $coinLog->OwnerActionId = backpack_user()->id;
        $coinLog->MemberUserName = $member->Email;
        $coinLog->Value = $money;
        $coinLog->bonus = round($money * floatval(max($bonus/100 + 1, 1))) - $money;
        $coinLog->Description = ($money > 0?'Nạp thẻ: ':'Xóa coin: ').$money.($money > 0?'VNĐ':' coin');
        DB::connection('sqlsrv_mem')->beginTransaction();
        DB::connection()->beginTransaction();
        if ($member->save() && $coinLog->save()) {
            DB::connection('sqlsrv_mem')->commit();
            DB::connection()->commit();
        } else {
            DB::connection('sqlsrv_mem')->rollBack();
            DB::connection()->rollBack();
            echo json_encode(['success' => 0]);
            return;
        }
        echo json_encode(['success' => 1]);
    }

    public function banmembers(BanMemberRequest $request)
    {
        $member_ids = $request->get('entries');
        $reason = $request->get('reason');
        $members = Member::find($member_ids);
        DB::connection('sqlsrv_mem')->beginTransaction();
        DB::beginTransaction(); //default is website database
        foreach ($members as $member) {
            $member->IsBan = intval(!$member->IsBan);
            if ($member->save()) {
                if ($member->IsBan) { //ban process
                    $banMemberReason = new BanMemberReason();
                    $banMemberReason->UserID = $member->UserID;
                    $banMemberReason->reason = $reason;
                    if (!$banMemberReason->save()) {
                        DB::connection('sqlsrv_mem')->rollBack();
                        DB::rollBack();
                        echo json_encode(['success' => 0]);
                        return;
                    }
                }
            } else {
                DB::connection('sqlsrv_mem')->rollBack();
                DB::rollBack();
                echo json_encode(['success' => 0]);
                return;
            }
        }
        DB::connection('sqlsrv_mem')->commit();
        DB::commit();
        echo json_encode(['success' => 1]);
        /*
        $coinLog = new CoinLog();
        $coinLog->UserID = backpack_user()->id;
        $coinLog->MemberID = $member_id;
        $coinLog->Value = $money;
        $coinLog->Description = ($money > 0?'Nạp thẻ: ':'Xóa coin: ').$money.($money > 0?'VNĐ':' coin');
        $coinLog->setTimeAttribute('asdf');
        DB::connection('sqlsrv_mem')->beginTransaction();
        DB::connection()->beginTransaction();
        if ($member->save() && $coinLog->save()) {
            DB::connection('sqlsrv_mem')->commit();
            DB::connection()->commit();
        } else {
            DB::connection('sqlsrv_mem')->rollBack();
            DB::connection()->rollBack();
            echo json_encode(['success' => 0]);
            return;
        }
        echo json_encode(['success' => 1]);
        */
    }

    public function resetPassword(RessetPasswordRequest $request)
    {
        $member_id = $request->route('id');
        $member = Member::find($member_id);
        if (!empty($member)) {
            $password = Str::random(10);
            $passwordHash = Hash::make($password);
            $member->Password = $passwordHash;
            if ($member->save()) {
                return response()->json(['success' => 1, 'message' => $password]);
            }
        }
        return response()->json(['success' => 0]);
    }
}
