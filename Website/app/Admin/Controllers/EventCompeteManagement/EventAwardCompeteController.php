<?php

namespace App\Admin\Controllers\EventCompeteManagement;

use App\EventAwardCompete;
use App\EventCompete;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;
use Illuminate\Http\Request;

class EventAwardCompeteController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Phần thưởng sự kiện';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
//        $e = EventAwardCompete::with(['EventCompete'])->get();
//        dd($e);
        $event_compete_id = Request::capture()->input('event_compete_id');
        $competes = EventCompete::with('EventCategory')->get();
        $eventsCompete = [];
        foreach ($competes as $compete){
            $eventsCompete[$compete->id] = '['.$compete->EventCategory->category_name.'] '.$compete->EventType->type_name; };

        $grid = new Grid(new EventAwardCompete());

        $grid->column('id', __('Id'));
        $grid->column('event_compete_id', __('[Danh mục] & TOP'))->display(function (){
            return '['.$this->EventCompete->EventCategory->category_name.'] '.$this->EventCompete->EventType->type_name;
        });
        $a = []; for($i = 1; $i <= 10; $i++){$a[$i]= "Top $i"; }
        $grid->column('rank', __('Thứ hạng'))->filter($a);
        $grid->column('_ImageItem_', __('Hình ảnh'))->display(function (){
            return $this->ResourceImageColumn();
        });
        $grid->column('Item.Name', __('Tên vật phẩm'));
        $grid->column('amount', __('Số lượng'));
        $grid->column('date', __('Hạn'));
        $grid->column('strengthen', __('Cường hoá'));
        $grid->column('composes', __('Chỉ số'));

//        $grid->disableCreateButton();
        $grid->expandFilter();
        $grid->filter(function ($filter) use ($eventsCompete){
            $filter->disableIdFilter();

            $filter->equal('event_compete_id', 'Lựa chọn sự kiện')->select($eventsCompete);
        });

        $grid->quickCreate(function (Grid\Tools\QuickCreate $create) use ($eventsCompete, $event_compete_id){
            $create->select('event_compete_id','Sự kiện')->options($eventsCompete)->default($event_compete_id);
            $create->text('rank','Thứ hạng');
            $create->select('item_id','Vật phẩm')->ajax('/admin/api/load-item');
            $create->text('amount','Số lượng');
            $create->text('date','Hạn');
            $create->text('strengthen','Cường hoá');
            $create->text('composes','Chỉ số');
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
        $show = new Show(EventAwardCompete::findOrFail($id));

        $show->field('id', __('Id'));
        $show->field('event_compete_id', __('Event compete id'));
        $show->field('rank', __('Rank'));
        $show->field('item_id', __('Item id'));
        $show->field('amount', __('Amount'));
        $show->field('date', __('Date'));
        $show->field('strengthen', __('Strengthen'));
        $show->field('composes', __('Composes'));
        $show->field('created_at', __('Created at'));
        $show->field('updated_at', __('Updated at'));

        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $competes = EventCompete::with('EventCategory')->get();
        $eventsCompete = []; foreach ($competes as $compete){ $eventsCompete[$compete->id] = '['.$compete->EventCategory->category_name.'] '.$compete->event_name; };


        $form = new Form(new EventAwardCompete());

        $form->select('event_compete_id', __('Danh mục sự kiện'))->options($eventsCompete);
        $form->number('rank', __('Thứ hạng'))->width('100%')->placeholder('(từ 1 đến 10)');
        $form->select('item_id', __('Vật phẩm'))->ajax('/admin/api/load-item');
        $form->number('amount', __('số lượng'))->width('100%')->placeholder('Số lượng vật phẩm');
        $form->number('date', __('Hạn'))->width('100%')->placeholder('Thời hạn dùng (0 => Vĩnh viễn)');
        $form->number('strengthen', __('Cường hoá'))->width('100%')->placeholder('Cường hoá: (VD: 12)');
        $form->text('composes', __('Chỉ số'))->width('100%')->placeholder('Chỉ số (VD: 50-50-50-50)');

        return $form;
    }
}
