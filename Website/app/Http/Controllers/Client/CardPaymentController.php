<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\Http\Requests\Client\Payment\CardCallbackRechargeRequest;
use App\Http\Requests\Client\Payment\RechargeCardRequest;
use App\LogCardCham;
use App\Member;
use App\Setting;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use SimpleSoftwareIO\QrCode\Facades\QrCode;

class CardPaymentController extends Controller
{
    public function showRechargeView(Request $request)
    {
        if($request->ajax()){
            $heSoATM = Setting::get('he-so-atm');
            $heSoTheCao = Setting::get('he-so-nap-the');
            $member = $request->user('member');
            $momoQrText = '2|99|08|MAC CHI KHANG||0|0|0|GG '.$member->Email.'|transfer_myqr';
            $momoQr = QrCode::size(250)->generate($momoQrText);
            $html = view('client.payment.recharge',compact('heSoATM', 'heSoTheCao', 'momoQr'))->render();
            return response()->json($html);
        }
        return redirect(route('home'));
    }

    public function rechargeCard(RechargeCardRequest $request)
    {
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
                $cardType = "Gate";
                break;
            case 6:
                $cardType = "Vietnamobile";
                break;
            case 7:
                $cardType = "Zing";
                break;
        }

        $serial = $request->input('serial');
        $pin = $request->input('pin');
        $cardAmount = $request->input('card_amount');
        $content = md5(uniqid('', true));
        $apiKey = env('THESIEUTOC_API');
        if (empty($apiKey)) {
            return response()->json(['msg' => 'Hệ thống nạp thẻ chưa sẵn sàng, liên hệ quản trị viên để được hỗ trợ!'],400);
//            $this->error('Hệ thống nạp thẻ chưa sẵn sàng, liên hệ quản trị viên để được hỗ trợ!');
        }
        $check = LogCardCham::where('Seri', $serial)
            ->where('Passcard', $pin)
            ->get();
        if (!empty($check) && $check->count()) {
            return response()->json(['msg' => 'Thẻ này đã được sử dụng!'],400);
//            $this->error('Thẻ đã được sử dụng!');
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
                //Gửi thẻ thành công, đợi duyệt.
//                $member = $this->getCurrentMember();
                $member = $request->user('member');
                //WAY 1 - MASS ASSIGNMENT
//                LogCardCham::create([
//                    "UserName" => $member->Email,
//                    "NameCard" => ucfirst($cardType),
//                    "Money" => $cardAmount,
//                    "Seri" => $serial,
//                    "Passcard" => $pin,
//                    "Timer" => date('Y-m-d H:i:s'),
//                    "Active" => 1,
//                    "Success" => 0,
//                    "TaskID" => $content,
//                    "status" => 0,
//                ]);

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
                    return response()->json(['msg' => $out->msg], 200);
                }
                return response()->json(['msg' => 'Gửi thẻ thành công, tuy nhiên hệ thống bị lỗi, hãy liên hệ quản trị viên để được trợ giúp!'],400);
            } else if ($out->status != '00' && $out->status != 'thanhcong'){
                // thất bại ở đây
                return response()->json(['msg' => $out->msg],400);
            }
        } else {
            return response()->json(['msg' => 'Hệ thống nạp thẻ bị lỗi, liên hệ quản trị viên để được hỗ trợ!'],400);
        }
    }

    public function cardCallbackRecharge(CardCallbackRechargeRequest $request)
    {
        $status = $request->input('status');
        $serial = $request->input('serial');
        $pin = $request->input('pin');
        $cardType = $request->input('card_type');
        $amount = $request->input('amount');
        $realAmount = $request->input('real_amount');
        $content = $request->input('content');
        $cardOnhold = LogCardCham::where('Seri', $serial)
            ->where('Passcard', $pin)
            ->where('TaskID', $content)
            ->where('Active', 1)
            ->where('status', 0)
            ->first();
        if ($cardOnhold) {
            if($status == 'thanhcong') {
                //Xử lý nạp thẻ thành công tại đây.
                $cardOnhold->Active = 0;
                $cardOnhold->status = 1;
                if ($cardOnhold->save()) {
                    $member = Member::where('Email', $cardOnhold->UserName)
                        ->first();
                    if ($member) {
                        $member->Money += $amount * Setting::get('he-so-nap-the');
                        $vipExp = $amount * Setting::get('vip-exp-rate');
                        $member->VIPExp += $vipExp;
                        $member->save();
                    }
                }
            } else if($status == 'saimenhgia') {
                //Xử lý nạp thẻ sai mệnh giá tại đây.
                $cardOnhold->status = 3; //sai menh gia
                $cardOnhold->Active = 0; //sai menh gia
                $cardOnhold->save();
            } else {
                //Xử lý nạp thẻ thất bại tại đây.
                $cardOnhold->status = 2; //nap that bai
                $cardOnhold->Active = 0; //sai menh gia
                $cardOnhold->save();
            }
        }
    }

    public function hello(){
        return "hello";
    }
}
