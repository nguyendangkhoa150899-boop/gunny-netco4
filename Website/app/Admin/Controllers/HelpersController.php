<?php

namespace App\Admin\Controllers;


use App\Admin;
use App\DropCondiction;
use App\EventTypeCompete;
use App\MaintenanceWebHook;
use App\Member;
use App\MissionInfo;
use App\NPC;
use App\Player;
use App\ServerList;
use Illuminate\Contracts\Foundation\Application;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class HelpersController
{
    protected $app;

    public function __construct(Application $app)
    {
        $this->app = $app;
    }

    public function clearConfigCache()
    {
        cache()->forget('configsFromCached'); //Cached values from DB
        cache()->forget('configCached'); //cached config variable
        return "OK_HUNGTHINH_IS_THE_BEST";
    }

    public function clearServerListCache()
    {
        cache()->forget('serverList');
        return "OK_HUNGTHINH_IS_THE_BEST";
    }

    public function clearSlideCache()
    {
        cache()->forget('slides');
        return "OK_HUNGTHINH_IS_THE_BEST";
    }


    public function clearAllConfigCache()
    {
        $this->clearConfigCache();
        $this->clearServerListCache();
        $this->clearSlideCache();
        return "OK_HUNGTHINH_IS_THE_BEST";
    }

    public function getListPlayer(Request $request)
    {
        $serverId = $request->input('server_id');
        $server = ServerList::select('ServerName', 'ServerID', 'Connection')->find($serverId);
        $q = $request->get('q');
        $players = Player::on($server->Connection)->select('UserID', 'UserName', 'NickName', 'Grade')
            ->where('NickName', 'like', "%$q%")
            ->orWhere('UserName', 'like', "%$q%")
            ->paginate();
        $players->getCollection()->transform(function ($value) use ($server) {
            return [
                'id' => $value->UserID,
                'text' => 'TK: ' . $value->UserName . ' - Nhân vật: ' . $value->NickName . ' (Server: ' . $server->ServerName . ' - ID: ' . $value->UserID . ' - Level: ' . $value->Grade . ')',
            ];
        });

        return $players;
    }

    public function getEventTypeCompete(Request $request)
    {
        $q = $request->get('q');
        return EventTypeCompete::where('type_name', 'like', "%$q%")
            ->paginate();
    }

    public function downServer()
    {
        $webhook = MaintenanceWebHook::where('is_active', 1)->first();

        if($webhook){
            $url = $webhook->webhook_url;
            $headers = [ 'Content-Type: application/json; charset=utf-8' ];
            $POST = [
                "embeds" => [
                    /*
                     * Our first embed
                     */
                    [
                        // Set the title for your embed
                        "title" => "THÔNG BÁO BẢO TRÌ",

                        // The type of your embed, will ALWAYS be "rich"
                        "type" => "rich",

                        // A description for your embed
                        "description" => "Hệ thống tạm thời đang được bảo trì, các Gunners vui lòng quay lại sau khi có thông báo nhé!",


                        // The integer color to be used on the left side of the embed
                        "color" => hexdec( "FFFFFF" ),

                        // Footer object
                        "footer" => [
                            "text" => "By GoGun.vn",
                            "icon_url" => "https://pbs.twimg.com/profile_images/972154872261853184/RnOg6UyU_400x400.jpg"
                        ],
                    ]
                ]
            ];

            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $url);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($POST));
            $response   = curl_exec($ch);
            curl_close( $ch );
            // If you need to debug, or find out why you can't send message uncomment line below, and execute script.
            // echo $response;
        }
        if ($this->app->isDownForMaintenance())
            return response()->json(['msg' => 'Server đã được bảo trì rồi!'], 400);
        Artisan::call('down');
        return response()->json(['msg' => 'Đã bảo trì server!']);
    }

    public function upServer()
    {
        $webhook = MaintenanceWebHook::where('is_active', 1)->first();
        if($webhook){
            $url = $webhook->webhook_url;
            $headers = [ 'Content-Type: application/json; charset=utf-8' ];
            $POST = [
                "embeds" => [
                    /*
                     * Our first embed
                     */
                    [
                        // Set the title for your embed
                        "title" => "THÔNG BÁO BẢO TRÌ HOÀN TẤT",

                        // The type of your embed, will ALWAYS be "rich"
                        "type" => "rich",

                        // A description for your embed
                        "description" => "Máy chủ đã được bảo trì hoàn tất, hãy vào bắn cháy máy ngay!",


                        // The integer color to be used on the left side of the embed
                        "color" => hexdec( "FFFFFF" ),

                        // Footer object
                        "footer" => [
                            "text" => "By GoGun.vn",
                            "icon_url" => "https://pbs.twimg.com/profile_images/972154872261853184/RnOg6UyU_400x400.jpg"
                        ],
                    ]
                ]
            ];

            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $url);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($POST));
            $response   = curl_exec($ch);
            curl_close( $ch );
        }
        if (!$this->app->isDownForMaintenance())
            return response()->json(['msg' => 'Server đã được mở rồi!'], 400);
        Artisan::call('up');
        return response()->json(['msg' => 'Đã mở lại server!']);
    }

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

    public function changeTank(Request $request)
    {
        $admin = $request->user('admin');
        $tank = $request->input('tankId');
        $isOk = Admin::where('id', $admin->id)->update(['current_tank' => $tank]);
        if($isOk)
            return response()->json(['msg' => "Đổi Tank thành công"]);
        return response()->json(['msg' => "Đổi Tank thất bại"], 400);
    }

    public function findQuest()
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;

    }

    public function findNPC(Request $request)
    {
        $q = $request->get('q');
        $npc = NPC::where('Name', 'like', "%$q%")->paginate();
        $npc->getCollection()->transform(function ($value) {
            return [
                'id' => $value->ID,
                'text' => '[ID: '.$value->ID.'] '.$value->Name,
            ];
        });

        return $npc;
    }

    public function findMissionInfo(Request $request)
    {
        $q = $request->get('q');
        $missionInfo = MissionInfo::where('Name', 'like', "%$q%")->paginate();
        $missionInfo->getCollection()->transform(function ($value) {
            return [
                'id' => $value->Id,
                'text' => '[ID: '.$value->Id.'] '.$value->Name,
            ];
        });

        return $missionInfo;
    }

    public function findMissionInfoViaDrop(Request $request)
    {
        //Use in |admin/drop-items| Drop Item
        $q = $request->get('q');
        $missionInfo = MissionInfo::where('Name', 'like', "%$q%")->paginate();
        $missions = [];
        foreach ($missionInfo as $mision){
            array_push($missions, ','.$mision->Id.',');
        }
        $dropCondictions = DropCondiction::query();
        foreach ($missions as $mission){
            $dropCondictions->orWhere('Para1', 'LIKE', '%'.$mission.'%');
        }

        $dropCondictions = $dropCondictions->distinct()->paginate();


        $dropCondictions->getCollection()->transform(function ($v){
            return [
                'id'=>$v->DropID,
                'text'=> $v->para];
        });

        return $dropCondictions;

//        dd();
//        $dropCondictions->getCollection()->transform(function ($value) {
//            return [
//                'id' => $value->DropID,
//                'text' => '[ID: '.$value->DropID.'] '.$value->para,
//            ];
//        });
    }

    public function getListMember(Request $request)
    {
        $q = $request->get('q');
        $member = Member::where('Email', 'like', "%$q%")->paginate();
        $member->getCollection()->transform(function ($value) {
            return [
                'id' => $value->UserID,
                'text' => $value->Email,
            ];
        });

        return $member;
    }
}
