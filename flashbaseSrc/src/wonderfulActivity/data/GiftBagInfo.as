package wonderfulActivity.data
{
   public class GiftBagInfo
   {
       
      
      public var activityId:String;
      
      public var giftbagId:String;
      
      public var giftConditionArr:Vector.<wonderfulActivity.data.GiftConditionInfo>;
      
      public var giftbagOrder:int;
      
      public var giftRewardArr:Vector.<wonderfulActivity.data.GiftRewardInfo>;
      
      public var rewardMark:int;
      
      public function GiftBagInfo()
      {
         super();
      }
   }
}
