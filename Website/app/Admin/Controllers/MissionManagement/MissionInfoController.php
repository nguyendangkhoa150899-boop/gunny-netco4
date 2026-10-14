<?php

namespace App\Admin\Controllers\MissionManagement;

use App\MissionInfo;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class MissionInfoController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'MissionInfo';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $missionInfo = new MissionInfo();
        $missionInfo->setConnection($currentTank);

        $grid = new Grid($missionInfo);

        $grid->column('Id', __('Id'));
        $grid->column('Name', __('Name'));
        $grid->column('TotalCount', __('TotalCount'));
        $grid->column('TotalTurn', __('TotalTurn'));
        $grid->column('Script', __('Script'));
        $grid->column('Success', __('Success'));
        $grid->column('Failure', __('Failure'));
        $grid->column('Description', __('Description'));
        $grid->column('IncrementDelay', __('IncrementDelay'));
        $grid->column('Delay', __('Delay'));
        $grid->column('Title', __('Title'));
        $grid->column('Param1', __('Param1'));
        $grid->column('Param2', __('Param2'));
        $grid->column('TakeCard', __('TakeCard'));

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
        $show = new Show(MissionInfo::on($currentTank)->findOrFail($id));

        $show->field('Id', __('Id'));
        $show->field('Name', __('Name'));
        $show->field('TotalCount', __('TotalCount'));
        $show->field('TotalTurn', __('TotalTurn'));
        $show->field('Script', __('Script'));
        $show->field('Success', __('Success'));
        $show->field('Failure', __('Failure'));
        $show->field('Description', __('Description'));
        $show->field('IncrementDelay', __('IncrementDelay'));
        $show->field('Delay', __('Delay'));
        $show->field('Title', __('Title'));
        $show->field('Param1', __('Param1'));
        $show->field('Param2', __('Param2'));
        $show->field('TakeCard', __('TakeCard'));

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
        $missionInfo = new MissionInfo();
        $missionInfo->setConnection($currentTank);

        $form = new Form($missionInfo);

        $form->text('Name', __('Name'));
        $form->number('TotalCount', __('TotalCount'));
        $form->number('TotalTurn', __('TotalTurn'));
        $form->text('Script', __('Script'));
        $form->text('Success', __('Success'));
        $form->text('Failure', __('Failure'));
        $form->text('Description', __('Description'));
        $form->number('IncrementDelay', __('IncrementDelay'));
        $form->number('Delay', __('Delay'));
        $form->text('Title', __('Title'));
        $form->number('Param1', __('Param1'));
        $form->number('Param2', __('Param2'));
        $form->number('TakeCard', __('TakeCard'));

        return $form;
    }

    public function showMissionInfo(Request $request)
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;

        $q = $request->get('q');
        $missionInfo = MissionInfo::on($currentTank)->where('Name','like', "%$q%")->paginate();
        $missionInfo->getCollection()->transform(function ($value) {
            return [
                'id'=> $value->Id,
                'text' => $value->Name .' - (ID: '.$value->Id. ')',
            ];
        });
        return $missionInfo;
    }

}
