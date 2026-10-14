<?php
namespace App\InGame;

class UserPetInfo
{
    public $TemplateID;
    public $Attack;
    public $Defence;
    public $Luck;
    public $Agility;
    public $Blood;
    public $Damage;
    public $Guard;
    public $AttackGrow;
    public $DefenceGrow;
    public $LuckGrow;
    public $AgilityGrow;
    public $BloodGrow;
    public $DamageGrow;
    public $GuardGrow;
    public $Level;
    public $Hunger = 100;

    //
    private $int_8;
    private $int_4;
    private $int_5;
    private $int_7;
    private $int_6;
    private $int_9;
    private $int_10;

    /**
     * @return mixed
     */
    public function getAttack()
    {
        return $this->int_4 - $this->method_1($this->int_4);
    }

    /**
     * @return mixed
     */
    public function getDefence()
    {
        return $this->int_5 - $this->method_1($this->int_5);
    }

    /**
     * @return mixed
     */
    public function getLuck()
    {
        return $this->int_6 - $this->method_1($this->int_6);
    }

    /**
     * @return mixed
     */
    public function getAgility()
    {
        return $this->int_7 - $this->method_1($this->int_7);
    }

    /**
     * @return mixed
     */
    public function getBlood()
    {
        return $this->int_8 - $this->method_1($this->int_8);
    }

    /**
     * @return mixed
     */
    public function getDamage()
    {
        return $this->int_9 - $this->method_1($this->int_9);
    }

    /**
     * @return mixed
     */
    public function getGuard()
    {
        return $this->int_10 - $this->method_1($this->int_10);
    }

    private function method_0()
    {
        $num1 = (double)$this->Hunger / 10000.0 * 100.0;
        $num2 = 0;
        if ($num1 >= 80.0)
        {
            $num2 = 3;
        }
        if ($num1 < 80.0 && $num1 >= 60.0)
        {
            $num2 = 2;
        }
        if ($num1 < 60.0 && $num1 > 0.0)
        {
            $num2 = 1;
        }
        return $num2;
    }

    private function method_1($int_32)
    {
        return 0;
        if ($this->method_0() == 2)
        {
            return $int_32 * 20 / 100;
        }
        if ($this->method_0() == 1)
        {
            return $int_32 * 40 / 100;
        }
        return 0;
    }

    public function method_2($int_32, $double_0)
    {
        $numArray = [];
        $numArray[0] = $double_0[0] * pow(2.0, $int_32 - 1);
        for ($index = 1; $index < count($double_0); $index++)
        {
            $numArray[$index] = $double_0[$index] * pow(1.5, $int_32 - 1);
        }
        return $numArray;
    }

    function BuildProp($petInfo = null)
    {
        $numArray1 = [
            $this->BloodGrow * 10,
            $this->AttackGrow,
            $this->DefenceGrow,
            $this->AgilityGrow,
            $this->LuckGrow
        ];

        $double_0 = [
            $this->BloodGrow,
            $this->AttackGrow,
            $this->DefenceGrow,
            $this->AgilityGrow,
            $this->LuckGrow
        ];
        $numArray2 = $numArray1;
        $numArray3 = $numArray1;
        $numArray4 = $numArray1;
        $numArray5 = $this->method_2(1, $double_0);
        $numArray6 = $this->method_2(2, $double_0);
        $numArray7 = $this->method_2(3, $double_0);
        $_ = [];
        $numArray8 = [];
        if ($this->Level < 30)
        {
            for ($index3 = 0; $index3 < count($numArray2); $index3++)
            {
                $numArray2[$index3] += (double)($this->Level - 1) * $numArray5[$index3];
                $numArray2[$index3] = ceil($numArray2[$index3] / 10.0) / 10.0;
            }
            $numArray8 = $numArray2;
        }
        else if ($this->Level < 50)
        {
            for ($index2 = 0; $index2 < count($numArray3); $index2++)
            {
                $numArray3[$index2] += (double)($this->Level - 30) * $numArray6[$index2] + 29.0 * $numArray5[$index2];
                $numArray3[$index2] = ceil($numArray3[$index2] / 10.0) / 10.0;
            }
            $numArray8 = $numArray3;
        }
        else
        {
            for ($index = 0; $index < count($numArray4); $index++)
            {
                $numArray4[$index] += (double)($this->Level - 50) * $numArray7[$index] + 20.0 * $numArray6[$index] + 29.0 * $numArray5[$index];
                $numArray4[$index] = ceil($numArray4[$index] / 10.0) / 10.0;
            }
            $numArray8 = $numArray4;
        }
        $this->int_8 = (int)$numArray8[0];
        $this->int_4 = (int)$numArray8[1];
        $this->int_5 = (int)$numArray8[2];
        $this->int_7 = (int)$numArray8[3];
        $this->int_6 = (int)$numArray8[4];
    }

    public function getProps()
    {
        return $this->BloodGrow . ' - '.$this->AttackGrow . ' - '.$this->DefenceGrow . ' - '.$this->AgilityGrow . ' - '.$this->LuckGrow;

    }
}
