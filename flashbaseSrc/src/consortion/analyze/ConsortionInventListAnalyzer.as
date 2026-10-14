package consortion.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.ConsortiaInventData;
   
   public class ConsortionInventListAnalyzer extends DataAnalyzer
   {
       
      
      public var inventList:Vector.<ConsortiaInventData>;
      
      public var totalCount:int;
      
      public function ConsortionInventListAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:ConsortiaInventData = null;
         this.inventList = new Vector.<ConsortiaInventData>();
         var _loc5_:XML = new XML(param1);
         if(_loc5_.@value == "true")
         {
            this.totalCount = int(_loc5_.@total);
            _loc2_ = XML(_loc5_)..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new ConsortiaInventData();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               this.inventList.push(_loc4_);
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
