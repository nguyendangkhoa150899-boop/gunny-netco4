<?php

namespace App\Http\Controllers\Client;

use App\CategoryEventCompete;
use App\EventAwardCompete;
use App\EventCompete;
use App\EventTypeCompete;
use App\Http\Controllers\Controller;
use App\Player;
use App\ServerList;
use Illuminate\Http\Request;

class CompeteEventController extends Controller
{
    public function showComepeteById($id)
    {
        $eventCompeteCategory = CategoryEventCompete::with(['EventCompete' => function ($q) {
            $q->with('EventType');
        }])->findOrFail($id);
        $description = $eventCompeteCategory->description;
        $serverId = $eventCompeteCategory->server_id;
        $types = [];
        $awards = [];
        $typesDB = $eventCompeteCategory->EventCompete;

        for ($i = 0; $i < sizeof($typesDB); $i++) {
            $awards[$i] = EventAwardCompete::with(['EventCompete'])->where('event_compete_id', $typesDB[$i]->id)->get();
            $types[$i] = $typesDB[$i]->EventType->type_name;
        }

        /*
         * GET AWARD FOR EACH TOP
         */
        $awardsFightPower = [];
        $awardsWin = [];
        $awardsLevel = [];
        $awardsOnline = [];

//        id	type_name
//        2	Top Lực chiến
//        3	Top Win
//        4	Top Level
//        5	Top Online
//        dd($awards);

        foreach ($awards as $key => $award){
            foreach ($award as $keyItem => $item){
                $typeId = (int) $item->EventCompete->event_type_id;
                if($typeId == 2){ //Top Lực chiến
                    $date = $item->date == 0 ? ' (Vĩnh Viễn)' : ' ('.$item->date. ' ngày)';
                    $strengthen = $item->strengthen == 0 ? ' ' : ' (Cường hoá +'.$item->strengthen.')';
                    $composes = $item->composes == 0 ? ' ' : ' (Chỉ số: '.$item->composes.')';
                    $text = $item->Item->Name.' x'.$item->amount. $strengthen . $composes . $date;

                    $awardsFightPower[$keyItem]['rank'] = $item->rank;
                    $awardsFightPower[$keyItem]['item'] = $item->Item->ResourceImageColumnForCompete($item['id']) .'<span class="hint-text" style="flex: 1;"> '.$text.'</span>';
                }
                if($typeId == 3) { //Top Win
                    $date = $item->date == 0 ? ' (Vĩnh Viễn)' : ' ('.$item->date. ' ngày)';
                    $strengthen = $item->strengthen == 0 ? ' ' : ' (Cường hoá +'.$item->strengthen.')';
                    $composes = $item->composes == 0 ? ' ' : ' (Chỉ số: '.$item->composes.')';
                    $text = $item->Item->Name.' x'.$item->amount. $strengthen . $composes . $date;

                    $awardsWin[$keyItem]['item'] = $item->Item->ResourceImageColumnForCompete($item['id']) .'<span class="hint-text" style="flex: 1;"> '.$text.'</span>';
                    $awardsWin[$keyItem]['rank'] = $item->rank;
                }
                if($typeId == 4) { //Top Level
                    $date = $item->date == 0 ? ' (Vĩnh Viễn)' : ' ('.$item->date. ' ngày)';
                    $strengthen = $item->strengthen == 0 ? ' ' : ' (Cường hoá +'.$item->strengthen.')';
                    $composes = $item->composes == 0 ? ' ' : ' (Chỉ số: '.$item->composes.')';
                    $text = $item->Item->Name.' x'.$item->amount. $strengthen . $composes . $date;

                    $awardsLevel[$keyItem]['rank'] = $item->rank;
                    $awardsLevel[$keyItem]['item'] = $item->Item->ResourceImageColumnForCompete($item['id']) .'<span class="hint-text" style="flex: 1;"> '.$text.'</span>';
                }
                if($typeId == 5) { //Top Online
                    $date = $item->date == 0 ? ' (Vĩnh Viễn)' : ' ('.$item->date. ' ngày)';
                    $strengthen = $item->strengthen == 0 ? ' ' : ' (Cường hoá +'.$item->strengthen.')';
                    $composes = $item->composes == 0 ? ' ' : ' (Chỉ số: '.$item->composes.')';
                    $text = $item->Item->Name.' x'.$item->amount. $strengthen . $composes . $date;

                    $awardsOnline[$keyItem]['rank'] = $item->rank;
                    $awardsOnline[$keyItem]['item'] = $item->Item->ResourceImageColumnForCompete($item['id']) .'<span class="hint-text" style="flex: 1;"> '.$text.'</span>';
                }

            }
        }

//        dd($awardsWin);

        /*
         * GET EACH KIND OF TOP
         */
        $serverList = ServerList::all();

        $topFightPowerPlayers = [];
        $topLevelPlayers = [];
        $topWinPlayers = [];
        $topOnlinePlayers = [];

        foreach ($serverList as $server)
        {
            if($server->ServerID == $serverId){
                $topFightPowerPlayers[$server->ServerID] = Player::on($server->Connection)
                    ->select('NickName', 'FightPower')
                    ->orderBy('FightPower', 'desc')
                    ->take(10)
                    ->get();
                $topLevelPlayers[$server->ServerID] = Player::on($server->Connection)
                    ->select('NickName', 'Grade')
                    ->orderBy('Grade', 'desc')
                    ->take(10)
                    ->get();
                $topWinPlayers[$server->ServerID] = Player::on($server->Connection)
                    ->select('NickName', 'Win')
                    ->orderBy('Win', 'desc')
                    ->take(10)
                    ->get();
                $topOnlinePlayers[$server->ServerID] = Player::on($server->Connection)
                    ->select('NickName', 'OnlineTime')
                    ->orderBy('OnlineTime', 'desc')
                    ->take(10)
                    ->get();
            }
        }

//        dd($awardsFightPower);

        //Return
        $compete = [
            'competeCategory' => $eventCompeteCategory,
            'description' => $description,
            'types' => $types,
            'server_id' => $serverId,
            'top_fightpower' => $topFightPowerPlayers,
            'top_level' => $topLevelPlayers,
            'top_win' => $topWinPlayers,
            'top_online' => $topOnlinePlayers,
            'awardFightPower' => $awardsFightPower,
            'awardWin' => $awardsWin,
            'awardLevel' => $awardsLevel,
            'awardOnline' => $awardsOnline,
        ];

        return view('client.compete-event.index', compact('compete'));
    }

    public function getCompeteEventInfo(Request $request)
    {
        $event = EventAwardCompete::with(['Item'])->findOrFail($request->input('id'));
        $date = $event->date == 0 ? ' (Vĩnh Viễn)' : ' ('.$event->date. ' ngày)';
        $strengthen = $event->strengthen == 0 ? ' ' : ' (Cường hoá +'.$event->strengthen.')';
        $composes = $event->composes == 0 ? ' ' : ' (Chỉ số: '.$event->composes.')';
        $text = $event->Item->Name.' x'.$event->amount. $strengthen . $composes . $date;
        return response()->json($text);
    }
}
