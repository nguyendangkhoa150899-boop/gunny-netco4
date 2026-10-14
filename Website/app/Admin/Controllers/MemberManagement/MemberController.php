<?php

namespace App\Admin\Controllers\MemberManagement;

use App\Admin\Actions\Member\BanOrUnbanMember;
use App\Admin\Actions\Member\LoginWithoutPassword;
use App\Admin\Actions\Member\ResetPassword;
use App\CoinLog;
use App\Http\Requests\Admin\Member\AddCoinRequest;
use App\Member;
use App\Setting;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Facades\Admin;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;
use App\Admin\Actions\Member\RechargeMoney;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Encore\Admin\Auth\Permission;

class MemberController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Danh sách tài khoản';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new Member());

        $grid->column('UserID', __('UserID'))->filter();
        $grid->column('Email', __('Tên tài khoản'))->sortable()->filter();
        $grid->column('Fullname', __('Email'))->filter();
        $grid->column('Money', __('Coin'))->sortable()->filter()->display(function ($Money){
            return number_format($Money, 0, ',','.');
        });
        $grid->column('IsBan', __('Tình trạng'))->filter([0 => 'Đang hoạt động', 1 => 'Đã khoá'])->display(function ($isBanned){
            return $isBanned == 0 ? '<span class="badge btn-success">Đang hoạt động</span>': '<span class="badge btn-danger">Đã Khoá</span>';
        });
        $grid->column('TwoFactorStatus', __('2FA'))->display(function ($twofa){
            if($twofa)
                return $twofa == 1  ? '<span class="badge btn-info">Đã kích hoạt</span>': '<span class="badge btn-danger">Chưa kích hoạt</span>';
            return '<span class="badge btn-danger">Chưa kích hoạt</span>';
        });
        $grid->column('VerifiedEmail', __('VerifiedEmail'))->display(function ($verifiedEmail){
            if($verifiedEmail)
                return $verifiedEmail == 1  ? '<span class="badge btn-primary">Đã xác thực</span>': '<span class="badge btn-danger">Chưa xác thực</span>';
            return '<span class="badge btn-danger">Chưa xác thực</span>';
        });
        $grid->column('IPCreate', __('IP'))->filter();

        $grid->quickSearch('Email','Fullname', 'Money','IPCreate');
        $grid->disableExport();

        $grid->actions(function ($actions) {
            // The roles with this permission will not able to see the delete button in actions column.
            if (!Admin::user()->can('delete-member')) {
                $actions->disableDelete();
            }
            $actions->add(new RechargeMoney());
            $actions->add(new ResetPassword());
            $actions->add(new BanOrUnbanMember());
            $actions->add(New LoginWithoutPassword());
        });

        return $grid;
    }

    /**
     * Make a show builder.
     *
     * @param mixed $id
     * @return Show
     */
    protected function detail($id)
    {
        $show = new Show(Member::findOrFail($id));

        $show->field('UserID', __('UserID'));
        $show->field('Email', __('Email'));
        $show->field('Fullname', __('Fullname'));
        $show->field('Money', __('Coin'));
        $show->field('VIPLevel', __('VIPLevel'));
        $show->field('IsBan', __('IsBan'));
        $show->field('TwoFactorStatus', __('TwoFactorStatus'));
        $show->field('VerifiedEmail', __('VerifiedEmail'));

        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new Member());

        $form->text('Email', __('Email'));
        $form->password('Password', __('Password'));
        $form->email('Fullname', __('Fullname'));
        $form->number('Money', __('Money'));

        return $form;
    }

    public function addCoinToMember(Model $model, Request $request)
    {
        $money = $request->input('Coin');
        $individualBonus = $request->input('Bonus')/100;
        $ownerActionId = $request->user('admin')->id;

        $money = floatval($money);
        $individualBonus = floatval($individualBonus);

        $memberUsername = $model->Email;

        $member = Member::findOrFail($model->UserID);
        $heSoATM = Setting::get('he-so-atm');
        $bonus = Setting::get('charge-bonus');

        //Calculate rate & money
        $allBonusMoney = 0;
        if ($money > 0) {
            //tienKhuyenMai = (tongtien * phantram) /100
            $systemBonusMoney = $money * floatval($bonus * 100)/100;
            $individualBonusMoney = $money * floatval($individualBonus*100/100);
            $allBonusMoney = $systemBonusMoney + $individualBonusMoney;
            $moneyWillBeCharge = round(($money + $allBonusMoney) * $heSoATM );
            $member->Money += $moneyWillBeCharge;
            $vipExp = $money * Setting::get('vip-exp-rate');
            $member->VIPExp += $vipExp;
        }
        else {
            $member->Money -= round(abs($money));
            if ($member->Money < 0) {
                $money -= $member->Money;
            }
            $member->Money = max(0, $member->Money);
            $vipExp = $money * Setting::get('vip-exp-rate');
            $member->VIPExp += $vipExp;
        }

        $coinLog = new CoinLog();
        $coinLog->OwnerActionId = $ownerActionId;
        $coinLog->MemberUserName = $memberUsername;
        $coinLog->Value = $money;
        $coinLog->bonus = $allBonusMoney;
        $coinLog->Description = ($money > 0 ?'Nạp tiền: ' : 'Xóa coin: ').number_format($money, 0, ',', '.').($money > 0?' đ':' coin');
        DB::connection('sqlsrv_mem')->beginTransaction();
        DB::connection()->beginTransaction();
        if ($member->save() && $coinLog->save()) {
            DB::connection('sqlsrv_mem')->commit();
            DB::connection()->commit();
        } else {
            DB::connection('sqlsrv_mem')->rollBack();
            DB::connection()->rollBack();
            return false;
        }
        return true;
    }
}
