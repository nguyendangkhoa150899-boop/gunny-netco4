package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.BadgeInfo;
   import flash.utils.Dictionary;
   
   public class BadgeInfoAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Dictionary;
      
      public function BadgeInfoAnalyzer(param1:Function)
      {
         this.list = new Dictionary();
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:BadgeInfo = null;
         var _loc3_:XML = new XML(param1);
         var _loc4_:XMLList = _loc3_..item;
         var _loc5_:int = _loc4_.length();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc2_ = new BadgeInfo();
            ObjectUtils.copyPorpertiesByXML(_loc2_,_loc4_[_loc6_]);
            this.list[_loc2_.BadgeID] = _loc2_;
            _loc6_++;
         }
         onAnalyzeComplete();
      }
   }
}
