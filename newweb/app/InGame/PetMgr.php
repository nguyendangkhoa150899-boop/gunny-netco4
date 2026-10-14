<?php
namespace App\InGame;

use App\Models\PetTemplateInfo;

class PetMgr
{
    /**
     * @param UserPetInfo $_petInfo
     * @param PetTemplateInfo $petTempleteInfo
     * @param $propArr
     * @param $growArr
     */
    public static function GetEvolutionPropArr($_petInfo, $petTempleteInfo, &$propArr, &$growArr)
		{
			$numArray1 = [
                $_petInfo->getBlood() * 100,
                $_petInfo->getAttack() * 100,
                $_petInfo->getDefence() * 100,
                $_petInfo->getAgility() * 100,
                $_petInfo->getLuck() * 100
			];
            $numArray2 = [
                $_petInfo->BloodGrow,
                $_petInfo->AttackGrow,
                $_petInfo->DefenceGrow,
                $_petInfo->AgilityGrow,
                $_petInfo->LuckGrow,
			];
			$numArray3 = [
                $petTempleteInfo->HighBlood,
                $petTempleteInfo->HighAttack,
                $petTempleteInfo->HighDefence,
                $petTempleteInfo->HighAgility,
                $petTempleteInfo->HighLuck
			];
			$propArr2 = [
                $petTempleteInfo->HighBloodGrow,
                $petTempleteInfo->HighAttackGrow,
                $petTempleteInfo->HighDefenceGrow,
                $petTempleteInfo->HighAgilityGrow,
                $petTempleteInfo->HighLuckGrow
			];
			$numArray4 = $numArray3;
			$addedPropArr1 = self::GetAddedPropArr(1, $propArr2);
			$numArray5 = $numArray3;
			$addedPropArr2 = self::GetAddedPropArr(2, $propArr2);
			$numArray6 = $numArray3;
			$addedPropArr3 = self::GetAddedPropArr(3, $propArr2);
			if ($_petInfo->Level < 30)
            {
                for ($index3 = 0; $index3 < count($numArray4); $index3++)
				{
                    $numArray4[$index3] += (double)($_petInfo->Level - 1) * $addedPropArr1[$index3] - $numArray1[$index3];
                    $addedPropArr1[$index3] -= $numArray2[$index3];
                    $numArray4[$index3] = ceil($numArray4[$index3] / 10.0) / 10.0;
                    $addedPropArr1[$index3] = ceil($addedPropArr1[$index3] / 10.0) / 10.0;
                }
				$propArr = $numArray4;
				$growArr = $addedPropArr1;
			}
            else if ($_petInfo->Level < 50)
            {
                for ($index2 = 0; $index2 < count($numArray5); $index2++)
				{
                    $numArray5[$index2] += (double)($_petInfo->Level - 30) * $addedPropArr2[$index2] + 29.0 * $addedPropArr1[$index2] - $numArray1[$index2];
                    $addedPropArr2[$index2] -= $numArray2[$index2];
                    $numArray5[$index2] = ceil($numArray5[$index2] / 10.0) / 10.0;
                    $addedPropArr2[$index2] = ceil($addedPropArr2[$index2] / 10.0) / 10.0;
                }
				$propArr = $numArray5;
				$growArr = $addedPropArr2;
			}
            else
            {
                for ($index = 0; $index < count($numArray6); $index++)
				{
                    $numArray6[$index] += (double)($_petInfo->Level - 50) * $addedPropArr3[$index] + 20.0 * $addedPropArr2[$index] + 29.0 * $addedPropArr1[$index] - $numArray1[$index];
                    $addedPropArr3[$index] -= $numArray2[$index];
                    $numArray6[$index] = ceil($numArray6[$index] / 10.0) / 10.0;
                    $addedPropArr3[$index] = ceil($addedPropArr3[$index] / 10.0) / 10.0;
                }
				$propArr = $numArray6;
				$growArr = $addedPropArr3;
			}
		}

		public static function GetAddedPropArr($grade, $propArr)
		{
            $numArray = [
                $propArr[0] * pow(2.0, $grade - 1),
                0.0,
                0.0,
                0.0,
                0.0
			];
			for ($index = 1; $index < 5; $index++)
			{
                $numArray[$index] = $propArr[$index] * pow(1.5, $grade - 1);
            }
			return $numArray;
		}

    /**
     * @param PetTemplateInfo $info
     * @param int $ceil 1 = min, 2 = max
     * @return UserPetInfo
     */
    public static function CreatePet($info, $ceil = 1)
    {
        $usersPetInfo = new UserPetInfo();
        $usersPetInfo->TemplateID = $info->TemplateID;
        $num = (double)$info->StarLevel * 0.1;
        $usersPetInfo->BloodGrow = (int)ceil((double)(minmax((int)((double)$info->HighBlood / (1.7 - $num)), $info->HighBlood - (int)((double)$info->HighBlood / 15.1), $ceil) / 10));
        $usersPetInfo->AttackGrow = minmax((int)((double)$info->HighAttack / (1.7 - $num)), $info->HighAttack - (int)((double)$info->HighAttack / 15.1), $ceil);
        $usersPetInfo->DefenceGrow = minmax((int)((double)$info->HighDefence / (1.7 - $num)), $info->HighDefence - (int)((double)$info->HighDefence / 15.1), $ceil);
        $usersPetInfo->AgilityGrow = minmax((int)((double)$info->HighAgility / (1.7 - $num)), $info->HighAgility - (int)((double)$info->HighAgility / 15.1), $ceil);
        $usersPetInfo->LuckGrow = minmax((int)((double)$info->HighLuck / (1.7 - $num)), $info->HighLuck - (int)((double)$info->HighLuck / 15.1), $ceil);
        $usersPetInfo->Level = 1;
        $usersPetInfo->BuildProp($usersPetInfo);
        return $usersPetInfo;
    }

    public static function UpdateEvolution($TemplateID, $lv, &$evoluTime)
    {
        $realId = (string)$TemplateID;
        $EvolutionLevel1 = 30;
        $EvolutionLevel2 = 50;
        $evoluTime = 1;
        $nextId = -1;

        if ($TemplateID % 10 == 1) {
            if ($lv < $EvolutionLevel1) {
                $nextId = $TemplateID;
            } else if ($lv < $EvolutionLevel2) {
                $nextId = $TemplateID + 1;
            } else {
                $nextId = $TemplateID + 2;
                $evoluTime = 2;
            }
        } else if ($TemplateID % 10 == 2) {
            $nextId = $TemplateID + 1;
        } else {
            $nextId = $TemplateID;
        }

        $nextinfo = self::FindPetTemplate($nextId);
        if ($nextinfo != null) {
            return $nextinfo->TemplateID;
        }

        return $TemplateID;
    }

    /**
     * @param $templateID
     */
    public static function FindPetTemplate($templateID)
    {
        return PetTemplateInfo::find($templateID);
    }
}
