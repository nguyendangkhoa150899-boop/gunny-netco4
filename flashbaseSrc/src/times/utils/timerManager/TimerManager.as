package times.utils.timerManager
{
   public class TimerManager
   {
      
      public static const TIMER_COMPLETE:String = "timerComplete";
      
      public static const TIMER:String = "timer";
      
      public static const COMMON:String = "common";
      
      public static const Delay80ms:String = "80ms";
      
      public static const Delay1000ms:String = "1s";
      
      private static var instance:times.utils.timerManager.TimerManager;
       
      
      private var _timerSpecial:times.utils.timerManager.TManagerJuggler;
      
      private var _timer80ms:times.utils.timerManager.TManagerJuggler;
      
      private var _timer1000ms:times.utils.timerManager.TManagerJuggler;
      
      public function TimerManager(param1:inner)
      {
         super();
         this._timerSpecial = new times.utils.timerManager.TManagerJuggler(new InternalFlag(),0);
         this._timer80ms = new times.utils.timerManager.TManagerJuggler(new InternalFlag(),0);
         this._timer1000ms = new times.utils.timerManager.TManagerJuggler(new InternalFlag(),0);
         this._timerSpecial.init(100);
         this._timer80ms.init(80);
         this._timer1000ms.init(1000);
      }
      
      public static function getInstance() : times.utils.timerManager.TimerManager
      {
         if(!instance)
         {
            instance = new times.utils.timerManager.TimerManager(new inner());
         }
         return instance;
      }
      
      public function addTimerJuggler(param1:Number, param2:int = 0, param3:Boolean = true, param4:String = "common") : TimerJuggler
      {
         switch(param4)
         {
            case "common":
               return this._timerSpecial.addTimer(param1,param2,param3,param4);
            case "80ms":
               return this._timer80ms.addTimer(param1,param2,param3,param4);
            case "1s":
               return this._timer1000ms.addTimer(param1,param2,param3,param4);
            default:
               return this._timerSpecial.addTimer(param1,param2,param3,param4);
         }
      }
      
      public function removeTimerJuggler(param1:uint) : void
      {
         this._timerSpecial.removeTimer(param1);
      }
      
      public function removeJugglerByTimer(param1:TimerJuggler) : void
      {
         if(param1 == null)
         {
            return;
         }
         switch(param1.type)
         {
            case "common":
               this._timerSpecial.removeTimer(param1.id);
               break;
            case "80ms":
               this._timer80ms.removeTimer(param1.id);
               break;
            case "1s":
               this._timer1000ms.removeTimer(param1.id);
         }
      }
      
      public function addTimer1000ms(param1:Number, param2:int = 0) : TimerJuggler
      {
         return this._timer1000ms.addTimer(param1,param2,false,"1s");
      }
      
      public function removeTimer1000ms(param1:TimerJuggler) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.type != "1s")
         {
            return;
         }
         this._timer1000ms.removeTimer(param1.id);
      }
      
      public function addTimer100ms(param1:Number, param2:int = 0) : TimerJuggler
      {
         return this._timerSpecial.addTimer(param1,param2,false,"common");
      }
      
      public function removeTimer100ms(param1:TimerJuggler) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.type != "common")
         {
            return;
         }
         this._timerSpecial.removeTimer(param1.id);
      }
   }
}

class inner
{
    
   
   public function inner()
   {
      super();
   }
}
