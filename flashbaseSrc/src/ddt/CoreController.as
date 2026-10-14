package ddt
{
   import ddt.events.CEvent;
   
   public class CoreController
   {
       
      
      public function CoreController()
      {
         super();
      }
      
      final protected function removeEvents(param1:Array, param2:CoreManager) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            param2.removeEventListener(param1[_loc3_],this.eventsHandler);
            _loc3_++;
         }
      }
      
      final protected function addEvents(param1:Array, param2:CoreManager) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            param2.addEventListener(param1[_loc3_],this.eventsHandler);
            _loc3_++;
         }
      }
      
      protected function eventsHandler(param1:CEvent) : void
      {
      }
      
      final protected function addEventsMap(param1:Array, param2:CoreManager) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            param2.addEventListener(param1[_loc3_][0],param1[_loc3_][1]);
            _loc3_++;
         }
      }
      
      final protected function removeEventsMap(param1:Array, param2:CoreManager) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            param2.removeEventListener(param1[_loc3_][0],param1[_loc3_][1]);
            _loc3_++;
         }
      }
   }
}
