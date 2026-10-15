<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});
Route::get('/play2/{token}', "App\Http\Controllers\PlayController@play");
Route::get('/getPlayVars', "App\Http\Controllers\PlayController@getPlayVars")->middleware('auth.bearer');
Route::get('/getTopList', "App\Http\Controllers\TopListController@index");
