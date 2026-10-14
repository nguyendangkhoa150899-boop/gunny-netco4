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

class CheckForCommingSoon extends Middleware
{
    /**
     * The URIs that should be reachable while maintenance mode is enabled.
     *
     * @var array
     */
    protected $except = [
        //
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
        $timeToOpen = Setting::get('open-time');

        if (!empty($timeToOpen) && strtotime($timeToOpen) > strtotime('now')) {

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

            if ($route instanceof Route) {
                if (strpos($route->getName(), 'api') === 0) {

                }
            }

            return new Response(view('/coming_soon', ['time' => date('Y/m/d H:i:s', strtotime($timeToOpen))]));
        }

        return $next($request);
    }
}
