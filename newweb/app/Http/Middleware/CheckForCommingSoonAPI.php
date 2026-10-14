<?php

namespace App\Http\Middleware;

use App\Models\Setting;
use Closure;
use Illuminate\Contracts\Foundation\Application;
use Illuminate\Http\Response;
use Illuminate\Routing\Route;
use Symfony\Component\HttpKernel\Exception\HttpException;
use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken;
use Illuminate\Foundation\Http\Middleware\CheckForMaintenanceMode as Middleware;

class CheckForCommingSoonAPI extends Middleware
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
        $timeToOpen = Setting::get('open-time');

        if (!empty($timeToOpen) && strtotime($timeToOpen) > strtotime('now')) {

            if (in_array($request->ip(), $this->excludedIPs)) {
                return $next($request);
            }

            echo json_encode(['success' => false, 'message' => 'Game chưa mở, vui lòng quay lại vào lúc '.date('H:i:s \n\g\à\y d/m/Y', strtotime($timeToOpen))]);
            exit;
        }

        return $next($request);
    }
}
