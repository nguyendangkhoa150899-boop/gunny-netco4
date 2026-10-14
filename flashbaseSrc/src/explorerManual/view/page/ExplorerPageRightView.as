package explorerManual.view.page
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import explorerManual.ExplorerManualController;
   import explorerManual.data.ExplorerManualInfo;
   import explorerManual.data.model.ManualPageItemInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ExplorerPageRightView extends ExplorerPageRightViewBase
   {
       
      
      private var _preview:explorerManual.view.page.PreviewPageView;
      
      private var _lostIcon:Bitmap;
      
      private var _payTypeIcon:Bitmap;
      
      private var _payMoney:FilterFrameText;
      
      private var _aKeyBtn:BaseButton;
      
      private var _puzzleView:explorerManual.view.page.ManualPuzzlePageView;
      
      private var _activeBtn:BaseButton;
      
      private var _activeIcon:Bitmap;
      
      private var _activeIconSpri:Sprite;
      
      private var _confirmFrame:BaseAlerFrame;
      
      private var _loaderPic:DisplayLoader;
      
      public function ExplorerPageRightView(param1:int, param2:ExplorerManualInfo, param3:ExplorerManualController)
      {
         super(param1,param2,param3);
      }
      
      override protected function initView() : void
      {
         super.initView();
         this._puzzleView = new explorerManual.view.page.ManualPuzzlePageView();
         addChild(this._puzzleView);
         PositionUtils.setPos(this._puzzleView,"explorerManual.puzzlePagePos");
         this._preview = new explorerManual.view.page.PreviewPageView();
         PositionUtils.setPos(this._preview,"explorerManual.pageRight.previewPageViewPos");
         addChild(this._preview);
         this._aKeyBtn = ComponentFactory.Instance.creatComponentByStylename("explorerManual.pageRight.aKeyBtn");
         addChild(this._aKeyBtn);
         this._aKeyBtn.enable = false;
         this._activeBtn = ComponentFactory.Instance.creatComponentByStylename("explorerManual.pageRight.activeBtn");
         addChild(this._activeBtn);
         this._activeBtn.visible = false;
         this._activeBtn.enable = false;
         this._lostIcon = ComponentFactory.Instance.creat("asset.explorerManual.pageRightView.lostTxtIcon");
         addChild(this._lostIcon);
         this._payTypeIcon = ComponentFactory.Instance.creat("asset.ddtshop.PayTypeLabelTicket");
         addChild(this._payTypeIcon);
         PositionUtils.setPos(this._payTypeIcon,"explorerManual.shop.PayTypePos");
         this._payMoney = ComponentFactory.Instance.creatComponentByStylename("explorerManual.pageLeftView.payMoneyValue");
         addChild(this._payMoney);
         this._payMoney.text = "100";
         this._activeIconSpri = new Sprite();
         this._activeIconSpri.x = 425;
         this._activeIconSpri.y = 42;
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         if(Boolean(this._aKeyBtn))
         {
            this._aKeyBtn.addEventListener("click",this.__aKeyBtnClickHandler);
         }
         if(Boolean(this._activeBtn))
         {
            this._activeBtn.addEventListener("click",this.__activeBtnClickHandler);
         }
         if(Boolean(this._puzzleView))
         {
            this._puzzleView.addEventListener("PuzzleSucceed",this.__puzzleSucceedHandler);
         }
         if(Boolean(_ctrl))
         {
            _ctrl.addEventListener("akeyMuzzleComplete",this.__akeyMuzzleHandler);
         }
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         if(Boolean(this._aKeyBtn))
         {
            this._aKeyBtn.removeEventListener("click",this.__aKeyBtnClickHandler);
         }
         if(Boolean(this._activeBtn))
         {
            this._activeBtn.removeEventListener("click",this.__activeBtnClickHandler);
         }
         if(Boolean(this._puzzleView))
         {
            this._puzzleView.removeEventListener("PuzzleSucceed",this.__puzzleSucceedHandler);
         }
         if(Boolean(_ctrl))
         {
            _ctrl.removeEventListener("akeyMuzzleComplete",this.__akeyMuzzleHandler);
         }
      }
      
      private function __akeyMuzzleHandler(param1:CEvent) : void
      {
         var _loc2_:Boolean = Boolean(param1.data);
         if(_loc2_)
         {
            this._puzzleView.akey();
            this._aKeyBtn.enable = false;
         }
         else
         {
            this._aKeyBtn.enable = true;
         }
      }
      
      private function __puzzleSucceedHandler(param1:CEvent) : void
      {
         var _loc2_:Boolean = Boolean(param1.data);
         this._activeBtn.visible = _loc2_;
         this._aKeyBtn.enable = this._activeBtn.enable = _loc2_;
         _ctrl.puzzleState = true;
      }
      
      private function __aKeyBtnClickHandler(param1:MouseEvent) : void
      {
         if(_pageInfo == null)
         {
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Money < _pageInfo.ActivateCurrency)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("moneyPoorNote"));
            return;
         }
         this.showAffirmHandle();
      }
      
      private function showAffirmHandle() : void
      {
         this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("explorerManual.akeyMuzzleConfirmTipTxt",_pageInfo.ActivateCurrency),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,1);
         this._confirmFrame.moveEnable = false;
         this._confirmFrame.addEventListener("response",this.__confirmBuy);
      }
      
      private function __confirmBuy(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._confirmFrame.removeEventListener("response",this.__confirmBuy);
         this._confirmFrame = null;
         if(param1.responseCode == 3 || param1.responseCode == 2)
         {
            if(Boolean(_ctrl))
            {
               _ctrl.sendManualPageActive(2,_pageInfo.ID);
               this._aKeyBtn.enable = false;
            }
         }
      }
      
      private function __activeBtnClickHandler(param1:MouseEvent) : void
      {
         if(Boolean(_ctrl))
         {
            _ctrl.sendManualPageActive(1,_pageInfo.ID);
            this._activeBtn.enable = false;
            this._activeBtn.visible = false;
            _ctrl.puzzleState = false;
         }
      }
      
      private function getPregressValue(param1:int, param2:int) : String
      {
         var _loc3_:* = null;
         return "<FONT FACE=\'Arial\' SIZE=\'14\' COLOR=\'#FF0000\' ><B>" + param1 + "</B></FONT>" + "/" + param2;
      }
      
      override public function set pageInfo(param1:ManualPageItemInfo) : void
      {
         super.pageInfo = param1;
         this._payMoney.text = _pageInfo.ActivateCurrency.toString();
      }
      
      override protected function updateShowView() : void
      {
         if(_pageInfo == null)
         {
            return;
         }
         super.updateShowView();
         this.clear();
         if(_model.checkPageActiveByPageID(_pageInfo.ID))
         {
            this._aKeyBtn.enable = false;
            this._activeBtn.visible = false;
            this.loadActiveIcon();
         }
         else
         {
            this._activeBtn.visible = this._activeBtn.enable = false;
            this.updatePuzzle();
            this._aKeyBtn.enable = this._puzzleView.isCanClick;
         }
         this._preview.tipData = _pageInfo;
      }
      
      private function loadActiveIcon() : void
      {
         addChildAt(this._activeIconSpri,0);
         this._loaderPic = LoadResourceManager.Instance.createLoader(PathManager.ManualDebrisIconPath(_pageInfo.ImagePath),0);
         this._loaderPic.addEventListener("complete",this.__picCompleteHandler);
         LoadResourceManager.Instance.startLoad(this._loaderPic);
      }
      
      private function __picCompleteHandler(param1:LoaderEvent) : void
      {
         if(param1.loader.isSuccess)
         {
            this._activeIconSpri.addChild(param1.loader.content as Bitmap);
         }
         this.clearLoader();
      }
      
      private function clearLoader() : void
      {
         if(Boolean(this._loaderPic))
         {
            this._loaderPic.removeEventListener("complete",this.__picCompleteHandler);
            this._loaderPic = null;
         }
      }
      
      private function clear() : void
      {
         if(Boolean(this._puzzleView))
         {
            this._puzzleView.clear();
         }
         ObjectUtils.disposeAllChildren(this._activeIconSpri);
         this.clearLoader();
      }
      
      private function updatePuzzle() : void
      {
         var _loc1_:* = null;
         if(Boolean(this._puzzleView))
         {
            this._puzzleView.totalDebrisCount = _pageInfo.DebrisCount;
            _loc1_ = _model.debrisInfo.getHaveDebrisByPageID(_pageInfo.ID);
            this._puzzleView.debrisInfo = _loc1_;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.clear();
         ObjectUtils.disposeObject(this._activeIconSpri);
         this._activeIconSpri = null;
         ObjectUtils.disposeObject(this._preview);
         this._preview = null;
         ObjectUtils.disposeObject(this._puzzleView);
         this._puzzleView = null;
         if(Boolean(this._aKeyBtn))
         {
            ObjectUtils.disposeObject(this._aKeyBtn);
         }
         this._aKeyBtn = null;
         ObjectUtils.disposeObject(this._lostIcon);
         this._lostIcon = null;
         ObjectUtils.disposeObject(this._payTypeIcon);
         this._payTypeIcon = null;
         ObjectUtils.disposeObject(this._payMoney);
         this._payMoney = null;
         ObjectUtils.disposeObject(this._activeIcon);
         this._activeIcon = null;
         if(Boolean(this._confirmFrame))
         {
            this._confirmFrame.removeEventListener("response",this.__confirmBuy);
            ObjectUtils.disposeObject(this._confirmFrame);
         }
         this._confirmFrame = null;
      }
   }
}
