<?php

namespace App\Http\Controllers\Launcher;

use App\Http\Controllers\Controller;
use App\Http\Requests\Launcher\LoginLauncherRequest;
use App\Member;
use App\Player;
use App\ServerList;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class PlayGameLauncherController extends Controller
{
    public function loginGame(LoginLauncherRequest $request)
    {
        $username = $request->input('username');
        $password = $request->input('password');
        $svId = $request->input('serverID');
        //LOGIN FIRST For check account banned or not
        if (!Auth::guard('member')->attempt(['Email' => $username, 'password' => $password])) {
            return response()->json(['success'=> false, 'message' => 'Tài khoản hoặc mật khẩu không đúng']);
        }

        $member = Auth::guard('member')->user();
        if($member->IsBan == 1)
            return response()->json(['success'=> false, 'message' => 'Tài khoản của bạn đã bị khoá']);

        if($svId == null)
            $svId = 1001;
        $server = ServerList::find($svId);
        if(!$server)
            return response()->json(['success'=> false, 'message' => 'Không có server nào là '.$svId]);
        $keyRand = rand(111111, 999999);
        $timeNow = time();
        $requestLink = $server->LinkRequest;

		$arrContextOptions=array(
			"ssl"=>array(
				"verify_peer"=>false,
				"verify_peer_name"=>false,
			),
		);

		$content = file_get_contents( trim($requestLink, '/'). "/CreateLogin.aspx?content=" . $username . "|" . strtoupper($keyRand) . "|" . $timeNow . "|" . md5($username . strtoupper($keyRand) . $timeNow . env('KEY_REQUEST', 'QY-16-WAN-0668-2555555-7ROAD-dandantang-love777')), false, stream_context_create($arrContextOptions));
        if (trim($content) != "0") {
            return $content;
        }
        $player = Player::on($server->Connection)
            ->select('UserID', 'LoginDevice')
            ->where('UserName', $username)->first();
        if($player)
            $player->launcherLoggedin();

        $playUrl =  trim(env('APP_URL', 'http://gunny92.com'), '/').'/flash/Loading.swf?user=' . $username . '&key=' . $keyRand . '&v=10950&rand=' . rand(100000000, 999999999) . '&config=' . $server->LinkConfig . '&sessionId=' . rand(100000000, 999999999);
        return response()->json([
            'success' => true,
            'message' => '',
            'data' =>  [
                'playUrl' => $playUrl
            ]
        ]);
    }

    public function loginGame2(LoginLauncherRequest $request)
    {
        $username = $request->input('username');
        $password = $request->input('password');
        $svId = $request->input('serverID');
        //LOGIN FIRST For check account banned or not
        if (!Auth::guard('member')->attempt(['Email' => $username, 'password' => $password])) {
            return response()->json(['success'=> false, 'message' => 'Tài khoản hoặc mật khẩu không đúng']);
        }

        $member = Auth::guard('member')->user();
        if($member->IsBan == 1)
            return response()->json(['success'=> false, 'message' => 'Tài khoản của bạn đã bị khoá']);

        if($svId == null)
            $svId = 1001;
        $server = ServerList::find($svId);
        if(!$server)
            return response()->json(['success'=> false, 'message' => 'Không có server nào là '.$svId]);
        $keyRand = rand(111111, 999999);
        $timeNow = time();
        $requestLink = $server->LinkRequest;

        $arrContextOptions=array(
            "ssl"=>array(
                "verify_peer"=>false,
                "verify_peer_name"=>false,
            ),
        );

        $content = file_get_contents( trim($requestLink, '/'). "/CreateLogin.aspx?content=" . $username . "|" . strtoupper($keyRand) . "|" . $timeNow . "|" . md5($username . strtoupper($keyRand) . $timeNow . env('KEY_REQUEST', 'QY-16-WAN-0668-2555555-7ROAD-dandantang-love777')), false, stream_context_create($arrContextOptions));
        if (trim($content) != "0") {
            return response($content);
        }
        $player = Player::on($server->Connection)
            ->select('UserID', 'LoginDevice')
            ->where('UserName', $username)->first();
        if($player)
            $player->launcherLoggedin();

        $playUrl =  trim(env('APP_URL', 'http://gunny92.com'), '/').'/flash/Loading.swf?user=' . $username . '&key=' . $keyRand . '&v=10950&rand=' . rand(100000000, 999999999) . '&config=' . $server->LinkConfig . '&sessionId=' . rand(100000000, 999999999);
        return response($playUrl);
    }
}
