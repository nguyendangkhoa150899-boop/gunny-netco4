package cardSystem.analyze
{
   import cardSystem.data.SetsUpgradeRuleInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class UpgradeRuleAnalyzer extends DataAnalyzer
   {
       
      
      public var upgradeRuleVec:Vector.<SetsUpgradeRuleInfo>;
      
      public function UpgradeRuleAnalyzer(param1:Function)
      {
         super(param1);
         this.upgradeRuleVec = new Vector.<SetsUpgradeRuleInfo>();
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:SetsUpgradeRuleInfo = null;
         var _loc6_:XML = new XML(param1);
         if(_loc6_.@value == "true")
         {
            _loc2_ = _loc6_..Item;
            _loc3_ = _loc2_.length();
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = new SetsUpgradeRuleInfo();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc2_[_loc4_]);
               this.upgradeRuleVec.push(_loc5_);
               _loc4_++;
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
