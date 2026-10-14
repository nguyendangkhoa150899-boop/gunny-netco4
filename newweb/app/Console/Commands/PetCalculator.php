<?php

namespace App\Console\Commands;

use App\InGame\PetAbstractInventory;
use App\InGame\PetMgr;
use App\InGame\UserPetInfo;
use App\Models\PetTemplateInfo;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use App\Models\OnlineReport;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

class PetCalculator extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'petcalculator';

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
        $pet = new UserPetInfo();
        $pet->Level = 50;
        $pet->BloodGrow = 12000;
        $pet->AttackGrow = 1510;
        $pet->DefenceGrow = 850;
        $pet->AgilityGrow = 910;
        $pet->LuckGrow = 850;
        $pet->BuildProp();
        echo $pet->getBlood() . ' - '.$pet->getAttack() . ' - '.$pet->getDefence() . ' - '.$pet->getAgility() . ' - '.$pet->getLuck();
        return true;
    }


}
