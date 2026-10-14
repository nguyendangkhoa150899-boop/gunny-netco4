package cardSystem.analyze
{
   import cardSystem.data.SetsInfo;
   import com.pickgliss.loader.DataAnalyzer;
   
   public class SetsSortRuleAnalyzer extends DataAnalyzer
   {
       
      
      public var setsVector:Vector.<SetsInfo>;
      
      public function SetsSortRuleAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:SetsInfo = null;
         var _loc5_:int = 0;
         var _loc6_:XMLList = null;
         var _loc7_:int = 0;
         this.setsVector = new Vector.<SetsInfo>();
         var _loc8_:XML = new XML(param1);
         if(_loc8_.@value == "true")
         {
            _loc2_ = _loc8_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new SetsInfo();
               _loc4_.ID = _loc2_[_loc3_].@ID;
               _loc4_.name = _loc2_[_loc3_].@Name;
               _loc4_.storyDescript = _loc2_[_loc3_].@Description;
               _loc5_ = parseInt(_loc2_[_loc3_].@SuitID) - 1;
               _loc6_ = _loc2_[_loc3_]..Card;
               _loc7_ = 0;
               while(_loc7_ < _loc6_.length())
               {
                  if(_loc6_[_loc7_].@ID != "0")
                  {
                     _loc4_.cardIdVec.push(parseInt(_loc6_[_loc7_].@ID));
                  }
                  _loc7_++;
               }
               this.setsVector.push(_loc4_);
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc8_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
