<?php

namespace App\Admin\Controllers\QuestManagement;

use App\Admin\Actions\QuestCondiction\DeleteQuestCondictionAction;
use App\Admin\Extensions\Tools\Quest\RedirectToCreateMultipleQuestCondiction;
use App\Quest;
use App\QuestCondiction;
use Encore\Admin\Admin;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Form\NestedForm;
use Encore\Admin\Grid;
use Encore\Admin\Layout\Content;
use Encore\Admin\Show;
use Encore\Admin\Widgets\Box;
use Encore\Admin\Widgets\Form as FormWidget;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class QuestCondictionController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Điều kiện hoàn thành nhiệm vụ';

    private $condictionType = [
        102 => 'Tắm suôi nước nóng {x} phút',
        100 => 'Trực tuyến game {x} phút',
        1 => 'Đăng nhập game (1)',
        16 => 'Đăng nhập game (16)',
        3 => 'Sử dụng vật phẩm bất kì',
        4 => 'Trong chiến đấu đánh bại {x} người',
        5 => 'Hoàn thành {x} trận chiến đấu',
        6 => 'Chiến thắng {x} trận chiến đấu',
        9 => 'Cường hoá vật phẩm {x} lên cấp {y}',
        10 => 'Tiêu phí shop',
        11 => 'Dung luyện vật phẩm {x}',
        13 => 'Đích thân hạ NPC {x}',
        15 => 'Thu thập vật phẩm {x}',
        17 => 'Kết hôn',
        18 => 'Guild đạt {x} người, gia nhập G, rèn-két-shop đạt cấp {y}',
        19 => 'dùng đá {x} để hợp thành thành công',
        20 => 'vào đấu giá, phòng tập,phòng cao thủ, kết bạn , tăng số lượng bạn bè',
        21 => 'Vượt ải {x}',
        22 => 'Tiêu diệt {x} người trong G chiến',
        23 => 'Hoàn thành {x} trận G chiến',
        24 => 'Chiến thắng {x} trận G chiến',
        25 => 'Khảm nạn châu báu bất kì',
        26 => 'Hoàn thành {x} trận vợ chồng',
        27 => 'Vào suối nước nóng',
        28 => 'Vợ chồng thắng {x} trận',
        29 => 'Hoàn thành {x} thành tích',
        30 => 'Tích luỹ {x} tài sản, hoàn thành {y} 2vs2',
        33 => 'Gửi thư cho bạn bè',
        34 => 'Tham gia {x} trận 2vs2',
        35 => 'Bái 1 sư phụ, thu nạp đệ tử',
        36 => 'Sư phụ và đệ tử hoàn thành {x} trận ',
        37 => 'Sư phụ và đệ tử hoàn thành {x} trận',
        38 => 'Đổi {x} xu vào game',
    ];
    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {


        $currentTank = Auth::guard('admin')->user()->current_tank;
        $questCondiction = new QuestCondiction();
        $questCondiction->setConnection($currentTank);

        $quests = Quest::on($currentTank)->get();
        $questID = Request::capture()->input('QuestID');
        $questValues = [];
        foreach ($quests as $quest){ $questValues[$quest->ID] = $quest->Title; }

        $grid = new Grid($questCondiction);
        $grid->model()->orderByDesc('QuestID');
        $grid->column('QuestID', __('QuestID'))->width(80);;
        $grid->column('Quest.Title','Nhiệm vụ');
        $grid->column('CondictionID', __('Thứ tự NV'))->width(100);
        $grid->column('CondictionType', __('Loại nhiệm vụ'))->display(function (){
            return $this->getCondictionTypeText();
        });
        $grid->column('CondictionTitle', __('Tiêu đề điều kiện'));
        $grid->column('Para1', __('Para1'));
        $grid->column('Para2', __('Para2'));
        $grid->column('isOpitional', __('IsOpitional'));

        $grid->expandFilter();
        $grid->filter(function ($filter) use ($questValues){
            $filter->disableIdFilter();
            $filter->equal('QuestID','Tìm kiếm nhiệm vụ')->select($questValues);
            $filter->equal('CondictionType','Loại nhiệm vụ')->select($this->condictionType);
        });

        $grid->actions(function ($actions){
            $actions->disableEdit();
            $actions->disableView();
            $actions->disableDelete();
            $actions->add(new DeleteQuestCondictionAction());
        });

        $grid->quickCreate(function ($create) use ($questID, $questValues){
            $create->select('QuestID')->options($questValues)->value($questID);
            $create->integer('CondictionID','Thứ tự NV');
            $create->select('CondictionType','Loại NV')->options($this->condictionType);
            $create->text('CondictionTitle', 'Tiêu đề điều kiện');
            $create->text('Para1', 'Para1');
            $create->text('Para2', 'Para2');
            $create->integer('isOpitional')->value(0)->style('display','none');
        });

        $grid->tools(function ($tools) {
            $tools->append(new RedirectToCreateMultipleQuestCondiction());
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

        $show = new Show(QuestCondiction::findOrFail($currentTank));

        $show->field('QuestID', __('QuestID'));
        $show->field('CondictionID', __('CondictionID'));
        $show->field('CondictionType', __('CondictionType'));
        $show->field('CondictionTitle', __('CondictionTitle'));
        $show->field('Para1', __('Para1'));
        $show->field('Para2', __('Para2'));
        $show->field('isOpitional', __('IsOpitional'));

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
        $questCondiction = new QuestCondiction();
        $questCondiction->setConnection($currentTank);

        $quests = Quest::on($currentTank)->get();
        $questValues = [];
        foreach ($quests as $quest){ $questValues[$quest->ID] = $quest->Title; }

        $form = new Form($questCondiction);

        $form->select('QuestID', __('Nhiệm vụ'))->options($questValues)->placeholder('Lựa chọn nhiệm vụ');
        $form->select('CondictionType', __('Loại nhiệm vụ'))->options($this->condictionType)->placeholder('Lựa chọn loại nhiệm vụ');
        $form->number('CondictionID', __('Thứ tự nhiệm vụ'))->width('100%')->default(1);
        $form->text('CondictionTitle', __('Tiêu đề điều kiện'))->placeholder('Nhập tiêu đề điều kiện');
        $form->divider('Tìm kiếm');
        $form->select('_MissionInfo_','Tìm kiếm ải phó bản')->ajax('/admin/api/find/mission-info');
        $form->select('_NPC_','Tìm kiếm NPC')->ajax('/admin/api/find/npc');
        $form->select('_Item_','Tìm kiếm vật phẩm')->ajax('/admin/api/load-item');
        $form->divider('Tham số');
        $form->text('Para1', __('Para1'))->default(0)->width('100%')->rules('integer',['integer'=>'Para1 phải là số']);
        $form->text('Para2', __('Para2'))->default(0)->width('100%')->rules('integer',['integer'=>'Para2 phải là số']);
        $form->hidden('isOpitional', __('IsOpitional'))->default(0)->width('100%');



        $form->ignore('_MissionInfo_');
        $form->ignore('_NPC_');
        $form->ignore('_Item_');
        $form->disableEditingCheck();

        return $form;
    }

    public function showCreateMultipleQuestCondictionForm(Content $content, Request $request)
    {
        $content->title('Cập nhật điều kiện cho nhiệm vụ');
        $questId = (int) $request->input('questId');

        $form = new FormWidget();
        $quests = Quest::all();
        $questValues = [];

        foreach ($quests as $quest){ $questValues[$quest->ID] = $quest->Title; }
        if ($questId > 0){
            $form->select('QuestID','Chọn nhiệm vụ')->options($questValues)->value($questId)->default($questId)->readonly()->disable();
        }
        else
            $form->select('QuestID','Chọn nhiệm vụ')->options($questValues);

        $form->divider('Tìm kiếm');
        $form->select('_MissionInfo_','Tìm kiếm ải phó bản')->ajax('/admin/api/find/mission-info');
        $form->select('_NPC_','Tìm kiếm NPC')->ajax('/admin/api/find/npc');
        $form->select('_Item_','Tìm kiếm vật phẩm')->ajax('/admin/api/load-item');

        $form->table('condictions', '', function ($form) {
            $form->select('CondictionType', __('Loại nhiệm vụ'))->options($this->condictionType)->placeholder('Lựa chọn loại nhiệm vụ')->required();
//            $form->text('CondictionID', __('Thứ tự NV'))->withoutIcon()->width('100%')->default(1);
            $form->text('CondictionTitle', __('Điều kiện'))->width('100%')->withoutIcon()->placeholder('Nhập điều kiện')->required();
            $form->text('Para1', __('Para1'))->withoutIcon()->default(0)->width('100%')->required();
            $form->text('Para2', __('Para2'))->withoutIcon()->default(0)->width('100%')->required();
            $form->hidden('isOpitional', __('IsOpitional'))->default(0)->width('100%');
        })->setWidth(12);;


        Admin::style('#has-many-condictions {overflow-x: auto;width: 100%;}');
        $content->body(new Box('Chọn điều kiện phần thưởng', $form));

        return $content;
    }

    public function createMultipleQuestCondiction(Request $request)
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $questId = $request->input('questId'); //MUST BE questId NOT QuestID
        $condictions = $request->input('condictions');
        $condictionKeys = array_keys($condictions);		// return array
        $payload = [];

        $maxQuestCondictionID = (int) QuestCondiction::where('QuestID', $questId)->max('CondictionID');
        if(sizeof($condictions) == 1){
            QuestCondiction::create([
                'QuestID' => $questId,
                'CondictionType' => $condictions[$condictionKeys[0]]['CondictionType'],
                'CondictionID' => ($maxQuestCondictionID+=1),
                'CondictionTitle' => $condictions[$condictionKeys[0]]['CondictionTitle'],
                'Para1' => $condictions[$condictionKeys[0]]['Para1'],
                'Para2' => $condictions[$condictionKeys[0]]['Para2'],
                'isOpitional' => $condictions[$condictionKeys[0]]['isOpitional'],
            ]);
            admin_toastr(__('Thêm điều kiện nhiệm vụ thành công'));
            return redirect('/admin/quests');
        }
        for($i = 0; $i < sizeof($condictions); $i++){
            array_push($payload, [
                'QuestID' => $questId,
                'CondictionType' => $condictions[$condictionKeys[$i]]['CondictionType'],
                'CondictionID' => ($maxQuestCondictionID+=1),
                'CondictionTitle' => $condictions[$condictionKeys[$i]]['CondictionTitle'],
                'Para1' => $condictions[$condictionKeys[$i]]['Para1'],
                'Para2' => $condictions[$condictionKeys[$i]]['Para2'],
                'isOpitional' => $condictions[$condictionKeys[$i]]['isOpitional'],
            ]);
        }

        DB::connection($currentTank)->table('Quest_Condiction')->insert($payload);
        admin_toastr(__('Thêm điều kiện nhiệm vụ thành công'));
        return redirect('/admin/quests');
    }

}
