package carnivalActivity.view
{
   import carnivalActivity.CarnivalActivityManager;
   import ddt.manager.LanguageMgr;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.PlayerCurInfo;
   
   public class RookieItem extends CarnivalActivityItem
   {
       
      
      private var _fightPower:int = -1;
      
      private var _fightPowerRankOne:int = -1;
      
      private var _fightPowerRankTwo:int = -1;
      
      public function RookieItem(param1:int, param2:GiftBagInfo, param3:int)
      {
         super(param1,param2,param3);
      }
      
      override protected function initData() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < _info.giftConditionArr.length)
         {
            if(_info.giftConditionArr[_loc1_].conditionIndex == 0)
            {
               this._fightPower = _info.giftConditionArr[_loc1_].conditionValue;
            }
            else if(_info.giftConditionArr[_loc1_].conditionIndex == 1)
            {
               this._fightPowerRankOne = _info.giftConditionArr[_loc1_].conditionValue;
               this._fightPowerRankTwo = _info.giftConditionArr[_loc1_].remain1;
            }
            else if(_info.giftConditionArr[_loc1_].conditionIndex == 100)
            {
               _sumCount = _info.giftConditionArr[_loc1_].conditionValue;
            }
            _loc1_++;
         }
      }
      
      override public function updateView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:PlayerCurInfo = null;
         _giftCurInfo = WonderfulActivityManager.Instance.activityInitData[_info.activityId].giftInfoDic[_info.giftbagId];
         _statusArr = WonderfulActivityManager.Instance.activityInitData[_info.activityId].statusArr;
         for each(_loc3_ in _statusArr)
         {
            if(_loc3_.statusID == 0)
            {
               _loc1_ = _loc3_.statusValue;
            }
            else
            {
               _loc2_ = _loc3_.statusValue;
            }
         }
         if(this._fightPower != -1)
         {
            _descTxt.text = LanguageMgr.GetTranslation("carnival.rookie.descTxt3",this._fightPower);
            _getBtn.enable = CarnivalActivityManager.instance.canGetAward() && _giftCurInfo.times == 0 && _loc1_ >= this._fightPower;
         }
         else if(this._fightPowerRankOne == this._fightPowerRankTwo)
         {
            _descTxt.text = LanguageMgr.GetTranslation("carnival.rookie.descTxt1",this._fightPowerRankOne);
            _getBtn.enable = CarnivalActivityManager.instance.rookieRankCanGetAward() && _giftCurInfo.times == 0 && _loc2_ >= this._fightPowerRankOne;
         }
         else
         {
            _descTxt.text = LanguageMgr.GetTranslation("carnival.rookie.descTxt2",this._fightPowerRankOne,this._fightPowerRankTwo);
            _getBtn.enable = CarnivalActivityManager.instance.rookieRankCanGetAward() && _giftCurInfo.times == 0 && _loc2_ >= this._fightPowerRankOne && _loc2_ <= this._fightPowerRankTwo;
         }
         _allGiftAlreadyGetCount = _giftCurInfo.allGiftGetTimes;
         if(Boolean(_awardCountTxt))
         {
            _awardCountTxt.text = LanguageMgr.GetTranslation("carnival.awardCountTxt") + (_sumCount - _allGiftAlreadyGetCount);
         }
         _alreadyGetBtn.visible = _giftCurInfo.times > 0;
         _getBtn.visible = !_alreadyGetBtn.visible;
      }
   }
}
