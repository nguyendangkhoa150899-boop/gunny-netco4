package ddt.data.quest
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.ConsortiaEventInfo;
   
   public class ConsortiaEventListAnayler extends DataAnalyzer
   {
       
      
      public var list:Array;
      
      public function ConsortiaEventListAnayler(param1:Function = null)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:ConsortiaEventInfo = null;
         this.list = new Array();
         var _loc5_:XML = new XML(param1);
         if(_loc5_.@value == "true")
         {
            _loc2_ = _loc5_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new ConsortiaEventInfo();
               _loc4_.ID = _loc2_[_loc3_].@ID;
               _loc4_.ConsortiaID = _loc2_[_loc3_].@ConsortiaID;
               _loc4_.Date = _loc2_[_loc3_].@Date;
               _loc4_.Type = _loc2_[_loc3_].@Type;
               _loc4_.NickName = _loc2_[_loc3_].@NickName;
               _loc4_.EventValue = _loc2_[_loc3_].@EventValue;
               _loc4_.ManagerName = _loc2_[_loc3_].@ManagerName;
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
