<?php


namespace App\Http\Controllers;


use App\Http\Requests\ApiLogin2FaRequest;
use App\Http\Requests\ApiLogin2FaResendRequest;
use App\Http\Requests\CardCallbackRequest;
use App\Launcher2FaCode;
use App\LauncherToken;
use App\Mailer;
use App\Member;
use App\Models\CardCharged;
use App\Models\Player;
use App\Models\ServerList;
use App\Models\Setting;
use Illuminate\Routing\Controller as BaseController;
use App\Http\Requests\ApiLoginRequest;
use Illuminate\Support\Facades\Cache;

class ApiController extends BaseController
{
    protected $currentMember;
    const ACCOUNT_BANNED = 5;
    const LOGIN_WRONG_INFO = 0;
    const MAIL_SENT_FAILED = 6;
    const TOKEN_CREATION_FAILED = 9;
    const NEEDED_2FA_VERIFICATION = 2;
    const LOGIN_SUCCESSFUL = 1;
    const TOKEN_EXPIRED = 10;

    const LOGIN_HASH_CACHE_KEY_PREFIX = 'login-launcher-hash-';
    const LOGIN_HASH_EXPIRED = 11;
    const LOGIN_HASH_NOTFOUND = 15;
    const LOGIN_HASH_MAX_EXCESS = 19;
    const LOGIN_HASH_SUCCESSFUL = 21;

    protected function success($message = '', $data = [], $status = true)
    {
        $returnval = ['success' => $status, 'message' => $message];
        if (!empty($data)) {
            $returnval['data'] = $data;
        }
        echo json_encode($returnval);
        exit;
    }

    protected function error($message = '', $data = [], $status = false)
    {
        $returnval = ['success' => $status, 'message' => $message];
        if (!empty($data)) {
            $returnval['data'] = $data;
        }
        echo json_encode($returnval);
        exit;
    }

    protected function getLogin($username, $password, $check2fa = true)
    {
        $existedMember = Member::where('Email', $username)
            ->where('Password', md5($password))
            ->get();
        if (!empty($existedMember) && $existedMember->count()) {
            $member = $existedMember->first();
            if ($member->IsBan) {
                return self::ACCOUNT_BANNED;
            }
            $member->Email = strtolower($member->Email);
            $member->save();
            $member->login();
            if ($check2fa && !empty($member['2fa']) && $member->Fullname) {
                $mailer = new Mailer();
                $sent_status = $mailer->TwoFactorAuthentication($member->Fullname);
                if ($sent_status['success']) {
                    $launcherToken = new Launcher2FaCode();
                    $launcherToken->MemberID = $member->UserID;
                    $launcherToken->code = md5($sent_status['code']);
                    $launcherToken->status = 0;
                    if ($launcherToken->save()) {
                        $this->currentMember = $member;
                        return self::NEEDED_2FA_VERIFICATION;
                    }
                    return self::TOKEN_CREATION_FAILED;
                }
                return self::MAIL_SENT_FAILED;
            }
            $this->currentMember = $member;
            return self::LOGIN_SUCCESSFUL;
        }
        return self::LOGIN_WRONG_INFO;
    }

    public function login(ApiLoginRequest $request)
    {
        $username = $request->username;
        $password = $request->password;

        $this->isBlockedAccess($username);

        $login_status = $this->getLogin($username, $password);
        switch ($login_status) {
            case self::ACCOUNT_BANNED:
                $this->error('Tài khoản của bạn đã bị khóa!');
                break;
            case self::LOGIN_SUCCESSFUL:
                $this->success('Đăng nhập thành công!', [
                    'username' => $this->currentMember->Email,
                    'email' => $this->currentMember->Fullname,
                    'coin' => number_format($this->currentMember->Money)
                ]);
                break;
            case self::NEEDED_2FA_VERIFICATION:
                $this->success('Đăng nhập thành công!', [
                    'email' => sensorEmail($this->currentMember->Fullname),
                    'MemberID' => $this->currentMember->UserID,
                    //'expires' => env('2FA_LAUNCHER_TOKEN_EXPIRES', 7200),
                ], 2);
                break;
            case self::TOKEN_CREATION_FAILED:
            case self::MAIL_SENT_FAILED:
                $this->error('Server gặp sự cố, vui lòng báo cáo cho quản trị viên để khắc phục!');
                break;
        }
        $this->error('Sai tài khoản hoặc mật khẩu!');
        exit;
    }

