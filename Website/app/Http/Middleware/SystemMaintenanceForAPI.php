<?php

namespace App\Http\Middleware;

use App\MaintenanceMode;
use Closure;
use Illuminate\Foundation\Http\Middleware\CheckForMaintenanceMode as Middleware;

class SystemMaintenanceForAPI extends Middleware
{
    protected $except = [
        //Prefix white list in here
        'admin/*'
    ];

    protected $approveIPList = [
        //IP WHITE LIST HERE
    ];

    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        if ($this->app->isDownForMaintenance()) {

            $excludedIPs = [];
            $excludedIPsWithoutAntiDDos = [];
            $ipInDB = MaintenanceMode::all();

            foreach ($ipInDB as $IP)
            {
                if($IP->mode == 1){
                    array_push($excludedIPs, $IP->ip_whitelist);
                }
                if($IP->mode == 0){
                    array_push($excludedIPsWithoutAntiDDos, $IP->ip_whitelist);
                }
            }
            if (in_array($request->header('x-real-ip'), $excludedIPs)) {
                return $next($request);
            }

            if (in_array($request->ip(), $excludedIPsWithoutAntiDDos)) {
                return $next($request);
            }

//            if (in_array($request->ip(), $this->approveIPList)) {
//                return $next($request);
//            }

            return response()->json(['success' => false, 'message' => 'Máy chủ đang được bảo trì, vui lòng quay lại sau.']);
        }
        return $next($request);
    }
}
