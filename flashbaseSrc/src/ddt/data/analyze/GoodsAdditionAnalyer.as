package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class GoodsAdditionAnalyer extends DataAnalyzer
   {
       
      
      private var _xml:XML;
      
      private var _additionArr:Array;
      
      public function GoodsAdditionAnalyer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         this._additionArr = new Array();
         this._xml = new XML(param1);
         var _loc4_:XMLList = this._xml.Item;
         if(this._xml.@value == "true")
         {
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length())
            {
               _loc3_ = new Object();
               _loc3_.ItemCatalog = int(_loc4_[_loc2_].@ItemCatalog);
               _loc3_.SubCatalog = int(_loc4_[_loc2_].@SubCatalog);
               _loc3_.StrengthenLevel = int(_loc4_[_loc2_].@StrengthenLevel);
               _loc3_.FailtureTimes = int(_loc4_[_loc2_].@FailtureTimes);
               _loc3_.PropertyPlus = int(_loc4_[_loc2_].@PropertyPlus);
               _loc3_.SuccessRatePlus = int(_loc4_[_loc2_].@SuccessRatePlus);
               this._additionArr.push(_loc3_);
               _loc2_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      public function get additionArr() : Array
      {
         return this._additionArr;
      }
   }
}
