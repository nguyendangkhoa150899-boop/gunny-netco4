<?php

namespace App\Admin\Forms;

use App\ActiveAward;
use Encore\Admin\Grid;
use Encore\Admin\Widgets\Form;
use Illuminate\Http\Request;
use Encore\Admin\Widgets\Table;

class AddActiveWithItem extends Form
{
    /**
     * The form title.
     *
     * @var string
     */
    public $title = 'Thêm hoạt động (Giftcode)';

    /**
     * Handle the form request.
     *
     * @param Request $request
     *
     * @return \Illuminate\Http\RedirectResponse
     */
    public function handle(Request $request)
    {

        admin_success('Processed successfully.');

        return back();
    }

    /**
     * Build a form here.
     */
    public function form()
    {
        $this->number('ActiveID')->rules('required|unique:sqlsrv_tank.Active', ['unique'=>'Mã hoạt động (GiftCode) đã được sử dụng'])->style('width','100%')->placeHolder('Nhập vào ID Hoạt động')->required(true);

        $this->text('Title', __('Tiêu đề'))->required(true)->placeHolder('Nhập tiêu đề Giftcode');
        $this->text('Description', __('Mô tả'))->placeHolder('Nhập mô tả');
        $this->text('Content', __('Nội dung'))->placeHolder('Nhập nội dung');
        $this->textarea('AwardContent', __('Phần thưởng'))->help('Mỗi phần thưởng 1 dòng.')->placeHolder('Nhập nội dung phần thưởng')->required(true);
        $this->hidden('HasKey', __('HasKey'))->default(1);
        $this->date('StartDate', __('Ngày mở'))->default(date('Y-m-d H:i:s'))->required(true);
        $this->date('EndDate', __('Ngày đóng'))->default(date('Y-m-d H:i:s'))->required(true);
        $this->date('ActionTimeContent', __('ActionTimeContent'))->format('DD/MM/YYYY')->style('width','100%')->required(true)->placeHolder('Nhập vào ActionTimeContent');
        $states = [
            'on' => ['value' => 1, 'text' => 'Chỉ một lần'],
            'off' => ['value' => 0, 'text' => 'Nhận nhiều lần', 'color' => 'danger'],
        ];
        $this->switch('IsOnly', __('Nhận 1 lần'))->states($states)->default(1);
        $this->radio('Type', 'Hình thức nhận')->options([1 => 'Nhập Giftcode', 3 => 'Nhận tự do'])->default(1)->required(true);//            $this->number('Type', __('Type'))->required(true);
        $this->hidden('IsAdvance', __('IsAdvance'))->default(0);

        $this->hidden('ActiveType', __('ActiveType'))->default(0);
        $this->hidden('IconID', __('IconID'))->default(0);
        $this->switch('CanGetCode', __('CanGetCode'))->help('Này chưa biết là gì');
        $this->text('CodePrefix', __('Tiền tố GiftCode'));
        $this->divider('Phần thưởng');


        $this->table('s', 'Phần thưởng', function ($form) {

            $form->text('name');
            $form->email('email');
            $form->ip('ip');
        });


    }

    /**
     * The data of the form.
     *
     * @return array $data
     */
    public function data()
    {
        return [
            'name'       => 'John Doe',
            'email'      => 'John.Doe@gmail.com',
            'created_at' => now(),
        ];
    }
}
