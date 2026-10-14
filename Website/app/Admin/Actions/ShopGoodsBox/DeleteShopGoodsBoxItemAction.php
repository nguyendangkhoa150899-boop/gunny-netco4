<?php

namespace App\Admin\Actions\ShopGoodsBox;

use App\QuestCondiction;
use App\ShopGoodsBox;
use App\ShopGoodsShowList;
use Encore\Admin\Actions\RowAction;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class DeleteShopGoodsBoxItemAction extends RowAction
{
    public $name = 'Xoá';

    public function dialog()
    {
        $this->confirm('Bạn có chắc xoá vật phẩm ra khỏi rương không?');
    }

    /*
     * MUST OVERRIDE PRIMARY KEY
     */
    protected function getKey()
    {
        return $this->row->fake;
    }

    public function handle(Model $model)
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $isDeleted = DB::connection($currentTank)->table($this->row->getTable())
            ->where('ID', $this->row->ID)
            ->where('TemplateId', $this->row->TemplateId)
            ->delete();
        if($isDeleted){
            return $this->response()->success('Xoá vật phẩm ra khỏi rương thành công.')->refresh();
        }
        return $this->response()->error('Xoá vật phẩm ra khỏi rương thất bại')->refresh();

    }

    /*
 * MUST OVERRIDE GET MODEL
 */
    public function retrieveModel(Request $request)
    {
        if (!$key = $request->get('_key')) {
            return false;
        }

        $params = explode('-',$key);

        //Params[0] -> ID
        //Params[1] -> TemplateId

        $currentTank = Auth::guard('admin')->user()->current_tank;

        return ShopGoodsBox::on($currentTank)
            ->where('ID','=',$params[0])
            ->where('TemplateId','=', $params[1])
            ->firstOrFail();
    }

}
