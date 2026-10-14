package petsBag.petsAdvanced
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import petsBag.data.PetsFormData;
   
   public class PetsFormDataAnalyzer extends DataAnalyzer
   {
       
      
      private var _list:Vector.<PetsFormData>;
      
      public function PetsFormDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:PetsFormData = null;
         this._list = new Vector.<PetsFormData>();
         var _loc5_:XML = new XML(param1);
         if(_loc5_.@value == "true")
         {
            _loc2_ = _loc5_..item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new PetsFormData();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               this._list.push(_loc4_);
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc5_.@message;
            onAnalyzeError();
         }
      }
      
      public function get list() : Vector.<PetsFormData>
      {
         return this._list;
      }
   }
}
