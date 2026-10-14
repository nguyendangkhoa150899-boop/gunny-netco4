package wonderfulActivity
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftConditionInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.data.GmActivityInfo;
   
   public class WonderfulGMActAnalyer extends DataAnalyzer
   {
       
      
      private var _activityData:Dictionary;
      
      public function WonderfulGMActAnalyer(param1:Function)
      {
         super(param1);
         this._activityData = new Dictionary();
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:GmActivityInfo = null;
         var _loc5_:Array = null;
         var _loc6_:XML = null;
         var _loc7_:XMLList = null;
         var _loc8_:int = 0;
         var _loc9_:GiftBagInfo = null;
         var _loc10_:Vector.<GiftConditionInfo> = null;
         var _loc11_:Vector.<GiftRewardInfo> = null;
         var _loc12_:XMLList = null;
         var _loc13_:int = 0;
         var _loc14_:GiftConditionInfo = null;
         var _loc15_:XMLList = null;
         var _loc16_:int = 0;
         var _loc17_:GiftRewardInfo = null;
         var _loc18_:int = 0;
         var _loc19_:XML = new XML(param1);
         if(_loc19_.@value == "true")
         {
            _loc2_ = _loc19_..ActiveInfo;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new GmActivityInfo();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_].Activity[0]);
               _loc4_.beginShowTime = _loc4_.beginShowTime.replace(/-/g,"/");
               _loc4_.beginTime = _loc4_.beginTime.replace(/-/g,"/");
               _loc4_.endShowTime = _loc4_.endShowTime.replace(/-/g,"/");
               _loc4_.endTime = _loc4_.endTime.replace(/-/g,"/");
               _loc5_ = new Array();
               _loc6_ = _loc2_[_loc3_].ActiveGiftBag[0];
               if(Boolean(_loc6_))
               {
                  _loc7_ = _loc6_..Gift;
               }
               else
               {
                  _loc7_ = null;
               }
               if(_loc6_ && _loc7_ && _loc7_.length() > 0)
               {
                  _loc8_ = 0;
                  while(_loc8_ < _loc7_.length())
                  {
                     _loc9_ = new GiftBagInfo();
                     ObjectUtils.copyPorpertiesByXML(_loc9_,_loc7_[_loc8_]);
                     _loc10_ = new Vector.<GiftConditionInfo>();
                     _loc11_ = new Vector.<GiftRewardInfo>();
                     if(_loc6_.ActiveCondition.length() > 0)
                     {
                        _loc12_ = _loc6_.ActiveCondition[_loc8_].Condition;
                        _loc13_ = 0;
                        while(_loc13_ < _loc12_.length())
                        {
                           _loc14_ = new GiftConditionInfo();
                           ObjectUtils.copyPorpertiesByXML(_loc14_,_loc12_[_loc13_]);
                           _loc10_.push(_loc14_);
                           _loc13_++;
                        }
                     }
                     if(_loc6_.ActiveReward.length() > 0)
                     {
                        _loc15_ = _loc6_.ActiveReward[_loc8_].Reward;
                        _loc16_ = 0;
                        while(_loc16_ < _loc15_.length())
                        {
                           _loc17_ = new GiftRewardInfo();
                           ObjectUtils.copyPorpertiesByXML(_loc17_,_loc15_[_loc16_]);
                           _loc18_ = int(_loc15_[_loc16_].@isBind[0]);
                           _loc17_.isBind = _loc18_ == 1;
                           _loc11_.push(_loc17_);
                           _loc16_++;
                        }
                     }
                     _loc9_.giftConditionArr = _loc10_;
                     _loc9_.giftRewardArr = _loc11_;
                     _loc5_.push(_loc9_);
                     _loc8_++;
                  }
               }
               _loc5_.sortOn("giftbagOrder",Array.NUMERIC);
               _loc4_.giftbagArray = _loc5_;
               this._activityData[_loc4_.activityId] = _loc4_;
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc19_.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function get ActivityData() : Dictionary
      {
         return this._activityData;
      }
   }
}
