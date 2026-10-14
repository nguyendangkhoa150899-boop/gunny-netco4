<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Contracts\Foundation\Application;
use Illuminate\Routing\Route;
use Symfony\Component\HttpKernel\Exception\HttpException;
use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken;
use Illuminate\Foundation\Http\Middleware\CheckForMaintenanceMode as Middleware;

class CheckForMaintenanceModeAPI extends Middleware
{
    /**
     * The URIs that should be reachable while maintenance mode is enabled.
     *
     * @var array
     */
    protected $except = [
        //
        'admin/*'
    ];

    protected $excludedIPs = [

    ];

    public function handle($request, Closure $next)
    {
        if ($this->app->isDownForMaintenance()) {

            if (in_array($request->ip(), $this->excludedIPs)) {
                return $next($request);
            }

            echo json_encode(['success' => false, 'message' => 'Hệ thống đang được bảo trì, vui lòng quay lại sau!']);
            exit;
        }

        return $next($request);
    }
}
