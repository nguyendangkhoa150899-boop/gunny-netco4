<?php

namespace App\Admin\Extensions\Tools;

use App\ServerList;
use Encore\Admin\Admin;
use Encore\Admin\Grid\Tools\AbstractTool;
use Illuminate\Support\Facades\Request;

class SelectServerTools extends AbstractTool
{
    protected function script()
    {
        $url = Request::fullUrlWithQuery(['server' => '_sqlsrv_tank41_']);
        return <<<EOT

$('.select-server').on('change', function() {
    var url = "$url".replace('_sqlsrv_tank41_', $(this).val());
    $.pjax({container:'#pjax-container', url: url });

});

EOT;
    }

    public function render()
    {
        Admin::script($this->script());
        $serverList = ServerList::all();
        $currentServer = Request::input('server');
        return view('admin.tools.select-server', compact('serverList', 'currentServer'));
    }
}
