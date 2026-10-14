<?php

namespace App\Http\Middleware;

use App\MaintenanceMode;
use Closure;
use Illuminate\Contracts\Foundation\Application;
use Illuminate\Routing\Route;
use Symfony\Component\HttpKernel\Exception\HttpException;
use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken;
use Illuminate\Foundation\Http\Middleware\CheckForMaintenanceMode as Middleware;

class CheckForMaintenanceMode extends Middleware
{
    /**
     * The URIs that should be reachable while maintenance mode is enabled.
     *
     * @var array
     */
    protected $except = [
        'admin',
        'admin/*',
        'api/*',
        'ip'
    ];
    protected $excludedNames = [

    ];

    protected $excludedIPs = [

    ];

    protected function shouldPassThrough($request)
    {
        foreach ($this->except as $except) {
            if ($except !== '/') {
                $except = trim($except, '/');
            }

            if ($request->is($except)) {
                return true;
            }
        }

        return false;
    }

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

            $route = $request->route();

            if ($route instanceof Route) {
                if (in_array($route->getName(), $this->excludedNames)) {
                    return $next($request);
                }
            }

            if ($this->shouldPassThrough($request))
            {
                return $next($request);
            }

            throw new HttpException(503);
        }

        return $next($request);
    }

}
