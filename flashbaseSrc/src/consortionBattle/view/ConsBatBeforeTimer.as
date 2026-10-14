package consortionBattle.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.TimeManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ConsBatBeforeTimer extends Sprite implements Disposeable
   {
       
      
      private var _timerMc:MovieClip;
      
      private var _timerMc_1:MovieClip;
      
      private var _timerMc_2:MovieClip;
      
      private var _timerMc_3:MovieClip;
      
      private var _timerMc_4:MovieClip;
      
      private var _total:int;
      
      private var _timer:Timer;
      
      public function ConsBatBeforeTimer(param1:int)
      {
         super();
         this._total = param1;
         this.initView();
         this.refreshView(this._total);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
         this._timer.start();
      }
      
      private function initView() : void
      {
         this._timerMc = ComponentFactory.Instance.creat("asset.consortiaBattle.beforeTimer");
         this._timerMc_1 = this._timerMc["timer_1"];
         this._timerMc_2 = this._timerMc["timer_2"];
         this._timerMc_3 = this._timerMc["timer_3"];
         this._timerMc_4 = this._timerMc["timer_4"];
         this._timerMc_1.gotoAndStop(10);
         this._timerMc_2.gotoAndStop(10);
         this._timerMc_3.gotoAndStop(10);
         this._timerMc_4.gotoAndStop(10);
         addChild(this._timerMc);
      }
      
      private function timerHandler(param1:TimerEvent) : void
      {
         --this._total;
         if(this._total <= 0)
         {
            this.dispose();
            return;
         }
         this.refreshView(this._total);
      }
      
      private function refreshView(param1:int) : void
      {
         var _loc2_:int = param1 / (TimeManager.Minute_TICKS / 1000);
         var _loc3_:int = _loc2_ / 10;
         this._timerMc_1.gotoAndStop(_loc3_ == 0 ? 10 : _loc3_);
         var _loc4_:int = _loc2_ % 10;
         this._timerMc_2.gotoAndStop(_loc4_ == 0 ? 10 : _loc4_);
         var _loc5_:int = param1 % (TimeManager.Minute_TICKS / 1000);
         var _loc6_:int = _loc5_ / 10;
         this._timerMc_3.gotoAndStop(_loc6_ == 0 ? 10 : _loc6_);
         var _loc7_:int = _loc5_ % 10;
         this._timerMc_4.gotoAndStop(_loc7_ == 0 ? 10 : _loc7_);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
            this._timer.stop();
         }
         this._timer = null;
         ObjectUtils.disposeObject(this._timerMc);
         this._timerMc = null;
         this._timerMc_1 = null;
         this._timerMc_2 = null;
         this._timerMc_3 = null;
         this._timerMc_4 = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
