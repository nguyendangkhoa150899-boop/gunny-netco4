<?php

namespace App\Admin\Actions\Attractive;

use App\EventRewardGoods;
use App\EventRewardInfo;
use App\QuestCondiction;
use App\QuestGoods;
use App\ShopGoodsShowList;
use Encore\Admin\Actions\RowAction;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class DeleteAttractiveAwardAction extends RowAction
{
    public $name = 'Xoá';

    public function dialog()
    {
        $this->confirm('Bạn có chắc muốn xoá phần thưởng này không?');
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
            ->where('ActivityType','=', $this->row->ActivityType)
            ->where('SubActivityType','=', $this->row->SubActivityType)
            ->where('TemplateID','=', $this->row->TemplateId)->delete();

        if($isDeleted){
            return $this->response()->success('Xoá phần thưởng thành công.')->refresh();
        }
        return $this->response()->error('Xoá phần thưởng thất bại')->refresh();
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

        //Params[0] -> ActivityType
        //Params[1] -> SubActivityType
        //Params[2] -> TemplateId

        $currentTank = Auth::guard('admin')->user()->current_tank;

        return EventRewardGoods::on($currentTank)
            ->where('ActivityType','=',$params[0])
            ->where('SubActivityType','=', $params[1])
            ->where('TemplateId','=', $params[2])->firstOrFail();
    }

}
