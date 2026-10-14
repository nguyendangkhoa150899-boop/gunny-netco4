package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.DailyLeagueAwardInfo;
   
   public class DailyLeagueAwardAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Array;
      
      public function DailyLeagueAwardAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:DailyLeagueAwardInfo = null;
         var _loc5_:XML = new XML(param1);
         this.list = new Array();
         if(_loc5_.@value == "true")
         {
            _loc2_ = _loc5_..item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new DailyLeagueAwardInfo();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               this.list.push(_loc4_);
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc5_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
