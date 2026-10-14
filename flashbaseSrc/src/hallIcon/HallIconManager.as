package hallIcon
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import hallIcon.event.HallIconEvent;
   import hallIcon.info.HallIconInfo;
   import hallIcon.model.HallIconModel;
   import hallIcon.view.HallIcon;
   import worldboss.WorldBossManager;
   
   public class HallIconManager extends EventDispatcher
   {
      
      private static var _instance:hallIcon.HallIconManager;
       
      
      public var model:HallIconModel;
      
      public function HallIconManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : hallIcon.HallIconManager
      {
         if(_instance == null)
         {
            _instance = new hallIcon.HallIconManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.model = new HallIconModel();
         this.initEvent();
      }
      
      public function checkDefaultIconShow() : void
      {
         this.model.expblessedIsOpen = true;
         if(PlayerManager.Instance.Self.Grade < 30 && !PlayerManager.Instance.Self.IsVIP)
         {
            this.model.vipLvlIsOpen = true;
         }
         this.model.wonderFulPlayIsOpen = true;
         this.model.activityIsOpen = true;
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.addEventListener(PlayerManager.VIP_STATE_CHANGE,this.__vipLvlIsOpenHandler);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onPlayerPropertyChange);
      }
      
      private function __vipLvlIsOpenHandler(param1:Event) : void
      {
         if(PlayerManager.Instance.Self.Grade < 30 && !PlayerManager.Instance.Self.IsVIP)
         {
            this.model.vipLvlIsOpen = true;
         }
         else
         {
            this.model.vipLvlIsOpen = false;
         }
         this.model.dataChange(HallIconEvent.UPDATE_LEFTICON_VIEW,new HallIconInfo(HallIconType.VIPLVL));
      }
      
      private function cacheRightIcon(param1:String, param2:HallIconInfo) : void
      {
         if(param2.isopen)
         {
            this.model.cacheRightIconDic[param1] = param2;
         }
         else if(Boolean(this.model.cacheRightIconDic[param1]))
         {
            delete this.model.cacheRightIconDic[param1];
         }
      }
      
      public function checkCacheRightIconShow() : void
      {
         this.model.dispatchEvent(new HallIconEvent(HallIconEvent.UPDATE_BATCH_RIGHTICON_VIEW));
      }
      
      public function executeCacheRightIconLevelLimit(param1:String, param2:Boolean, param3:int = 0) : void
      {
         if(param2)
         {
            this.model.cacheRightIconLevelLimit[param1] = param3;
         }
         else if(Boolean(this.model.cacheRightIconLevelLimit[param1]))
         {
            delete this.model.cacheRightIconLevelLimit[param1];
         }
      }
      
      private function __onPlayerPropertyChange(param1:PlayerPropertyEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         if(Boolean(param1.changedProperties["Grade"]) && PlayerManager.Instance.Self.IsUpGrade)
         {
            for(_loc2_ in this.model.cacheRightIconLevelLimit)
            {
               _loc3_ = int(this.model.cacheRightIconLevelLimit[_loc2_]);
               if(PlayerManager.Instance.Self.Grade >= _loc3_)
               {
                  this.updateSwitchHandler(_loc2_,true);
                  delete this.model.cacheRightIconLevelLimit[_loc2_];
               }
            }
         }
      }
      
      public function updateSwitchHandler(param1:String, param2:Boolean, param3:String = null, param4:int = -1) : void
      {
         var _loc5_:HallIconInfo = this.convertIconInfo(param1,param2,param3,param4);
         this.cacheRightIcon(param1,_loc5_);
         this.model.dispatchEvent(new HallIconEvent(HallIconEvent.UPDATE_RIGHTICON_VIEW,_loc5_));
      }
      
      private function convertIconInfo(param1:String, param2:Boolean, param3:String, param4:int) : HallIconInfo
      {
         var _loc7_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:int = 99;
         switch(param1)
         {
            case HallIconType.RINGSTATION:
               _loc5_ = HallIcon.WONDERFULPLAY;
               _loc6_ = 3;
               break;
            case HallIconType.BATTLE:
               _loc5_ = HallIcon.WONDERFULPLAY;
               _loc6_ = 5;
               break;
            case HallIconType.TRANSNATIONAL:
               _loc5_ = HallIcon.WONDERFULPLAY;
               _loc6_ = 6;
               break;
            case HallIconType.CONSORTIABATTLE:
               _loc5_ = HallIcon.WONDERFULPLAY;
               _loc6_ = 7;
               break;
            case HallIconType.CAMP:
               _loc5_ = HallIcon.WONDERFULPLAY;
               _loc6_ = 8;
               break;
            case HallIconType.FIGHTFOOTBALLTIME:
               _loc5_ = HallIcon.WONDERFULPLAY;
               _loc6_ = 9;
               break;
            case HallIconType.SEVENDOUBLE:
               _loc5_ = HallIcon.WONDERFULPLAY;
               _loc6_ = 10;
               break;
            case HallIconType.LITTLEGAMENOTE:
               _loc5_ = HallIcon.WONDERFULPLAY;
               _loc6_ = 11;
               break;
            case HallIconType.FLOWERGIVING:
               _loc5_ = HallIcon.WONDERFULPLAY;
               _loc6_ = 12;
               break;
            case HallIconType.ESCORT:
               _loc5_ = HallIcon.WONDERFULPLAY;
               _loc6_ = 13;
               break;
            case HallIconType.BURIED:
               _loc5_ = HallIcon.WONDERFULPLAY;
               _loc6_ = 14;
               break;
            case HallIconType.ACCUMULATIVE_LOGIN:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 1;
               break;
            case HallIconType.SEVENDAYTARGET:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 2;
               break;
            case HallIconType.GODSROADS:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 3;
               break;
            case HallIconType.LIMITACTIVITY:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 4;
               break;
            case HallIconType.OLDPLAYERREGRESS:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 5;
               break;
            case HallIconType.GROWTHPACKAGE:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 6;
               break;
            case HallIconType.LEFTGUNROULETTE:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 7;
               break;
            case HallIconType.GROUPPURCHASE:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 8;
               break;
            case HallIconType.SUPERWINNER:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 10;
               break;
            case HallIconType.LUCKSTAR:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 11;
               break;
            case HallIconType.DICE:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 12;
               break;
            case HallIconType.TREASUREHUNTING:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 13;
               break;
            case HallIconType.GUILDMEMBERWEEK:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 14;
               break;
            case HallIconType.PYRAMID:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 15;
               break;
            case HallIconType.MYSTERIOUROULETTE:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 17;
               break;
            case HallIconType.LANTERNRIDDLES:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 19;
               break;
            case HallIconType.LUCKSTONE:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 21;
               break;
            case HallIconType.LIGHTROAD:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 22;
               break;
            case HallIconType.ENTERTAINMENT:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 23;
               break;
            case HallIconType.SALESHOP:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 24;
               break;
            case HallIconType.KINGDIVISION:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 25;
               break;
            case HallIconType.CHICKACTIVATION:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 26;
               break;
            case HallIconType.DDPLAY:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 27;
               break;
            case HallIconType.BOGUADVENTURE:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 28;
            case HallIconType.HALLOWEEN:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 29;
               break;
            case HallIconType.WITCHBLESSING:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 29;
               break;
            case HallIconType.TREASUREPUZZLE:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 29;
               break;
            case HallIconType.WORSHIPTHEMOON:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 30;
               break;
            case HallIconType.FOODACTIVITY:
               _loc5_ = 3;
               _loc6_ = 31;
               break;
            case HallIconType.RESCUE:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 32;
               break;
            case HallIconType.CATCHINSECT:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 33;
               break;
            case HallIconType.MAGPIEBRIDGE:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 34;
               break;
            case HallIconType.CLOUDBUYLOTTERY:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 35;
               break;
            case HallIconType.TREASURELOST:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 32;
               break;
            case HallIconType.WelfareCenterIcon:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 36;
               break;
            case HallIconType.HAPPYRECHARGE:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 37;
               break;
            case HallIconType.SYAH:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 38;
               break;
            case HallIconType.NEWCHICKENBOX:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 39;
               break;
            case HallIconType.GODCARD:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 40;
               break;
            case HallIconType.CATCHBEAST:
               _loc5_ = HallIcon.ACTIVITY;
               _loc6_ = 41;
               break;
		   case HallIconType.SIGNACTIVITY:
			   _loc5_ = HallIcon.ACTIVITY;
			   _loc6_ = 42;
			   break;
            case HallIconType.WORLDBOSSENTRANCE1:
               if(Boolean(WorldBossManager.Instance.bossInfo))
               {
                  _loc7_ = WorldBossManager.Instance.bossInfo.fightOver;
               }
               _loc5_ = HallIcon.WONDERFULPLAY;
               _loc6_ = 1;
               break;
            case HallIconType.WORLDBOSSENTRANCE4:
               if(Boolean(WorldBossManager.Instance.bossInfo))
               {
                  _loc7_ = WorldBossManager.Instance.bossInfo.fightOver;
               }
               _loc5_ = HallIcon.WONDERFULPLAY;
               _loc6_ = 2;
               break;
            case HallIconType.CRYPT_BOSS:
               _loc5_ = HallIcon.WONDERFULPLAY;
               _loc6_ = 15;
               break;
            case HallIconType.LIMITACTIVITY:
               if(EnableFunc.OpenWonderfulActivity)
               {
                  _loc5_ = HallIcon.ACTIVITY;
                  _loc6_ = 4;
                  break;
               }
               break;
         }
         var _loc8_:HallIconInfo = new HallIconInfo();
         _loc8_.halltype = _loc5_;
         _loc8_.icontype = param1;
         _loc8_.isopen = param2;
         _loc8_.timemsg = param3;
         _loc8_.fightover = false;
         _loc8_.orderid = _loc6_;
         _loc8_.num = param4;
         return _loc8_;
      }
      
      public function showCommonFrame(param1:DisplayObject, param2:String = "", param3:Number = 530, param4:Number = 545) : Frame
      {
         var _loc5_:Frame = ComponentFactory.Instance.creatCustomObject("hallIcon.commonFrame");
         _loc5_.titleText = LanguageMgr.GetTranslation(param2);
         _loc5_.width = param3;
         _loc5_.height = param4;
         _loc5_.addToContent(param1);
         _loc5_.addEventListener(FrameEvent.RESPONSE,this.__commonFrameResponse);
         LayerManager.Instance.addToLayer(_loc5_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND,true);
         return _loc5_;
      }
      
      private function __commonFrameResponse(param1:FrameEvent) : void
      {
         var _loc2_:Frame = param1.currentTarget as Frame;
         if(Boolean(_loc2_))
         {
            _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__commonFrameResponse);
            ObjectUtils.disposeAllChildren(_loc2_);
            ObjectUtils.disposeObject(_loc2_);
            _loc2_ = null;
         }
      }
      
      public function checkHallIconExperienceTask(param1:Boolean = true) : void
      {
         if(param1)
         {
            this.model.cacheRightIconTask = null;
         }
         else
         {
            this.model.cacheRightIconTask = {"isCompleted":param1};
         }
         dispatchEvent(new HallIconEvent(HallIconEvent.CHECK_HALLICONEXPERIENCEOPEN));
      }
      
      public function checkCacheRightIconTask() : void
      {
         if(Boolean(this.model.cacheRightIconTask))
         {
            dispatchEvent(new HallIconEvent(HallIconEvent.CHECK_HALLICONEXPERIENCEOPEN,this.model.cacheRightIconTask.isCompleted));
         }
      }
      
      public function checkDefaultIconShow2() : void
      {
         if(EnableFunc.OpenWonderfulActivity)
         {
            this.model.wonderFulPlayIsOpen = true;
            this.model.activityIsOpen = true;
         }
      }
   }
}
