package consortionBattle.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class ConsBatResurrectView extends Sprite implements Disposeable
   {
      
      public static const FIGHT:int = 2;
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _resurrectBtn:SimpleBitmapButton;
      
      private var _stayResBtn:SimpleBitmapButton;
      
      private var _timeCD:MovieClip;
      
      private var _txtProp:FilterFrameText;
      
      private var _totalCount:int;
      
      private var _timer:Timer;
      
      private var _consumeCount:int = 5;
      
      private var _lastCreatTime2:int = 0;
      
      private var _lastCreatTime:int = 0;
      
      public function ConsBatResurrectView(param1:int)
      {
         super();
         this._totalCount = param1;
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.resurrectBg");
         addChild(this._bg);
         this._txtProp = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.resurrect.txtProp");
         addChild(this._txtProp);
         this._txtProp.text = LanguageMgr.GetTranslation("worldboss.resurrectView.prop");
         this._timeCD = ComponentFactory.Instance.creat("asset.consortiaBattle.resurrectTimeCD");
         PositionUtils.setPos(this._timeCD,"consortiaBattle.timeCDPos");
         addChild(this._timeCD);
         this._resurrectBtn = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.resurrect.btn");
         addChild(this._resurrectBtn);
         this._stayResBtn = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.stayRes.btn");
         addChild(this._stayResBtn);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__startCount);
         this._timer.start();
      }
      
      private function __startCount(param1:TimerEvent) : void
      {
         if(this._totalCount < 0)
         {
            this.__timerComplete();
            return;
         }
         var _loc2_:String = this.setFormat(int(this._totalCount / 3600)) + ":" + this.setFormat(int(this._totalCount / 60 % 60)) + ":" + this.setFormat(int(this._totalCount % 60));
         (this._timeCD["timeHour2"] as MovieClip).gotoAndStop("num_" + _loc2_.charAt(0));
         (this._timeCD["timeHour"] as MovieClip).gotoAndStop("num_" + _loc2_.charAt(1));
         (this._timeCD["timeMint2"] as MovieClip).gotoAndStop("num_" + _loc2_.charAt(3));
         (this._timeCD["timeMint"] as MovieClip).gotoAndStop("num_" + _loc2_.charAt(4));
         (this._timeCD["timeSecond2"] as MovieClip).gotoAndStop("num_" + _loc2_.charAt(6));
         (this._timeCD["timeSecond"] as MovieClip).gotoAndStop("num_" + _loc2_.charAt(7));
         --this._totalCount;
      }
      
      private function setFormat(param1:int) : String
      {
         var _loc2_:String = param1.toString();
         if(param1 < 10)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }
      
      protected function __timerComplete() : void
      {
         if(this._consumeCount >= 5)
         {
            SocketManager.Instance.out.sendConsBatConsume(5,true);
            this._consumeCount = 0;
         }
         else
         {
            ++this._consumeCount;
         }
      }
      
      private function addEvent() : void
      {
         this._resurrectBtn.addEventListener(MouseEvent.CLICK,this.__resurrect,false,0,true);
         this._stayResBtn.addEventListener(MouseEvent.CLICK,this.__stayRes,false,0,true);
      }
      
      private function __stayRes(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(getTimer() - this._lastCreatTime2 > 1000)
         {
            this._lastCreatTime2 = getTimer();
            this.promptlyStayRevive();
         }
      }
      
      protected function promptlyStayRevive() : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc1_:Object = ConsortiaBattleManager.instance.getBuyRecordStatus(3);
         if(Boolean(_loc1_.isNoPrompt))
         {
            if(Boolean(_loc1_.isBand) && PlayerManager.Instance.Self.Gift < 80)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.buy.noEnoughBindMoneyTxt"));
               _loc1_.isNoPrompt = false;
            }
            else
            {
               if(!(!_loc1_.isBand && PlayerManager.Instance.Self.Money < 80))
               {
                  SocketManager.Instance.out.sendConsBatConsume(4,_loc1_.isBand);
                  return;
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.buy.noEnoughMoneyTxt"));
               _loc1_.isNoPrompt = false;
            }
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortiaBattle.buyStayResurrect.promptTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"ConsBatBuyConfirmView",30,true);
         _loc2_.moveEnable = false;
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__StayResurrectConfirm,false,0,true);
      }
      
      protected function __StayResurrectConfirm(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         var _loc3_:Object = null;
         SoundManager.instance.play("008");
         var _loc4_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc4_.removeEventListener(FrameEvent.RESPONSE,this.__StayResurrectConfirm);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(_loc4_.isBand && PlayerManager.Instance.Self.Gift < 80)
            {
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortiaBattle.changeMoneyCostTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
               _loc2_.moveEnable = false;
               _loc2_.addEventListener(FrameEvent.RESPONSE,this.__StayResurrectTwoConfirm,false,0,true);
               return;
            }
            if(!_loc4_.isBand && PlayerManager.Instance.Self.Money < 80)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            if((_loc4_ as ConsBatBuyConfirmView).isNoPrompt)
            {
               _loc3_ = ConsortiaBattleManager.instance.getBuyRecordStatus(3);
               _loc3_.isNoPrompt = true;
               _loc3_.isBand = _loc4_.isBand;
            }
            SocketManager.Instance.out.sendConsBatConsume(4,_loc4_.isBand);
         }
      }
      
      protected function __StayResurrectTwoConfirm(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__StayResurrectTwoConfirm);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < 80)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.sendConsBatConsume(4,false);
         }
      }
      
      private function __resurrect(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(getTimer() - this._lastCreatTime > 1000)
         {
            this._lastCreatTime = getTimer();
            this.promptlyRevive();
         }
      }
      
      protected function promptlyRevive() : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc1_:Object = ConsortiaBattleManager.instance.getBuyRecordStatus(2);
         if(Boolean(_loc1_.isNoPrompt))
         {
            if(Boolean(_loc1_.isBand) && PlayerManager.Instance.Self.Gift < 50)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.buy.noEnoughBindMoneyTxt"));
               _loc1_.isNoPrompt = false;
            }
            else
            {
               if(!(!_loc1_.isBand && PlayerManager.Instance.Self.Money < 50))
               {
                  SocketManager.Instance.out.sendConsBatConsume(3,_loc1_.isBand);
                  return;
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.buy.noEnoughMoneyTxt"));
               _loc1_.isNoPrompt = false;
            }
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortiaBattle.buyResurrect.promptTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"ConsBatBuyConfirmView",30,true);
         _loc2_.moveEnable = false;
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__resurrectConfirm,false,0,true);
      }
      
      protected function __resurrectConfirm(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         var _loc3_:Object = null;
         SoundManager.instance.play("008");
         var _loc4_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc4_.removeEventListener(FrameEvent.RESPONSE,this.__resurrectConfirm);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(_loc4_.isBand && PlayerManager.Instance.Self.Gift < 50)
            {
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortiaBattle.changeMoneyCostTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
               _loc2_.moveEnable = false;
               _loc2_.addEventListener(FrameEvent.RESPONSE,this.__resurrectTwoConfirm,false,0,true);
               return;
            }
            if(!_loc4_.isBand && PlayerManager.Instance.Self.Money < 10)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            if((_loc4_ as ConsBatBuyConfirmView).isNoPrompt)
            {
               _loc3_ = ConsortiaBattleManager.instance.getBuyRecordStatus(2);
               _loc3_.isNoPrompt = true;
               _loc3_.isBand = _loc4_.isBand;
            }
            SocketManager.Instance.out.sendConsBatConsume(3,_loc4_.isBand);
         }
      }
      
      protected function __resurrectTwoConfirm(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__resurrectTwoConfirm);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < 50)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.sendConsBatConsume(3,false);
         }
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._resurrectBtn))
         {
            this._resurrectBtn.removeEventListener(MouseEvent.CLICK,this.__resurrect);
         }
         if(Boolean(this._stayResBtn))
         {
            this._stayResBtn.removeEventListener(MouseEvent.CLICK,this.__stayRes);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__startCount);
            this._timer = null;
         }
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            this.parent.removeChild(this);
         }
         this._bg = null;
         this._txtProp = null;
         this._resurrectBtn = null;
         this._stayResBtn = null;
         this._timeCD = null;
      }
   }
}
