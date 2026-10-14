<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Player;
use App\Member;
use App\Models\ServerList;

class PlayController extends Controller
{
    public function index($sv_id)
    {
        $member = $this->getCurrentMember();
        $server = ServerList::find($sv_id);
        if (empty($member) || empty($server)) {
            return redirect('/');
        }
        $keyrand = rand(111111, 999999);
        $timeNow = time();
        $requestLink = $server->LinkRequest;
        $url = trim($requestLink, '/'). "/CreateLogin.aspx?content=" . $member->Email . "|" . strtoupper($keyrand) . "|" . $timeNow . "|" . md5($member->Email . strtoupper($keyrand) . $timeNow . env('KEY_REQUEST', 'no-one_is_promised_tomorow'));
        $content = file_get_contents($url);
        $error = 0;
        $message = '';
        if (trim($content) != "0") {
            $error = 1;
            $message = $content;
        }
        $flashFile = 'Loading.swf';
        $configLink = $server->LinkConfig;
        $flashUrl = trim(env('FLASH_URL'), '/');
        $player = Player::select('UserID', 'LoginDevice')->where('UserName', $member->Email)->first();
        if (empty($player)) {
            $configLink = $server->LinkConfigRegister;
            $flashUrl = trim(env('FLASH_URL_REGISTER'), '/');
        }
        return view('play', [
            'error' => $error,
            'message' => $message,
            'username' => $member->Email,
            'keyrand' => $keyrand,
            'configLink' => $configLink,
            'flashFile' => $flashFile,
            'flashUrl' => $flashUrl
        ]);
    }
}
