package labyrinth.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class RankingAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Array;
      
      public function RankingAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:RankingInfo = null;
         var _loc3_:int = 0;
         this.list = [];
         var _loc4_:XML = new XML(param1);
         var _loc5_:XMLList = _loc4_..Item;
         if(_loc4_.@value == "true")
         {
            _loc3_ = 0;
            while(_loc3_ < _loc5_.length())
            {
               _loc2_ = new RankingInfo();
               ObjectUtils.copyPorpertiesByXML(_loc2_,_loc5_[_loc3_]);
               this.list.push(_loc2_);
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc4_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
