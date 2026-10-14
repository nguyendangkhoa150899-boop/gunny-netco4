package bagAndInfo.bag.ring.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   
   public class RingDataAnalyzer extends DataAnalyzer
   {
       
      
      private var _data:Dictionary;
      
      public function RingDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:XML = new XML(param1);
         this._data = new Dictionary();
         if(_loc5_.@value == "true")
         {
            _loc2_ = _loc5_..Item;
            RingSystemData.TotalLevel = _loc2_.length();
            _loc3_ = 0;
            while(_loc3_ < RingSystemData.TotalLevel)
            {
               _loc4_ = new RingSystemData();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               this._data[_loc4_.Level] = _loc4_;
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
      
      public function get data() : Dictionary
      {
         return this._data;
      }
   }
}
