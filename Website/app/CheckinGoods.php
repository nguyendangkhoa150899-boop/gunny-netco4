<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class CheckinGoods extends Model
{
    protected $connection = 'sqlsrv';
    protected $table = 'checkin_goods';
    protected $primaryKey = 'ID';
    protected $fillable = ['ItemID','Count','ValidDate','StrengthenLevel','AttackCompose','DefendCompose','LuckCompose','AgilityCompose','Gold','Money','Sex','Status'];
    public $timestamps = false;

    public function Item()
    {
        return $this->hasOne('App\FShopGoods', 'TemplateID', 'ItemID');
    }

    public function ResourceImageColumn()
    {
        return $this->Item->ResourceImageColumn();
    }

    public function combine4Column()
    {
        return $this->AttackCompose.'-'.$this->DefendCompose.'-'.$this->AgilityCompose.'-'.$this->LuckCompose;
    }

}
