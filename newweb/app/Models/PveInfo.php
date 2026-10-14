<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

class PveInfo extends Model
{
    use CrudTrait;

    /*
    |--------------------------------------------------------------------------
    | GLOBAL VARIABLES
    |--------------------------------------------------------------------------
    */
    protected $connection = 'sqlsrv_tank';

    protected $table = 'Pve_Info';
    protected $primaryKey = 'ID';
    public $timestamps = false;
    protected $fillable = ['ID', 'Name', 'Type', 'LevelLimits', 'SimpleTemplateIds', 'NormalTemplateIds', 'HardTemplateIds', 'TerrorTemplateIds', 'Pic', 'Description', 'SimpleGameScript', 'NormalGameScript', 'HardGameScript', 'TerrorGameScript', 'Ordering', 'AdviceTips', 'BossFightNeedMoney', 'FightPower', 'Disabled', 'CanOpenBoss'];
    public $autoincrement = false;
    protected $attributes = [
        'Disabled' => 0,
        'CanOpenBoss' => 0,
    ];
    private $scriptsPath;

    public function __construct(array $attributes = [])
    {
        $this->scriptsPath = resource_path('scripts');
        parent::__construct($attributes);
    }

    /*
    |--------------------------------------------------------------------------
    | FUNCTIONS
    |--------------------------------------------------------------------------
    */
    public static function PveTypes()
    {
        return [
            4 => "Phó bản",
            5 => "Phòng tập",
            6 => "Phó bản đặc biệt",
            10 => "Khác",
        ];
    }

    public function getTypeText()
    {
        return self::PveTypes()[$this->Type];
    }

    private function getGameMissions($property)
    {
        $simpleScriptPath = str_replace('GameServerScript', '', $property);
        $simpleScriptPath = str_replace('.', DIRECTORY_SEPARATOR, $simpleScriptPath);
        $simpleScriptPath .= '.cs';
        if (!file_exists($this->scriptsPath . $simpleScriptPath)) {
            return false;
        }
        $scriptContent = file_get_contents($this->scriptsPath . $simpleScriptPath);
        preg_match('/Game\.SetupMissions\(".+/', $scriptContent, $matches);
        if (!empty($matches)) {
            $gameMission = $matches[0];
            $gameMissions = str_replace('Game.SetupMissions("', '', $gameMission);
            $gameMissions = str_replace('");', '', $gameMissions);
            $gameMissions = explode(',', $gameMissions);
            return array_map(function ($a) {
                return trim($a);
            }, $gameMissions);
        }
        return [];
    }

    public function getPveMissions($script)
    {
        if (empty($script)) {
            return null;
        }
        $gameMissions = $this->getGameMissions($script);
        if (empty($gameMissions)) {
            return $gameMissions;
        }
        $missions = new Collection();
        foreach ($gameMissions as $gameMission) {
            $mission = PveInfoMissions::find($gameMission);
            $missions->push($mission);
        }
        return $missions;
    }

    public function SimpleMissions()
    {
        return $this->getPveMissions($this->SimpleGameScript);
    }

    public function NormalMissions()
    {
        return $this->getPveMissions($this->NormalGameScript);
    }

    public function HardMissions()
    {
        return $this->getPveMissions($this->HardGameScript);
    }

    public function TerrorMissions()
    {
        return $this->getPveMissions($this->TerrorGameScript);
    }

    /*
    |--------------------------------------------------------------------------
    | RELATIONS
    |--------------------------------------------------------------------------
    */


    /*
    |--------------------------------------------------------------------------
    | SCOPES
    |--------------------------------------------------------------------------
    */

    /*
    |--------------------------------------------------------------------------
    | ACCESSORS
    |--------------------------------------------------------------------------
    */


    /*
    |--------------------------------------------------------------------------
    | MUTATORS
    |--------------------------------------------------------------------------
    */
}
