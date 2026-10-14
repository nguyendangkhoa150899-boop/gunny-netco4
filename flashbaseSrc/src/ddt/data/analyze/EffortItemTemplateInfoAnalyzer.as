package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.effort.EffortInfo;
   import ddt.data.effort.EffortQualificationInfo;
   import ddt.data.effort.EffortRewardInfo;
   import road7th.data.DictionaryData;
   
   public class EffortItemTemplateInfoAnalyzer extends DataAnalyzer
   {
      
      private static const PATH:String = "AchievementList.xml";
       
      
      public var list:DictionaryData;
      
      public function EffortItemTemplateInfoAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:XML = null;
         var _loc5_:EffortInfo = null;
         var _loc6_:XMLList = null;
         var _loc7_:int = 0;
         var _loc8_:XMLList = null;
         var _loc9_:int = 0;
         var _loc10_:EffortQualificationInfo = null;
         var _loc11_:EffortRewardInfo = null;
         var _loc12_:XML = new XML(param1);
         this.list = new DictionaryData();
         if(_loc12_.@value == "true")
         {
            _loc2_ = _loc12_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = _loc2_[_loc3_];
               _loc5_ = new EffortInfo();
               _loc5_.ID = _loc4_.@ID;
               _loc5_.PlaceID = _loc4_.@PlaceID;
               _loc5_.Title = _loc4_.@Title;
               _loc5_.Detail = _loc4_.@Detail;
               _loc5_.NeedMinLevel = _loc4_.@NeedMinLevel;
               _loc5_.NeedMaxLevel = _loc4_.@NeedMaxLevel;
               _loc5_.PreAchievementID = _loc4_.@PreAchievementID;
               _loc5_.IsOther = this.getBoolean(_loc4_.@IsOther);
               _loc5_.AchievementType = _loc4_.@AchievementType;
               _loc5_.CanHide = this.getBoolean(_loc4_.@CanHide);
               _loc5_.picId = _loc4_.@PicID;
               _loc5_.StartDate = new Date(String(_loc4_.@StartDate).substr(5,2) + "/" + String(_loc4_.@StartDate).substr(8,2) + "/" + String(_loc4_.@StartDate).substr(0,4));
               _loc5_.EndDate = new Date(String(_loc4_.@StartDate).substr(5,2) + "/" + String(_loc4_.@StartDate).substr(8,2) + "/" + String(_loc4_.@StartDate).substr(0,4));
               _loc5_.AchievementPoint = _loc4_.@AchievementPoint;
               _loc6_ = _loc4_..Item_Condiction;
               _loc7_ = 0;
               while(_loc7_ < _loc6_.length())
               {
                  _loc10_ = new EffortQualificationInfo();
                  _loc10_.AchievementID = _loc6_[_loc7_].@AchievementID;
                  _loc10_.CondictionID = _loc6_[_loc7_].@CondictionID;
                  _loc10_.CondictionType = _loc6_[_loc7_].@CondictionType;
                  _loc10_.Condiction_Para1 = _loc6_[_loc7_].@Condiction_Para1;
                  _loc10_.Condiction_Para2 = _loc6_[_loc7_].@Condiction_Para2;
                  _loc5_.addEffortQualification(_loc10_);
                  _loc7_++;
               }
               _loc8_ = _loc4_..Item_Reward;
               _loc9_ = 0;
               while(_loc9_ < _loc8_.length())
               {
                  _loc11_ = new EffortRewardInfo();
                  _loc11_.AchievementID = _loc8_[_loc9_].@AchievementID;
                  _loc11_.RewardCount = _loc8_[_loc9_].@RewardCount;
                  _loc11_.RewardPara = _loc8_[_loc9_].@RewardPara;
                  _loc11_.RewardType = _loc8_[_loc9_].@RewardType;
                  _loc11_.RewardValueId = _loc8_[_loc9_].@RewardValueId;
                  _loc5_.addEffortReward(_loc11_);
                  _loc9_++;
               }
               this.list[_loc5_.ID] = _loc5_;
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc12_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      private function getBoolean(param1:String) : Boolean
      {
         if(param1 == "true" || param1 == "1")
         {
            return true;
         }
         return false;
      }
   }
}
