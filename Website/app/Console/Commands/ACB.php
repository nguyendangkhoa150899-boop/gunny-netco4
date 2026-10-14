<?php

namespace App\Console\Commands;

use App\Models\Member;
use App\Models\PaymentAcbHistory;
use App\Models\PaymentMomoHistory;
use App\Models\Setting;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;

class ACB extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'acbpayment';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Fetch momo payment to add coin every 30s';

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
        $this->rechargeAcb();
        return 0;
    }

    public function rechargeAcb()
    {
        $transList = $this->getAcbHistories();
        $isDirty = false;
        if (!empty($transList)) {
            $transInDb = Cache::rememberForever('acb_histories', function () {
                return PaymentAcbHistory::all();
            });
            foreach ($transList as $transaction) {
                $existedTrans = $transInDb->where('transactionID', $transaction['transactionID'])->first();
                if (!empty($existedTrans)) {
                    continue;
                }
                $comment = $transaction['description'];
                $cmt_parts = explode(' ', $comment);
                $account = $cmt_parts[0];
                if (!empty($account)) {
                    $member = Member::where('Email', strtolower($account))->first();
                    if (!empty($member)) {
                        $amount = $transaction['amount'];
                        $member->Money += floor($amount * Setting::get('he-so-atm'));
                        DB::connection($member->getConnectionName())->beginTransaction();
                        if (!$member->save()) {
                            DB::connection($member->getConnectionName())->rollBack();
                            continue;
                        }
                    }
                }
                $data = [
                    'transactionID' => $transaction['transactionID'],
                    'amount' => $transaction['amount'],
                    'description' => $transaction['description'],
                ];
                $payment = new PaymentAcbHistory($data);
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
                Cache::put('acb_histories', $transInDb);
            }
        }
    }

    private function getAcbHistories()
    {
        $endpoint = "https://api.web2m.com/historyapiacbv3/" . env('WEB2M_ACB_ACCOUNT_PASSWORD', '') . '/' . env('WEB2M_ACB_ACCOUNT_NUMBER', '') . '/' . env('WEB2M_ACB_TOKEN', '');
        $client = new \GuzzleHttp\Client(['verify' => false]);
        $response = $client->request('GET', $endpoint);
        $statusCode = $response->getStatusCode();
        $transList = [];
        if ($statusCode == 200) {
            $body = $response->getBody();
            $body = (string)$body;
            $content = json_decode($body, true);
            $transList = !empty($content['transactions']) ? $content['transactions'] : [];
        }
        return $transList;
    }
}
