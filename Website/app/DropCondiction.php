<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class DropCondiction extends Model
{
    protected $connection = 'sqlsrv_tank';

    protected $table = 'Drop_Condiction';
    protected $primaryKey = 'DropID';
    protected $fillable = ['DropID', 'CondictionType', 'Para1', 'Para2', 'Detail'];
    protected $appends = ['para'];

    public $timestamps = false;
    public $incrementing = false;

    public function __construct(array $attributes = [])
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $this->connection = $currentTank;
        parent::__construct($attributes);
    }


    public function DropItem()
    {
        return $this->hasMany('App\DropItem','DropID','DropID');
    }

    public function getParaAttribute()
    {
        $missionInfo = MissionInfo::all();
        $para1 = $this->Para1;
        $missions = "";
        $returnText = null;

        if($para1){
            $param1 = ltrim($para1, ',');
            $param1 = rtrim($para1, ',');
            $missions = explode(",", $param1);
        }

        foreach ($missionInfo as $mission){
            if(in_array($mission->Id, $missions)){
                $returnText .= $mission->Name.'<br>';
            }
        }
        return $returnText;
    }
}
