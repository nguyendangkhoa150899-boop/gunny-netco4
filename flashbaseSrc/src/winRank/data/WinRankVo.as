package winRank.data
{
   public class WinRankVo
   {
       
      
      public var userId:int;
      
      public var name:String;
      
      public var consume:int;
      
      public var vipLvl:int;
      
      public function WinRankVo()
      {
         super();
      }
      
      public function get isVIP() : Boolean
      {
         return this.vipLvl >= 1;
      }
   }
}
