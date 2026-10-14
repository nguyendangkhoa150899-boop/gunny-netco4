package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import texpSystem.data.TexpExp;
   
   public class TexpExpAnalyze extends DataAnalyzer
   {
       
      
      public var list:Dictionary;
      
      public function TexpExpAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:TexpExp = null;
         var _loc5_:int = 0;
         this.list = new Dictionary();
         var _loc6_:XML = new XML(param1);
         message = _loc6_.@message;
         if(_loc6_.@value == "true")
         {
            _loc2_ = _loc6_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new TexpExp();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               _loc5_ = int(_loc2_[_loc3_].@Grage);
               this.list[_loc5_] = _loc4_;
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            onAnalyzeError();
         }
      }
   }
}
