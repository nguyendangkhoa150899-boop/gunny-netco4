<?php

namespace App\Admin\Actions\Player;

use Encore\Admin\Actions\RowAction;
use Illuminate\Http\Request;

class RedirectEditAction extends RowAction
{
    protected $selector = '.redirect-edit-action';
    public $name = "Chỉnh sửa";
    private $server;
    public function __construct($server)
    {
        $this->server = $server;
    }

    /**
     * @return  string
     */
    public function href()
    {
        return $this->getResource().'/'.$this->getKey() .'/edit?server='.$this->server->ServerID;
    }

    public function html()
    {
        return <<<HTML
        <a class="btn btn-sm btn-default redirect-edit-action"></a>
HTML;
    }
}
