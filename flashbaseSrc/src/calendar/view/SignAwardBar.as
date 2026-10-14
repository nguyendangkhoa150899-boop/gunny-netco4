package calendar.view
{
   import calendar.CalendarEvent;
   import calendar.CalendarModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class SignAwardBar extends Sprite implements Disposeable
   {
       
      
      private var _items:Vector.<calendar.view.NavigItem>;
      
      private var _current:calendar.view.NavigItem;
      
      private var _model:CalendarModel;
      
      private var _back:DisplayObject;
      
      private var _title:DisplayObject;
      
      private var _awardHolder:calendar.view.SignedAwardHolder;
      
      private var _signCoundField:FilterFrameText;
      
      private var _selectedItem:calendar.view.NavigItem;
      
      public function SignAwardBar(param1:CalendarModel)
      {
         this._items = new Vector.<NavigItem>();
         super();
         this._model = param1;
         this.configUI();
         this.addEvent();
      }
      
      private function configUI() : void
      {
         this._back = ComponentFactory.Instance.creatComponentByStylename("Calendar.SignedAwardBack");
         addChild(this._back);
         this._title = ComponentFactory.Instance.creatBitmap("Calendar.SignedAward.Title");
         addChild(this._title);
         this._signCoundField = ComponentFactory.Instance.creatComponentByStylename("Calendar.SignCountField");
         this._signCoundField.text = this._model.signCount.toString();
         addChild(this._signCoundField);
         this._awardHolder = ComponentFactory.Instance.creatCustomObject("SignedAwardHolder",[this._model]);
         addChild(this._awardHolder);
         this.drawCells();
      }
      
      private function drawCells() : void
      {
         var _loc1_:Point = null;
         var _loc3_:calendar.view.NavigItem = null;
         _loc1_ = null;
         var _loc2_:int = 0;
         _loc3_ = null;
         var _loc4_:int = int(this._model.awardCounts.length);
         var _loc5_:int = 0;
         _loc1_ = ComponentFactory.Instance.creatCustomObject("Calendar.Award.TopLeft");
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = new calendar.view.NavigItem(this._model.awardCounts[_loc2_]);
            _loc3_.x = _loc1_.x + _loc2_ * 100;
            _loc3_.y = _loc1_.y;
            _loc3_.addEventListener(MouseEvent.CLICK,this.__itemClick);
            this._items.push(_loc3_);
            addChild(_loc3_);
            if(this._model.hasReceived(this._model.awardCounts[_loc2_]))
            {
               _loc3_.received = true;
               _loc5_++;
            }
            _loc2_++;
         }
         if(_loc5_ < this._items.length)
         {
            this._items[_loc5_].selected = true;
            this._selectedItem = this._items[_loc5_];
            this._awardHolder.setAwardsByCount(this._selectedItem.count);
         }
      }
      
      private function __itemClick(param1:MouseEvent) : void
      {
         var _loc2_:calendar.view.NavigItem = param1.currentTarget as NavigItem;
         if(this._selectedItem != _loc2_)
         {
            this._selectedItem.selected = false;
            this._selectedItem = _loc2_;
            this._selectedItem.selected = true;
            this._awardHolder.setAwardsByCount(this._selectedItem.count);
            SoundManager.instance.play("008");
         }
      }
      
      private function reset() : void
      {
         var _loc1_:int = int(this._model.awardCounts.length);
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            this._items[_loc3_].selected = this._items[_loc3_].received = false;
            _loc3_++;
         }
         this._selectedItem = this._items[0];
         this._selectedItem.selected = true;
         this._awardHolder.setAwardsByCount(this._selectedItem.count);
      }
      
      private function __signCountChanged(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this._signCoundField.text = this._model.signCount.toString();
         if(this._model.signCount == 0)
         {
            this.reset();
         }
         else
         {
            _loc2_ = int(this._model.awardCounts.length);
            _loc3_ = 0;
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               if(this._model.hasReceived(this._model.awardCounts[_loc4_]))
               {
                  this._items[_loc4_].received = true;
                  if(this._items[_loc4_] == this._selectedItem)
                  {
                     this._selectedItem = null;
                  }
                  _loc3_++;
               }
               _loc4_++;
            }
            if(_loc3_ < this._items.length && this._selectedItem == null)
            {
               this._items[_loc3_].selected = true;
               this._selectedItem = this._items[_loc3_];
               this._awardHolder.setAwardsByCount(this._selectedItem.count);
            }
            else if(this._selectedItem == null)
            {
               this._awardHolder.clean();
            }
         }
      }
      
      private function addEvent() : void
      {
         this._model.addEventListener(CalendarEvent.SignCountChanged,this.__signCountChanged);
      }
      
      private function removeEvent() : void
      {
         this._model.removeEventListener(CalendarEvent.SignCountChanged,this.__signCountChanged);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._title);
         this._title = null;
         ObjectUtils.disposeObject(this._signCoundField);
         this._signCoundField = null;
         ObjectUtils.disposeObject(this._awardHolder);
         this._awardHolder = null;
         var _loc1_:calendar.view.NavigItem = this._items.shift();
         while(_loc1_ != null)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = this._items.shift();
         }
         this._current = this._selectedItem = null;
         this._model = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
