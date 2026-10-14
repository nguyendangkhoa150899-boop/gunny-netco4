<?php

namespace App\Console\Commands;

use App\Member;
use App\PaymentMomoHistory;
use App\Setting;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;

class Momo extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'momopayment';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Fetch momo payment to add coin every 1m';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {
        $this->rechargeMomo();
        return 0;
    }

    public function rechargeMomo()
    {
        $transList = $this->getMomoHistories();
        $isDirty = false;
        if (!empty($transList)) {
            $transInDb = Cache::rememberForever('momo_histories', function () {
                return PaymentMomoHistory::all();
            });
            foreach ($transList as $transaction) {
                $existedTrans = $transInDb->where('tranId', $transaction['tranId'])->first();
                if (!empty($existedTrans)) {
                    continue;
                }
                $status = $transaction['status'];
                if ($status == 999) {
                    $comment = (empty($transaction['comment']) || is_array($transaction['comment'])) ? '' : $transaction['comment'];
                    if (!empty($comment)) {
                        $prefix = substr($comment, 0, 3);
                        if ($prefix == env('MOMO_COMMENT_PREFIX', ' NO SERVER ').' ') {
                            $email = substr($comment, 3);
                            $member = Member::where('Email', strtolower(trim($email)))->first();
                            if (!empty($member)) {
                                $money = $transaction['amount'];
                                $heSoATM = Setting::get('he-so-atm');
                                $bonus = Setting::get('charge-bonus');
                                //Calculate rate & money
                                $allBonusMoney = 0;
                                //tienKhuyenMai = (tongtien * phantram) /100
                                $systemBonusMoney = $money * floatval($bonus * 100)/100;
                                $individualBonusMoney = 0;
                                $allBonusMoney = $systemBonusMoney + $individualBonusMoney;
                                $moneyWillBeCharge = round(($money + $allBonusMoney) * $heSoATM );
                                $member->Money += $moneyWillBeCharge;
                                $vipExp = $money * Setting::get('vip-exp-rate');
                                $member->VIPExp += $vipExp;
                                //$member->Money += floor($amount * Setting::get('he-so-atm'));
                                DB::connection($member->getConnectionName())->beginTransaction();
                                if (!$member->save()) {
                                    DB::connection($member->getConnectionName())->rollBack();
                                    continue;
                                }
                            }
                        }
                    }
                    $data = [
                        'comment' => $comment,
                        'tranId' => $transaction['tranId'],
                        'amount' => $transaction['amount'],
                        'user' => $transaction['user'],
                        'partnerId' => $transaction['partnerId'],
                        'partnerName' => $transaction['partnerName'],
                        'status' => $status,
                    ];
                    $payment = new PaymentMomoHistory($data);
                    DB::connection($payment->getConnectionName())->beginTransaction();
                    if (!$payment->save()) {
                        if (!empty($member)) {
                            DB::connection($member->getConnectionName())->rollBack();
                        }
                        DB::connection($payment->getConnectionName())->rollBack();
                        continue;
                    }
                    DB::connection($payment->getConnectionName())->commit();
                    if (!empty($member)) {
                        DB::connection($member->getConnectionName())->commit();
                    }
                    $transInDb->push($payment);
                    Cache::put('momo_histories', $transInDb, 0);
                }
            }
        }
    }

    private function getMomoHistories()
    {
        $endpoint = "https://api.web2m.com/historyapimomo/" . env('WEB2M_MOMO_TOKEN', '');
        $client = new \GuzzleHttp\Client(['verify' => false]);
        $response = $client->request('GET', $endpoint);
        $statusCode = $response->getStatusCode();
        $transList = [];
        if ($statusCode == 200) {
            $body = $response->getBody();
            $body = (string)$body;
            $content = json_decode($body, true);
            $transList = !empty($content['momoMsg']['tranList']) ? $content['momoMsg']['tranList'] : [];
        }
        return $transList;
    }
}
