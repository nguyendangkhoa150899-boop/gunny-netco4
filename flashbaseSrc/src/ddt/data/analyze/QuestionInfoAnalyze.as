package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.QuestionInfo;
   import road7th.data.DictionaryData;
   
   public class QuestionInfoAnalyze extends DataAnalyzer
   {
       
      
      public var questionList:DictionaryData;
      
      public var allQuestion:Array;
      
      public function QuestionInfoAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:QuestionInfo = null;
         var _loc5_:XML = new XML(param1);
         this.allQuestion = [];
         this.questionList = new DictionaryData();
         if(_loc5_.@value == "true")
         {
            _loc2_ = _loc5_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new QuestionInfo();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               if(this.allQuestion[_loc4_.QuestionCatalogID] == null)
               {
                  this.allQuestion[_loc4_.QuestionCatalogID] = new DictionaryData();
               }
               this.allQuestion[_loc4_.QuestionCatalogID].add(_loc4_.QuestionID,_loc4_);
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
   }
}
