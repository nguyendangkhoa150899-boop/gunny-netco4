<?php
/*
|--------------------------------------------------------------------------
| ajax-public Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "wweb" middleware group. Now create something great!
|
*/

Route::prefix('ajax-public')->group(function () {
    Route::post('/news', 'AjaxPublic\NewsController@getPublicNews')->name('get-news');
    Route::post('/ranking', 'AjaxPublic\RankedController@getPublicRanked')->name('ajax-get-rank');
    Route::post('/check-is-valid-username', 'AjaxPublic\RegisterHelperController@checkValidUsername')->name('ajax-check-valid-username');
    Route::post('/check-is-valid-email', 'AjaxPublic\RegisterHelperController@checkValidEmail')->name('ajax-check-valid-email');
    Route::get('/get-compete-info', 'Client\CompeteEventController@getCompeteEventInfo')->name("ajax-get-compete-info");
});
