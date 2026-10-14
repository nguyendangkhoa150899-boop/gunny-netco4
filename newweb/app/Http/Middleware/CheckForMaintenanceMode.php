<?php

namespace App\Http\Middleware;

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
        //
        'admin',
        'admin/*',
        'api/*',
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

            if (in_array($request->ip(), $this->excludedIPs)) {
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
