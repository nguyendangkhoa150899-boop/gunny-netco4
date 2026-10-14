package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.vote.VoteQuestionInfo;
   import flash.utils.Dictionary;
   
   public class VoteInfoAnalyzer extends DataAnalyzer
   {
       
      
      public var firstQuestionID:String;
      
      public var completeMessage:String;
      
      public var questionLength:int;
      
      public var list:Dictionary;
      
      public var voteId:String;
      
      private var award:String;
      
      public function VoteInfoAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      public function get awardArr() : Array
      {
         return this.award.split(",");
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:VoteQuestionInfo = null;
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         this.list = new Dictionary();
         var _loc7_:XML = new XML(param1);
         this.voteId = _loc7_.@voteId;
         this.firstQuestionID = _loc7_.@firstQuestionID;
         this.completeMessage = _loc7_.@completeMessage;
         this.award = _loc7_.@award;
         var _loc8_:XMLList = _loc7_..item;
         this.questionLength = _loc8_.length();
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_.length())
         {
            _loc2_ = new VoteQuestionInfo();
            _loc2_.questionID = _loc8_[_loc9_].@id;
            _loc2_.multiple = _loc8_[_loc9_].@multiple == "true" ? Boolean(true) : Boolean(false);
            _loc2_.question = _loc8_[_loc9_].@question;
            _loc2_.nextQuestionID = _loc8_[_loc9_].@nextQuestionID;
            _loc3_ = _loc8_[_loc9_]..answer;
            _loc2_.answerLength = _loc3_.length();
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = int(_loc3_[_loc4_].@id);
               _loc6_ = _loc3_[_loc4_].@value;
               _loc2_.answer[_loc5_] = _loc6_;
               _loc4_++;
            }
            this.list[_loc2_.questionID] = _loc2_;
            _loc9_++;
         }
         onAnalyzeComplete();
      }
   }
}
