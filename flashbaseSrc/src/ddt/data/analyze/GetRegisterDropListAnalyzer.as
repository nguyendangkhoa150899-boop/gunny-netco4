package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.RegisterDropInfo;
   
   public class GetRegisterDropListAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Vector.<RegisterDropInfo>;
      
      public function GetRegisterDropListAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:RegisterDropInfo = null;
         var _loc5_:XML = new XML(param1);
         if(_loc5_.@value == "true")
         {
            this.list = new Vector.<RegisterDropInfo>();
            _loc2_ = _loc5_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new RegisterDropInfo();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               this.list.push(_loc4_);
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
