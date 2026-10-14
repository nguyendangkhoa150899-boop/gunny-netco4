<?php

namespace App\Console\Commands;

use App\InGame\PetAbstractInventory;
use App\InGame\PetMgr;
use App\Models\PetTemplateInfo;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use App\Models\OnlineReport;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

class PetEvolutions extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'petevolutions';

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
        $activeWorksheet->setCellValue(($col++).'1', 'Tên pet');
        $activeWorksheet->setCellValue(($col++).'1', 'Số sao');
        $activeWorksheet->setCellValue(($col++).'1', 'Cấp');
        $activeWorksheet->setCellValue(($col++).'1', 'Máu');
        $activeWorksheet->setCellValue(($col++).'1', 'Tấn công');
        $activeWorksheet->setCellValue(($col++).'1', 'Phòng thủ');
        $activeWorksheet->setCellValue(($col++).'1', 'Nhanh nhẹn');
        $activeWorksheet->setCellValue(($col++).'1', 'May mắn');

        $petTemps = PetTemplateInfo::where('StarLevel', '=', 5)
//            ->whereIn('KindID', [9, 11])
            ->get();
        $row = 2;
        foreach ($petTemps as $petTemp) {
            if ($petTemp->TemplateID % 10 != 1) {
                continue;
            }
            $petMin = PetMgr::CreatePet($petTemp, 1);
            $petMax = PetMgr::CreatePet($petTemp, 2);
            $a1 = $this->changeIntoMinMax($petMin, $petMax);
            $col = 'A';
            $activeWorksheet->setCellValue(($col++) . $row, $petTemp->Name);
            $activeWorksheet->setCellValue(($col++) . $row, $petTemp->StarLevel);
            $activeWorksheet->setCellValue(($col++) . $row, '1 - 29');
            $activeWorksheet->setCellValue(($col++) . $row, $a1['Blood']);
            $activeWorksheet->setCellValue(($col++) . $row, $a1['Attack']);
            $activeWorksheet->setCellValue(($col++) . $row, $a1['Defence']);
            $activeWorksheet->setCellValue(($col++) . $row, $a1['Agility']);
            $activeWorksheet->setCellValue(($col++) . $row, $a1['Luck']);
            $row++;
            $_petMin = clone($petMin);
            $_petMax = clone($petMax);
            $petMin30 = PetAbstractInventory::UpdateEvolutionPet($_petMin, 30, 50, 9, 1);
            $petMax30 = PetAbstractInventory::UpdateEvolutionPet($_petMax, 30, 50, 9, 2);
            $a2 = $this->changeIntoMinMax($petMin30, $petMax30);
            $col = 'A';
            $activeWorksheet->setCellValue(($col++) . $row, $petTemp->Name);
            $activeWorksheet->setCellValue(($col++) . $row, $petTemp->StarLevel);
            $activeWorksheet->setCellValue(($col++) . $row, '30 - 49');
            $activeWorksheet->setCellValue(($col++) . $row, $a2['Blood']);
            $activeWorksheet->setCellValue(($col++) . $row, $a2['Attack']);
            $activeWorksheet->setCellValue(($col++) . $row, $a2['Defence']);
            $activeWorksheet->setCellValue(($col++) . $row, $a2['Agility']);
            $activeWorksheet->setCellValue(($col++) . $row, $a2['Luck']);
            $row++;
            $_petMin = clone($petMin);
            $_petMax = clone($petMax);
            $petMin50 = PetAbstractInventory::UpdateEvolutionPet($_petMin, 50, 50, 9, 1);
            $petMax50 = PetAbstractInventory::UpdateEvolutionPet($_petMax, 50, 50, 9, 2);
            $a3 = $this->changeIntoMinMax($petMin50, $petMax50);
            $col = 'A';
            $activeWorksheet->setCellValue(($col++) . $row, $petTemp->Name);
            $activeWorksheet->setCellValue(($col++) . $row, $petTemp->StarLevel);
            $activeWorksheet->setCellValue(($col++) . $row, '50');
            $activeWorksheet->setCellValue(($col++) . $row, $a3['Blood']);
            $activeWorksheet->setCellValue(($col++) . $row, $a3['Attack']);
            $activeWorksheet->setCellValue(($col++) . $row, $a3['Defence']);
            $activeWorksheet->setCellValue(($col++) . $row, $a3['Agility']);
            $activeWorksheet->setCellValue(($col++) . $row, $a3['Luck']);
            $row++;
        }

        $writer = new Xlsx($spreadsheet);
        $writer->save('Pet_Props_5stars.xlsx');
        return true;
    }

    private function changeIntoMinMax($petMin, $petMax)
    {
        $returnval = [
            'Blood' => '',
            'Attack' => '',
            'Defence' => '',
            'Agility' => '',
            'Luck' => '',
        ];
        $returnval['Blood'] = ($petMin->BloodGrow/100) . ' - '.($petMax->BloodGrow/100);
        $returnval['Attack'] = ($petMin->AttackGrow/100) . ' - '.($petMax->AttackGrow/100);
        $returnval['Defence'] = ($petMin->DefenceGrow/100) . ' - '.($petMax->DefenceGrow/100);
        $returnval['Agility'] = ($petMin->AgilityGrow/100) . ' - '.($petMax->AgilityGrow/100);
        $returnval['Luck'] = ($petMin->LuckGrow/100) . ' - '.($petMax->LuckGrow/100);
        return $returnval;
    }
}
