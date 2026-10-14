<?php

namespace App\Admin\Forms;

use App\Player;
use App\ServerList;
use Doctrine\DBAL\Connection;
use Encore\Admin\Form\Row;
use Encore\Admin\Widgets\Form;
use Illuminate\Http\Request;
Use Encore\Admin\Admin;

class SendItemForm extends Form
{
    /**
     * The form title.
     *
     * @var string
     */
    public $title = '';
    private $gf= '';
    /**
     * Handle the form request.
     *
     * @param Request $request
     *
     * @return \Illuminate\Http\RedirectResponse
     */
    public function handle(Request $request)
    {
//        $number_of_items = $request->number_of_items;
        $serverList = ServerList::all();
        $players = [];
        $connection = "";
//        $baseurl = trim(env('REQUEST_URL'), '/').'/SendMailAndItem.aspx';
        foreach ($serverList as $server)
        {
            if($request->input("User_$server->ServerID") != null){
                $connection = $server->Connection;
                $players = $request->input("User_$server->ServerID");
                $baseurl = $server->LinkRequest.'SendMailAndItem.aspx';
            }
        }
        array_pop($players); //remove NULL by Mutiple select element

        $title = $request->input('mail_title');
        $content = $request->input('mail_content');
        $gold = $request->input('gold');
        $money = $request->input('money');
        $items = $request->input('items');

        if($items == null)
            $items = [];

        $number_of_mail = floor(count($items) / 5) + 1;
        $uri = '?title='.urlencode($title).'&content='.urlencode($content);
        $error = [];
        $itemKeys = array_keys($items);
        foreach ($players as $player_id) {
			if (empty($player_id)) {
				continue;
			}
            $player = Player::on($connection)->select('UserID')->where('UserID', (int) $player_id)->first(); //On connection
            if (empty($player)) {
                continue;
            }
            $url = $baseurl.$uri.'&user_id='.$player_id;
            for ($mail_num = 0; $mail_num < $number_of_mail; $mail_num++) {
                $_uri = $url;
                if ($mail_num == 0) {
                    $_uri .= '&gold='.$gold.'&money='.$money;
                } else {
                    $_uri .= '&gold=0&money=0';
                }
                $_uri .= '&str=';
                for ($item_num = max($mail_num * 5, 0); $item_num < min(($mail_num+1) * 5, count($items)); $item_num++) {
                    $item = $items[$itemKeys[$item_num]];

                    if (empty($item['id'])) {
                        continue;
                    }
                    if (is_array($item['id'])) {
                        $item['id'] = $item['id'][0];
                    }
                    $item_param = [
                        $item['id'],
                        max(intval($item['count']), 1),
                        intval($item['date']),
                        intval($item['strength']),
                        intval($item['attack']),
                        intval($item['defend']),
                        intval($item['agility']),
                        intval($item['luck']),
                        intval($item['bind']),
                    ];
                    $_uri .= implode(',', $item_param).'|';
                }
                //echo $_uri.'<br>';
                //return;
                $result = file_get_contents($_uri);
				//echo $result;
				//return;
                if ($result !== "1") {
                    $error[] = "Lỗi nhân vật ".$player->NickName;
                }
            }
        }
        if (!empty($error)) {
            admin_error('Đã có lỗi trong quá trình gửi thư. '.implode('<br>', $error));
//            echo json_encode(['success' => false, 'message' => implode('<br>', $error)]);
            return back();
        }
        admin_success('Gửi thư thành công.');
//        echo json_encode(['success' => true, 'message' => '']);
        return back();
    }

