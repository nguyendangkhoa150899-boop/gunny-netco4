<?php

namespace App\Admin\Controllers\QuestManagement;

use App\Admin\Actions\Quest\AddQuestCondiction;
use App\Admin\Actions\Quest\AddQuestGoods;
use App\Admin\Extensions\Tools\Quest\RedirectToCreateMultipleQuestCondiction;
use App\Admin\Extensions\Tools\Quest\RedirectToCreateMultipleQuestGoods;
use App\Quest;
use App\QuestCondiction;
use App\ShopGoods;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Form\NestedForm;
use Encore\Admin\Grid;
use Encore\Admin\Show;
use Encore\Admin\Widgets\Table;
use Illuminate\Support\Facades\Auth;

class QuestController extends AdminController
{

    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Quản lý nhiệm vụ';

    private $questType = [
        0 => "Nhiệm vụ chủ tuyến",
        1 => "Nhiệm vụ phụ",
        2 => "Nhiệm vụ hằng ngày",
        3 => "Nhiệm vụ sự kiện",
        4 => "Nhiệm vụ VIP",
        6 => "Nhiệm vụ sử thi",
    ];
    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $quest = new Quest();
        $quest->setConnection($currentTank);

        $grid = new Grid($quest);
        $grid->model()->orderByDesc('ID');

        $grid->column('ID', __('ID'));
        $grid->column('Title', __('Tiêu đề'));
//        $grid->column('Detail', __('Mô tả nhiệm vụ'));
        $grid->column('QuestID', __('Loại nhiệm vụ'))->display(function (){
            return $this->QuestType();
        });
        $grid->column('RewardGP', __('EXP'))->editable();
        $grid->column('RewardGold', __('Vàng'))->editable();
        $grid->column('RewardMedal', __('Huân chương'))->editable();
        $grid->column('RewardGiftToken', __('Lễ kim'))->editable();
        $grid->column('NeedMinLevel', __('LV tối thiểu'))->editable();
        $grid->column('NeedMaxLevel', __('LV cao nhất'))->editable();
        $grid->column('PreQuestID', __('PreQuestID'))->editable();
        $grid->column('NextQuestID', __('NextQuestID'))->editable();
        $canRepeat =  [
            'on' => ['value' => 1, 'text' => 'Lặp lại', 'color' => 'primary'],
            'off' => ['value' => 0, 'text' => 'Nhận 1 lần', 'color' => 'danger'],
        ];
        $grid->column('StartDate', __('StartDate'))->filter('datetime')->editable('datetime');
        $grid->column('EndDate', __('EndDate'))->filter('datetime')->editable('datetime');;
//        $grid->column('QuestGoods','Phần thưởng')->display(function ($questGoods){
//            dd($questGoods);
//            return $questGoods;
//        });

        $grid->column('_Condiction_','Điều kiện')->expand(function ($model) use ($currentTank){
            $questCondiction = $model->QuestCondiction;
            $condictions = [];
            for ($i = 0; $i < sizeof($questCondiction); $i++) {
                array_push($condictions, [
                    $questCondiction[$i]->CondictionID,
                    $questCondiction[$i]->getCondictionTypeText(),
                    $questCondiction[$i]->CondictionTitle,
                    $questCondiction[$i]->Para1,
                    $questCondiction[$i]->Para2,
                ]);
            }
            sort($condictions);
            return new Table(['Thứ tự nhiệm vụ', 'Loại NV', 'Tiêu đề điều kiện', 'Para1', 'Para2'], $condictions);

        });
        $grid->column('_Award_','Phần thưởng')->expand(function ($model) {

            $questGoods = $model->QuestGoods;
			//var_dump($questGoods);
            $goods = [];
            for ($i = 0; $i < sizeof($questGoods); $i++) {
                array_push($goods, [
                    $questGoods[$i]->Item->ResourceImageColumnForQuest(),
                    $questGoods[$i]->Item->Name,
                    $questGoods[$i]->IsSelect,
                    $questGoods[$i]->StrengthenLevel,
                    $questGoods[$i]->RewardItemValid,
                    $questGoods[$i]->RewardItemCount,
                    $questGoods[$i]->Item->combine4Column(),
                    $questGoods[$i]->IsBind == 0 ? '<span class="badge btn-success">Không khoá</span>' : '<span class="badge btn-danger">khoá</span>',
					
                ]);
            }
			
            return new Table(['Hình ảnh', 'Vật phẩm', 'IsSelect', 'Cường hoá', 'Hạn', 'Số lượng', 'Chỉ số', 'Khoá'], $goods);
        });
        $grid->column('CanRepeat', __('Lặp lại'))->switch($canRepeat);
        $grid->column('RepeatMax', __('Nhận tối đa'));


//        $grid->column('RepeatInterval', __('RepeatInterval'));
//        $grid->column('Objective', __('Objective'));
//        $grid->column('IsOther', __('IsOther'));
//        $grid->column('RewardOffer', __('RewardOffer'));
//        $grid->column('RewardRiches', __('RewardRiches'));
//        $grid->column('RewardBuffID', __('RewardBuffID'));
//        $grid->column('RewardBuffDate', __('RewardBuffDate'));
//        $grid->column('RewardMoney', __('Xu'));
//        $grid->column('Rands', __('Rands'));
//        $grid->column('RandDouble', __('RandDouble'));
//        $grid->column('TimeMode', __('TimeMode'));
//        $grid->column('MapID', __('MapID'));
//        $grid->column('AutoEquip', __('AutoEquip'));
//        $grid->column('Rank', __('Rank'));
//        $grid->column('StarLev', __('StarLev'));
//        $grid->column('NotMustCount', __('NotMustCount'));

