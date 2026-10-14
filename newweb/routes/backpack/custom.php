<?php

// --------------------------
// Custom Backpack Routes
// --------------------------
// This route file is loaded automatically by Backpack\Base.
// Routes you generate using Backpack\Generators will be placed here.

Route::group([
    'prefix'     => config('backpack.base.route_prefix', 'admin'),
    'middleware' => array_merge(
        (array) config('backpack.base.web_middleware', 'web'),
        (array) config('backpack.base.middleware_key', 'admin')
    ),
    'namespace'  => 'App\Http\Controllers\Admin',
], function () { // custom admin routes
    App::setLocale('vi');
    //disable register
    Route::get('register', function () {return redirect('/');})->name('backpack.auth.register');
    Route::post('register', function () {return redirect('/');});

    Route::get('dashboard', 'DashboardController@dashboard')->name('backpack.dashboard');
    Route::get('/', 'DashboardController@redirect')->name('backpack');

    Route::crud('memhistory', 'MemHistoryCrudController');
    Route::crud('member', 'MemberCrudController');
    Route::post('member/banmembers', 'MemberCrudController@banmembers');
    Route::crud('cardcharged', 'CardChargedCrudController');
    Route::crud('player', 'PlayerCrudController');
    Route::crud('active', 'ActiveCrudController');
    Route::crud('shopgoods', 'ShopGoodsCrudController');
    Route::group(['prefix' => 'shopgoods/{template_id}'], function() {
        Route::crud('box_items', 'ShopGoodsBoxItemsCrudController');
    });
    Route::crud('shopgoodscategory', 'ShopGoodsCategoryCrudController');
    Route::group(['prefix' => 'active/{active_id}'], function() {
        Route::crud('award', 'ActiveAwardCrudController');
    });
    Route::get('api/shopgoods', 'Api\ShopGoodsController@index');
    Route::get('api/shopgoods/{id}', 'Api\ShopGoodsController@show');
    Route::crud('senditem', 'SendItemCrudController');
    Route::get('api/players', 'Api\PlayersController@index');
    Route::get('api/players/{id}', 'Api\PlayersController@show');
    Route::post('api/senditem', 'Api\SendItemController@index');
    Route::get('charts/online-users', 'Charts\OnlineUsersChartController@response')->name('charts.online-users.index');
    Route::crud('consortia', 'ConsortiaCrudController');
    Route::crud('topracing', 'TopRacingCrudController');
    Route::crud('topracingevent', 'TopRacingEventCrudController');
    Route::group(['prefix' => 'topracing/{top_racing_id}'], function() {
        Route::crud('award', 'TopRacingAwardCrudController');
    });
    Route::crud('flushcache', 'FlushCacheController');
    Route::crud('createallxml', 'CreateAllXmlController');
    Route::post('api/creategiftcode', 'Api\CreateGiftCodeController@index');
    Route::get('downloadgiftcode/{uniqid}/{filename}', 'GiftCodeDownloaderController@index');
    Route::crud('quest', 'QuestCrudController');
    Route::group(['prefix' => 'quest/{quest_id}'], function() {
        Route::crud('goods', 'QuestGoodsCrudController');
        Route::crud('condiction', 'QuestCondictionCrudController');
    });
    Route::crud('noviceactivity', 'NoviceActivityCrudController');
    Route::group(['prefix' => 'noviceactivity/{activity_id}'], function() {
        Route::crud('subactivity', 'NoviceSubActivityCrudController');
    });
    Route::crud('itemstrengthen', 'ItemStrengthenCrudController');
    Route::crud('shopitems', 'ShopItemsCrudController');
    Route::crud('consortialevels', 'ConsortiaLevelCrudController');
    Route::group(['prefix' => 'consortialevels/{level}'], function() {
        Route::crud('tasks', 'ConsortiaTaskCrudController');
        Route::crud('rewards', 'ConsortiaTaskRewardCrudController');
    });
    Route::crud('pveinfo', 'PveCrudController');
    Route::group(['prefix' => 'pveinfo/{pve_id}'], function() {
        Route::crud('templates', 'PveTemplateCrudController');
        Route::crud('missions', 'PveMissionCrudController');
        Route::crud('condictions', 'PveDropCondictionCrudController');
        Route::crud('drops', 'PveDropCrudController');
    });
    Route::crud('momocharged', 'MomoChargedCrudController');
    Route::crud('bankcharged', 'BankChargedCrudController');
    Route::crud('memconvertcoin', 'MemConvertCoinCrudController');
    Route::crud('shopdepartments', 'ShopDepartmentsCrudController');
    Route::group(['prefix' => 'shopdepartments/{department_id}'], function() {
        Route::crud('items', 'ShopDepartmentItemsCrudController');
    });
    Route::crud('user_messages', 'UserMessagesCrudController');
    Route::crud('user_logs', 'UserLogsCrudController');
    Route::get('api/shopitem', 'Api\ShopItemController@index');
    Route::get('api/shopitem/{id}', 'Api\ShopItemController@show');
    Route::crud('dropemulator', 'Tools\DropEmulatorCrudController');
    Route::get('api/pveinfo', 'Api\PveInfoController@index');
    Route::get('api/pveinfohardlevel', 'Api\PveInfoController@hardLevel');
    Route::get('api/pveinfostage', 'Api\PveInfoController@stage');
    Route::post('api/dropemulator', 'Api\DropEmulatorController@index');
    Route::crud('avatargroup', 'ClothGroupCrudController');
    Route::group(['prefix' => 'avatargroup/{group_id}'], function() {
        Route::crud('templates', 'ClothGroupTemplatesCrudController');
    });
}); // this should be the absolute last line of this file