    /**
     * Build a form here.
     */
    public function form()
    {

        Admin::script('
        $(".select-server").on("change", function(){
            let serverIdSelected = $(".select-server").find(":selected").val();
            console.log(serverIdSelected);
        });');

        $this->html('<h4>Chọn nhân vật / Tài khoản nhận thư</h4>');
        $servers = ServerList::select('ServerID', 'Connection','ServerName')->get();
        $serverList = [];
        $serverIdList = [];
        foreach ($servers as $server)
        {
            array_push($serverIdList, $server->ServerID);
            $serverList[$server->ServerID] = $server->ServerName;
        }
        //FIXED 10 SERVER BY 1001 -> 1010 (Refactor after laravel-admin update get value selected at linkage component)
        $this->select('_Server_','Chọn máy chủ')
            ->options($serverList)
            ->when(1001, function (Form $form) {
                $form->multipleSelect('User_1001','Tài khoản: ')->placeholder('Nhập vào tên nhân vật hoặc tên tài khoản để tìm kiếm')->ajax('api/get-list-player?server_id=1001');
            })->when(1002, function (Form $form) {
                $form->multipleSelect('User_1002','Tài khoản: ')->placeholder('Nhập vào tên nhân vật hoặc tên tài khoản để tìm kiếm')->ajax('api/get-list-player?server_id=1002');
            })->when(1003, function (Form $form) {
                $form->multipleSelect('User_1003','Tài khoản: ')->placeholder('Nhập vào tên nhân vật hoặc tên tài khoản để tìm kiếm')->ajax('api/get-list-player?server_id=1003');
            })->when(1004, function (Form $form) {
                $form->multipleSelect('User_1004','Tài khoản: ')->placeholder('Nhập vào tên nhân vật hoặc tên tài khoản để tìm kiếm')->ajax('api/get-list-player?server_id=1004');
            })->when(1005, function (Form $form) {
                $form->multipleSelect('User_1005','Tài khoản: ')->placeholder('Nhập vào tên nhân vật hoặc tên tài khoản để tìm kiếm')->ajax('api/get-list-player?server_id=1005');
            })->when(1006, function (Form $form) {
                $form->multipleSelect('User_1006','Tài khoản: ')->placeholder('Nhập vào tên nhân vật hoặc tên tài khoản để tìm kiếm')->ajax('api/get-list-player?server_id=1006');
            })->when(1007, function (Form $form) {
                $form->multipleSelect('User_1007','Tài khoản: ')->placeholder('Nhập vào tên nhân vật hoặc tên tài khoản để tìm kiếm')->ajax('api/get-list-player?server_id=1007');
            })->when(1008, function (Form $form) {
                $form->multipleSelect('User_1008','Tài khoản: ')->placeholder('Nhập vào tên nhân vật hoặc tên tài khoản để tìm kiếm')->ajax('api/get-list-player?server_id=1008');
            })->when(1009, function (Form $form) {
                $form->multipleSelect('User_1009','Tài khoản: ')->placeholder('Nhập vào tên nhân vật hoặc tên tài khoản để tìm kiếm')->ajax('api/get-list-player?server_id=1009');
            })->when(1010, function (Form $form) {
                $form->multipleSelect('User_1010','Tài khoản: ')->placeholder('Nhập vào tên nhân vật hoặc tên tài khoản để tìm kiếm')->ajax('api/get-list-player?server_id=1010');
            })->help('ServerID phải nằm trong khoản từ 1001 -> 1010 (Tối đa 10 Server)');

        $this->divider();
        $this->html('<h4>Thông tin gửi thư</h4>');
        $this->text('mail_title','Tiêu đề')->default('Thư gửi từ hệ thống')->rules('required');
        $this->text('mail_content','Nội dung gửi thư')
            ->default('Đây là thư được gửi từ hệ thống, vui lòng không replay')->rules('required');
        $this->html('<div class="col-lg-6">

        </div>');
        $this->number('money','Xu')->default(0)->required();
        $this->number('gold','Vàng')->default(0)->required();
        $this->divider();

        $this->table('items', 'VẬT PHẨM', function ($form) {
            $form->select('id', 'Chọn vật phẩm cần gửi cho tài khoản tương ứng')
                ->options()->ajax('/admin/api/load-item');

            $form->radio('bind', 'Khoá vật phẩm')->options([0 => 'Không khoá', 1=> 'Khoá'])->default(1);
            $form->text('date','Hạn')->withoutIcon()->width('100px')->default(0);
            $form->text('count','Số lượng')->withoutIcon()->width('100px')->default(1);
            $form->text('strength','Cường Hoá')->withoutIcon()->width('100px')->default(0);
            $form->text('attack','Tấn Công')->withoutIcon()->width('100px')->default(0);
            $form->text('defend','Phòng Thủ')->withoutIcon()->width('100px')->default(0);
            $form->text('agility','Nhanh Nhẹn')->withoutIcon()->width('100px')->default(0);
            $form->text('luck','May mắn')->withoutIcon()->width('100px')->default(0);
            $form->ignore('_remove_');
        })->setWidth(12);
        Admin::style('#has-many-items {overflow-x: auto;width: 100%;}');


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
