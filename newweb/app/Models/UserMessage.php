<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class UserMessage extends Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_tank41';

    protected $table = 'User_Messages';
    protected $primaryKey = 'ID';
    protected $fillable = ['SenderID','Sender','ReceiverID','Receiver','Title','Content','SendTime','IsRead','IsDelR','IfDelS','IsDelete','Annex1','Annex2','Gold','Money','IsExist','Type','Remark','ValidDate','Annex1Name','Annex2Name','SendDate','Annex3','Annex4','Annex5','Annex3Name','Annex4Name','Annex5Name','AnnexRemark','GiftToken'];
    public $timestamps = false;
    public $incrementing = true;

    public function __construct(array $attributes = [])
    {
        parent::__construct($attributes);
    }


}
