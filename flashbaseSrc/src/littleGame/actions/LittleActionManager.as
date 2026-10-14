package littleGame.actions
{
   import ddt.ddt_internal;
   
   public class LittleActionManager
   {
       
      
      ddt_internal var _queue:Array;
      
      public function LittleActionManager()
      {
         super();
         this.ddt_internal::_queue = new Array();
      }
      
      public function act(param1:LittleAction) : void
      {
         var _loc2_:LittleAction = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.ddt_internal::_queue.length)
         {
            _loc2_ = this.ddt_internal::_queue[_loc3_];
            if(_loc2_.connect(param1))
            {
               return;
            }
            if(_loc2_.canReplace(param1))
            {
               param1.prepare();
               this.ddt_internal::_queue[_loc3_] = param1;
               return;
            }
            _loc3_++;
         }
         this.ddt_internal::_queue.push(param1);
         if(this.ddt_internal::_queue.length == 1)
         {
            param1.prepare();
         }
      }
      
      public function execute() : void
      {
         var _loc1_:LittleAction = null;
         if(this.ddt_internal::_queue.length > 0)
         {
            _loc1_ = this.ddt_internal::_queue[0];
            if(!_loc1_.isFinished)
            {
               _loc1_.execute();
            }
            else
            {
               this.ddt_internal::_queue.shift();
               if(this.ddt_internal::_queue.length > 0)
               {
                  this.ddt_internal::_queue[0].prepare();
               }
            }
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:LittleAction = null;
         for each(_loc1_ in this.ddt_internal::_queue)
         {
            _loc1_.cancel();
         }
         this.ddt_internal::_queue = null;
      }
   }
}
