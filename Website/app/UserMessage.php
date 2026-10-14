<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class UserMessage extends Model
{
    protected $connection = 'sqlsrv_tank41';

    protected $table = 'User_Messages';
    protected $primaryKey = 'ID';
    protected $fillable = ['ID', 'SenderID', 'Sender', 'ReceiverID', 'Receiver', 'Title', 'Content', 'SendTime', 'IsRead', 'IsDelR', 'IfDelS', 'IsDelete', 'Annex1', 'Annex2', 'Gold', 'Money', 'IsExist', 'Type', 'Remark', 'ValidDate', 'Annex1Name', 'Annex2Name', 'SendDate', 'Annex3', 'Annex4', 'Annex5', 'Annex3Name', 'Annex4Name', 'Annex5Name', 'AnnexRemark', 'GiftToken'];
    public $autoincrement = true;
    public $timestamps = false;

    public function __construct(array $attributes = [])
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $serverList = ServerList::where('TankConnection', $currentTank)->first();
        $this->connection = $serverList->Connection;
        parent::__construct($attributes);
    }


}
