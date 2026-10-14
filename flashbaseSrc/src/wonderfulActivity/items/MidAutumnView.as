package wonderfulActivity.items
{
   import activeEvents.data.ActiveEventsInfo;
   import calendar.CalendarManager;
   import calendar.view.ICalendar;
   import calendar.view.goodsExchange.GoodsExchangeInfo;
   import calendar.view.goodsExchange.SendGoodsExchangeInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.utils.setTimeout;
   import road7th.utils.DateUtils;
   import wonderfulActivity.event.ActivityEvent;
   
   public class MidAutumnView extends Sprite implements ICalendar
   {
      
      private static var HAVE_GOODS_CELL_COUNT:int = 20;
      
      private static var EXCHANGE_GOODS_CELL_COUNT:int = 5;
       
      
      private var _activityInfo:ActiveEventsInfo;
      
      private var _goodsExchangeInfoVector:Vector.<GoodsExchangeInfo>;
      
      private var _cellVector:Vector.<wonderfulActivity.items.ActivitySeedCell>;
      
      private var _exchangeCellVec:Vector.<wonderfulActivity.items.ActivitySeedCell>;
      
      private var _bg:Bitmap;
      
      private var _activityTime:FilterFrameText;
      
      private var _description:FilterFrameText;
      
      private var _haveGoodsBox:SimpleTileList;
      
      private var _exchangeGoodsBox:SimpleTileList;
      
      private var _getAwardFlag:Boolean = true;
      
      public function MidAutumnView()
      {
         super();
         this.initview();
      }
      
      private function initview() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.activity.midautumnbg");
         addChild(this._bg);
         this._activityTime = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.midAutumn.actTime");
         addChild(this._activityTime);
         this._description = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.midAutumn.description");
         PositionUtils.setPos(this._description,"ddtcalendar.midAutumnView.description");
         addChild(this._description);
         this._haveGoodsBox = ComponentFactory.Instance.creatCustomObject("ddtcalendar.midAutumnView.haveGoodsBox",[4]);
         addChild(this._haveGoodsBox);
         this._exchangeGoodsBox = ComponentFactory.Instance.creatCustomObject("ddtcalendar.midAutumnView.exchangeGoodsBox",[1]);
         addChild(this._exchangeGoodsBox);
      }
      
      public function setData(param1:* = null) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this._activityInfo = param1 as ActiveEventsInfo;
         if(Boolean(this._activityInfo))
         {
            this._goodsExchangeInfoVector = new Vector.<GoodsExchangeInfo>();
            _loc2_ = CalendarManager.getInstance().activeExchange;
            _loc3_ = int(_loc2_.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if(this._activityInfo.ActiveID == _loc2_[_loc4_].ActiveID)
               {
                  this._goodsExchangeInfoVector.push(_loc2_[_loc4_]);
               }
               _loc4_++;
            }
            this.updateTimeShow();
            this.updateDescription();
            this.updateHaveGoodsBox();
            this.updateExchangeGoodsBox();
            this.addAwardAnimation();
         }
      }
      
      private function updateDescription() : void
      {
         this._description.text = this._activityInfo.Description;
      }
      
      private function addAwardAnimation() : void
      {
         var _loc1_:int = int(this._cellVector.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(_loc2_ % 4 == 0)
            {
               this._getAwardFlag = true;
            }
            if(this._cellVector[_loc2_].needCount < 0)
            {
               this._getAwardFlag = false;
               this._cellVector[_loc2_].addSeedBtn();
            }
            else if(_loc2_ % 4 == 3 && this._getAwardFlag)
            {
               this._exchangeCellVec[int(_loc2_ / 4)].addAwardAnimation();
               this._exchangeCellVec[int(_loc2_ / 4)].addEventListener(ActivityEvent.SEND_GOOD,this.__seedGood);
            }
            _loc2_++;
         }
      }
      
      private function __updateCellCount(param1:ActivityEvent) : void
      {
         this.setGetAwardBtnEnable(param1.id);
      }
      
      private function setGetAwardBtnEnable(param1:int) : void
      {
         if(this._cellVector[param1].needCount < 0)
         {
            setTimeout(this.removeAnimation,2500,param1);
         }
      }
      
      private function removeAnimation(param1:int) : void
      {
         this._cellVector[param1].addSeedBtn();
         var _loc2_:int = int(param1 / 4);
         this._exchangeCellVec[_loc2_].removeFireworkAnimation();
         this._exchangeCellVec[_loc2_].removeEventListener(ActivityEvent.SEND_GOOD,this.__seedGood);
      }
      
      protected function __seedGood(param1:ActivityEvent) : void
      {
         var _loc2_:SendGoodsExchangeInfo = null;
         var _loc3_:int = param1.id;
         var _loc4_:Vector.<SendGoodsExchangeInfo> = new Vector.<SendGoodsExchangeInfo>();
         var _loc5_:int = _loc3_ * 4 + 4;
         var _loc6_:int = _loc3_ * 4;
         while(_loc6_ < _loc5_)
         {
            _loc2_ = new SendGoodsExchangeInfo();
            _loc2_.id = this._cellVector[_loc6_].info.TemplateID;
            if(!this._cellVector[_loc6_].itemInfo)
            {
               return;
            }
            _loc2_.place = this._cellVector[_loc6_].itemInfo.Place;
            _loc2_.bagType = this._cellVector[_loc6_].itemInfo.BagType;
            _loc4_.push(_loc2_);
            _loc6_++;
         }
         SocketManager.Instance.out.sendGoodsExchange(_loc4_,this._activityInfo.ActiveID,1,_loc3_);
      }
      
      private function updateTimeShow() : void
      {
         var _loc1_:Date = DateUtils.getDateByStr(this._activityInfo.StartDate);
         var _loc2_:Date = DateUtils.getDateByStr(this._activityInfo.EndDate);
         this._activityTime.text = this.addZero(_loc1_.fullYear) + "." + this.addZero(_loc1_.month + 1) + "." + this.addZero(_loc1_.date);
         this._activityTime.text += "-" + this.addZero(_loc2_.fullYear) + "." + this.addZero(_loc2_.month + 1) + "." + this.addZero(_loc2_.date);
      }
      
      private function updateHaveGoodsBox() : void
      {
         var _loc1_:int = 0;
         var _loc2_:wonderfulActivity.items.ActivitySeedCell = null;
         if(!this._goodsExchangeInfoVector)
         {
            return;
         }
         this.cleanCell();
         this._haveGoodsBox.disposeAllChildren();
         ObjectUtils.removeChildAllChildren(this._haveGoodsBox);
         var _loc3_:int = int(this._goodsExchangeInfoVector.length);
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < 5)
         {
            _loc1_ = 0;
            while(_loc1_ < _loc3_)
            {
               if(this._goodsExchangeInfoVector[_loc1_].ItemType == _loc5_ * 2)
               {
                  _loc2_ = new wonderfulActivity.items.ActivitySeedCell(this._goodsExchangeInfoVector[_loc1_],this._activityInfo.ActiveType,this._cellVector.length);
                  this._haveGoodsBox.addChild(_loc2_);
                  _loc2_.addEventListener(ActivityEvent.UPDATE_COUNT,this.__updateCellCount);
                  _loc4_ += 1;
                  this._cellVector.push(_loc2_);
                  if(_loc4_ >= HAVE_GOODS_CELL_COUNT)
                  {
                     break;
                  }
               }
               _loc1_++;
            }
            _loc5_++;
         }
      }
      
      private function updateExchangeGoodsBox() : void
      {
         var _loc1_:int = 0;
         var _loc2_:wonderfulActivity.items.ActivitySeedCell = null;
         if(!this._goodsExchangeInfoVector)
         {
            return;
         }
         this.cleanExchangeCell();
         this._exchangeGoodsBox.disposeAllChildren();
         ObjectUtils.removeChildAllChildren(this._exchangeGoodsBox);
         var _loc3_:int = int(this._goodsExchangeInfoVector.length);
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < 5)
         {
            _loc1_ = 0;
            while(_loc1_ < _loc3_)
            {
               if(this._goodsExchangeInfoVector[_loc1_].ItemType == _loc5_ * 2 + 1)
               {
                  _loc2_ = new wonderfulActivity.items.ActivitySeedCell(this._goodsExchangeInfoVector[_loc1_],this._activityInfo.ActiveType,this._exchangeCellVec.length,false);
                  this._exchangeGoodsBox.addChild(_loc2_);
                  this._exchangeCellVec.push(_loc2_);
                  _loc4_ += 1;
                  if(_loc4_ >= EXCHANGE_GOODS_CELL_COUNT)
                  {
                     break;
                  }
               }
               _loc1_++;
            }
            _loc5_++;
         }
      }
      
      private function cleanCell() : void
      {
         var _loc1_:wonderfulActivity.items.ActivitySeedCell = null;
         for each(_loc1_ in this._cellVector)
         {
            _loc1_.removeEventListener(ActivityEvent.UPDATE_COUNT,this.__updateCellCount);
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         this._cellVector = new Vector.<ActivitySeedCell>();
      }
      
      private function cleanExchangeCell() : void
      {
         var _loc1_:wonderfulActivity.items.ActivitySeedCell = null;
         for each(_loc1_ in this._exchangeCellVec)
         {
            _loc1_.removeEventListener(ActivityEvent.SEND_GOOD,this.__seedGood);
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         this._exchangeCellVec = new Vector.<ActivitySeedCell>();
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
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            this._bg.bitmapData.dispose();
            this._bg = null;
         }
         this.cleanCell();
         this.cleanExchangeCell();
         if(Boolean(this._activityTime))
         {
            this._activityTime.dispose();
            this._activityTime = null;
         }
         if(Boolean(this._description))
         {
            this._description.dispose();
            this._description = null;
         }
         if(Boolean(this._haveGoodsBox))
         {
            this._haveGoodsBox.dispose();
            this._haveGoodsBox = null;
         }
         if(Boolean(this._exchangeGoodsBox))
         {
            this._exchangeGoodsBox.dispose();
            this._exchangeGoodsBox = null;
         }
      }
   }
}
