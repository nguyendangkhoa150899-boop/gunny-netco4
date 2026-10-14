package consortionBattle
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import consortionBattle.event.ConsBatEvent;
   import consortionBattle.player.ConsortiaBattlePlayer;
   import consortionBattle.player.ConsortiaBattlePlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class ConsortiaBattleManager extends EventDispatcher
   {
      
      public static const ICON_AND_MAP_LOAD_COMPLETE:String = "consBatIconMapComplete";
      
      public static const CLOSE:String = "consortiaBattleClose";
      
      public static const MOVE_PLAYER:String = "consortiaBattleMovePlayer";
      
      public static const UPDATE_SCENE_INFO:String = "consortiaBattleUpdateSceneInfo";
      
      public static const HIDE_RECORD_CHANGE:String = "consortiaBattleHideRecordChange";
      
      public static const UPDATE_SCORE:String = "consortiaBattleUpdateScore";
      
      public static const BROADCAST:String = "consortiaBattleBroadcast";
      
      private static var _instance:consortionBattle.ConsortiaBattleManager;
       
      
      public const resourcePrUrl:String = PathManager.SITE_MAIN + "image/factionwar/";
      
      public var isAutoPowerFull:Boolean = false;
      
      private var _isOpen:Boolean = false;
      
      private var _isLoadMapComplete:Boolean = false;
      
      private var _playerDataList:DictionaryData;
      
      private var _buffPlayerList:DictionaryData;
      
      private var _buffCreatePlayerList:DictionaryData;
      
      private var _timer:Timer;
      
      public var isInMainView:Boolean = false;
      
      private var _startTime:Date;
      
      private var _endTime:Date;
      
      private var _isPowerFullUsed:Boolean = true;
      
      private var _isDoubleScoreUsed:Boolean = true;
      
      private var _victoryCount:int;
      
      private var _winningStreak:int;
      
      private var _score:int;
      
      private var _curHp:int;
      
      private var _hideRecord:int = 0;
      
      private var _buyRecordStatus:Array;
      
      private var _isCanEnter:Boolean;
      
      private var _isHadLoadRes:Boolean = false;
      
      private var _isHadShowOpenTip:Boolean = false;
      
      public function ConsortiaBattleManager(param1:IEventDispatcher = null)
      {
         super(param1);
         this._playerDataList = new DictionaryData();
         this._buffPlayerList = new DictionaryData();
         this._buffCreatePlayerList = new DictionaryData();
         this._timer = new Timer(500);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
      }
      
      public static function get instance() : consortionBattle.ConsortiaBattleManager
      {
         if(_instance == null)
         {
            _instance = new consortionBattle.ConsortiaBattleManager();
         }
         return _instance;
      }
      
      public function get playerDataList() : DictionaryData
      {
         return this._playerDataList;
      }
      
      public function get isPowerFullUsed() : Boolean
      {
         return this._isPowerFullUsed;
      }
      
      public function get isDoubleScoreUsed() : Boolean
      {
         return this._isDoubleScoreUsed;
      }
      
      public function get victoryCount() : int
      {
         return this._victoryCount;
      }
      
      public function get winningStreak() : int
      {
         return this._winningStreak;
      }
      
      public function get score() : int
      {
         return this._score;
      }
      
      public function get curHp() : int
      {
         return this._curHp;
      }
      
      public function get isCanEnter() : Boolean
      {
         return this._isCanEnter;
      }
      
      private function timerHandler(param1:TimerEvent) : void
      {
         if(this._buffCreatePlayerList.length <= 0)
         {
            this._timer.stop();
            return;
         }
         var _loc2_:ConsortiaBattlePlayerInfo = this._buffCreatePlayerList.list[0];
         this._buffCreatePlayerList.remove(_loc2_.id);
         if(this._playerDataList.length < 80)
         {
            this._playerDataList.add(_loc2_.id,_loc2_);
         }
      }
      
      public function judgeCreatePlayer(param1:Number, param2:Number) : void
      {
         var _loc3_:ConsortiaBattlePlayerInfo = null;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:ConsortiaBattlePlayerInfo = null;
         var _loc8_:Array = [];
         for each(_loc3_ in this._buffPlayerList)
         {
            _loc5_ = _loc3_.pos.x + param1;
            _loc6_ = _loc3_.pos.y + param2;
            if(_loc5_ > 0 && _loc5_ < 1000 && _loc6_ > 10 && _loc6_ <= 650)
            {
               _loc8_.push(_loc3_.id);
            }
         }
         for each(_loc4_ in _loc8_)
         {
            _loc7_ = this._buffPlayerList[_loc4_];
            this._buffPlayerList.remove(_loc4_);
            this._buffCreatePlayerList.add(_loc7_.id,_loc7_);
         }
         if(_loc8_.length > 0 && !this._timer.running)
         {
            this._timer.start();
         }
      }
      
      public function getBuyRecordStatus(param1:int) : Object
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         if(!this._buyRecordStatus)
         {
            this._buyRecordStatus = [];
            _loc2_ = 0;
            while(_loc2_ < 4)
            {
               _loc3_ = {};
               _loc3_.isNoPrompt = false;
               _loc3_.isBand = false;
               this._buyRecordStatus.push(_loc3_);
               _loc2_++;
            }
         }
         return this._buyRecordStatus[param1];
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function get isLoadIconMapComplete() : Boolean
      {
         return this._isLoadMapComplete;
      }
      
      public function get beforeStartTime() : int
      {
         if(!this._startTime)
         {
            return 0;
         }
         return this.getDateHourTime(this._startTime) - this.getDateHourTime(TimeManager.Instance.Now());
      }
      
      public function get toEndTime() : int
      {
         if(!this._endTime)
         {
            return 0;
         }
         return this.getDateHourTime(this._endTime) - this.getDateHourTime(TimeManager.Instance.Now());
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_BATTLE,this.pkgHandler);
      }
      
      private function getDateHourTime(param1:Date) : int
      {
         return int(param1.hours * 3600 + param1.minutes * 60 + param1.seconds);
      }
      
      public function changeHideRecord(param1:int, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         if(param2)
         {
            if(param1 == 1)
            {
               _loc3_ = 4;
            }
            else if(param1 == 2)
            {
               _loc3_ = 2;
            }
            else
            {
               _loc3_ = 1;
            }
            this._hideRecord |= _loc3_;
         }
         else
         {
            if(param1 == 1)
            {
               _loc3_ = 3;
            }
            else if(param1 == 2)
            {
               _loc3_ = 5;
            }
            else
            {
               _loc3_ = 6;
            }
            this._hideRecord &= _loc3_;
         }
         dispatchEvent(new Event(HIDE_RECORD_CHANGE));
      }
      
      public function isHide(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         if(param1 == 1)
         {
            _loc2_ = 4;
         }
         else if(param1 == 2)
         {
            _loc2_ = 2;
         }
         else
         {
            _loc2_ = 1;
         }
         if((this._hideRecord & _loc2_) == 0)
         {
            return false;
         }
         return true;
      }
      
      public function judgePlayerVisible(param1:ConsortiaBattlePlayer) : Boolean
      {
         if(param1.playerData.id == PlayerManager.Instance.Self.ID)
         {
            return true;
         }
         if(ConsortiaBattleManager.instance.isHide(1) && param1.playerData.selfOrEnemy == 1)
         {
            return false;
         }
         if(ConsortiaBattleManager.instance.isHide(2) && param1.isInTomb)
         {
            return false;
         }
         if(ConsortiaBattleManager.instance.isHide(3) && param1.isInFighting)
         {
            return false;
         }
         return true;
      }
      
      public function addEntryBtn(param1:Boolean, param2:String = null) : void
      {
         ConsortiaBattleManager.instance.addEventListener(ConsortiaBattleManager.CLOSE,this.closeHandler);
         if(param2 != "" && param2 != null)
         {
            //HallIconManager.instance.updateSwitchHandler(HallIconType.CONSORTIABATTLE,param1,param2);
         }
         if(ConsortiaBattleManager.instance.isLoadIconMapComplete)
         {
            //HallIconManager.instance.updateSwitchHandler(HallIconType.CONSORTIABATTLE,param1,param2);
         }
         if(!this._isHadLoadRes)
         {
            this.loadMap();
            this._isHadLoadRes = true;
         }
      }
      
      private function closeHandler(param1:Event) : void
      {
         //HallIconManager.instance.updateSwitchHandler(HallIconType.CONSORTIABATTLE,false);
      }
      
      private function pkgHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:Boolean = false;
         _loc2_ = param1.pkg;
         var _loc4_:int = _loc2_.readByte();
         switch(_loc4_)
         {
            case ConsBatPackageType.START_OR_CLOSE:
               this.openOrCloseHandler(_loc2_);
               break;
            case ConsBatPackageType.ENTER_SELF_INFO:
               _loc3_ = _loc2_.readBoolean();
               this.initSelfInfo(_loc2_);
               if(_loc3_)
               {
                  StateManager.setState(StateType.CONSORTIA_BATTLE_SCENE);
               }
               break;
            case ConsBatPackageType.ADD_PLAYER:
               this.addPlayerInfo(_loc2_);
               break;
            case ConsBatPackageType.PLAYER_MOVE:
               this.movePlayer(_loc2_);
               break;
            case ConsBatPackageType.DELETE_PLAYER:
               this.deletePlayer(_loc2_);
               break;
            case ConsBatPackageType.PLAYER_STATUS:
               this.updatePlayerStatus(_loc2_);
               break;
            case ConsBatPackageType.UPDATE_SCENE_INFO:
               this.updateSceneInfo(_loc2_);
               break;
            case ConsBatPackageType.UPDATE_SCORE:
               this.updateScore(_loc2_);
               break;
            case ConsBatPackageType.SPLIT_MERGE:
               this.splitMergeHandler();
               break;
            case ConsBatPackageType.BROADCAST:
               this.broadcastHandler(_loc2_);
         }
      }
      
      private function broadcastHandler(param1:PackageIn) : void
      {
         var _loc2_:ConsBatEvent = new ConsBatEvent(BROADCAST);
         _loc2_.data = param1;
         dispatchEvent(_loc2_);
      }
      
      private function splitMergeHandler() : void
      {
         var _loc1_:* = null;
         if(!this.isInMainView)
         {
            return;
         }
         for(_loc1_ in this._playerDataList)
         {
            if(int(_loc1_) != PlayerManager.Instance.Self.ID)
            {
               this._playerDataList.remove(_loc1_);
            }
         }
         this._buffPlayerList = new DictionaryData();
         this._buffCreatePlayerList = new DictionaryData();
         SocketManager.Instance.out.sendConsBatRequestPlayerInfo();
      }
      
      private function updateScore(param1:PackageIn) : void
      {
         if(!this.isInMainView)
         {
            return;
         }
         var _loc2_:ConsBatEvent = new ConsBatEvent(UPDATE_SCORE);
         _loc2_.data = param1;
         dispatchEvent(_loc2_);
      }
      
      private function updateSceneInfo(param1:PackageIn) : void
      {
         this._curHp = param1.readInt();
         this._victoryCount = param1.readInt();
         this._winningStreak = param1.readInt();
         this._score = param1.readInt();
         this._isPowerFullUsed = param1.readBoolean();
         this._isDoubleScoreUsed = param1.readBoolean();
         var _loc2_:ConsortiaBattlePlayerInfo = this._playerDataList[PlayerManager.Instance.Self.ID] as ConsortiaBattlePlayerInfo;
         if(Boolean(_loc2_))
         {
            _loc2_.tombstoneEndTime = param1.readDate();
         }
         dispatchEvent(new Event(UPDATE_SCENE_INFO));
      }
      
      private function updatePlayerStatus(param1:PackageIn) : void
      {
         var _loc2_:ConsortiaBattlePlayerInfo = null;
         var _loc3_:int = param1.readInt();
         if(!this.isInMainView && _loc3_ != PlayerManager.Instance.Self.ID)
         {
            return;
         }
         if(Boolean(this._playerDataList[_loc3_]))
         {
            _loc2_ = this._playerDataList[_loc3_];
         }
         else if(Boolean(this._buffPlayerList[_loc3_]))
         {
            _loc2_ = this._buffPlayerList[_loc3_];
         }
         else
         {
            _loc2_ = this._buffCreatePlayerList[_loc3_];
         }
         if(Boolean(_loc2_))
         {
            _loc2_.tombstoneEndTime = param1.readDate();
            _loc2_.status = param1.readByte();
            _loc2_.pos = new Point(param1.readInt(),param1.readInt());
            _loc2_.winningStreak = param1.readInt();
            _loc2_.failBuffCount = param1.readInt();
            if(_loc2_ == this._playerDataList[_loc3_])
            {
               this._playerDataList.add(_loc2_.id,_loc2_);
            }
         }
      }
      
      private function deletePlayer(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readInt();
         if(_loc2_ == PlayerManager.Instance.Self.ID)
         {
            StateManager.setState(StateType.MAIN);
            return;
         }
         if(this.isInMainView)
         {
            this._playerDataList.remove(_loc2_);
            this._buffPlayerList.remove(_loc2_);
            this._buffCreatePlayerList.remove(_loc2_);
         }
      }
      
      private function movePlayer(param1:PackageIn) : void
      {
         var _loc2_:Point = null;
         var _loc3_:ConsBatEvent = null;
         var _loc4_:ConsortiaBattlePlayerInfo = null;
         if(!this.isInMainView)
         {
            return;
         }
         var _loc5_:int = param1.readInt();
         var _loc6_:int = param1.readInt();
         var _loc7_:int = param1.readInt();
         var _loc8_:String = param1.readUTF();
         if(_loc5_ == PlayerManager.Instance.Self.ID)
         {
            return;
         }
         var _loc9_:Array = _loc8_.split(",");
         var _loc10_:Array = [];
         var _loc11_:uint = 0;
         while(_loc11_ < _loc9_.length)
         {
            _loc2_ = new Point(_loc9_[_loc11_],_loc9_[_loc11_ + 1]);
            _loc10_.push(_loc2_);
            _loc11_ += 2;
         }
         if(Boolean(this._playerDataList[_loc5_]))
         {
            _loc3_ = new ConsBatEvent(MOVE_PLAYER);
            _loc3_.data = {
               "id":_loc5_,
               "path":_loc10_
            };
            dispatchEvent(_loc3_);
         }
         else
         {
            if(Boolean(this._buffPlayerList[_loc5_]))
            {
               _loc4_ = this._buffPlayerList[_loc5_];
            }
            else
            {
               _loc4_ = this._buffCreatePlayerList[_loc5_];
            }
            if(Boolean(_loc4_))
            {
               _loc4_.pos = _loc10_[_loc10_.length - 1];
            }
         }
      }
      
      private function addPlayerInfo(param1:PackageIn) : void
      {
         var _loc2_:ConsortiaBattlePlayerInfo = null;
         var _loc3_:int = 0;
         if(!this.isInMainView)
         {
            return;
         }
         var _loc4_:int = param1.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = new ConsortiaBattlePlayerInfo();
            _loc2_.id = param1.readInt();
            _loc2_.tombstoneEndTime = param1.readDate();
            _loc2_.status = param1.readByte();
            _loc2_.pos = new Point(param1.readInt(),param1.readInt());
            _loc2_.sex = param1.readBoolean();
            _loc3_ = param1.readInt();
            if(_loc3_ == PlayerManager.Instance.Self.ConsortiaID)
            {
               _loc2_.selfOrEnemy = 1;
            }
            else
            {
               _loc2_.selfOrEnemy = 2;
            }
            _loc2_.clothIndex = 2;
            _loc2_.consortiaName = param1.readUTF();
            _loc2_.winningStreak = param1.readInt();
            _loc2_.failBuffCount = param1.readInt();
            if(_loc2_.id != PlayerManager.Instance.Self.ID)
            {
               this._buffPlayerList.add(_loc2_.id,_loc2_);
            }
            _loc5_++;
         }
      }
      
      private function initSelfInfo(param1:PackageIn) : void
      {
         var _loc2_:ConsortiaBattlePlayerInfo = new ConsortiaBattlePlayerInfo();
         _loc2_.id = PlayerManager.Instance.Self.ID;
         _loc2_.tombstoneEndTime = param1.readDate();
         _loc2_.pos = new Point(param1.readInt(),param1.readInt());
         _loc2_.sex = PlayerManager.Instance.Self.Sex;
         _loc2_.clothIndex = 1;
         _loc2_.selfOrEnemy = 1;
         _loc2_.consortiaName = PlayerManager.Instance.Self.ConsortiaName;
         this._playerDataList = new DictionaryData();
         this._playerDataList.add(PlayerManager.Instance.Self.ID,_loc2_);
         this._curHp = param1.readInt();
         this._victoryCount = param1.readInt();
         this._winningStreak = param1.readInt();
         this._score = param1.readInt();
         this._isPowerFullUsed = param1.readBoolean();
         this._isDoubleScoreUsed = param1.readBoolean();
      }
      
      public function getPlayerInfo(param1:int) : ConsortiaBattlePlayerInfo
      {
         return this._playerDataList[param1];
      }
      
      public function clearPlayerInfo() : void
      {
         var _loc1_:ConsortiaBattlePlayerInfo = this._playerDataList[PlayerManager.Instance.Self.ID];
         this._playerDataList = new DictionaryData();
         if(Boolean(_loc1_))
         {
            this._playerDataList.add(_loc1_.id,_loc1_);
         }
         this._buffPlayerList = new DictionaryData();
         this._buffCreatePlayerList = new DictionaryData();
      }
      
      private function openOrCloseHandler(param1:PackageIn) : void
      {
         if(param1.readBoolean())
         {
            this._startTime = param1.readDate();
            this._endTime = param1.readDate();
            this._isCanEnter = param1.readBoolean();
            this.open();
         }
         else
         {
            this._isOpen = false;
            this._startTime = null;
            this._endTime = null;
            this._isCanEnter = false;
            this._isHadShowOpenTip = false;
            dispatchEvent(new Event(CLOSE));
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.closePromptTxt"),0,true);
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("ddt.consortiaBattle.closePromptTxt"));
         }
      }
      
      private function open() : void
      {
         this._isOpen = true;
         this._isLoadMapComplete = false;
         if(this._isCanEnter)
         {
            this.loadMap();
         }
         else
         {
            this._isLoadMapComplete = true;
         }
      }
      
      private function loadMap() : void
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(this.resourcePrUrl + "map/factionwarmap.swf",BaseLoader.MODULE_LOADER);
         _loc1_.addEventListener(LoaderEvent.COMPLETE,this.onMapLoadComplete);
         LoaderManager.Instance.startLoad(_loc1_);
      }
      
      private function onMapLoadComplete(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener(LoaderEvent.COMPLETE,this.onMapLoadComplete);
         this._isLoadMapComplete = true;
         if(this.isLoadIconMapComplete)
         {
//            HallIconManager.instance.updateSwitchHandler(HallIconType.CONSORTIABATTLE,this._isOpen);
//            dispatchEvent(new Event(ICON_AND_MAP_LOAD_COMPLETE));
//            if(!this._isHadShowOpenTip)
//            {
//               ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("ddt.consortiaBattle.openPromptTxt"));
//               this._isHadShowOpenTip = true;
//            }
         }
      }
      
      public function createLoader(param1:String) : BitmapLoader
      {
         return LoaderManager.Instance.creatLoader(param1,BaseLoader.BITMAP_LOADER);
      }
   }
}
