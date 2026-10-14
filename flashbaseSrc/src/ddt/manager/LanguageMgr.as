package ddt.manager
{
   import ddt.data.analyze.LanguageAnalyzer;
   import flash.utils.Dictionary;
   
   public class LanguageMgr
   {
      
      private static var _dic:Dictionary;
      
      private static var _reg:RegExp = /\{(\d+)\}/;
       
      
      public function LanguageMgr()
      {
         super();
      }
      
      public static function setup(param1:LanguageAnalyzer) : void
      {
         _dic = param1.languages;
      }
      
      public static function GetTranslation(param1:String, ... rest) : String
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:String = Boolean(_dic[param1]) ? String(_dic[param1]) : "";
         var _loc7_:Object = _reg.exec(_loc6_);
         while(Boolean(_loc7_) && rest.length > 0)
         {
            _loc3_ = int(_loc7_[1]);
            _loc4_ = String(rest[_loc3_]);
            if(_loc3_ >= 0 && _loc3_ < rest.length)
            {
               _loc5_ = _loc4_.indexOf("$");
               if(_loc5_ > -1)
               {
                  _loc4_ = _loc4_.slice(0,_loc5_) + "$" + _loc4_.slice(_loc5_);
               }
               _loc6_ = _loc6_.replace(_reg,_loc4_);
            }
            else
            {
               _loc6_ = _loc6_.replace(_reg,"{}");
            }
            _loc7_ = _reg.exec(_loc6_);
         }
         return _loc6_;
      }
   }
}
