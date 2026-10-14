<?php

namespace App\Console\Commands;

use App\InGame\PetAbstractInventory;
use App\InGame\PetMgr;
use App\InGame\UserPetInfo;
use App\Models\BallConfig;
use App\Models\PetTemplateInfo;
use App\Models\ShopGoods;
use Illuminate\Console\Command;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Support\Facades\DB;
use App\Models\OnlineReport;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

class ClothList extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'clothlist';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Excel of pet evolutions';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {
        $spreadsheet = new Spreadsheet();
        $activeWorksheet = $spreadsheet->getActiveSheet();
        $col = 'A';
        $activeWorksheet->setCellValue(($col++).'1', 'TemplateID');
        $activeWorksheet->setCellValue(($col++).'1', 'Name');
        $activeWorksheet->setCellValue(($col++).'1', 'BaseDamage');
        $activeWorksheet->setCellValue(($col++).'1', 'Damage');
        $activeWorksheet->setCellValue(($col++).'1', 'BallID');
        $activeWorksheet->setCellValue(($col++).'1', 'Power');
        $activeWorksheet->setCellValue(($col++).'1', 'BallCount');
        $weapons = ShopGoods::where('CategoryID', 7)
            ->get();
        $weapons = $weapons->sort(function ($a, $b) {
            if (strlen($a->TemplateID) == strlen($b->TemplateID)) {
                return $a->TemplateID - $b->TemplateID;
            }
            $temp = 0;
            if (strlen($a->TemplateID) > strlen($b->TemplateID)) {
                $temp = floor($a->TemplateID/10) - $b->TemplateID;
            }
            if (strlen($a->TemplateID) < strlen($b->TemplateID)) {
                $temp = $a->TemplateID - floor($b->TemplateID/10);
            }
            if ($temp == 0) {
                return strlen($a->TemplateID) - strlen($b->TemplateID);
            }
            return $temp;
        });
        $sortedWeapons = new Collection();

        $row = 2;
        foreach ($weapons as $weapon) {
            $ballCount = 0;
            $dmg = $this->MakeDamage($weapon->TemplateID, $specialBall);
            if (empty($specialBall)) {
                continue;
            }
            $col = 'A';
            $activeWorksheet->setCellValue(($col++) . $row, $weapon->TemplateID);
            $activeWorksheet->setCellValue(($col++) . $row, $weapon->Name);
            $activeWorksheet->setCellValue(($col++) . $row, $weapon->Property7);
            $activeWorksheet->setCellValue(($col++) . $row, $dmg);
            $activeWorksheet->setCellValue(($col++) . $row, $specialBall->ID);
            $activeWorksheet->setCellValue(($col++) . $row, $specialBall->Power);
            $activeWorksheet->setCellValue(($col++) . $row, $specialBall->Amount);
            $row++;
        }
        $writer = new Xlsx($spreadsheet);
        $writer->save('Weapons_pow_power.xlsx');
        return true;
    }
    public function MakeDamage($weapon_id, &$specialBall)
    {
        $m_owner = new owner();
        $target = new target();
        $baseDamage = $m_owner->BaseDamage;
		$baseGuard = $target->BaseGuard;
		$defence = $target->Defence;
		$attack = $m_owner->Attack;

        $damagePlus = $m_owner->CurrentDamagePlus();
        $specialBall = $m_owner->CurrentShootMinus($weapon_id);
        if (empty($specialBall)) {
            return 0;
        }
        $shootMinus = $specialBall->Power;
		$DR1 = 0.95 * ($baseGuard - 3 * $m_owner->Grade) / (500 + $baseGuard - 3 * $m_owner->Grade);
		$DR2 = $defence - $m_owner->Lucky >= 0.0 ? 0.95 * ($defence - $m_owner->Lucky) / (600.0 + $defence - $m_owner->Lucky) : 0;
		$DR3 = 0;
		$damage = ($DR3 + ($baseDamage * (1 + $attack * 0.001) * (1 - ($DR1 + $DR2 - $DR1 * $DR2)))) * $damagePlus * $shootMinus;
        return (int)$damage;
    }


}

class owner {
    public $BaseDamage = 1500;
    public $Attack = 4500;
    public $BaseGuard = 900;
    public $Grade = 58;
    public $Lucky = 4100;

    public function CurrentDamagePlus() {
        $value = 1.0;
        //3
        $value *= 0.9;
        //444
        $value += 0.5 + 0.5 + 0.5;
        return $value;
    }

    public function CurrentShootMinus($weapon_id) {
        $ballConfig = BallConfig::where('TemplateID', $weapon_id)->first();
        if (empty($ballConfig)) {
            echo "Ball notfound: " . $weapon_id."\n";
            return null;
        }
        $specialBall = $ballConfig->SpecialBall;
        //pow
        return $specialBall;
    }
}
class target extends owner {
    public $Defence = 4400;
}
