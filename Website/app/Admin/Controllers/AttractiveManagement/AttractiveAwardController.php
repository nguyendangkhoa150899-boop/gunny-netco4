<?php

namespace App\Admin\Controllers\AttractiveManagement;

use App\Admin\Actions\Attractive\DeleteAttractiveAwardAction;
use App\EventRewardGoods;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;
use Illuminate\Support\Facades\Auth;

class AttractiveAwardController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Phần thưởng của hấp dẫn';

    private $activityType = [
        1 => 'Mốc level ',
        2 => 'Mốc cường hoá',
        3 => 'Mốc tiêu xu',
        4 => 'Mốc nạp xu',
        5 => 'Mốc level VIP',
        6 => 'Mốc quà lực chiến',
        7 => 'Mốc Nạp xu đặc biệt',
        8 => 'Mốc Tiêu xu đặc biệt',
        9 => 'Nạp lần đầu'
    ];

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $eventRewardGoods = new EventRewardGoods();
        $eventRewardGoods->setConnection($currentTank);
        $eventRewardGoods->setPrimaryKey('fake');

        $grid = new Grid($eventRewardGoods);
        $grid->perPage = 50;

        $grid->column('ActivityType','Loại Hấp dẫn')->display(function (){
            return $this->getActivityTypeText();
        });
        $grid->column('SubActivityType', 'Mốc thứ hạng');
//        $grid->column('TemplateId', __('TemplateId'));
        $grid->column('_ImageItem)', __('Hình ảnh'))->display(function (){
            return $this->ResourceImageColumn();
        });
        $grid->column('Item.Name', __('Phần thưởng'));
        $grid->column('StrengthLevel', __('Cường hoá'));
        $grid->column('AttackCompose', __('HT tấn công'));
        $grid->column('DefendCompose', __('HT Phòng thủ'));
        $grid->column('LuckCompose', __('HT May mắn'));
        $grid->column('AgilityCompose', __('HT Nhanh nhẹn'));
        $grid->column('IsBind', __('Khoá'))->display(function ( $IsBind){
            return (int) $IsBind == 0 ? '<span class="badge btn-success">Không khoá</span>': '<span class="badge btn-danger">Khoá</span>';
        });
        $grid->column('ValidDate', __('Thời hạn'));
        $grid->column('Count', __('Số lượng'));

        $grid->expandFilter();
        $grid->filter(function ($filter){
            $filter->disableIdFilter();
            $filter->equal('ActivityType','Tìm kiếm mốc')->select($this->activityType);
            $filter->equal('SubActivityType','Mốc thứ hạng');
        });

        $grid->disableBatchActions();
        $grid->actions(function ($actions){
            $actions->disableDelete();
            $actions->disableEdit();
            $actions->disableView();
            $actions->add(new DeleteAttractiveAwardAction());
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
        $show = new Show(EventRewardGoods::findOrFail($id));

        $show->field('ActivityType', __('ActivityType'));
        $show->field('SubActivityType', __('SubActivityType'));
        $show->field('TemplateId', __('TemplateId'));
        $show->field('StrengthLevel', __('StrengthLevel'));
        $show->field('AttackCompose', __('AttackCompose'));
        $show->field('DefendCompose', __('DefendCompose'));
        $show->field('LuckCompose', __('LuckCompose'));
        $show->field('AgilityCompose', __('AgilityCompose'));
        $show->field('IsBind', __('IsBind'));
        $show->field('ValidDate', __('ValidDate'));
        $show->field('Count', __('Count'));

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
        $eventRewardGoods = new EventRewardGoods();
        $eventRewardGoods->setConnection($currentTank);

        $form = new Form($eventRewardGoods);

        $form->select('ActivityType', 'Loại hấp dẫn')->options($this->activityType);
        $form->select('TemplateId', 'Vật phẩm')->ajax('/admin/api/load-item');
        $form->number('SubActivityType', 'Mốc thứ hạng')->width('100%');
        $form->number('StrengthLevel', 'Cường hoá')->width('100%')->default(0);
        $form->number('AttackCompose', 'HT Tấn công')->width('100%')->default(0);
        $form->number('DefendCompose', 'HT Phòng thủ')->width('100%')->default(0);
        $form->number('LuckCompose', 'HT May mắn')->width('100%')->default(0);
        $form->number('AgilityCompose', 'HT Nhanh nhẹn')->width('100%')->default(0);
        $form->switch('IsBind', 'Khoá')->default(1)->width('100%');
        $form->number('ValidDate', 'Thời hạn')->help('0 là vĩnh viễn')->width('100%');
        $form->number('Count', 'Số lượng')->default(1)->width('100%');

        return $form;
    }
}
