<?php

namespace App\Admin\Actions\ShopGoodsShowList;

use Encore\Admin\Actions\RowAction;
use Illuminate\Http\Request;

class EditShopGoodsShowListAction extends RowAction
{
    public $name = "Chỉnh sửa";
    protected $selector = '.edit-shop-goods-show-list-action';

    public function handle(Request $request)
    {
        // $request ...

        return $this->response()->success('Success message...')->refresh();
    }

    public function href()
    {
        return 'showlist/edit/?active_id='. $this->getKey();
    }

    public function html()
    {
        return <<<HTML
        <a class="btn btn-sm btn-default edit-shop-goods-show-list-action"></a>
HTML;
    }
}
