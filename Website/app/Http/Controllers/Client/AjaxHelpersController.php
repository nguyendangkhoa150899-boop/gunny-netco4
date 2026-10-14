<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\Http\Requests\Client\ChangeNickName\CheckDuplicateNickNameRequest;
use App\Player;
use App\ServerList;
use Illuminate\Http\Request;

class AjaxHelpersController extends Controller
{
    public function getPlayerNickNameByServerId(Request $request)
    {
        $serverId = $request->input('serverId');
        if($serverId == 0 || !$serverId)
            return response()->json(['msg', 'Server không hợp lệ'], 400);
        $server = ServerList::select('Connection', 'ServerID')->find($serverId);
        $players = Player::on($server->Connection)
            ->select('UserID', 'NickName', 'UserName')
            ->where('UserName', $request->user('member')->Email)
            ->get();
        if(!empty($players) && $players->count() > 1) {
			$dt = [];
			foreach ($players as $player) {
				$dt[] = [
					'id' => $player->UserID,
					'nickname' => $player->NickName
				];
			}
			return response()->json($dt);
		} elseif (!empty($players) && $players->count() == 1) {
			$player = $players->first();
			return response()->json(['nickname' => $player->NickName]);
		}
		return response()->json(['msg' => 'Không có nhân vật nào'], 400);

    }

    public function isDuplicateNewNickName(CheckDuplicateNickNameRequest $request)
    {
        $server_id = $request->input('server_id');
        $server = ServerList::find($server_id);
        if (empty($server)) {
            return response()->json(['msg'=>'Lỗi: Không tìm thấy máy chủ!'],422);
        }
        $player = Player::on($server->Connection)->select('UserID', 'NickName')
            ->where('NickName', $request->input('new_name'))
            ->first();
        return $player == null ? response()->json(['msg'=>'Tên nhân vật hợp lệ!'],200) : response()->json(['msg'=>'Lỗi: Tên nhân vật đã tồn tại!'],422);
    }
}
