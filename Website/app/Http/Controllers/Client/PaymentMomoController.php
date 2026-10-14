<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Member;
use App\PaymentBank;
use App\MemberHistory;
use App\Setting;
use Carbon\Carbon;
use App\CoinLog;
use Illuminate\Support\Facades\DB;

class PaymentMomoController extends Controller
{
    private function getUsernameFromContextMoMo($context)
    {
        $prefix = '/momo \w+/im';
        preg_match_all($prefix, $des, $matches, PREG_SET_ORDER, 0);
        if (count($matches) == 0 )
            return null;
        // Print the entire match result
        $orderCode = $matches[0][0];
        $prefixLength = strlen('momo '); //cú pháp chuyển
        $username = substr($orderCode, $prefixLength);
        return $username;
    }

    private function fetchTransactionFromAPI()
    {
        $token = env('WEB2M_API');
        $urlConfig = env('WEB2M_MOMO_URL');//https://api.web2m.com/historyapimb/Bentley2020/0944640994/
        $url = $urlConfig.$token;
        $curl = curl_init($url);
        curl_setopt($curl, CURLOPT_URL, $url);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
        $resp = curl_exec($curl);
        curl_close($curl);
        return json_decode($resp, true);
    }

    public function handleBankTransaction()
    {
        $result = $this->fetchTransactionFromAPI();
        $Momo = new PaymentMomo;
        $Member = new Member;
        $isFound = false;

        foreach($result['momoMsg']['tranList'] as $data)
        {
            if($data['io'] == 1) {
                $partnerId      = $data['partnerId'];               //  SỐ ĐIỆN THOẠI CHUYỂN
                $comment        = $data['comment'];                 // NỘI DUNG CHUYỂN TIỀN
                $tranId         = $data['tranId'];                  // MÃ GIAO DỊCH
                $partnerName    = $data['partnerName'];             // TÊN CHỦ VÍ
                $username       = $this->getUsernameFromContextBank($comment);         // TÁCH NỘI DUNG CHUYỂN TIỀN
                $amount         = $data['amount'];

                if ($username)
                {
                    
                    $check = $Momo->findTransaction($tranId);

                    if($check == 0) {
                        $user = $Member::where('Email', $username)->limit(1)->get();
                        $user = $user[0];
                        $heSoATM = Setting::get('he-so-atm');
                        $bonus = Setting::get('charge-bonus');

                        $moneyQuydoi = $amount * $heSoATM;
                        $bonusHave = $moneyQuydoi * floatval($bonus * 100)/100;
                        $moneyWillHave = $moneyQuydoi + $bonusHave;
                       
                        DB::connection('sqlsrv_mem')->beginTransaction();
                        DB::connection('sqlsrv')->beginTransaction();
                       
                        Member::where('UserID', $user->UserID)->update(['Money' => $user->Money + $moneyWillHave]);

                        $creatData = PaymentMomo::create([
                            'UserID' => $user->UserID,
                            'TransID' => $tranId,
                            'Amount' => $amount
                        ]);

                        $coinLog = new CoinLog();
                        $coinLog->OwnerActionId = 'MOMO';
                        $coinLog->MemberUserName = $user->Email;
                        $coinLog->Type = 'Momo';
                        $coinLog->Vendor = 'Momo';
                        $coinLog->Value = $amount;
                        $coinLog->bonus = $bonusHave;
                        $coinLog->Description = 'Nạp tiền qua MOMO (API): '.number_format($moneyQuydoi, 0, ',', '.').$moneyQuydoi.' đ';
                         if ($coinLog->save()) {
                            DB::connection('sqlsrv_mem')->commit();
                            DB::connection('sqlsrv')->commit();
                        } else {
                            DB::connection('sqlsrv_mem')->rollBack();
                            DB::connection('sqlsrv')->rollBack();
                        }
                        
                        $isFound = true;
                    }
                
                }                 
            }
        }  

        if($isFound) 
            return response()->json(['message' => 'Handle transaction successfuly']);
        return response()->json(['message' => 'Not found any transaction']);
    
        
    }
}
