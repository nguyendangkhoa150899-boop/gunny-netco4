<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class ConsortiaTaskConfig extends Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_tank';
    protected $table = 'Consortia_TaskConfig';
    protected $primaryKey = 'ID';

    protected $fillable = ['Level', 'CondictionTitle', 'CondictionType', 'Para1', 'Para2'];

    public $timestamps = false;
    public $incrementing = true;

    public function __construct(array $attributes = [])
    {
        parent::__construct($attributes);
    }

    public function GuildLevel()
    {
        return $this->belongsTo(ConsortiaLevel::class, 'Level', 'Level');
    }

    public function CondictionTypeText()
    {
        return '('.$this->CondictionType.') '.QuestCondiction::CondictionText($this->CondictionType);
    }
}
