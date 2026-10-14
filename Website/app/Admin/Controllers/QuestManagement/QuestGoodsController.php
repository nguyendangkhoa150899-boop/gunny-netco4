<?php

namespace App\Admin\Controllers\QuestManagement;

use App\Admin\Actions\QuestGoods\DeleteQuestGoodsAction;
use App\Admin\Extensions\Tools\CreateMultipleQuestGoods;
use App\Admin\Extensions\Tools\Quest\RedirectToCreateMultipleQuestGoods;
use App\Quest;
use App\QuestGoods;
use App\ShopGoods;
use Encore\Admin\Admin;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Layout\Content;
use Encore\Admin\Show;
use Encore\Admin\Widgets\Box;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Encore\Admin\Widgets\Form as FormWidget;
use Illuminate\Support\Facades\DB;

class QuestGoodsController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Phần thưởng nhiệm vụ';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;

        $quests = Quest::on($currentTank)->get();
        $questValues = [];
        foreach ($quests as $quest){ $questValues[$quest->ID] = $quest->Title; }
        $req = Request::capture();
        $questID = $req->input('QuestID');

        $questGoods = new QuestGoods();
        $questGoods->setConnection($currentTank);
        $questGoods->setPrimaryKey('fake');
        $grid = new Grid($questGoods);
