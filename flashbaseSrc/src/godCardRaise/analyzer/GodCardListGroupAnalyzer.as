package godCardRaise.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import godCardRaise.info.GodCardListGroupInfo;
   
   public class GodCardListGroupAnalyzer extends DataAnalyzer
   {
       
      
      private var _list:Array;
      
      public function GodCardListGroupAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:XML = new XML(param1);
         this._list = [];
         if(_loc10_.@value == "true")
         {
            _loc2_ = _loc10_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new GodCardListGroupInfo();
               _loc5_ = [];
               _loc6_ = _loc2_[_loc3_]..ItemDetail;
               _loc7_ = 0;
               while(_loc7_ < _loc6_.length())
               {
                  _loc8_ = int(_loc6_[_loc7_].@CardID);
                  _loc9_ = int(_loc6_[_loc7_].@Number);
                  _loc5_.push({
                     "cardId":_loc8_,
                     "cardCount":_loc9_
                  });
                  _loc7_++;
               }
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               _loc4_.Cards = _loc5_;
               this._list.push(_loc4_);
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc10_.@message;
            onAnalyzeError();
         }
      }
      
      public function get list() : Array
      {
         return this._list;
      }
   }
}
