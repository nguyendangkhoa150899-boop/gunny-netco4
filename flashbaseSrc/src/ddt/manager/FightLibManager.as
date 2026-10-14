package ddt.manager
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import ddt.data.analyze.FightLibAwardAnalyzer;
   import ddt.data.fightLib.FightLibAwardInfo;
   import ddt.data.fightLib.FightLibInfo;
   import ddt.data.map.DungeonInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.utils.RequestVairableCreater;
   import fightLib.script.BaseScript;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLVariables;
   import road7th.comm.PackageIn;
   
   public class FightLibManager extends EventDispatcher
   {
      
      private static const PATH:String = "FightLabDropItemList.xml";
      
      public static const GAINAWARD:String = "gainAward";
      
      private static var _ins:ddt.manager.FightLibManager;
       
      
      private var _currentInfo:FightLibInfo;
      
      public var lastInfo:FightLibInfo;
      
      public var lastFightLibMission:String;
      
      private var _lastWin:Boolean = false;
      
      private var _awardList:Array;
      
      private var _script:BaseScript;
      
      private var _reAnswerNum:int;
      
      public var award:Boolean = false;
      
      private var _isWork:Boolean;
      
      public function FightLibManager(param1:SingletonFocer)
      {
         super();
         this.addEvent();
      }
      
      public static function get Instance() : ddt.manager.FightLibManager
      {
         if(_ins == null)
         {
            _ins = new ddt.manager.FightLibManager(new SingletonFocer());
         }
         return _ins;
      }
      
      public function set isWork(param1:Boolean) : void
      {
         this._isWork = param1;
      }
      
      public function get isWork() : Boolean
      {
         return this._isWork;
      }
      
      public function get lastWin() : Boolean
      {
         return this._lastWin;
      }
      
      public function set lastWin(param1:Boolean) : void
      {
         this._lastWin = param1;
      }
      
      private function addEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHT_LIB_INFO_CHANGE,this.__infoChange);
      }
      
      private function __infoChange(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         this.currentInfoID = _loc3_;
         this.currentInfo.beginChange();
         this.currentInfo.difficulty = _loc4_;
         var _loc5_:DungeonInfo = this.findDungInfoByID(_loc3_);
         this.currentInfo.commitChange();
      }
      
      private function findDungInfoByID(param1:int) : DungeonInfo
      {
         var _loc2_:DungeonInfo = null;
         for each(_loc2_ in MapManager.getFightLibList())
         {
            if(_loc2_.ID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getFightLibInfoByID(param1:int) : FightLibInfo
      {
         var _loc2_:FightLibInfo = null;
         var _loc3_:DungeonInfo = this.findDungInfoByID(param1);
         if(Boolean(_loc3_))
         {
            _loc2_ = new FightLibInfo();
            _loc2_.beginChange();
            _loc2_.id = _loc3_.ID;
            _loc2_.description = _loc3_.Description;
            _loc2_.name = _loc3_.Name;
            _loc2_.difficulty = -1;
            _loc2_.requiedLevel = _loc3_.LevelLimits;
            _loc2_.mapID = int(_loc3_.Pic);
            _loc2_.commitChange();
            return _loc2_;
         }
         return null;
      }
      
      public function reset() : void
      {
         this.currentInfo = null;
         this.reAnswerNum = 1;
         if(Boolean(this._script))
         {
            this._script.dispose();
         }
         this._script = null;
      }
      
      public function get currentInfo() : FightLibInfo
      {
         return this._currentInfo;
      }
      
      public function set currentInfo(param1:FightLibInfo) : void
      {
         this._currentInfo = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function set currentInfoID(param1:int) : void
      {
         var _loc2_:FightLibInfo = null;
         if(Boolean(this.currentInfo) && this.currentInfo.id == param1)
         {
            return;
         }
         var _loc3_:DungeonInfo = this.findDungInfoByID(param1);
         if(Boolean(_loc3_))
         {
            _loc2_ = new FightLibInfo();
            _loc2_.beginChange();
            _loc2_.id = _loc3_.ID;
            _loc2_.description = _loc3_.Description;
            _loc2_.name = _loc3_.Name;
            _loc2_.difficulty = -1;
            _loc2_.requiedLevel = _loc3_.LevelLimits;
            _loc2_.mapID = int(_loc3_.Pic);
            _loc2_.commitChange();
            this.currentInfo = _loc2_;
         }
      }
      
      public function get script() : BaseScript
      {
         return this._script;
      }
      
      public function set script(param1:BaseScript) : void
      {
         this._script = param1;
      }
      
      public function get reAnswerNum() : int
      {
         return this._reAnswerNum;
      }
      
      public function set reAnswerNum(param1:int) : void
      {
         this._reAnswerNum = param1;
      }
      
      public function getFightLibAwardInfoByID(param1:int) : FightLibAwardInfo
      {
         var _loc2_:FightLibAwardInfo = null;
         for each(_loc2_ in this._awardList)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function setup() : void
      {
         this.createInitAwardLoader(this.initAwardInfo);
      }
      
      private function createInitAwardLoader(param1:Function) : BaseLoader
      {
         var _loc2_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         var _loc3_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath(PATH),BaseLoader.COMPRESS_TEXT_LOADER,_loc2_);
         _loc3_.loadErrorMessage = LanguageMgr.GetTranslation("tank.fightLib.LoaderAwardInfoError");
         _loc3_.analyzer = new FightLibAwardAnalyzer(param1);
         LoaderManager.Instance.startLoad(_loc3_);
         return _loc3_;
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
      }
      
      private function initAwardInfo(param1:FightLibAwardAnalyzer) : void
      {
         this._awardList = param1.list;
      }
      
      public function gainAward(param1:FightLibInfo) : void
      {
         dispatchEvent(new Event(GAINAWARD));
      }
   }
}

class SingletonFocer
{
    
   
   public function SingletonFocer()
   {
      super();
   }
}
