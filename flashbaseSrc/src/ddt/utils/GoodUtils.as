package ddt.utils
{
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.TimeManager;
   import road7th.data.DictionaryData;
   import road7th.utils.DateUtils;
   
   public class GoodUtils
   {
       
      
      public function GoodUtils()
      {
         super();
      }
      
      public static function getOverdueItemsFrom(param1:DictionaryData) : Array
      {
         var _loc2_:Date = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:InventoryItemInfo = null;
         var _loc6_:Array = [];
         var _loc7_:Array = [];
         for each(_loc5_ in param1)
         {
            if(Boolean(_loc5_))
            {
               if(_loc5_.IsUsed)
               {
                  if(_loc5_.ValidDate != 0)
                  {
                     _loc2_ = DateUtils.getDateByStr(_loc5_.BeginDate);
                     _loc3_ = TimeManager.Instance.TotalDaysToNow(_loc2_);
                     _loc4_ = (_loc5_.ValidDate - _loc3_) * 24;
                     if(_loc4_ < 24 && _loc4_ > 0)
                     {
                        _loc6_.push(_loc5_);
                     }
                     else if(_loc4_ <= 0)
                     {
                        _loc7_.push(_loc5_);
                     }
                  }
               }
            }
         }
         return [_loc6_,_loc7_];
      }
   }
}
