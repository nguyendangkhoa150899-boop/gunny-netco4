package bigBugleRank.data
{
   public class BigBugleRankVo
   {
       
      
      public var userId:int;
      
      public var name:String;
      
      public var consume:int;
      
      public var vipLvl:int;
      
      public function BigBugleRankVo()
      {
         super();
      }
      
      public function get isVIP() : Boolean
      {
         return this.vipLvl >= 1;
      }
   }
}
