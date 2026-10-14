package explorerManual.view.page
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import explorerManual.ExplorerManualController;
   import explorerManual.ExplorerManualManager;
   import explorerManual.data.ExplorerManualInfo;
   import explorerManual.data.model.ManualPageItemInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearInterval;
   import flash.utils.setTimeout;
   
   public class ExplorerPageView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _leftView:explorerManual.view.page.ExplorerPageLeftView;
      
      private var _rightView:explorerManual.view.page.ExplorerPageRightViewBase;
      
      private var _unActiveView:explorerManual.view.page.ExplorerPageRightViewBase;
      
      private var _pageDirectoryView:explorerManual.view.page.ExplorerPageDirectoryView;
      
      private var _curChapter:int;
      
      private var _curAllPage:Array;
      
      private var _curPageIndex:int;
      
      private var _curPage:ManualPageItemInfo;
      
      private var _model:ExplorerManualInfo;
      
      private var _ctrl:ExplorerManualController;
      
      private var _upPageBtn:BaseButton;
      
      private var _downPageBtn:BaseButton;
      
      private var _timer:int;
      
      private var _clickNum:Number = 0;
      
      private var _confirmFrame:BaseAlerFrame;
      
      public function ExplorerPageView(param1:ExplorerManualInfo, param2:ExplorerManualController)
      {
         super();
         this._model = param1;
         this._ctrl = param2;
         this.initEvent();
      }
      
      public function get curPageIndex() : int
      {
         return this._curPageIndex;
      }
      
      public function set curPageIndex(param1:int) : void
      {
         this._curPageIndex = param1;
      }
      
      private function initEvent() : void
      {
         this._model.addEventListener("updatePageView",this.__updatePageViewHandler);
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._model))
         {
            this._model.removeEventListener("updatePageView",this.__updatePageViewHandler);
         }
         if(Boolean(this._upPageBtn))
         {
            this._upPageBtn.removeEventListener("click",this.__upPageBtnHandler);
         }
         if(Boolean(this._downPageBtn))
         {
            this._downPageBtn.removeEventListener("click",this.__downPageBtnHandler);
         }
         if(Boolean(this._pageDirectoryView))
         {
            this._pageDirectoryView.removeEventListener("directionryTurn",this.directionryClick_Handler);
         }
      }
      
      private function __updatePageViewHandler(param1:Event) : void
      {
         this.initView();
         this.initPage();
      }
      
      public function get curPage() : ManualPageItemInfo
      {
         return this._curPage;
      }
      
      public function set curPage(param1:ManualPageItemInfo) : void
      {
         this._curPage = param1;
         this.updateView();
         this.updateBtn();
      }
      
      private function updateBtn() : void
      {
         var _loc1_:int = int(this._curAllPage.length);
         this._downPageBtn.enable = true;
         this._upPageBtn.enable = true;
         if(this._curPage.Sort == 0)
         {
            this._downPageBtn.enable = true;
            this._upPageBtn.enable = false;
         }
         else if(this._curPage.Sort == _loc1_ - 1)
         {
            this._downPageBtn.enable = false;
            this._upPageBtn.enable = true;
         }
      }
      
      private function updateView() : void
      {
         this._leftView.pageInfo = this.curPage;
         this._leftView.curChapter = this._curChapter;
         if(this._curPage.Sort == 0)
         {
            this._pageDirectoryView.visible = true;
            this._rightView.visible = false;
            this._unActiveView.visible = false;
            this._pageDirectoryView.initDirectory(this._curAllPage);
         }
         else
         {
            this._pageDirectoryView.visible = false;
            if(this._model.debrisInfo.getHaveDebrisByPageID(this.curPage.ID).length > 0)
            {
               this._rightView.visible = true;
               this._unActiveView.visible = false;
               this._rightView.pageInfo = this.curPage;
            }
            else
            {
               this._rightView.visible = false;
               this._unActiveView.visible = true;
               this._unActiveView.pageInfo = this.curPage;
            }
         }
      }
      
      public function set chapter(param1:int) : void
      {
         this._curChapter = param1;
      }
      
      private function initView() : void
      {
         if(Boolean(this._leftView))
         {
            return;
         }
         this._bg = ComponentFactory.Instance.creat("asset.explorerManual.pageView.bg");
         addChild(this._bg);
         this._leftView = new explorerManual.view.page.ExplorerPageLeftView(this._curChapter,this._model);
         addChild(this._leftView);
         this._pageDirectoryView = new explorerManual.view.page.ExplorerPageDirectoryView(this._curChapter,this._model,this._ctrl);
         addChild(this._pageDirectoryView);
         this._pageDirectoryView.addEventListener("directionryTurn",this.directionryClick_Handler);
         this._pageDirectoryView.visible = false;
         this._rightView = new ExplorerPageRightView(this._curChapter,this._model,this._ctrl);
         addChild(this._rightView);
         this._rightView.visible = false;
         this._unActiveView = new ExplorerPageUnActiveView(this._curChapter,this._model,this._ctrl);
         addChild(this._unActiveView);
         this._unActiveView.visible = false;
         PositionUtils.setPos(this._unActiveView,"explorerManual.unActiveViewPos");
         this._upPageBtn = ComponentFactory.Instance.creatComponentByStylename("explorerManual.manualpageView.upPageBtn");
         addChild(this._upPageBtn);
         this._upPageBtn.enable = false;
         this._upPageBtn.addEventListener("click",this.__upPageBtnHandler);
         this._downPageBtn = ComponentFactory.Instance.creatComponentByStylename("explorerManual.manualpageView.downPageBtn");
         addChild(this._downPageBtn);
         this._downPageBtn.enable = false;
         this._downPageBtn.addEventListener("click",this.__downPageBtnHandler);
      }
      
      private function directionryClick_Handler(param1:CEvent) : void
      {
         var _loc2_:int = int(param1.data);
         this.curPageIndex = _loc2_ - 1;
         this.turnPage(2);
      }
      
      private function __upPageBtnHandler(param1:MouseEvent) : void
      {
         this.turnPage(1);
      }
      
      private function turnPage(param1:int) : void
      {
         var type:int = 0;
         type = param1;
         if(this._curAllPage.length <= 0)
         {
            return;
         }
         if(Boolean(this._ctrl) && this._ctrl.puzzleState)
         {
            this.showPuzzleAffim(type == 1 ? this.__upPageBtnHandler : this.__downPageBtnHandler);
            return;
         }
         if(!this.checkCanClick())
         {
            return;
         }
         this.dispatchEvent(new CEvent("pageChange",type));
         this._timer = setTimeout((function():*
         {
            var start:* = undefined;
            return start = function():void
            {
               clearInterval(_timer);
               if(_curAllPage == null)
               {
                  return;
               }
               if(type == 1)
               {
                  if(curPageIndex == 0)
                  {
                     return;
                  }
                  --curPageIndex;
               }
               else if(type == 2)
               {
                  if(curPageIndex == _curAllPage.length - 1)
                  {
                     return;
                  }
                  ++curPageIndex;
               }
               curPage = _curAllPage[curPageIndex];
            };
         })(),800);
      }
      
      private function __downPageBtnHandler(param1:MouseEvent) : void
      {
         this.turnPage(2);
      }
      
      private function checkCanClick() : Boolean
      {
         var _loc1_:Number = new Date().time;
         if(_loc1_ - this._clickNum < 2000)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"),0,true);
            return false;
         }
         this._clickNum = _loc1_;
         return true;
      }
      
      private function showPuzzleAffim(param1:Function) : void
      {
         var callfun:Function = null;
         callfun = param1;
         this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("explorerManual.checkPuzzleState.prompt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,1);
         this._confirmFrame.moveEnable = false;
         this._confirmFrame.addEventListener("response",(function():*
         {
            var __confirmBuy:* = undefined;
            return __confirmBuy = function(param1:FrameEvent):void
            {
               SoundManager.instance.play("008");
               _confirmFrame.removeEventListener("response",__confirmBuy);
               _confirmFrame = null;
               if(param1.responseCode == 3 || param1.responseCode == 2)
               {
                  _ctrl.puzzleState = false;
                  if(Boolean(callfun))
                  {
                     callfun(null);
                  }
               }
            };
         })());
      }
      
      private function initPage() : void
      {
         this._curAllPage = [];
         this.curPageIndex = 0;
         this._curAllPage = ExplorerManualManager.instance.getAllPageByChapterID(this._curChapter);
         this._curAllPage.sortOn("Sort");
         this._curAllPage.unshift(new ManualPageItemInfo());
         if(this._curAllPage.length > 0)
         {
            this.curPage = this._curAllPage[this.curPageIndex];
         }
      }
      
      private function clearView() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._upPageBtn);
         this._upPageBtn = null;
         ObjectUtils.disposeObject(this._downPageBtn);
         this._downPageBtn = null;
         ObjectUtils.disposeObject(this._unActiveView);
         this._unActiveView = null;
         ObjectUtils.disposeObject(this._confirmFrame);
         this._confirmFrame = null;
         ObjectUtils.disposeObject(this._leftView);
         this._leftView = null;
         ObjectUtils.disposeObject(this._rightView);
         this._rightView = null;
         ObjectUtils.disposeObject(this._pageDirectoryView);
         this._pageDirectoryView = null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._curPageIndex = 0;
         if(Boolean(this._curAllPage))
         {
            this._curAllPage = null;
         }
         this._curPage = null;
         this._model = null;
         this._ctrl = null;
         this.clearView();
      }
   }
}
