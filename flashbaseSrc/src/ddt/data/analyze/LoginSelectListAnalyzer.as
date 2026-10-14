package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.Role;
   import road7th.utils.DateUtils;
   
   public class LoginSelectListAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Vector.<Role>;
      
      public var totalCount:int;
      
      public function LoginSelectListAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:Role = null;
         var _loc5_:XML = new XML(param1);
         if(_loc5_.@value == "true")
         {
            this.list = new Vector.<Role>();
            this.totalCount = int(_loc5_.@total);
            _loc2_ = XML(_loc5_)..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new Role();
               _loc4_.LastDate = DateUtils.decodeDated(_loc2_[_loc3_].@LastDate);
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               this.list.push(_loc4_);
               _loc3_++;
            }
            this.list.sort(this.sortLastDate);
            onAnalyzeComplete();
         }
         else
         {
            message = _loc5_.@message;
            onAnalyzeError();
         }
      }
      
      private function sortLastDate(param1:Role, param2:Role) : int
      {
         var _loc3_:int = 0;
         if(param1.LastDate.time < param2.LastDate.time)
         {
            _loc3_ = 1;
         }
         else
         {
            _loc3_ = -1;
         }
         return _loc3_;
      }
   }
}
