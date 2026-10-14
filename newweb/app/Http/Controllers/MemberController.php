<?php

namespace App\Http\Controllers;

use App\Http\Requests\CardChargeRequest;
use App\Http\Requests\Toggle2FaCodeRequest;
use App\Http\Requests\Toggle2FaRequest;
use App\Mailer;
use App\Member;
use App\Http\Requests\ChangePasswordRequest;
use App\Http\Requests\ChangeMoneyRequest;
use App\Models\Active;
use App\Models\ActiveNumber;
use App\Models\CardCharged;
use App\Models\Player;
use App\SoapRequest;
use App\Toggle2faCode;
use App\VerifyEmailCode;
use App\Models\Setting;
use App\Models\ServerList;
use App\Models\MemHistory;
use Illuminate\Support\Facades\DB;
use App\Http\Requests\IsDuplicateNewNickNameRequest;
use App\Http\Requests\ChangeNickNameRequest;

class MemberController extends Controller
{

    public function account()
    {
        return view('account/index', ['member' => $this->getCurrentMember()]);
    }

    public function changePassword()
    {
        return view('account/change_password');
    }

    public function changePasswordPost(ChangePasswordRequest $request)
    {
        $current_password = $request->current_password;
        $m = new Member();
        $member_id = $m->getMemberId();
        $members = Member::where('UserID', $member_id)
            ->where('Password', md5($current_password))
            ->get();
        if (!empty($members) && $members->count()) {
            $member = $members->first();
            $member->Password = md5($request->new_password);
            if($member->save()) {
                $this->success("Đổi mật khẩu thành công!");
            }
        } else {
            $this->error("Mật khẩu cũ không đúng!");
        }
        $this->error("Không thể đổi mật khẩu vào lúc này, vui lòng thử lại sau!");
    }

    public function changeMoney()
    {
        $m = new Member();
        $setting = Setting::get('he-so-doi-coin');
        $serverList = ServerList::all();
        return view('account/chuyen_xu', ['member' => $m->current(), 'setting' => $setting, 'servers' => $serverList]);
    }

    public function changeMoneyPost(ChangeMoneyRequest $request)
    {
        $server_id = $request->server_id;
        $server = ServerList::find($server_id);
        if (empty($server)) {
            $this->error("Máy chủ không tồn tại!");
        }
        $member = $this->getCurrentMember();
        $coin = $request->coin;
        $coin = intval($coin);
        $coin = max(1000, $coin);
        $coin = min(1000000, $coin);
        //get total charged for checking
        $mem_history = new MemHistory();
        $total_changed = $mem_history->memberTotalChargedToday($member->UserID);
        $total_change_allowed = Setting::get('gioi-han-chuyen-xu-ngay');
        if ($member->Money < $coin) {
            $this->error("Không đủ coin để chuyển đổi!");
        }
        if ($total_changed > 0 && !empty($total_change_allowed) && intval($total_change_allowed) <= ($total_changed + $coin)) {
            if ($total_changed < intval($total_change_allowed)) {
                $this->error('Số xu tối đa bạn có thể đổi trong hôm nay là '.(intval($total_change_allowed) - $total_changed));
            }
            $this->error('Bạn đã đạt tối đa số xu nạp cho phép trong hôm nay, hãy quay lại vào ngày mai!');
        }
        $player = Player::select('UserID', 'NickName', 'TotalCharged')
            ->where('UserName', $member->Email)
            ->first();
        if (empty($player)) {
            $this->error("Nhân vật không tồn tại!");
        }

        /*
         * No need to build Charge Money
        $chargeMoney = new ChargeMoney();
        $chargeMoney->ChargeID = md5(uniqid());
        $chargeMoney->UserName = $member->Email;
        $chargeMoney->Money = $coin * Setting::get('he-so-doi-coin');
        $chargeMoney->Date = date('Y-m-d H:i:s');
        $chargeMoney->CanUse = 0;
        $chargeMoney->PayWay = 0;
        $chargeMoney->NeedMoney = 0;
        $chargeMoney->NickName = $player->NickName;
        */
        DB::connection('sqlsrv_mem')->beginTransaction();
        DB::connection('sqlsrv_tank41')->beginTransaction();
        $mem_history = new MemHistory();
        if (
            $mem_history->memberChargeMoneyLog($member->UserID, $coin, $server->ServerName, $request->ip()) &&
            $member->chargeMoney($coin)
//            && $chargeMoney->save()
        ) {
            /*
             * No Soap is available at this time ...
            try {
                /* @var $soapRequest SoapRequest
                $soapRequest = app()->make(SoapRequest::class);
            } catch (\Illuminate\Contracts\Container\BindingResolutionException $e) {
                DB::connection('sqlsrv_mem')->rollBack();
                DB::connection('sqlsrv_tank41')->rollBack();
                echo json_encode(['success'=> false, 'message' => "Không thể nạp xu vào game, vui lòng thông báo với quản trị viên để được trợ giúp!"]);
                return;
            }
            $soapResult = $soapRequest->PlayerChargeMoney($server_id, $player->UserID, $chargeMoney->ChargeID);
            if($soapResult->ChargeMoneyResult == '1') {
            */
            /* Here am using request to charge for player */
            $chargeID = md5(uniqid());
            $content = file_get_contents(
                trim($server->LinkRequest, '/')
                . "/ChargeMoney.aspx?content="
                . $chargeID
                . "|" . $member->Email
                . "|" . ($coin * Setting::get('he-so-doi-coin'))
                . "|0" //payway
                . "|.00" //needMoney
                . "|" . md5($chargeID.$member->Email.($coin * Setting::get('he-so-doi-coin')).'0'.'.00'.env('CHARGE_KEY'))
                . "&nickname=" . $player->UserID
            );
            if (substr($content, 0, 1) === "0") {
                //update into db for total charge
                $he_so_atm = Setting::get('he-so-atm');
                $bonus = Setting::get('charge-bonus');
                $player->TotalCharged += round($coin / floatval($he_so_atm) / floatval(max($bonus/100 + 1, 1)));
                if ($player->save()) {
                    DB::connection('sqlsrv_mem')->commit();
                    DB::connection('sqlsrv_tank41')->commit();
                    $this->success("Nạp xu thành công!");
                } else {
                    DB::connection('sqlsrv_mem')->rollBack();
                    DB::connection('sqlsrv_tank41')->rollBack();
                    $this->error("Không thể nạp xu vào game, vui lòng thoát game và thử lại hoặc thông báo tới quản trị viên để được trợ giúp!");
                }
            } else {
                DB::connection('sqlsrv_mem')->rollBack();
                DB::connection('sqlsrv_tank41')->rollBack();
                $this->error("Không thể nạp xu vào game, vui lòng thoát game và thử lại hoặc thông báo tới quản trị viên để được trợ giúp!");
            }
        }
    }

