package consortion.view.selfConsortia.consortiaTask
{
   public class ConsortiaTaskInfo
   {
       
      
      public var itemList:Vector.<Object>;
      
      public var exp:int;
      
      public var offer:int;
      
      public var riches:int;
      
      public var buffID:int;
      
      public var beginTime:Date;
      
      public var time:int;
      
      private var sortKey:Array;
      
      public function ConsortiaTaskInfo()
      {
         this.sortKey = [3,4,1,5,2];
         super();
         this.itemList = new Vector.<Object>();
      }
      
      public function addItemData(param1:int, param2:String, param3:int = 0, param4:Number = 0, param5:int = 0, param6:int = 0) : void
      {
         var _loc7_:Object = new Object();
         _loc7_["id"] = param1;
         _loc7_["taskType"] = param3;
         _loc7_["content"] = param2;
         _loc7_["currenValue"] = param4;
         _loc7_["targetValue"] = param5;
         _loc7_["finishValue"] = param6;
         this.itemList.push(_loc7_);
      }
      
      public function sortItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         var _loc3_:Vector.<Object> = new Vector.<Object>();
         while(_loc1_ < this.sortKey.length)
         {
            for each(_loc2_ in this.itemList)
            {
               if(this.sortKey[_loc1_] == _loc2_["taskType"])
               {
                  _loc3_.push(_loc2_);
               }
            }
            _loc1_++;
         }
         this.itemList = _loc3_;
      }
      
      public function updateItemData(param1:int, param2:Number = 0, param3:int = 0) : void
      {
         var _loc4_:Object = null;
         for each(_loc4_ in this.itemList)
         {
            if(_loc4_["id"] == param1)
            {
               _loc4_["currenValue"] = param2;
               _loc4_["finishValue"] = param3;
            }
         }
      }
   }
}
