<?php

namespace App\Http\Controllers\Launcher;

use App\CoinLog;
use App\Http\Controllers\Controller;
use App\Http\Requests\Client\Launcher\ExchangeLogRequest;
use App\Http\Requests\Client\Launcher\LoadCharsRequest;
use App\Http\Requests\Client\Launcher\LoginLauncherRequest;
use App\Http\Requests\Client\Launcher\RechargeCardRequest;
use App\Http\Requests\Client\Launcher\ConvertCoinRequest;
use App\LogCardCham;
use App\MemberHistory;
use App\Player;
use App\ServerList;
use App\Setting;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class OtherLauncherController extends Controller
{
    public function cashInfo(LoginLauncherRequest $request)
    {
        $username = $request->input('username');
        $password = $request->input('password');
        if (Auth::guard('member')->attempt(['Email' => $username, 'password' => $password])) {
            $member = Auth::guard('member')->user();
            if($member->IsBan == 1)
                return response('Tài khoản của bạn đã bị khoá');

            return response($member->getVipLevel() . ':' . $member->Money);
        }
        return response('Đăng nhập không hợp lệ!');
    }

    public function exchangeCash(RechargeCardRequest $request)
    {
        $username = $request->input('username');
        $password = $request->input('password');
        if (!Auth::guard('member')->attempt(['Email' => $username, 'password' => $password])) {
            return response('Đăng nhập không hợp lệ!');
        }
        $member = Auth::guard('member')->user();
        if($member->IsBan == 1) {
            return response('Tài khoản của bạn đã bị khoá');
        }
        $cardTypeNumber = $request->input('card_type');
        $cardType = "";
        switch ($cardTypeNumber){
            case 0:
                $cardType = 0;
                break;
            case 1:
                $cardType = "Viettel";
                break;
            case 2:
                $cardType = "Mobifone";
                break;
            case 3:
                $cardType = "Vinaphone";
                break;
            case 4:
                $cardType = "Vcoin";
                break;
            case 5:
                $cardType = "Gate";
                break;
            case 6:
                $cardType = "Zing";
                break;
        }

        $serial = $request->input('serial');
        $pin = $request->input('pin');
        $cardAmount = $request->input('card_amount');
        $content = md5(uniqid('', true));
        $apiKey = env('THESIEUTOC_API');
        if (empty($apiKey)) {
            return response('Hệ thống nạp thẻ chưa sẵn sàng, liên hệ quản trị viên để được hỗ trợ!');
        }
        $check = LogCardCham::where('Seri', $serial)
            ->orWhere('Passcard', $pin)
            ->get();
        if (!empty($check) && $check->count()) {
            return response('Thẻ này đã được sử dụng!');
        }

        $url = "https://thesieutoc.net/chargingws/v2?APIkey=".$apiKey."&mathe=".$pin."&seri=".$serial."&type=".ucfirst($cardType)."&menhgia=".$cardAmount."&content=".$content;
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch,CURLOPT_CAINFO, base_path() .'/curl-ca-bundle.crt');
        curl_setopt($ch,CURLOPT_CAPATH, base_path() .'/curl-ca-bundle.crt');
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $out = json_decode(curl_exec($ch));
        $httpCode = 0;
        if (isset($out->status)){$httpCode = 200;}
        curl_close($ch);
        if ($httpCode == 200){
            if ($out->status == '00' || $out->status == 'thanhcong'){
                //WAY 2 - traditional
                $logCardCham = new LogCardCham();
                $logCardCham->UserName = $member->Email;
                $logCardCham->NameCard = ucfirst($cardType);
                $logCardCham->Money = $cardAmount;
                $logCardCham->Seri = $serial;
                $logCardCham->Passcard = $pin;
                $logCardCham->Timer = date('Y-m-d H:i:s');
                $logCardCham->Active = 1;
                $logCardCham->Success = 0;
                $logCardCham->TaskID = $content;
                $logCardCham->status = 0;

                if ($logCardCham->save()) {
//                    $this->success($out->msg);
                    return response($out->msg);
                }
                return response('Gửi thẻ thành công, tuy nhiên hệ thống bị lỗi, hãy liên hệ quản trị viên để được trợ giúp!');
            } else if ($out->status != '00' && $out->status != 'thanhcong'){
                // thất bại ở đây
                return response($out->msg);
            }
        } else {
            return response('Hệ thống nạp thẻ bị lỗi, liên hệ quản trị viên để được hỗ trợ!');
        }
    }

    public function loadChars(LoadCharsRequest $request)
    {
        $username = $request->input('username');
        $password = $request->input('password');
        $serverId = $request->input('srv');

        if(Auth::guard('member')->attempt(['Email' => $username, 'password' => $password])) {
            $member = Auth::guard('member')->user();
            $server = ServerList::find($serverId);

            if(empty($server))
                return response('Máy chủ không hoạt động, vui lòng chọn máy chủ khác');
            $serverConnection = $server->Connection;
            if($serverConnection) {//have connection
                $players = Player::on($serverConnection)->select('UserID', 'NickName')
                    ->where('UserName', $member->Email)
                    ->get();
				$response = '';
				if (!empty($players) && $players->count() > 0) {
					$index = 0;
					foreach ($players as $player) {
						$response .= '|'.($index++).';'.$player->UserID.';'.$player->NickName;
					}
					$response = trim($response, '|');
				}
                return response($response);
            } else {
                return response('');
            }
        } else {
            return response('Tài khoản hoặc mật khẩu không đúng');
        }
    }

    public function convertCoin(ConvertCoinRequest $request)
    {
        $username = $request->input('username');
        $password = $request->input('password');
        if (!Auth::guard('member')->attempt(['Email' => $username, 'password' => $password])) {
            return response('Đăng nhập không hợp lệ!');
        }
        $member = Auth::guard('member')->user();
        if($member->IsBan == 1) {
            return response('Tài khoản của bạn đã bị khoá');
        }
        $serverId = $request->input('server_id');
        $server = ServerList::find($serverId);
        if(!$server) {
            return response('Server không tồn tại');
        }
        $serverConnection = $server->Connection;
        $coin = $request->input('coin');
        $coin = intval($coin);
        $coin = max(20000, $coin);
        $coin = min(2000000, $coin);
		$playerId = $request->input('player_id');
		if (empty($playerId)) {
			return response('Chưa chọn nhân vật cần chuyển!');
		}
        //Get total charged for checking
        $memHistory = new MemberHistory();

        $totalChanged = $memHistory->memberTotalChargedToday($member->UserID);
        $totalChangeAllowed = Setting::get('gioi-han-chuyen-xu-ngay');
        if ($member->Money < $coin)
            return response('Không đủ coin để chuyển đổi!');

        if ($totalChanged > 0 && !empty($totalChangeAllowed) && intval($totalChangeAllowed) <= ($totalChanged + $coin)) {
            if ($totalChanged < intval($totalChangeAllowed))
                return response('Số xu tối đa bạn có thể đổi trong hôm nay là '.(intval($totalChangeAllowed) - $totalChanged));
            return response('Bạn đã đạt tối đa số xu nạp cho phép trong hôm nay, hãy quay lại vào ngày mai!');
        }

        $player = Player::on($serverConnection)->select('UserID', 'NickName')
            ->where('UserID', $playerId)
            ->first();
        if (!$player)
            return response('Nhân vật không tồn tại!');

        DB::connection('sqlsrv_mem')->beginTransaction();
        $memHistory = new MemberHistory();
        if(
//            $memHistory->memberChargeMoneyLog($member->UserID, $coin, $server->ServerName, $request->ip()) && //Without AntiDDos.vn
            $memHistory->memberChargeMoneyLog($member->UserID, $coin, $server->ServerName, $request->header('x-real-ip')) &&
            $member->chargeMoney($coin)
        ){
            $chargeID = md5(uniqid());

            $options = array(
                'http'=>array(
                    'header'=>"User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) 37abc/2.0.6.16 Chrome/60.0.3112.113 Safari/537.36" // i.e. An iPad
                )
            );
            $context = stream_context_create($options);
            $xu = $coin * Setting::get('he-so-doi-coin');
            $xu += $xu * $member->getVipBonus() / 100;
            $content = file_get_contents(
                trim($server->LinkRequest, '/')
                . "/ChargeMoney.aspx?content="
                . $chargeID
                . "|" . $member->Email
                . "|" . $xu
                . "|0" //payway
                . "|.00" //needMoney
                . "|" . md5($chargeID.$member->Email.$xu.'0'.'.00'.env('CHARGE_KEY'))
                . "&nickname=" . $player->UserID
                ,false, $context);
            if (substr($content, 0, 1) === "0") {
                DB::connection('sqlsrv_mem')->commit();
                return response('Nạp xu thành công!');

            } else {
                DB::connection('sqlsrv_mem')->rollBack();
                return response('Không thể nạp xu vào game, vui lòng thoát game và thử lại hoặc thông báo tới quản trị viên để được trợ giúp!');
            }
        }
		return response('Không thể nạp xu vào game, vui lòng thoát game và thử lại hoặc thông báo tới quản trị viên để được trợ giúp!');
    }

    public function getExchangeLog(ExchangeLogRequest $request)
    {
        $username = $request->input('username');
        $password = $request->input('password');
        if (!Auth::guard('member')->attempt(['Email' => $username, 'password' => $password])) {
            return response('Đăng nhập không hợp lệ!');
        }
        $member = Auth::guard('member')->user();
        if($member->IsBan == 1) {
            return response('Tài khoản của bạn đã bị khoá');
        }
        $columns = [
            DB::raw('0 as ID'),
            'NameCard',
            DB::raw('Seri as Serial'),
            DB::raw('Passcard as CodeCard'),
            DB::raw('Money as ValueCard'),
            DB::raw('status as Status'),
            DB::raw('Timer as TimeCreate'),
        ];
        $page = $request->input('page', 1);
        $limit = 12;
        $cardsCharged = LogCardCham::select($columns)->where('UserName', $member->Email)->limit($limit)->offset(($page - 1) * $limit)->get();
        return response()->json(['Data' => $cardsCharged->toArray(), 'TotalRecord' => $cardsCharged->count()]);
    }

    public function getCoinLog(ExchangeLogRequest $request)
    {
        $username = $request->input('username');
        $password = $request->input('password');
        if (!Auth::guard('member')->attempt(['Email' => $username, 'password' => $password])) {
            return response('Đăng nhập không hợp lệ!');
        }
        $member = Auth::guard('member')->user();
        if($member->IsBan == 1) {
            return response('Tài khoản của bạn đã bị khoá');
        }
        $columns = [
            DB::raw('0 as ID'),
            'Description',
            'Bonus',
            DB::raw('created_at as TimeCreate'),
        ];
        $page = $request->input('page', 1);
        $limit = 12;
        $cardsCharged = CoinLog::select($columns)->where('MemberUserName', $member->Email)->limit($limit)->offset(($page - 1) * $limit)->get();
        return response()->json(['Data' => $cardsCharged->toArray(), 'TotalRecord' => $cardsCharged->count()]);
    }
}
