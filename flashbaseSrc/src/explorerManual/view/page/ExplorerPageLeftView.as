package explorerManual.view.page
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import explorerManual.ExplorerManualManager;
   import explorerManual.data.ExplorerManualInfo;
   import explorerManual.data.ManualProType;
   import explorerManual.data.model.ManualPageItemInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ExplorerPageLeftView extends Sprite implements Disposeable
   {
       
      
      private var _titleIcon:Bitmap;
      
      private var _chapterID:int;
      
      private var _curProTitle:FilterFrameText;
      
      private var _titleTxt:FilterFrameText;
      
      private var _curPageInfo:ManualPageItemInfo;
      
      private var _activeStateTitle:FilterFrameText;
      
      private var _model:ExplorerManualInfo;
      
      private var _curProSpri:Sprite;
      
      private var _activeProSpri:Sprite;
      
      private var _totalProSpri:Sprite;
      
      private var _directorySpri:Sprite;
      
      private var _directoryLeftBg:Bitmap;
      
      private var _pageDescribe:FilterFrameText;
      
      public function ExplorerPageLeftView(param1:int, param2:ExplorerManualInfo)
      {
         super();
         this._model = param2;
         this._chapterID = param1;
         this._curProSpri = new Sprite();
         addChild(this._curProSpri);
         this._activeProSpri = new Sprite();
         addChild(this._activeProSpri);
         PositionUtils.setPos(this._activeProSpri,"explorerManual.activeProSpriPos");
         this._totalProSpri = new Sprite();
         addChild(this._totalProSpri);
         PositionUtils.setPos(this._totalProSpri,"explorerManual.totalProSpriPos");
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("explorerManual.pageLeftView.titleTxt");
         this._titleTxt.width = 250;
         addChild(this._titleTxt);
         this._titleIcon = ComponentFactory.Instance.creat("asset.explorerManual.pageLeftView.desc" + this._chapterID);
         addChild(this._titleIcon);
         this._curProTitle = ComponentFactory.Instance.creatComponentByStylename("explorerManual.pageLeftView.curProTitleTxt");
         addChild(this._curProTitle);
         this._curProTitle.text = LanguageMgr.GetTranslation("explorerManual.pagePro");
         PositionUtils.setPos(this._curProTitle,"explorerManual.pageLeft.curProTitlePos");
         this._activeStateTitle = ComponentFactory.Instance.creatComponentByStylename("explorerManual.pageLeftView.curProTitleTxt");
         addChild(this._activeStateTitle);
         PositionUtils.setPos(this._activeStateTitle,"explorerManual.pageLeft.curunActiveProTitlePos");
         this._directorySpri = new Sprite();
         addChild(this._directorySpri);
         this._directorySpri.visible = false;
         this._directoryLeftBg = ComponentFactory.Instance.creatBitmap("asset.explorerManual.directoryleftView.bg");
         this._directorySpri.addChild(this._directoryLeftBg);
         this._pageDescribe = ComponentFactory.Instance.creatComponentByStylename("explorerManual.leftView.pageDescribe");
         this._directorySpri.addChild(this._pageDescribe);
      }
      
      private function initEvent() : void
      {
         if(Boolean(this._model))
         {
            this._model.addEventListener("pageActiveComplete",this.__activeUpdateHandler);
            this._model.addEventListener("manualModelUpdate",this.__manualModelUpdateHandler);
         }
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._model))
         {
            this._model.removeEventListener("pageActiveComplete",this.__activeUpdateHandler);
            this._model.removeEventListener("manualModelUpdate",this.__manualModelUpdateHandler);
         }
      }
      
      private function __manualModelUpdateHandler(param1:Event) : void
      {
         this.allProData();
      }
      
      private function __activeUpdateHandler(param1:Event) : void
      {
         var _loc2_:Boolean = this._model.checkPageActiveByPageID(this._curPageInfo.ID);
         this._activeStateTitle.text = LanguageMgr.GetTranslation("explorerManual.activeProState") + (_loc2_ ? LanguageMgr.GetTranslation("explorerManual.active") : LanguageMgr.GetTranslation("explorerManual.unActive"));
      }
      
      public function set pageInfo(param1:ManualPageItemInfo) : void
      {
         this.clear();
         this._curPageInfo = param1;
         this.visibleView();
         if(this._curPageInfo.Sort == 0)
         {
            this.allProData();
         }
         else
         {
            this.updateData();
         }
      }
      
      private function updatePageDescris() : void
      {
         this._pageDescribe.text = ExplorerManualManager.instance.getChapterInfoByChapterID(this._chapterID).Describe;
      }
      
      private function visibleView() : void
      {
         if(Boolean(this._directorySpri))
         {
            this._directorySpri.visible = this._curPageInfo.Sort == 0;
         }
         if(Boolean(this._titleTxt))
         {
            this._titleTxt.visible = this._curPageInfo.Sort > 0;
         }
         if(Boolean(this._activeStateTitle))
         {
            this._activeStateTitle.visible = this._curPageInfo.Sort > 0;
         }
         this._curProTitle.visible = this._curPageInfo.Sort > 0;
      }
      
      public function set curChapter(param1:int) : void
      {
         this._chapterID = param1;
         this.updateTitleIcon();
         this.updatePageDescris();
      }
      
      private function updateTitleIcon() : void
      {
         if(Boolean(this._titleIcon))
         {
            ObjectUtils.disposeObject(this._titleIcon);
         }
         this._titleIcon = ComponentFactory.Instance.creat("asset.explorerManual.pageLeftView.desc" + this._chapterID);
         addChild(this._titleIcon);
      }
      
      private function clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this._curPageInfo = null;
         if(Boolean(this._curProSpri))
         {
            _loc1_ = 0;
            while(_loc1_ < this._curProSpri.numChildren)
            {
               ObjectUtils.disposeObject(this._curProSpri.getChildAt(_loc1_));
               _loc1_++;
            }
            this._curProSpri.removeChildren();
         }
         if(Boolean(this._activeProSpri))
         {
            _loc2_ = 0;
            while(_loc2_ < this._activeProSpri.numChildren)
            {
               ObjectUtils.disposeObject(this._activeProSpri.getChildAt(_loc2_));
               _loc2_++;
            }
            this._activeProSpri.removeChildren();
         }
         if(Boolean(this._totalProSpri))
         {
            _loc3_ = 0;
            while(_loc3_ < this._totalProSpri.numChildren)
            {
               ObjectUtils.disposeObject(this._totalProSpri.getChildAt(_loc3_));
               _loc3_++;
            }
            this._totalProSpri.removeChildren();
         }
      }
      
      private function updateData() : void
      {
         this._titleTxt.text = this._curPageInfo.Name;
         this.curProData();
         this.activeProData();
         this.allProData();
         this.__activeUpdateHandler(null);
      }
      
      private function curProData() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = ManualProType.collectProArr;
         var _loc5_:Array = LanguageMgr.GetTranslation("explorerManual.manualAllPro.name").split(",");
         _loc2_ = 0;
         while(_loc2_ < _loc4_.length)
         {
            if(int(this._curPageInfo[_loc4_[_loc2_]]) > 0)
            {
               _loc1_ = ComponentFactory.Instance.creatComponentByStylename("explorerManual.pageLeftView.curProValueTxt");
               this._curProSpri.addChild(_loc1_);
               _loc1_.text = _loc5_[_loc2_] + " +" + this._curPageInfo[_loc4_[_loc2_]];
               _loc1_.x = 100 * (_loc3_ % 2) + 66;
               _loc1_.y = 163 + int(_loc3_ / 2) * 20;
               _loc3_++;
               if(_loc3_ >= 4)
               {
                  return;
               }
            }
            _loc2_++;
         }
      }
      
      private function activeProData() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = ManualProType.activateProArr;
         var _loc5_:Array = LanguageMgr.GetTranslation("explorerManual.manualAllPro.name").split(",");
         _loc2_ = 0;
         while(_loc2_ < _loc4_.length)
         {
            if(int(this._curPageInfo[_loc4_[_loc2_]]) > 0)
            {
               _loc1_ = ComponentFactory.Instance.creatComponentByStylename("explorerManual.pageLeftView.curProValueTxt");
               this._activeProSpri.addChild(_loc1_);
               _loc1_.text = _loc5_[_loc2_] + " +" + this._curPageInfo[_loc4_[_loc2_]];
               _loc1_.x = 100 * (_loc3_ % 2) + 66;
               _loc1_.y = 163 + int(_loc3_ / 2) * 20;
               _loc3_++;
               if(_loc3_ >= 4)
               {
                  return;
               }
            }
            _loc2_++;
         }
      }
      
      private function allProData() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         if(Boolean(this._totalProSpri) && this._totalProSpri.numChildren > 0)
         {
            ObjectUtils.disposeAllChildren(this._totalProSpri);
         }
         var _loc3_:Array = ManualProType.pageProArr;
         var _loc4_:Array = LanguageMgr.GetTranslation("explorerManual.manualAllPro.name").split(",");
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            _loc1_ = ComponentFactory.Instance.creatComponentByStylename("explorerManual.pageLeftView.curProValueTxt");
            this._totalProSpri.addChild(_loc1_);
            _loc1_.text = _loc4_[_loc2_] + " +" + this._model.pageAllPro[_loc3_[_loc2_]];
            _loc1_.x = 100 * (_loc2_ % 2) + 66;
            _loc1_.y = 163 + int(_loc2_ / 2) * 20;
            _loc2_++;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.clear();
         this._curProSpri = null;
         this._activeProSpri = null;
         this._totalProSpri = null;
         if(Boolean(this._directorySpri))
         {
            while(this._directorySpri.numChildren > 0)
            {
               ObjectUtils.disposeObject(this._directorySpri.getChildAt(0));
            }
            this._directorySpri.removeChildren();
            this._directorySpri = null;
         }
         ObjectUtils.disposeObject(this._pageDescribe);
         this._pageDescribe = null;
         this._curPageInfo = null;
         this._model = null;
         if(Boolean(this._titleTxt))
         {
            ObjectUtils.disposeObject(this._titleTxt);
         }
         this._titleTxt = null;
         if(Boolean(this._titleIcon))
         {
            ObjectUtils.disposeObject(this._titleIcon);
         }
         this._titleIcon = null;
         if(Boolean(this._curProTitle))
         {
            ObjectUtils.disposeObject(this._curProTitle);
         }
         this._curProTitle = null;
         if(Boolean(this._activeStateTitle))
         {
            ObjectUtils.disposeObject(this._activeStateTitle);
         }
         this._activeStateTitle = null;
      }
   }
}
