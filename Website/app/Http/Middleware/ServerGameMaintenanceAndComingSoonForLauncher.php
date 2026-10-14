<?php

namespace App\Http\Middleware;

use App\MaintenanceMode;
use App\ServerList;
use Closure;

class ServerGameMaintenanceAndComingSoonForLauncher
{
    private function accessPermissionIfValid($excludedIPs, $excludedIPsWithoutAntiDDos, $request)
    {
        $isValid = false;
        //Anti ddos IP
        if (in_array($request->header('x-real-ip'), $excludedIPs)){
            $isValid = true;
        }

        //Real IP
        if (in_array($request->ip(), $excludedIPsWithoutAntiDDos)){
            $isValid = true;
        }
        return $isValid;
    }

    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        $serverID = $request->input('serverID');

        if($serverID == null){
            $serverID = 1001;
        }
//      Status: 0 => Bảo trì
//      Status: 1 => Hoạt động bình thường
//      Status: 2 => Sắp ra mắt
        $server = ServerList::select('Status','ServerName')->findOrFail($serverID);

        $excludedIPs = $excludedIPsWithoutAntiDDos = [];
        $ipInDB = MaintenanceMode::all();

        foreach ($ipInDB as $IP)
        {
            if($IP->mode == 1)
                array_push($excludedIPs, $IP->ip_whitelist);
            if($IP->mode == 0)
                array_push($excludedIPsWithoutAntiDDos, $IP->ip_whitelist);
        }

        $isValid = $this->accessPermissionIfValid($excludedIPs, $excludedIPsWithoutAntiDDos, $request);

        if($isValid)
            return $next($request);

        switch ((int) $server->Status){
            case 0: //Maintenance
                return response()->json(['success'=> false, 'message' => 'Máy chủ ['.$server->ServerName.'] đang được bảo trì!']);
            case 2: //Coming soon
                return response()->json(['success'=> false, 'message' => 'Máy chủ ['.$server->ServerName.'] chưa ra mắt!']);
        }

        return $next($request);
    }
}
