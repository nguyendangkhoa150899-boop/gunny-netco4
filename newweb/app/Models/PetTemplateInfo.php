<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class PetTemplateInfo extends Model
{
    use CrudTrait;

    protected $connection = 'sqlsrv_tank';

    protected $table = 'Pet_Template_Info';
    protected $primaryKey = 'TemplateID';
    public $timestamps = false;
    protected $fillable = ['TemplateID', 'Name', 'KindID', 'Description', 'Pic', 'RareLevel', 'MP', 'StarLevel', 'GameAssetUrl', 'EvolutionID', 'HighAgility', 'HighAgilityGrow', 'HighAttack', 'HighAttackGrow', 'HighBlood', 'HighBloodGrow', 'HighDamage', 'HighDamageGrow', 'HighDefence', 'HighDefenceGrow', 'HighGuard', 'HighGuardGrow', 'HighLuck', 'HighLuckGrow', 'WashGetCount'];
    public $autoincrement = false;

}
