package wonderfulActivity.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.SendGiftInfo;
   import wonderfulActivity.data.WonderfulActivityTypeData;
   import wonderfulActivity.views.IRightView;
   
   public class AccumulativePayView extends Sprite implements IRightView
   {
      
      private static const LENGTH:int = 10;
      
      private static const LENGTH2:int = 8;
      
      private static const NUMBER:int = 5;
      
      private static const NUMBER2:int = 4;
      
      private static const PRIZE_LEN:int = 7;
       
      
      private var _content:Sprite;
      
      private var _bg:Bitmap;
      
      private var _title:Bitmap;
      
      private var _shadowBG:Bitmap;
      
      private var _progressBack1:ScaleBitmapImage;
      
      private var _progressBack2:ScaleBitmapImage;
      
      private var _itemList:SimpleTileList;
      
      private var _itemArr:Array;
      
      private var _prizeBG:Bitmap;
      
      private var _prizeList:HBox;
      
      private var _prizeArr:Array;
      
      private var _alreadyPayTxt:FilterFrameText;
      
      private var _alreadyPayValue:FilterFrameText;
      
      private var _nextPrizeNeedTxt:FilterFrameText;
      
      private var _nextPrizeNeedValue:FilterFrameText;
      
      private var _getPrizeBtn:SimpleBitmapButton;
      
      private var _progressList:SimpleTileList;
      
      private var _progressArr:Array;
      
      private var _tip:OneLineTip;
      
      private var activityData:Dictionary;
      
      private var activityInitData:Dictionary;
      
      private var actId:String;
      
      private var accPayValue:int;
      
      private var giftCurInfoDic:Dictionary;
      
      private var giftData:Array;
      
      private var index:int;
      
      public function AccumulativePayView()
      {
         super();
      }
      
      public function init() : void
      {
         this.accPayValue = 0;
         this.index = -1;
         this._itemArr = [];
         this._progressArr = [];
         this._prizeArr = [];
         this.initView();
         this.initData();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:AccumulativeItem = null;
         _loc1_ = 0;
         _loc2_ = null;
         var _loc3_:ScaleBitmapImage = null;
         var _loc4_:PrizeListItem = null;
         this._content = new Sprite();
         PositionUtils.setPos(this._content,"wonderful.Accumulative.ContentPos");
         this._bg = ComponentFactory.Instance.creat("wonderful.accumulative.BG");
         this._content.addChild(this._bg);
         this._title = ComponentFactory.Instance.creat("wonderful.accumulative.title");
         this._content.addChild(this._title);
         this._shadowBG = ComponentFactory.Instance.creat("wonderful.accumulative.shadowBG");
         this._content.addChild(this._shadowBG);
         this._progressBack1 = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulative.progressBack");
         PositionUtils.setPos(this._progressBack1,"wonderful.Accumulative.ProgressBackPos1");
         this._content.addChild(this._progressBack1);
         this._progressBack2 = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulative.progressBack");
         PositionUtils.setPos(this._progressBack2,"wonderful.Accumulative.ProgressBackPos2");
         this._content.addChild(this._progressBack2);
         this._itemList = ComponentFactory.Instance.creatCustomObject("wonderful.Accumulative.SimpleTileList",[NUMBER]);
         _loc1_ = 1;
         while(_loc1_ <= LENGTH)
         {
            _loc2_ = new AccumulativeItem();
            _loc2_.buttonMode = true;
            _loc2_.initView(_loc1_);
            _loc2_.turnGray(true);
            _loc2_.box.addEventListener(MouseEvent.CLICK,this.__itemBoxClick);
            this._itemList.addChild(_loc2_);
            this._itemArr.push(_loc2_);
            _loc1_++;
         }
         this._content.addChild(this._itemList);
         this._prizeBG = ComponentFactory.Instance.creat("wonderful.accumulative.prizeBG");
         this._content.addChild(this._prizeBG);
         this._alreadyPayTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulative.alreadyPayTxt");
         this._alreadyPayTxt.text = LanguageMgr.GetTranslation("wonderful.accumulative.alreadyPayTxt");
         this._content.addChild(this._alreadyPayTxt);
         this._alreadyPayValue = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulative.alreadyPayValue");
         this._alreadyPayValue.text = "0";
         this._content.addChild(this._alreadyPayValue);
         this._nextPrizeNeedTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulative.nextPrizeNeedTxt");
         this._nextPrizeNeedTxt.text = LanguageMgr.GetTranslation("wonderful.accumulative.nextPrizeNeedTxt");
         this._content.addChild(this._nextPrizeNeedTxt);
         this._nextPrizeNeedValue = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulative.nextPrizeNeedValue");
         this._nextPrizeNeedValue.text = "9999";
         this._content.addChild(this._nextPrizeNeedValue);
         this._getPrizeBtn = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulative.getPrizeBtn");
         this._getPrizeBtn.enable = false;
         this._content.addChild(this._getPrizeBtn);
         this._progressList = ComponentFactory.Instance.creatCustomObject("wonderful.Accumulative.progressList",[NUMBER2]);
         var _loc5_:int = 1;
         while(_loc5_ <= LENGTH2)
         {
            _loc3_ = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulative.progress2");
            _loc3_.visible = false;
            _loc3_.addEventListener(MouseEvent.ROLL_OVER,this.progressBackOver);
            _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.progressBackOver);
            _loc3_.addEventListener(MouseEvent.ROLL_OUT,this.progressBackOut);
            this._progressList.addChild(_loc3_);
            this._progressArr.push(_loc3_);
            _loc5_++;
         }
         this._content.addChild(this._progressList);
         this._prizeList = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulative.Hbox");
         var _loc6_:int = 1;
         while(_loc6_ <= PRIZE_LEN)
         {
            _loc4_ = new PrizeListItem();
            _loc4_.initView(_loc6_);
            this._prizeList.addChild(_loc4_);
            this._prizeArr.push(_loc4_);
            _loc6_++;
         }
         this._content.addChild(this._prizeList);
         this._prizeList.refreshChildPos();
         this._tip = new OneLineTip();
         this._tip.visible = false;
         this._content.addChild(this._tip);
         addChild(this._content);
      }
      
      private function initData() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         if(!this.checkData())
         {
            return;
         }
         var _loc3_:Array = this.activityData[this.actId].giftbagArray;
         var _loc4_:int = 0;
         while(_loc4_ <= _loc3_.length - 1)
         {
            if(this.accPayValue >= _loc3_[_loc4_].giftConditionArr[0].conditionValue)
            {
               (this._itemArr[_loc4_] as AccumulativeItem).turnGray(false);
               (this._itemArr[_loc4_] as AccumulativeItem).glint(true);
               (this._itemArr[_loc4_] as AccumulativeItem).setNumber(_loc3_[_loc4_].giftConditionArr[0].conditionValue);
               (this._itemArr[_loc4_] as AccumulativeItem).lightProgressPoint();
               this.index = _loc4_;
            }
            _loc4_++;
         }
         var _loc5_:int = -1;
         var _loc6_:int = 0;
         while(_loc6_ <= this.index)
         {
            _loc1_ = String(_loc3_[_loc6_].giftbagId);
            if(this.giftCurInfoDic[_loc1_].times > 0)
            {
               (this._itemArr[_loc6_] as AccumulativeItem).glint(false);
            }
            else
            {
               _loc5_ = _loc6_;
               this._getPrizeBtn.enable = true;
            }
            _loc6_++;
         }
         if(_loc5_ >= 0)
         {
            (this._itemArr[_loc5_] as AccumulativeItem).turnLight(true);
            this.showGift(_loc5_);
         }
         else
         {
            _loc2_ = this.index + 1 <= this._itemArr.length - 1 ? int(this.index + 1) : int(this.index);
            (this._itemArr[_loc2_] as AccumulativeItem).turnLight(true);
            this.showGift(_loc2_);
         }
         if(this.index + 1 <= _loc3_.length - 1)
         {
            (this._itemArr[this.index + 1] as AccumulativeItem).setNumber(_loc3_[this.index + 1].giftConditionArr[0].conditionValue);
            this._nextPrizeNeedValue.text = (_loc3_[this.index + 1].giftConditionArr[0].conditionValue - this.accPayValue).toString();
         }
         else
         {
            this._nextPrizeNeedValue.text = "0";
         }
         this._alreadyPayValue.text = this.accPayValue.toString();
         this.showProgress(this.index);
         this._tip.tipData = this.accPayValue.toString();
      }
      
      private function checkData() : Boolean
      {
         var _loc1_:GmActivityInfo = null;
         this.activityData = WonderfulActivityManager.Instance.activityData;
         this.activityInitData = WonderfulActivityManager.Instance.activityInitData;
         for each(_loc1_ in this.activityData)
         {
            if(_loc1_.activityType == WonderfulActivityTypeData.MAIN_PAY_ACTIVITY && _loc1_.activityChildType == WonderfulActivityTypeData.ACCUMULATIVE_PAY)
            {
               this.actId = _loc1_.activityId;
               break;
            }
         }
         if(this.actId == null || this.activityData[this.actId] == null)
         {
            return false;
         }
         if(this.activityInitData[this.actId] != null)
         {
            this.accPayValue = this.activityInitData[this.actId].statusArr[0].statusValue;
            this.giftCurInfoDic = this.activityInitData[this.actId].giftInfoDic;
         }
         return true;
      }
      
      private function initEvent() : void
      {
         this._getPrizeBtn.addEventListener(MouseEvent.CLICK,this.__GetPrizeBtnClick);
      }
      
      private function progressBackOver(param1:MouseEvent) : void
      {
         this._tip.visible = true;
         this._tip.x = this._content.mouseX;
         this._tip.y = this._content.mouseY;
      }
      
      private function progressBackOut(param1:MouseEvent) : void
      {
         this._tip.visible = false;
      }
      
      private function showProgress(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         if(param1 < 0)
         {
            return;
         }
         var _loc5_:int = -1;
         var _loc6_:int = 0;
         while(_loc6_ <= param1)
         {
            _loc5_++;
            if(_loc6_ == 4 || _loc6_ == 9)
            {
               _loc5_--;
            }
            this._progressArr[_loc5_].visible = true;
            _loc6_++;
         }
         var _loc7_:Array = this.activityData[this.actId].giftbagArray;
         if(param1 == 4 || param1 == 9 || param1 + 1 >= _loc7_.length || _loc5_ <= 0)
         {
            return;
         }
         _loc2_ = int(_loc7_[param1].giftConditionArr[0].conditionValue);
         _loc3_ = int(_loc7_[param1 + 1].giftConditionArr[0].conditionValue);
         _loc4_ = (this.accPayValue - _loc2_) / (_loc3_ - _loc2_);
         (this._progressArr[_loc5_] as ScaleBitmapImage).scaleX = _loc4_;
      }
      
      private function showGift(param1:int) : void
      {
         var _loc2_:GiftRewardInfo = null;
         if(param1 < 0 || param1 > this.activityData[this.actId].giftbagArray.length - 1)
         {
            return;
         }
         var _loc3_:Vector.<GiftRewardInfo> = this.activityData[this.actId].giftbagArray[param1].giftRewardArr;
         this.clearPrizeArr();
         var _loc4_:int = 0;
         while(_loc4_ <= _loc3_.length - 1)
         {
            _loc2_ = _loc3_[_loc4_] as GiftRewardInfo;
            this._prizeArr[_loc4_].setCellData(_loc2_);
            _loc4_++;
         }
      }
      
      private function clearPrizeArr() : void
      {
         var _loc1_:PrizeListItem = null;
         for each(_loc1_ in this._prizeArr)
         {
            _loc1_.setCellData(null);
         }
      }
      
      private function __GetPrizeBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:SendGiftInfo = new SendGiftInfo();
         _loc2_.activityId = this.actId;
         var _loc3_:Array = this.activityData[this.actId].giftbagArray;
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ <= _loc3_.length - 1)
         {
            _loc4_.push(_loc3_[_loc5_].giftbagId);
            _loc5_++;
         }
         _loc2_.giftIdArr = _loc4_;
         var _loc6_:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         _loc6_.push(_loc2_);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(_loc6_);
         var _loc7_:int = 0;
         while(_loc7_ <= this.index)
         {
            this._itemArr[_loc7_].glint(false);
            _loc7_++;
         }
         this._getPrizeBtn.enable = false;
      }
      
      private function __itemBoxClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:AccumulativeItem = param1.target.parent as AccumulativeItem;
         var _loc4_:int = this.index + 1 < this._itemArr.length ? int(this.index + 1) : int(this.index);
         if(_loc3_.index - 1 <= _loc4_)
         {
            _loc2_ = 0;
            while(_loc2_ <= _loc4_)
            {
               (this._itemArr[_loc2_] as AccumulativeItem).turnLight(false);
               _loc2_++;
            }
            _loc3_.turnLight(true);
            this.showGift(_loc3_.index - 1);
         }
      }
      
      private function removeEvents() : void
      {
         this._getPrizeBtn.removeEventListener(MouseEvent.CLICK,this.__GetPrizeBtnClick);
         var _loc1_:int = 0;
         while(_loc1_ <= this._itemArr.length - 1)
         {
            this._itemArr[_loc1_].box.removeEventListener(MouseEvent.CLICK,this.__itemBoxClick);
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ <= this._progressArr.length - 1)
         {
            this._progressArr[_loc2_].removeEventListener(MouseEvent.ROLL_OVER,this.progressBackOver);
            this._progressArr[_loc2_].removeEventListener(MouseEvent.MOUSE_MOVE,this.progressBackOver);
            this._progressArr[_loc2_].removeEventListener(MouseEvent.ROLL_OUT,this.progressBackOut);
            _loc2_++;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._title))
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(Boolean(this._shadowBG))
         {
            ObjectUtils.disposeObject(this._shadowBG);
         }
         this._shadowBG = null;
         if(Boolean(this._progressBack1))
         {
            ObjectUtils.disposeObject(this._progressBack1);
         }
         this._progressBack1 = null;
         if(Boolean(this._progressBack2))
         {
            ObjectUtils.disposeObject(this._progressBack2);
         }
         this._progressBack2 = null;
         if(Boolean(this._prizeBG))
         {
            ObjectUtils.disposeObject(this._prizeBG);
         }
         this._prizeBG = null;
         if(Boolean(this._alreadyPayTxt))
         {
            ObjectUtils.disposeObject(this._alreadyPayTxt);
         }
         this._alreadyPayTxt = null;
         if(Boolean(this._alreadyPayValue))
         {
            ObjectUtils.disposeObject(this._alreadyPayValue);
         }
         this._alreadyPayValue = null;
         if(Boolean(this._nextPrizeNeedTxt))
         {
            ObjectUtils.disposeObject(this._nextPrizeNeedTxt);
         }
         this._nextPrizeNeedTxt = null;
         if(Boolean(this._nextPrizeNeedValue))
         {
            ObjectUtils.disposeObject(this._nextPrizeNeedValue);
         }
         this._nextPrizeNeedValue = null;
         if(Boolean(this._getPrizeBtn))
         {
            ObjectUtils.disposeObject(this._getPrizeBtn);
         }
         this._getPrizeBtn = null;
         if(Boolean(this._itemList))
         {
            ObjectUtils.disposeObject(this._itemList);
         }
         this._itemList = null;
         if(Boolean(this._prizeList))
         {
            ObjectUtils.disposeObject(this._prizeList);
         }
         this._prizeList = null;
         var _loc1_:int = 0;
         while(_loc1_ <= this._itemArr.length - 1)
         {
            if(Boolean(this._itemArr[_loc1_]))
            {
               ObjectUtils.disposeObject(this._itemArr[_loc1_]);
            }
            this._itemArr[_loc1_] = null;
            _loc1_++;
         }
         if(Boolean(this._progressList))
         {
            ObjectUtils.disposeObject(this._progressList);
         }
         this._progressList = null;
         var _loc2_:int = 0;
         while(_loc2_ <= this._progressArr.length - 1)
         {
            if(Boolean(this._progressArr[_loc2_]))
            {
               ObjectUtils.disposeObject(this._progressArr[_loc2_]);
            }
            this._progressArr[_loc2_] = null;
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ <= this._prizeArr.length - 1)
         {
            if(Boolean(this._prizeArr[_loc3_]))
            {
               ObjectUtils.disposeObject(this._prizeArr[_loc3_]);
            }
            this._prizeArr[_loc3_] = null;
            _loc3_++;
         }
         if(Boolean(this._tip))
         {
            ObjectUtils.disposeObject(this._tip);
         }
         this._tip = null;
         if(Boolean(this._content))
         {
            ObjectUtils.disposeObject(this._content);
         }
         this._content = null;
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function setState(param1:int, param2:int) : void
      {
      }
   }
}
