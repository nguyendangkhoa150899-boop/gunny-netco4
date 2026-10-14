<?php

namespace App\Admin\Actions\QuestGoods;

use App\QuestGoods;
use Encore\Admin\Actions\RowAction;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class DeleteQuestGoodsAction extends RowAction
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

        $isDeleted = QuestGoods::on($currentTank)
            ->where('QuestID','=',$this->row->QuestID)
            ->where('RewardItemID','=', $this->row->RewardItemID)
            ->delete();
        if($isDeleted){
            return $this->response()->success('Xoá vật phẩm thành công.')->refresh();
        }
        return $this->response()->error('Xoá vật phẩm thất bại')->refresh();

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

        //Params[0] -> QuestID
        //Params[1] -> RewardItemID

        $currentTank = Auth::guard('admin')->user()->current_tank;

        return QuestGoods::on($currentTank)
            ->where('QuestID','=',$params[0])
            ->where('RewardItemID','=', $params[1])
            ->firstOrFail();
    }

}
