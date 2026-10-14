package godCardRaise.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import godCardRaise.GodCardRaiseManager;
   import godCardRaise.info.GodCardListInfo;
   
   public class GodCardRaiseAtlasCard extends Sprite implements Disposeable
   {
       
      
      private var _info:GodCardListInfo;
      
      private var _countTxt:FilterFrameText;
      
      private var _picSp:Sprite;
      
      private var _loaderPic:DisplayLoader;
      
      private var _picBmp:Bitmap;
      
      private var _compositeBtn:BaseButton;
      
      private var _smashBtn:BaseButton;
      
      private var _btnBg:Shape;
      
      private var _cardCount:int;
      
      private var _clickNum:Number = 0;
      
      private var _btnType:int;
      
      private var _alert:godCardRaise.view.GodCardRaiseAtlasCardAlert;
      
      public function GodCardRaiseAtlasCard()
      {
         super();
         this.initView();
         this.initEvent();
         this.buttonMode = true;
      }
      
      private function initView() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = undefined;
         this._countTxt = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseAtlasCard.countTxt");
         addChild(this._countTxt);
         this._picSp = new Sprite();
         addChild(this._picSp);
         this._btnBg = new Shape();
         this._btnBg.graphics.beginFill(0,0.5);
         this._btnBg.graphics.drawRect(0,0,140,40);
         this._btnBg.graphics.endFill();
         this._btnBg.x = 13;
         this._btnBg.y = 180;
         addChild(this._btnBg);
         this._compositeBtn = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseAtlasCard.compositeBtn");
         addChild(this._compositeBtn);
         this._smashBtn = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseAtlasCard.smashBtn");
         addChild(this._smashBtn);
         _loc1_ = false;
         this._smashBtn.visible = _loc1_;
         _loc1_ = _loc1_;
         this._compositeBtn.visible = _loc1_;
         this._btnBg.visible = _loc1_;
      }
      
      private function initEvent() : void
      {
         this._compositeBtn.addEventListener("click",this.__compositeBtnHandler);
         this._smashBtn.addEventListener("click",this.__smashBtnHandler);
         this.addEventListener("mouseOver",this.onMouseOver);
         this.addEventListener("mouseOut",this.onMouseOut);
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this._info.Composition;
         if(this._cardCount > 0 && this._info.Decompose != 0)
         {
            this._smashBtn.visible = true;
         }
         else
         {
            this._smashBtn.visible = false;
         }
         if(this._info.Composition != 0)
         {
            this._compositeBtn.visible = true;
         }
         else
         {
            this._compositeBtn.visible = false;
         }
         if(this._smashBtn.visible)
         {
            if(this._compositeBtn.visible)
            {
               this._smashBtn.x = 93;
               this._compositeBtn.x = 23;
            }
            else
            {
               this._smashBtn.x = 60;
            }
            this._btnBg.visible = true;
         }
         else if(this._compositeBtn.visible)
         {
            this._compositeBtn.x = 60;
            this._btnBg.visible = true;
         }
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         _loc2_ = undefined;
         _loc2_ = false;
         this._smashBtn.visible = _loc2_;
         _loc2_ = _loc2_;
         this._compositeBtn.visible = _loc2_;
         this._btnBg.visible = _loc2_;
      }
      
      public function updateView() : void
      {
         this._cardCount = GodCardRaiseManager.Instance.model.cards[this._info.ID];
         this._countTxt.text = LanguageMgr.GetTranslation("godCardRaiseAtlasCard.countTxtMsg",this._cardCount);
         if(this._cardCount > 0)
         {
            this._picSp.filters = null;
         }
         else
         {
            this._picSp.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      public function set info(param1:GodCardListInfo) : void
      {
         this._info = param1;
         this.updateView();
         this._loaderPic = LoadResourceManager.Instance.createLoader(PathManager.solveGodCardRaisePath(this._info.Pic),0);
         this._loaderPic.addEventListener("complete",this.__picComplete);
         LoadResourceManager.Instance.startLoad(this._loaderPic);
      }
      
      private function __picComplete(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener("complete",this.__picComplete);
         if(param1.loader.isSuccess)
         {
            this._picBmp = param1.loader.content as Bitmap;
            this._picSp.addChild(this._picBmp);
         }
      }
      
      private function __compositeBtnHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:Number = new Date().time;
         if(_loc2_ - this._clickNum < 1000)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"));
            return;
         }
         this._clickNum = _loc2_;
         var _loc3_:int = GodCardRaiseManager.Instance.model.chipCount;
         if(_loc3_ < this._info.Composition)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("godCardRaiseAtlasCard.compositeMsg2",this._info.Composition));
            return;
         }
         this.showAlert(2);
      }
      
      private function showAlert(param1:int) : void
      {
         var _loc2_:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._btnType = param1;
         if(this._btnType == 2)
         {
            _loc2_ = GodCardRaiseManager.Instance.model.chipCount / this._info.Composition;
         }
         else
         {
            _loc2_ = this._cardCount;
         }
         this._alert = ComponentFactory.Instance.creatComponentByStylename("GodCardRaiseAtlasCardAlert");
         this._alert.addEventListener("response",this.__alertResponse);
         this._alert.setInfo = this._info;
         this._alert.setType = this._btnType;
         this._alert.valueLimit = "1," + _loc2_;
         this._alert.show();
      }
      
      private function __alertResponse(param1:FrameEvent) : void
      {
         if(Boolean(this._alert))
         {
            this._alert.removeEventListener("response",this.__alertResponse);
         }
         switch(int(param1.responseCode) - 2)
         {
            case 0:
            case 1:
               GameInSocketOut.sendGodCardOperateCard(this._btnType,this._info.ID,this._alert.count);
               break;
            case 2:
         }
         this._alert.dispose();
         if(Boolean(this._alert.parent))
         {
            this._alert.parent.removeChild(this._alert);
         }
         this._alert = null;
      }
      
      private function __smashBtnHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:Number = new Date().time;
         if(_loc2_ - this._clickNum < 1000)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"));
            return;
         }
         this._clickNum = _loc2_;
         if(this._cardCount <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("godCardRaiseAtlasCard.smashMsg2"));
            return;
         }
         this.showAlert(1);
      }
      
      private function removeEvent() : void
      {
         this._compositeBtn.removeEventListener("click",this.__compositeBtnHandler);
         this._smashBtn.removeEventListener("click",this.__smashBtnHandler);
         this.removeEventListener("mouseOver",this.onMouseOver);
         this.removeEventListener("mouseOut",this.onMouseOut);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._loaderPic))
         {
            this._loaderPic.removeEventListener("complete",this.__picComplete);
            this._loaderPic = null;
         }
         ObjectUtils.disposeAllChildren(this._picSp);
         this._btnBg.graphics.clear();
         ObjectUtils.disposeAllChildren(this);
         this._picSp = null;
         this._countTxt = null;
         this._info = null;
         this._picBmp = null;
         this._btnBg = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
