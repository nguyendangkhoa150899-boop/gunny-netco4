package times.utils.timerManager
{
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class TManagerJuggler extends EventDispatcher implements ITimerManager
   {
       
      
      protected var _sTimer:Timer;
      
      protected var _timerDic:Dictionary;
      
      protected var _curID:uint;
      
      private var _duration:int;
      
      private var _date:Date;
      
      private var _preTime:Number;
      
      private var _internalFlag:InternalFlag;
      
      public function TManagerJuggler(param1:InternalFlag, param2:int)
      {
         super();
         this._curID = param2;
      }
      
      internal function addTimer(param1:Number, param2:int, param3:Boolean, param4:String) : TimerJuggler
      {
         ++this._curID;
         var _loc5_:TimerJuggler = new TimerJuggler(this._internalFlag,param1,param2,this._curID,param3,param4);
         this._timerDic[this._curID] = _loc5_;
         return _loc5_;
      }
      
      internal function removeTimer(param1:uint) : void
      {
         delete this._timerDic[param1];
      }
      
      internal function getTimerDataByID(param1:int) : TimerJuggler
      {
         return this._timerDic[param1];
      }
      
      internal function init(param1:Number) : void
      {
         this._duration = param1;
         this._timerDic = new Dictionary();
         this._sTimer = new Timer(param1,0);
         this._sTimer.addEventListener("timer",this.onTimer);
         this._sTimer.start();
         this._date = new Date();
         this._preTime = this._date.time;
      }
      
      internal function dispose() : void
      {
         if(this._sTimer != null)
         {
            this._sTimer.stop();
            this._sTimer.removeEventListener("timer",this.onTimer);
            this._sTimer = null;
         }
         this._timerDic = null;
      }
      
      protected function onTimer(param1:TimerEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc4_:* = undefined;
         this._date = new Date();
         var _loc3_:Number = (_loc2_ = this._date.time) - this._preTime;
         this._preTime = _loc2_;
         for each(_loc4_ in this._timerDic)
         {
            if(Boolean(_loc4_.revise))
            {
               _loc4_.advance(_loc3_);
            }
            else
            {
               _loc4_.advance(this._duration);
            }
         }
      }
   }
}
