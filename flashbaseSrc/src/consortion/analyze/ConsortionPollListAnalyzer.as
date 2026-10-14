package consortion.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.ConsortionPollInfo;
   
   public class ConsortionPollListAnalyzer extends DataAnalyzer
   {
       
      
      public var pollList:Vector.<ConsortionPollInfo>;
      
      public function ConsortionPollListAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:ConsortionPollInfo = null;
         this.pollList = new Vector.<ConsortionPollInfo>();
         var _loc5_:XML = new XML(param1);
         if(_loc5_.@value == "true")
         {
            _loc2_ = XML(_loc5_)..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new ConsortionPollInfo();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               this.pollList.push(_loc4_);
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
