<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class EventRewardInfo extends Model
{
    protected $connection = 'sqlsrv_tank';
    protected $table = 'Event_Reward_Info';
    protected $primaryKey = 'ActivityType';

    protected $fillable = ['ActivityType', 'SubActivityType', 'Condition'];

    protected $appends = ['fake'];

//    protected $attributes = [ 'fake_primary' => ''];

    public $timestamps = false;
    public $incrementing = false;

    public function __construct(array $attributes = [])
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;
        $this->connection = $currentTank;
        parent::__construct($attributes);
    }

    public function getActivityTypeText()
    {
        switch ($this->ActivityType){
            case 1:
                return 'Mốc level ';
            case 2:
                return 'Mốc cường hoá';
            case 3:
                return 'Mốc tiêu xu';
            case 4:
                return 'Mốc nạp xu';
            case 5:
                return 'Mốc level VIP';
            case 6:
                return 'Mốc quà lực chiến';
            case 7:
                return 'Mốc Nạp xu đặc biệt';
            case 8:
                return 'Mốc Tiêu xu đặc biệt';
            case 9:
                return 'Nạp lần đầu';
        }
    }

    public function getFakeAttribute()
    {
        return $this->ActivityType.'-'.$this->SubActivityType.'-'.$this->Condition;
    }

    /**
     * @param string $primaryKey
     */
    public function setPrimaryKey(string $primaryKey): void
    {
        $this->primaryKey = $primaryKey;
    }

    /**
     * @return string
     */
    public function getPrimaryKey(): string
    {
        return $this->primaryKey;
    }
}
