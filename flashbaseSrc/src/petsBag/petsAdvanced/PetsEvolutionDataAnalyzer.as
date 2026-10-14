package petsBag.petsAdvanced
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import petsBag.data.PetFightPropertyData;
   
   public class PetsEvolutionDataAnalyzer extends DataAnalyzer
   {
       
      
      private var _list:Vector.<PetFightPropertyData>;
      
      public function PetsEvolutionDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:PetFightPropertyData = null;
         this._list = new Vector.<PetFightPropertyData>();
         var _loc5_:XML = new XML(param1);
         if(_loc5_.@value == "true")
         {
            _loc2_ = _loc5_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new PetFightPropertyData();
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
      
      public function get list() : Vector.<PetFightPropertyData>
      {
         return this._list;
      }
   }
}
