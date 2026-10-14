<?php

namespace App\Admin\Actions\QuestCondiction;

use App\QuestCondiction;
use App\ShopGoodsShowList;
use Encore\Admin\Actions\RowAction;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class DeleteQuestCondictionAction extends RowAction
{
    public $name = 'Xoá';

    public function dialog()
    {
        $this->confirm('Bạn có chắc xoá nhiệm vụ này ra khỏi mục không?');
    }

    public function handle(Model $model)
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $questID = (int) $this->row->QuestID;
        $condictionTitle = $this->row->CondictionTitle;
        $condictionId = (int) $this->row->CondictionID;

        $questCondiction = QuestCondiction::on($currentTank)
            ->where('QuestID',$questID)
            ->where('CondictionTitle', $condictionTitle)
            ->where('CondictionID', $condictionId)
            ->first();

        if($questCondiction->delete()){
            return $this->response()->success('Xoá điều kiện ra nhiệm vụ thành công.')->refresh();
        }
        return $this->response()->error('Xoá điều kiện ra nhiệm vụ thất bại')->refresh();

    }

}
