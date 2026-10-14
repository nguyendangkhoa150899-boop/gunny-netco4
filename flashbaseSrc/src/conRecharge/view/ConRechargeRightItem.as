package conRecharge.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import conRecharge.ConRechargeManager;
   import flash.display.Sprite;
   
   public class ConRechargeRightItem extends Sprite implements Disposeable
   {
       
      
      private var _vbox:VBox;
      
      public function ConRechargeRightItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("conRecharge.rightItem.vbox");
         addChild(this._vbox);
         _loc1_ = 0;
         while(_loc1_ < ConRechargeManager.instance.dayGiftbagArray.length)
         {
            _loc2_ = new DayItem(ConRechargeManager.instance.dayGiftbagArray[_loc1_]);
            this._vbox.addChild(_loc2_);
            _loc1_++;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._vbox);
         this._vbox = null;
      }
   }
}

import bagAndInfo.cell.BagCell;
import com.pickgliss.ui.ComponentFactory;
import com.pickgliss.ui.controls.BaseButton;
import com.pickgliss.ui.controls.container.HBox;
import com.pickgliss.ui.core.Component;
import com.pickgliss.utils.ObjectUtils;
import conRecharge.ConRechargeManager;
import ddt.data.goods.InventoryItemInfo;
import ddt.data.goods.ItemTemplateInfo;
import ddt.manager.ItemManager;
import ddt.manager.SocketManager;
import ddt.utils.PositionUtils;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import wonderfulActivity.WonderfulActivityManager;
import wonderfulActivity.data.GiftBagInfo;
import wonderfulActivity.data.SendGiftInfo;

class DayItem extends Component
{
    
   
   private var _bg:Bitmap;
   
   private var _btn:BaseButton;
   
   private var _hbox:HBox;
   
   private var _info:GiftBagInfo;
   
   private var _statusArr:Array;
   
   private var _num:Sprite;
   
   public function DayItem(param1:GiftBagInfo)
   {
      var _loc2_:int = 0;
      var _loc3_:* = null;
      var _loc4_:* = null;
      var _loc5_:* = null;
      var _loc6_:* = null;
      var _loc7_:* = null;
      super();
      this._info = param1;
      this._bg = ComponentFactory.Instance.creatBitmap("asset.conRecharge.rightItem.bg");
      addChild(this._bg);
      this._statusArr = WonderfulActivityManager.Instance.getActivityInitDataById(ConRechargeManager.instance.actId).statusArr;
      this._statusArr.sortOn("statusID",16);
      if(WonderfulActivityManager.Instance.getActivityInitDataById(ConRechargeManager.instance.actId).giftInfoDic[param1.giftbagId].times != 0)
      {
         this._btn = ComponentFactory.Instance.creatComponentByStylename("conRecharge.havaReceived.btn");
         addChild(this._btn);
         this._btn.addEventListener("click",this.clickHandler);
         this._btn.enable = false;
      }
      else if(param1.giftConditionArr[0].conditionValue > this._statusArr[0].statusValue)
      {
         this._btn = ComponentFactory.Instance.creatComponentByStylename("conRecharge.canReceive.btn");
         addChild(this._btn);
         this._btn.addEventListener("click",this.clickHandler);
         this._btn.enable = false;
      }
      else
      {
         this._btn = ComponentFactory.Instance.creatComponentByStylename("conRecharge.canReceive.btn");
         addChild(this._btn);
         this._btn.addEventListener("click",this.clickHandler);
      }
      this._num = ComponentFactory.Instance.creatNumberSprite(param1.giftConditionArr[0].conditionValue,"asset.conRecharge.red");
      addChild(this._num);
      PositionUtils.setPos(this._num,"asset.conRecharge.red.pos");
      this._hbox = ComponentFactory.Instance.creatComponentByStylename("conRecharge.rightItem.hbox");
      addChild(this._hbox);
      _loc2_ = 0;
      while(_loc2_ < param1.giftRewardArr.length)
      {
         _loc3_ = param1.giftRewardArr[_loc2_].property.split(",");
         _loc4_ = ItemManager.Instance.getTemplateById(param1.giftRewardArr[_loc2_].templateId) as ItemTemplateInfo;
         _loc5_ = new InventoryItemInfo();
         ObjectUtils.copyProperties(_loc5_,_loc4_);
         _loc5_.StrengthenLevel = _loc3_[0];
         _loc5_.AttackCompose = _loc3_[1];
         _loc5_.DefendCompose = _loc3_[2];
         _loc5_.AgilityCompose = _loc3_[3];
         _loc5_.LuckCompose = _loc3_[4];
         _loc5_.MagicAttack = _loc3_[6];
         _loc5_.MagicDefence = _loc3_[7];
         _loc5_.ValidDate = param1.giftRewardArr[_loc2_].validDate;
         _loc5_.IsBinds = param1.giftRewardArr[_loc2_].isBind;
         _loc5_.Count = param1.giftRewardArr[_loc2_].count;
         _loc6_ = ComponentFactory.Instance.creatBitmap("asset.conRecharge.goodsBG");
         _loc7_ = new BagCell(0,_loc5_,false,_loc6_);
         this._hbox.addChild(_loc7_);
         _loc2_++;
      }
   }
   
   private function clickHandler(param1:MouseEvent) : void
   {
      var _loc2_:SendGiftInfo = new SendGiftInfo();
      _loc2_.activityId = ConRechargeManager.instance.actId;
      _loc2_.giftIdArr = [this._info.giftbagId];
      var _loc3_:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
      _loc3_.push(_loc2_);
      SocketManager.Instance.out.sendWonderfulActivityGetReward(_loc3_);
      ObjectUtils.disposeObject(this._btn);
      this._btn.removeEventListener("click",this.clickHandler);
      this._btn = ComponentFactory.Instance.creatComponentByStylename("conRecharge.havaReceived.btn");
      addChild(this._btn);
      this._btn.enable = false;
   }
   
   override public function dispose() : void
   {
      super.dispose();
      this._btn.removeEventListener("click",this.clickHandler);
      ObjectUtils.disposeObject(this._bg);
      this._bg = null;
      ObjectUtils.disposeObject(this._btn);
      this._btn = null;
      ObjectUtils.disposeObject(this._hbox);
      this._hbox = null;
      ObjectUtils.disposeObject(this._num);
      this._num = null;
   }
}
