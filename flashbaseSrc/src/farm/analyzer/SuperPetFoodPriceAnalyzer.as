package farm.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import farm.modelx.SuperPetFoodPriceInfo;
   
   public class SuperPetFoodPriceAnalyzer extends DataAnalyzer
   {
      
      public static const Path:String = "PetExpItemPrice.xml";
       
      
      public var list:Vector.<SuperPetFoodPriceInfo>;
      
      public function SuperPetFoodPriceAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:XML = null;
         var _loc4_:SuperPetFoodPriceInfo = null;
         var _loc5_:XML = XML(param1);
         var _loc6_:XMLList = _loc5_..Item;
         this.list = new Vector.<SuperPetFoodPriceInfo>();
         for each(_loc3_ in _loc6_)
         {
            _loc4_ = new SuperPetFoodPriceInfo();
            ObjectUtils.copyPorpertiesByXML(_loc4_,_loc3_);
            this.list.push(_loc4_);
         }
         onAnalyzeComplete();
      }
   }
}
