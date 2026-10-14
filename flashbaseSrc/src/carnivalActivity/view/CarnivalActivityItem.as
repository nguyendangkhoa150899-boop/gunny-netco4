package carnivalActivity.view
{
   import bagAndInfo.cell.BagCell;
   import carnivalActivity.CarnivalActivityManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftCurInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.data.PlayerCurInfo;
   import wonderfulActivity.data.SendGiftInfo;
   
   public class CarnivalActivityItem extends Sprite implements Disposeable
   {
       
      
      protected var _bg:Bitmap;
      
      protected var _getBtn:SimpleBitmapButton;
      
      protected var _giftCurInfo:GiftCurInfo;
      
      protected var _sumCount:int;
      
      protected var _allGiftAlreadyGetCount:int;
      
      protected var _playerAlreadyGetCount:int;
      
      protected var _condtion:int;
      
      protected var _currentCondtion:int;
      
      protected var _goodContent:Sprite;
      
      protected var _descTxt:FilterFrameText;
      
      protected var _awardCountTxt:FilterFrameText;
      
      protected var _type:int;
      
      protected var _info:GiftBagInfo;
      
      protected var _index:int;
      
      protected var _alreadyGetBtn:SimpleBitmapButton;
      
      protected var _statusArr:Array;
      
      public function CarnivalActivityItem(param1:int, param2:GiftBagInfo, param3:int)
      {
         super();
         this._type = param1;
         this._info = param2;
         this._index = param3;
         this.initData();
         this.initView();
         this.initItem();
         this.initEvent();
      }
      
      protected function initData() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._info.giftConditionArr.length)
         {
            if(this._info.giftConditionArr[_loc1_].conditionIndex == 0)
            {
               this._condtion = this._info.giftConditionArr[_loc1_].conditionValue;
            }
            else if(this._info.giftConditionArr[_loc1_].conditionIndex == 100)
            {
               this._sumCount = this._info.giftConditionArr[_loc1_].conditionValue;
            }
            _loc1_++;
         }
      }
      
      protected function initView() : void
      {
         var _loc1_:BagCell = null;
         var _loc2_:Bitmap = null;
         _loc1_ = null;
         _loc2_ = null;
         this._bg = ComponentFactory.Instance.creat("carnicalAct.listItem" + this._index);
         addChild(this._bg);
         this._descTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.condtionTxt");
         addChild(this._descTxt);
         this._getBtn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.bigGetBtn");
         addChild(this._getBtn);
         this._getBtn.enable = false;
         PositionUtils.setPos(this._getBtn,"carnivalAct.getButtonPos");
         this._alreadyGetBtn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.overBtn");
         addChild(this._alreadyGetBtn);
         this._alreadyGetBtn.visible = false;
         this._alreadyGetBtn.enable = false;
         PositionUtils.setPos(this._alreadyGetBtn,"carnivalAct.getButtonPos");
         this._goodContent = new Sprite();
         addChild(this._goodContent);
         var _loc3_:int = 0;
         while(_loc3_ < this._info.giftRewardArr.length)
         {
            _loc1_ = this.createBagCell(0,this._info.giftRewardArr[_loc3_]);
            _loc2_ = ComponentFactory.Instance.creat("wonderfulactivity.goods.back");
            _loc2_.x = (_loc2_.width + 5) * _loc3_;
            _loc1_.x = _loc2_.width / 2 - _loc1_.width / 2 + _loc2_.x + 2;
            _loc1_.y = _loc2_.height / 2 - _loc1_.height / 2 + 1;
            this._goodContent.addChild(_loc2_);
            this._goodContent.addChild(_loc1_);
            _loc3_++;
         }
         this._goodContent.x = 142;
         this._goodContent.y = 7;
      }
      
      protected function initItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this._sumCount != 0)
         {
            this._awardCountTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.countTxt");
            addChild(this._awardCountTxt);
         }
         else
         {
            this._descTxt.y += 9;
         }
         if(CarnivalActivityManager.instance.currentChildType == 10)
         {
            _loc1_ = int(this._condtion / 10) + 1;
            _loc2_ = this._condtion % 10;
            this._descTxt.text = LanguageMgr.GetTranslation("carnival.descTxt" + CarnivalActivityManager.instance.currentChildType,_loc1_,_loc2_);
         }
         else if(CarnivalActivityManager.instance.currentChildType != 4)
         {
            this._descTxt.text = LanguageMgr.GetTranslation("carnival.descTxt" + CarnivalActivityManager.instance.currentChildType,this._condtion);
         }
      }
      
      protected function createBagCell(param1:int, param2:GiftRewardInfo) : BagCell
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
      
      public function updateView() : void
      {
         var _loc1_:PlayerCurInfo = null;
         this._giftCurInfo = WonderfulActivityManager.Instance.activityInitData[this._info.activityId].giftInfoDic[this._info.giftbagId];
         this._statusArr = WonderfulActivityManager.Instance.activityInitData[this._info.activityId].statusArr;
         this._playerAlreadyGetCount = this._giftCurInfo.times;
         this._allGiftAlreadyGetCount = this._giftCurInfo.allGiftGetTimes;
         this._currentCondtion = this._statusArr[0].statusValue;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(CarnivalActivityManager.instance.currentChildType == 10)
         {
            for each(_loc1_ in this._statusArr)
            {
               if(_loc1_.statusID == 0)
               {
                  _loc2_ = _loc1_.statusValue;
               }
               else if(_loc1_.statusID == 1)
               {
                  _loc3_ = _loc1_.statusValue;
               }
            }
            this._getBtn.enable = CarnivalActivityManager.instance.canGetAward() && this._playerAlreadyGetCount == 0 && this._condtion > _loc2_ && this._condtion <= _loc3_ && (this._sumCount == 0 || this._sumCount - this._allGiftAlreadyGetCount > 0);
         }
         else
         {
            this._getBtn.enable = CarnivalActivityManager.instance.canGetAward() && this._playerAlreadyGetCount == 0 && this._currentCondtion >= this._condtion && (this._sumCount == 0 || this._sumCount - this._allGiftAlreadyGetCount > 0);
         }
         if(Boolean(this._awardCountTxt))
         {
            this._awardCountTxt.text = LanguageMgr.GetTranslation("carnival.awardCountTxt") + (this._sumCount - this._allGiftAlreadyGetCount);
         }
         this._alreadyGetBtn.visible = this._playerAlreadyGetCount > 0;
         this._getBtn.visible = !this._alreadyGetBtn.visible;
      }
      
      protected function initEvent() : void
      {
         this._getBtn.addEventListener(MouseEvent.CLICK,this.__getAwardHandler);
      }
      
      protected function __getAwardHandler(param1:MouseEvent) : void
      {
         if(getTimer() - CarnivalActivityManager.instance.lastClickTime < 2000)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("carnival.clickTip"));
            return;
         }
         CarnivalActivityManager.instance.lastClickTime = getTimer();
         SoundManager.instance.playButtonSound();
         var _loc2_:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         var _loc3_:SendGiftInfo = new SendGiftInfo();
         _loc3_.activityId = this._info.activityId;
         _loc3_.giftIdArr = [this._info.giftbagId];
         _loc3_.awardCount = 1 - this._playerAlreadyGetCount;
         _loc2_.push(_loc3_);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(_loc2_);
      }
      
      protected function removeEvent() : void
      {
         this._getBtn.removeEventListener(MouseEvent.CLICK,this.__getAwardHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         while(Boolean(this._goodContent.numChildren))
         {
            ObjectUtils.disposeObject(this._goodContent.getChildAt(0));
         }
         this._goodContent = null;
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         this._getBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
