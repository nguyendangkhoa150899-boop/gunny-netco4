<?php

namespace App\Http\Middleware;

use App\MaintenanceMode;
use App\ServerList;
use Closure;

class ServerGameMaintenanceAndComingSoon
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
        $fullPath = $request->path();
        $serverID = (int) str_replace('play/','',$fullPath);

//      Status: 0 => Bảo trì
//      Status: 1 => Hoạt động bình thường
//      Status: 2 => Sắp ra mắt
        $serverStatus = (int) ServerList::select('Status')->findOrFail($serverID)->Status;

        $excludedIPs = [];
        $excludedIPsWithoutAntiDDos = [];
        $ipInDB = MaintenanceMode::all();

        foreach ($ipInDB as $IP)
        {
            if($IP->mode == 1)
                array_push($excludedIPs, $IP->ip_whitelist);
            if($IP->mode == 0)
                array_push($excludedIPsWithoutAntiDDos, $IP->ip_whitelist);
        }

        $isValid = $this->accessPermissionIfValid($excludedIPs, $excludedIPsWithoutAntiDDos, $request);

        if($isValid){
            return $next($request);
        }

        if($serverStatus == 0 || $serverStatus == 2)
            return redirect(route('view-select-server'));


        return $next($request);
    }
}
