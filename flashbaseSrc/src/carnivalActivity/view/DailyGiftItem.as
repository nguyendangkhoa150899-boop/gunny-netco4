package carnivalActivity.view
{
   import carnivalActivity.CarnivalActivityManager;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.goods.QualityType;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.PlayerCurInfo;
   
   public class DailyGiftItem extends CarnivalActivityItem
   {
       
      
      private var _count:int;
      
      private var _temId:int;
      
      private var _getGoodsType:int;
      
      private var _beadGrade:int;
      
      private var _magicStoneQuality:int;
      
      private var _actType:int;
      
      public function DailyGiftItem(param1:int, param2:GiftBagInfo, param3:int)
      {
         super(param1,param2,param3);
      }
      
      override protected function initItem() : void
      {
         var _loc1_:int = 0;
         _awardCountTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.countTxt");
         addChild(_awardCountTxt);
         var _loc2_:int = 0;
         while(_loc2_ < _info.giftConditionArr.length)
         {
            if(_info.giftConditionArr[_loc2_].conditionIndex == 0)
            {
               this._actType = 1;
            }
            else if(_info.giftConditionArr[_loc2_].conditionIndex == 1)
            {
               this._actType = 2;
               this._count = _info.giftConditionArr[_loc2_].remain1;
               this._getGoodsType = int(_info.giftConditionArr[_loc2_].remain2);
               if(this._getGoodsType == 2)
               {
                  this._beadGrade = _info.giftConditionArr[_loc2_].conditionValue;
               }
               else
               {
                  this._magicStoneQuality = _info.giftConditionArr[_loc2_].conditionValue;
               }
            }
            else if(_info.giftConditionArr[_loc2_].conditionIndex == 2)
            {
               this._actType = 3;
            }
            else if(_info.giftConditionArr[_loc2_].conditionIndex != 3)
            {
               if(_info.giftConditionArr[_loc2_].conditionIndex > 50 && _info.giftConditionArr[_loc2_].conditionIndex < 100)
               {
                  this._temId = _info.giftConditionArr[_loc2_].conditionValue;
                  this._count = _info.giftConditionArr[_loc2_].remain1;
               }
            }
            _loc2_++;
         }
         _descTxt.height *= 2;
         if(this._actType == 1)
         {
            _descTxt.y -= 8;
            _descTxt.text = LanguageMgr.GetTranslation("dailyGift.useType.descTxt",this._count,ItemManager.Instance.getTemplateById(this._temId).Name);
         }
         else if(this._actType == 2)
         {
            if(this._getGoodsType == 1)
            {
               _descTxt.text = LanguageMgr.GetTranslation("dailyGift.getType.descTxt" + this._getGoodsType,this._count);
            }
            else if(this._getGoodsType == 2)
            {
               _descTxt.text = LanguageMgr.GetTranslation("dailyGift.getType.descTxt" + this._getGoodsType,this._count,this._beadGrade);
            }
            else
            {
               _loc1_ = this._magicStoneQuality / 100;
               _descTxt.text = LanguageMgr.GetTranslation("dailyGift.getType.descTxt" + this._getGoodsType,this._count,QualityType.QUALITY_STRING[_loc1_]);
            }
         }
         else
         {
            _descTxt.y -= 8;
            _awardCountTxt.y += 7;
            _descTxt.text = LanguageMgr.GetTranslation("dailyGift.getType.plantTxt",this._count,ItemManager.Instance.getTemplateById(this._temId).Name);
         }
      }
      
      override public function updateView() : void
      {
         var _loc1_:PlayerCurInfo = null;
         var _loc2_:PlayerCurInfo = null;
         var _loc3_:PlayerCurInfo = null;
         _giftCurInfo = WonderfulActivityManager.Instance.activityInitData[_info.activityId].giftInfoDic[_info.giftbagId];
         _statusArr = WonderfulActivityManager.Instance.activityInitData[_info.activityId].statusArr;
         for each(_loc3_ in _statusArr)
         {
            if(this._actType == 1 || this._actType == 3)
            {
               if(_loc3_.statusID == this._temId)
               {
                  _getBtn.enable = CarnivalActivityManager.instance.canGetAward() && _giftCurInfo.times == 0 && _loc3_.statusValue >= this._count;
                  _awardCountTxt.text = _loc3_.statusValue + "/" + this._count;
               }
            }
            else if(this._getGoodsType == 3)
            {
               if(_loc3_.statusID == this._magicStoneQuality)
               {
                  _loc1_ = _loc3_;
               }
            }
            else if(this._getGoodsType == 2)
            {
               if(_loc3_.statusID == this._beadGrade)
               {
                  _loc2_ = _loc3_;
               }
            }
            else
            {
               _getBtn.enable = CarnivalActivityManager.instance.canGetAward() && _giftCurInfo.times == 0 && _loc3_.statusValue >= this._count;
               _awardCountTxt.text = _loc3_.statusValue + "/" + this._count;
            }
         }
         if(this._actType == 2)
         {
            if(this._getGoodsType == 3)
            {
               _getBtn.enable = CarnivalActivityManager.instance.canGetAward() && Boolean(_loc1_) ? _giftCurInfo.times == 0 && _loc1_.statusValue >= this._count : Boolean(false);
               _awardCountTxt.text = (Boolean(_loc1_) ? _loc1_.statusValue : 0) + "/" + this._count;
            }
            else if(this._getGoodsType == 2)
            {
               _getBtn.enable = CarnivalActivityManager.instance.canGetAward() && Boolean(_loc2_) ? _giftCurInfo.times == 0 && _loc2_.statusValue >= this._count : Boolean(false);
               _awardCountTxt.text = (Boolean(_loc2_) ? _loc2_.statusValue : 0) + "/" + this._count;
            }
         }
         _alreadyGetBtn.visible = _giftCurInfo.times > 0;
         _getBtn.visible = !_alreadyGetBtn.visible;
      }
   }
}
