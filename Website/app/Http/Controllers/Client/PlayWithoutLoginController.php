<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\Http\Requests\Client\ChangeLinkPlayRequest;
use App\Member;
use App\PlayWithoutLogin;
use App\ServerList;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class PlayWithoutLoginController extends Controller
{
    private function intialOrGenerateLinkPlay($user)
    {
        $keyVerify = $user->UserID.Str::random(80);
        if(PlayWithoutLogin::where('UserID', $user->UserID)->exists()){
            $linkPlay = PlayWithoutLogin::where('UserID', $user->UserID)->first();
            return $linkPlay->KeyVerify;
        }
        PlayWithoutLogin::create([
            'UserID' => $user->UserID,
            'Email' => $user->Email,
            'KeyVerify' => $keyVerify,
//            'TimeCreate' => now()
        ]);
        return $keyVerify;
    }

    public function showGetLinkPlay(Request $request)
    {
        if($request->ajax()){
            $user = $request->user('member');
            $linkPlay = $this->intialOrGenerateLinkPlay($user);
            $linkPlay = route('view-select-game-without-login', $linkPlay);
            $html = view('client.account.play-without-authenticate', compact('linkPlay'))->render();
            return response()->json( $html );
        }
        return route('home');
    }

    public function changeLinkPlay(ChangeLinkPlayRequest $request)
    {
        $user = $request->user('member');
        $keyVerify = $user->UserID.Str::random(80);
        if(PlayWithoutLogin::where('UserID', $user->UserID)->exists()){
            PlayWithoutLogin::where('UserID', $user->UserID)->update(['KeyVerify' => $keyVerify]);
            $linkPlay = route('view-select-game-without-login', $keyVerify);

            return response()->json(['linkPlay'=>$linkPlay]);
        }
        PlayWithoutLogin::create([
            'UserID' => $user->UserID,
            'Email' => $user->Email,
            'KeyVerify' => $keyVerify,
//            'TimeCreate' => now()
        ]);
        $linkPlay = route('view-select-game-without-login', $keyVerify);

        return response()->json(['linkPlay'=>$linkPlay]);
    }


    public function isAcceptToSlectAndPlay($token)
    {
        if(PlayWithoutLogin::where('KeyVerify', $token)->exists()){
            return PlayWithoutLogin::where('KeyVerify', $token)->first()->KeyVerify;
        }
        return false;
    }

    public function selectServerWithoutAuthenticate($token)
    {
        $keyVerify = $this->isAcceptToSlectAndPlay($token);
        if($keyVerify){
            $serverList = ServerList::all();
            $user = PlayWithoutLogin::where('KeyVerify', $token)->first();
            return view('client.play-without-login.select-server-free', compact('serverList', 'user', 'keyVerify'));
        }
        return redirect(route('home'));
    }

    public function playGameWithoutAuthenticate($serverId, $token)
    {
        $keyVerify = $this->isAcceptToSlectAndPlay($token);
        if($keyVerify){
            $userId = PlayWithoutLogin::where('KeyVerify', $token)->first()->UserID;
            $member = Member::findOrFail($userId);
            $serverList = ServerList::all();
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
            return view('client.play-without-login.play-free', [
                //Self
                'server' => $server,
                'serverList' => $serverList,
                'error' => $error,
                'message' => $message,
                'member' => $member,
                'keyrand' => $keyRand,
                'configLink' => $server->LinkConfig
            ]);
        }
        return redirect(route('home'));
    }


}
