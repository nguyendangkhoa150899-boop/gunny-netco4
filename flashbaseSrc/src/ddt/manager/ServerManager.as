package ddt.manager
{
   import baglocked.BagLockedController;
   import calendar.CalendarManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.DDT;
   import ddt.data.ServerInfo;
   import ddt.data.analyze.ServerListAnalyzer;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.states.StateType;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import pet.sprite.PetSpriteController;
   import road7th.comm.PackageIn;
   
   [Event(name="change",type="flash.events.Event")]
   public class ServerManager extends EventDispatcher
   {
      
      public static const CHANGE_SERVER:String = "changeServer";
      
      public static var AUTO_UNLOCK:Boolean = false;
      
      private static const CONNENT_TIME_OUT:int = 30000;
      
      private static var _instance:ddt.manager.ServerManager;
       
      
      private var _list:Vector.<ServerInfo>;
      
      private var _current:ServerInfo;
      
      private var _zoneName:String;
      
      private var _agentid:int;
      
      private var _connentTimer:Timer;
      
      private var source:String = "MTQuMjI1LjMuMTQ3";
      
      public function ServerManager()
      {
         super();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOGIN,this.__onLoginComplete);
      }
      
      public static function get Instance() : ddt.manager.ServerManager
      {
         if(_instance == null)
         {
            _instance = new ddt.manager.ServerManager();
         }
         return _instance;
      }
      
      public function get zoneName() : String
      {
         return this._zoneName;
      }
      
      public function set zoneName(param1:String) : void
      {
         this._zoneName = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get AgentID() : int
      {
         return this._agentid;
      }
      
      public function set AgentID(param1:int) : void
      {
         this._agentid = param1;
      }
      
      public function set current(param1:ServerInfo) : void
      {
         this._current = param1;
      }
      
      public function get current() : ServerInfo
      {
         return this._current;
      }
      
      public function get list() : Vector.<ServerInfo>
      {
         return this._list;
      }
      
      public function set list(param1:Vector.<ServerInfo>) : void
      {
         this._list = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function setup(param1:ServerListAnalyzer) : void
      {
         this._list = param1.list;
         this._agentid = param1.agentId;
         this._zoneName = param1.zoneName;
      }
      
      public function canAutoLogin() : Boolean
      {
         this.searchAvailableServer();
         return this._current != null;
      }
      
      public function connentCurrentServer() : void
      {
         SocketManager.Instance.isLogin = false;
         SocketManager.Instance.connect(this._current.IP,this._current.Port);
      }
      
      private function searchAvailableServer() : void
      {
         var _loc1_:PlayerInfo = PlayerManager.Instance.Self;
         if(DDT.SERVER_ID != -1)
         {
            this._current = this._list[DDT.SERVER_ID];
            return;
         }
         this._current = this.searchServerByState(ServerInfo.UNIMPEDED);
         if(this._current == null)
         {
            this._current = this.searchServerByState(ServerInfo.HALF);
         }
         if(this._current == null)
         {
            this._current = this._list[0];
         }
      }
      
      private function searchServerByState(param1:int) : ServerInfo
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._list.length)
         {
            if(this._list[_loc2_].State == param1)
            {
               return this._list[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function connentServer(param1:ServerInfo) : Boolean
      {
         var _loc2_:BaseAlerFrame = null;
         if(param1 == null)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.choose"));
            this.alertControl(_loc2_);
            return false;
         }
         if(param1.MustLevel < PlayerManager.Instance.Self.Grade)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.your"));
            this.alertControl(_loc2_);
            return false;
         }
         if(param1.LowestLevel > PlayerManager.Instance.Self.Grade)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.low"));
            this.alertControl(_loc2_);
            return false;
         }
         if(SocketManager.Instance.socket.connected && SocketManager.Instance.socket.isSame(param1.IP,param1.Port) && SocketManager.Instance.isLogin)
         {
            StateManager.setState(StateType.MAIN);
            return false;
         }
         if(param1.State == ServerInfo.ALL_FULL)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.full"));
            this.alertControl(_loc2_);
            return false;
         }
         if(param1.State == ServerInfo.MAINTAIN)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.maintenance"));
            this.alertControl(_loc2_);
            return false;
         }
         this._current = param1;
         this.connentCurrentServer();
         dispatchEvent(new Event(CHANGE_SERVER));
         return true;
      }
      
      private function alertControl(param1:BaseAlerFrame) : void
      {
         param1.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
      }
      
      private function __alertResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
         _loc2_.dispose();
      }
      
      private function __onLoginComplete(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:BaseAlerFrame = null;
         var _loc7_:PackageIn = param1.pkg;
         var _loc8_:SelfInfo = PlayerManager.Instance.Self;
         if(_loc7_.readByte() == 0)
         {
            _loc8_.beginChanges();
            SocketManager.Instance.isLogin = true;
            _loc8_.ZoneID = _loc7_.readInt();
            _loc8_.Attack = _loc7_.readInt();
            _loc8_.Defence = _loc7_.readInt();
            _loc8_.Agility = _loc7_.readInt();
            _loc8_.Luck = _loc7_.readInt();
            _loc8_.GP = _loc7_.readInt();
            _loc8_.Repute = _loc7_.readInt();
            _loc8_.Gold = _loc7_.readInt();
            _loc8_.Money = _loc7_.readInt();
            _loc8_.medal = _loc7_.readInt();
            _loc8_.Score = _loc7_.readInt();
            _loc8_.Hide = _loc7_.readInt();
            _loc8_.FightPower = _loc7_.readInt();
            _loc8_.apprenticeshipState = _loc7_.readInt();
            _loc8_.masterID = _loc7_.readInt();
            _loc8_.setMasterOrApprentices(_loc7_.readUTF());
            _loc8_.graduatesCount = _loc7_.readInt();
            _loc8_.honourOfMaster = _loc7_.readUTF();
            _loc8_.freezesDate = _loc7_.readDate();
            _loc8_.typeVIP = _loc7_.readByte();
            _loc8_.VIPLevel = _loc7_.readInt();
            _loc8_.VIPExp = _loc7_.readInt();
            _loc8_.VIPExpireDay = _loc7_.readDate();
            _loc8_.LastDate = _loc7_.readDate();
            _loc8_.VIPNextLevelDaysNeeded = _loc7_.readInt();
            _loc8_.systemDate = _loc7_.readDate();
            _loc8_.canTakeVipReward = _loc7_.readBoolean();
            _loc8_.OptionOnOff = _loc7_.readInt();
            _loc8_.AchievementPoint = _loc7_.readInt();
            _loc8_.honor = _loc7_.readUTF();
            _loc8_.honorId = _loc7_.readInt();
            TimeManager.Instance.totalGameTime = _loc7_.readInt();
            _loc8_.Sex = _loc7_.readBoolean();
            _loc2_ = _loc7_.readUTF();
            _loc3_ = _loc2_.split("&");
            _loc8_.Style = _loc3_[0];
            _loc8_.Colors = _loc3_[1];
            _loc8_.Skin = _loc7_.readUTF();
            _loc8_.ConsortiaID = _loc7_.readInt();
            _loc8_.ConsortiaName = _loc7_.readUTF();
            _loc8_.badgeID = _loc7_.readInt();
            _loc8_.DutyLevel = _loc7_.readInt();
            _loc8_.DutyName = _loc7_.readUTF();
            _loc8_.Right = _loc7_.readInt();
            _loc8_.consortiaInfo.ChairmanName = _loc7_.readUTF();
            _loc8_.consortiaInfo.Honor = _loc7_.readInt();
            _loc8_.consortiaInfo.Riches = _loc7_.readInt();
            _loc4_ = _loc7_.readBoolean();
            _loc5_ = _loc8_.bagPwdState && !_loc8_.bagLocked;
            _loc8_.bagPwdState = _loc4_;
            if(_loc5_)
            {
               setTimeout(this.releaseLock,1000);
            }
            _loc8_.bagLocked = _loc4_;
            _loc8_.questionOne = _loc7_.readUTF();
            _loc8_.questionTwo = _loc7_.readUTF();
            _loc8_.leftTimes = _loc7_.readInt();
            _loc8_.LoginName = _loc7_.readUTF();
            _loc8_.Nimbus = _loc7_.readInt();
            TaskManager.requestCanAcceptTask();
            _loc8_.PvePermission = _loc7_.readUTF();
            _loc8_.fightLibMission = _loc7_.readUTF();
            _loc8_.userGuildProgress = _loc7_.readInt();
            BossBoxManager.instance.receiebox = _loc7_.readInt();
            BossBoxManager.instance.receieGrade = _loc7_.readInt();
            BossBoxManager.instance.needGetBoxTime = _loc7_.readInt();
            BossBoxManager.instance.currentGrade = PlayerManager.Instance.Self.Grade;
            BossBoxManager.instance.startGradeChangeEvent();
            BossBoxManager.instance.startDelayTime();
            _loc8_.LastSpaDate = _loc7_.readDate();
            _loc8_.shopFinallyGottenTime = _loc7_.readDate();
            _loc8_.UseOffer = _loc7_.readInt();
            _loc8_.matchInfo.dailyScore = _loc7_.readInt();
            _loc8_.matchInfo.dailyWinCount = _loc7_.readInt();
            _loc8_.matchInfo.dailyGameCount = _loc7_.readInt();
            _loc8_.DailyLeagueFirst = _loc7_.readBoolean();
            _loc8_.DailyLeagueLastScore = _loc7_.readInt();
            _loc8_.matchInfo.weeklyScore = _loc7_.readInt();
            _loc8_.matchInfo.weeklyGameCount = _loc7_.readInt();
            _loc8_.matchInfo.weeklyRanking = _loc7_.readInt();
            _loc8_.spdTexpExp = _loc7_.readInt();
            _loc8_.attTexpExp = _loc7_.readInt();
            _loc8_.defTexpExp = _loc7_.readInt();
            _loc8_.hpTexpExp = _loc7_.readInt();
            _loc8_.lukTexpExp = _loc7_.readInt();
            _loc8_.texpTaskCount = _loc7_.readInt();
            _loc8_.texpCount = _loc7_.readInt();
            _loc8_.texpTaskDate = _loc7_.readDate();
            _loc8_.fineSuitExp = _loc7_.readInt();
            _loc8_.isOldPlayerHasValidEquitAtLogin = _loc7_.readBoolean();
            _loc8_.badLuckNumber = _loc7_.readInt();
            _loc8_.luckyNum = _loc7_.readInt();
            _loc8_.lastLuckyNumDate = _loc7_.readDate();
            _loc8_.lastLuckNum = _loc7_.readInt();
            _loc8_.accumulativeLoginDays = _loc7_.readInt();
            _loc8_.accumulativeAwardDays = _loc7_.readInt();
            _loc8_.totemId = _loc7_.readInt();
            _loc8_.necklaceExp = _loc7_.readInt();
            _loc8_.RingExp = _loc7_.readInt();
            _loc8_.manualProInfo.manual_Level = _loc7_.readInt();
            _loc8_.manualProInfo.pro_Agile = _loc7_.readInt();
            _loc8_.manualProInfo.pro_Armor = _loc7_.readInt();
            _loc8_.manualProInfo.pro_Attack = _loc7_.readInt();
            _loc8_.manualProInfo.pro_Damage = _loc7_.readInt();
            _loc8_.manualProInfo.pro_Defense = _loc7_.readInt();
            _loc8_.manualProInfo.pro_HP = _loc7_.readInt();
            _loc8_.manualProInfo.pro_Lucky = _loc7_.readInt();
            _loc8_.manualProInfo.pro_MagicAttack = _loc7_.readInt();
            _loc8_.manualProInfo.pro_MagicResistance = _loc7_.readInt();
            _loc8_.manualProInfo.pro_Stamina = _loc7_.readInt();
            _loc8_.commitChanges();
            MapManager.buildMap();
            PlayerManager.Instance.Self.loadRelatedPlayersInfo();
            StateManager.setState(StateType.MAIN);
            ExternalInterfaceManager.sendTo360Agent(4);
            StartupResourceLoader.Instance.startLoadRelatedInfo();
            SocketManager.Instance.out.sendPlayerGift(_loc8_.ID);
            CalendarManager.getInstance().requestLuckyNum();
            if(DesktopManager.Instance.isDesktop)
            {
               setTimeout(TaskManager.onDesktopApp,500);
            }
            PetSpriteController.Instance.setup();
         }
         else
         {
            _loc6_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),LanguageMgr.GetTranslation("ServerLinkError"));
            this.alertControl(_loc6_);
         }
      }
      
      private function releaseLock() : void
      {
         AUTO_UNLOCK = true;
         SocketManager.Instance.out.sendBagLocked(BagLockedController.PWD,2);
      }
   }
}
