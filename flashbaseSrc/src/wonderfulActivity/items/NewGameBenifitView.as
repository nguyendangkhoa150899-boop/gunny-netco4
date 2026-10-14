package wonderfulActivity.items
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.SendGiftInfo;
   import wonderfulActivity.data.WonderfulActivityTypeData;
   import wonderfulActivity.views.IRightView;
   
   public class NewGameBenifitView extends Sprite implements IRightView
   {
       
      
      private var _back:Bitmap;
      
      private var _activeTimeBit:Bitmap;
      
      private var _activetimeFilter:FilterFrameText;
      
      private var _rectangle:Rectangle;
      
      private var _pBar:Bitmap;
      
      private var _progressBar:Bitmap;
      
      private var _progressBarBitmapData:BitmapData;
      
      private var _progressFrame:Bitmap;
      
      private var _progressComplete:Bitmap;
      
      private var _progressTip:wonderfulActivity.items.NewGameBenifitTipSprite;
      
      private var _progressCompleteNum:int;
      
      private var _progressWidthArr:Array;
      
      private var _itemArr:Array;
      
      private var _itemLightArr:Array;
      
      private var _currentTarget;
      
      private var _awardArr:Array;
      
      private var _activityInfo:GmActivityInfo;
      
      private var _getButton:SimpleBitmapButton;
      
      private var _bagCellDic:Dictionary;
      
      private var _giftInfoDic:Dictionary;
      
      private var _statusArr:Array;
      
      private var _chargeNumArr:Array;
      
      public function NewGameBenifitView()
      {
         this._progressWidthArr = [35,35 + 56,35 + 56 * 2,35 + 56 * 3,35 + 56 * 4,35 + 56 * 5];
         super();
         this._itemArr = new Array();
         this._itemLightArr = new Array();
         this._awardArr = new Array();
         this._chargeNumArr = new Array();
         this._bagCellDic = new Dictionary();
         this._progressTip = new wonderfulActivity.items.NewGameBenifitTipSprite();
      }
      
      public function setState(param1:int, param2:int) : void
      {
      }
      
      public function init() : void
      {
         this.initView();
         this.initData();
         this.initViewWithData();
      }
      
      private function initViewWithData() : void
      {
         var _loc1_:Array = null;
         if(!this.checkData())
         {
            return;
         }
         if(Boolean(this._activityInfo))
         {
            _loc1_ = [this._activityInfo.beginTime.split(" ")[0],this._activityInfo.endTime.split(" ")[0]];
            this._activetimeFilter.text = _loc1_[0] + "-" + _loc1_[1];
            this._activetimeFilter.y = 202;
         }
         this.initProgressBar(Boolean(this._statusArr) ? int(this._statusArr[0].statusValue) : int(0));
         this.initItem();
         this.initAward();
         this.setCurrentData(0);
      }
      
      private function checkData() : Boolean
      {
         if(Boolean(this._activityInfo) && this._chargeNumArr.length >= 6)
         {
            return true;
         }
         return false;
      }
      
      private function initView() : void
      {
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.newgamebenifit.back");
         addChild(this._back);
         this._activeTimeBit = ComponentFactory.Instance.creat("wonderfulactivity.activetime");
         this._activeTimeBit.y = 195;
         addChild(this._activeTimeBit);
         this._activetimeFilter = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.activetimeTxt");
         addChild(this._activetimeFilter);
         this._progressFrame = ComponentFactory.Instance.creat("wonderfulactivity.newgamebenifit.progressframe");
         addChild(this._progressFrame);
         this._pBar = ComponentFactory.Instance.creat("wonderfulactivity.newgamebenifit.progressbar");
         this._progressBar = new Bitmap();
         this._progressBar.x = this._pBar.x;
         this._progressBar.y = this._pBar.y;
         this._progressTip.x = this._progressBar.x;
         this._progressTip.y = this._progressBar.y;
         this._getButton = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityState.GetButton");
         addChild(this._getButton);
         this._getButton.enable = false;
      }
      
      private function initData() : void
      {
         var _loc1_:GmActivityInfo = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         for each(_loc1_ in WonderfulActivityManager.Instance.activityData)
         {
            if(_loc1_.activityType == WonderfulActivityTypeData.MAIN_PAY_ACTIVITY && _loc1_.activityChildType == WonderfulActivityTypeData.NEWGAMEBENIFIT)
            {
               this._activityInfo = _loc1_;
               if(Boolean(WonderfulActivityManager.Instance.activityInitData[_loc1_.activityId]))
               {
                  this._giftInfoDic = WonderfulActivityManager.Instance.activityInitData[_loc1_.activityId]["giftInfoDic"];
                  this._statusArr = WonderfulActivityManager.Instance.activityInitData[_loc1_.activityId]["statusArr"];
               }
               _loc2_ = 0;
               while(_loc2_ < _loc1_.giftbagArray.length)
               {
                  _loc3_ = 0;
                  while(_loc3_ < _loc1_.giftbagArray[_loc2_].giftConditionArr.length)
                  {
                     if(_loc1_.giftbagArray[_loc2_].giftConditionArr[_loc3_].conditionIndex == 0 && this._chargeNumArr.length < 6)
                     {
                        this._chargeNumArr.push(_loc1_.giftbagArray[_loc2_].giftConditionArr[_loc3_].conditionValue);
                     }
                     _loc3_++;
                  }
                  _loc2_++;
               }
            }
         }
      }
      
      private function initProgressBar(param1:int) : void
      {
         var _loc2_:Bitmap = null;
         var _loc3_:int = 0;
         _loc2_ = null;
         this._rectangle = new Rectangle();
         this._rectangle.x = 0;
         this._rectangle.y = 0;
         this._rectangle.height = this._pBar.height;
         if(param1 < this._chargeNumArr[0])
         {
            this._rectangle.width = param1 / this._chargeNumArr[0] * 35;
            this._progressCompleteNum = 0;
         }
         else if(param1 >= this._chargeNumArr[0] && param1 < this._chargeNumArr[1])
         {
            this._rectangle.width = 35 + (param1 - this._chargeNumArr[0]) / (this._chargeNumArr[1] - this._chargeNumArr[0]) * 56;
            this._progressCompleteNum = 1;
         }
         else if(param1 >= this._chargeNumArr[1] && param1 < this._chargeNumArr[2])
         {
            this._rectangle.width = 35 + 56 + (param1 - this._chargeNumArr[1]) / (this._chargeNumArr[2] - this._chargeNumArr[1]) * 56;
            this._progressCompleteNum = 2;
         }
         else if(param1 >= this._chargeNumArr[2] && param1 < this._chargeNumArr[3])
         {
            this._rectangle.width = 35 + 56 * 2 + (param1 - this._chargeNumArr[2]) / (this._chargeNumArr[3] - this._chargeNumArr[2]) * 56;
            this._progressCompleteNum = 3;
         }
         else if(param1 >= this._chargeNumArr[3] && param1 < this._chargeNumArr[4])
         {
            this._rectangle.width = 35 + 56 * 3 + (param1 - this._chargeNumArr[3]) / (this._chargeNumArr[4] - this._chargeNumArr[3]) * 56;
            this._progressCompleteNum = 4;
         }
         else if(param1 >= this._chargeNumArr[4] && param1 < this._chargeNumArr[5])
         {
            this._rectangle.width = 35 + 56 * 4 + (param1 - this._chargeNumArr[4]) / (this._chargeNumArr[5] - this._chargeNumArr[4]) * 56;
            this._progressCompleteNum = 5;
         }
         else if(param1 >= this._chargeNumArr[5])
         {
            this._rectangle.width = this._pBar.width;
            this._progressCompleteNum = 6;
         }
         if(this._rectangle.width <= 0)
         {
            this._rectangle.width = 1;
         }
         this._rectangle.width = Math.ceil(this._rectangle.width);
         this._progressBarBitmapData = new BitmapData(this._rectangle.width,this._rectangle.height,true,0);
         this._progressBarBitmapData.copyPixels(this._pBar.bitmapData,this._rectangle,new Point(0,0));
         this._progressBar.bitmapData = this._progressBarBitmapData;
         addChild(this._progressBar);
         this._progressTip.tipStyle = "ddt.view.tips.OneLineTip";
         this._progressTip.tipDirctions = "0,1,2";
         this._progressTip.tipData = param1;
         this._progressTip.back = new Bitmap(this._pBar.bitmapData.clone());
         addChild(this._progressTip);
         _loc3_ = 0;
         while(_loc3_ < this._progressCompleteNum)
         {
            _loc2_ = ComponentFactory.Instance.creat("wonderfulactivity.newgamebenifit.progresscomplete");
            _loc2_.y = this._progressBar.y - 2;
            _loc2_.x = 318 + this._progressWidthArr[_loc3_] - 6;
            addChild(_loc2_);
            _loc3_++;
         }
         var _loc4_:Boolean = true;
         if(Boolean(this._giftInfoDic) && this._progressCompleteNum >= 1)
         {
            if(this._giftInfoDic[this._activityInfo.giftbagArray[this._progressCompleteNum - 1].giftbagId].times > 0)
            {
               _loc4_ = false;
            }
         }
         if(this._progressCompleteNum > 0 && _loc4_)
         {
            this._getButton.enable = true;
            this._getButton.addEventListener(MouseEvent.CLICK,this.__getAward);
         }
      }
      
      private function __getAward(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._getButton.enable = false;
         var _loc2_:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         var _loc3_:SendGiftInfo = new SendGiftInfo();
         _loc3_.activityId = this._activityInfo.activityId;
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < this._activityInfo.giftbagArray.length)
         {
            _loc4_.push(this._activityInfo.giftbagArray[_loc5_].giftbagId);
            _loc5_++;
         }
         _loc3_.giftIdArr = _loc4_;
         _loc2_.push(_loc3_);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(_loc2_);
      }
      
      private function initItem() : void
      {
         var _loc2_:SimpleBitmapButton = null;
         var _loc1_:int = 0;
         _loc2_ = null;
         var _loc3_:SimpleBitmapButton = null;
         var _loc4_:FilterFrameText = null;
         var _loc5_:int = 0;
         while(_loc5_ < this._chargeNumArr.length)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityState.itemButton");
            _loc2_.x = 330 + 55 * _loc5_ + _loc5_;
            _loc2_.y = 294;
            this._itemArr.push(_loc2_);
            _loc2_.addEventListener(MouseEvent.CLICK,this.itemClickHandler);
            addChild(_loc2_);
            _loc5_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._chargeNumArr.length)
         {
            _loc3_ = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityState.itemLightButton");
            _loc3_.x = 330 + 55 * _loc1_ + _loc1_;
            _loc3_.y = 279;
            this._itemLightArr.push(_loc3_);
            _loc3_.addEventListener(MouseEvent.CLICK,this.itemClickHandler);
            addChild(_loc3_);
            _loc4_ = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.newgameTxt");
            if(_loc1_ == 0)
            {
               _loc3_.enable = _loc3_.visible = true;
               this._currentTarget = _loc3_;
            }
            else if(_loc1_ == 1 || _loc1_ == 2)
            {
               _loc3_.enable = _loc3_.visible = false;
            }
            else
            {
               _loc3_.enable = _loc3_.visible = false;
            }
            _loc4_.x = _loc3_.x + 5;
            _loc4_.y = _loc3_.y + 22;
            if(int(this._chargeNumArr[_loc1_]) / 100000 >= 1)
            {
               _loc4_.text = int(this._chargeNumArr[_loc1_]) / 10000 + "w";
            }
            else
            {
               _loc4_.text = this._chargeNumArr[_loc1_];
            }
            addChild(_loc4_);
            _loc1_++;
         }
      }
      
      private function initAward() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:BagCell = null;
         if(Boolean(this._activityInfo.giftbagArray))
         {
            _loc1_ = 0;
            while(_loc1_ < this._activityInfo.giftbagArray.length)
            {
               _loc2_ = new Array();
               if(Boolean(this._activityInfo.giftbagArray[_loc1_].giftRewardArr))
               {
                  _loc3_ = 0;
                  while(_loc3_ < this._activityInfo.giftbagArray[_loc1_].giftRewardArr.length)
                  {
                     _loc4_ = this.createBagCell(this._activityInfo.giftbagArray[_loc1_].giftbagOrder,this._activityInfo.giftbagArray[_loc1_].giftRewardArr[_loc3_]);
                     _loc4_.x = this._getButton.x - 89 + 63 * _loc3_;
                     _loc4_.y = this._getButton.y - 90;
                     addChild(_loc4_);
                     _loc2_.push(_loc4_);
                     _loc3_++;
                  }
               }
               this._bagCellDic[_loc1_] = _loc2_;
               _loc1_++;
            }
         }
      }
      
      private function createBagCell(param1:int, param2:GiftRewardInfo) : BagCell
      {
         var _loc3_:InventoryItemInfo = new InventoryItemInfo();
         _loc3_.TemplateID = param2.templateId;
         _loc3_ = ItemManager.fill(_loc3_);
         _loc3_.IsBinds = param2.isBind;
         _loc3_.ValidDate = param2.validDate;
         var _loc4_:Array = param2.property.split(",");
         _loc3_._StrengthenLevel = parseInt(_loc4_[0]);
         _loc3_.AttackCompose = parseInt(_loc4_[1]);
         _loc3_.DefendCompose = parseInt(_loc4_[2]);
         _loc3_.AgilityCompose = parseInt(_loc4_[3]);
         _loc3_.LuckCompose = parseInt(_loc4_[4]);
         var _loc5_:BagCell = new BagCell(param1);
         _loc5_.info = _loc3_;
         _loc5_.setCount(param2.count);
         _loc5_.setBgVisible(false);
         return _loc5_;
      }
      
      private function itemClickHandler(param1:MouseEvent) : void
      {
         if(param1.target == this._currentTarget)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._itemArr.length)
         {
            if(this._itemArr[_loc2_] == param1.target)
            {
               this._currentTarget = this._itemLightArr[_loc2_];
               this.setCurrentData(_loc2_);
               break;
            }
            _loc2_++;
         }
      }
      
      private function setCurrentData(param1:int) : void
      {
         var _loc2_:BagCell = null;
         var _loc3_:BagCell = null;
         var _loc4_:int = 0;
         while(_loc4_ < this._itemArr.length)
         {
            if(_loc4_ == param1)
            {
               this._itemArr[_loc4_].enable = this._itemArr[_loc4_].visible = false;
               this._itemLightArr[_loc4_].enable = this._itemLightArr[_loc4_].visible = true;
               if(Boolean(this._bagCellDic[_loc4_]))
               {
                  for each(_loc2_ in this._bagCellDic[_loc4_])
                  {
                     _loc2_.visible = true;
                  }
               }
            }
            else
            {
               this._itemArr[_loc4_].enable = this._itemArr[_loc4_].visible = true;
               this._itemLightArr[_loc4_].enable = this._itemLightArr[_loc4_].visible = false;
               if(Boolean(this._bagCellDic[_loc4_]))
               {
                  for each(_loc3_ in this._bagCellDic[_loc4_])
                  {
                     _loc3_.visible = false;
                  }
               }
            }
            _loc4_++;
         }
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function dispose() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         this._getButton.removeEventListener(MouseEvent.CLICK,this.__getAward);
         var _loc3_:int = 0;
         while(_loc3_ < this._itemArr.length)
         {
            (this._itemArr[_loc3_] as SimpleBitmapButton).removeEventListener(MouseEvent.CLICK,this.itemClickHandler);
            _loc3_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < this._itemArr.length)
         {
            (this._itemLightArr[_loc4_] as SimpleBitmapButton).removeEventListener(MouseEvent.CLICK,this.itemClickHandler);
            _loc4_++;
         }
         for each(_loc1_ in this._bagCellDic)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               _loc1_[_loc2_] = null;
               _loc2_++;
            }
         }
         this._bagCellDic = null;
         while(Boolean(this.numChildren))
         {
            ObjectUtils.disposeObject(this.getChildAt(0));
         }
         if(Boolean(parent))
         {
            ObjectUtils.disposeObject(this);
         }
      }
   }
}
