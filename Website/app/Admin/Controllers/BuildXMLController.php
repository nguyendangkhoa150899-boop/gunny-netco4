<?php

namespace App\Admin\Controllers;


use App\Admin;
use App\EventTypeCompete;
use App\MaintenanceWebHook;
use App\MissionInfo;
use App\NPC;
use App\Player;
use App\ServerList;
use Illuminate\Contracts\Foundation\Application;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class BuildXMLController
{
    public function createAllXML($id)
    {
        $server = ServerList::find($id);
        if($server){
            $stream_opts = [
                "ssl" => [
                    "verify_peer" => false,
                    "verify_peer_name" => false,
                ]
            ];
            $content = file_get_contents(trim($server->LinkRequest, '/') . "/createallxml.ashx", false, stream_context_create($stream_opts));
            if ($content != 'IP is not valid!') {
                $content = str_replace('!Build', '!<br>Build', $content);
            }
            return response()->json(['msg'=> $content]);
        }
        return response()->json(['msg' => 'Không tìm thấy server'],400);
    }

    public function buildQuest($id)
    {
        $server = ServerList::find($id);
        if($server){
            $stream_opts = [
                "ssl" => [
                    "verify_peer" => false,
                    "verify_peer_name" => false,
                ]
            ];
            $content = file_get_contents(trim($server->LinkRequest, '/') . "/QuestList.ashx", false, stream_context_create($stream_opts));
            if ($content != '5') {
                $content = str_replace('!Build', '!<br>Build', $content);
            }
            return response()->json(['msg'=> $content]);
        }
        return response()->json(['msg' => 'Không tìm thấy server'],400);
    }

    public function buildActive($id)
    {
        $server = ServerList::find($id);
        if($server){
            $stream_opts = [
                "ssl" => [
                    "verify_peer" => false,
                    "verify_peer_name" => false,
                ]
            ];
            $content = file_get_contents(trim($server->LinkRequest, '/') . "/ActiveList.ashx", false, stream_context_create($stream_opts));
            if ($content != '5') {
                $content = str_replace('!Build', '!<br>Build', $content);
            }
            return response()->json(['msg'=> $content]);
        }
        return response()->json(['msg' => 'Không tìm thấy server'],400);
    }

    public function sendMaintenanceNotice($id)
    {
        $server = ServerList::find($id);
        if($server){
            $stream_opts = [
                "ssl" => [
                    "verify_peer" => false,
                    "verify_peer_name" => false,
                ]
            ];
            $content = file_get_contents(trim($server->LinkRequest, '/') . "/KitoffUser.aspx", false, stream_context_create($stream_opts));
            if ($content != '0') {
                $content = "Đã gửi lệnh thông báo bảo trì server sau 5 phút nữa!";
            }
            return response()->json(['msg'=> $content]);
        }
        return response()->json(['msg' => 'Không tìm thấy server'],400);
    }
}
