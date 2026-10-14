<?php


namespace App\Http\Controllers\Admin\Widgets;


use Illuminate\Routing\Controller as BaseController;

class OnlineUsersNowController extends BaseController
{
    public function __construct()
    {
        $this->index();
    }

    public function index()
    {
        $now_online = 200;
        $highest = 300;
        return view('backpack::base.widgets.onlinenow', ['now_online' => $now_online, 'highest' => $highest]);
    }
}
