package calendar.view.goodsExchange
{
   import activeEvents.data.ActiveEventsInfo;
   import calendar.CalendarEvent;
   import calendar.CalendarManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import road7th.utils.DateUtils;
   
   public class GoodsExchangeView extends Sprite implements Disposeable
   {
      
      private static var HAVE_GOODS_CELL_COUNT:int = 8;
      
      private static var EXCHANGE_GOODS_CELL_COUNT:int = 5;
       
      
      private var _time:Bitmap;
      
      private var _actTimeText:FilterFrameText;
      
      private var _actTime:FilterFrameText;
      
      private var _haveImg:Bitmap;
      
      private var _haveGoodsExplain:FilterFrameText;
      
      private var _haveGoodsBox:SimpleTileList;
      
      private var _line:Bitmap;
      
      private var _exchangImg:Bitmap;
      
      private var _exchangGoodsExplain:FilterFrameText;
      
      private var _exchangGoodsCountText:FilterFrameText;
      
      private var _exchangGoodsCount:FilterFrameText;
      
      private var _awardBtnGroup:SelectedButtonGroup;
      
      private var _awardBtn1:SelectedButton;
      
      private var _awardBtn2:SelectedButton;
      
      private var _awardBtn3:SelectedButton;
      
      private var _exchangGoodsBox:SimpleTileList;
      
      private var _awardBg1:MutipleImage;
      
      private var _awardBg2:Scale9CornerImage;
      
      private var _textBg:Scale9CornerImage;
      
      private var _goodsExchangeInfoVector:Vector.<calendar.view.goodsExchange.GoodsExchangeInfo>;
      
      private var _count:int = 1;
      
      private var _haveGoodsCount:int;
      
      private var _activeEventsInfo:ActiveEventsInfo;
      
      private var _awardIndex:int = 0;
      
      private var _cellVector:Vector.<calendar.view.goodsExchange.GoodsExchangeCell>;
      
      private var _ifNoneGoods:Boolean;
      
      public function GoodsExchangeView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this.showTime();
         this.haveGoods();
         this.exchangGoods();
      }
      
      private function showTime() : void
      {
         this._time = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.TimeIcon");
         PositionUtils.setPos(this._time,"ddtcalendar.GoodsExchangeView.timeImgPos");
         addChild(this._time);
         this._actTimeText = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.actTimeText");
         this._actTimeText.text = LanguageMgr.GetTranslation("tank.calendar.GoodsExchangeView.actTimeText");
         addChild(this._actTimeText);
         this._actTime = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.actTime");
         addChild(this._actTime);
      }
      
      private function haveGoods() : void
      {
         this._haveImg = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.AwardIcon");
         PositionUtils.setPos(this._haveImg,"ddtcalendar.GoodsExchangeView.HaveImgPos");
         this._haveGoodsExplain = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.haveGoodsExplain");
         this._haveGoodsExplain.text = LanguageMgr.GetTranslation("tank.calendar.GoodsExchangeView.haveGoodsExplainText");
         addChild(this._haveGoodsExplain);
         this._haveGoodsBox = ComponentFactory.Instance.creatCustomObject("ddtcalendar.exchange.haveGoodsBox",[4]);
         addChild(this._haveGoodsBox);
         this._line = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.SeparatorLine");
         PositionUtils.setPos(this._line,"ddtcalendar.exchange.LinePos");
         addChild(this._line);
      }
      
      private function exchangGoods() : void
      {
         this._awardBg1 = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.awardBack");
         addChild(this._awardBg1);
         this._awardBg2 = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.awardScoreBg");
         addChild(this._awardBg2);
         this._textBg = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.TextFieldBg");
         addChild(this._textBg);
         this._exchangImg = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.ContentIcon");
         PositionUtils.setPos(this._exchangImg,"ddtcalendar.GoodsExchangeView.changeImgPos");
         addChild(this._exchangImg);
         this._exchangGoodsExplain = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.changeGoodsExplain");
         this._exchangGoodsExplain.text = LanguageMgr.GetTranslation("tank.calendar.GoodsExchangeView.changeGoodsExplainText");
         addChild(this._exchangGoodsExplain);
         this._exchangGoodsCountText = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.changeGoodsCountText");
         this._exchangGoodsCountText.text = LanguageMgr.GetTranslation("tank.calendar.GoodsExchangeView.changeGoodsCountText");
         addChild(this._exchangGoodsCountText);
         this._exchangGoodsCount = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.changeGoodsCount");
         this._exchangGoodsCount.text = "1";
         this._exchangGoodsCount.restrict = "0-9";
         addChild(this._exchangGoodsCount);
         this._awardBtnGroup = new SelectedButtonGroup();
         this._awardBtn1 = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.awardBtn1");
         addChild(this._awardBtn1);
         this._awardBtn2 = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.awardBtn2");
         addChild(this._awardBtn2);
         this._awardBtn3 = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.awardBtn3");
         addChild(this._awardBtn3);
         this._awardBtnGroup.addSelectItem(this._awardBtn1);
         this._awardBtnGroup.addSelectItem(this._awardBtn2);
         this._awardBtnGroup.addSelectItem(this._awardBtn3);
         this._awardBtnGroup.selectIndex = 0;
         this._exchangGoodsBox = ComponentFactory.Instance.creatCustomObject("ddtcalendar.exchange.exchangeGoodsBox",[5]);
         addChild(this._exchangGoodsBox);
      }
      
      private function initEvent() : void
      {
         this._awardBtn1.addEventListener(MouseEvent.CLICK,this.__clickBtn);
         this._awardBtn2.addEventListener(MouseEvent.CLICK,this.__clickBtn);
         this._awardBtn3.addEventListener(MouseEvent.CLICK,this.__clickBtn);
         this._exchangGoodsCount.addEventListener(MouseEvent.CLICK,this.__countClickHandler);
         this._exchangGoodsCount.addEventListener(KeyboardEvent.KEY_DOWN,this.__countOnKeyDown);
         this._exchangGoodsCount.addEventListener(Event.CHANGE,this.__countChangeHandler);
      }
      
      private function __clickBtn(param1:MouseEvent) : void
      {
         this._exchangGoodsCount.text = "1";
         this.count = 0;
         SoundManager.instance.play("008");
         this._awardIndex = this._awardBtnGroup.selectIndex;
      }
      
      private function __changeHandler(param1:Event) : void
      {
         var _loc2_:int = this._awardBtnGroup.selectIndex;
         this._haveGoodsCount = 0;
         this.updateHaveGoodsBox(_loc2_);
         this.updateExchangeGoodsBox(_loc2_);
      }
      
      private function __countClickHandler(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
      }
      
      private function __countOnKeyDown(param1:KeyboardEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
      }
      
      private function __countChangeHandler(param1:Event) : void
      {
         var _loc2_:String = null;
         if(this._exchangGoodsCount.text == "")
         {
            this._exchangGoodsCount.text = "1";
         }
         else if(this._exchangGoodsCount.text != "0")
         {
            _loc2_ = this._exchangGoodsCount.text.substr(0,1);
            if(_loc2_ == "0")
            {
               this._exchangGoodsCount.text = this._exchangGoodsCount.text.substring(1);
            }
         }
         if(int(this._exchangGoodsCount.text) > this._haveGoodsCount)
         {
            if(this._haveGoodsCount == 0)
            {
               this._exchangGoodsCount.text = "1";
            }
            else
            {
               this._exchangGoodsCount.text = this._haveGoodsCount.toString();
            }
         }
         this.count = int(this._exchangGoodsCount.text);
      }
      
      public function setData(param1:ActiveEventsInfo) : void
      {
         this._activeEventsInfo = param1;
         this._goodsExchangeInfoVector = new Vector.<GoodsExchangeInfo>();
         var _loc2_:Array = CalendarManager.getInstance().activeExchange;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this._activeEventsInfo.ActiveID == _loc2_[_loc4_].ActiveID)
            {
               this._goodsExchangeInfoVector.push(_loc2_[_loc4_]);
            }
            _loc4_++;
         }
         this.updateTimeShow();
         this.updateHaveGoodsBox(0);
         this.updateExchangeGoodsBox(0);
      }
      
      private function updateTimeShow() : void
      {
         var _loc1_:Date = DateUtils.getDateByStr(this._activeEventsInfo.StartDate);
         var _loc2_:Date = DateUtils.getDateByStr(this._activeEventsInfo.EndDate);
         this._actTime.text = this.addZero(_loc1_.fullYear) + "." + this.addZero(_loc1_.month + 1) + "." + this.addZero(_loc1_.date);
         this._actTime.text += "-" + this.addZero(_loc2_.fullYear) + "." + this.addZero(_loc2_.month + 1) + "." + this.addZero(_loc2_.date);
      }
      
      private function addZero(param1:Number) : String
      {
         var _loc2_:String = null;
         if(param1 < 10)
         {
            _loc2_ = "0" + param1.toString();
         }
         else
         {
            _loc2_ = param1.toString();
         }
         return _loc2_;
      }
      
      private function updateHaveGoodsBox(param1:int) : void
      {
         var _loc2_:calendar.view.goodsExchange.GoodsExchangeCell = null;
         var _loc3_:int = 0;
         if(!this._goodsExchangeInfoVector)
         {
            return;
         }
         this._ifNoneGoods = false;
         this.cleanCell();
         this._haveGoodsBox.disposeAllChildren();
         ObjectUtils.removeChildAllChildren(this._haveGoodsBox);
         var _loc4_:int = int(this._goodsExchangeInfoVector.length);
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            if(this._goodsExchangeInfoVector[_loc6_].ItemType == param1 * 2)
            {
               _loc2_ = new calendar.view.goodsExchange.GoodsExchangeCell(this._goodsExchangeInfoVector[_loc6_]);
               this.getLeastCount(_loc2_);
               this._haveGoodsBox.addChild(_loc2_);
               _loc5_ += 1;
               this._cellVector.push(_loc2_);
            }
            _loc6_++;
         }
         if(_loc5_ < HAVE_GOODS_CELL_COUNT)
         {
            _loc3_ = _loc5_;
            while(_loc3_ < HAVE_GOODS_CELL_COUNT)
            {
               this._haveGoodsBox.addChild(new calendar.view.goodsExchange.GoodsExchangeCell(null));
               _loc3_++;
            }
         }
         if(_loc5_ == 0)
         {
            this.getLeastCount(null);
            this._exchangGoodsCount.text = "0";
         }
         this.checkBtn();
      }
      
      private function updateExchangeGoodsBox(param1:int) : void
      {
         var _loc2_:int = 0;
         if(!this._goodsExchangeInfoVector)
         {
            return;
         }
         this._exchangGoodsBox.disposeAllChildren();
         ObjectUtils.removeChildAllChildren(this._exchangGoodsBox);
         var _loc3_:int = int(this._goodsExchangeInfoVector.length);
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            if(this._goodsExchangeInfoVector[_loc5_].ItemType == param1 * 2 + 1)
            {
               this._exchangGoodsBox.addChild(new calendar.view.goodsExchange.GoodsExchangeCell(this._goodsExchangeInfoVector[_loc5_],this._activeEventsInfo.ActiveType,false));
               _loc4_ += 1;
            }
            _loc5_++;
         }
         if(_loc3_ < EXCHANGE_GOODS_CELL_COUNT)
         {
            _loc2_ = _loc4_;
            while(_loc2_ < EXCHANGE_GOODS_CELL_COUNT)
            {
               this._exchangGoodsBox.addChild(new calendar.view.goodsExchange.GoodsExchangeCell(null));
               _loc2_++;
            }
         }
      }
      
      private function cleanCell() : void
      {
         var _loc1_:calendar.view.goodsExchange.GoodsExchangeCell = null;
         for each(_loc1_ in this._cellVector)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         this._cellVector = new Vector.<GoodsExchangeCell>();
      }
      
      public function sendGoods() : void
      {
         var _loc1_:SendGoodsExchangeInfo = null;
         var _loc2_:Boolean = false;
         var _loc3_:Vector.<SendGoodsExchangeInfo> = new Vector.<SendGoodsExchangeInfo>();
         var _loc4_:int = 0;
         while(_loc4_ < this._cellVector.length)
         {
            _loc1_ = new SendGoodsExchangeInfo();
            if(!this._cellVector[_loc4_].info || !this._cellVector[_loc4_].itemInfo)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("calendar.view.goodsExchange.warningIII"));
               return;
            }
            _loc1_.id = this._cellVector[_loc4_].info.TemplateID;
            _loc1_.place = this._cellVector[_loc4_].itemInfo.Place;
            _loc1_.bagType = this._cellVector[_loc4_].itemInfo.BagType;
            _loc3_.push(_loc1_);
            if(this._cellVector[_loc4_].needCount - this.count <= 0)
            {
               _loc2_ = true;
            }
            _loc4_++;
         }
         this._exchangGoodsCount.text = "1";
         SocketManager.Instance.out.sendGoodsExchange2(_loc3_,this._activeEventsInfo.ActiveID,this.count,this._awardIndex);
         this._count = 1;
         if(_loc2_)
         {
            dispatchEvent(new CalendarEvent(CalendarEvent.ExchangeGoodsChange,false));
         }
      }
      
      private function getLeastCount(param1:calendar.view.goodsExchange.GoodsExchangeCell) : void
      {
         if(param1 == null)
         {
            this._haveGoodsCount = 0;
            if(this._count != 0)
            {
               this._count = 0;
            }
            return;
         }
         var _loc2_:int = param1.needCount;
         if(this._ifNoneGoods == true)
         {
            return;
         }
         if(_loc2_ == 0)
         {
            this._ifNoneGoods = true;
            this._haveGoodsCount = 0;
         }
         else if(this._haveGoodsCount == 0)
         {
            this._haveGoodsCount = _loc2_;
         }
         else
         {
            this._haveGoodsCount = this._haveGoodsCount > _loc2_ ? int(int(int(_loc2_))) : int(int(int(this._haveGoodsCount)));
         }
      }
      
      private function get count() : int
      {
         return this._count;
      }
      
      private function set count(param1:int) : void
      {
         this._count = param1 == 0 ? int(int(int(1))) : int(int(int(param1)));
         this.__changeHandler(null);
      }
      
      private function checkBtn() : void
      {
         if(this._haveGoodsCount == 0 || this._exchangGoodsCount.text == "0")
         {
            dispatchEvent(new CalendarEvent(CalendarEvent.ExchangeGoodsChange,false));
         }
         else
         {
            dispatchEvent(new CalendarEvent(CalendarEvent.ExchangeGoodsChange,true));
         }
      }
      
      private function removeView() : void
      {
         if(Boolean(this._time))
         {
            ObjectUtils.disposeObject(this._time);
            this._time = null;
         }
         if(Boolean(this._actTimeText))
         {
            ObjectUtils.disposeObject(this._actTimeText);
            this._actTimeText = null;
         }
         if(Boolean(this._actTime))
         {
            ObjectUtils.disposeObject(this._actTime);
            this._actTime = null;
         }
         if(Boolean(this._haveImg))
         {
            ObjectUtils.disposeObject(this._haveImg);
            this._haveImg = null;
         }
         if(Boolean(this._haveGoodsExplain))
         {
            ObjectUtils.disposeObject(this._haveGoodsExplain);
            this._haveGoodsExplain = null;
         }
         if(Boolean(this._haveGoodsBox))
         {
            ObjectUtils.disposeObject(this._haveGoodsBox);
            this._haveGoodsBox = null;
         }
         if(Boolean(this._line))
         {
            ObjectUtils.disposeObject(this._line);
            this._line = null;
         }
         if(Boolean(this._exchangImg))
         {
            ObjectUtils.disposeObject(this._exchangImg);
            this._exchangImg = null;
         }
         if(Boolean(this._exchangGoodsExplain))
         {
            ObjectUtils.disposeObject(this._exchangGoodsExplain);
            this._exchangGoodsExplain = null;
         }
         if(Boolean(this._exchangGoodsCountText))
         {
            ObjectUtils.disposeObject(this._exchangGoodsCountText);
            this._exchangGoodsCountText = null;
         }
         if(Boolean(this._exchangGoodsBox))
         {
            ObjectUtils.disposeObject(this._exchangGoodsBox);
            this._exchangGoodsBox = null;
         }
         if(Boolean(this._awardBg1))
         {
            ObjectUtils.disposeObject(this._awardBg1);
            this._awardBg1 = null;
         }
         if(Boolean(this._awardBg2))
         {
            ObjectUtils.disposeObject(this._awardBg2);
            this._awardBg2 = null;
         }
         if(Boolean(this._awardBtn1))
         {
            ObjectUtils.disposeObject(this._awardBtn1);
            this._awardBtn1 = null;
         }
         if(Boolean(this._awardBtn2))
         {
            ObjectUtils.disposeObject(this._awardBtn2);
            this._awardBtn2 = null;
         }
         if(Boolean(this._awardBtn3))
         {
            ObjectUtils.disposeObject(this._awardBtn3);
            this._awardBtn3 = null;
         }
         if(Boolean(this._textBg))
         {
            ObjectUtils.disposeObject(this._textBg);
            this._textBg = null;
         }
      }
      
      private function removeEvent() : void
      {
         this._awardBtnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         if(Boolean(this._awardBtn1))
         {
            this._awardBtn1.removeEventListener(MouseEvent.CLICK,this.__clickBtn);
         }
         if(Boolean(this._awardBtn2))
         {
            this._awardBtn2.removeEventListener(MouseEvent.CLICK,this.__clickBtn);
         }
         if(Boolean(this._awardBtn3))
         {
            this._awardBtn3.removeEventListener(MouseEvent.CLICK,this.__clickBtn);
         }
         this._exchangGoodsCount.removeEventListener(MouseEvent.CLICK,this.__countClickHandler);
         this._exchangGoodsCount.removeEventListener(KeyboardEvent.KEY_DOWN,this.__countOnKeyDown);
         this._exchangGoodsCount.removeEventListener(Event.CHANGE,this.__countChangeHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeView();
      }
   }
}
