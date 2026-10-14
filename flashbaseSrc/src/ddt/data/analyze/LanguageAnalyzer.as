package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.StringUtils;
   import flash.utils.Dictionary;
   
   public class LanguageAnalyzer extends DataAnalyzer
   {
       
      
      public var languages:Dictionary;
      
      public function LanguageAnalyzer(param1:Function)
      {
         this.languages = new Dictionary();
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Array = String(param1).split("\r\n");
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_.length)
         {
            _loc2_ = String(_loc6_[_loc7_]);
            if(_loc2_.indexOf("#") != 0)
            {
               _loc2_ = _loc2_.replace("\\r","\r");
               _loc2_ = _loc2_.replace("\\n","\n");
               _loc3_ = _loc2_.indexOf(":");
               if(_loc3_ != -1)
               {
                  _loc4_ = _loc2_.substring(0,_loc3_);
                  _loc5_ = _loc2_.substr(_loc3_ + 1);
                  _loc5_ = String(_loc5_.split("##")[0]);
                  this.languages[_loc4_] = StringUtils.trimRight(_loc5_);
                  onAnalyzeComplete();
               }
            }
            _loc7_++;
         }
      }
   }
}