    public function napCoin()
    {
        return view('account/nap_coin');
    }

    public function giftcode()
    {
        $m = new Member();
        $member = $m->current();
        $giftcodes = Active::where('CanGetCode', 1)->get();
        $codes = [];
        foreach ($giftcodes as $giftcode) {
            $activeNumber = ActiveNumber::where('ActiveID', $giftcode->ActiveID)
                ->where('Creator', $member->UserID)
                ->get();
            if (!empty($activeNumber) && $activeNumber->count()) {
                $codes[$giftcode->ActiveID] = $activeNumber->first()->AwardID;
            } else {
                $activeNumber = $giftcode->createActiveNumberForCreator($giftcode->CodePrefix, $member->UserID);
                if ($activeNumber) {
                    $codes[$giftcode->ActiveID] = $activeNumber->AwardID;
                }
            }
        }
        return view('account/giftcode', ['giftcodes' => $giftcodes, 'codes' => $codes]);
    }

    public function changeNickName()
    {
        $member = $this->getCurrentMember();
        $player = Player::select('UserID', 'NickName')
            ->where('UserName', $member->Email)
            ->first();
        if (empty($player)) {
            $this->error("Nhân vật không tồn tại!");
        }
        $serverList = ServerList::all();
        return view('account/doi_ten', ['player' => $player, 'member'=> $member, 'servers' => $serverList]);
    }

    public function isDuplicateNewNickName(IsDuplicateNewNickNameRequest $request)
    {
        $server_id = $request->input('server_id');
        $server = ServerList::find($server_id);
        if (empty($server)) {
            $this->error("Máy chủ không tồn tại!");
        }
        $player = Player::select('UserID', 'NickName')
            ->where('NickName', $request->input('new_name'))
            ->first();
        return empty($player);

    }
    private function isNickNameValid($serverId, $nickName)
    {
        $server = ServerList::find($serverId);
        if (empty($server)) {
            return false;
        }
        $player = Player::select('UserID', 'NickName')
            ->where('NickName', $nickName)
            ->first();
        return empty($player);
    }


