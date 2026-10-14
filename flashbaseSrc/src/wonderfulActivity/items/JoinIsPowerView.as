package wonderfulActivity.items
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
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
   
   public class JoinIsPowerView extends Sprite implements IRightView
   {
       
      
      private var _back:Bitmap;
      
      private var _activityTimeTxt:FilterFrameText;
      
      private var _contentTxt:FilterFrameText;
      
      private var _getButton:SimpleBitmapButton;
      
      private var _activityInfo:GmActivityInfo;
      
      private var _giftInfoDic:Dictionary;
      
      private var _statusArr:Array;
      
      private var _giftCondition:int;
      
      private var _hbox:HBox;
      
      private var _giftNeedMinId:String;
      
      public function JoinIsPowerView()
      {
         super();
      }
      
      public function init() : void
      {
         this.initView();
         this.initData();
         this.initViewWithData();
      }
      
      public function setState(param1:int, param2:int) : void
      {
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      private function initView() : void
      {
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.tuanjie.back");
         addChild(this._back);
         this._activityTimeTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.activetimeTxt");
         addChild(this._activityTimeTxt);
         PositionUtils.setPos(this._activityTimeTxt,"wonderful.joinispower.activetime.pos");
         this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.joinIsPowerContentTxt");
         addChild(this._contentTxt);
         this._getButton = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityState.GetButton");
         addChild(this._getButton);
         PositionUtils.setPos(this._getButton,"wonderful.getButton.pos");
         this._getButton.enable = false;
         this._hbox = ComponentFactory.Instance.creatComponentByStylename("wonderful.joinIsPower.Hbox");
         addChild(this._hbox);
      }
      
      private function initData() : void
      {
         var _loc1_:GmActivityInfo = null;
         var _loc2_:int = 0;
         for each(_loc1_ in WonderfulActivityManager.Instance.activityData)
         {
            if(_loc1_.activityType == WonderfulActivityTypeData.CONSORTION_ACTIVITY && _loc1_.activityChildType == WonderfulActivityTypeData.TUANJIE_POWER)
            {
               this._activityInfo = _loc1_;
               _loc2_ = 0;
               while(_loc2_ <= this._activityInfo.giftbagArray.length - 1)
               {
                  if(this._activityInfo.giftbagArray[_loc2_].rewardMark != 100 && (this._giftCondition == 0 || this._giftCondition > this._activityInfo.giftbagArray[_loc2_].giftConditionArr[0].conditionValue))
                  {
                     this._giftCondition = this._activityInfo.giftbagArray[_loc2_].giftConditionArr[0].conditionValue;
                     this._giftNeedMinId = this._activityInfo.giftbagArray[_loc2_].giftbagId;
                  }
                  _loc2_++;
               }
               if(Boolean(WonderfulActivityManager.Instance.activityInitData[_loc1_.activityId]))
               {
                  this._giftInfoDic = WonderfulActivityManager.Instance.activityInitData[_loc1_.activityId]["giftInfoDic"];
                  this._statusArr = WonderfulActivityManager.Instance.activityInitData[_loc1_.activityId]["statusArr"];
               }
            }
         }
      }
      
      private function initViewWithData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:BagCell = null;
         if(!this._activityInfo)
         {
            return;
         }
         var _loc3_:Array = [this._activityInfo.beginTime.split(" ")[0],this._activityInfo.endTime.split(" ")[0]];
         this._activityTimeTxt.text = _loc3_[0] + "-" + _loc3_[1];
         this._contentTxt.text = this._activityInfo.desc;
         this.changeBtnState();
         var _loc4_:int = 0;
         while(_loc4_ < this._activityInfo.giftbagArray.length)
         {
            if(this._activityInfo.giftbagArray[_loc4_].rewardMark != 100)
            {
               _loc1_ = 0;
               while(_loc1_ < this._activityInfo.giftbagArray[_loc4_].giftRewardArr.length)
               {
                  _loc2_ = this.createBagCell(0,this._activityInfo.giftbagArray[_loc4_].giftRewardArr[_loc1_]);
                  this._hbox.addChild(_loc2_);
                  _loc1_++;
               }
            }
            _loc4_++;
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
      
      public function refresh() : void
      {
         if(Boolean(WonderfulActivityManager.Instance.activityInitData[this._activityInfo.activityId]))
         {
            this._giftInfoDic = WonderfulActivityManager.Instance.activityInitData[this._activityInfo.activityId]["giftInfoDic"];
            this._statusArr = WonderfulActivityManager.Instance.activityInitData[this._activityInfo.activityId]["statusArr"];
         }
         this.changeBtnState();
      }
      
      private function changeBtnState() : void
      {
         if(Boolean(this._giftInfoDic[this._giftNeedMinId]) && this._statusArr[0].statusValue - this._giftInfoDic[this._giftNeedMinId].times * this._giftCondition >= this._giftCondition)
         {
            this._getButton.enable = true;
            this._getButton.addEventListener(MouseEvent.CLICK,this.__getAwardHandler);
         }
         else
         {
            this._getButton.enable = false;
         }
      }
      
      protected function __getAwardHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
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
      
      public function setData(param1:* = null) : void
      {
      }
      
      public function dispose() : void
      {
         this._getButton.removeEventListener(MouseEvent.CLICK,this.__getAwardHandler);
         if(Boolean(this._back))
         {
            ObjectUtils.disposeObject(this._back);
            this._back = null;
         }
         if(Boolean(this._activityTimeTxt))
         {
            ObjectUtils.disposeObject(this._activityTimeTxt);
            this._activityTimeTxt = null;
         }
         if(Boolean(this._contentTxt))
         {
            ObjectUtils.disposeObject(this._contentTxt);
            this._contentTxt = null;
         }
         if(Boolean(this._getButton))
         {
            ObjectUtils.disposeObject(this._getButton);
            this._getButton = null;
         }
         if(Boolean(this._hbox))
         {
            ObjectUtils.disposeObject(this._hbox);
            this._hbox = null;
         }
         if(Boolean(parent))
         {
            ObjectUtils.disposeObject(this);
         }
      }
   }
}
