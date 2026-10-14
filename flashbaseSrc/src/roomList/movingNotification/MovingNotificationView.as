package roomList.movingNotification
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   
   public class MovingNotificationView extends Sprite
   {
       
      
      private var _list:Array;
      
      private var _mask:Shape;
      
      private var _currentIndex:uint;
      
      private var _currentMovingFFT:FilterFrameText;
      
      private var _textFields:Vector.<FilterFrameText>;
      
      private var _keyWordTF:TextFormat;
      
      private var _timer:Timer;
      
      private var i:int = 1;
      
      public function MovingNotificationView()
      {
         this._textFields = new Vector.<FilterFrameText>();
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._currentIndex = 0;
         this._timer = new Timer(15000);
         scrollRect = ComponentFactory.Instance.creatCustomObject("roomList.MovingNotification.DisplayRect");
         this._keyWordTF = ComponentFactory.Instance.model.getSet("roomList.MovingNotificationKeyWordTF");
      }
      
      public function get list() : Array
      {
         return this._list;
      }
      
      public function set list(param1:Array) : void
      {
         if(Boolean(param1) && this._list != param1)
         {
            this._list = param1;
            this.updateTextFields();
            this.updateCurrentTTF();
         }
         if(Boolean(this._list))
         {
            this._timer.addEventListener(TimerEvent.TIMER,this.stopEnterFrame);
            addEventListener(Event.ENTER_FRAME,this.moveFFT);
         }
      }
      
      private function stopEnterFrame(param1:TimerEvent) : void
      {
         this._timer.stop();
         addEventListener(Event.ENTER_FRAME,this.moveFFT);
      }
      
      private function clearTextFields() : void
      {
         var _loc1_:FilterFrameText = this._textFields.shift();
         while(_loc1_ != null)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = this._textFields.shift();
         }
      }
      
      private function updateTextFields() : void
      {
         var _loc1_:FilterFrameText = null;
         var _loc2_:String = null;
         var _loc3_:Vector.<uint> = null;
         var _loc4_:Vector.<uint> = null;
         this.clearTextFields();
         var _loc5_:int = 0;
         while(_loc5_ < this._list.length)
         {
            _loc1_ = ComponentFactory.Instance.creatComponentByStylename("roomList.MovingNotificationText");
            _loc2_ = String(this._list[_loc5_]);
            _loc3_ = new Vector.<uint>();
            _loc4_ = new Vector.<uint>();
            while(_loc2_.indexOf("{") > -1)
            {
               _loc3_.push(_loc2_.indexOf("{"));
               _loc4_.push(_loc2_.indexOf("}"));
               _loc2_ = _loc2_.replace("{","");
               _loc2_ = _loc2_.replace("}","");
            }
            _loc1_.text = _loc2_;
            while(_loc3_.length > 0)
            {
               _loc1_.setTextFormat(this._keyWordTF,_loc3_.shift(),_loc4_.shift() - 1);
            }
            this._textFields.push(_loc1_);
            if(!contains(_loc1_))
            {
               addChildAt(_loc1_,0);
            }
            _loc5_++;
         }
      }
      
      private function updateCurrentTTF() : void
      {
         if(this.i > this._list.length - 1)
         {
            this.i = 1;
         }
         this._currentIndex = this.i - 1;
         this._currentMovingFFT = this._textFields[this._currentIndex];
         ++this.i;
      }
      
      private function moveFFT(param1:Event) : void
      {
         if(Boolean(this._currentMovingFFT))
         {
            this._currentMovingFFT.y -= 1;
            if(this._currentMovingFFT.y == -1)
            {
               this._timer.start();
               removeEventListener(Event.ENTER_FRAME,this.moveFFT);
            }
            if(this._currentMovingFFT.y < -(this._currentMovingFFT.textHeight + 2))
            {
               this._currentMovingFFT.y = 22;
               this.updateCurrentTTF();
            }
         }
      }
      
      public function dispose() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.moveFFT);
         this._timer.stop();
         this.clearTextFields();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
