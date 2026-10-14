<?php

namespace App\Admin\Controllers\ActiveManagement;

use App\Active;
use App\ActiveAward;
use App\Admin\Actions\Giftcode\GenerateGiftCode;
use App\Admin\Actions\Giftcode\RedirectToActiveAwardGrid;
use App\Admin\Actions\Giftcode\ShowAddEntryItem;
use App\Admin\Forms\AddActiveAward;
use App\ServerList;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Form\NestedForm;
use Encore\Admin\Grid;
use Encore\Admin\Layout\Column;
use Encore\Admin\Layout\Content;
use Encore\Admin\Layout\Row;
use Encore\Admin\Show;
use App\Admin\Selectable\ActiveAwardSelectable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;


class GiftCodeController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Quản lý Hoạt động (Giftcode)';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        //Set on connection Tank
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $active = new Active();
        $active->setConnection($currentTank);

        $grid = new Grid($active);

        $grid->column('ActiveID', __('Giftcode ID'));
        $grid->column('Title', __('Tiêu đề'));
        $grid->column('Description', __('Mô tả'));
//        $grid->column('Content', __('Content'));
//        $grid->column('AwardContent', __('AwardContent'));
//        $grid->column('HasKey', __('HasKey'));
        $grid->column('StartDate', __('Ngày bắt đầu'))->display(function ($day){
            return date("d-m-Y", strtotime($day));
        });
        $grid->column('EndDate', __('Ngày kết thúc'))->display(function ($day){
            return date("d-m-Y", strtotime($day));
        });;

        $grid->actions(function ($actions) {
            $actions->add(new GenerateGiftCode());
            $actions->add(new RedirectToActiveAwardGrid());
        });
//        $grid->column('IsOnly', __('IsOnly'));
//        $grid->column('Type', __('Type'));
//        $grid->column('ActionTimeContent', __('ActionTimeContent'));
//        $grid->column('IsAdvance', __('IsAdvance'));
//        $grid->column('GoodsExchangeTypes', __('GoodsExchangeTypes'));
//        $grid->column('GoodsExchangeNum', __('GoodsExchangeNum'));
//        $grid->column('limitType', __('LimitType'));
//        $grid->column('limitValue', __('LimitValue'));
//        $grid->column('IsShow', __('IsShow'));
//        $grid->column('ActiveType', __('ActiveType'));
//        $grid->column('IconID', __('IconID'));
//        $grid->column('CanGetCode', __('CanGetCode'));
//        $grid->column('CodePrefix', __('CodePrefix'));

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
        $show = new Show(Active::on($currentTank)->findOrFail($id));

        $show->field('ActiveID', __('ActiveID'));
        $show->field('Title', __('Tiêu đề'));
        $show->field('Description', __('Mô tả'));
        $show->field('Content', __('Nội dung'));
        $show->field('AwardContent', __('Phần thưởng'));
