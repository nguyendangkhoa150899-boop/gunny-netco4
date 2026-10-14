package times.utils.timerManager
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public final class TimerJuggler extends EventDispatcher
   {
       
      
      private var _id:uint;
      
      private var _delay:Number;
      
      private var _repeatCount:int;
      
      private var _running:Boolean;
      
      private var _currentCount:int = 0;
      
      private var _totalTime:Number;
      
      private var _currentTime:int = 0;
      
      private var _revise:Boolean;
      
      private var _type:String;
      
      public function TimerJuggler(param1:InternalFlag, param2:Number, param3:int, param4:int, param5:Boolean, param6:String)
      {
         super();
         this._delay = param2;
         this._repeatCount = param3;
         this._id = param4;
         this._running = false;
         this._totalTime = param3 * param2;
         this._revise = param5;
      }
      
      final internal function advance(param1:Number) : void
      {
         var _loc2_:Boolean = false;
         if(!this._running)
         {
            return;
         }
         this._currentTime += param1;
         if(this._currentTime < (this._currentCount + 1) * this.delay)
         {
            return;
         }
         if(this._revise)
         {
            this._currentCount = this._currentTime / this.delay;
            _loc2_ = this._currentTime >= this._totalTime && this._totalTime > 0;
         }
         else
         {
            ++this._currentCount;
            _loc2_ = this._currentCount >= this.repeatCount && this.repeatCount > 0;
         }
         if(_loc2_)
         {
            this._running = false;
            dispatchEvent(new Event("timer"));
            dispatchEvent(new Event("timerComplete"));
            this._currentCount = 0;
            this._currentTime = 0;
         }
         else
         {
            dispatchEvent(new Event("timer"));
         }
      }
      
      public function reset() : void
      {
         this._running = false;
         this._currentCount = 0;
         this._currentTime = 0;
      }
      
      public function start() : void
      {
         this._running = true;
      }
      
      public function stop() : void
      {
         this._running = false;
      }
      
      public function get running() : Boolean
      {
         return this._running;
      }
      
      public function get currentCount() : int
      {
         if(this.repeatCount == 0)
         {
            return this._currentCount;
         }
         return Math.min(this.repeatCount,this._currentCount);
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get repeatCount() : int
      {
         return this._repeatCount;
      }
      
      public function set repeatCount(param1:int) : void
      {
         this._repeatCount = param1;
         this._totalTime = this._repeatCount * this._delay;
      }
      
      public function get delay() : Number
      {
         return this._delay;
      }
      
      public function set delay(param1:Number) : void
      {
         this._delay = param1;
         this._totalTime = this._repeatCount * this._delay;
      }
      
      public function get revise() : Boolean
      {
         return this._revise;
      }
      
      public function get type() : String
      {
         return this._type;
      }
   }
}
