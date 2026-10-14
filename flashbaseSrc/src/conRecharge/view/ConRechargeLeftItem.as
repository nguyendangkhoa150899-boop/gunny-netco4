package conRecharge.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import conRecharge.ConRechargeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   
   public class ConRechargeLeftItem extends Sprite implements Disposeable
   {
       
      
      private var _vbox:VBox;
      
      private var _num1:Sprite;
      
      private var _num2:Sprite;
      
      private var _num3:Sprite;
      
      public function ConRechargeLeftItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("conRecharge.leftItem.vbox");
         addChild(this._vbox);
         this._num1 = ComponentFactory.Instance.creatNumberSprite(ConRechargeManager.instance.longGiftbagArray[0][0].giftConditionArr[0].remain1,"asset.conRecharge.yellow");
         addChild(this._num1);
         PositionUtils.setPos(this._num1,"asset.conRecharge.yellow1.pos");
         this._num2 = ComponentFactory.Instance.creatNumberSprite(ConRechargeManager.instance.longGiftbagArray[0][1].giftConditionArr[0].remain1,"asset.conRecharge.yellow");
         addChild(this._num2);
         PositionUtils.setPos(this._num2,"asset.conRecharge.yellow2.pos");
         this._num3 = ComponentFactory.Instance.creatNumberSprite(ConRechargeManager.instance.longGiftbagArray[0][2].giftConditionArr[0].remain1,"asset.conRecharge.yellow");
         addChild(this._num3);
         PositionUtils.setPos(this._num3,"asset.conRecharge.yellow3.pos");
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = new BoxItem(_loc1_);
            this._vbox.addChild(_loc2_);
            _loc1_++;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._vbox);
         this._vbox = null;
         ObjectUtils.disposeObject(this._num1);
         this._num1 = null;
         ObjectUtils.disposeObject(this._num2);
         this._num2 = null;
         ObjectUtils.disposeObject(this._num3);
         this._num3 = null;
      }
   }
}

import com.pickgliss.ui.ComponentFactory;
import com.pickgliss.ui.controls.container.HBox;
import com.pickgliss.ui.core.Component;
import com.pickgliss.ui.text.FilterFrameText;
import com.pickgliss.utils.ClassUtils;
import com.pickgliss.utils.ObjectUtils;
import conRecharge.ConRechargeManager;
import ddt.data.goods.ItemTemplateInfo;
import ddt.manager.ItemManager;
import ddt.manager.LanguageMgr;
import ddt.manager.SocketManager;
import ddt.manager.TimeManager;
import ddt.utils.PositionUtils;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import wonderfulActivity.WonderfulActivityManager;
import wonderfulActivity.data.SendGiftInfo;

class BoxItem extends Component
{
    
   
   private var _titleBg:Bitmap;
   
   private var _index:int;
   
   private var _finishDayTxt:FilterFrameText;
   
   private var _moneyTxt:FilterFrameText;
   
   private var _hBox:HBox;
   
   private var _cellArr:Array;
   
   private var _boxArr:Array;
   
   public function BoxItem(param1:int)
   {
      super();
      this._index = param1;
      this.initView();
   }
   
