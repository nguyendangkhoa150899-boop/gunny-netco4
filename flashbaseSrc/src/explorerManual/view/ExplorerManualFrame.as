package explorerManual.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.HelpFrameUtils;
   import ddt.utils.PositionUtils;
   import explorerManual.ExplorerManualController;
   import explorerManual.data.ExplorerManualInfo;
   import explorerManual.view.chapter.ExplorerChapterView;
   import explorerManual.view.page.ExplorerPageView;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class ExplorerManualFrame extends Frame
   {
       
      
      private var _closeBtn:BaseButton;
      
      private var _chapterView:ExplorerChapterView;
      
      private var _pageView:ExplorerPageView = null;
      
      private var _leftMenu:explorerManual.view.ManualLeftMenu;
      
      private var _rightMenu:explorerManual.view.ManualRightMenu;
      
      private var _manualModel:ExplorerManualInfo = null;
      
      private var _control:ExplorerManualController;
      
      private var _helpBtn:BaseButton;
      
      private var _mainMovie:MovieClip;
      
      private var _curSelectChapter:int;
      
      private var _confirmFrame:BaseAlerFrame;
      
      public function ExplorerManualFrame(param1:ExplorerManualInfo, param2:ExplorerManualController)
      {
         this._manualModel = param1;
         this._control = param2;
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._helpBtn = HelpFrameUtils.Instance.simpleHelpButton(this,"explorerManual.helpbtn",null,LanguageMgr.GetTranslation("explorerManual.helpDis"),"asset.explorerManual.helpDis",404,490);
         this._chapterView = new ExplorerChapterView(this._manualModel,this._control);
         PositionUtils.setPos(this._chapterView,"explorerManual.chapterViewPos");
         this._pageView = new ExplorerPageView(this._manualModel,this._control);
         PositionUtils.setPos(this._pageView,"explorerManual.pageViewPos");
         this._pageView.visible = false;
         this._pageView.addEventListener("pageChange",this.__pageChangleHandler);
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("explorerManual.frame.closeBtn");
         this._closeBtn.addEventListener("click",this.__closeBtnClickHandler);
         this._leftMenu = new explorerManual.view.ManualLeftMenu(this._manualModel);
         PositionUtils.setPos(this._leftMenu,"explorerManual.manualLeftMenuPos");
         this._leftMenu.addEventListener("click",this.__leftMenuClickHandler);
         this._rightMenu = new explorerManual.view.ManualRightMenu();
         PositionUtils.setPos(this._rightMenu,"explorerManual.manualRightMenuPos");
         this._rightMenu.addEventListener("itemClick",this.__rightMenuClickHandler);
         this._rightMenu.selectItem = 0;
         this._mainMovie = ComponentFactory.Instance.creat("explorerManual.pageChange.animation");
         this._mainMovie.addFrameScript(5,this.subtractAlpha);
         this._mainMovie.addFrameScript(10,this.subtractAlpha);
         this._mainMovie.addFrameScript(15,this.subtractAlpha);
         this._mainMovie.addFrameScript(20,this.subtractAlpha);
         this._mainMovie.addFrameScript(27,this.addAlpha);
         this._mainMovie.addFrameScript(33,this.addAlpha);
         this._mainMovie.addFrameScript(36,this.addAlpha);
         this._mainMovie.addFrameScript(41,this.endMovie);
         this._mainMovie.stop();
      }
      
      private function subtractAlpha() : void
      {
         this._pageView.alpha -= Math.max(0.3,0);
         if(this._pageView.alpha < 0)
         {
            this._pageView.alpha = 0;
         }
      }
      
      private function addAlpha() : void
      {
         this._pageView.alpha += Math.min(0.3,1);
      }
      
      private function endMovie() : void
      {
         this._pageView.alpha = 1;
         this._mainMovie.stop();
      }
      
      private function __pageChangleHandler(param1:CEvent) : void
      {
         var _loc2_:int = int(param1.data);
         if(_loc2_ == 1)
         {
            this._mainMovie.scaleX = -1;
            PositionUtils.setPos(this._mainMovie,"explorerManual.pageChange.mainMoviePos1");
         }
         else
         {
            this._mainMovie.scaleX = 1;
            PositionUtils.setPos(this._mainMovie,"explorerManual.pageChange.mainMoviePos");
         }
         this._mainMovie.play();
      }
      
      private function __leftMenuClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.openChapterView();
      }
      
      private function __rightMenuClickHandler(param1:CEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:int = int(param1.data);
         if(_loc2_ == 0)
         {
            this.openChapterView();
         }
         else
         {
            this.openPageView(_loc2_);
         }
      }
      
      public function openPageView(param1:int) : void
      {
         var _loc2_:* = null;
         if(this._curSelectChapter == param1)
         {
            return;
         }
         if(Boolean(this._control) && this._control.puzzleState)
         {
            _loc2_ = {};
            _loc2_.fun = this.openPageView;
            _loc2_.params = param1;
            this.showPuzzleAffim(_loc2_);
            return;
         }
         this._curSelectChapter = param1;
         this._rightMenu.selectItem = param1;
         this._chapterView.visible = false;
         if(this._pageView == null)
         {
            this._pageView = new ExplorerPageView(this._manualModel,this._control);
         }
         this._pageView.chapter = param1;
         this._pageView.visible = true;
         if(Boolean(this._control))
         {
            this._control.requestManualPageData(param1);
         }
      }
      
      private function openChapterView() : void
      {
         var _loc1_:* = null;
         if(this._curSelectChapter == 0)
         {
            return;
         }
         if(Boolean(this._control) && this._control.puzzleState)
         {
            _loc1_ = {};
            _loc1_.fun = this.openChapterView;
            _loc1_.params = "not";
            this.showPuzzleAffim(_loc1_);
            return;
         }
         this._curSelectChapter = 0;
         this._rightMenu.selectItem = 0;
         if(this._chapterView == null)
         {
            this._chapterView = new ExplorerChapterView(this._manualModel,this._control);
         }
         if(Boolean(this._pageView))
         {
            this._pageView.visible = false;
         }
         this._chapterView.visible = true;
      }
      
      private function showPuzzleAffim(param1:Object) : void
      {
         var callfun:Object = null;
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
                  _control.puzzleState = false;
                  if(Boolean(callfun))
                  {
                     if(callfun.params == "not")
                     {
                        callfun.fun.apply();
                     }
                     else
                     {
                        callfun.fun(callfun.params);
                     }
                  }
               }
            };
         })());
      }
      
      private function __closeBtnClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         SoundManager.instance.play("008");
         if(Boolean(this._control) && this._control.puzzleState)
         {
            _loc2_ = {};
            _loc2_.fun = this.__closeBtnClickHandler;
            _loc2_.params = null;
            this.showPuzzleAffim(_loc2_);
            return;
         }
         this.dispose();
      }
      
      public function show() : void
      {
         addEventListener("response",this._response);
         LayerManager.Instance.addToLayer(this,3,false,1);
      }
      
      private function _response(param1:FrameEvent) : void
      {
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            this.__closeBtnClickHandler(null);
         }
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(Boolean(this._closeBtn))
         {
            addToContent(this._closeBtn);
         }
         if(Boolean(this._chapterView))
         {
            addToContent(this._chapterView);
         }
         if(Boolean(this._leftMenu))
         {
            addToContent(this._leftMenu);
         }
         if(Boolean(this._rightMenu))
         {
            addToContent(this._rightMenu);
         }
         if(Boolean(this._pageView))
         {
            addToContent(this._pageView);
         }
         if(Boolean(this._helpBtn))
         {
            addToContent(this._helpBtn);
         }
         if(Boolean(this._mainMovie))
         {
            addToContent(this._mainMovie);
         }
      }
      
      override public function dispose() : void
      {
         removeEventListener("response",this._response);
         this._manualModel = null;
         this._control = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         ObjectUtils.disposeObject(this._chapterView);
         this._chapterView = null;
         if(Boolean(this._pageView))
         {
            this._pageView.removeEventListener("pageChange",this.__pageChangleHandler);
         }
         ObjectUtils.disposeObject(this._pageView);
         this._pageView = null;
         if(Boolean(this._closeBtn))
         {
            this._closeBtn.removeEventListener("click",this.__closeBtnClickHandler);
            ObjectUtils.disposeObject(this._closeBtn);
         }
         this._closeBtn = null;
         if(Boolean(this._leftMenu))
         {
            this._leftMenu.removeEventListener("click",this.__leftMenuClickHandler);
            ObjectUtils.disposeObject(this._leftMenu);
         }
         this._leftMenu = null;
         if(Boolean(this._mainMovie))
         {
            this._mainMovie.stop();
            ObjectUtils.disposeObject(this._mainMovie);
            this._mainMovie = null;
         }
         if(Boolean(this._rightMenu))
         {
            this._rightMenu.removeEventListener("click",this.__rightMenuClickHandler);
            ObjectUtils.disposeObject(this._rightMenu);
         }
         this._rightMenu = null;
         ObjectUtils.disposeObject(this._confirmFrame);
         this._confirmFrame = null;
         super.dispose();
      }
   }
}
