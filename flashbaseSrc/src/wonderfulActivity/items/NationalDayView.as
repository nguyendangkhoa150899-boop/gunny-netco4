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
   import road7th.utils.DateUtils;
   import wonderfulActivity.event.ActivityEvent;
   
   public class NationalDayView extends Sprite implements ICalendar
   {
       
      
      private var _bg:Bitmap;
      
      private var _activityTime:FilterFrameText;
      
      private var _description:FilterFrameText;
      
      private var _activityInfo:ActiveEventsInfo;
      
      private var _goodsExchangeInfoVector:Vector.<GoodsExchangeInfo>;
      
      private var _cellVector:Vector.<wonderfulActivity.items.ActivitySeedCell>;
      
      private var _haveGoodsBox1:SimpleTileList;
      
      private var _haveGoodsBox2:SimpleTileList;
      
      private var _haveGoodsBox3:SimpleTileList;
      
      private var _haveGoodsBox:Vector.<SimpleTileList>;
      
      private var _exchangeCellVec:Vector.<wonderfulActivity.items.ActivitySeedCell>;
      
      public function NationalDayView()
      {
         super();
         this.initview();
      }
      
      private function initview() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.activity.nationalbg");
         addChild(this._bg);
         this._activityTime = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.midAutumn.actTime");
         PositionUtils.setPos(this._activityTime,"ddtcalendar.nationalDayView.timePos");
         addChild(this._activityTime);
         this._description = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.midAutumn.description");
         PositionUtils.setPos(this._description,"ddtcalendar.nationalDayView.description");
         addChild(this._description);
         this._haveGoodsBox1 = ComponentFactory.Instance.creatCustomObject("ddtcalendar.nationalDayView.haveGoodsBox1",[4]);
         addChild(this._haveGoodsBox1);
         this._haveGoodsBox2 = ComponentFactory.Instance.creatCustomObject("ddtcalendar.nationalDayView.haveGoodsBox2",[4]);
         addChild(this._haveGoodsBox2);
         this._haveGoodsBox3 = ComponentFactory.Instance.creatCustomObject("ddtcalendar.nationalDayView.haveGoodsBox3",[4]);
         addChild(this._haveGoodsBox3);
         this._haveGoodsBox = new Vector.<SimpleTileList>();
         this._haveGoodsBox.push(this._haveGoodsBox1);
         this._haveGoodsBox.push(this._haveGoodsBox2);
         this._haveGoodsBox.push(this._haveGoodsBox3);
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
         var _loc1_:int = 0;
         var _loc2_:int = 4;
         var _loc3_:int = int(this._cellVector.length);
         var _loc4_:Boolean = true;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            if(_loc5_ == 0 || _loc5_ == 4 || _loc5_ == 12)
            {
               _loc2_ += _loc5_;
               _loc4_ = true;
            }
            if(this._cellVector[_loc5_].needCount < 0)
            {
               _loc4_ = false;
            }
            else if(_loc5_ % _loc2_ == 3 && _loc4_)
            {
               _loc1_ = _loc5_ < 4 ? int(0) : (_loc5_ < 12 ? int(1) : int(2));
               this._exchangeCellVec[_loc1_].addFireworkAnimation(_loc1_);
               this._exchangeCellVec[_loc1_].addEventListener(ActivityEvent.SEND_GOOD,this.__seedGood);
            }
            _loc5_++;
         }
      }
      
      private function __updateCellCount(param1:ActivityEvent) : void
      {
         this.setGetAwardBtnEnable(param1.id);
      }
      
      private function setGetAwardBtnEnable(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this._cellVector[param1].needCount < 0)
         {
            _loc2_ = param1 < 4 ? int(0) : (param1 < 12 ? int(1) : int(2));
            this._exchangeCellVec[_loc2_].removeFireworkAnimation();
            this._exchangeCellVec[_loc2_].removeEventListener(ActivityEvent.SEND_GOOD,this.__seedGood);
         }
      }
      
      protected function __seedGood(param1:ActivityEvent) : void
      {
         var _loc2_:SendGoodsExchangeInfo = null;
         var _loc3_:int = param1.id;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(_loc3_ == 0)
         {
            _loc4_ = 0;
            _loc5_ = 4;
         }
         else if(_loc3_ == 1)
         {
            _loc4_ = 4;
            _loc5_ = 12;
         }
         else
         {
            _loc4_ = 12;
            _loc5_ = 24;
         }
         var _loc6_:Vector.<SendGoodsExchangeInfo> = new Vector.<SendGoodsExchangeInfo>();
         var _loc7_:int = _loc4_;
         while(_loc7_ < _loc5_)
         {
            _loc2_ = new SendGoodsExchangeInfo();
            _loc2_.id = this._cellVector[_loc7_].info.TemplateID;
            _loc2_.place = this._cellVector[_loc7_].itemInfo.Place;
            _loc2_.bagType = this._cellVector[_loc7_].itemInfo.BagType;
            _loc6_.push(_loc2_);
            _loc7_++;
         }
         SocketManager.Instance.out.sendGoodsExchange(_loc6_,this._activityInfo.ActiveID,1,_loc3_);
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
         var _loc3_:int = int(this._goodsExchangeInfoVector.length);
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < 3)
         {
            this._haveGoodsBox[_loc5_].disposeAllChildren();
            ObjectUtils.removeChildAllChildren(this._haveGoodsBox[_loc5_]);
            _loc1_ = 0;
            while(_loc1_ < _loc3_)
            {
               if(this._goodsExchangeInfoVector[_loc1_].ItemType == _loc5_ * 2)
               {
                  _loc2_ = new wonderfulActivity.items.ActivitySeedCell(this._goodsExchangeInfoVector[_loc1_],this._activityInfo.ActiveType,this._cellVector.length);
                  this._haveGoodsBox[_loc5_].addChild(_loc2_);
                  _loc2_.addEventListener(ActivityEvent.UPDATE_COUNT,this.__updateCellCount);
                  _loc4_ += 1;
                  this._cellVector.push(_loc2_);
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
                  this.setFireworkTemplateID(this._goodsExchangeInfoVector[_loc1_]);
                  _loc2_ = new wonderfulActivity.items.ActivitySeedCell(this._goodsExchangeInfoVector[_loc1_],this._activityInfo.ActiveType,this._exchangeCellVec.length,false);
                  addChild(_loc2_);
                  this._exchangeCellVec.push(_loc2_);
                  PositionUtils.setPos(_loc2_,"ddtcalendar.nationalDayView.fireworkPos" + this._exchangeCellVec.length);
                  _loc4_ += 1;
               }
               _loc1_++;
            }
            _loc5_++;
         }
      }
      
      private function setFireworkTemplateID(param1:GoodsExchangeInfo) : void
      {
         if(param1.TemplateID > 112333 && param1.TemplateID < 112337)
         {
            param1.TemplateID -= 100616;
         }
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
      
      private function updateTimeShow() : void
      {
         var _loc1_:Date = DateUtils.getDateByStr(this._activityInfo.StartDate);
         var _loc2_:Date = DateUtils.getDateByStr(this._activityInfo.EndDate);
         this._activityTime.text = this.addZero(_loc1_.fullYear) + "." + this.addZero(_loc1_.month + 1) + "." + this.addZero(_loc1_.date);
         this._activityTime.text += "-" + this.addZero(_loc2_.fullYear) + "." + this.addZero(_loc2_.month + 1) + "." + this.addZero(_loc2_.date);
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
         var _loc1_:int = 0;
         while(_loc1_ < this._haveGoodsBox.length)
         {
            this._haveGoodsBox[_loc1_].dispose();
            this._haveGoodsBox[_loc1_] = null;
            _loc1_++;
         }
         this._haveGoodsBox.length = 0;
         this._haveGoodsBox = null;
      }
   }
}
