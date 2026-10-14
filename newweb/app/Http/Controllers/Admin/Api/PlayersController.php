<?php


namespace App\Http\Controllers\Admin\Api;


use App\Models\Player;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class PlayersController extends Controller
{
    public function index(Request $request)
    {
        $search_term = $request->input('q');
        $page = $request->input('page');
        $all = $request->input('all');

        if ($search_term)
        {
            $collection = Player::select('UserID', 'UserName', 'NickName')
                ->where('NickName', 'LIKE', '%'.$search_term.'%')
                ->orWhere('UserName', 'LIKE', '%'.$search_term.'%')
                ->paginate(10);
        }
        else
        {
            $collection = Player::select('UserID', 'UserName', 'NickName')->paginate(10);
        }
        if (!empty($all)) {
            $allPlayerItem = new Player();
            $allPlayerItem->UserID = -9;
            $allPlayerItem->UserName = 'No';
            $allPlayerItem->NickName = 'Gửi thư toàn server';
            $collection->push($allPlayerItem);
            $allOnlinePlayerItem = new Player();
            $allOnlinePlayerItem->UserID = -10;
            $allOnlinePlayerItem->UserName = 'No';
            $allOnlinePlayerItem->NickName = 'Gửi thư tất cả user đang online';
            $collection->push($allOnlinePlayerItem);
        }

        return $collection;
    }

    public function show($id)
    {
        return Player::select('UserID', 'UserName', 'NickName')->where('UserID', $id)->first();
    }
}