    public function login2fa(ApiLogin2FaRequest $request)
    {
        $code = $request->code;
        $memberId = $request->member;
        $attempts = Launcher2FaCode::where('MemberID', $memberId)
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
                    $member = Member::findOrFail($memberId);
                    $launcerToken = new LauncherToken();
                    $launcerToken->MemberID = $member->UserID;
                    $launcerToken->token = strtoupper(uniqid('GoGunLauncer', true));
                    $launcerToken->status = 0;
                    if ($launcerToken->save()) {
                        $this->success('Đăng nhập thành công!', [
                            'username' => $member->Email,
                            'email' => $member->Fullname,
                            'coin' => number_format($member->Money),
                            'token' => $launcerToken->token
                        ]);
                    }
                }
                $this->error('Server gặp sự cố, vui lòng báo cáo cho quản trị viên để khắc phục!');
            }
            foreach ($attempts as $item) {
                $item->status = 2;
                $item->save();
            }
            $this->error('Mã hết hiệu lực!');
        }
        $this->error('Yêu cầu không hợp lệ!');
    }

    public function login2faresendcode(ApiLogin2FaResendRequest $request)
    {
        $member_id = $request->member;
        $existed2facode = Launcher2FaCode::where('MemberID', $member_id)
            ->where('status', 0)
            ->orderBy('created_at', 'DESC')
            ->get();
        if (!empty($existed2facode) && $existed2facode->count()) {
            $last2fa = $existed2facode->first();
            $last_time = strtotime($last2fa->created_at);
            $time = strtotime('now') - $last_time;
            if ($time > env('2FA_WAITING_TIME_TO_RESEND', 60)) {
                foreach ($existed2facode as $item) {
                    $item->status = 2;
                    $item->save();
                }
                $sent_status = $this->sendCode();
                if ($sent_status === 0) {
                    $this->success('Gửi lại mã đăng nhập thành công!');
                }
                if ($sent_status === 1) {
                    $this->error('Có lỗi xảy ra, vui lòng thử lại hoặc liên hệ quản trị viên để được trợ giúp!');
                }
                if ($sent_status === 2) {
                    $this->error('Không thể gửi email, thử lại hoặc liên hệ quản trị viên để được trợ giúp!');
                }
            }
            $rest_time = env('2FA_WAITING_TIME_TO_RESEND', 60) - $time;
            $this->error('Hãy đợi ' . intval($rest_time/60).':'.intval($rest_time%60).'s nữa rồi thử lại!');
        }
        $this->error('Yêu cầu không hợp lệ!');
    }

    public function loginGame(ApiLoginRequest $request)
    {
        $username = $request->username;
        $password = $request->password;

        $this->isBlockedAccess($username);

        $login_status = $this->getLogin($username, $password, false);
        if ($login_status == self::ACCOUNT_BANNED) {
            $this->error('Tài khoản của bạn đã bị khóa!');
        }
        if ($login_status == self::LOGIN_WRONG_INFO) {
            $this->error('Sai tài khoản hoặc mật khẩu!');
        }
        if (!empty($this->currentMember['2fa']) && !empty($this->currentMember->Fullname)) {
            $token = $request->token;
            $launcherTokens = LauncherToken::where('MemberID', $this->currentMember->UserID)
                ->where('token', $token)
                ->where('status', 0)
                ->get();
            if (!empty($launcherTokens) && $launcherTokens->count()) {
                $last_token = $launcherTokens->first();
                $last_time = strtotime($last_token->created_at);
                $time = strtotime('now') - $last_time;
                if ($time > env('2FA_LAUNCHER_TOKEN_EXPIRES', 7200)) {
                    $this->error('Phiên đăng nhập hết hạn!', [], self::TOKEN_EXPIRED);
                }
                foreach ($launcherTokens as $item) {
                    $item->status = 2;
                    $item->save();
                }
            } else {
                $this->error('Yêu cầu không hợp lệ!');
            }
        }
        $svid = 1;
        $bypass = false;
        $serverInfo = ServerList::find($svid);
        if (empty($serverInfo)) {
            $this->error('Server Die!');
        }
        $keyrand = rand(111111, 999999);
        $timeNow = time();
        $requestLink = $serverInfo->LinkRequest;
        $content = file_get_contents( trim($requestLink, '/'). "/CreateLogin.aspx?content=" . $username . "|" . strtoupper($keyrand) . "|" . $timeNow . "|" . md5($username . strtoupper($keyrand) . $timeNow . env('KEY_REQUEST', 'no-one_is_promised_tomorow')));
        if (trim($content) != "0") {
            $this->error($content);
        }
        $configLink = '';
        $flashFile = 'Loading.swf';
        $flashUrl = '';
        $player = Player::select('UserID', 'LoginDevice')->where('UserName', $username)->first();
        if (!empty($player)) {
            $player->LauncherLoggedin();
            $configLink = $serverInfo->LinkConfig;
            $flashUrl = trim(env('FLASH_URL'), '/');
        } else {
            $configLink = $serverInfo->LinkConfigRegister;
            $flashUrl = trim(env('FLASH_URL_REGISTER'), '/');
        }
        $text = $flashUrl.'/Loading.swf?user=' . $username . '&key=' . $keyrand . '&v=10950&rand=' . rand(100000000, 999999999) . '&config=' . $configLink . '&sessionId=' . rand(100000000, 999999999);//dang nhap thanh cong
        $this->success('', ['playUrl' => $text]);
    }

    public function cardCallback(CardCallbackRequest $request)
    {
        $status = $request->status;
        $serial = $request->serial;
        $pin = $request->pin;
        $card_type = $request->card_type;
        $amount = $request->amount;
        $real_amount = $request->real_amount;
        $content = $request->get('content');
        $card_onhold = CardCharged::where('Seri', $serial)
            ->where('Passcard', $pin)
            ->where('TaskID', $content)
            ->where('Active', 1)
            ->where('status', 0)
            ->first();
        if (!empty($card_onhold)) {
            if($status == 'thanhcong') {
                //Xử lý nạp thẻ thành công tại đây.
                $card_onhold->Active = 0;
                $card_onhold->status = 1;
                if ($card_onhold->save()) {
                    $member = Member::where('Email', $card_onhold->UserName)
                        ->first();
                    if (!empty($member)) {
                        $he_so = Setting::get('he-so-nap-the');
                        $bonus = Setting::get('charge-bonus');
                        $member->Money += round($amount * $he_so * floatval(max($bonus/100 + 1, 1)));
                        $member->save();
                    }
                }
            } else if($status == 'saimenhgia') {
                //Xử lý nạp thẻ sai mệnh giá tại đây.
                $card_onhold->status = 3; //sai menh gia
                $card_onhold->Active = 0; //sai menh gia
                $card_onhold->save();
            } else {
                //Xử lý nạp thẻ thất bại tại đây.
                $card_onhold->status = 2; //nap that bai
                $card_onhold->Active = 0; //sai menh gia
                $card_onhold->save();
            }
        }
    }

    private function isBlockedAccess($username, $return = false)
    {
        $key = 'login-by-launcher-'.$username.'-attempts';
        $keyTime = 'login-by-launcher-'.$username.'-blocked';
        if (Cache::has($key)) {
            $number = Cache::get($key);
            if ($number > 10) {
                if (strtotime('now') - Cache::get($keyTime) > 30) {
                    Cache::forget($key);
                    Cache::forget($keyTime);
                    return true;
                }
                if (!$return) {
                    $this->error('No Access!');
                }
                return false;
            }
            Cache::increment($key);
        } else {
            Cache::remember($key, 60*60, function () {
                return 1;
            });
            Cache::remember($keyTime, 60*60, function () {
                return strtotime('now');
            });
        }
        return true;
    }

    private function generateHash($username)
    {
        $hash = md5(uniqid());
        $cache_key = self::LOGIN_HASH_CACHE_KEY_PREFIX.$hash;
        $cache_key_time = self::LOGIN_HASH_CACHE_KEY_PREFIX.$hash.'-time';
        $cache_key_count = self::LOGIN_HASH_CACHE_KEY_PREFIX.$hash.'-count';
        Cache::put($cache_key, $username, 60*60);
        Cache::put($cache_key_time, strtotime('now'), 60*60);
        Cache::put($cache_key_count, 1, 60*60);
        return $hash;
    }

    private function getLoggedInfoFromHash($hash)
    {
        $cache_key = self::LOGIN_HASH_CACHE_KEY_PREFIX.$hash;
        $cache_key_time = self::LOGIN_HASH_CACHE_KEY_PREFIX.$hash.'-time';
        $cache_key_count = self::LOGIN_HASH_CACHE_KEY_PREFIX.$hash.'-count';
        if (!Cache::has($cache_key) || !Cache::has($cache_key_time) || !Cache::has($cache_key_count)) {
            return self::LOGIN_HASH_NOTFOUND;
        }
        $username = Cache::get($cache_key);
        $loggedin_time = Cache::get($cache_key_time);
        $loggedin_count = Cache::get($cache_key_count);
        if (empty($username) || empty($loggedin_time) || empty($loggedin_count) || strtotime('now') - $loggedin_time > 60*60*2 || $loggedin_count > 30) {
            // one hash has 2 hours to live and 30 times to be valid
            Cache::forget($cache_key);
            Cache::forget($cache_key_time);
            Cache::forget($cache_key_count);
            return self::LOGIN_HASH_EXPIRED;
        }
        Cache::increment($cache_key_count);
        return $username;
    }

    public function loginWithLauncher(ApiLoginRequest $request)
    {
        $username = $request->username;
        $password = $request->password;

        $this->isBlockedAccess($username);

        $login_status = $this->getLogin($username, $password);
        switch ($login_status) {
            case self::ACCOUNT_BANNED:
                $this->error('Tài khoản của bạn đã bị khóa!');
                break;
            case self::LOGIN_SUCCESSFUL:
                $hash = $this->generateHash($username);
                $this->success('Đăng nhập thành công!', [
                    'username' => $this->currentMember->Email,
                    'email' => $this->currentMember->Fullname,
                    'coin' => number_format($this->currentMember->Money),
                    'hash' => $hash
                ]);
                break;
            case self::NEEDED_2FA_VERIFICATION:
                $this->success('Đăng nhập thành công!', [
                    'email' => sensorEmail($this->currentMember->Fullname),
                    'MemberID' => $this->currentMember->UserID,
                    //'expires' => env('2FA_LAUNCHER_TOKEN_EXPIRES', 7200),
                ], 2);
                break;
            case self::TOKEN_CREATION_FAILED:
            case self::MAIL_SENT_FAILED:
                $this->error('Server gặp sự cố, vui lòng báo cáo cho quản trị viên để khắc phục!');
                break;
        }
        $this->error('Sai tài khoản hoặc mật khẩu!');
        exit;
    }

    public function login2fa2(ApiLogin2FaRequest $request)
    {
        $code = $request->code;
        $memberId = $request->member;
        $attempts = Launcher2FaCode::where('MemberID', $memberId)
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
                    $member = Member::findOrFail($memberId);
                    $launcerToken = new LauncherToken();
                    $launcerToken->MemberID = $member->UserID;
                    $launcerToken->token = strtoupper(uniqid('GoGunLauncer', true));
                    $launcerToken->status = 0;
                    if ($launcerToken->save()) {
                        $hash = $this->generateHash($member->Email);
                        $this->success('Đăng nhập thành công!', [
                            'username' => $member->Email,
                            'email' => $member->Fullname,
                            'coin' => number_format($member->Money),
                            'token' => $launcerToken->token
                        ]);
                    }
                }
                $this->error('Server gặp sự cố, vui lòng báo cáo cho quản trị viên để khắc phục!');
            }
            foreach ($attempts as $item) {
                $item->status = 2;
                $item->save();
            }
            $this->error('Mã hết hiệu lực!');
        }
        $this->error('Yêu cầu không hợp lệ!');
    }

    public function loginGameWithLauncher($hash, $token = '')
    {
        $error = '';
        if (empty($hash)) {
            $error = 'No Access';
            goto theEnd;
        }
        //$username = $this->getLoggedInfoFromHash($hash);
        $username = 'koolkiizz';
        if ($username === self::LOGIN_HASH_EXPIRED) {
            $error = 'Phiên đăng nhập hết hạn!';
            goto theEnd;
        }
        if (!$this->isBlockedAccess($username, true)) {
            $error = 'No Access';
            goto theEnd;
        }

        $member = Member::where('Email', $username)->first();
        if (empty($member)) {
            $this->error('Tài khoản của bạn đã bị xóa!');
        }
        if ($member->IsBan) {
            $this->error('Tài khoản của bạn đã bị khóa!');
        }
        if (!empty($member['2fa']) && !empty($member->Fullname)) {
            if (empty($token)) {
                $this->error('No Access');
            }
            $launcherTokens = LauncherToken::where('MemberID', $member->UserID)
                ->where('token', $token)
                ->where('status', 0)
                ->get();
            if (!empty($launcherTokens) && $launcherTokens->count()) {
                $last_token = $launcherTokens->first();
                $last_time = strtotime($last_token->created_at);
                $time = strtotime('now') - $last_time;
                if ($time > env('2FA_LAUNCHER_TOKEN_EXPIRES', 7200)) {
                    $this->error('Phiên đăng nhập hết hạn!', [], self::TOKEN_EXPIRED);
                }
                foreach ($launcherTokens as $item) {
                    $item->status = 2;
                    $item->save();
                }
            } else {
                $this->error('Yêu cầu không hợp lệ!');
            }
        }
        $svid = 1001;
        $bypass = false;
        $serverInfo = ServerList::find($svid);
        if (empty($serverInfo)) {
            $this->error('Server Die!');
        }
        $keyrand = rand(111111, 999999);
        $timeNow = time();
        $requestLink = $serverInfo->LinkRequest;
        $content = file_get_contents( trim($requestLink, '/'). "/CreateLogin.aspx?content=" . $username . "|" . strtoupper($keyrand) . "|" . $timeNow . "|" . md5($username . strtoupper($keyrand) . $timeNow . env('KEY_REQUEST', 'no-one_is_promised_tomorow')));
        if (trim($content) != "0") {
            $this->error($content);
        }
        $player = Player::select('UserID', 'LoginDevice')->where('UserName', $username)->first();
        if (!empty($player)) {
            $player->LauncherLoggedin();
        }
        $text = trim(env('APP_URL', 'https://go-gun.com'), '/').'/flash/Loading.swf?user=' . $username . '&key=' . $keyrand . '&v=10950&rand=' . rand(100000000, 999999999) . '&config=' . $serverInfo->LinkConfig . '&sessionId=' . rand(100000000, 999999999);//dang nhap thanh cong
        theEnd:
        $ua = $_SERVER['HTTP_USER_AGENT'];
        $is_Uc = false;
        if (strpos($ua, 'UBrowser')) {
            $is_Uc = true;
        }
        return view('launcherplay', [
            'error' => $error,
            'username' => $member->Email,
            'keyrand' => $keyrand,
            'configLink' => $serverInfo->LinkConfig,
            'is_uc' => $is_Uc
        ]);
    }
}