        $grid->expandFilter();
        $grid->filter(function ($filter) {
            $filter->disableIdFilter();
            $filter->like('Title','Tìm kiếm nhiệm vụ');
            $filter->equal('QuestID','Loại nhiệm vụ')->select($this->questType);
        });

        $grid->actions(function($actions) {
            $actions->add(new AddQuestCondiction());
            $actions->add(new AddQuestGoods());
        });

        $grid->tools(function ($tools) {
            $tools->append(new RedirectToCreateMultipleQuestCondiction());
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

        $show = new Show(Quest::on($currentTank)->findOrFail($id));

        $show->field('ID', __('ID'));
        $show->field('EndDate', __('EndDate'));
        $show->field('RewardGP', __('RewardGP'));
        $show->field('QuestID', __('QuestID'));
        $show->field('Title', __('Title'));
        $show->field('Detail', __('Detail'));
        $show->field('Objective', __('Objective'));
        $show->field('NeedMinLevel', __('NeedMinLevel'));
        $show->field('NeedMaxLevel', __('NeedMaxLevel'));
        $show->field('PreQuestID', __('PreQuestID'));
        $show->field('NextQuestID', __('NextQuestID'));
        $show->field('IsOther', __('IsOther'));
        $show->field('CanRepeat', __('CanRepeat'));
        $show->field('RepeatInterval', __('RepeatInterval'));
        $show->field('RepeatMax', __('RepeatMax'));
        $show->field('RewardGold', __('RewardGold'));
        $show->field('RewardGiftToken', __('RewardGiftToken'));
        $show->field('RewardOffer', __('RewardOffer'));
        $show->field('RewardRiches', __('RewardRiches'));
        $show->field('RewardBuffID', __('RewardBuffID'));
        $show->field('RewardBuffDate', __('RewardBuffDate'));
        $show->field('RewardMoney', __('RewardMoney'));
        $show->field('Rands', __('Rands'));
        $show->field('RandDouble', __('RandDouble'));
        $show->field('TimeMode', __('TimeMode'));
        $show->field('StartDate', __('StartDate'));
        $show->field('MapID', __('MapID'));
        $show->field('AutoEquip', __('AutoEquip'));
        $show->field('RewardMedal', __('RewardMedal'));
        $show->field('Rank', __('Rank'));
        $show->field('StarLev', __('StarLev'));
        $show->field('NotMustCount', __('NotMustCount'));

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
        $quest = new Quest();
        $newId = (int) Quest::max('ID');
        $newId += 1;
        $quest->setConnection($currentTank);

        $form = new Form($quest);

        $form->divider('Thông tin nhiệm vụ');
        if($form->isCreating())
            $form->number('ID', __('ID'))
                ->value($newId)
                ->width('100%')
                ->help('ID không được trùng')
                ->rules('required|unique:'.$currentTank.'.Quest', ['unique'=>'QuestID đã được sử dụng']);
        else
            $form->number('ID', __('ID'))->width('100%')->help('ID không được trùng');

        $form->select('QuestID', 'Loại nhiệm vụ')->options($this->questType);
        $form->text('Title', __('Tiêu đề nhiệm vụ'));
        $form->text('Detail', __('Chi tiết nhiệm vụ'));
        $form->hidden('Objective')->default("")->value("");
        $form->number('NeedMinLevel', __('Level tối thiểu'))->width('100%')->default(5);
        $form->number('NeedMaxLevel', __('Level tối đa'))->width('100%')->default(100);
        $form->text('PreQuestID', __('PreQuestID'))->default('0,');
        $form->text('NextQuestID', __('NextQuestID'))->default('0,');
        $form->number('IsOther', __('IsOther'))->width('100%')->default(0);
        $form->switch('CanRepeat', __('Lặp lại'))->width('100%');
        $form->number('RepeatInterval', __('RepeatInterval'))->width('100%')->default(1);
        $form->number('RepeatMax', __('Lặp lại tối đa'))->width('100%')->default(1);
        $form->divider('Thời gian');
        $form->datetime('StartDate', __('StartDate'))->default(date('2000-01-01 00:00:00.000'))->width('100%');
        $form->datetime('EndDate', __('EndDate'))->default(date('Y-m-d 23:59:59.000'))->width('100%');
        $form->divider('Phần thưởng')->width('100%');
        $form->number('RewardGold', __('Vàng'))->default(0)->width('100%');
        $form->number('RewardGP', __('EXP'))->default(0)->width('100%');
        $form->number('RewardGiftToken', __('Lễ kim'))->default(0)->width('100%');
        $form->number('RewardOffer', __('Công trạng'))->default(0)->width('100%');
        $form->number('RewardMedal', __('Huân chương'))->default(0)->width('100%');
        $form->number('RewardMoney', __('Xu'))->default(0)->width('100%');
        $form->number('RewardRiches', __('Tài sản guild'))->default(0)->width('100%');
        $form->number('RewardBuffID', __('Kỹ năng guild'))->default(0)->width('100%');
        $form->number('RewardBuffDate', __('Thời hạn kỹ năng guild'))->default(0)->width('100%');
        $form->text('Rands', __('Nhiệm vụ xanh'))->default('0.00');
        $form->number('RandDouble', __('Tỉ lệ nhân đôi vật phẩm'))->default(1)->width('100%');
        $form->switch('TimeMode', __('TimeMode'))->default(0)->width('100%');
        $form->number('MapID', __('MapID'))->default(0)->width('100%');
        $form->switch('AutoEquip', __('AutoEquip'))->default(0)->width('100%');
        $form->text('Rank', __('Rank'))->default("");
        $form->number('StarLev', __('StarLev'))->default(0)->width('100%');
        $form->number('NotMustCount', __('NotMustCount'))->default(0)->width('100%');

        $form->disableEditingCheck();
        return $form;
    }

    private function getCondictionTypeInTable($condictionType)
    {
        switch ($condictionType){
            case 102:
                return 'Tắm suôi nước nóng {x} phút';
            case 100:
                return 'Trực tuyến game {x} phút';
            case 1:
                return 'Đăng nhập game (1)';
            case 16:
                return 'Đăng nhập game (16)';
            case 3:
                return 'Sử dụng vật phẩm bất kì';
            case 4:
                return 'Trong chiến đấu đánh bại {x} người';
            case 5:
                return 'Hoàn thành {x} trận chiến đấu';
            case 6:
                return 'Chiến thắng {x} trận chiến đấu';
            case 9:
                return 'Cường hoá vật phẩm {x} lên cấp {y}';
            case 10:
                return 'Tiêu phí shop';
            case 11:
                return 'Dung luyện vật phẩm {x}';
            case 13:
                return 'Đích thân hạ NPC {x}';
            case 15:
                return 'Thu thập vật phẩm {x}';
            case 17:
                return 'Kết hôn';
            case 18:
                return 'Guild đạt {x} người, gia nhập G, rèn-két-shop đạt cấp {y}';
            case 19:
                return 'dùng đá {x} để hợp thành thành công';
            case 20:
                return 'vào đấu giá, phòng tập,phòng cao thủ, kết bạn , tăng số lượng bạn bè';
            case 21:
                return 'Vượt ải {x}';
            case 22:
                return 'Tiêu diệt {x} người trong G chiến';
            case 23:
                return 'Hoàn thành {x} trận G chiến';
            case 24:
                return 'Chiến thắng {x} trận G chiến';
            case 25:
                return 'Khảm nạn châu báu bất kì';
            case 26:
                return 'Hoàn thành {x} trận vợ chồng';
            case 27:
                return 'Vào suối nước nóng';
            case 28:
                return 'Vợ chồng thắng {x} trận';
            case 29:
                return 'Hoàn thành {x} thành tích';
            case 30:
                return 'Tích luỹ {x} tài sản, hoàn thành {y} 2vs2';
            case 33:
                return 'Gửi thư cho bạn bè';
            case 34:
                return 'Tham gia {x} trận 2vs2';
            case 35:
                return 'Bái 1 sư phụ, thu nạp đệ tử';
            case 36:
                return 'Sư phụ và đệ tử hoàn thành {x} trận ';
            case 37:
                return 'Sư phụ và đệ tử hoàn thành {x} trận';
            case 38:
                return 'Đổi {x} xu vào game';
            default:
                return 'Không xác định';
        }

    }
}
