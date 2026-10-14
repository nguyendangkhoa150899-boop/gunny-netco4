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
   
   public class WholePeopleVipActItem extends CarnivalActivityItem
   {
       
      
      private var _selfGrade:int = -1;
      
      private var _personNum:int = -1;
      
      private var _vipGd:int;
      
      private var _addedNum:int = -1;
      
      private var _addedVipGd:int;
      
      private var _btnTxt:FilterFrameText;
      
      private var _tipsBtn:Bitmap;
      
      private var _tipStr:String = "";
      
      private var _tipSp:carnivalActivity.view.WholePeopleTipSp;
      
      private var _awardCount:int;
      
      private var _getCount:int = -1;
      
      public function WholePeopleVipActItem(param1:int, param2:GiftBagInfo, param3:int)
      {
         super(param1,param2,param3);
      }
      
      override protected function initItem() : void
      {
         _awardCountTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.countTxt");
         addChild(_awardCountTxt);
         var _loc1_:int = 0;
         while(_loc1_ < _info.giftConditionArr.length)
         {
            if(_info.giftConditionArr[_loc1_].conditionIndex == 0)
            {
               this._selfGrade = _info.giftConditionArr[_loc1_].conditionValue;
            }
            else if(_info.giftConditionArr[_loc1_].conditionIndex == 1)
            {
               this._vipGd = _info.giftConditionArr[_loc1_].conditionValue;
               this._personNum = _info.giftConditionArr[_loc1_].remain1;
            }
            else if(_info.giftConditionArr[_loc1_].conditionIndex == 2)
            {
               this._addedVipGd = _info.giftConditionArr[_loc1_].conditionValue;
               this._addedNum = _info.giftConditionArr[_loc1_].remain1;
            }
            else if(_info.giftConditionArr[_loc1_].conditionIndex == 3)
            {
               this._getCount = _info.giftConditionArr[_loc1_].conditionValue;
            }
            _loc1_++;
         }
         var _loc2_:String = "";
         if(this._addedNum != -1)
         {
            _loc2_ = LanguageMgr.GetTranslation("wholePeople.vip.descTxt3",this._addedVipGd,this._addedNum);
            if(this._selfGrade != -1)
            {
               this._tipStr = LanguageMgr.GetTranslation("wholePeople.vip.tipTxt",this._selfGrade);
            }
         }
         else if(this._personNum != -1)
         {
            _loc2_ = LanguageMgr.GetTranslation("wholePeople.vip.descTxt2",this._vipGd,this._personNum);
            if(this._selfGrade != -1)
            {
               this._tipStr = LanguageMgr.GetTranslation("wholePeople.vip.tipTxt",this._selfGrade);
            }
         }
         else
         {
            _loc2_ = LanguageMgr.GetTranslation("wholePeople.vip.descTxt1",this._selfGrade);
         }
         _descTxt.text = _loc2_;
      }
      
      override public function updateView() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:PlayerCurInfo = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         _giftCurInfo = WonderfulActivityManager.Instance.activityInitData[_info.activityId].giftInfoDic[_info.giftbagId];
         _statusArr = WonderfulActivityManager.Instance.activityInitData[_info.activityId].statusArr;
         for each(_loc4_ in _statusArr)
         {
            if(_loc4_.statusID == 0)
            {
               _loc3_ = _loc4_.statusValue;
            }
            else if(_loc4_.statusID == this._vipGd)
            {
               _loc2_ = _loc4_.statusValue;
            }
            else if(_loc4_.statusID == this._addedVipGd)
            {
               _loc1_ = _loc4_.statusValue;
            }
         }
         _loc5_ = this._addedNum != -1 ? Boolean(int(_loc1_ / this._addedNum) > _giftCurInfo.times) : Boolean(true);
         var _loc7_:Boolean = this._personNum != -1 ? Boolean(_loc2_ >= this._personNum) : Boolean(true);
         var _loc8_:Boolean = this._selfGrade != -1 ? Boolean(_loc3_ >= this._selfGrade) : Boolean(true);
         var _loc9_:Boolean = this._getCount == 0 ? Boolean(true) : Boolean(_giftCurInfo.times < this._getCount);
         _loc6_ = CarnivalActivityManager.instance.canGetAward() && _loc5_ && _loc7_ && _loc8_ && _loc9_;
         if(this._addedNum != -1)
         {
            ObjectUtils.disposeObject(_getBtn);
            _getBtn = null;
            if(_loc6_ && int(_loc1_ / this._addedNum) - _giftCurInfo.times >= 1)
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
               this._btnTxt.text = "(" + (int(_loc1_ / this._addedNum) - _giftCurInfo.times) + ")";
               this._awardCount = int(_loc1_ / this._addedNum) - _giftCurInfo.times;
            }
            else
            {
               _getBtn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.bigGetBtn");
               addChild(_getBtn);
            }
            _getBtn.enable = _loc6_ && int(_loc1_ / this._addedNum) - _giftCurInfo.times >= 1;
            _getBtn.addEventListener(MouseEvent.CLICK,this.__getAwardHandler);
            PositionUtils.setPos(_getBtn,"carnivalAct.getButtonPos");
            _awardCountTxt.text = "" + _loc1_;
         }
         else if(this._personNum != -1)
         {
            _awardCountTxt.text = _loc2_ + "/" + this._personNum;
            _alreadyGetBtn.visible = _giftCurInfo.times > 0;
            _getBtn.enable = _loc6_ && _giftCurInfo.times == 0;
            _getBtn.visible = !_alreadyGetBtn.visible;
         }
         else
         {
            _descTxt.y += 9;
            _alreadyGetBtn.visible = _giftCurInfo.times > 0;
            _getBtn.enable = _loc6_ && _giftCurInfo.times == 0;
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
         if(this._addedNum != -1)
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
