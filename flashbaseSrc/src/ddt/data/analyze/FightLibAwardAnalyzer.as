package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.fightLib.FightLibAwardInfo;
   import ddt.data.fightLib.FightLibInfo;
   
   public class FightLibAwardAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Array;
      
      public function FightLibAwardAnalyzer(param1:Function)
      {
         this.list = [];
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Object = null;
         var _loc4_:Array = [];
         var _loc5_:XMLList = XML(param1).Item;
         for each(_loc2_ in _loc5_)
         {
            _loc3_ = new Object();
            _loc3_.id = int(_loc2_.@ID);
            _loc3_.diff = int(_loc2_.@Easy);
            _loc3_.itemID = int(_loc2_.@AwardItem);
            _loc3_.count = int(_loc2_.@Count);
            _loc4_.push(_loc3_);
         }
         this.sortItems(_loc4_);
         onAnalyzeComplete();
      }
      
      private function sortItems(param1:Array) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in param1)
         {
            this.pushInListByIDAndDiff({
               "id":_loc2_.itemID,
               "count":_loc2_.count
            },_loc2_.id,_loc2_.diff);
         }
      }
      
      private function pushInListByIDAndDiff(param1:Object, param2:int, param3:int) : void
      {
         var _loc4_:FightLibAwardInfo = this.findAwardInfoByID(param2);
         switch(param3)
         {
            case FightLibInfo.EASY:
               _loc4_.easyAward.push(param1);
               break;
            case FightLibInfo.NORMAL:
               _loc4_.normalAward.push(param1);
               break;
            case FightLibInfo.DIFFICULT:
               _loc4_.difficultAward.push(param1);
         }
      }
      
      private function findAwardInfoByID(param1:int) : FightLibAwardInfo
      {
         var _loc2_:FightLibAwardInfo = null;
         var _loc3_:int = int(this.list.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.list[_loc4_].id == param1)
            {
               return this.list[_loc4_];
            }
            _loc4_++;
         }
         if(_loc2_ == null)
         {
            _loc2_ = new FightLibAwardInfo();
            _loc2_.id = param1;
            this.list.push(_loc2_);
         }
         return _loc2_;
      }
   }
}
