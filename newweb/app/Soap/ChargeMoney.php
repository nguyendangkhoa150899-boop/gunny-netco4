<?php

namespace App\Soap;

class ChargeMoney
{

    public $userID;
    public $zoneId;
    public $chargeID;

    public function __construct($userID, $zoneId, $chargeID)
    {
        $this->userID = $userID;
        $this->zoneId = $zoneId;
        $this->chargeID = $chargeID;
    }
}
