package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import road7th.data.DictionaryData;
   
   public class LoadEdictumAnalyze extends DataAnalyzer
   {
       
      
      public var edictumDataList:DictionaryData;
      
      public function LoadEdictumAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         this.edictumDataList = new DictionaryData();
         var _loc4_:XML = new XML(param1);
         var _loc5_:XMLList = _loc4_..Item;
         if(_loc4_.@value == "true")
         {
            while(_loc2_ < _loc5_.length())
            {
               _loc3_ = new Object();
               _loc3_["id"] = _loc5_[_loc2_].@ID.toString();
               _loc3_["Title"] = _loc5_[_loc2_].@Title.toString();
               _loc3_["Text"] = _loc5_[_loc2_].@Text.toString();
               _loc3_["IsExist"] = _loc5_[_loc2_].@IsExist.toString();
               this.edictumDataList[_loc3_["id"]] = _loc3_;
               _loc2_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc4_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
