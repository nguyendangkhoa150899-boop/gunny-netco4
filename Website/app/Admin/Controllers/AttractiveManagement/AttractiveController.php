<?php

namespace App\Admin\Controllers\AttractiveManagement;

use App\Admin\Actions\Attractive\DeleteAttractiveAction;
use App\EventRewardInfo;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Layout\Content;
use Encore\Admin\Show;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AttractiveController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Quản lý hấp dẫn';
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
        $req = Request::capture();
        $activityType = $req->input('ActivityType');

        $currentTank = Auth::guard('admin')->user()->current_tank;
        $eventRewardInfo = new EventRewardInfo();
        $eventRewardInfo->setConnection($currentTank);
        $eventRewardInfo->setPrimaryKey('fake');


        $grid = new Grid($eventRewardInfo);
        $grid->column('_ActivityType_', 'Loại hấp dẫn')->display(function (){
            return $this->getActivityTypeText();
        })->filter($this->activityType);
        $grid->column('SubActivityType', __('Mốc Thứ hạng'))->display(function ($SubActivityType){
            return $this->getActivityTypeText().' - '. $SubActivityType;
        });
        $grid->column('Condition', __('Điều kiện'));

        $grid->expandFilter();
        $grid->filter(function ($filter){
            $filter->disableIdFilter();
            $filter->equal('ActivityType','Tìm kiếm mốc')->select($this->activityType);
            $filter->equal('SubActivityType','Thứ hạng');
        });

        $grid->disableBatchActions();
        $grid->actions(function ($actions){
            $actions->disableDelete();
            $actions->disableEdit();
            $actions->disableView();
            $actions->add(new DeleteAttractiveAction());
        });

        $grid->quickCreate(function ($create) use ($activityType){
            $create->select('ActivityType')->options($this->activityType)->value($activityType);
            $create->text('SubActivityType','Mốc thứ hạng')->placeholder('Nhập thứ hạng');
            $create->text('Condition', 'Điều kiện')->placeholder('Nhập điều kiện');

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

        $show = new Show(EventRewardInfo::on($currentTank)->findOrFail($id));

        $show->field('ActivityType', __('ActivityType'));
        $show->field('SubActivityType', __('SubActivityType'));
        $show->field('Condition', __('Condition'));

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
        $eventRewardInfo = new EventRewardInfo();
        $eventRewardInfo->setConnection($currentTank);

        $form = new Form($eventRewardInfo);

        $form->select('ActivityType', 'Loại hấp dẫn')->options($this->activityType);
        $form->number('SubActivityType', __('Mốc thứ hạng'))->style('width','100%');
        $form->text('Condition', 'Điều kiện')->placeholder('Nhập vào điều kiện để đạt')->style('width','100%');

        return $form;
    }


    public function destroy($id)
    {
        return "stop here";
    }

    public function edit($id, Content $content)
    {
        return $content
            ->title($this->title())
            ->description($this->description['edit'] ?? trans('admin.edit'))
            ->body($this->form()->edit($id));
    }

}
