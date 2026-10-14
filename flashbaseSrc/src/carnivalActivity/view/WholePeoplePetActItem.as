package carnivalActivity.view
{
   import carnivalActivity.CarnivalActivityManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.PlayerCurInfo;
   import wonderfulActivity.data.SendGiftInfo;
   
   public class WholePeoplePetActItem extends CarnivalActivityItem
   {
       
      
      private var _selfNeedPetNum:int = -1;
      
      private var _selfNeedPetStar:int;
      
      private var _personNeedPetNum:int = -1;
      
      private var _personNeedPetStar:int;
      
      private var _addedNeedPetNum:int = -1;
      
      private var _addedNeedPetStar:int;
      
      private var _getCount:int = -1;
      
      private var _addedIsSuperPet:Boolean;
      
      private var _personIsSuperPet:Boolean;
      
      private var _selfIsSuperPet:Boolean;
      
      private var _btnTxt:FilterFrameText;
      
      private var _tipsBtn:Bitmap;
      
      private var _tipStr:String = "";
      
      private var _tipSp:carnivalActivity.view.WholePeopleTipSp;
      
      private var _awardCount:int;
      
      public function WholePeoplePetActItem(param1:int, param2:GiftBagInfo, param3:int)
      {
         super(param1,param2,param3);
      }
      
      override protected function initItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _awardCountTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.countTxt");
         addChild(_awardCountTxt);
         var _loc3_:int = 0;
         while(_loc3_ < _info.giftConditionArr.length)
         {
            if(_info.giftConditionArr[_loc3_].conditionIndex == 4)
            {
               this._selfIsSuperPet = true;
            }
            else if(_info.giftConditionArr[_loc3_].conditionIndex == 5)
            {
               this._personIsSuperPet = true;
            }
            else if(_info.giftConditionArr[_loc3_].conditionIndex == 6)
            {
               this._addedIsSuperPet = true;
            }
            _loc3_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < _info.giftConditionArr.length)
         {
            if(_info.giftConditionArr[_loc4_].conditionIndex == (this._selfIsSuperPet ? 4 : 0))
            {
               this._selfNeedPetStar = _info.giftConditionArr[_loc4_].conditionValue;
               this._selfNeedPetNum = _info.giftConditionArr[_loc4_].remain1;
            }
            else if(_info.giftConditionArr[_loc4_].conditionIndex == (this._personIsSuperPet ? 5 : 1))
            {
               this._personNeedPetStar = _info.giftConditionArr[_loc4_].conditionValue;
               this._personNeedPetNum = _info.giftConditionArr[_loc4_].remain1;
            }
            else if(_info.giftConditionArr[_loc4_].conditionIndex == (this._addedIsSuperPet ? 6 : 2))
            {
               this._addedNeedPetStar = _info.giftConditionArr[_loc4_].conditionValue;
               this._addedNeedPetNum = _info.giftConditionArr[_loc4_].remain1;
            }
            else if(_info.giftConditionArr[_loc4_].conditionIndex == 3)
            {
               this._getCount = _info.giftConditionArr[_loc4_].conditionValue;
            }
            _loc4_++;
         }
         var _loc5_:String = "";
         if(this._addedNeedPetNum != -1)
         {
            _loc1_ = this._addedIsSuperPet ? int(6) : int(3);
            _loc2_ = this._selfIsSuperPet ? int(6) : int(3);
            _loc5_ = LanguageMgr.GetTranslation("wholePeople.pet.descTxt" + _loc1_,this._addedNeedPetNum,this._addedIsSuperPet ? this._addedNeedPetStar - 10 : this._addedNeedPetStar);
            if(this._selfNeedPetNum != -1)
            {
               this._tipStr = LanguageMgr.GetTranslation("wholePeople.pet.tipTxt" + _loc2_,this._selfNeedPetNum,this._selfIsSuperPet ? this._selfNeedPetStar - 10 : this._selfNeedPetStar);
            }
         }
         else if(this._personNeedPetNum != -1)
         {
            _loc1_ = this._personIsSuperPet ? int(5) : int(2);
            _loc2_ = this._selfIsSuperPet ? int(5) : int(2);
            _loc5_ = LanguageMgr.GetTranslation("wholePeople.pet.descTxt" + _loc1_,this._personNeedPetNum,this._personIsSuperPet ? this._personNeedPetStar - 10 : this._personNeedPetStar);
            if(this._selfNeedPetNum != -1)
            {
               this._tipStr = LanguageMgr.GetTranslation("wholePeople.pet.tipTxt" + _loc2_,this._selfNeedPetNum,this._selfIsSuperPet ? this._selfNeedPetStar - 10 : this._selfNeedPetStar);
            }
         }
         else
         {
            _loc1_ = this._selfIsSuperPet ? int(4) : int(1);
            _loc5_ = LanguageMgr.GetTranslation("wholePeople.pet.descTxt" + _loc1_,this._selfNeedPetNum,this._selfIsSuperPet ? this._selfNeedPetStar - 10 : this._selfNeedPetStar);
         }
         _descTxt.text = _loc5_;
      }
      
      override public function updateView() : void
      {
         var _loc1_:int = 0;
         var _loc9_:Boolean = false;
         _loc1_ = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:PlayerCurInfo = null;
         var _loc5_:Boolean = false;
         _giftCurInfo = WonderfulActivityManager.Instance.activityInitData[_info.activityId].giftInfoDic[_info.giftbagId];
         _statusArr = WonderfulActivityManager.Instance.activityInitData[_info.activityId].statusArr;
         for each(_loc4_ in _statusArr)
         {
            if(_loc4_.statusID >= this._selfNeedPetStar + (this._selfIsSuperPet ? 200 : 0) && _loc4_.statusID < 50 + (this._selfIsSuperPet ? 200 : 0))
            {
               _loc3_ += _loc4_.statusValue;
            }
            else if(_loc4_.statusID == this._personNeedPetStar + (this._personIsSuperPet ? 300 : 100))
            {
               _loc2_ = _loc4_.statusValue;
            }
            else if(_loc4_.statusID == this._addedNeedPetStar + (this._addedIsSuperPet ? 300 : 100))
            {
               _loc1_ = _loc4_.statusValue;
            }
         }
         _loc5_ = this._addedNeedPetNum != -1 ? Boolean(int(_loc1_ / this._addedNeedPetNum) > _giftCurInfo.times) : Boolean(true);
         var _loc6_:Boolean = this._personNeedPetNum != -1 ? Boolean(_loc2_ >= this._personNeedPetNum) : Boolean(true);
         var _loc7_:Boolean = this._selfNeedPetNum != -1 ? Boolean(_loc3_ >= this._selfNeedPetNum) : Boolean(true);
         var _loc8_:Boolean = this._getCount == 0 ? Boolean(true) : Boolean(_giftCurInfo.times < this._getCount);
         _loc9_ = CarnivalActivityManager.instance.canGetAward() && _loc5_ && _loc6_ && _loc7_ && _loc8_;
         if(this._addedNeedPetNum != -1)
         {
            ObjectUtils.disposeObject(_getBtn);
            _getBtn = null;
            if(_loc9_ && int(_loc1_ / this._addedNeedPetNum) - _giftCurInfo.times >= 1)
            {
               _getBtn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.smallGetBtn");
               this._btnTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.btnTxt");
               addChild(_getBtn);
               addChild(this._btnTxt);
               this._btnTxt.x = _getBtn.x + 49;
               this._btnTxt.y = _getBtn.y + 8;
               this._tipsBtn = ComponentFactory.Instance.creat("wonderfulactivity.can.repeat");
               this._tipsBtn.x = _getBtn.x + 45;
               this._tipsBtn.y = _getBtn.y - 16;
               addChild(this._tipsBtn);
               this._btnTxt.text = "(" + (int(_loc1_ / this._addedNeedPetNum) - _giftCurInfo.times) + ")";
               this._awardCount = int(_loc1_ / this._addedNeedPetNum) - _giftCurInfo.times;
            }
            else
            {
               _getBtn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.bigGetBtn");
               addChild(_getBtn);
            }
            _getBtn.enable = _loc9_ && int(_loc1_ / this._addedNeedPetNum) - _giftCurInfo.times >= 1;
            _getBtn.addEventListener(MouseEvent.CLICK,this.__getAwardHandler);
            PositionUtils.setPos(_getBtn,"carnivalAct.getButtonPos");
            _awardCountTxt.text = "" + _loc1_;
         }
         else if(this._personNeedPetNum != -1)
         {
            _awardCountTxt.text = _loc2_ + "/" + this._personNeedPetNum;
            _alreadyGetBtn.visible = _giftCurInfo.times > 0;
            _getBtn.enable = _loc9_ && _giftCurInfo.times == 0;
            _getBtn.visible = !_alreadyGetBtn.visible;
         }
         else
         {
            _awardCountTxt.text = _loc3_ + "/" + this._selfNeedPetNum;
            _alreadyGetBtn.visible = _giftCurInfo.times > 0;
            _getBtn.enable = _loc9_ && _giftCurInfo.times == 0;
            _getBtn.visible = !_alreadyGetBtn.visible;
         }
         if(this._tipStr != "")
         {
            if(!_getBtn.enable)
            {
               this._tipSp = new carnivalActivity.view.WholePeopleTipSp();
               addChild(this._tipSp);
               this._tipSp.graphics.beginFill(16777215,0);
               this._tipSp.graphics.drawRect(0,0,_getBtn.width,_getBtn.height);
               this._tipSp.graphics.endFill();
               this._tipSp.width = this._tipSp.displayWidth;
               this._tipSp.height = this._tipSp.displayHeight;
               PositionUtils.setPos(this._tipSp,"carnivalAct.getButtonPos");
               this._tipSp.tipStyle = "ddt.view.tips.OneLineTip";
               this._tipSp.tipDirctions = "0,5";
               this._tipSp.tipData = this._tipStr;
            }
            else
            {
               _getBtn.tipStyle = "ddt.view.tips.OneLineTip";
               _getBtn.tipDirctions = "0,5";
               _getBtn.tipData = this._tipStr;
            }
         }
      }
      
      override protected function __getAwardHandler(param1:MouseEvent) : void
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
         _loc3_.activityId = _info.activityId;
         _loc3_.giftIdArr = [_info.giftbagId];
         if(this._addedNeedPetNum != -1)
         {
            _loc3_.awardCount = this._awardCount;
         }
         else
         {
            _loc3_.awardCount = 1;
         }
         _loc2_.push(_loc3_);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(_loc2_);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._tipSp);
         this._tipSp = null;
         ObjectUtils.disposeObject(this._btnTxt);
         this._btnTxt = null;
         ObjectUtils.disposeObject(this._tipsBtn);
         this._tipsBtn = null;
         super.dispose();
      }
   }
}
