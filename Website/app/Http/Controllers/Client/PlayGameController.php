<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\MaintenanceMode;
use App\ServerList;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\App;

class PlayGameController extends Controller
{
    public function showSelectServerListView()
    {
        $serverList = ServerList::all();
        return view('client.play-game.select-server',compact('serverList'));
    }

    public function playGame(Request $request, $serverId, $debug = 0)
    {
        $member = $request->user('member');
        $serverList = ServerList::all();
        if ($member->Email == 'admin1') {
            $serverId = 1004;
        }
        $server = ServerList::findOrFail($serverId);

        if (empty($member) || empty($server)) {
            return redirect('/');
        }
        $keyRand = rand(111111, 999999);
        $timeNow = time();
        $requestLink = $server->LinkRequest;

        $stream_opts = [
            "ssl" => [
                "verify_peer" => false,
                "verify_peer_name" => false,
            ]
        ];

        $content = file_get_contents( trim($requestLink, '/'). "/CreateLogin.aspx?content=" . $member->Email . "|" . strtoupper($keyRand) . "|" . $timeNow . "|" . md5($member->Email . strtoupper($keyRand) . $timeNow . env('KEY_REQUEST', 'no-one_is_promised_tomorow')), false, stream_context_create($stream_opts));
        $error = 0;
        $message = '';
        if (trim($content) != "0") {
            $error = 1;
            $message = $content;
        }
        return view('client.play-game.play', [
            //Self
            'server' => $server,
            'serverList' => $serverList,
            'error' => $error,
            'message' => $message,
            'member' => $member,
            'keyrand' => $keyRand,
            'configLink' => $server->LinkConfig,
            'debug' => $debug
        ]);
    }
}
