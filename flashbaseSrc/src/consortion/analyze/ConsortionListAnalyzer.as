package consortion.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ConsortiaInfo;
   
   public class ConsortionListAnalyzer extends DataAnalyzer
   {
       
      
      public var consortionList:Vector.<ConsortiaInfo>;
      
      public var consortionsTotalCount:int;
      
      public function ConsortionListAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:ConsortiaInfo = null;
         this.consortionList = new Vector.<ConsortiaInfo>();
         var _loc5_:XML = new XML(param1);
         if(_loc5_.@value == "true")
         {
            this.consortionsTotalCount = int(_loc5_.@total);
            _loc2_ = _loc5_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new ConsortiaInfo();
               _loc4_.beginChanges();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               _loc4_.commitChanges();
               this.consortionList.push(_loc4_);
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
