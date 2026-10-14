<?php
namespace App\InGame;

class PetAbstractInventory
{
    /**
     * @param UserPetInfo $pet
     * @param $level
     * @param $maxLevel
     * @param $vipLv
     * @param int $ceil
     * @return UserPetInfo
     */
    public static function UpdateEvolutionPet($pet, $level, $maxLevel, $vipLv, $ceil = 1)
    {
        $timeLoop = 1;
        $tempID = PetMgr::UpdateEvolution($pet->TemplateID, $level, $timeLoop);
        if ($tempID > $pet->TemplateID) {
            $pet->TemplateID = $tempID;
            $pet->Level = $level;
            $tempInfo = PetMgr::FindPetTemplate($tempID);
            if ($tempInfo != null) {
                for ($i = 0; $i < $timeLoop; $i++) {
                    $propArr = null;
                    $growArr = null;
                    PetMgr::GetEvolutionPropArr($pet, $tempInfo, $propArr, $growArr);
                    if ($propArr != null && $growArr != null) {
                        $minRate = $tempInfo->RareLevel * 0.1;
                        if ($minRate < $growArr[0])
                            $pet->BloodGrow += (int)(self::GetRandomDouble($minRate, $growArr[0], $ceil) * 10);
                        if ($minRate < $growArr[1])
                            $pet->AttackGrow += (int)(self::GetRandomDouble($minRate, $growArr[1], $ceil) * 10);
                        if ($minRate < $growArr[2])
                            $pet->DefenceGrow += (int)(self::GetRandomDouble($minRate, $growArr[2], $ceil) * 10);
                        if ($minRate < $growArr[3])
                            $pet->AgilityGrow += (int)(self::GetRandomDouble($minRate, $growArr[3], $ceil) * 10);
                        if ($minRate < $growArr[4])
                            $pet->LuckGrow += (int)(self::GetRandomDouble($minRate, $growArr[4], $ceil) * 10);
                    }
                }
            }
        }
        $pet->BuildProp($pet);
        return $pet;
    }

    public static function GetRandomDouble($min, $max, $ceil = 1)
    {
        return minmax($min, $max, $ceil);
    }
}
