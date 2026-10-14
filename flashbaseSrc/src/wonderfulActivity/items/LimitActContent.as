package wonderfulActivity.items
{
   import activeEvents.data.ActiveEventsInfo;
   import baglocked.BaglockedManager;
   import calendar.CalendarManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class LimitActContent extends Sprite implements Disposeable
   {
      
      public static const PICC_PRICE:int = 10000;
       
      
      private var _limitView:wonderfulActivity.items.LimitActView;
      
      private var _titleField:FilterFrameText;
      
      private var _titleBack:Bitmap;
      
      private var _scrollList:ScrollPanel;
      
      private var _back:MutipleImage;
      
      private var _getButton:SimpleBitmapButton;
      
      private var _exchangeButton:SimpleBitmapButton;
      
      private var _piccBtn:SimpleBitmapButton;
      
      private var _activityInfo:ActiveEventsInfo;
      
      public function LimitActContent(param1:ActiveEventsInfo)
      {
         super();
         this._activityInfo = param1;
         this.initView(param1);
      }
      
      private function initView(param1:ActiveEventsInfo) : void
      {
         this._getButton = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityState.GetButton");
         this._getButton.visible = false;
         addChild(this._getButton);
         this._piccBtn = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityState.PiccBtn");
         this._piccBtn.visible = false;
         addChild(this._piccBtn);
         this._back = ComponentFactory.Instance.creat("wonderful.ActivityStateBg");
         addChild(this._back);
         this._titleField = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityStateTitleField");
         this._titleField.text = param1.Title;
         addChild(this._titleField);
         this._scrollList = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityDetailList");
         addChild(this._scrollList);
         this._limitView = new wonderfulActivity.items.LimitActView(param1);
         addChild(this._limitView);
         this._scrollList.setView(this._limitView);
         this.showBtn();
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         if(Boolean(this._getButton))
         {
            this._getButton.addEventListener(MouseEvent.CLICK,this.__getAward);
         }
         if(Boolean(this._exchangeButton))
         {
            this._exchangeButton.addEventListener(MouseEvent.CLICK,this.__exchange);
         }
         if(Boolean(this._piccBtn))
         {
            this._piccBtn.addEventListener(MouseEvent.CLICK,this.__piccHandler);
         }
      }
      
      private function showBtn() : void
      {
         if(this._activityInfo.ActiveType == ActiveEventsInfo.GOODS_EXCHANGE)
         {
            if(Boolean(this._exchangeButton))
            {
               this._exchangeButton.visible = true;
            }
         }
         else if(this._activityInfo.ActiveType == ActiveEventsInfo.PICC)
         {
            this._piccBtn.visible = true;
         }
         else
         {
            this._getButton.visible = true;
         }
      }
      
      private function removeEvents() : void
      {
         if(Boolean(this._getButton))
         {
            this._getButton.removeEventListener(MouseEvent.CLICK,this.__getAward);
         }
         if(Boolean(this._exchangeButton))
         {
            this._exchangeButton.removeEventListener(MouseEvent.CLICK,this.__exchange);
         }
         if(Boolean(this._piccBtn))
         {
            this._piccBtn.removeEventListener(MouseEvent.CLICK,this.__piccHandler);
         }
      }
      
      private function __getAward(param1:MouseEvent) : void
      {
         var _loc2_:BaseLoader = null;
         var _loc3_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(this._activityInfo.ActiveType == ActiveEventsInfo.COMMON)
         {
            if(!this._limitView.getInputField())
            {
               return;
            }
            if(this._limitView.getInputField().text == "" && (this._activityInfo.HasKey == 1 || this._activityInfo.HasKey == 7))
            {
               _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.movement.MovementRightView.pass"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,false,false,2);
               _loc3_.info.showCancel = false;
               return;
            }
            _loc2_ = CalendarManager.getInstance().reciveActivityAward(this._activityInfo,this._limitView.getInputField().text);
            _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
            _loc2_.addEventListener(LoaderEvent.COMPLETE,this.__activityLoadComplete);
            this._limitView.getInputField().text = "";
            if(this._activityInfo.HasKey == 1)
            {
               this._getButton.enable = true;
            }
            else
            {
               this._getButton.enable = !this._activityInfo.isAttend;
            }
         }
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:BaseLoader = param1.currentTarget as BaseLoader;
         _loc2_.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         _loc2_.removeEventListener(LoaderEvent.COMPLETE,this.__activityLoadComplete);
         this._getButton.enable = !this._activityInfo.isAttend;
      }
      
      private function __exchange(param1:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         SoundManager.instance.playButtonSound();
      }
      
      private function __activityLoadComplete(param1:LoaderEvent) : void
      {
         var _loc2_:BaseLoader = param1.currentTarget as BaseLoader;
         if(this._activityInfo.HasKey == 1)
         {
            this._getButton.enable = true;
         }
         else
         {
            this._getButton.enable = !this._activityInfo.isAttend;
         }
      }
      
      protected function __piccHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ActivityState.confirm.content",PICC_PRICE),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         _loc2_.moveEnable = false;
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      protected function __responseHandler(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         var _loc3_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc3_.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.Money >= PICC_PRICE)
            {
               SocketManager.Instance.out.sendPicc(this._activityInfo.ActiveID,PICC_PRICE);
            }
            else
            {
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("poorNote"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
               _loc2_.moveEnable = false;
               _loc2_.addEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
            }
         }
         ObjectUtils.disposeObject(_loc3_);
      }
      
      private function __poorManResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._limitView);
         ObjectUtils.disposeObject(this._back);
         ObjectUtils.disposeObject(this._titleField);
         ObjectUtils.disposeObject(this._scrollList);
         ObjectUtils.disposeObject(this._getButton);
         ObjectUtils.disposeObject(this._exchangeButton);
         ObjectUtils.disposeObject(this._piccBtn);
         this._limitView = null;
         this._scrollList = null;
         this._titleField = null;
         this._back = null;
         this._getButton = null;
         this._exchangeButton = null;
         this._piccBtn = null;
      }
   }
}