//        $grid->setTitle('Danh sách phần thưởng nhiệm vụ (Lưu ý: Xoá 1 phần thưởng trong nhiệm vụ sẽ xoá tất cả phần thưởng trong nhiệm vụ đó)');
        $grid->model()->orderByDesc('QuestID');

        $grid->column('QuestID', __('QuestID'));
        $grid->column('Quest.Title','Nhiệm vụ');
        $grid->column('_ImageItem)', __('Hình ảnh'))->display(function (){
            return $this->ResourceImageColumn();
        });
        $grid->column('Item.Name', __('Phần thưởng'));
        $grid->column('IsSelect', __('IsSelect'));
        $grid->column('RewardItemValid', __('Hạn'));
        $grid->column('RewardItemCount', __('Số lượng'));
        $grid->column('StrengthenLevel', __('Cường hoá'));
        $grid->column('AttackCompose', __('Tấn công'));
        $grid->column('DefendCompose', __('Phòng thủ'));
        $grid->column('AgilityCompose', __('Nhanh nhẹn'));
        $grid->column('LuckCompose', __('May mắn'));
        $grid->column('IsCount', __('IsCount'));
        $canRepeat =  [
            'on' => ['value' => 1, 'text' => 'Khoá', 'color' => 'danger'],
            'off' => ['value' => 0, 'text' => 'Không khoá', 'color' => 'success'],
        ];
        $grid->column('IsBind', __('Khoá'))->switch($canRepeat);
        $grid->expandFilter();
        $grid->filter(function ($filter) use ($questValues){
            $filter->disableIdFilter();
            $filter->equal('QuestID','Tìm kiếm nhiệm vụ')->select($questValues);
        });

        $grid->quickCreate(function ($create) use ($questID, $questValues, $currentTank){
            $create->select('QuestID')->options($questValues)->value($questID);
            $create->select('RewardItemID', 'Chọn vật phẩm')->ajax('/admin/api/load-item');
            $create->integer('IsSelect');
            $create->integer('RewardItemValid','Hạn');
            $create->integer('RewardItemCount','Số lượng');
            $create->integer('StrengthenLevel')->value(0)->style('display','none');
            $create->integer('AttackCompose')->value(0)->style('display','none');
            $create->integer('DefendCompose')->value(0)->style('display','none');
            $create->integer('AgilityCompose')->value(0)->style('display','none');
            $create->integer('LuckCompose')->value(0)->style('display','none');
            $create->integer('IsCount')->value(1)->style('display','none');
            $create->integer('IsBind')->value(1)->style('display','none');
        });

        $grid->disableBatchActions();

        $grid->actions(function ($actions){
            $actions->disableDelete();
            $actions->disableEdit();
            $actions->disableView();
            $actions->add(new DeleteQuestGoodsAction());
        });

        $grid->tools(function ($tools) {
            $tools->append(new RedirectToCreateMultipleQuestGoods());
        });

        return $grid;
    }

    /**
     * Make a show builder.
     *
     * @param mixed $id
     * @return Show
     */
    protected function detail($id)
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $show = new Show(QuestGoods::on($currentTank)->findOrFail($id));

        $show->field('QuestID', __('QuestID'));
        $show->field('RewardItemID', __('RewardItemID'));
        $show->field('IsSelect', __('IsSelect'));
        $show->field('RewardItemValid', __('RewardItemValid'));
        $show->field('RewardItemCount', __('RewardItemCount'));
        $show->field('StrengthenLevel', __('StrengthenLevel'));
        $show->field('AttackCompose', __('AttackCompose'));
        $show->field('DefendCompose', __('DefendCompose'));
        $show->field('AgilityCompose', __('AgilityCompose'));
        $show->field('LuckCompose', __('LuckCompose'));
        $show->field('IsCount', __('IsCount'));
        $show->field('IsBind', __('IsBind'));

        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;

        $quests = Quest::on($currentTank)->get();
        $questValues = [];
        foreach ($quests as $quest){ $questValues[$quest->ID] = $quest->Title; }

        $questGoods = new QuestGoods();
        $questGoods->setConnection($currentTank);

        $form = new Form($questGoods);

        $form->select('QuestID','Chọn nhiệm vụ')->options($questValues);
        $form->select('RewardItemID', 'Chọn vật phẩm')->options(function ($templateID) use($currentTank){
            $shopGoods = ShopGoods::on($currentTank)->find($templateID);
            if($shopGoods){
                return [$shopGoods->TemplateID => $shopGoods->Name];
            }
        })->ajax('/admin/api/load-item');
        $form->switch('IsSelect', __('IsSelect'))->default(0);
        $form->number('RewardItemValid', __('RewardItemValid'))->width('100%')->default(0);
        $form->number('RewardItemCount', 'Số lượng')->width('100%')->default(1);
        $form->number('StrengthenLevel', 'Cường hoá')->width('100%')->default(0);
        $form->number('AttackCompose', 'Chỉ số hợp thành tấn công')->width('100%')->default(0);
        $form->number('DefendCompose', 'Chỉ số hợp thành phòng thủ')->width('100%')->default(0);
        $form->number('AgilityCompose', 'Chỉ số hợp thành nhanh nhẹn')->width('100%')->default(0);
        $form->number('LuckCompose', 'Chỉ số hợp thành may mắn')->width('100%')->default(0);
        $form->switch('IsCount', __('IsCount'))->default(1);
        $form->switch('IsBind', __('Khoá'))->default(1);

        return $form;
    }

    public function showCreateMultipleQuestGoodsForm(Content $content, Request $request)
    {
        $content->title('Cập nhật phần thưởng cho nhiệm vụ');
        $questId = (int) $request->input('questId');

        $form = new FormWidget();
        $quests = Quest::all();
        $questValues = [];

        foreach ($quests as $quest){ $questValues[$quest->ID] = '[ID: '.$questId.'] - '.$quest->Title; }

        if ($questId > 0){
            $form->select('QuestID','Chọn nhiệm vụ')->options($questValues)->value($questId)->default($questId)->readonly()->disable();
        }
        else
            $form->select('QuestID','Chọn nhiệm vụ')->options($questValues);

        $form->table('items', '', function ($form) {

            $form->select('RewardItemID', 'Chọn vật phẩm')->options(function ($templateID) {
                $shopGoods = ShopGoods::find($templateID);
                if($shopGoods){
                    return [$shopGoods->TemplateID => $shopGoods->Name];
                }
            })->ajax('/admin/api/load-item')->required();
            $form->text('IsSelect', __('IsSelect'))->withoutIcon()->default(0);;
            $form->text('RewardItemValid', __('Hạn'))->width('100%')->default(0)->withoutIcon();
            $form->text('RewardItemCount', 'Số lượng')->withoutIcon()->default(1);
            $form->text('StrengthenLevel', 'Cường hoá')->withoutIcon()->default(0);
            $form->text('AttackCompose', 'Tấn công')->withoutIcon()->default(0);
            $form->text('DefendCompose', 'Phòng thủ')->withoutIcon()->default(0);
            $form->text('AgilityCompose', 'Nhanh nhẹn')->withoutIcon()->default(0);
            $form->text('LuckCompose', 'May mắn')->withoutIcon()->default(0);
            $form->hidden('IsCount', __('IsCount'))->default(1);
            $form->hidden('IsBind', __('Khoá'))->default(1);
        })->setWidth(12);;

        Admin::style('#has-many-items {overflow-x: auto;width: 100%;}');


        $content->body(new Box('Chọn nhiều phần thưởng', $form));

        return $content;
    }


    public function createMultipleQuestGoods(Request $request)
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $questId = $request->input('questId'); //MUST BE questId NOT QuestID
        $items = $request->input('items');
        $itemKeys = array_keys($items);		// return array
        $payload = [];

        if(sizeof($items) == 1){
            QuestGoods::create([
                'QuestID' => $questId,
                'RewardItemID' => $items[$itemKeys[0]]['RewardItemID'],
                'RewardItemValid' => $items[$itemKeys[0]]['RewardItemValid'],
                'RewardItemCount' => $items[$itemKeys[0]]['RewardItemCount'],
                'StrengthenLevel' => $items[$itemKeys[0]]['StrengthenLevel'],
                'AttackCompose' => $items[$itemKeys[0]]['AttackCompose'],
                'DefendCompose' => $items[$itemKeys[0]]['DefendCompose'],
                'AgilityCompose' => $items[$itemKeys[0]]['AgilityCompose'],
                'LuckCompose' => $items[$itemKeys[0]]['LuckCompose'],
                'IsCount' => $items[$itemKeys[0]]['IsCount'],
                'IsBind' => $items[$itemKeys[0]]['IsBind'],
                'IsSelect' => $items[$itemKeys[0]]['IsSelect'],
            ]);
            admin_toastr(__('Thêm phần thưởng thành công'));
            return redirect('/admin/quests');
        }

        for($i = 0; $i < sizeof($items); $i++){
            array_push($payload, [
                'QuestID' => $questId,
                'RewardItemID' => $items[$itemKeys[$i]]['RewardItemID'],
                'RewardItemValid' => $items[$itemKeys[$i]]['RewardItemValid'],
                'RewardItemCount' => $items[$itemKeys[$i]]['RewardItemCount'],
                'StrengthenLevel' => $items[$itemKeys[$i]]['StrengthenLevel'],
                'AttackCompose' => $items[$itemKeys[$i]]['AttackCompose'],
                'DefendCompose' => $items[$itemKeys[$i]]['DefendCompose'],
                'AgilityCompose' => $items[$itemKeys[$i]]['AgilityCompose'],
                'LuckCompose' => $items[$itemKeys[$i]]['LuckCompose'],
                'IsCount' => $items[$itemKeys[$i]]['IsCount'],
                'IsBind' => $items[$itemKeys[$i]]['IsBind'],
                'IsSelect' => $items[$itemKeys[$i]]['IsSelect'],
            ]);
        }
        DB::connection($currentTank)->table('Quest_Goods')->insert($payload);
        admin_toastr(__('Thêm điều kiện nhiệm vụ thành công'));
        return redirect('/admin/quests');
    }
}
