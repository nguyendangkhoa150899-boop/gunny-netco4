package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import pet.date.PetTemplateInfo;
   
   public class PetInfoAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Dictionary;
      
      public function PetInfoAnalyzer(param1:Function)
      {
         this.list = new Dictionary();
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XML = null;
         var _loc3_:PetTemplateInfo = null;
         var _loc4_:XML = XML(param1);
         var _loc5_:XMLList = _loc4_..item;
         for each(_loc2_ in _loc5_)
         {
            _loc3_ = new PetTemplateInfo();
            ObjectUtils.copyPorpertiesByXML(_loc3_,_loc2_);
            this.list[_loc3_.TemplateID] = _loc3_;
         }
         onAnalyzeComplete();
      }
   }
}
