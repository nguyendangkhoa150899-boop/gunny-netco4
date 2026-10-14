<?php

namespace App;

use Artisaninweb\SoapWrapper\SoapWrapper;
use App\Models\ServerList;
use App\Soap\ChargeMoney;

class SoapRequest
{
    protected $soapWrapper;

    protected $servers;

    /**
     * SoapController constructor.
     *
     * @param SoapWrapper $soapWrapper
     */
    public function __construct(SoapWrapper $soapWrapper)
    {
        $this->soapWrapper = $soapWrapper;
    }

    protected function addCenter($serverid)
    {
        if (empty($this->servers[$serverid])) {
            $server = ServerList::find($serverid);
            if (empty($server)) {
                return false;
            }
            $this->servers[$serverid] = $server;
        }
        $server = $this->servers[$serverid];
        if (!$this->soapWrapper->has('Center'.$serverid)) {
            $this->soapWrapper->add('Center' . $serverid, function ($service) use ($server) {
                $service
                    ->wsdl($server->LinkCenter . '?WSDL')
                    ->trace(true)
                    ->classmap([
                        ChargeMoney::class
                    ])
                    ->options([
                        'soap_version' => SOAP_1_1,
                        'exceptions' => false,
                    ]);
            });
        }
    }

    public function PlayerChargeMoney($serverid, $playerid, $chargeId)
    {
        $this->addCenter($serverid);
        return $this->soapWrapper->call('Center'.$serverid.'.ChargeMoney', [
            new ChargeMoney($playerid, $serverid, $chargeId)
        ]);
    }
}
