<?php

use Illuminate\Routing\Router;

Admin::routes();

Route::group([
    'prefix'        => config('admin.route.prefix'),
    'namespace'     => config('admin.route.namespace'),
    'middleware'    => config('admin.route.middleware'),
    'as'            => config('admin.route.prefix') . '.',
], function (Router $router) {

    $router->get('/', 'HomeController@index')->name('admin-home');

    /*
     * System Controllers [Config_]
     */

    //Config_Client:
    $router->resource('web-management', SystemConfigManagement\ClientConfigControllers::class);
    //Config_Slide:
    $router->resource('slides-management', SystemConfigManagement\SlideController::class);
    //Config_Payment:
    $router->resource('payment-setting', SystemConfigManagement\SettingController::class);
    //Config_ServerList
    $router->resource('server-lists', SystemConfigManagement\ServerListController::class);
    //Config_IP Maintenance WhiteList
    $router->resource('maintenance-modes', SystemConfigManagement\MaintenanceModeController::class);
    //Config_Discord Webhook
    $router->resource('maintenance-web-hooks', SystemConfigManagement\MaintenanceWebHookController::class);

    /*
     * News Controllers
     */

    $router->resource('news-management', NewsManagement\NewsController::class);

    /*
     * Account Controllers
     */

    //List Account
    $router->resource('members', MemberManagement\MemberController::class);
    //History Staff Recharge
    $router->resource('history-staff-recharge', MemberManagement\HistoryStaffRecharge::class);
    //History User Recharge
    $router->resource('history-card-recharge', MemberManagement\HistoryCardRecharge::class);
    //History Transfer Coin
    $router->resource('member-histories', MemberManagement\MemberHistoryController::class);
    //History Send Mail
    $router->resource('user-send-mail-history', MemberManagement\LogUserSendMailController::class);


    /*
     * Game Controllers
     */

    //Players Management
    $router->resource('player-management', PlayerManagement::class);
    $router->post('/player-management/{id}/save', 'PlayerManagement@save'); //Save/Edit Players

    //__Shops Management__//
    //---- ShopShowList
    $router->resource('showlist-management', ShopManagement\ShopGoodsShowListController::class);
    $router->get('showlist/edit/','ShopManagement\ShopGoodsShowListController@showEditView'); //Edit showlist
    //---- Shop
    $router->resource('shop-management', ShopManagement\ShopController::class);

    //__ShopGoods Management__//
    //---- ShopGoods Category
    $router->resource('shop-goods-category', ShopGoodsManagement\ShopGoodsCategoryController::class);
    //---- ShopGoods
    $router->resource('shop-goods', ShopGoodsManagement\ShopGoodsController::class);

    //__Active Management__//
    //---- Active (Giftcode)
    $router->resource('giftcode-management', ActiveManagement\GiftCodeController::class);
    //---- Active Award
    //Active Award
    $router->resource('active-award', ActiveManagement\ActiveAwardController::class);
    $router->get('active-award-management', 'ActiveManagement\GiftCodeController@showAddActiveAward')->name('hee'); //Dont known
    $router->resource('active-numbers', ActiveManagement\ActiveNumberController::class);


    //__Mission Management__//
    //---- Mission Info
    $router->resource('mission-infos', MissionManagement\MissionInfoController::class);
    //---- Drop Condiction
    $router->resource('drop-condictions', MissionManagement\DropConditionController::class);
    //---- DropItem
    $router->resource('drop-items', MissionManagement\DropItemController::class);
    //---- NPC
    $router->resource('npc-management', MissionManagement\NPCController::class);


    //__Quest Management__//
    //---- Quest
    $router->resource('quests', QuestManagement\QuestController::class);
    //---- Quest Condiction
    $router->resource('quest-condictions', QuestManagement\QuestCondictionController::class);
    //____ Create Multiple QuestCondiction
    $router->get('create-multiple-quest-condictions','QuestManagement\QuestCondictionController@showCreateMultipleQuestCondictionForm');
    $router->post('create-multiple-quest-condictions','QuestManagement\QuestCondictionController@createMultipleQuestCondiction');
    //---- Quest Goods
    $router->resource('quest-goods', QuestManagement\QuestGoodsController::class);
    //____ Create Multiple QuestGoods
    $router->get('create-multiple-quest-goods','QuestManagement\QuestGoodsController@showCreateMultipleQuestGoodsForm');
    $router->post('create-multiple-quest-goods','QuestManagement\QuestGoodsController@createMultipleQuestGoods');

    //__Attractive Management__//
    //Attractive
    $router->resource('event-reward-infos', AttractiveManagement\AttractiveController::class);
    //Attractive Awards
    $router->resource('event-reward-goods', AttractiveManagement\AttractiveAwardController::class);

    //__Shop Goods Box
    $router->resource('shop-goods-boxes', ShopBoxManagement\ShopGoodsBoxController::class);

    //__Fusion Management__//
    //ItemFusion
    $router->resource('item-fusions', FusionManagement\ItemFusionController::class);
    $router->resource('item-fusion-lists', FusionManagement\ItemFusionListController::class);

    //Login 7 days award
    $router->resource('login-award-item-templates', Login7DaysAwardItem::class);

    //Send Item
    $router->get('send-item','SendItemController@showSendItemView');






    /*
     * Compete Event Controllers
     */

    //Compete Event Category
    $router->resource('category-event-competes', EventCompeteManagement\EventCompeteCategoryController::class);
    //Compete Event Type
    $router->resource('event-type-competes', EventCompeteManagement\EventTypeCompeteController::class);
    //Compete Event
    $router->resource('event-competes', EventCompeteManagement\EventCompeteController::class);
    //Compete Event Award
    $router->resource('event-award-competes', EventCompeteManagement\EventAwardCompeteController::class);
    $router->resource('checkin-award', CheckinManagement\CheckinController::class);
    /*
     * HELPERS API
     */

    //Clear Cache Helpers
    $router->get('/api/clear-config-cache', 'HelpersController@clearConfigCache');
    $router->get('/api/clear-serverlist-cache', 'HelpersController@clearServerListCache');
    $router->get('/api/clear-slide-cache', 'HelpersController@clearSlideCache');
    $router->get('/api/clear-all-cache', 'HelpersController@clearAllConfigCache');

    $router->get('/api/load-item', 'ShopGoodsManagement\ShopGoodsController@loadItemList');
    $router->get('/api/load-shop-with-relation','ShopManagement\ShopController@loadShopWithRelation');
    $router->get('/api/get-list-player','HelpersController@getListPlayer');
    $router->get('/api/get-list-member','HelpersController@getListMember');
    $router->get('/api/get-mission-info','MissionManagement\MissionInfoController@showMissionInfo');
    $router->get('/api/get-mission-info-for-drop','HelpersController@findMissionInfoViaDrop');
    $router->get('/api/get-event-type-compete','HelpersController@getEventTypeCompete');

    //Maintenance helpers
    $router->get('/api/server/down','HelpersController@downServer');
    $router->get('/api/server/up','HelpersController@upServer');

    //Change Tank Admin
    $router->get('/api/change-tank','HelpersController@changeTank');

    //Find Quest
    $router->get('/api/find-quest','HelpersController@findQuest');

    //Find NPC
    $router->get('/api/find/npc','HelpersController@findNPC');

    //Find MissionInfo
    $router->get('/api/find/mission-info','HelpersController@findMissionInfo');

    /*
     * XML Builder
     */
    //CREATEALLXML helpers
    $router->get('/api/build-xml/createallxml/{id}','BuildXMLController@createAllXML');
    //Build Quest XML
    $router->get('/api/build-xml/quest/{id}','BuildXMLController@buildQuest');
    //Build Active XML
    $router->get('/api/build-xml/active/{id}','BuildXMLController@buildActive');
    //Send Maintenance To Server Game (Delay 5 minutes)
    $router->get('/api/build-xml/kickoffuser/{id}','BuildXMLController@sendMaintenanceNotice');


    /*
     * Maintenance
     */
    $router->get('/api/maintenance/down/{id}','MaintenanceController@downServerGame');
    $router->get('/api/maintenance/up/{id}','MaintenanceController@upServerGame');


});
