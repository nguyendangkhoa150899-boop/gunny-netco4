package giftRank.data
{
   public class GiftRankVo
   {
       
      
      public var userId:int;
      
      public var name:String;
      
      public var consume:int;
      
      public var vipLvl:int;
      
      public function GiftRankVo()
      {
         super();
      }
      
      public function get isVIP() : Boolean
      {
         return this.vipLvl >= 1;
      }
   }
}
