package ddt.manager
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.UIModuleTypes;
   import ddt.data.analyze.EffortItemTemplateInfoAnalyzer;
   import ddt.data.effort.EffortCompleteStateInfo;
   import ddt.data.effort.EffortInfo;
   import ddt.data.effort.EffortProgressInfo;
   import ddt.data.effort.EffortQualificationInfo;
   import ddt.data.effort.EffortRewardInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.EffortEvent;
   import ddt.view.UIModuleSmallLoading;
   import effortView.EffortMainFrame;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import newTitle.NewTitleManager;
   import newTitle.model.NewTitleModel;
   import road7th.data.DictionaryData;
   import road7th.utils.DateUtils;
   
   public class EffortManager extends EventDispatcher
   {
      
      private static var _instance:ddt.manager.EffortManager;
       
      
      private var allEfforts:DictionaryData;
      
      private var integrationEfforts:Array;
      
      private var roleEfforts:Array;
      
      private var taskEfforts:Array;
      
      private var duplicateEfforts:Array;
      
      private var combatEfforts:Array;
      
      private var currentEfforts:Array;
      
      private var newlyCompleteEffort:Array;
      
      private var preEfforts:DictionaryData;
      
      private var preTopEfforts:DictionaryData;
      
      private var nextEfforts:DictionaryData;
      
      private var completeEfforts:DictionaryData;
      
      private var completeTopEfforts:DictionaryData;
      
      private var inCompleteEfforts:DictionaryData;
      
      private var progressEfforts:DictionaryData;
      
      private var honorEfforts:Array;
      
      private var completeHonorEfforts:Array;
      
      private var inCompleteHonorEfforts:Array;
      
      private var honorArray:Array;
      
      private var tempPreEfforts:DictionaryData;
      
      private var tempCompleteEfforts:DictionaryData;
      
      private var tempInCompleteEfforts:DictionaryData;
      
      private var tempInCompleteTopEfforts:DictionaryData;
      
      private var tempIntegrationEfforts:Array;
      
      private var tempRoleEfforts:Array;
      
      private var tempTaskEfforts:Array;
      
      private var tempDuplicateEfforts:Array;
      
      private var tempCombatEfforts:Array;
      
      private var tempNewlyCompleteEffort:Array;
      
      private var tempCompleteID:Array;
      
      private var tempAchievementPoint:int;
      
      private var tempPreTopEfforts:DictionaryData;
      
      private var tempCompleteNextEfforts:DictionaryData;
      
      private var tempHonorEfforts:Array;
      
      private var tempCompleteHonorEfforts:Array;
      
      private var tempInCompleteHonorEfforts:Array;
      
      private var _isSelf:Boolean;
      
      private var currentType:int;
      
      private var count:int;
      
      private var _view:EffortMainFrame;
      
      private var _titleEndTimeList:DictionaryData;
      
      public function EffortManager()
      {
         super();
      }
      
      public static function get Instance() : ddt.manager.EffortManager
      {
         if(_instance == null)
         {
            _instance = new ddt.manager.EffortManager();
         }
         return _instance;
      }
      
      public function setup(param1:EffortItemTemplateInfoAnalyzer) : void
      {
         this.allEfforts = param1.list;
         this.initDictionaryData();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACHIEVEMENT_UPDATE,this.__updateAchievement);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACHIEVEMENT_FINISH,this.__AchievementFinish);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACHIEVEMENT_INIT,this.__initializeAchievement);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACHIEVEMENTDATA_INIT,this.__initializeAchievementData);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOOKUP_EFFORT,this.__lookUpEffort);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USER_RANK,this.__userRank);
      }
      
      private function initDictionaryData() : void
      {
         this.preEfforts = new DictionaryData();
         this.preTopEfforts = new DictionaryData();
         this.nextEfforts = new DictionaryData();
         this.progressEfforts = new DictionaryData();
         this.completeEfforts = new DictionaryData();
         this.completeTopEfforts = new DictionaryData();
         this.inCompleteEfforts = new DictionaryData();
      }
      
      public function getProgressEfforts() : DictionaryData
      {
         return this.progressEfforts;
      }
      
      public function getEffortByID(param1:int) : EffortInfo
      {
         if(!this.allEfforts)
         {
            return null;
         }
         return this.allEfforts[param1];
      }
      
      public function getIntegrationEffort() : Array
      {
         return this.integrationEfforts;
      }
      
      public function getRoleEffort() : Array
      {
         return this.roleEfforts;
      }
      
      public function getTaskEffort() : Array
      {
         return this.taskEfforts;
      }
      
      public function getDuplicateEffort() : Array
      {
         return this.duplicateEfforts;
      }
      
      public function getCombatEffort() : Array
      {
         return this.combatEfforts;
      }
      
      public function getNewlyCompleteEffort() : Array
      {
         return this.newlyCompleteEffort;
      }
      
      public function getHonorArray() : Array
      {
         return this.honorArray;
      }
      
      private function splitHonorEffort() : void
      {
         var _loc1_:EffortInfo = null;
         var _loc2_:int = 0;
         this.honorEfforts = [];
         this.completeHonorEfforts = [];
         this.inCompleteHonorEfforts = [];
         for each(_loc1_ in this.allEfforts)
         {
            if(Boolean(_loc1_.effortRewardArray))
            {
               _loc2_ = 0;
               while(_loc2_ < _loc1_.effortRewardArray.length)
               {
                  if((_loc1_.effortRewardArray[_loc2_] as EffortRewardInfo).RewardType == 1)
                  {
                     this.honorEfforts.push(_loc1_);
                     if(Boolean(_loc1_.CompleteStateInfo))
                     {
                        this.completeHonorEfforts.push(_loc1_);
                     }
                     else
                     {
                        this.inCompleteHonorEfforts.push(_loc1_);
                     }
                  }
                  _loc2_++;
               }
            }
         }
      }
      
      public function getHonorEfforts() : Array
      {
         this.splitHonorEffort();
         return this.honorEfforts;
      }
      
      public function getCompleteHonorEfforts() : Array
      {
         this.splitHonorEffort();
         return this.completeHonorEfforts;
      }
      
      public function getInCompleteHonorEfforts() : Array
      {
         this.splitHonorEffort();
         return this.inCompleteHonorEfforts;
      }
      
      public function get completeList() : DictionaryData
      {
         return this.completeEfforts;
      }
      
      public function get fullList() : DictionaryData
      {
         return this.allEfforts;
      }
      
      public function get currentEffortList() : Array
      {
         return this.currentEfforts;
      }
      
      public function set currentEffortList(param1:Array) : void
      {
         this.currentEfforts = [];
         this.currentEfforts = param1;
         dispatchEvent(new EffortEvent(EffortEvent.LIST_CHANGED));
      }
      
      public function setEffortType(param1:int) : void
      {
         this.currentType = param1;
         switch(param1)
         {
            case 0:
               this.splitEffort(this.preTopEfforts);
               break;
            case 1:
               this.splitEffort(this.completeTopEfforts);
               break;
            case 2:
               this.splitEffort(this.inCompleteEfforts);
         }
         dispatchEvent(new EffortEvent(EffortEvent.TYPE_CHANGED));
      }
      
      private function splitEffort(param1:DictionaryData) : void
      {
         var _loc2_:EffortInfo = null;
         if(!param1)
         {
            return;
         }
         this.integrationEfforts = [];
         this.roleEfforts = [];
         this.taskEfforts = [];
         this.duplicateEfforts = [];
         this.combatEfforts = [];
         for each(_loc2_ in param1)
         {
            if(!_loc2_)
            {
               continue;
            }
            switch(_loc2_.PlaceID)
            {
               case 0:
                  this.integrationEfforts.push(_loc2_);
                  break;
               case 1:
                  this.roleEfforts.push(_loc2_);
                  break;
               case 2:
                  this.taskEfforts.push(_loc2_);
                  break;
               case 3:
                  this.duplicateEfforts.push(_loc2_);
                  break;
               case 4:
                  this.combatEfforts.push(_loc2_);
                  break;
            }
         }
      }
      
      private function __updateAchievement(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:EffortProgressInfo = null;
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new EffortProgressInfo();
            _loc2_.RecordID = param1.pkg.readInt();
            _loc2_.Total = param1.pkg.readInt();
            this.progressEfforts[_loc2_.RecordID] = _loc2_;
            this.updateProgress(_loc2_);
            _loc4_++;
         }
      }
      
      private function __initializeAchievement(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:EffortProgressInfo = null;
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new EffortProgressInfo();
            _loc2_.RecordID = param1.pkg.readInt();
            _loc2_.Total = param1.pkg.readInt();
            this.progressEfforts.add(_loc2_.RecordID,_loc2_);
            _loc4_++;
         }
         this.updateWholeProgress();
         this.splitHonorEffort();
      }
      
      private function __initializeAchievementData(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:EffortCompleteStateInfo = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Date = null;
         this.newlyCompleteEffort = [];
         var _loc7_:int = param1.pkg.readInt();
         this.count = _loc7_;
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc2_ = new EffortCompleteStateInfo();
            _loc2_.ID = param1.pkg.readInt();
            _loc3_ = param1.pkg.readInt();
            _loc4_ = param1.pkg.readInt();
            _loc5_ = param1.pkg.readInt();
            _loc6_ = new Date(_loc3_,_loc4_ - 1,_loc5_);
            _loc2_.CompletedDate = _loc6_;
            if(Boolean(this.allEfforts[_loc2_.ID]))
            {
               (this.allEfforts[_loc2_.ID] as EffortInfo).CompleteStateInfo = _loc2_;
               (this.allEfforts[_loc2_.ID] as EffortInfo).completedDate = _loc2_.CompletedDate;
               if(_loc8_ < 4)
               {
                  this.newlyCompleteEffort.push(this.allEfforts[_loc2_.ID]);
               }
            }
            _loc8_++;
         }
         this.splitPreEffort();
      }
      
      public function get titleEndTimeList() : DictionaryData
      {
         return this._titleEndTimeList;
      }
      
      private function __userRank(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc8_:int = 0;
         this._titleEndTimeList = new DictionaryData();
         this.honorArray = [];
         var _loc9_:Array = [];
         var _loc10_:int = param1.pkg.readInt();
         _loc2_ = 0;
         while(_loc2_ < _loc10_)
         {
            _loc3_ = new NewTitleModel();
            _loc4_ = param1.pkg.readInt();
            _loc3_.id = _loc4_;
            _loc3_.Name = param1.pkg.readUTF();
            _loc5_ = param1.pkg.readDate();
            _loc6_ = param1.pkg.readDate();
            _loc3_.Valid = DateUtils.getHourDifference(new Date().time,_loc6_.time) / 24 + 1;
            if(_loc4_ >= NewTitleManager.FIRST_TITLEID)
            {
               NewTitleManager.instance.titleInfo[_loc4_].Valid = _loc3_.Valid;
               this._titleEndTimeList.add(_loc4_,{
                  "id":_loc4_,
                  "endTime":_loc6_.time
               });
               this.honorArray.push(NewTitleManager.instance.titleInfo[_loc4_]);
            }
            else
            {
               _loc7_ = NewTitleManager.instance.getTitleByName(_loc3_.Name);
               if(_loc7_)
               {
                  _loc3_.Desc = _loc7_.Desc;
                  _loc9_.push(_loc3_);
               }
            }
            _loc2_++;
         }
         this.honorArray.sortOn("id",16);
         _loc8_ = 0;
         while(_loc8_ < _loc9_.length)
         {
            this.honorArray.push(_loc9_[_loc8_]);
            _loc8_++;
         }
         dispatchEvent(new EffortEvent("finish"));
      }
      
      private function __userRank2(param1:CrazyTankSocketEvent) : void
      {
         this.honorArray = [];
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this.honorArray.push(param1.pkg.readUTF());
            _loc3_++;
         }
         dispatchEvent(new EffortEvent(EffortEvent.FINISH));
      }
      
      private function splitPreEffort() : void
      {
         var _loc1_:EffortInfo = null;
         for each(_loc1_ in this.allEfforts)
         {
            if(this.estimateEffortState(_loc1_))
            {
               this.preEfforts.add(_loc1_.ID,_loc1_);
            }
            if(this.estimateEffortState(_loc1_) && (this.isTopEffort(_loc1_) || !_loc1_.CompleteStateInfo))
            {
               this.preTopEfforts.add(_loc1_.ID,_loc1_);
            }
            else if(!this.estimateEffortState(_loc1_))
            {
               this.nextEfforts.add(_loc1_.ID,_loc1_);
            }
         }
         this.splitCompleteEffort();
         this.splitEffort(this.preEfforts);
      }
      
      private function inCompletedToPreTopEfforts() : void
      {
         var _loc1_:EffortInfo = null;
         var _loc2_:Array = null;
         var _loc3_:EffortInfo = null;
         var _loc4_:int = 0;
         for each(_loc1_ in this.completeEfforts)
         {
            _loc2_ = this.getFellNextEffort(_loc1_.ID);
            _loc2_.sortOn("ID");
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = _loc2_[_loc4_] as EffortInfo;
               if(!_loc3_.CompleteStateInfo && !this.isTopEffort(_loc3_))
               {
                  this.preTopEfforts.add(_loc3_.ID,_loc3_);
                  return;
               }
               _loc4_++;
            }
         }
      }
      
      private function estimateEffortState(param1:EffortInfo) : Boolean
      {
         var _loc2_:Array = [];
         _loc2_ = param1.PreAchievementID.split(",");
         if(_loc2_.length == 2 && _loc2_[0] == "0")
         {
            return true;
         }
         var _loc3_:int = 0;
         while(_loc3_ <= _loc2_.length)
         {
            if(_loc2_[_loc3_] == "")
            {
               break;
            }
            if((this.allEfforts[int(_loc2_[_loc3_])] as EffortInfo).CompleteStateInfo == null)
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      public function getTopEffort(param1:EffortInfo) : int
      {
         if(this.isTopEffort(param1) || !param1.CompleteStateInfo)
         {
            return param1.ID;
         }
         var _loc2_:int = 1;
         while(true)
         {
            if(this.isTopEffort(this.getEffortByID(param1.ID - _loc2_)))
            {
               return this.getEffortByID(param1.ID - _loc2_).ID;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function getCompleteNextEffort(param1:int) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         if(Boolean(this.completeEfforts[param1]))
         {
            _loc3_.push(this.completeEfforts[param1]);
         }
         var _loc5_:int = 1;
         while(true)
         {
            if(!Boolean(this.completeEfforts[param1 + _loc5_]))
            {
               return _loc3_;
            }
            _loc4_ = (this.completeEfforts[param1 + _loc5_] as EffortInfo).PreAchievementID.split(",");
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length)
            {
               if(this.isTopEffort(this.completeEfforts[param1 + _loc5_]))
               {
                  return _loc3_;
               }
               if(param1 + _loc5_ - 1 == int(_loc4_[_loc2_]))
               {
                  _loc3_.push(this.completeEfforts[param1 + _loc5_]);
               }
               _loc2_++;
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function getFellNextEffort(param1:int) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         if(Boolean(this.allEfforts[param1]))
         {
            _loc3_.push(this.allEfforts[param1]);
         }
         var _loc5_:int = 1;
         while(true)
         {
            if(!Boolean(this.allEfforts[param1 + _loc5_]))
            {
               return _loc3_;
            }
            _loc4_ = (this.allEfforts[param1 + _loc5_] as EffortInfo).PreAchievementID.split(",");
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length)
            {
               if(this.isTopEffort(this.allEfforts[param1 + _loc5_]))
               {
                  return _loc3_;
               }
               if(param1 + _loc5_ - 1 == int(_loc4_[_loc2_]))
               {
                  _loc3_.push(this.allEfforts[param1 + _loc5_]);
               }
               _loc2_++;
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      private function splitCompleteEffort() : void
      {
         var _loc1_:EffortInfo = null;
         for each(_loc1_ in this.preEfforts)
         {
            if(_loc1_.CompleteStateInfo != null && this.isTopEffort(_loc1_))
            {
               this.completeTopEfforts.add(_loc1_.ID,_loc1_);
            }
            if(_loc1_.CompleteStateInfo != null)
            {
               this.completeEfforts.add(_loc1_.ID,_loc1_);
            }
            else
            {
               this.inCompleteEfforts.add(_loc1_.ID,_loc1_);
            }
         }
      }
      
      private function __AchievementFinish(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:EffortCompleteStateInfo = new EffortCompleteStateInfo();
         _loc2_.ID = param1.pkg.readInt();
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:int = param1.pkg.readInt();
         var _loc6_:Date = new Date(_loc3_,_loc4_ - 1,_loc5_);
         _loc2_.CompletedDate = _loc6_;
         EffortMovieClipManager.Instance.addQueue(this.allEfforts[_loc2_.ID] as EffortInfo);
         if(Boolean(this.inCompleteEfforts[_loc2_.ID]))
         {
            (this.inCompleteEfforts[_loc2_.ID] as EffortInfo).CompleteStateInfo = _loc2_;
            (this.inCompleteEfforts[_loc2_.ID] as EffortInfo).completedDate = _loc2_.CompletedDate;
         }
         if(Boolean(this.allEfforts[_loc2_.ID]))
         {
            (this.allEfforts[_loc2_.ID] as EffortInfo).CompleteStateInfo = _loc2_;
            (this.allEfforts[_loc2_.ID] as EffortInfo).completedDate = _loc2_.CompletedDate;
         }
         this.completeToInComplete(_loc2_.ID);
         if(Boolean(this.newlyCompleteEffort))
         {
            this.newlyCompleteEffort.unshift(this.completeEfforts[_loc2_.ID]);
         }
         dispatchEvent(new EffortEvent(EffortEvent.FINISH));
      }
      
      private function updateWholeProgress() : void
      {
         var _loc1_:EffortInfo = null;
         var _loc2_:Array = null;
         var _loc3_:EffortInfo = null;
         var _loc4_:EffortQualificationInfo = null;
         var _loc5_:int = 0;
         for each(_loc1_ in this.allEfforts)
         {
            for each(_loc4_ in _loc1_.EffortQualificationList)
            {
               if(Boolean(this.progressEfforts[_loc4_.CondictionType]))
               {
               }
               _loc4_.para2_currentValue = (this.progressEfforts[_loc4_.CondictionType] as EffortProgressInfo).Total;
               _loc1_.addEffortQualification(_loc4_);
            }
            this.allEfforts[_loc1_.ID] = _loc1_;
         }
         _loc2_ = [];
         for each(_loc3_ in this.allEfforts)
         {
            if(this.testEffortIsComplete(_loc3_))
            {
               _loc2_.push(_loc3_);
            }
         }
         _loc2_.sortOn("ID");
         if(this.count != _loc2_.length)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               SocketManager.Instance.out.sendAchievementFinish(_loc2_[_loc5_].ID);
               _loc5_++;
            }
         }
      }
      
      private function updateProgress(param1:EffortProgressInfo) : void
      {
         var _loc2_:EffortInfo = null;
         var _loc3_:EffortInfo = null;
         var _loc4_:EffortInfo = null;
         var _loc5_:EffortQualificationInfo = null;
         var _loc6_:Array = [];
         for each(_loc2_ in this.allEfforts)
         {
            for each(_loc5_ in _loc2_.EffortQualificationList)
            {
               if(_loc5_.CondictionType == param1.RecordID)
               {
                  _loc5_.para2_currentValue = param1.Total;
                  _loc2_.addEffortQualification(_loc5_);
               }
            }
         }
         for each(_loc3_ in this.inCompleteEfforts)
         {
            if(this.testEffortIsComplete(_loc3_))
            {
               _loc6_.push(_loc3_);
            }
         }
         for each(_loc4_ in this.nextEfforts)
         {
            if(this.testEffortIsComplete(_loc4_))
            {
               _loc6_.push(_loc4_);
            }
         }
         if(Boolean(_loc6_) && Boolean(_loc6_[0]))
         {
            _loc6_.sortOn("ID");
         }
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_.length)
         {
            SocketManager.Instance.out.sendAchievementFinish(_loc6_[_loc7_].ID);
            _loc7_++;
         }
      }
      
      private function testEffortIsComplete(param1:EffortInfo) : Boolean
      {
         var _loc2_:EffortQualificationInfo = null;
         for each(_loc2_ in param1.EffortQualificationList)
         {
            if(_loc2_.para2_currentValue < _loc2_.Condiction_Para2)
            {
               return false;
            }
         }
         return true;
      }
      
      public function splitTitle(param1:String) : String
      {
         var _loc2_:Array = [];
         _loc2_ = param1.split("/");
         if(_loc2_.length > 1 && _loc2_[1] != "")
         {
            if(PlayerManager.Instance.Self.Sex)
            {
               return _loc2_[0];
            }
            return _loc2_[1];
         }
         return _loc2_[0];
      }
      
      public function testFunction(param1:int) : void
      {
      }
      
      private function completeToInComplete(param1:int) : void
      {
         if(Boolean(this.inCompleteEfforts[param1]) && this.isTopEffort(this.inCompleteEfforts[param1]))
         {
            this.completeTopEfforts.add(param1,this.inCompleteEfforts[param1]);
            this.preTopEfforts.add(param1,this.inCompleteEfforts[param1]);
         }
         if(Boolean(this.inCompleteEfforts[param1]))
         {
            this.completeEfforts.add(param1,this.inCompleteEfforts[param1]);
         }
         var _loc2_:Array = this.getFellNextEffort(param1);
         if(param1 == _loc2_[_loc2_.length - 1].ID && (this.allEfforts[param1] as EffortInfo).IsOther)
         {
            this.preTopEfforts.remove(param1);
         }
         this.inCompleteEfforts.remove(param1);
         this.nextToPre();
      }
      
      private function isTopEffort(param1:EffortInfo) : Boolean
      {
         return param1.PreAchievementID == "0,";
      }
      
      private function nextToPre() : void
      {
         var _loc1_:EffortInfo = null;
         for each(_loc1_ in this.nextEfforts)
         {
            if(this.estimateEffortState(_loc1_))
            {
               this.preEfforts.add(_loc1_.ID,_loc1_);
               this.nextEfforts.remove(_loc1_.ID);
               this.nexToPreTop(_loc1_);
               if(this.testEffortIsComplete(_loc1_) && this.isTopEffort(_loc1_))
               {
                  this.completeTopEfforts.add(_loc1_.ID,_loc1_);
               }
               if(this.testEffortIsComplete(_loc1_))
               {
                  this.completeEfforts.add(_loc1_.ID,_loc1_);
               }
               else
               {
                  this.inCompleteEfforts.add(_loc1_.ID,_loc1_);
               }
            }
         }
         this.setEffortType(this.currentType);
      }
      
      private function nexToPreTop(param1:EffortInfo) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(!param1.CompleteStateInfo)
         {
            this.preTopEfforts.add(param1.ID,param1);
            if(param1.PreAchievementID != "0,")
            {
               _loc2_ = [];
               _loc2_ = param1.PreAchievementID.split(",");
               _loc3_ = 0;
               while(_loc3_ <= _loc2_.length)
               {
                  if(_loc2_[_loc3_] == "")
                  {
                     break;
                  }
                  if(Boolean(this.preTopEfforts[int(_loc2_[_loc3_])]) && !this.isTopEffort(this.preTopEfforts[int(_loc2_[_loc3_])]))
                  {
                     this.preTopEfforts.remove(int(_loc2_[_loc3_]));
                  }
                  _loc3_++;
               }
            }
         }
      }
      
      public function lookUpEffort(param1:int) : void
      {
         SocketManager.Instance.out.sendLookupEffort(param1);
      }
      
      private function __lookUpEffort(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:EffortInfo = null;
         this.tempPreEfforts = new DictionaryData();
         this.tempPreTopEfforts = new DictionaryData();
         this.tempCompleteEfforts = new DictionaryData();
         this.tempInCompleteEfforts = new DictionaryData();
         this.tempCompleteNextEfforts = new DictionaryData();
         this.tempInCompleteTopEfforts = new DictionaryData();
         this.tempNewlyCompleteEffort = [];
         this.tempCompleteID = [];
         this.tempAchievementPoint = param1.pkg.readInt();
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc3_ == 0)
            {
               break;
            }
            this.tempCompleteID[_loc4_] = param1.pkg.readInt();
            if(Boolean(this.allEfforts[this.tempCompleteID[_loc4_]]) && this.isTopEffort(this.allEfforts[this.tempCompleteID[_loc4_]]))
            {
               this.tempInCompleteTopEfforts.add(this.tempCompleteID[_loc4_],this.allEfforts[this.tempCompleteID[_loc4_]]);
            }
            if(Boolean(this.allEfforts[this.tempCompleteID[_loc4_]]))
            {
               this.tempCompleteEfforts.add(this.tempCompleteID[_loc4_],this.allEfforts[this.tempCompleteID[_loc4_]]);
            }
            if(_loc4_ < 4)
            {
               this.tempNewlyCompleteEffort[_loc4_] = this.allEfforts[this.tempCompleteID[_loc4_]];
            }
            _loc4_++;
         }
         for each(_loc2_ in this.allEfforts)
         {
            if(this.estimateTempEffortState(_loc2_))
            {
               this.tempPreEfforts.add(_loc2_.ID,_loc2_);
               if(this.isTopEffort(_loc2_) || !this.tempCompleteEfforts[_loc2_.ID])
               {
                  this.tempPreTopEfforts.add(_loc2_.ID,_loc2_);
               }
               if(!this.tempCompleteEfforts[_loc2_.ID])
               {
                  this.tempInCompleteEfforts.add(_loc2_.ID,_loc2_);
               }
            }
         }
         this.setTempEffortType(0);
         this.isSelf = false;
         EffortManager.Instance.switchVisible();
      }
      
      private function estimateTempEffortState(param1:EffortInfo) : Boolean
      {
         var _loc2_:Array = [];
         _loc2_ = param1.PreAchievementID.split(",");
         if(_loc2_.length == 2 && _loc2_[0] == "0")
         {
            return true;
         }
         var _loc3_:int = 0;
         while(_loc3_ <= _loc2_.length)
         {
            if(_loc2_[_loc3_] == "")
            {
               break;
            }
            if(this.tempCompleteEfforts[int(_loc2_[_loc3_])] == null)
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      public function setTempEffortType(param1:int) : void
      {
         switch(param1)
         {
            case 0:
               this.splitTempEffort(this.tempPreTopEfforts);
               break;
            case 1:
               this.splitTempEffort(this.tempInCompleteTopEfforts);
               break;
            case 2:
               this.splitTempEffort(this.tempInCompleteEfforts);
         }
         dispatchEvent(new EffortEvent(EffortEvent.TYPE_CHANGED));
      }
      
      private function splitTempEffort(param1:DictionaryData) : void
      {
         var _loc2_:EffortInfo = null;
         if(!param1)
         {
            return;
         }
         this.tempIntegrationEfforts = [];
         this.tempRoleEfforts = [];
         this.tempTaskEfforts = [];
         this.tempDuplicateEfforts = [];
         this.tempCombatEfforts = [];
         for each(_loc2_ in param1)
         {
            if(!_loc2_)
            {
               continue;
            }
            switch(_loc2_.PlaceID)
            {
               case 0:
                  this.tempIntegrationEfforts.push(_loc2_);
                  break;
               case 1:
                  this.tempRoleEfforts.push(_loc2_);
                  break;
               case 2:
                  this.tempTaskEfforts.push(_loc2_);
                  break;
               case 3:
                  this.tempDuplicateEfforts.push(_loc2_);
                  break;
               case 4:
                  this.tempCombatEfforts.push(_loc2_);
                  break;
            }
         }
      }
      
      public function getTempTopEffort(param1:EffortInfo) : int
      {
         if(this.isTopEffort(param1) || !this.tempEffortIsComplete(param1.ID))
         {
            return param1.ID;
         }
         var _loc2_:int = 1;
         while(true)
         {
            if(this.isTopEffort(this.getEffortByID(param1.ID - _loc2_)))
            {
               return this.getEffortByID(param1.ID - _loc2_).ID;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function getTempCompleteNextEffort(param1:int) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         if(this.tempEffortIsComplete(param1))
         {
            _loc3_.push(this.tempCompleteEfforts[param1]);
         }
         var _loc5_:int = 1;
         while(true)
         {
            if(!Boolean(this.tempCompleteEfforts[param1 + _loc5_]))
            {
               return _loc3_;
            }
            _loc4_ = (this.tempCompleteEfforts[param1 + _loc5_] as EffortInfo).PreAchievementID.split(",");
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length)
            {
               if(this.isTopEffort(this.tempCompleteEfforts[param1 + _loc5_]))
               {
                  return _loc3_;
               }
               if(param1 + _loc5_ - 1 == int(_loc4_[_loc2_]))
               {
                  _loc3_.push(this.tempCompleteEfforts[param1 + _loc5_]);
               }
               _loc2_++;
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      private function splitTempHonorEffort() : void
      {
         var _loc1_:EffortInfo = null;
         var _loc2_:int = 0;
         this.tempHonorEfforts = [];
         this.tempCompleteHonorEfforts = [];
         this.tempInCompleteHonorEfforts = [];
         for each(_loc1_ in this.allEfforts)
         {
            if(Boolean(_loc1_.effortRewardArray))
            {
               _loc2_ = 0;
               while(_loc2_ < _loc1_.effortRewardArray.length)
               {
                  if((_loc1_.effortRewardArray[_loc2_] as EffortRewardInfo).RewardType == 1)
                  {
                     this.tempHonorEfforts.push(_loc1_);
                     if(EffortManager.Instance.tempEffortIsComplete(_loc1_.ID))
                     {
                        this.tempCompleteHonorEfforts.push(_loc1_);
                     }
                     else
                     {
                        this.tempInCompleteHonorEfforts.push(_loc1_);
                     }
                  }
                  _loc2_++;
               }
            }
         }
      }
      
      public function getTempHonorEfforts() : Array
      {
         this.splitTempHonorEffort();
         return this.tempHonorEfforts;
      }
      
      public function getTempCompleteHonorEfforts() : Array
      {
         this.splitTempHonorEffort();
         return this.tempCompleteHonorEfforts;
      }
      
      public function getTempInCompleteHonorEfforts() : Array
      {
         this.splitTempHonorEffort();
         return this.tempInCompleteHonorEfforts;
      }
      
      public function tempEffortIsComplete(param1:int) : Boolean
      {
         return this.tempCompleteEfforts[param1];
      }
      
      public function getTempIntegrationEffort() : Array
      {
         return this.tempIntegrationEfforts;
      }
      
      public function getTempRoleEffort() : Array
      {
         return this.tempRoleEfforts;
      }
      
      public function getTempTaskEffort() : Array
      {
         return this.tempTaskEfforts;
      }
      
      public function getTempDuplicateEffort() : Array
      {
         return this.tempDuplicateEfforts;
      }
      
      public function getTempCombatEffort() : Array
      {
         return this.tempCombatEfforts;
      }
      
      public function getTempNewlyCompleteEffort() : Array
      {
         return this.tempNewlyCompleteEffort;
      }
      
      public function set isSelf(param1:Boolean) : void
      {
         this._isSelf = param1;
      }
      
      public function get isSelf() : Boolean
      {
         return this._isSelf;
      }
      
      public function getTempAchievementPoint() : int
      {
         return this.tempAchievementPoint;
      }
      
      public function getMainFrameVisible() : Boolean
      {
         if(this._view == null)
         {
            return false;
         }
         if(Boolean(this._view) && this._view.parent == null)
         {
            return false;
         }
         return true;
      }
      
      public function switchVisible() : void
      {
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.EFFORT);
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
      }
      
      private function __onProgress(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      private function __onUIModuleComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.EFFORT)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            if(this.getMainFrameVisible())
            {
               this.hide();
            }
            else
            {
               if(Boolean(this._view))
               {
                  this.hide();
               }
               this.show();
            }
         }
      }
      
      private function show() : void
      {
         this._view = ComponentFactory.Instance.creatComponentByStylename("effortView.effortMainFrame");
         this._view.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         LayerManager.Instance.addToLayer(this._view,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __frameEvent(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               this.hide();
         }
      }
      
      private function hide() : void
      {
         this._view.removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         this._view.dispose();
         this._view = null;
      }
   }
}
