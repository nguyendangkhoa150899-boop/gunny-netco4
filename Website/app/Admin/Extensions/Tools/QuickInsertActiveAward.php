<?php

namespace App\Admin\Extensions\Tools;

use App\ServerList;
use App\ShopGoods;
use Encore\Admin\Admin;
use Encore\Admin\Grid\Tools\AbstractTool;
use Encore\Admin\Widgets\Form;
use Illuminate\Support\Facades\Request;

class QuickInsertActiveAward extends AbstractTool
{
    protected function script()
    {
        $url = Request::fullUrlWithQuery(['ActiveID' => '_ActiveID_']);
        return <<<EOT

$('.select-server').on('change', function() {
    var url = "$url".replace('_ActiveID_', $(this).val());
    $.pjax({container:'#pjax-container', url: url });

});

EOT;
    }

    public function render()
    {
        Admin::script($this->script());
        $currentActiveID = Request::input('ActiveID');
        $form = new Form();
        $form->number('Active', 'Mã Giftcode')->width('100%')->default($currentActiveID);
//        $form->number('ItemID_Modal', 'ItemID')->width('100%')->default(0);
        $form->select('ItemID_Modal', 'ItemID')
            ->options(function ($itemName){
                $shopGoods = ShopGoods::where('Name','like', '%'.$itemName.'%')->first();
                if($shopGoods)
                    return [$shopGoods->TemplateID => $shopGoods->Name];
                return 'haizz';
            })
            ->ajax('/admin/api/load-item')
            ->width('100%');
        $form->number('Count_Modal', 'Số lượng')->width('100%')->default(1);
        $form->number('ValidDate_Modal', 'ValidDate')->width('100%')->default(0);
        $form->number('StrengthenLevel_Modal', 'Cường hoá')->width('100%')->default(0);
        $form->number('AttackCompose_Modal', 'Tấn Công')->width('100%')->default(0);
        $form->number('DefendCompose_Modal', 'Phòng thủ')->width('100%')->default(0);
        $form->number('LuckCompose_Modal', 'May mắn')->width('100%')->default(0);
        $form->number('AgilityCompose_Modal', 'Nhanh nhẹn')->width('100%')->default(0);
        $form->number('Gold_Modal', 'Vàng')->width('100%')->default(0);
        $form->number('Money_Modal', 'Xu')->width('100%')->default(0);
        $form->number('Sex_Modal', 'Giới tính')->width('100%')->default(0);
        $form->number('Mark_Modal', 'Mark')->width('100%')->default(0);

        $form->disableReset()->disableSubmit();
        $form->render();
        return view('admin.tools.model-insert-active-award', compact('form'));
    }
}
