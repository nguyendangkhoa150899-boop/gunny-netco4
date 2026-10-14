package cardSystem.analyze
{
   import cardSystem.data.SetsPropertyInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import road7th.data.DictionaryData;
   
   public class SetsPropertiesAnalyzer extends DataAnalyzer
   {
       
      
      public var setsList:DictionaryData;
      
      public function SetsPropertiesAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Vector.<SetsPropertyInfo> = null;
         var _loc6_:XMLList = null;
         var _loc7_:int = 0;
         var _loc8_:SetsPropertyInfo = null;
         this.setsList = new DictionaryData();
         var _loc9_:XML = new XML(param1);
         if(_loc9_.@value == "true")
         {
            _loc2_ = _loc9_..Card;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = _loc2_[_loc3_].@CardID;
               _loc5_ = new Vector.<SetsPropertyInfo>();
               _loc6_ = _loc2_[_loc3_]..Item;
               _loc7_ = 0;
               while(_loc7_ < _loc6_.length())
               {
                  if(_loc6_[_loc7_].@condition != "0")
                  {
                     _loc8_ = new SetsPropertyInfo();
                     ObjectUtils.copyPorpertiesByXML(_loc8_,_loc6_[_loc7_]);
                     _loc5_.push(_loc8_);
                  }
                  _loc7_++;
               }
               this.setsList.add(_loc4_,_loc5_);
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc9_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
