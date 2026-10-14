<?php

namespace App\Admin\Actions\ShopGoodsShowList;

use App\ShopGoodsShowList;
use Encore\Admin\Actions\RowAction;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;

class DeleteShopGoodsShowListItemAction extends RowAction
{
    public $name = 'Xoá';

    protected function getKey()
    {
        return $this->row->getKey();
    }

    public function dialog()
    {
        $this->confirm('Bạn có chắc xoá vật phẩm này ra khỏi mục không?');
    }

    public function handle(Model $model, Request $request)
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;

        $type = $this->row->Type;
        $shopId = (int) $request->shopid;
        $shopGoodsShowList = ShopGoodsShowList::on($currentTank)->where('Type',$type)->where('ShopId', $shopId)->get();
        if(ShopGoodsShowList::on($currentTank)->where('Type',$type)->where('ShopId', $shopId)->delete()){
            return $this->response()->success('Xoá vật phẩm '.$shopId.' ra khỏi mục thành công.')->refresh();
        }
        return $this->response()->error('Xoá vật phẩm ra khỏi mục thất bại')->refresh();

    }

    public function render()
    {
        if ($href = $this->href()) {
            return "<a href='{$href}'>{$this->name()}</a>";
        }

        $this->addScript();

        $attributes = $this->formatAttributes();

        return sprintf(
            "<a data-_key='%s' data-shopId='%s' href='javascript:void(0);' class='%s' {$attributes}>%s</a>",
            $this->getKey(),
            $this->row->getAttribute('ShopId'),
            $this->getElementClass(),
            $this->asColumn ? $this->display($this->row($this->column->getName())) : $this->name()
        );
    }

}
