<?php

namespace App\Admin\Controllers;

use App\Admin\Actions\Player\RedirectEditAction;
use App\Admin\Extensions\Tools\SelectServerTools;
use App\Admin\Forms\EditPlayerForm;
use App\Member;
use App\Player;
use App\ServerList;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Layout\Content;
use Encore\Admin\Show;
use Illuminate\Http\Request;

class PlayerManagement extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Danh sách nhân vật';
    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {

        $request = Request::capture();
        if($request->has('server')){
            $request->input('server') == null ? $serverId = "1001" : $serverId = $request->input('server');
        }
        else $serverId = "1001";

        $server = ServerList::findOrFail($serverId);

        $player = new Player();
        $player->setConnection($server->Connection);

        $grid = new Grid($player);
        $grid->model()->select('UserID', 'UserName', 'NickName', 'IsConsortia', 'ConsortiaID', 'Sex', 'Win', 'Total', 'GP', 'Gold', 'Money', 'MoneyLock' ,'FightPower','Grade','OnlineTime');
        $grid->column('UserID', __('UserID'))->filter();
        $grid->column('UserName', __('Tài khoản'))->sortable();
        $grid->column('NickName', __('Tên nhân vật'))->sortable();
        $grid->column('Win', __('Trận thắng'))->sortable();
        $grid->column('Total', __('Tổng trận'))->sortable();
        $grid->column('Money', __('Xu'))->sortable();
        $grid->column('Grade', __('Cấp độ'))->sortable();
        $grid->column('FightPower', __('Lực chiến'))->sortable();
        $grid->column('OnlineTime', __('Online'))->sortable();

        $grid->quickSearch('UserID', 'UserName', 'NickName', 'Money', 'Grade');
        $grid->disableCreateButton();
        $grid->disableFilter();
        $grid->disableExport();

        $resource = $grid->resource();


        $grid->actions(function($actions) use ($resource, $server){
            $actions->disableDelete();
            $actions->disableView();
            $actions->disableEdit();
            $actions->add(new RedirectEditAction($server));
//            $actions->append('<a href="'.$resource.'/'.$actions->getKey() .'/edit?server='.$server->ServerID.'"><i class="fa fa-edit"> Chỉnh sửa</i></a>');


        });

        $grid->tools(function ($tools) {
            $tools->append(new SelectServerTools());
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
        $player = Player::on('sqlsrv_tank41')->select('UserID','UserName', 'Password', 'NickName', 'IsConsortia', 'ConsortiaID', 'Sex', 'Win', 'Total', 'Escape', 'GP', 'Honor', 'Gold', 'Money', 'MoneyLock', 'Style', 'Colors', 'Hide', 'Grade', 'OnlineTime', 'ServerName')->where('UserID', $id)->first();
        $show = new Show($player);

        $show->field('UserID', __('UserID'));
        $show->field('UserName', __('UserName'));
        $show->field('NickName', __('NickName'));
        $show->field('IsConsortia', __('IsConsortia'));
        $show->field('ConsortiaID', __('ConsortiaID'));
        $show->field('Sex', __('Sex'));
        $show->field('Win', __('Win'));
        $show->field('Total', __('Total'));
        $show->field('GP', __('GP'));
        $show->field('Gold', __('Gold'));
        $show->field('Money', __('Money'));
        $show->field('MoneyLock', __('MoneyLock'));
        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function formNe($player, $server)
    {

        $form = new Form($player);
        $form->setTitle("Chỉnh sửa nhân vật ");
        $form->text('Server')->readonly()->disable()->value($server->ServerName);
        $form->hidden('ServerConnection')->readonly()->value($server->Connection);
        $form->text('UserName','Tên Tài khoản')->value($player->UserName);
        $form->text('NickName', 'Tên nhân vật')->value($player->NickName);
        $form->number('IsConsortia')->value($player->IsConsortia);
        $form->number('ConsortiaID')->value($player->ConsortiaID);
        $form->radio('Sex','Giới tính')->value($player->Sex)->options([1 => 'Nam', 0=> 'Nữ'])->stacked();
        $form->number('Win', 'Trận thắng')->value($player->Win);
        $form->number('Total','Tổng trận đã đấu')->value($player->Total);
        $form->number('GP','Kinh nghiệm (EXP)')->value($player->GP);
        $form->number('Gold','Vàng')->value($player->Gold);
        $form->number('Money','Xu')->value($player->Money);
        $form->number('MoneyLock','Lễ Kim')->value($player->MoneyLock);
        $form->number('Grade','Cấp độ')->value($player->Grade);
        $form->number('OnlineTime','Thời gian chơi')->value($player->OnlineTime);

        $form->disableViewCheck();
        $form->disableCreatingCheck();
        $form->disableEditingCheck();

        $form->tools(function ( $tools) {
            $tools->disableDelete();
            $tools->disableView();
            $tools->disableList();
        });

        $form->setAction('save');

        return $form;
    }

    public function edit($id, Content $content)
    {
        $serverId = Request::capture()->input('server');
        $server = ServerList::findOrFail($serverId);

        $player = Player::on($server->Connection)->select('UserName', 'Password', 'NickName', 'IsConsortia', 'ConsortiaID', 'Sex', 'Win', 'Total', 'Escape', 'GP', 'Honor', 'Gold', 'Money', 'MoneyLock', 'Style', 'Colors', 'Hide', 'Grade', 'OnlineTime', 'ServerName')
            ->where("UserID", $id)
            ->first();
        return $content
            ->title('Chỉnh sửa nhân vật')
            ->body($this->formNe($player, $server));
//        return parent::edit($id, $content); // TODO: Change the autogenerated stub
    }

    public function update($id)
    {
        $this->formNe($id)->update($id);
    }

    /**
     * SAVE USSER
     * @param $id
     * @param Request $request
     * @return \Illuminate\Http\RedirectResponse
     */
    public function save($id, Request $request)
    {
        $serverConnection = $request->input('ServerConnection');
        Player::on($serverConnection)->select('UserName', 'Password', 'NickName', 'IsConsortia', 'ConsortiaID', 'Sex', 'Win', 'Total', 'Escape', 'GP', 'Honor', 'Gold', 'Money', 'MoneyLock', 'Style', 'Colors', 'Hide', 'Grade', 'OnlineTime', 'ServerName')->where('UserID', $id)->update($request->except(['_token', '_previous_', 'ServerConnection','ServerName']));
        admin_success('Cập nhập thông tin nhân vật thành công.');
        return back();
    }


}