    public function changeNickNamePost(ChangeNickNameRequest $request)
    {
        $PRICE_CHANGE_NAME = 1000;
        //Get input without through magic method
        $server_id = $request->input('server_id');
        $newNickName = $request->input('new_name');

        $server = ServerList::find($server_id);
        if (empty($server)) {
            $this->error("Máy chủ không tồn tại!");
        }

        $member = $this->getCurrentMember();

        $player = Player::select('UserID', 'NickName')
            ->where('UserName', $member->Email)
            ->first();
        if (empty($player)) {
            $this->error("Nhân vật không tồn tại!");
        }

        $currentCoin = (int) $member->Money;
        if($currentCoin < $PRICE_CHANGE_NAME){
            $this->error("Bạn không đủ Coin để thay đổi tên nhân vật");
            return;
        }

        //Check is new NickName valid
        $isNickNameValid = $this->isNickNameValid($server_id, $newNickName);

        //Initial variable for logs
        $previousNickName = $player->NickName;

        if($isNickNameValid){
            DB::connection('sqlsrv_mem')->beginTransaction();
            $mem_history = new MemHistory();
            if (
                $mem_history->memberChangeNickNameLog($member->UserID, $previousNickName, $newNickName ,$PRICE_CHANGE_NAME, $server->ServerName, $request->ip())
                &&
                $member->chargeMoney($PRICE_CHANGE_NAME)
            ) {
                $player->NickName = $newNickName;

                if($player->save()){
                    DB::connection('sqlsrv_mem')->commit();
                    $this->success("Đổi tên nhân vật thành công!");
                }
                else{
                    DB::connection('sqlsrv_mem')->rollBack();
                    $this->error("Không thể đổi tên nhân vật, vui lòng thoát game và thử lại hoặc thông báo tới quản trị viên để được trợ giúp!");
                }
            }
            else
                $this->error("Không lưu lịch sử đổ tên, vui lòng thoát game và thử lại hoặc thông báo tới quản trị viên để được trợ giúp!");
        }
        else{
            $this->error("Tên nhân vật đã tồn tại!");
        }
    }

    public function support()
    {
        return view('account/ho_tro');
    }

    public function toggle2fa(Toggle2FaRequest $request)
    {
        $tfa = $request->tfa;
        $member = $this->getCurrentMember();
        if ($member['2fa'] == $tfa || empty($member->Fullname)) {
            $this->error('Yêu cầu không hợp lệ!');
        }
        if (empty($member->VerifiedEmail)) {
            $this->error('Chưa xác thực email, không thể thao tác!');
        }
        $mailer = new Mailer();
        $sent_status = $mailer->toggle2fa($member->Fullname);
        if ($sent_status['success']) {
            $code = $sent_status['code'];
            $model = new Toggle2faCode();
            $model->MemberID = $member->UserID;
            $model->status = 0;
            $model->code = md5($code);
            if ($model->save()) {
                $this->setSession('2fa_toggle', $tfa);
                $this->success('', [], 2);
            }
            $this->error('Có lỗi hệ thống, vui lòng thử lại hoặc liên hệ quản trị viên để được hỗ trợ!');
        }
        $this->error('Có lỗi hệ thống, vui lòng thử lại hoặc liên hệ quản trị viên để được hỗ trợ!');
    }

    public function toggle2facode(Toggle2FaCodeRequest $request)
    {
        $code = $request->code;
        $status = intval($this->getSession('2fa_toggle'));
        if ($status !== 0 && $status !== 1) {
            $this->error('Yêu cầu không hợp lệ!');
        }
        $member = $this->getCurrentMember();
        $attempts = Toggle2faCode::where('MemberID', $member->UserID)
            ->where('code', md5($code))
            ->where('status', 0)
            ->orderBy('created_at', 'DESC')
            ->get();
        if (!empty($attempts) && $attempts->count()) {
            $last_attempt = $attempts->first();
            $last_time = strtotime($last_attempt->created_at);
            $time = strtotime('now') - $last_time;
            if ($time < env('2FA_CODE_EXPIRES', 120)) {
                $last_attempt->status = 1;
                if ($last_attempt->save()) {
                    $member = Member::findOrFail($member->UserID);
                    $member['2fa'] = $status;
                    if ($member->save()) {
                        $this->unsetSession('2fa_toggle');
                        $this->success('Cập nhật thành công!');
                    }
                }
                $this->error('Có lỗi xảy ra, vui lòng thử lại hoặc liên hệ quản trị viên để được trợ giúp!');
            }
            foreach ($attempts as $item) {
                $item->status = 2;
                $item->save();
            }
            $this->error('Mã hết hiệu lực!');
        }
        $this->error('Yêu cầu không hợp lệ!');
    }

