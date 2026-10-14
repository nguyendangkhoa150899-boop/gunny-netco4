package wonderfulActivity
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import wonderfulActivity.data.ActivityTypeData;
   
   public class WonderfulActAnalyer extends DataAnalyzer
   {
       
      
      public var itemList:Vector.<ActivityTypeData>;
      
      public function WonderfulActAnalyer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:ActivityTypeData = null;
         this.itemList = new Vector.<ActivityTypeData>();
         var _loc3_:XML = new XML(param1);
         var _loc4_:int = _loc3_.Item.length();
         var _loc5_:XMLList = _loc3_.Item;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length())
         {
            _loc2_ = new ActivityTypeData();
            ObjectUtils.copyPorpertiesByXML(_loc2_,_loc5_[_loc6_]);
            this.itemList.push(_loc2_);
            _loc6_++;
         }
         onAnalyzeComplete();
      }
   }
}
