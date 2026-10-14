<?php

namespace App\Http\Controllers\Client;

use App\Config;
use App\Http\Controllers\Controller;
use App\Player;
use App\ServerList;
use App\Slide;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\View;

class HomeController extends Controller
{
    public function showIndex(Request $request)
    {
        $slides = cache()->remember('slides', 60*160*24, function (){
            return Slide::all();
        });
        return view('client.index', compact('slides'));
    }

    public function showTmpTransferAccount()
    {
        return view('client.tmp-transfer-account');
    }

    public function showGameGuide($id)
    {
        if($id == 1 )
            return view('client.game_guide.1');
        else if($id == 2)
            return view('client.game_guide.2');
    }
}
