package onlineRank.data
{
   public class OnlineRankVo
   {
       
      
      public var userId:int;
      
      public var name:String;
      
      public var consume:int;
      
      public var vipLvl:int;
      
      public function OnlineRankVo()
      {
         super();
      }
      
      public function get isVIP() : Boolean
      {
         return this.vipLvl >= 1;
      }
   }
}
