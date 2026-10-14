<?php

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
    Route::get('/', 'Client\HomeController@showIndex')->name('home');
    Route::get('/login-puffin', 'Client\HomeController@showIndex')->name('view-login-puffin');
//        ->middleware('cacheResponse:900');

    //TMP Transfer
    Route::get('/transfer-account', 'Client\HomeController@showTmpTransferAccount')->name('view-transfer-account');
    Route::post('/transfer-account', 'Client\AuthenticateController@transferPasswordFromS1')->name('ajax-transfer-account');

    Route::get('/register', 'Client\AuthenticateController@showRegister')->name('view-register');
    Route::get('/forgot-password', 'Client\ForgotPasswordController@showForgotPassword')->name('view-forgot-password');
    Route::post('/send-forgot-password', 'Client\ForgotPasswordController@sendForgotPasswordEmail')->name('ajax-send-email-forgot-pwd');
    Route::get('/reset-password-by-forgot-password', 'Client\ForgotPasswordController@showChangePasswordView')->name('view-change-password-by-forgot');
    Route::post('/reset-password-by-forgot-password', 'Client\ForgotPasswordController@resetPassword')->name('ajax-reset-password-by-forgot');
    Route::get('/get-captcha-html', 'Client\CaptchaController@getCaptchaHTML')->name('ajax-get-captcha-html');

    //Game Guide
    Route::get('/game_guide/{id}', 'Client\HomeController@showGameGuide')->name('view-game-guide');

	//DETAIL
	Route::get('/compete-events/{id}', 'Client\CompeteEventController@showComepeteById')->name('view-show-compete-by-id');

    //News
    Route::get('/news', 'Client\NewsController@showNewsById')->name('view-news-by-id');

    //PlayWithOutLogin
    Route::get('select-server-free/{token}', 'Client\PlayWithoutLoginController@selectServerWithoutAuthenticate')->name('view-select-game-without-login');
    Route::get('play-free/{serverId}/{token}', 'Client\PlayWithoutLoginController@playGameWithoutAuthenticate')->name('view-play-game-without-login');


    //Authenticate prefix route
    Route::prefix('a-gunga')->group(function () {
        Route::post('/login', 'Client\AuthenticateController@login')->name('auth-ajax-login');
        Route::post('/register', 'Client\AuthenticateController@register')->name('auth-ajax-register');
        Route::post('/login-puffin', 'Client\AuthenticateController@loginWithPuffin')->name('auth-login-puffin');
    });

    Route::group( ['middleware' => 'auth:member'],function(){
        //Two factor views
        Route::get('/verify-2fa', 'Client\TwoFactorController@showVerifyView')->name('verify-2fa');
        Route::post('/send-2fa', 'Client\TwoFactorController@sendTwoFactorCode')->name('ajax-send-2fa');
        Route::post('/verify-2fa', 'Client\TwoFactorController@verifyTwoFactorCode')->name('execute-verify-2fa');
//    Route::post('/resend-2fa', 'Client\TwoFactorController@resend')->name('ajax-resend-2fa-code');


        //Select server & Playing games
        Route::get('/select-server', 'Client\PlayGameController@showSelectServerListView')->name('view-select-server');
        Route::get('/play/{serverId}/{debug?}', 'Client\PlayGameController@playGame')->name('view-play-game')->middleware('server_game_maintenance');

        // authenticated member routes here
        Route::group( ['middleware' => 'two_factor'],function() {

            //Account group views
            Route::prefix('/account')->group(function () {
                Route::get('/', 'Client\AccountController@showAccountView')->name('view-account');

                //Đổi mật khẩu
                Route::get('/change-password', 'Client\AccountController@showChangePasswordView')->name('ajax-view-change-password');
                Route::post('/change-password', 'Client\AccountController@changePassword')->name('ajax-change-password');

                //Xác thực Email
                Route::get('/show-verify-email', 'Client\AccountController@showVerifyEmailView')->name('ajax-view-verify-email');
                Route::post('/send-verify-email', 'Client\AccountController@sendVerifyCodeToEmail')->name('ajax-send-verify-email');
                Route::get('/verify-email-from-mail', 'Client\AccountController@verifyEmail')->name('execute-verify-email');

                //Đổi Email
                Route::post('/send-code-verified-email', 'Client\AccountController@sendCodeToChangeVerifiedEmail')->name('ajax-send-code-verified-email');
                Route::get('/change-email', 'Client\AccountController@showChangeEmailView')->name('ajax-view-change-email');
                Route::post('/change-email', 'Client\AccountController@changeEmail')->name('ajax-change-email');

                //Nạp tiền
                Route::get('/recharge-card', 'Client\CardPaymentController@showRechargeView')->name('ajax-view-recharge');
                Route::post('/recharge-card', 'Client\CardPaymentController@rechargeCard')->name('ajax-recharge-card');

                //Lịch sử nạp tiền
                Route::get('/history-recharge', 'Client\AccountController@showHistoryRechargeView')->name('ajax-view-history-recharge');

                //Đổi xu
                Route::get('/convert-coin', 'Client\AccountController@showConvertCoinView')->name('ajax-view-convert-coin');
                Route::post('/convert-coin', 'Client\AccountController@convertCoin')->name('ajax-convert-coin');

                //Đổi số điện thoại
                Route::get('/change-phone','Client\AccountController@showChangePhoneNumberView')->name('ajax-view-change-phone');
                Route::post('/change-phone','Client\AccountController@changePhoneNumber')->name('ajax-change-phone');

                //Tạo link chơi game không cần đăng nhập
                Route::get('/get-link-play-without-authenticate', 'Client\PlayWithoutLoginController@showGetLinkPlay')->name('ajax-view-get-link-play');
                Route::post('/change-link-play-without-authenticate', 'Client\PlayWithoutLoginController@changeLinkPlay')->name('ajax-change-link-play');

                //Đổi tên nhân vật
                Route::get('/change-nickname', 'Client\AccountController@showChangeNickName')->name('ajax-view-change-nickname');
                Route::post('/check-is-duplicate-nickname', 'Client\AjaxHelpersController@isDuplicateNewNickName')->name('ajax-check-duplicate-nickname');
                Route::post('/change-nickname', 'Client\AccountController@changeNickName')->name('ajax-change-nickname');

                Route::get('/checkin', 'Client\AccountController@showCheckin')->name('ajax-view-checkin');
                Route::post('/checkin', 'Client\AccountController@checkin')->name('ajax-checkin');
            });

            Route::prefix('/ajax-helpers')->group(function (){
                Route::post('/player-nickname', 'Client\AjaxHelpersController@getPlayerNickNameByServerId')->name('ajax-get-player-nickname');
            });
        });
        Route::get('account/activate-2fa', 'Client\TwoFactorController@enableTwoFactor')->name('execute-on-2fa');
        Route::get('account/deactivate-2fa', 'Client\TwoFactorController@disableTwoFactor')->name('execute-off-2fa');

        Route::get('account/logout', 'Client\AuthenticateController@logout')->name('member-logout');
    });



