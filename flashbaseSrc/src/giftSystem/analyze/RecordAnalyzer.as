package giftSystem.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import giftSystem.data.RecordInfo;
   import giftSystem.data.RecordItemInfo;
   
   public class RecordAnalyzer extends DataAnalyzer
   {
       
      
      private var _info:RecordInfo;
      
      public function RecordAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:RecordItemInfo = null;
         var _loc5_:XML = new XML(param1);
         if(_loc5_.@value == "true")
         {
            this._info = new RecordInfo();
            _loc2_ = _loc5_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new RecordItemInfo();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               this._info.recordList.push(_loc4_);
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc5_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      public function get info() : RecordInfo
      {
         return this._info;
      }
   }
}
