<?php


namespace App\Http\Controllers\Admin\Api;


use App\Models\Player;
use App\Models\PveInfo;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class PveInfoController extends Controller
{
    public function index(Request $request)
    {
        $search_term = $request->input('q');
        $page = $request->input('page');

        if ($search_term)
        {
            $collection = PveInfo::select('ID', 'Name')
                ->where('Name', 'LIKE', '%'.$search_term.'%')
                ->paginate(10);
        }
        else
        {
            $collection = Player::select('ID', 'Name')->paginate(10);
        }

        return $collection;
    }

    public function hardLevel(Request $request)
    {
        $pveid = $request->input('pveid');
        $data = [];
        if (empty($pveid)) {
            return json_encode([
                'data' => $data
            ]);
        }
        $pveinfo = PveInfo::find($pveid);
        if (!empty($pveinfo)) {
            if (!empty($pveinfo->SimpleGameScript)) {
                $data[] = [
                    'ID' => 1,
                    'Name' => 'Dễ'
                ];
            }
            if (!empty($pveinfo->NormalGameScript)) {
                $data[] = [
                    'ID' => 2,
                    'Name' => 'Thường'
                ];
            }
            if (!empty($pveinfo->HardGameScript)) {
                $data[] = [
                    'ID' => 3,
                    'Name' => 'Khó'
                ];
            }
            if (!empty($pveinfo->TerrorGameScript)) {
                $data[] = [
                    'ID' => 4,
                    'Name' => 'Anh hùng'
                ];
            }
        }
        return json_encode([
            'data' => $data
        ]);
    }

    public function stage(Request $request)
    {
        $pveid = $request->input('pveid');
        $hardLevel = $request->input('hardLevel');
        $data = [];
        if (empty($pveid) || empty($hardLevel)) {
            return json_encode([
                'data' => $data
            ]);
        }
        $pveinfo = PveInfo::find($pveid);
        if (!empty($pveinfo)) {
            $missions = [];
            switch ($hardLevel) {
                case 1: $missions = $pveinfo->SimpleMissions(); break;
                case 2: $missions = $pveinfo->NormalMissions(); break;
                case 3: $missions = $pveinfo->HardMissions(); break;
                case 4: $missions = $pveinfo->TerrorMissions(); break;
            }
            if (!empty($missions)) {
                $data = $missions;
            }
        }
        return [
            'data' => $data
        ];
    }
}
