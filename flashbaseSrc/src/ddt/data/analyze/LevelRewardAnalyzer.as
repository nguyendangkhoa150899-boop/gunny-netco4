package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import flash.utils.Dictionary;
   import trainer.data.LevelRewardInfo;
   
   public class LevelRewardAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Dictionary;
      
      public function LevelRewardAnalyzer(param1:Function)
      {
         this.list = new Dictionary();
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:Dictionary = null;
         var _loc5_:XMLList = null;
         var _loc6_:XML = null;
         var _loc7_:LevelRewardInfo = null;
         var _loc8_:XML = XML(param1);
         var _loc9_:XMLList = _loc8_.reward;
         for each(_loc2_ in _loc9_)
         {
            _loc3_ = int(_loc2_.@level);
            _loc4_ = new Dictionary();
            _loc5_ = _loc2_.rewardItem;
            for each(_loc6_ in _loc5_)
            {
               _loc7_ = new LevelRewardInfo();
               _loc7_.sort = int(_loc6_.@sort);
               _loc7_.title = String(_loc6_.@title);
               _loc7_.content = String(_loc6_.@content);
               _loc7_.girlItems = String(_loc6_.@items).split("|")[0].split(",");
               _loc7_.boyItems = String(_loc6_.@items).split("|")[1].split(",");
               _loc4_[_loc7_.sort] = _loc7_;
            }
            this.list[_loc3_] = _loc4_;
         }
         onAnalyzeComplete();
      }
   }
}
