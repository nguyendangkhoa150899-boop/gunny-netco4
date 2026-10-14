package explorerManual.data
{
   import explorerManual.ExplorerManualManager;
   import explorerManual.data.model.ManualItemInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public class ExplorerManualInfo extends EventDispatcher
   {
      
      public static const P_manualLev:String = "manualLev";
      
      public static const P_debrisInfo:String = "debrisInfo";
      
      public static const P_activePageID:String = "activePageID";
      
      public static const P_progress:String = "progress";
      
      public static const P_manualPro:String = "manualPro";
      
      public static const P_refreshData:String = "manualrefresh";
       
      
      protected var _changedPropeties:Dictionary;
      
      protected var _changeCount:int = 0;
      
      private var _count:int = 0;
      
      private var _manualLev:int = -1;
      
      private var _progress:int;
      
      private var _maxProgress:int = 0;
      
      private var _proLevMaxProgress:int = 0;
      
      private var _curPro:explorerManual.data.ManualLevelProInfo;
      
      private var _nextPro:explorerManual.data.ManualLevelProInfo;
      
      private var _pageAllPro:explorerManual.data.PageItemAllProInfo;
      
      private var _activePageID:Array;
      
      private var _upgradeCondition:explorerManual.data.UpgradeConditonBase;
      
      private var _havePage:int;
      
      private var _conditionCount:int;
      
      private var _debrisInfo:explorerManual.data.ManualPageDebrisInfo;
      
      public function ExplorerManualInfo()
      {
         this._changedPropeties = new Dictionary();
         super();
         this._curPro = new explorerManual.data.ManualLevelProInfo();
         this._nextPro = new explorerManual.data.ManualLevelProInfo();
         this._debrisInfo = new explorerManual.data.ManualPageDebrisInfo();
      }
      
      public function get proLevMaxProgress() : int
      {
         return this._proLevMaxProgress;
      }
      
      public function set proLevMaxProgress(param1:int) : void
      {
         this._proLevMaxProgress = param1;
      }
      
      public function beginChanges() : void
      {
         ++this._changeCount;
      }
      
      public function commitChanges() : void
      {
         --this._changeCount;
         this.invalidate();
      }
      
      protected function invalidate() : void
      {
         if(this._changeCount <= 0)
         {
            this._changeCount = 0;
            this.onProppertiesUpdate();
            this._changedPropeties = new Dictionary(true);
         }
      }
      
      protected function onProppertiesUpdate() : void
      {
         if(Boolean(this._changedPropeties["manualLev"]))
         {
            this.dispatchEvent(new Event("manualLevelChangle"));
         }
         if(Boolean(this._changedPropeties["debrisInfo"]))
         {
            this.dispatchEvent(new Event("updatePageView"));
         }
         if(Boolean(this._changedPropeties["activePageID"]))
         {
            this.dispatchEvent(new Event("pageActiveComplete"));
         }
         if(Boolean(this._changedPropeties["progress"]))
         {
            this.dispatchEvent(new Event("manualProgressUpdate"));
         }
         if(Boolean(this._changedPropeties["manualPro"]))
         {
            this.dispatchEvent(new Event("manualProUpdate"));
         }
         if(Boolean(this._changedPropeties["manualrefresh"]))
         {
            this.dispatchEvent(new Event("manualModelUpdate"));
         }
      }
      
      protected function onPropertiesChanged(param1:String = null) : void
      {
         if(this._changedPropeties == null)
         {
            return;
         }
         if(Boolean(this._changedPropeties[param1]))
         {
            return;
         }
         if(param1 != null)
         {
            this._changedPropeties[param1] = true;
         }
         this.invalidate();
      }
      
      public function get debrisInfo() : explorerManual.data.ManualPageDebrisInfo
      {
         return this._debrisInfo;
      }
      
      public function set debrisInfo(param1:explorerManual.data.ManualPageDebrisInfo) : void
      {
         this._debrisInfo = param1;
         this.onPropertiesChanged("debrisInfo");
      }
      
      public function get conditionCount() : int
      {
         return this._conditionCount;
      }
      
      public function set conditionCount(param1:int) : void
      {
         this._conditionCount = param1;
      }
      
      public function get havePage() : int
      {
         return this._havePage;
      }
      
      public function set havePage(param1:int) : void
      {
         this._havePage = param1;
      }
      
      public function get upgradeCondition() : explorerManual.data.UpgradeConditonBase
      {
         return this._upgradeCondition;
      }
      
      public function set upgradeCondition(param1:explorerManual.data.UpgradeConditonBase) : void
      {
         this._upgradeCondition = param1;
      }
      
      public function get maxProgress() : int
      {
         return this._maxProgress;
      }
      
      public function set maxProgress(param1:int) : void
      {
         this.proLevMaxProgress = this._maxProgress;
         this._maxProgress = param1;
         if(this.proLevMaxProgress == 0)
         {
            this.proLevMaxProgress = this._maxProgress;
         }
      }
      
      public function get activePageID() : Array
      {
         return this._activePageID;
      }
      
      public function set activePageID(param1:Array) : void
      {
         this._activePageID = param1;
         this.onPropertiesChanged("activePageID");
      }
      
      public function chapterProgress(param1:int) : String
      {
         var _loc2_:int = 0;
         var _loc3_:Array = ExplorerManualManager.instance.getAllPageByChapterID(param1);
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            if(this.checkPageActiveByPageID(_loc3_[_loc2_].ID))
            {
               _loc5_++;
            }
            _loc2_++;
         }
         return "<FONT FACE=\'Arial\' SIZE=\'14\' COLOR=\'#FF0000\' ><B>" + _loc5_ + "</B></FONT>" + "/" + _loc4_;
      }
      
      public function checkPageActiveByPageID(param1:int) : Boolean
      {
         return this.activePageID.indexOf(param1) != -1;
      }
      
      public function get pageAllPro() : explorerManual.data.PageItemAllProInfo
      {
         return this._pageAllPro;
      }
      
      public function set pageAllPro(param1:explorerManual.data.PageItemAllProInfo) : void
      {
         this._pageAllPro = param1;
      }
      
      public function get nextPro() : explorerManual.data.ManualLevelProInfo
      {
         return this._nextPro;
      }
      
      public function set nextPro(param1:explorerManual.data.ManualLevelProInfo) : void
      {
         this._nextPro = param1;
      }
      
      public function get curPro() : explorerManual.data.ManualLevelProInfo
      {
         return this._curPro;
      }
      
      public function set curPro(param1:explorerManual.data.ManualLevelProInfo) : void
      {
         this._curPro = param1;
      }
      
      public function get progress() : int
      {
         return this._progress;
      }
      
      public function set progress(param1:int) : void
      {
         if(this._progress == param1)
         {
            return;
         }
         this._progress = param1;
         this.onPropertiesChanged("progress");
      }
      
      public function get manualLev() : int
      {
         return this._manualLev;
      }
      
      public function set manualLev(param1:int) : void
      {
         if(this._manualLev == param1)
         {
            return;
         }
         if(this._manualLev != -1)
         {
            this.onPropertiesChanged("manualLev");
         }
         this._manualLev = param1;
         this.updatePro();
      }
      
      private function updatePro() : void
      {
         var _loc1_:ManualItemInfo = ExplorerManualManager.instance.getAddProItemInfo(this.manualLev);
         this._curPro.update(_loc1_);
         var _loc2_:ManualItemInfo = ExplorerManualManager.instance.getAddProItemInfo(this.manualLev + 1);
         if(Boolean(_loc2_))
         {
            this._nextPro.update(_loc2_);
         }
         else
         {
            this._nextPro = null;
         }
         this.onPropertiesChanged("manualPro");
      }
      
      private function initInfo() : void
      {
         this._pageAllPro = new explorerManual.data.PageItemAllProInfo();
         this._upgradeCondition = new ManualUpgradeCondition();
         this._activePageID = [];
      }
      
      public function clear() : void
      {
         this.initInfo();
      }
      
      public function refreshData() : void
      {
         this.onPropertiesChanged("manualrefresh");
      }
   }
}
