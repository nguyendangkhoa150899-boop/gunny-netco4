package explorerManual
{
   import ddt.CoreManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import explorerManual.analyzer.ChapterItemAnalyzer;
   import explorerManual.analyzer.ManualDebrisAnalyzer;
   import explorerManual.analyzer.ManualItemAnalyzer;
   import explorerManual.analyzer.ManualPageItemAnalyzer;
   import explorerManual.analyzer.ManualUpgradeAnalyzer;
   import explorerManual.data.model.ManualChapterInfo;
   import explorerManual.data.model.ManualDebrisInfo;
   import explorerManual.data.model.ManualItemInfo;
   import explorerManual.data.model.ManualPageItemInfo;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import road7th.data.DictionaryData;
   
   public class ExplorerManualManager extends CoreManager
   {
      
      private static var _instance:explorerManual.ExplorerManualManager;
       
      
      private var _isInitData:Boolean = false;
      
      private var _debrisData:DictionaryData = null;
      
      private var _chapterData:DictionaryData = null;
      
      private var _manualItemData:DictionaryData = null;
      
      private var _manualUpgradeData:Array;
      
      private var _PageItemData:DictionaryData = null;
      
      public function ExplorerManualManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : explorerManual.ExplorerManualManager
      {
         if(_instance == null)
         {
            _instance = new explorerManual.ExplorerManualManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._isInitData = false;
      }
      
      override protected function start() : void
      {
         this.dispatchEvent(new Event("openView"));
      }
      
      public function requestInitData() : void
      {
         SocketManager.Instance.out.requestManualInitData();
      }
      
      public function startUpgrade(param1:Boolean, param2:Boolean, param3:Boolean) : void
      {
         SocketManager.Instance.out.sendManualUpgrade(param1,param2,param3);
      }
      
      public function requestManualPageData(param1:int) : void
      {
         SocketManager.Instance.out.requestManualPageData(param1);
      }
      
      public function sendManualPageActive(param1:int, param2:int) : void
      {
         SocketManager.Instance.out.sendManualPageActive(param1,param2);
      }
      
      public function getManualProInfoByLev(param1:int) : ManualItemInfo
      {
         var _loc2_:* = null;
         if(Boolean(this._manualItemData) && this._manualItemData.hasKey(param1))
         {
            return this._manualItemData[param1] as ManualItemInfo;
         }
         return null;
      }
      
      public function getAddProItemInfo(param1:int) : ManualItemInfo
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:ManualItemInfo = new ManualItemInfo();
         var _loc5_:Array = this._manualItemData.list;
         _loc2_ = 0;
         while(_loc2_ < _loc5_.length)
         {
            if((_loc3_ = _loc5_[_loc2_]).Level <= param1)
            {
               if(_loc3_.Level == param1)
               {
                  _loc4_.Name = _loc3_.Name;
                  _loc4_.Level = _loc3_.Level;
               }
               _loc4_.Boost += _loc3_.Boost;
               _loc4_.MagicAttack += _loc3_.MagicAttack;
               _loc4_.MagicResistance += _loc3_.MagicResistance;
            }
            _loc2_++;
         }
         if(_loc4_.Level == 0)
         {
            return null;
         }
         return _loc4_;
      }
      
      public function getupgradeConditionByLev(param1:int) : Array
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         if(Boolean(this._manualUpgradeData))
         {
            _loc2_ = [];
            _loc3_ = 0;
            while(_loc3_ < this._manualUpgradeData.length)
            {
               if(this._manualUpgradeData[_loc3_].ManualLevel == param1)
               {
                  _loc2_.push(this._manualUpgradeData[_loc3_]);
               }
               _loc3_++;
            }
            return _loc2_;
         }
         return null;
      }
      
      public function getChapterInfoByChapterID(param1:int) : ManualChapterInfo
      {
         var _loc3_:* = undefined;
         var _loc2_:* = null;
         if(Boolean(this._chapterData))
         {
            for each(_loc3_ in this._chapterData)
            {
               if(_loc3_.ID == param1)
               {
                  _loc2_ = _loc3_;
                  break;
               }
            }
         }
         return _loc2_;
      }
      
      public function isHaveNewDebrisForPage(param1:int) : Boolean
      {
         var _loc2_:Array = SharedManager.Instance.manualNewPages;
         return _loc2_.indexOf(param1) != -1;
      }
      
      public function removeNewDebrisForPages(param1:int) : void
      {
         var _loc2_:Array = SharedManager.Instance.manualNewPages;
         if(_loc2_.indexOf(param1) != -1)
         {
            _loc2_.splice(_loc2_.indexOf(param1),1);
            SharedManager.Instance.manualNewPages = _loc2_;
            SharedManager.Instance.save();
         }
      }
      
      public function getChaptersInfo() : Array
      {
         if(Boolean(this._chapterData))
         {
            return this._chapterData.list;
         }
         return null;
      }
      
      public function getAllPageByChapterID(param1:int) : Array
      {
         var _loc3_:* = undefined;
         var _loc2_:* = null;
         if(Boolean(this._PageItemData))
         {
            _loc2_ = [];
            for each(_loc3_ in this._PageItemData)
            {
               if(_loc3_.ChapterID == param1)
               {
                  _loc2_.push(_loc3_);
               }
            }
            return _loc2_;
         }
         return null;
      }
      
      public function getDebrisByPageID(param1:int) : Array
      {
         var _loc3_:* = undefined;
         var _loc2_:* = null;
         if(Boolean(this._debrisData))
         {
            _loc2_ = [];
            for each(_loc3_ in this._debrisData)
            {
               if(_loc3_.PageID == param1)
               {
                  _loc2_.push(_loc3_);
               }
            }
            return _loc2_;
         }
         return null;
      }
      
      public function getDeBrisByDeBrisID(param1:int) : ManualDebrisInfo
      {
         if(Boolean(this._debrisData) && this._debrisData.hasKey(param1))
         {
            return this._debrisData[param1];
         }
         return null;
      }
      
      public function getChapterByPageID(param1:int) : ManualPageItemInfo
      {
         if(Boolean(this._PageItemData) && this._PageItemData.hasKey(param1))
         {
            return this._PageItemData[param1] as ManualPageItemInfo;
         }
         return null;
      }
      
      public function getManualInfoByManualLev(param1:int) : ManualItemInfo
      {
         if(Boolean(this._manualItemData) && this._manualItemData.hasKey(param1))
         {
            return this._manualItemData[param1];
         }
         return null;
      }
      
      public function getAllPageItemCount() : int
      {
         if(Boolean(this._PageItemData))
         {
            return this._PageItemData.length;
         }
         return 0;
      }
      
      public function isHaveNewDebris(param1:int) : Boolean
      {
         var _loc2_:Array = SharedManager.Instance.manualNewChapters;
         return _loc2_.indexOf(param1) != -1;
      }
      
      public function removeNewDebris(param1:int) : void
      {
         var _loc2_:Array = SharedManager.Instance.manualNewChapters;
         if(_loc2_.indexOf(param1) != -1)
         {
            _loc2_.splice(_loc2_.indexOf(param1),1);
            SharedManager.Instance.manualNewChapters = _loc2_;
            SharedManager.Instance.save();
         }
      }
      
      public function initDebrisData(param1:ManualDebrisAnalyzer) : void
      {
         this._debrisData = param1.data;
      }
      
      public function initChapterData(param1:ChapterItemAnalyzer) : void
      {
         this._chapterData = param1.data;
      }
      
      public function initManualItemData(param1:ManualItemAnalyzer) : void
      {
         this._manualItemData = param1.data;
      }
      
      public function initManualUpgradeData(param1:ManualUpgradeAnalyzer) : void
      {
         this._manualUpgradeData = param1.data;
      }
      
      public function initPageItemData(param1:ManualPageItemAnalyzer) : void
      {
         this._PageItemData = param1.data;
      }
      
      public function get isInitData() : Boolean
      {
         return this._isInitData;
      }
      
      public function set isInitData(param1:Boolean) : void
      {
         this._isInitData = param1;
      }
      
      public function set cachNewChapter(param1:Array) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:Array = SharedManager.Instance.manualNewChapters;
         var _loc5_:Array = SharedManager.Instance.manualNewPages;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = this.getChapterByPageID(param1[_loc3_]);
            if(_loc2_ != null)
            {
               if(_loc4_.indexOf(_loc2_.ChapterID) == -1)
               {
                  _loc4_.push(_loc2_.ChapterID);
               }
               if(_loc5_.indexOf(_loc2_.ID) == -1)
               {
                  _loc5_.push(_loc2_.ID);
               }
            }
            _loc3_++;
         }
         SharedManager.Instance.manualNewChapters = _loc4_;
         SharedManager.Instance.manualNewPages = _loc5_;
         SharedManager.Instance.save();
      }
   }
}
