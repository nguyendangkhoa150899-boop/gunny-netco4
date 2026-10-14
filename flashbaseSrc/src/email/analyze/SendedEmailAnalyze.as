package email.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import email.data.EmailInfoOfSended;
   import flash.utils.describeType;
   
   public class SendedEmailAnalyze extends DataAnalyzer
   {
       
      
      private var _list:Array;
      
      public function SendedEmailAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:EmailInfoOfSended = null;
         this._list = new Array();
         var _loc6_:XML = new XML(param1);
         if(_loc6_.@value == "true")
         {
            _loc2_ = _loc6_.Item;
            _loc3_ = describeType(new EmailInfoOfSended());
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length())
            {
               _loc5_ = new EmailInfoOfSended();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc2_[_loc4_]);
               this.list.push(_loc5_);
               _loc4_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc6_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      public function get list() : Array
      {
         return this._list;
      }
   }
}
