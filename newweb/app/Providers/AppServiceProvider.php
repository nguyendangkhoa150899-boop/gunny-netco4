<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

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

    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        //override UserCrudController from EduardoArandaH
        $this->app->bind(
            \EduardoArandaH\UserManager\app\Http\Controllers\UserCrudController::class,
            \App\Http\Controllers\Admin\UserCrudController::class
        );

        $this->app->bind(
            \Backpack\NewsCRUD\app\Http\Controllers\Admin\ArticleCrudController::class,
            \App\Http\Controllers\Admin\ArticleCrudController::class
        );
    }
}
