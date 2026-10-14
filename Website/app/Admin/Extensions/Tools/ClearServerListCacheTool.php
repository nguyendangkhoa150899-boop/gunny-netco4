<?php

namespace App\Admin\Extensions\Tools;

use Encore\Admin\Admin;
use Encore\Admin\Grid\Tools\AbstractTool;
use Illuminate\Support\Facades\Request;

class ClearServerListCacheTool extends AbstractTool
{
    protected function script()
    {
        $url = Request::fullUrlWithQuery(['gender' => '_gender_']);

        return <<<EOT

$('#clear-cache-config').on('click', function() {
    $.ajax({
        method: 'get',
        url: '/admin/api/clear-serverlist-cache',
        success: function () {
            toastr.success('Xoá Cache thành công');
        }
    });
});

EOT;
    }

    public function render()
    {
        Admin::script($this->script());

        return view('admin.tools.clear-cache');
    }
}
