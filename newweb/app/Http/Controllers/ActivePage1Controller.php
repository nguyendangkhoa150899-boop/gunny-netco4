<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Player;
use App\Member;
use App\Models\TopRacing;
use App\Models\TopRacingAward;
use App\Models\TopRacingEvent;
use Illuminate\Support\Facades\Cache;

class ActivePage1Controller extends Controller
{
    const CACHE_REMEMBER_SECONDS = 3600; //1 hour

    public function index()
    {
        $member = new \App\Member();
        if ($member->isLoggedIn()) {
            return redirect('/');
        }
        return view('activepage1', [

        ]);
    }

}
