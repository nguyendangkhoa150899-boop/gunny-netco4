<?php

namespace App\Admin\Forms;

use App\Player;
use Encore\Admin\Widgets\Form;
use Illuminate\Http\Request;

class Test extends Form
{
    /**
     * The form title.
     *
     * @var string
     */
    public $title = 'Chỉnh sửa nhân vật';

    /**
     * Handle the form request.
     *
     * @param Request $request
     *
     * @return \Illuminate\Http\RedirectResponse
     */
    public function handle(Request $request)
    {
        //dump($request->all());

        admin_success('Processed successfully.');

        return back();
    }

    /**
     * Build a form here.
     */
    public function form()
    {
        $this->text('UserName')->rules('required');
        $this->email('email')->rules('email');
        $this->datetime('created_at');
    }

    /**
     * The data of the form.
     *
     * @return array $data
     */
    public function data()
    {
        $player = Player::on('sqlsrv_tank41')->select('UserName', 'NickName')->where("UserName", 'huyne123')->first();

        return [
            'UserName'       => $player->UserName,
            'email'      => 'John.Doe@gmail.com',
            'created_at' => now(),
        ];
    }
}