   private function initView() : void
   {
      var _loc1_:int = 0;
      var _loc2_:* = null;
      var _loc3_:* = null;
      var _loc4_:* = null;
      var _loc5_:* = null;
      var _loc6_:* = null;
      var _loc7_:* = null;
      var _loc8_:int = 0;
      var _loc9_:* = null;
      var _loc10_:* = null;
      this._titleBg = ComponentFactory.Instance.creatBitmap("asset.conRecharge.leftTitle.bg");
      addChild(this._titleBg);
      this._finishDayTxt = ComponentFactory.Instance.creatComponentByStylename("conRecharge.finishDay.txt");
      addChild(this._finishDayTxt);
      this._finishDayTxt.text = LanguageMgr.GetTranslation("ddt.conRecharge.finishDay",this.rechargeDayNum(ConRechargeManager.instance.longGiftbagArray[this._index][0].giftConditionArr[0].conditionValue));
      this._moneyTxt = ComponentFactory.Instance.creatComponentByStylename("conRecharge.leftItem.money.txt");
      addChild(this._moneyTxt);
      this._moneyTxt.text = LanguageMgr.GetTranslation("ddt.conRecharge.moneyTxt",ConRechargeManager.instance.longGiftbagArray[this._index][0].giftConditionArr[0].conditionValue);
      this._hBox = ComponentFactory.Instance.creatComponentByStylename("conRecharge.leftItem.hbox");
      addChild(this._hBox);
      this._cellArr = [];
      this._boxArr = [];
      var _loc11_:int = 0;
      _loc1_ = 0;
      while(_loc1_ < ConRechargeManager.instance.longGiftbagArray[this._index].length)
      {
         _loc2_ = ConRechargeManager.instance.longGiftbagArray[this._index][_loc1_];
         _loc3_ = new Sprite();
         _loc4_ = ComponentFactory.Instance.creatBitmap("asset.conRecharge.leftItem.bg");
         _loc3_.addChild(_loc4_);
         _loc5_ = _loc2_.giftRewardArr[0].property.split(",");
         _loc6_ = ComponentFactory.Instance.creatComponentByStylename("conRecharge.prize.btn");
         _loc6_.id = _loc1_;
         _loc7_ = "";
         _loc8_ = 0;
         while(_loc8_ < _loc2_.giftRewardArr.length)
         {
            _loc9_ = ItemManager.Instance.getTemplateById(_loc2_.giftRewardArr[_loc8_].templateId) as ItemTemplateInfo;
            _loc7_ += _loc9_.beadName;
            if(_loc2_.giftRewardArr[_loc8_].validDate > 0)
            {
               _loc7_ += "(" + LanguageMgr.GetTranslation("ddt.conRecharge.leftDay",_loc2_.giftRewardArr[_loc8_].validDate) + ")";
            }
            _loc7_ += " x " + String(_loc2_.giftRewardArr[_loc8_].count) + "\n";
            _loc8_++;
         }
         _loc6_.tipData = _loc7_;
         _loc3_.addChild(_loc6_);
         this._cellArr.push(_loc6_);
         _loc10_ = ClassUtils.CreatInstance("asset.conRecharge.box");
         if(WonderfulActivityManager.Instance.getActivityInitDataById(ConRechargeManager.instance.actId).giftInfoDic[_loc2_.giftbagId].times != 0)
         {
            _loc10_.gotoAndStop(1);
            _loc6_.enable = false;
            _loc6_.mouseEnabled = true;
         }
         else if(this.judgeRechargeDay(_loc2_.giftConditionArr[0].remain1,_loc2_.giftConditionArr[0].conditionValue))
         {
            _loc10_.gotoAndStop(2);
            _loc6_.addEventListener("click",this.clickHandler);
         }
         else
         {
            _loc10_.gotoAndStop(3);
            _loc6_.enable = false;
            _loc6_.mouseEnabled = true;
         }
         PositionUtils.setPos(_loc10_,"asset.conRecharge.box.pos");
         this._boxArr.push(_loc10_);
         _loc3_.addChild(_loc10_);
         this._hBox.addChild(_loc3_);
         _loc11_++;
         _loc1_++;
      }
   }
   
