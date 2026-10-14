<?php

namespace App\Http\Controllers\AjaxPublic;

use App\Http\Controllers\Controller;
//use Illuminate\Http\Request;
use App\Http\Requests\AjaxPublic\GetPublicRankRequest;
use App\PVPLogs;
use App\ServerList;
use App\Player;
use App\UserLogs;
use Illuminate\Support\Facades\DB;

class RankedController extends Controller
{
    /**
     * @param GetPublicRankRequest $request
     * $request->type => 1 (FirePower) | => 2 (Grade [aka Level]) | => 3 (Win)
     */
    public function getPublicRanked(GetPublicRankRequest $request)
    {
//        $type = $request->input('type') == 1 ? 'FightPower' : 'Grade';
        $typeInput = $request->input('type');
        switch ($typeInput){
            case 1:
                $type = 'FightPower';
                break;
            case 2:
                $type = 'Grade';
                break;
            case 3:
                $type = 'OnlineTime';
                break;
            case 4:
                $type = 'charmGP';
                break;
            case 5:
                return $this->TieuXuRanking($request);
            case 6:
            case 7:
            case 8:
                return $this->phobanRanking($request);
            case 9:
                return $this->tudo11Ranking($request);
        }
        $serverId = $request->input('server_id');

        $server = ServerList::find($serverId);
        if(!$server)
            return response()->json(['data' => 'Server Not found']);

        $serverConnection = $server->Connection;

        $player = new Player;
        $player->setConnection($serverConnection);

        $ranked = Player::on($serverConnection)
            ->select('NickName', $type)
            ->orderBy($type, 'desc')
            ->take(10)
            ->get();
        return response()->json($ranked);
    }

    public function TieuXuRanking(GetPublicRankRequest $request)
    {
        $serverId = $request->input('server_id');

        $server = ServerList::find($serverId);
        if(!$server)
            return response()->json(['data' => 'Server Not found']);

        $serverConnection = $server->Connection;

        $historiesBuyItem = UserLogs::on($serverConnection)->where('Type', 'BuyShop')
            ->where('TimeCreate', '>=', '2023-05-22 17:00:00.000')
            ->get();
        $topTieuXu = [];
        foreach ($historiesBuyItem as $item) {
            if (empty($topTieuXu[$item->UserID])) {
                $topTieuXu[$item->UserID] = [
                    'UserID' => $item->UserID,
                    'Amount' => 0
                ];
            }
            $topTieuXu[$item->UserID]['Amount'] += intval($item->Content);
        }
        uasort($topTieuXu, function ($a, $b) {
            return $a['Amount'] > $b['Amount'] ? -1 : 1;
        });
        $topTieuXu = array_slice($topTieuXu, 0, 10);
        $topTieuXu2 = [];
        foreach ($topTieuXu as $top) {
            if (!empty($topTieuXu2[$top['UserID']])) {
                $topTieuXu2[$top['UserID']]['Amount'] += $top['Amount'];
                continue;
            }
            $player = Player::on($serverConnection)->select('NickName')->where('UserID', $top['UserID'])->first();
            $item = [
                'NickName' => $player->NickName,
                'Amount' => $top['Amount']
            ];
            $topTieuXu2[$top['UserID']] = $item;
        }
        $topTieuXu2 = array_values($topTieuXu2);
        return response()->json($topTieuXu2);
    }

    public function phobanRanking(GetPublicRankRequest $request)
    {
        $serverId = $request->input('server_id');

        $server = ServerList::find($serverId);
        if(!$server)
            return response()->json(['data' => 'Server Not found']);

        $serverConnection = $server->Connection;
        $mission = 0;
        $typeInput = $request->input('type');
        switch($typeInput) {
            case 6:
                $mission = 1375; //gah
            break;
            case 7:
                $mission = 3106; //bltt t
                break;
            case 8:
                $mission = 4103; //pdha t
            break;
        }
        $histories = UserLogs::on($serverConnection)
            ->where('Type', 'WinMission')
            ->where('Content', $mission)
            ->where('TimeCreate', '>=', '2023-05-23 17:30:00.000')
            ->get();
        $topTieuXu = [];
        foreach ($histories as $item) {
            if (empty($topTieuXu[$item->UserID])) {
                $topTieuXu[$item->UserID] = [
                    'UserID' => $item->UserID,
                    'Amount' => 0
                ];
            }
            $topTieuXu[$item->UserID]['Amount']++;
        }
        uasort($topTieuXu, function ($a, $b) {
            return $a['Amount'] > $b['Amount'] ? -1 : 1;
        });
        $topTieuXu = array_slice($topTieuXu, 0, 10);
        $topTieuXu2 = [];
        foreach ($topTieuXu as $top) {
            if (!empty($topTieuXu2[$top['UserID']])) {
                $topTieuXu2[$top['UserID']]['Amount'] += $top['Amount'];
                continue;
            }
            $player = Player::on($serverConnection)->select('NickName')->where('UserID', $top['UserID'])->first();
            $item = [
                'NickName' => $player->NickName,
                'Amount' => $top['Amount']
            ];
            $topTieuXu2[$top['UserID']] = $item;
        }
        $topTieuXu2 = array_values($topTieuXu2);
        return response()->json($topTieuXu2);
    }

    public function tudo11Ranking(GetPublicRankRequest $request)
    {
        $serverId = $request->input('server_id');

        $server = ServerList::find($serverId);
        if(!$server)
            return response()->json(['data' => 'Server Not found']);

        $serverConnection = $server->Connection;

        $pvps = PVPLogs::on($serverConnection)->get();
        $topPvp = [];
        foreach ($pvps as $item) {
            if (empty($topPvp[$item->UserID])) {
                $player = Player::on($serverConnection)->select('NickName')->where('UserID', $item->UserID)->first();
                $topPvp[$item->UserID] = [
                    'NickName' => $player->NickName,
                    'Count' => 0
                ];
            }
            $topPvp[$item->UserID]['Count'] += intval($item->Count);
        }
        uasort($topPvp, function ($a, $b) {
            return $a['Count'] > $b['Count'] ? -1 : 1;
        });
        $topPvp = array_slice($topPvp, 0, 10);
        return response()->json(array_values($topPvp));
    }
}
