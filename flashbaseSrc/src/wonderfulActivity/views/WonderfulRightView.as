package wonderfulActivity.views
{
   import RechargeRank.views.RechargeRankView;
   import activeEvents.data.ActiveEventsInfo;
   import bigBugleRank.views.BigBugleRankView;
   import calendar.view.ICalendar;
   import carnivalActivity.view.CarnivalActivityView;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import consumeRank.views.ConsumeRankView;
   import fightPowerRank.views.FightPowerRankView;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import giftRank.views.GiftRankView;
   import levelRank.views.LevelRankView;
   import onlineRank.views.OnlineRankView;
   import winGuildRank.views.WinGuildRankView;
   import winLeagueRank.views.WinLeagueRankView;
   import winRank.views.WinRankView;
   import wonderfulActivity.ActivityType;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.ActivityTypeData;
   import wonderfulActivity.data.WonderfulActivityTypeData;
   import wonderfulActivity.items.AccumulativePayView;
   import wonderfulActivity.items.FighterRutrunView;
   import wonderfulActivity.items.HeroView;
   import wonderfulActivity.items.JoinIsPowerView;
   import wonderfulActivity.items.LimitActivityView;
   import wonderfulActivity.items.NewGameBenifitView;
   import wonderfulActivity.items.RechargeReturnView;
   import wonderfulActivity.items.StrengthDarenView;
   import wonderfulActivity.newActivity.AnnouncementAct.AnnouncementActView;
   import wonderfulActivity.newActivity.ExchangeAct.ExchangeActView;
   import wonderfulActivity.newActivity.GetRewardAct.GetRewardActView;
   import wonderfulActivity.newActivity.returnActivity.ReturnActivityView;
   
   public class WonderfulRightView extends Sprite implements Disposeable
   {
       
      
      private var _view:wonderfulActivity.views.IRightView;
      
      private var _tittle:Bitmap;
      
      private var _currentInfo:ActiveEventsInfo;
      
      private var _currentLimitView:ICalendar;
      
      public function WonderfulRightView()
      {
         super();
      }
      
      public function setState(param1:int, param2:int) : void
      {
         if(!this._view)
         {
            return;
         }
         this._view.setState(param1,param2);
      }
      
      public function updateView(param1:String) : void
      {
         var _loc2_:Dictionary = null;
         var _loc3_:ActivityTypeData = null;
         this.dispose();
         if(WonderfulActivityManager.Instance.isExchangeAct)
         {
            _loc2_ = WonderfulActivityManager.Instance.exchangeActLeftViewInfoDic;
         }
         else
         {
            _loc2_ = WonderfulActivityManager.Instance.leftViewInfoDic;
         }
         var _loc4_:int = int(_loc2_[param1].viewType);
         switch(_loc4_)
         {
            case ActivityType.CHONGZHIHUIKUI:
               _loc3_ = WonderfulActivityManager.Instance.activityRechargeList[0];
               this._view = new RechargeReturnView(1,_loc3_);
               break;
            case ActivityType.XIAOFEIHUIKUI:
               _loc3_ = WonderfulActivityManager.Instance.activityExpList[0];
               this._view = new RechargeReturnView(2,_loc3_);
               break;
            case ActivityType.ZHANYOUCHONGZHIHUIKUI:
               _loc3_ = WonderfulActivityManager.Instance.activityFighterList[0];
               this._view = new FighterRutrunView(_loc3_);
               break;
            case ActivityType.HERO:
               this._view = new HeroView();
               break;
            case ActivityType.NEWGAMEBENIFIT:
               this._view = new NewGameBenifitView();
               break;
            case ActivityType.ACCUMULATIVE_PAY:
               this._view = new AccumulativePayView();
               break;
            case ActivityType.STRENGTHEN_DAREN:
               this._view = new StrengthDarenView();
               break;
            case ActivityType.TUANJIE_POWER:
               this._view = new JoinIsPowerView();
               break;
            case ActivityType.ONE_OFF_PAY:
               break;
            case ActivityType.PAY_RETURN:
               this._view = new ReturnActivityView(0,param1);
               break;
            case ActivityType.CONSUME_RETURN:
               this._view = new ReturnActivityView(1,param1);
               break;
            case ActivityType.NORMAL_EXCHANGE:
               this._view = new ExchangeActView(param1);
               break;
            case ActivityType.ACT_ANNOUNCEMENT:
               this._view = new AnnouncementActView(param1);
               break;
            case ActivityType.RECEIVE_ACTIVITY:
               this._view = new GetRewardActView(param1);
               break;
            case ActivityType.RECHARGE_RANK:
               this._view = new RechargeRankView();
               break;
            case ActivityType.CONSUME_RANK:
               this._view = new ConsumeRankView();
               break;
            case ActivityType.FIGHTPOWER_RANK:
               this._view = new FightPowerRankView();
               break;
            case ActivityType.LEVEL_RANK:
               this._view = new LevelRankView();
               break;
            case ActivityType.ONLINE_RANK:
               this._view = new OnlineRankView();
               break;
            case ActivityType.BIGBULE_RANK:
               this._view = new BigBugleRankView();
               break;
            case ActivityType.WIN_RANK:
               this._view = new WinRankView();
               break;
            case ActivityType.WIN_GUILD_RANK:
               this._view = new WinGuildRankView();
               break;
            case ActivityType.WIN_LEAGUE_RANK:
               this._view = new WinLeagueRankView();
               break;
            case ActivityType.GIFT_RANK:
               this._view = new GiftRankView();
               break;
            case ActivityType.MOUNT_MASTER_LEVEL:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.MOUNT_MASTER,WonderfulActivityTypeData.MOUNT_LEVEL);
               break;
            case ActivityType.MOUNT_MASTER_SKILL:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.MOUNT_MASTER,WonderfulActivityTypeData.MOUNT_SKILL);
               break;
            case ActivityType.GOD_TEMPLE_LEVEL:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.GOD_TEMPLE,WonderfulActivityTypeData.GOD_TEMPLE_LEVEL_UP,param1);
               break;
            case ActivityType.CARNIVAL_MOUNT_MASTER:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.CARNIVAL_ACTIVITY,WonderfulActivityTypeData.CARNIVAL_MOUNT_LEVEL);
               break;
            case ActivityType.CARNIVAL_GRADE:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.CARNIVAL_ACTIVITY,WonderfulActivityTypeData.CARNIVAL_GRADE);
               break;
            case ActivityType.CARNIVAL_STRENGTH:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.CARNIVAL_ACTIVITY,WonderfulActivityTypeData.CARNIVAL_STRENGTH);
               break;
            case ActivityType.CARNIVAL_FUSION:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.CARNIVAL_ACTIVITY,WonderfulActivityTypeData.CARNIVAL_FUSION);
               break;
            case ActivityType.CARNIVAL_ROOKIE:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.CARNIVAL_ACTIVITY,WonderfulActivityTypeData.CARNIVAL_ROOKIE);
               break;
            case ActivityType.CARNIVAL_BEAD:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.CARNIVAL_ACTIVITY,WonderfulActivityTypeData.CARNIVAL_BEAD);
               break;
            case ActivityType.CARNIVAL_TOTEM:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.CARNIVAL_ACTIVITY,WonderfulActivityTypeData.CARNIVAL_TOTEM);
               break;
            case ActivityType.CARNIVAL_PRACTICE:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.CARNIVAL_ACTIVITY,WonderfulActivityTypeData.CARNIVAL_PRACTICE);
               break;
            case ActivityType.CARNIVAL_CARD:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.CARNIVAL_ACTIVITY,WonderfulActivityTypeData.CARNIVAL_CARD);
               break;
            case ActivityType.CARNIVAL_ZHANHUN:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.CARNIVAL_ACTIVITY,WonderfulActivityTypeData.CARNIVAL_ZHANHUN);
               break;
            case ActivityType.CARNIVAL_PET:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.CARNIVAL_ACTIVITY,WonderfulActivityTypeData.CARNIVAL_PET);
               break;
            case ActivityType.WHOLEPEOPLE_VIP:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.WHOLEPEOPLE_VIP);
               break;
            case ActivityType.WHOLEPEOPLE_PET:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.WHOLEPEOPLE_PET);
               break;
            case ActivityType.DAILY_GIFT:
               this._view = new CarnivalActivityView(WonderfulActivityTypeData.DAILY_GIFT);
               break;
            default:
               if(Boolean(this._view))
               {
                  this._view.dispose();
                  this._view = null;
               }
         }
         if(_loc4_ >= ActivityType.LIMIT_FLOOR && _loc4_ <= ActivityType.LIMIT_CEILING)
         {
            this._view = new LimitActivityView(_loc4_);
         }
         if(Boolean(this._view))
         {
            this._view.init();
            addChild(this._view.content());
            WonderfulActivityManager.Instance.currentView = this._view;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._view);
         ObjectUtils.disposeObject(this._currentLimitView);
         this._view = null;
         this._currentLimitView = null;
      }
   }
}
