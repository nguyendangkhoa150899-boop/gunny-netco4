package wonderfulActivity.items
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.SendGiftInfo;
   import wonderfulActivity.data.WonderfulActivityTypeData;
   import wonderfulActivity.views.IRightView;
   
   public class HeroView extends Sprite implements IRightView
   {
       
      
      private var _back:Bitmap;
      
      private var _activeTimeBit:Bitmap;
      
      private var _activetimeFilter:FilterFrameText;
      
      private var _getButton:SimpleBitmapButton;
      
      private var _cartoonList:Vector.<MovieClip>;
      
      private var _cartoonVisibleArr:Array;
      
      private var _bagCellGrayArr:Array;
      
      private var _bagCellArr:Array;
      
      private var _mcNum:int;
      
      private var _info:SelfInfo;
      
      private var _fightPowerArr:Array;
      
      private var _gradeArr:Array;
      
      private var _numPower:int = 0;
      
      private var _numGrade:int = 0;
      
      private var _activityInfo1:GmActivityInfo;
      
      private var _activityInfo2:GmActivityInfo;
      
      private var _activityInfoArr:Array;
      
      private var _giftInfoDic:Dictionary;
      
      private var _statusPowerArr:Array;
      
      private var _statusGradeArr:Array;
      
      public function HeroView()
      {
         super();
         this._fightPowerArr = new Array();
         this._gradeArr = new Array();
         this._activityInfoArr = new Array();
         this._cartoonVisibleArr = [false,false,false,false];
         this._bagCellGrayArr = [false,false,false,false];
         this._bagCellArr = new Array();
         this._info = PlayerManager.Instance.Self;
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
         var _loc4_:Bitmap = null;
         var _loc5_:FilterFrameText = null;
         var _loc6_:BagCell = null;
         var _loc9_:BagCell = null;
         var _loc1_:int = 0;
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         _loc4_ = null;
         _loc5_ = null;
         _loc6_ = null;
         var _loc7_:Bitmap = null;
         var _loc8_:FilterFrameText = null;
         _loc9_ = null;
         if(!this.checkData())
         {
            return;
         }
         if(Boolean(this._activityInfo1))
         {
            _loc2_ = [this._activityInfo1.beginTime.split(" ")[0],this._activityInfo1.endTime.split(" ")[0]];
            this._activetimeFilter.text = _loc2_[0] + "-" + _loc2_[1];
         }
         else if(Boolean(this._activityInfo2))
         {
            _loc3_ = [this._activityInfo2.beginTime.split(" ")[0],this._activityInfo2.endTime.split(" ")[0]];
            this._activetimeFilter.text = _loc3_[0] + "-" + _loc3_[1];
         }
         _loc1_ = 0;
         while(_loc1_ < 4 && _loc1_ < this._numPower + this._numGrade)
         {
            if(_loc1_ < this._numPower)
            {
               _loc4_ = ComponentFactory.Instance.creat("wonderfulactivity.powerBitmap");
               _loc4_.x += 120 * _loc1_;
               addChild(_loc4_);
               _loc5_ = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.heroTxt");
               _loc5_.x += 120 * _loc1_;
               _loc5_.text = this._fightPowerArr[_loc1_];
               addChild(_loc5_);
               _loc6_ = this.createBagCell(_loc1_,this._activityInfo1.giftbagArray[_loc1_]);
               _loc6_.x = _loc5_.x + 22;
               _loc6_.y = _loc5_.y + 45;
               addChild(_loc6_);
            }
            else
            {
               _loc7_ = ComponentFactory.Instance.creat("wonderfulactivity.levelBitmap");
               _loc7_.x += 120 * _loc1_;
               addChild(_loc7_);
               _loc8_ = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.heroTxt");
               _loc8_.x += 120 * _loc1_;
               _loc8_.text = this._gradeArr[_loc1_ - this._numPower];
               addChild(_loc8_);
               _loc9_ = this.createBagCell(_loc1_,this._activityInfo2.giftbagArray[_loc1_ - this._numPower]);
               _loc9_.x = _loc7_.x + 32;
               _loc9_.y = _loc8_.y + 45;
               addChild(_loc9_);
            }
            _loc1_++;
         }
         this.initItem();
      }
      
      private function checkData() : Boolean
      {
         if((Boolean(this._activityInfo1) || Boolean(this._activityInfo2)) && (this._fightPowerArr.length > 0 || this._gradeArr.length > 0))
         {
            return true;
         }
         return false;
      }
      
      private function initView() : void
      {
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.hero.back");
         addChild(this._back);
         this._activeTimeBit = ComponentFactory.Instance.creat("wonderfulactivity.activetime");
         addChild(this._activeTimeBit);
         this._activetimeFilter = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.activetimeTxt");
         addChild(this._activetimeFilter);
         this._getButton = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityState.GetButton");
         addChild(this._getButton);
         this._getButton.enable = false;
      }
      
      private function createBagCell(param1:int, param2:GiftBagInfo) : BagCell
      {
         var _loc3_:GiftRewardInfo = param2.giftRewardArr[0];
         var _loc4_:InventoryItemInfo = new InventoryItemInfo();
         _loc4_.TemplateID = _loc3_.templateId;
         _loc4_ = ItemManager.fill(_loc4_);
         _loc4_.IsBinds = _loc3_.isBind;
         _loc4_.ValidDate = _loc3_.validDate;
         var _loc5_:Array = _loc3_.property.split(",");
         _loc4_._StrengthenLevel = parseInt(_loc5_[0]);
         _loc4_.AttackCompose = parseInt(_loc5_[1]);
         _loc4_.DefendCompose = parseInt(_loc5_[2]);
         _loc4_.AgilityCompose = parseInt(_loc5_[3]);
         _loc4_.LuckCompose = parseInt(_loc5_[4]);
         var _loc6_:BagCell = new BagCell(param1);
         _loc6_.info = _loc4_;
         _loc6_.setCount(_loc3_.count);
         _loc6_.setBgVisible(false);
         if(Boolean(this._giftInfoDic))
         {
            if(Boolean(this._giftInfoDic[param2.giftbagId]) && this._giftInfoDic[param2.giftbagId].times > 0)
            {
               this._bagCellGrayArr[param1] = _loc6_.grayFilters = true;
            }
         }
         else
         {
            this._bagCellGrayArr[param1] = _loc6_.grayFilters = false;
         }
         this._bagCellArr.push(_loc6_);
         return _loc6_;
      }
      
      private function initData() : void
      {
         var _loc1_:GmActivityInfo = null;
         var _loc2_:int = 0;
         var _loc3_:Dictionary = null;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Dictionary = null;
         var _loc8_:* = null;
         var _loc9_:int = 0;
         var _loc10_:Dictionary = WonderfulActivityManager.Instance.activityInitData;
         for each(_loc1_ in WonderfulActivityManager.Instance.activityData)
         {
            if(_loc1_.activityType == WonderfulActivityTypeData.MAIN_FAMOUS_ACTIVITY)
            {
               if(_loc1_.activityChildType == WonderfulActivityTypeData.HERO_POWER)
               {
                  if(Boolean(WonderfulActivityManager.Instance.activityInitData[_loc1_.activityId]))
                  {
                     if(!this._giftInfoDic)
                     {
                        this._giftInfoDic = WonderfulActivityManager.Instance.activityInitData[_loc1_.activityId]["giftInfoDic"];
                     }
                     else
                     {
                        _loc3_ = WonderfulActivityManager.Instance.activityInitData[_loc1_.activityId]["giftInfoDic"];
                        if(Boolean(_loc3_))
                        {
                           for(_loc4_ in _loc3_)
                           {
                              this._giftInfoDic[_loc4_] = _loc3_[_loc4_];
                           }
                        }
                     }
                     this._statusPowerArr = WonderfulActivityManager.Instance.activityInitData[_loc1_.activityId]["statusArr"];
                  }
                  this._numPower = _loc1_.giftbagArray.length;
                  _loc2_ = 0;
                  while(_loc2_ < this._numPower && _loc2_ < 4)
                  {
                     _loc5_ = 0;
                     while(_loc5_ < _loc1_.giftbagArray[_loc2_].giftConditionArr.length)
                     {
                        if(_loc1_.giftbagArray[_loc2_].giftConditionArr[_loc5_].conditionIndex == 0)
                        {
                           this._fightPowerArr.push(_loc1_.giftbagArray[_loc2_].giftConditionArr[_loc5_].conditionValue);
                        }
                        _loc5_++;
                     }
                     _loc2_++;
                  }
                  this._activityInfo1 = _loc1_;
                  this._activityInfoArr.push(this._activityInfo1);
               }
               else if(_loc1_.activityChildType == WonderfulActivityTypeData.HERO_GRADE)
               {
                  if(Boolean(WonderfulActivityManager.Instance.activityInitData[_loc1_.activityId]))
                  {
                     if(!this._giftInfoDic)
                     {
                        this._giftInfoDic = WonderfulActivityManager.Instance.activityInitData[_loc1_.activityId]["giftInfoDic"];
                     }
                     else
                     {
                        _loc7_ = WonderfulActivityManager.Instance.activityInitData[_loc1_.activityId]["giftInfoDic"];
                        if(Boolean(_loc7_))
                        {
                           for(_loc8_ in _loc7_)
                           {
                              this._giftInfoDic[_loc8_] = _loc7_[_loc8_];
                           }
                        }
                     }
                     this._statusGradeArr = WonderfulActivityManager.Instance.activityInitData[_loc1_.activityId]["statusArr"];
                  }
                  this._numGrade = _loc1_.giftbagArray.length;
                  _loc6_ = 0;
                  while(_loc6_ < this._numGrade && _loc6_ < 4)
                  {
                     _loc9_ = 0;
                     while(_loc9_ < _loc1_.giftbagArray[_loc6_].giftConditionArr.length)
                     {
                        if(_loc1_.giftbagArray[_loc6_].giftConditionArr[_loc9_].conditionIndex == 0)
                        {
                           this._gradeArr.push(_loc1_.giftbagArray[_loc6_].giftConditionArr[_loc9_].conditionValue);
                        }
                        _loc9_++;
                     }
                     _loc6_++;
                  }
                  this._activityInfo2 = _loc1_;
                  this._activityInfoArr.push(this._activityInfo2);
               }
            }
         }
      }
      
      private function initCartoonPlayArr(param1:Array, param2:Array) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < param1.length && _loc3_ < 4)
         {
            if(this._statusPowerArr && this._statusPowerArr[0].statusValue >= param1[_loc3_] && !this._bagCellGrayArr[_loc3_])
            {
               this._cartoonVisibleArr[_loc3_] = true;
            }
            else
            {
               this._cartoonVisibleArr[_loc3_] = false;
            }
            _loc3_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < 4 - param1.length)
         {
            if(this._statusGradeArr && this._statusGradeArr[0].statusValue >= param2[_loc4_] && !this._bagCellGrayArr[_loc3_])
            {
               this._cartoonVisibleArr[param1.length + _loc4_] = true;
            }
            else
            {
               this._cartoonVisibleArr[param1.length + _loc4_] = false;
            }
            _loc4_++;
         }
      }
      
      private function initItem() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:int = 0;
         _loc2_ = null;
         this._cartoonList = new Vector.<MovieClip>();
         this.initCartoonPlayArr(this._fightPowerArr,this._gradeArr);
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            if(Boolean(this._cartoonVisibleArr[_loc1_]))
            {
               _loc2_ = ComponentFactory.Instance.creat("wonderfulactivity.cartoon");
               _loc2_.mouseChildren = false;
               _loc2_.mouseEnabled = false;
               _loc2_.x = 268 + 120 * _loc1_;
               _loc2_.y = 311;
               addChild(_loc2_);
               this._cartoonList.push(_loc2_);
            }
            _loc1_++;
         }
         if(this._cartoonList.length > 0)
         {
            this._getButton.enable = true;
            this._getButton.addEventListener(MouseEvent.CLICK,this.__getAward);
         }
      }
      
      private function __getAward(param1:MouseEvent) : void
      {
         var _loc2_:SendGiftInfo = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         SoundManager.instance.playButtonSound();
         var _loc5_:int = 0;
         while(_loc5_ < this._bagCellArr.length)
         {
            if(Boolean(this._cartoonVisibleArr[_loc5_]))
            {
               (this._bagCellArr[_loc5_] as BagCell).grayFilters = true;
            }
            _loc5_++;
         }
         var _loc6_:int = 0;
         while(_loc6_ < this._cartoonList.length)
         {
            this._cartoonList[_loc6_].parent.removeChild(this._cartoonList[_loc6_]);
            _loc6_++;
         }
         this._getButton.enable = false;
         var _loc7_:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         var _loc8_:int = 0;
         while(_loc8_ < this._activityInfoArr.length)
         {
            _loc2_ = new SendGiftInfo();
            _loc2_.activityId = this._activityInfoArr[_loc8_].activityId;
            _loc3_ = new Array();
            _loc4_ = 0;
            while(_loc4_ < this._activityInfoArr[_loc8_].giftbagArray.length)
            {
               _loc3_.push(this._activityInfoArr[_loc8_].giftbagArray[_loc4_].giftbagId);
               _loc4_++;
            }
            _loc2_.giftIdArr = _loc3_;
            _loc7_.push(_loc2_);
            _loc8_++;
         }
         SocketManager.Instance.out.sendWonderfulActivityGetReward(_loc7_);
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function dispose() : void
      {
         var _loc1_:MovieClip = null;
         this._getButton.removeEventListener(MouseEvent.CLICK,this.__getAward);
         this._bagCellArr = null;
         for each(_loc1_ in this._cartoonList)
         {
            if(Boolean(_loc1_.parent))
            {
               _loc1_.parent.removeChild(_loc1_);
            }
            _loc1_ = null;
         }
         this._cartoonList = null;
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
