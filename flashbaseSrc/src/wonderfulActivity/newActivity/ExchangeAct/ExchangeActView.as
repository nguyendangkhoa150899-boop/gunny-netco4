package wonderfulActivity.newActivity.ExchangeAct
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.SendGiftInfo;
   import wonderfulActivity.views.IRightView;
   
   public class ExchangeActView extends Sprite implements IRightView
   {
       
      
      private var _back:DisplayObject;
      
      private var _titleField:FilterFrameText;
      
      private var _buttonBack:DisplayObject;
      
      private var _exchangeButton:BaseButton;
      
      private var _container:Sprite;
      
      private var _actId:String;
      
      private var _activityInfo:GmActivityInfo;
      
      private var _goodsExchange:wonderfulActivity.newActivity.ExchangeAct.ExchangeGoodsView;
      
      public function ExchangeActView(param1:String)
      {
         super();
         this._actId = param1;
         WonderfulActivityManager.Instance.isExchangeAct = false;
      }
      
      public function init() : void
      {
         this.initView();
         this.addEvent();
         this.initData();
         this.initViewWithData();
      }
      
      private function initView() : void
      {
         this._container = new Sprite();
         PositionUtils.setPos(this._container,"wonderful.limitActivity.ContentPos");
         this._back = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityStateBg");
         this._container.addChild(this._back);
         this._titleField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityStateTitleField");
         this._container.addChild(this._titleField);
         this._buttonBack = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.GetButtonBackBg");
         this._container.addChild(this._buttonBack);
         this._exchangeButton = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.exchangeButton");
         this._container.addChild(this._exchangeButton);
         this._goodsExchange = new wonderfulActivity.newActivity.ExchangeAct.ExchangeGoodsView();
         PositionUtils.setPos(this._goodsExchange,"wonderful.exchangeGoodsView");
         this._container.addChild(this._goodsExchange);
         addChild(this._container);
      }
      
      private function initData() : void
      {
         this._activityInfo = WonderfulActivityManager.Instance.activityData[this._actId];
      }
      
      private function initViewWithData() : void
      {
         if(!this._activityInfo)
         {
            return;
         }
         this._titleField.text = this._activityInfo.activityName;
         this._goodsExchange.setData(this._activityInfo);
      }
      
      public function setState(param1:int, param2:int) : void
      {
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      private function addEvent() : void
      {
         this._exchangeButton.addEventListener(MouseEvent.CLICK,this.__exchange);
         this._goodsExchange.addEventListener(ExchangeGoodsEvent.ExchangeGoodsChange,this.__ExchangeGoodsChangeHandler);
      }
      
      private function __ExchangeGoodsChangeHandler(param1:ExchangeGoodsEvent) : void
      {
         if(param1.enable == false)
         {
            this._exchangeButton.enable = false;
         }
         else
         {
            this._exchangeButton.enable = true;
         }
      }
      
      private function __exchange(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         var _loc3_:SendGiftInfo = new SendGiftInfo();
         _loc3_.activityId = this._activityInfo.activityId;
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < this._goodsExchange.count)
         {
            _loc4_.push(this._activityInfo.giftbagArray[this._goodsExchange.selectedIndex].giftbagId);
            _loc5_++;
         }
         _loc3_.giftIdArr = _loc4_;
         _loc2_.push(_loc3_);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(_loc2_);
      }
      
      private function removeEvent() : void
      {
         this._exchangeButton.removeEventListener(MouseEvent.CLICK,this.__exchange);
         this._goodsExchange.removeEventListener(ExchangeGoodsEvent.ExchangeGoodsChange,this.__ExchangeGoodsChangeHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._back))
         {
            ObjectUtils.disposeObject(this._back);
         }
         this._back = null;
         if(Boolean(this._titleField))
         {
            ObjectUtils.disposeObject(this._titleField);
         }
         this._titleField = null;
         if(Boolean(this._buttonBack))
         {
            ObjectUtils.disposeObject(this._buttonBack);
         }
         this._buttonBack = null;
         if(Boolean(this._exchangeButton))
         {
            ObjectUtils.disposeObject(this._exchangeButton);
         }
         this._exchangeButton = null;
      }
   }
}
