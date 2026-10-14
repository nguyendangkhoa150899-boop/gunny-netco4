<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class EventRewardInfo extends Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_tank';
    protected $table = 'Event_Reward_Info';
    protected $primaryKey = 'ID';

    protected $fillable = ['ActivityType', 'SubActivityType', 'Condition'];

    public $timestamps = false;
    public $incrementing = true;

    public function __construct(array $attributes = [])
    {
        parent::__construct($attributes);
    }

    public function Activity()
    {
        return $this->belongsTo(EventReward::class, 'ActivityType', 'ID');
    }

    public function getCondictionText()
    {
        $text = $this->RewardCondiction->Label;
        return str_replace('{0}', $this->Condition, $text);
    }

    public function RewardCondiction()
    {
        return $this->belongsTo(EventRewardCondiction::class, 'ActivityType', 'ID');
    }
}
