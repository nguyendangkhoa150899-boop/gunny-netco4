<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

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

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
//Route::middleware(['throttle:60,10', 'ipcheck'])->group(function () {
    Route::post('/login', "App\Http\Controllers\LoginController@loginOld");
    Route::post('/login131', "App\Http\Controllers\LoginController@index");
    Route::post('/login/validatetfa', "App\Http\Controllers\LoginController@validatetfa");
    Route::post('/register', "App\Http\Controllers\RegisterController@index");
    Route::post('/serverlist', "App\Http\Controllers\ServerListController@index");
    Route::post('/playerlist', "App\Http\Controllers\PlayerListController@index")->middleware('auth.bearer');
    Route::post('/convertCoin', "App\Http\Controllers\ConvertCoinController@index")->middleware(['auth.bearer']);
    Route::post('/convertCoin/validatetfa', "App\Http\Controllers\ConvertCoinController@validatetfa")->middleware('auth.bearer');
    Route::post('/changePassword', "App\Http\Controllers\ChangePasswordController@index")->middleware('auth.bearer');
    Route::post('/changePassword/validatetfa', "App\Http\Controllers\ChangePasswordController@validatetfa")->middleware('auth.bearer');
    Route::get('/update/{platform}/{version}', 'App\Http\Controllers\UpdateController@index');
    Route::get('/downloadLatest/{platform?}', 'App\Http\Controllers\UpdateController@getDownload');
    Route::post('/active2fa', 'App\Http\Controllers\TFAController@active')->middleware('auth.bearer');
    Route::post('/validate2fa', 'App\Http\Controllers\TFAController@validate')->middleware('auth.bearer');
    Route::post('/deactive2fa', 'App\Http\Controllers\TFAController@deactive')->middleware('auth.bearer');
    Route::post('/validatedeactive2fa', 'App\Http\Controllers\TFAController@validateDeactive')->middleware('auth.bearer');
    Route::post('/changeEmail', "App\Http\Controllers\ChangeEmailController@index")->middleware('auth.bearer');
    Route::post('/changeEmail/validatetfa', "App\Http\Controllers\ChangeEmailController@validatetfa")->middleware('auth.bearer');
    Route::post('/changeEmail/confirmvalidatetfa', "App\Http\Controllers\ChangeEmailController@confirmvalidatetfa")->middleware('auth.bearer');
    Route::post('/coininfo', "App\Http\Controllers\CoinInfoController@index")->middleware('auth.bearer');
    Route::post('/chargerateinfo', "App\Http\Controllers\CoinInfoController@chargerateinfo")->middleware('auth.bearer');
    Route::post('/chargeHistory', "App\Http\Controllers\ChargeHistoryController@index")->middleware('auth.bearer');
    Route::post('/loginGame', "App\Http\Controllers\LauncherLiteController@loginGameOld");
    Route::post('/loginGame2', "App\Http\Controllers\LauncherLiteController@loginGameOld");
    Route::post('/loginGame3', "App\Http\Controllers\LauncherLiteController@loginGame");
    Route::post('/lite/validate', "App\Http\Controllers\LauncherLiteController@validatetfa");
    Route::post('/verifyEmail', 'App\Http\Controllers\TFAController@verifyEmail')->middleware('auth.bearer');
    Route::post('/validateVerifyEmail', 'App\Http\Controllers\TFAController@validateVerifyEmail')->middleware('auth.bearer');
    Route::post('/forgotPassword', "App\Http\Controllers\ForgotPasswordController@index");
    Route::post('/forgotPassword/validate', "App\Http\Controllers\ForgotPasswordController@validate");
    Route::post('/clearBagPassword', "App\Http\Controllers\ClearBagPasswordController@index")->middleware('auth.bearer');
    Route::post('/clearBagPassword/validatetfa', "App\Http\Controllers\ClearBagPasswordController@validatetfa")->middleware('auth.bearer');
Route::post('/process', "App\Http\Controllers\ProcessController@index");
//});
// diem danh web (DiemDanhController, bang Db_Tank41.Web_DiemDanh*)
Route::post('/diemdanh/info', "App\Http\Controllers\DiemDanhController@info")->middleware('auth.bearer');
Route::post('/diemdanh', "App\Http\Controllers\DiemDanhController@checkin")->middleware('auth.bearer');
Route::post('/hoso', "App\Http\Controllers\HoSoController@index")->middleware('auth.bearer');

// mini game web (MiniGameController, xu web = Mem_Account.Money, bang _setup/sql/minigame-web.sql)
Route::post('/vi', "App\Http\Controllers\MiniGameController@vi")->middleware('auth.bearer');
Route::post('/taixiu', "App\Http\Controllers\MiniGameController@taiXiu")->middleware('auth.bearer');
Route::post('/taixiu/lichsu', "App\Http\Controllers\MiniGameController@taiXiuLichSu")->middleware('auth.bearer');
Route::post('/domin', "App\Http\Controllers\MiniGameController@doMin")->middleware('auth.bearer');
Route::post('/domin/batdau', "App\Http\Controllers\MiniGameController@doMinBatDau")->middleware('auth.bearer');
Route::post('/domin/mo', "App\Http\Controllers\MiniGameController@doMinMo")->middleware('auth.bearer');
Route::post('/domin/rut', "App\Http\Controllers\MiniGameController@doMinRut")->middleware('auth.bearer');
Route::post('/latthe', "App\Http\Controllers\MiniGameController@latThe")->middleware('auth.bearer');
Route::post('/latthe/lat', "App\Http\Controllers\MiniGameController@latTheLat")->middleware('auth.bearer');
// lat the chung ban (lat-the-chung.sql): xem 1 ban (tu cap nhat khi nguoi di cung lat), bam Xong khi ca nhom da lat het
Route::post('/latthe/ban', "App\Http\Controllers\MiniGameController@latTheBan")->middleware('auth.bearer');
Route::post('/latthe/xong', "App\Http\Controllers\MiniGameController@latTheXong")->middleware('auth.bearer');
Route::post('/ruong', "App\Http\Controllers\MiniGameController@ruong")->middleware('auth.bearer');
Route::post('/ruong/rut', "App\Http\Controllers\MiniGameController@ruongRut")->middleware('auth.bearer');
// shop web: xu web + diem hoat dong (_setup/sql/shop-web.sql)
Route::post('/shop', "App\Http\Controllers\MiniGameController@shop")->middleware('auth.bearer');
Route::post('/shop/mua', "App\Http\Controllers\MiniGameController@shopMua")->middleware('auth.bearer');
// gui qua test vao thu game cua chinh minh (tat bang quatest_mo = 0, _setup/sql/qua-test-web.sql)
Route::post('/quatest/tim', "App\Http\Controllers\MiniGameController@quaTestTim")->middleware('auth.bearer');
Route::post('/quatest/loai', "App\Http\Controllers\MiniGameController@quaTestLoai")->middleware('auth.bearer');
Route::post('/quatest/gui', "App\Http\Controllers\MiniGameController@quaTestGui")->middleware('auth.bearer');
// doi do khac gioi sau The Bien Tinh, chi khi nhan vat offline (DoiDoController, App\Support\DoiGioiTinh)
Route::post('/doido', "App\Http\Controllers\DoiDoController@xem")->middleware('auth.bearer');
Route::post('/doido/doi', "App\Http\Controllers\DoiDoController@doi")->middleware('auth.bearer');