    public function verifyEmail()
    {
        $member = $this->getCurrentMember();
        if (!empty($member->VerifiedEmail)) {
            $this->error('Yêu cầu không hợp lệ!');
        }
        $mailer = new Mailer();
        $sent_status = $mailer->verifyEmail($member->Fullname);
        if ($sent_status['success']) {
            $code = $sent_status['code'];
            $model = new VerifyEmailCode();
            $model->MemberID = $member->UserID;
            $model->status = 0;
            $model->code = md5($code);
            if ($model->save()) {
                $this->success('', [], 2);
            }
            $this->error('Có lỗi hệ thống, vui lòng thử lại hoặc liên hệ quản trị viên để được hỗ trợ!');
        }
        $this->error('Có lỗi hệ thống, vui lòng thử lại hoặc liên hệ quản trị viên để được hỗ trợ!');
    }

    public function verifyEmailCode(Toggle2FaCodeRequest $request)
    {
        $code = $request->code;
        $member = $this->getCurrentMember();
        if (!empty($member->VerifiedEmail)) {
            $this->error('Yêu cầu không hợp lệ!');
        }
        $attempts = VerifyEmailCode::where('MemberID', $member->UserID)
            ->where('code', md5($code))
            ->where('status', 0)
            ->orderBy('created_at', 'DESC')
            ->get();
        if (!empty($attempts) && $attempts->count()) {
            $last_attempt = $attempts->first();
            $last_time = strtotime($last_attempt->created_at);
            $time = strtotime('now') - $last_time;
            if ($time < env('2FA_CODE_EXPIRES', 120)) {
                $last_attempt->status = 1;
                if ($last_attempt->save()) {
                    $member = Member::findOrFail($member->UserID);
                    $member->VerifiedEmail = 1;
                    if ($member->save()) {
                        $this->success('Cập nhật thành công!');
                    }
                }
                $this->error('Có lỗi xảy ra, vui lòng thử lại hoặc liên hệ quản trị viên để được trợ giúp!');
            }
            foreach ($attempts as $item) {
                $item->status = 2;
                $item->save();
            }
            $this->error('Mã hết hiệu lực!');
        }
        $this->error('Yêu cầu không hợp lệ!');
    }

    public function cardChargePost(CardChargeRequest $request)
    {
        $card_type = $request->card_type;
        $serial = $request->serial;
        $pin = $request->pin;
        $card_amount = $request->card_amount;
        $content = md5(uniqid('', true));
        $apikey = env('THESIEUTOC_API');
        if (empty($apikey)) {
            $this->error('Hệ thống nạp thẻ chưa sẵn sàng, liên hệ quản trị viên để được hỗ trợ!');
        }
        $check = CardCharged::where('Seri', $serial)
            ->where('Passcard', $pin)
            ->get();
        if (!empty($check) && $check->count()) {
            $this->error('Thẻ đã được sử dụng!');
        }

        $url = "https://thesieutoc.net/chargingws/v2?APIkey=".$apikey."&mathe=".$pin."&seri=".$serial."&type=".ucfirst($card_type)."&menhgia=".$card_amount."&content=".$content;
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch,CURLOPT_CAINFO, base_path() .'/curl-ca-bundle.crt');
        curl_setopt($ch,CURLOPT_CAPATH, base_path() .'/curl-ca-bundle.crt');
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $out = json_decode(curl_exec($ch));
        $http_code = 0;
        if (isset($out->status)){$http_code = 200;}
        curl_close($ch);
        if ($http_code == 200){
            if ($out->status == '00' || $out->status == 'thanhcong'){
                //Gửi thẻ thành công, đợi duyệt.
                $member = $this->getCurrentMember();
                $md = new CardCharged();
                $md->UserName = $member->Email;
                $md->NameCard = ucfirst($card_type);
                $md->Money = $card_amount;
                $md->Seri = $serial;
                $md->Passcard = $pin;
                $md->Timer = date('Y-m-d H:i:s');
                $md->Active = 1;
                $md->Success = 0;
                $md->TaskID = $content;
                $md->status = 0;
                if ($md->save()) {
                    $this->success($out->msg);
                }
                $this->error('Gửi thẻ thành công, tuy nhiên hệ thống bị lỗi, hãy liên hệ quản trị viên để được trợ giúp!');
            } else if ($out->status != '00' && $out->status != 'thanhcong'){
                // thất bại ở đây
                $this->error($out->msg);
            }
        } else {
            $this->error('Hệ thống nạp thẻ bị lỗi, liên hệ quản trị viên để được hỗ trợ!');
        }
    }

    public function cardHistory()
    {
        $member = $this->getCurrentMember();
        $logCards = CardCharged::where('UserName', $member->Email)
            ->get();

        return view('account/card_history', ['member'=> $member, 'logCards' => $logCards]);
    }
}
