<?php

namespace App\Admin\Controllers\MemberManagement;

use App\Player;
use App\ServerList;
use App\ShopGoods;
use App\UserMessage;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;
use Illuminate\Support\Facades\Auth;

class LogUserSendMailController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Lịch sử gửi thư';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new UserMessage());

        $grid->column('ID', __('ID'));
        $grid->column('SenderID', __('SenderID'))->filter();
        $grid->column('Sender', __('Sender'));
        $grid->column('ReceiverID', __('ReceiverID'))->filter();
        $grid->column('Receiver', __('Receiver'));
        $grid->column('Title', __('Title'));
        $grid->column('Content', __('Content'));
        $grid->column('SendTime', __('SendTime'));
        $grid->column('IsRead', __('IsRead'));
        $grid->column('IsDelR', __('IsDelR'));
        $grid->column('IfDelS', __('IfDelS'));
        $grid->column('IsDelete', __('IsDelete'));
        $grid->column('Gold', __('Gold'));
        $grid->column('Money', __('Money'));
        $grid->column('IsExist', __('IsExist'));
        $grid->column('Type', __('Type'));
        $grid->column('Annex1Name', __('Annex1Name'));
        $grid->column('AnnexRemark', __('AnnexRemark'));
        $grid->column('Remark', __('Remark'));
        $grid->column('SendDate', __('SendDate'));
        $grid->column('ValidDate', __('ValidDate'));
        $grid->column('Annex2Name', __('Annex2Name'));
        $grid->column('Annex1', __('Annex1'));
        $grid->column('Annex2', __('Annex2'));
        $grid->column('Annex3', __('Annex3'));
        $grid->column('Annex4', __('Annex4'));
        $grid->column('Annex5', __('Annex5'));
        $grid->column('Annex3Name', __('Annex3Name'));
        $grid->column('Annex4Name', __('Annex4Name'));
        $grid->column('Annex5Name', __('Annex5Name'));
        $grid->column('GiftToken', __('GiftToken'));

        $grid->disableActions();
        $grid->disableBatchActions();
        $grid->disableCreateButton();
        $grid->expandFilter();

        $grid->filter(function($filter){
            $filter->disableIdFilter();
            $currentTank = Auth::guard('admin')->user()->current_tank;
            $serverList = ServerList::where('TankConnection', $currentTank)->first();

            $filter->equal('SenderID','Người gửi')->select(function ($senderID) use ($serverList){
                $player = Player::on($serverList->Connection)->select('UserID','NickName')->find($senderID);
                if($player){
                    return [$player->UserID => $player->NickName];
                }
            })->ajax('api/get-list-player?server_id='.$serverList->ServerID);
            $filter->equal('ReceiverID','Người nhận')->select(function ($receiverID) use ($serverList){
                $player = Player::on($serverList->Connection)->select('UserID','NickName')->find($receiverID);
                if($player){
                    return [$player->UserID => $player->NickName];
                }
            })->ajax('api/get-list-player?server_id='.$serverList->ServerID);

        });
//        $grid->quickSearch( function($model, $query){
//            $model->whereHas('admin', function ($q) use ($query){
//                $q->where("name", 'like', '%'.$query.'%');
//            })->orWhere('MemberUserName', 'like', "%{$query}%")
//                ->orWhere('Value', 'like', "%{$query}%");
//        });
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
        $show = new Show(UserMessage::findOrFail($id));

        $show->field('ID', __('ID'));
        $show->field('SenderID', __('SenderID'));
        $show->field('Sender', __('Sender'));
        $show->field('ReceiverID', __('ReceiverID'));
        $show->field('Receiver', __('Receiver'));
        $show->field('Title', __('Title'));
        $show->field('Content', __('Content'));
        $show->field('SendTime', __('SendTime'));
        $show->field('IsRead', __('IsRead'));
        $show->field('IsDelR', __('IsDelR'));
        $show->field('IfDelS', __('IfDelS'));
        $show->field('IsDelete', __('IsDelete'));
        $show->field('Annex1', __('Annex1'));
        $show->field('Annex2', __('Annex2'));
        $show->field('Gold', __('Gold'));
        $show->field('Money', __('Money'));
        $show->field('IsExist', __('IsExist'));
        $show->field('Type', __('Type'));
        $show->field('Remark', __('Remark'));
        $show->field('ValidDate', __('ValidDate'));
        $show->field('Annex1Name', __('Annex1Name'));
        $show->field('Annex2Name', __('Annex2Name'));
        $show->field('SendDate', __('SendDate'));
        $show->field('Annex3', __('Annex3'));
        $show->field('Annex4', __('Annex4'));
        $show->field('Annex5', __('Annex5'));
        $show->field('Annex3Name', __('Annex3Name'));
        $show->field('Annex4Name', __('Annex4Name'));
        $show->field('Annex5Name', __('Annex5Name'));
        $show->field('AnnexRemark', __('AnnexRemark'));
        $show->field('GiftToken', __('GiftToken'));

        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new UserMessage());

        $form->number('SenderID', __('SenderID'));
        $form->text('Sender', __('Sender'));
        $form->number('ReceiverID', __('ReceiverID'));
        $form->text('Receiver', __('Receiver'));
        $form->text('Title', __('Title'));
        $form->text('Content', __('Content'));
        $form->datetime('SendTime', __('SendTime'))->default(date('Y-m-d H:i:s'));
        $form->switch('IsRead', __('IsRead'));
        $form->switch('IsDelR', __('IsDelR'));
        $form->switch('IfDelS', __('IfDelS'));
        $form->switch('IsDelete', __('IsDelete'));
        $form->text('Annex1', __('Annex1'));
        $form->text('Annex2', __('Annex2'));
        $form->number('Gold', __('Gold'));
        $form->number('Money', __('Money'));
        $form->switch('IsExist', __('IsExist'))->default(1);
        $form->number('Type', __('Type'));
        $form->text('Remark', __('Remark'));
        $form->number('ValidDate', __('ValidDate'))->default(240);
        $form->text('Annex1Name', __('Annex1Name'));
        $form->text('Annex2Name', __('Annex2Name'));
        $form->datetime('SendDate', __('SendDate'))->default(date('Y-m-d H:i:s'));
        $form->text('Annex3', __('Annex3'));
        $form->text('Annex4', __('Annex4'));
        $form->text('Annex5', __('Annex5'));
        $form->text('Annex3Name', __('Annex3Name'));
        $form->text('Annex4Name', __('Annex4Name'));
        $form->text('Annex5Name', __('Annex5Name'));
        $form->text('AnnexRemark', __('AnnexRemark'));
        $form->number('GiftToken', __('GiftToken'));

        return $form;
    }
}
