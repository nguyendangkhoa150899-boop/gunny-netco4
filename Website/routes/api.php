<?php

use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

//Route::middleware('auth:api')->get('/user', function (Request $request) {
//    return $request->user();
//});

//Route::post('/login', 'ClientLauncherController\@login');
Route::post('/recharge-card-callback', 'Client\CardPaymentController@cardCallbackRecharge');

/**
 * CRONJOB API MOMO & BANK
 */
Route::get('/cron-momo', 'Client\PaymentBankController@handleBankTransaction');
Route::get('/cron-bank', 'Client\PaymentMomoController@handleBankTransaction');

/**
 * LAUNCHER API
 */
 //Route::post('/login', 'Launcher\AuthenticateLauncherController@login');
    //Route::get('/login', 'Launcher\AuthenticateLauncherController@login');
Route::middleware('system_maintenance_api')->group(function (){
    Route::post('/login', 'Launcher\AuthenticateLauncherController@login');
    Route::post('/login2', 'Launcher\AuthenticateLauncherController@login2');
    Route::post('/loginGame', 'Launcher\PlayGameLauncherController@loginGame')->middleware('server_game_maintenance_launcher');
    Route::post('/loginGame2', 'Launcher\PlayGameLauncherController@loginGame2')->middleware('server_game_maintenance_launcher');
    Route::post('/register', 'Launcher\AuthenticateLauncherController@register');
    Route::post('/cashInfo', 'Launcher\OtherLauncherController@cashInfo');
    Route::post('/changePassword', 'Launcher\AuthenticateLauncherController@changePassword');
    Route::post('/exchangeCash', 'Launcher\OtherLauncherController@exchangeCash');
    Route::post('/loadChars', 'Launcher\OtherLauncherController@loadChars');
    Route::post('/convertCoin', 'Launcher\OtherLauncherController@convertCoin');
    Route::post('/getExchangeLog', 'Launcher\OtherLauncherController@getExchangeLog');
    Route::post('/getCoinLog', 'Launcher\OtherLauncherController@getCoinLog');
});
