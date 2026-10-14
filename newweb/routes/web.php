<?php

use App\Http\Middleware\CheckForCommingSoon;
use App\Http\Middleware\CheckForMaintenanceMode;
use Illuminate\Support\Facades\Route;
use App\Http\Middleware\MemberLoginAndRegister;
use App\Http\Middleware\MemberAccount;

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

//Route::get('/', 'HomeController@index');
Route::get('/play/{sv_id}', 'PlayController@index')->middleware(MemberAccount::class);
Route::get('/news/{slug}', 'NewsController@index');
Route::get('/su-kien/{slug}', 'HomeController@topRacing');
Route::get('/active1', 'ActivePage1Controller@index');
Route::prefix('member')->group(function () {
    Route::post('/register', 'AuthController@register')->middleware(MemberLoginAndRegister::class);
    Route::post('/login', 'AuthController@login')->middleware(MemberLoginAndRegister::class);
    Route::get('/logout', 'AuthController@logout')->middleware(MemberAccount::class);
    Route::get('/refreshCaptcha', 'AuthController@refreshCaptcha');
    Route::post('/nhap-ma-login', 'AuthController@loginCode2Fa');
    Route::get('/gui-lai-ma-login', 'AuthController@loginResendCode2Fa');
    Route::post('/quen-mat-khau', 'AuthController@forgotPass');
    Route::post('/nhap-ma-khoi-phuc-mat-khau', 'AuthController@forgotPassCode2Fa');
    Route::post('/doi-mat-khau', 'AuthController@changePass');
});
Route::middleware([MemberAccount::class])->prefix('tai-khoan')->group(function () {
    Route::get('/', 'MemberController@account');
    Route::get('/doi-mat-khau', 'MemberController@changePassword');
    Route::post('/doi-mat-khau', 'MemberController@changePasswordPost');
    Route::get('/chuyen-xu', 'MemberController@changeMoney');
    Route::post('/chuyen-xu', 'MemberController@changeMoneyPost');
    Route::get('/nap-coin', 'MemberController@napCoin');
    Route::get('/giftcode', 'MemberController@giftcode');
    Route::get('/doi-ten-nhan-vat', 'MemberController@changeNickName');
    Route::post('/check-ten-nhan-vat', 'MemberController@isDuplicateNewNickName');
    Route::post('/doi-ten-nhan-vat', 'MemberController@changeNickNamePost');
    Route::get('/ho-tro', 'MemberController@support');
    Route::post('/doi-email', 'EmailChangeController@emailChangePost');
    Route::post('/doi-email-gui-lai-ma', 'EmailChangeController@emailChangePost');
    Route::post('/doi-email-code', 'EmailChangeController@emailChangeCodePost');
    Route::get('/doi-email-resend-code', 'EmailChangeController@emailChangeResendCode');
    Route::post('/toggle-2fa', 'MemberController@toggle2fa');
    Route::post('/toggle-2fa-code', 'MemberController@toggle2facode');
    Route::get('/xac-thuc-email', 'MemberController@verifyEmail');
    Route::post('/xac-thuc-email', 'MemberController@verifyEmailCode');
    Route::post('/nap-coin', 'MemberController@cardChargePost');
    Route::get('/lich-su-nap-the', 'MemberController@cardHistory');
});

Route::middleware(['api_maintain', 'api_coming_soon'])->prefix('api')->group(function () {
    Route::post('/login', 'ApiController@login');
    Route::post('/loginGame', 'ApiController@loginGame');
    Route::post('/login2fa', 'ApiController@login2fa');
    Route::post('/login2faresendcode', 'ApiController@login2fa');
    Route::post('/cardcallback', 'ApiController@cardCallback');
    Route::get('/play/{hash}/{token}', 'ApiController@loginGameWithLauncher');
});