//        $show->field('HasKey', __('HasKey'));
        $show->field('StartDate', __('StartDate'));
        $show->field('EndDate', __('EndDate'));
        $show->field('IsOnly', __('IsOnly'));
        $show->field('Type', __('Type'));
        $show->field('ActionTimeContent', __('ActionTimeContent'));
        $show->field('IsAdvance', __('IsAdvance'));
        $show->field('GoodsExchangeTypes', __('GoodsExchangeTypes'));
        $show->field('GoodsExchangeNum', __('GoodsExchangeNum'));
        $show->field('limitType', __('LimitType'));
        $show->field('limitValue', __('LimitValue'));
        $show->field('IsShow', __('IsShow'));
        $show->field('ActiveType', __('ActiveType'));
        $show->field('IconID', __('IconID'));
        $show->field('CanGetCode', __('CanGetCode'));
        $show->field('CodePrefix', __('CodePrefix'));

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
        $active = new Active();
        $active->setConnection($currentTank);

        $form = new Form($active);
        $form->setTitle('Tạo mới Hoạt động (Giftcode)');

        $form->column(1/2, function ($form) {
        if($form->isEditing())
            $form->number('ActiveID')->rules('required')->style('width','100%')->placeHolder('Nhập vào ID Hoạt động')->required(true);
        if($form->isCreating())
            $form->number('ActiveID')->rules('required|unique:sqlsrv_tank.Active', ['unique'=>'Mã hoạt động (GiftCode) đã được sử dụng'])->style('width','100%')->placeHolder('Nhập vào ID Hoạt động')->required(true);
        $form->text('Title', __('Tiêu đề'))->required(true)->placeHolder('Nhập tiêu đề Giftcode');
        $form->text('Description', __('Mô tả'))->placeHolder('Nhập mô tả');
        $form->text('Content', __('Nội dung'))->placeHolder('Nhập nội dung');
        $form->textarea('AwardContent', __('Phần thưởng'))->help('Mỗi phần thưởng 1 dòng.')->placeHolder('Nhập nội dung phần thưởng')->required(true);
//        $form->hidden('HasKey', __('HasKey'))->default(1);
        });

        $form->column(1/2, function ($form) {
            $form->date('StartDate', __('Ngày mở'))->default(date('Y-m-d H:i:s'))->required(true);
            $form->date('EndDate', __('Ngày đóng'))->default(date('Y-m-d H:i:s'))->required(true);
            $form->date('ActionTimeContent', __('ActionTimeContent'))->format('DD/MM/YYYY')->style('width','100%')->required(true)->placeHolder('Nhập vào ActionTimeContent');
            $states = [
                'on' => ['value' => 1, 'text' => 'Chỉ một lần'],
                'off' => ['value' => 0, 'text' => 'Nhận nhiều lần', 'color' => 'danger'],
            ];
            $form->switch('IsOnly', __('Nhận 1 lần'))->states($states)->default(1);
            $form->number('Type', 'Loại biểu tượng')->default(1);
            $form->radio('HasKey', 'Hình thức nhận')->options([1 => 'Nhập Giftcode', 3 => 'Nhận tự do'])->default(1)->required(true);
            $form->hidden('IsAdvance', __('IsAdvance'))->default(0);
            $form->hidden('ActiveType', __('ActiveType'))->default(0);
            $form->hidden('IconID', __('IconID'))->default(0);
            $form->switch('CanGetCode', __('CanGetCode'))->help('Này chưa biết là gì');
            $form->text('CodePrefix', __('Tiền tố GiftCode'));

//            $form->number('Type', __('Type'))->default(1)->required(true);
//            $form->checkbox('IsOnly', __('Nhận 1 lần'))->value(1)->options([0 => 'nhiều lần', 1=>'1 lần'])->stacked()->help('Mỗi nhân vật chỉ được nhận 1 lần');
//            $form->text('GoodsExchangeTypes', __('GoodsExchangeTypes'));
//            $form->text('GoodsExchangeNum', __('GoodsExchangeNum'));
//            $form->text('limitType', __('LimitType'));
//            $form->text('limitValue', __('LimitValue'));
//            $form->switch('IsShow', __('IsShow'));
        });

        return $form;
    }

    public function showAddActiveAward(Content $content)
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $request = Request::capture();
        $ActiveAwardId = $request->input('active_id');
        return $content->title('Chasn')
            ->title('Chỉnh sửa phần thưởng')
            ->row(function(Row $row) use($ActiveAwardId, $currentTank){
                $row->column(12, function (Column $column) use($ActiveAwardId, $currentTank){
                    $activeAward = new ActiveAward();
                    $activeAward->setConnection($currentTank);
                    $grid = new Grid($activeAward);
                    $grid->model()->where('ActiveID', $ActiveAwardId);
                    $grid->column('ActiveID','GiftCode ID');
                    $grid->column('image', __('Hình ảnh'))->display(function (){
                        return $this->ResourceImageColumn();
                    });
                    $grid->column('Item.Name','Vật phẩm')->editable();
                    $grid->column('Count', 'Count')->editable();
                    $grid->column('ValidDate', 'ValidDate')->editable();
                    $grid->column('StrengthenLevel', 'StrengthenLevel')->editable();
                    $grid->column('AttackCompose', 'AttackCompose')->editable();
                    $grid->column('DefendCompose', 'DefendCompose')->editable();
                    $grid->column('LuckCompose', 'LuckCompose')->editable();
                    $grid->column('AgilityCompose', 'AgilityCompose')->editable();
                    $grid->column('Gold', 'Gold')->editable();
                    $grid->column('Money', 'Money')->editable();
                    $grid->column('Sex', 'Sex')->editable();
                    $grid->column('Mark', 'Mark')->editable();

//                    $grid->


                    $column->row($grid);
                });
        });
    }

    public function generateGiftCode($model ,Request $request)
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $server = ServerList::where('TankConnection', $currentTank)->firstOrFail();
        $serverConnection = $server->Connection;

        $prefix = trim($request->input('Prefix'));
        $amount = $request->input('Amount');

        $payload = [];
        for ($i = 0; $i < $amount; $i++){
            $giftCode = $prefix.Str::random(15);
            array_push($payload,[
                'ActiveID' => $model->ActiveID,
                'AwardID' => $giftCode,//
                'PullDown' => 0,
                'GetDate' => now(),
                'UserID' => 0,
                'Mark' => 0,
            ]);
        }
        DB::connection($serverConnection)->table('Active_Number')->insert($payload);
        return true;
    }

}
