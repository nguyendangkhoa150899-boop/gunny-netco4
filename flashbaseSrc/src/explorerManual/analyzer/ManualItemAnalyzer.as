package explorerManual.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import explorerManual.data.model.ManualItemInfo;
   import road7th.data.DictionaryData;
   
   public class ManualItemAnalyzer extends DataAnalyzer
   {
       
      
      private var _data:DictionaryData;
      
      public function ManualItemAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         this._data = new DictionaryData();
         var _loc5_:XML = new XML(param1);
         if(_loc5_.@value == "true")
         {
            _loc2_ = _loc5_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new ManualItemInfo();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               this._data.add(_loc4_.Level,_loc4_);
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc5_.@message;
            onAnalyzeError();
         }
         this._data = null;
      }
      
      public function get data() : DictionaryData
      {
         return this._data;
      }
   }
}
