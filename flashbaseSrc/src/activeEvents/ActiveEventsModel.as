package activeEvents
{
   import activeEvents.data.ActiveEventsInfo;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public class ActiveEventsModel extends EventDispatcher
   {
      
      public static var newMovement:Dictionary = new Dictionary();
       
      
      private var _list:Array;
      
      private var _activesList:Array;
      
      public function ActiveEventsModel()
      {
         super();
      }
      
      public function get actives() : Array
      {
         return this._activesList;
      }
      
      public function get list() : Array
      {
         return this._list;
      }
      
      public function set actives(param1:Array) : void
      {
         this._list = param1;
         this._activesList = this._list.concat();
         this.filtTime();
         this._activesList = this.sortActives();
      }
      
      private function filtTime() : void
      {
         var _loc1_:ActiveEventsInfo = null;
         var _loc2_:int = this.actives.length - 1;
         while(_loc2_ >= 0)
         {
            _loc1_ = this.actives[_loc2_];
            if(_loc1_.overdue())
            {
               this.actives.splice(_loc2_,1);
            }
            _loc2_--;
         }
      }
      
      private function sortActives() : Array
      {
         var _loc1_:ActiveEventsInfo = null;
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < this.actives.length)
         {
            _loc1_ = this.actives[_loc5_];
            if(_loc1_.Type == 0)
            {
               _loc4_.push(_loc1_);
            }
            else if(_loc1_.Type == 1)
            {
               _loc3_.push(_loc1_);
               if(newMovement[_loc1_.ActiveID] == null)
               {
                  newMovement[_loc1_.ActiveID] = false;
               }
            }
            else if(_loc1_.Type == 2)
            {
               _loc2_.push(_loc1_);
            }
            _loc5_++;
         }
         return _loc2_.concat(_loc3_,_loc4_);
      }
   }
}
