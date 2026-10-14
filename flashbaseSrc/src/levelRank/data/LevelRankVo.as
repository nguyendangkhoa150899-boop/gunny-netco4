package levelRank.data
{
   public class LevelRankVo
   {
       
      
      public var userId:int;
      
      public var name:String;
      
      public var consume:int;
      
      public var vipLvl:int;
      
      public function LevelRankVo()
      {
         super();
      }
      
      public function get isVIP() : Boolean
      {
         return this.vipLvl >= 1;
      }
   }
}
