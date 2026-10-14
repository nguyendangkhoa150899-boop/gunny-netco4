<?php

namespace App\Admin\Controllers\MissionManagement;

use App\NPC;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;
use Illuminate\Support\Facades\Auth;

class NPCController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'NPC';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $NPC = new NPC();
        $NPC->setConnection($currentTank);
        $grid = new Grid($NPC);
        $grid->model()->orderBy('ID');
        $grid->column('ID', __('ID'))->sortable();
        $grid->column('Name', __('Name'))->editable()->sortable();
        $grid->column('Level', __('Level'))->editable();
        $grid->column('Camp', __('Camp'))->editable();
        $grid->column('Type', __('Type'))->editable();
        $grid->column('X', __('X'))->editable();
        $grid->column('Y', __('Y'))->editable();
        $grid->column('Width', __('Width'))->editable();
        $grid->column('Height', __('Height'))->editable();
        $grid->column('Blood', __('Blood'))->editable();
        $grid->column('MoveMin', __('MoveMin'))->editable();
        $grid->column('MoveMax', __('MoveMax'))->editable();
        $grid->column('BaseDamage', __('BaseDamage'))->editable();
        $grid->column('BaseGuard', __('BaseGuard'))->editable();
        $grid->column('Defence', __('Defence'))->editable();
        $grid->column('Agility', __('Agility'))->editable();
        $grid->column('Lucky', __('Lucky'))->editable();
        $grid->column('Attack', __('Attack'))->editable();
        $grid->column('ModelID', __('ModelID'))->editable();
        $grid->column('ResourcesPath', __('ResourcesPath'))->editable();
        $grid->column('DropRate', __('DropRate'))->editable();
        $grid->column('Experience', __('Experience'))->editable();
        $grid->column('Delay', __('Delay'))->editable();
        $grid->column('Immunity', __('Immunity'))->editable();
        $grid->column('Alert', __('Alert'))->editable();
        $grid->column('Range', __('Range'))->editable();
        $grid->column('Preserve', __('Preserve'))->editable();
        $grid->column('Script', __('Script'))->editable();
        $grid->column('FireX', __('FireX'))->editable();
        $grid->column('FireY', __('FireY'))->editable();
        $grid->column('DropId', __('DropId'))->editable();
        $grid->column('CurrentBallId', __('CurrentBallId'))->editable();
        $grid->column('speed', __('Speed'))->editable();
        $grid->column('MagicAttack', __('MagicAttack'))->editable();
        $grid->column('MagicDefence', __('MagicDefence'))->editable();

        $grid->quickSearch('ID', 'Name', 'Level', 'ResourcesPath', 'ModelID', 'Script');

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
        $show = new Show(NPC::on($currentTank)->findOrFail($id));

        $show->field('ID', __('ID'));
        $show->field('Name', __('Name'));
        $show->field('Level', __('Level'));
        $show->field('Camp', __('Camp'));
        $show->field('Type', __('Type'));
        $show->field('X', __('X'));
        $show->field('Y', __('Y'));
        $show->field('Width', __('Width'));
        $show->field('Height', __('Height'));
        $show->field('Blood', __('Blood'));
        $show->field('MoveMin', __('MoveMin'));
        $show->field('MoveMax', __('MoveMax'));
        $show->field('BaseDamage', __('BaseDamage'));
        $show->field('BaseGuard', __('BaseGuard'));
        $show->field('Defence', __('Defence'));
        $show->field('Agility', __('Agility'));
        $show->field('Lucky', __('Lucky'));
        $show->field('Attack', __('Attack'));
        $show->field('ModelID', __('ModelID'));
        $show->field('ResourcesPath', __('ResourcesPath'));
        $show->field('DropRate', __('DropRate'));
        $show->field('Experience', __('Experience'));
        $show->field('Delay', __('Delay'));
        $show->field('Immunity', __('Immunity'));
        $show->field('Alert', __('Alert'));
        $show->field('Range', __('Range'));
        $show->field('Preserve', __('Preserve'));
        $show->field('Script', __('Script'));
        $show->field('FireX', __('FireX'));
        $show->field('FireY', __('FireY'));
        $show->field('DropId', __('DropId'));
        $show->field('CurrentBallId', __('CurrentBallId'));
        $show->field('speed', __('Speed'));
        $show->field('MagicAttack', __('MagicAttack'));
        $show->field('MagicDefence', __('MagicDefence'));

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
        $NPC = new NPC();
        $NPC->setConnection($currentTank);
        $form = new Form($NPC);

        $form->text('Name', __('Name'));
        $form->number('Level', __('Level'));
        $form->number('Camp', __('Camp'));
        $form->number('Type', __('Type'));
        $form->number('X', __('X'));
        $form->number('Y', __('Y'));
        $form->number('Width', __('Width'));
        $form->number('Height', __('Height'));
        $form->number('Blood', __('Blood'));
        $form->number('MoveMin', __('MoveMin'));
        $form->number('MoveMax', __('MoveMax'));
        $form->number('BaseDamage', __('BaseDamage'));
        $form->number('BaseGuard', __('BaseGuard'));
        $form->number('Defence', __('Defence'));
        $form->number('Agility', __('Agility'));
        $form->number('Lucky', __('Lucky'));
        $form->number('Attack', __('Attack'));
        $form->text('ModelID', __('ModelID'));
        $form->text('ResourcesPath', __('ResourcesPath'));
        $form->text('DropRate', __('DropRate'));
        $form->number('Experience', __('Experience'));
        $form->number('Delay', __('Delay'));
        $form->number('Immunity', __('Immunity'));
        $form->number('Alert', __('Alert'));
        $form->number('Range', __('Range'));
        $form->number('Preserve', __('Preserve'));
        $form->text('Script', __('Script'));
        $form->number('FireX', __('FireX'));
        $form->number('FireY', __('FireY'));
        $form->number('DropId', __('DropId'));
        $form->number('CurrentBallId', __('CurrentBallId'));
        $form->number('speed', __('Speed'));
        $form->number('MagicAttack', __('MagicAttack'));
        $form->number('MagicDefence', __('MagicDefence'));

        return $form;
    }
}
