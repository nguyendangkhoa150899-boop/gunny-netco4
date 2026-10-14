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

class MaintenanceController
{
    protected $app;

    public function __construct(Application $app)
    {
        $this->app = $app;
    }

    public function downServerGame($serverId)
    {
        $server = ServerList::findOrFail($serverId);
        $helpersController = new HelpersController($this->app);
        $stream_opts = [
            "ssl" => [
                "verify_peer" => false,
                "verify_peer_name" => false,
            ]
        ];
        if($server->Status == 1 || $server->Status == 2){
            $server->Status = 0;
            if($server->save()){
                $content = file_get_contents(trim($server->LinkRequest, '/') . "/KitoffUser.aspx", false, stream_context_create($stream_opts));
                if($content == 0){
                    return response()->json(['msg' => 'Chưa gửi thông báo bảo trì lên server thành công!'], 400);
                }
                $helpersController->clearSlideCache();
                $helpersController->clearServerListCache();
                return response()->json(['msg' => 'Chuyển SV: '.$server->ServerName.' sang chế độ bảo trì thành công!']);
            }
            else
                return response()->json(['msg' => 'Đã có lỗi trong quá trình bảo trì server!'], 400);
        }

        return response()->json(['msg' => 'Server đã được bảo trì trước đó!'], 400);
    }

    public function upServerGame($serverId)
    {
        $server = ServerList::findOrFail($serverId);
        $helpersController = new HelpersController($this->app);
        if($server->Status == 0){
            $server->Status = 1;
            if($server->save()){
                $helpersController->clearSlideCache();
                $helpersController->clearServerListCache();
                return response()->json(['msg' => 'Server '.$server->ServerName.' đã hoạt động lại!']);
            }
            else
                return response()->json(['msg' => 'Đã có lỗi trong quá trình mở server!'], 400);
        }

        return response()->json(['msg' => 'Server đang không bảo trì!'], 400);
    }
}
