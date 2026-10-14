<?php


namespace App\Http\Controllers\Admin\Api;


use App\Models\Player;
use App\Models\PveInfo;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class DropEmulatorController extends Controller
{
    public function index(Request $request)
    {
        $pveid = $request->input('pveid');
        $hardLevel = $request->input('hardLevel');
        $stage = $request->input('stage');
        $opentimes = $request->input('opentimes');

        if (empty($pveid) || empty($hardLevel) || empty($stage) || empty($opentimes)) {
            return [];
        }
        $pveinfo = PveInfo::find($pveid);
        $gameScript = 'SimpleGameScript';
        if ($hardLevel == 2) {
            $gameScript = 'NormalGameScript';
        } elseif ($hardLevel == 3) {
            $gameScript = 'HardGameScript';
        } elseif ($hardLevel == 4) {
            $gameScript = 'TerrorGameScript';
        }
        $script = $pveinfo[$gameScript];
        $missions = $pveinfo->getPveMissions($script);
        foreach ($missions as $m) {
            if ($m->Id == $stage) {
                $mission = $m;
                break;
            }
        }
        $condictions = $mission->Condictions();
        $condiction = null;
        foreach ($condictions as $c) {
            if ($c->Para2 == ',1,' || $c->Para2 == ',1,2,') {
                $condiction = $c;
                break;
            }
        }
        if (!empty($condiction)) {
            $dropItems = $condiction->DropItems;
            $maxRand = 0;
            foreach ($dropItems as $item) {
                if ($maxRand < $item->Random) {
                    $maxRand = $item->Random;
                }
            }
            $resultItems = [];
            for ($i = 0; $i < $opentimes; $i++) {
                $item = $this->randomItem($maxRand, $dropItems);
                if (empty($resultItems[$item->ItemId])) {
                    $goods = $item->toArray();
                    unset($goods['item']);
                    $goods['ItemName'] = $item->Item->Name;
                    $goods['ResourceImage'] = $item->ResourceImageColumn();
                    $resultItems[$item->ItemId] = [
                        'item' => $goods,
                        'tong' => 0
                    ];
                }
                $resultItems[$item->ItemId]['tong']++;
            }
            foreach ($resultItems as $i => $rs) {
                $resultItems[$i]['percent'] = round($rs['tong']/$opentimes, 5) * 100 . '%';
            }
            return array_values($resultItems);
        }

        return [];
    }

    /**
     * @param $maxRand
     * @param $items
     * @return \App\Models\PveInfoDropItem
     */
    private function randomItem($maxRand, $items)
    {
        $random = mt_rand(1, $maxRand);
        $randomItems = [];
        foreach ($items as $item) {
            if ($item->Random >= $random) {
                $randomItems[] = $item;
            }
        }
        $random2 = mt_rand(0, count($randomItems)-1);
        return $randomItems[$random2];
    }
}
