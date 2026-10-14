package newTitle.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import newTitle.model.NewTitleModel;
   
   public class NewTitleDataAnalyz extends DataAnalyzer
   {
       
      
      public var _newTitleList:Dictionary;
      
      public function NewTitleDataAnalyz(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         this._newTitleList = new Dictionary();
         var _loc5_:XML = new XML(param1);
         if(_loc5_.@value == "true")
         {
            _loc2_ = _loc5_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new NewTitleModel();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               this._newTitleList[_loc4_.id] = _loc4_;
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc5_.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function get list() : Dictionary
      {
         return this._newTitleList;
      }
   }
}
