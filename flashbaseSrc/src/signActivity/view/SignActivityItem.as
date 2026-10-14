package signActivity.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import signActivity.SignActivityMgr;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftCurInfo;
   import wonderfulActivity.data.PlayerCurInfo;
   import wonderfulActivity.data.SendGiftInfo;
   
   public class SignActivityItem extends Sprite
   {
      
      public static var length:int = 1;
      
      public static var btnIndex:int = 1;
      
      public static var btnBigIndex:int = 1;
      
      public static var continuousGoodsIndex:int = 1;
       
      
      private var giftInfo:GiftBagInfo;
      
      private var _smallBtn:BaseButton;
      
      private var _goodEveryDayItemContainerAll:Sprite;
      
      private var _goodItemContainerAll:Sprite;
      
      private var _tag:Bitmap;
      
      private var _day:int;
      
      private var _money:int;
      
      private var _index:int;
      
      private var condition:int;
      
      private var tagIndex:int;
      
      private var leftIndex:int;
      
      private var dayArray:Array;
      
      private var _desText:FilterFrameText;
      
      public function SignActivityItem($day:int, $money:int)
      {
         this.dayArray = [3,7,14];
         super();
         this._day = $day;
      }
      
      private function removeEvent() : void
      {
         if(this._smallBtn)
         {
            this._smallBtn.removeEventListener("click",this.getRewardBtnClick);
         }
         if(this._day == this.dayArray[2] && this._goodEveryDayItemContainerAll)
         {
            this._goodEveryDayItemContainerAll.removeEventListener("rollOver",this.__onOver);
            this._goodEveryDayItemContainerAll.removeEventListener("rollOut",this.__onOut);
         }
      }
      
      private function getRewardBtnClick(e:MouseEvent) : void
      {
		 var _loc3_:SendGiftInfo = new SendGiftInfo();
		 _loc3_.activityId = SignActivityMgr.instance.model.actId;
		 _loc3_.giftIdArr = [giftInfo.giftbagId];
		 var _loc2_:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
		 _loc2_.push(_loc3_);
		 SocketManager.Instance.out.sendWonderfulActivityGetReward(_loc2_);
		 setGetBtnEnalbe(false);
      }
      
      public function setGetBtnEnalbe($flag:*) : void
      {
         if(this._smallBtn)
         {
            ObjectUtils.disposeObject(this._smallBtn);
            this._smallBtn = null;
         }
         if(this.giftInfo.giftConditionArr[0].conditionIndex == 1)
         {
            this._tag = ComponentFactory.Instance.creatBitmap("asset.signactivity.tag");
            PositionUtils.setPos(this._tag,"asset.signactivity.tag.pos." + this._day + "." + (this.tagIndex + 1));
            addChild(this._tag);
         }
         else
         {
            this.createBigBtn(this.leftIndex + 1,false);
            addChild(this._smallBtn);
            this._smallBtn.enable = $flag;
            ++this.leftIndex;
         }
      }
      
      public function setGoods(info:GiftBagInfo) : void
      {
         this.giftInfo = info;
         this.condition = this._money;
         if(this.giftInfo.giftConditionArr[0].conditionIndex == 1)
         {
            this.everyDayGoods();
         }
         else
         {
            this.continuousGoods();
         }
      }
      
      private function everyDayGoods() : void
      {
         var _loc3_:* = undefined;
         var _loc6_:* = null;
         var _loc5_:* = null;
         var _loc4_:* = null;
         var _loc1_:* = null;
         var _loc2_:* = null;
         if(this._goodEveryDayItemContainerAll)
         {
            ObjectUtils.disposeObject(this._goodEveryDayItemContainerAll);
            this._goodEveryDayItemContainerAll = null;
         }
         this._goodEveryDayItemContainerAll = new Sprite();
         for each(_loc3_ in this.giftInfo.giftRewardArr)
         {
            _loc6_ = _loc3_.property.split(",");
            _loc5_ = ComponentFactory.Instance.creatBitmap("asset.signactivity.goodsBG");
            _loc4_ = ItemManager.Instance.getTemplateById(_loc3_.templateId) as ItemTemplateInfo;
            _loc1_ = new InventoryItemInfo();
            ObjectUtils.copyProperties(_loc1_,_loc4_);
            _loc1_.StrengthenLevel = _loc6_[0];
            _loc1_.AttackCompose = _loc6_[1];
            _loc1_.DefendCompose = _loc6_[2];
            _loc1_.AgilityCompose = _loc6_[3];
            _loc1_.LuckCompose = _loc6_[4];
            //_loc1_.MagicAttack = _loc6_[6];
            //_loc1_.MagicDefence = _loc6_[7];
            _loc1_.ValidDate = _loc3_.validDate;
            _loc1_.IsBinds = _loc3_.isBind;
            _loc1_.Count = _loc3_.count;
            _loc2_ = new BagCell(0,_loc1_,false);
            _loc2_.setBgVisible(false);
            this._goodEveryDayItemContainerAll.addChild(_loc5_);
            this._goodEveryDayItemContainerAll.addChild(_loc2_);
         }
         addChild(this._goodEveryDayItemContainerAll);
         PositionUtils.setPos(this._goodEveryDayItemContainerAll,"everyDayGoods." + this._day + "." + length);
         ++length;
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         if(this._day == this.dayArray[2])
         {
            this.addEventListener("mouseOver",this.__onOver);
            this.addEventListener("mouseOut",this.__onOut);
         }
      }
      
      private function __onOver(e:MouseEvent) : void
      {
         if(this._smallBtn)
         {
            this._smallBtn.visible = true;
         }
      }
      
      private function __onOut(e:MouseEvent) : void
      {
         if(this._smallBtn)
         {
            this._smallBtn.visible = false;
         }
      }
      
      private function continuousGoods() : void
      {
         var _loc3_:* = undefined;
         var _loc7_:* = null;
         var _loc6_:* = null;
         var _loc5_:* = null;
         var _loc1_:* = null;
         var _loc2_:* = null;
         if(this._goodItemContainerAll)
         {
            ObjectUtils.disposeObject(this._goodItemContainerAll);
            this._goodItemContainerAll = null;
         }
         this._goodItemContainerAll = new Sprite();
         var _loc4_:int = 0;
         for each(_loc3_ in this.giftInfo.giftRewardArr)
         {
            _loc7_ = _loc3_.property.split(",");
            _loc6_ = ComponentFactory.Instance.creatBitmap("asset.signactivity.goodsBG");
            _loc5_ = ItemManager.Instance.getTemplateById(_loc3_.templateId) as ItemTemplateInfo;
            _loc1_ = new InventoryItemInfo();
            ObjectUtils.copyProperties(_loc1_,_loc5_);
            _loc1_.StrengthenLevel = _loc7_[0];
            _loc1_.AttackCompose = _loc7_[1];
            _loc1_.DefendCompose = _loc7_[2];
            _loc1_.AgilityCompose = _loc7_[3];
            _loc1_.LuckCompose = _loc7_[4];
            //_loc1_.MagicAttack = _loc7_[6];
            //_loc1_.MagicDefence = _loc7_[7];
            _loc1_.ValidDate = _loc3_.validDate;
            _loc1_.IsBinds = _loc3_.isBind;
            _loc1_.Count = _loc3_.count;
            _loc2_ = new BagCell(0,_loc1_,false);
            if(this._day == this.dayArray[2])
            {
               _loc2_.width = 42;
               _loc2_.height = 42;
               _loc6_.height = 45;
               _loc6_.width = 45;
               _loc6_.x = _loc4_ * (_loc6_.width + 2);
               _loc2_.x = _loc6_.x + 5;
            }
            else
            {
               _loc6_.x = _loc4_ * (_loc6_.width + 2);
               _loc2_.x = _loc6_.x + 5;
            }
            _loc6_.y = 20;
            _loc2_.y = 25;
            _loc2_.setBgVisible(false);
            this._goodItemContainerAll.addChild(_loc6_);
            this._goodItemContainerAll.addChild(_loc2_);
            _loc4_++;
         }
         addChild(this._goodItemContainerAll);
         PositionUtils.setPos(this._goodItemContainerAll,this._day == 14 ? "continuousGoods.14" : "continuousGoods." + this._day + "." + continuousGoodsIndex);
         ++continuousGoodsIndex;
         if(this._day == 14)
         {
            this._desText = ComponentFactory.Instance.creatComponentByStylename("signActivityFrame.desTxt");
            addChild(this._desText);
            this._desText.text = LanguageMgr.GetTranslation("tank.signActivity.dexTxt",this.giftInfo.giftConditionArr[0].conditionValue);
         }
      }
      
      public function setStatus(statusArr:Array, giftStatusDic:Dictionary, index:int) : void
      {
         var _loc4_:int = 0;
         var _loc6_:* = null;
         this.clearBtn();
         this.tagIndex = index;
         var _loc5_:PlayerCurInfo = statusArr[index] as PlayerCurInfo;
         if((_loc4_ = (giftStatusDic[this.giftInfo.giftbagId] as GiftCurInfo).times) == 0)
         {
            if(this.giftInfo.giftConditionArr[0].conditionIndex == 1)
            {
               this._smallBtn = ComponentFactory.Instance.creat("signActivityItem.getBtn");
               PositionUtils.setPos(this._smallBtn,"signActivityItem.getBtn." + this._day + "." + btnIndex);
               this.leftIndex = btnIndex;
               ++btnIndex;
               if(this._day == this.dayArray[2])
               {
                  this._smallBtn.visible = false;
               }
            }
            else if(this.giftInfo.giftConditionArr[0].conditionIndex == 2)
            {
               this.createBigBtn(btnBigIndex);
               ++btnBigIndex;
            }
            addChild(this._smallBtn);
            this._smallBtn.enable = false;
            if(this.giftInfo.giftConditionArr[0].conditionIndex == 1)
            {
               if(_loc5_.statusValue == 1)
               {
                  this._smallBtn.enable = true;
                  this._smallBtn.addEventListener("click",this.getRewardBtnClick);
               }
               else if(_loc5_.statusValue == 2)
               {
                  this.createTag(index);
               }
            }
            else if(this.giftInfo.giftConditionArr[0].conditionIndex == 2)
            {
               if((_loc6_ = statusArr[13 + (btnBigIndex - 1)] as PlayerCurInfo).statusValue == 1)
               {
                  this._smallBtn.enable = true;
                  this._smallBtn.addEventListener("click",this.getRewardBtnClick);
               }
            }
         }
         else if(this.giftInfo.giftConditionArr[0].conditionIndex == 1)
         {
            this.createTag(index);
            ++btnIndex;
         }
         else
         {
            this.createBigBtn(btnBigIndex,false);
            ++btnBigIndex;
            this._smallBtn.enable = false;
            addChild(this._smallBtn);
         }
      }
      
      private function createBigBtn(btnBigIndex:int, flag:Boolean = true) : void
      {
         if(flag)
         {
            if(this._day != this.dayArray[0])
            {
               this._smallBtn = ComponentFactory.Instance.creat("signActivityItem.getBtnBig2");
            }
            else
            {
               this._smallBtn = ComponentFactory.Instance.creat("signActivityItem.getBtnBig");
            }
         }
         else if(this._day != this.dayArray[0])
         {
            this._smallBtn = ComponentFactory.Instance.creat("signActivityItem.getBtnBig3");
         }
         else
         {
            this._smallBtn = ComponentFactory.Instance.creat("signActivityItem.getBtnBig4");
         }
         PositionUtils.setPos(this._smallBtn,this._day == 14 ? "signActivityItem.getBtnBig.14" : "signActivityItem.getBtnBig." + this._day + "." + btnBigIndex);
      }
      
      private function createTag(index:int) : void
      {
         if(this._smallBtn)
         {
            ObjectUtils.disposeObject(this._smallBtn);
            this._smallBtn = null;
         }
         this._tag = ComponentFactory.Instance.creatBitmap("asset.signactivity.tag");
         PositionUtils.setPos(this._tag,"asset.signactivity.tag.pos." + this._day + "." + (index + 1));
         addChild(this._tag);
      }
      
      private function clearBtn() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._smallBtn);
         this._smallBtn = null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._desText)
         {
            ObjectUtils.disposeObject(this._desText);
            this._desText = null;
         }
         ObjectUtils.disposeAllChildren(this);
         ObjectUtils.disposeObject(this._smallBtn);
         this._smallBtn = null;
      }
   }
}