   private function rechargeDayNum(param1:int) : int
   {
      var _loc2_:int = 0;
      var _loc3_:* = 0;
      var _loc4_:int = 0;
      var _loc5_:* = 0;
      var _loc6_:* = null;
      var _loc7_:Array = [];
      _loc2_ = 0;
      while(_loc2_ < WonderfulActivityManager.Instance.getActivityInitDataById(ConRechargeManager.instance.actId).statusArr.length)
      {
         if(WonderfulActivityManager.Instance.getActivityInitDataById(ConRechargeManager.instance.actId).statusArr[_loc2_].statusID != 0)
         {
            _loc7_.push(WonderfulActivityManager.Instance.getActivityInitDataById(ConRechargeManager.instance.actId).statusArr[_loc2_]);
         }
         _loc2_++;
      }
      _loc7_.sortOn("statusID",16);
      var _loc8_:Date = TimeManager.Instance.Now();
      var _loc9_:int = 10000 * _loc8_.getFullYear() + 100 * (_loc8_.getMonth() + 1) + _loc8_.getDate();
      _loc4_ = 0;
      while(_loc4_ < _loc7_.length)
      {
         if(_loc7_[_loc4_].statusID == _loc9_)
         {
            if(_loc4_ == 0)
            {
               if(_loc7_[_loc4_].statusValue == 0)
               {
                  return 0;
               }
               if(_loc7_[_loc4_].statusValue >= param1)
               {
                  return 1;
               }
               return 0;
            }
            if(_loc7_[_loc4_].statusValue >= param1)
            {
               _loc3_ = _loc4_;
               break;
            }
            _loc3_ = int(_loc4_ - 1);
            break;
         }
         _loc4_++;
      }
      var _loc10_:int = 0;
      _loc5_ = _loc3_;
      while(_loc5_ >= 0)
      {
         _loc6_ = _loc7_[_loc5_];
         if(_loc6_.statusValue < param1)
         {
            return _loc10_;
         }
         _loc10_++;
         _loc5_--;
      }
      return _loc10_;
   }
   
   private function judgeRechargeDay(param1:int, param2:int) : Boolean
   {
      var _loc3_:int = 0;
      var _loc4_:* = null;
      var _loc5_:int = 0;
      var _loc6_:Array = [];
      var _loc7_:Array = WonderfulActivityManager.Instance.getActivityInitDataById(ConRechargeManager.instance.actId).statusArr;
      _loc7_.sortOn("statusID",16);
      _loc3_ = 0;
      while(_loc3_ < _loc7_.length)
      {
         _loc4_ = _loc7_[_loc3_];
         _loc4_.my = _loc3_;
         if(_loc4_.statusID != 0)
         {
            if(_loc4_.statusValue >= param2)
            {
               _loc6_.push(_loc4_);
            }
         }
         _loc3_++;
      }
      if(_loc6_.length < param1)
      {
         return false;
      }
      _loc5_ = param1 - 1;
      while(_loc5_ < _loc6_.length)
      {
         if(_loc6_[_loc5_].my - _loc6_[_loc5_ - param1 + 1].my == param1 - 1)
         {
            return true;
         }
         _loc5_++;
      }
      return false;
   }
   
   private function clickHandler(param1:MouseEvent) : void
   {
      var _loc2_:SendGiftInfo = new SendGiftInfo();
      _loc2_.activityId = ConRechargeManager.instance.actId;
      _loc2_.giftIdArr = [ConRechargeManager.instance.longGiftbagArray[this._index][param1.currentTarget.id].giftbagId];
      var _loc3_:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
      _loc3_.push(_loc2_);
      SocketManager.Instance.out.sendWonderfulActivityGetReward(_loc3_);
      param1.currentTarget.enable = false;
      param1.currentTarget.mouseEnabled = true;
      this._boxArr[param1.currentTarget.id].gotoAndStop(0);
   }
   
   override public function dispose() : void
   {
      var _loc1_:int = 0;
      super.dispose();
      _loc1_ = 0;
      while(_loc1_ < this._cellArr.length)
      {
         this._cellArr[_loc1_].removeEventListener("click",this.clickHandler);
         _loc1_++;
      }
      ObjectUtils.disposeObject(this._titleBg);
      this._titleBg = null;
      ObjectUtils.disposeObject(this._finishDayTxt);
      this._finishDayTxt = null;
      ObjectUtils.disposeObject(this._moneyTxt);
      this._moneyTxt = null;
      ObjectUtils.disposeObject(this._hBox);
      this._hBox = null;
   }
}
