package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import vip.data.VipSetting;
   
   public class VipSettingAnalyzer extends DataAnalyzer
   {
       
      
      public var VipSettings:Dictionary;
      
      public function VipSettingAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:VipSetting = null;
         var _loc5_:int = 0;
         var _loc6_:XML = new XML(param1);
         this.VipSettings = new Dictionary();
         if(_loc6_.@value == "true")
         {
            _loc2_ = _loc6_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new VipSetting();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               _loc5_ = int(_loc2_[_loc3_].@VIPLevel);
               this.VipSettings[_loc5_] = _loc4_;
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc6_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
