<?php

namespace App\Providers;

use App\CategoryEventCompete;
use App\Config;
use App\ServerList;
use Carbon\Carbon;
use Illuminate\Support\Facades\View;
use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\URL;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        //
    }

    private function initGlobalVariablesAndCached()
    {
        $configsFromCached = cache()->remember('configsFromCached', 60*160*24, function (){
            return Config::all()->toArray();
        });

        //Initial default Value
        $config = [];

        foreach ($configsFromCached as $configFromCached){
            $config[$configFromCached['key']] = $configFromCached['value'];
        }

        $configCached = cache()->remember('configCached', 60*160*24, function () use($config){
            return $config;
        });

        //Server List
        $serverList = cache()->remember('serverList', 60*60*24, function (){
            return ServerList::select('ServerID', 'ServerName','Status')->get();
        });

        View::share([
            'config'      => $configCached,
            'serverList'  => $serverList
        ]);
    }

    private function checkCurrentCompeteEvent()
    {
        $competeEvent = CategoryEventCompete::where('start_time', '<', Carbon::now())->first();
        if ($competeEvent) {
            if (Carbon::now()->gte($competeEvent->start_time) && Carbon::now()->lte($competeEvent->end_time) && $competeEvent->is_active == 1) {
                View::share([
                    'competeEvent' => $competeEvent,
                ]);
            }
        }
    }
    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        if (env('APP_USE_HTTPS')) {
            URL::forceScheme('https');
        } else {
            URL::forceScheme('http');
        }
        $this->initGlobalVariablesAndCached();
        $this->checkCurrentCompeteEvent();
    }
}
