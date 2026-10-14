<?php

namespace App\Admin\Extensions\Tools;

use Encore\Admin\Admin;
use Encore\Admin\Grid\Tools\AbstractTool;
use Illuminate\Support\Facades\Request;

class ClearSlideCacheTool extends AbstractTool
{
    protected function script()
    {
        $url = Request::fullUrlWithQuery(['gender' => '_gender_']);

        return <<<EOT

$('#clear-cache-config').on('click', function() {
    $.ajax({
        method: 'get',
        url: '/admin/api/clear-slide-cache',
        success: function () {
//            $.pjax.reload('#pjax-container');
            toastr.success('Xoá Cache Slide thành công');
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
