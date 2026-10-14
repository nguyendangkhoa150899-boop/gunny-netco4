package calendar.view
{
   import calendar.CalendarEvent;
   import calendar.CalendarManager;
   import calendar.CalendarModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   
   public class CalendarGrid extends Sprite implements Disposeable
   {
       
      
      private var _dayCells:Vector.<calendar.view.DayCell>;
      
      private var _model:CalendarModel;
      
      private var _monthField:FilterFrameText;
      
      private var _enMonthField:FilterFrameText;
      
      private var _dateField:FilterFrameText;
      
      private var _todyField:FilterFrameText;
      
      private var _back:DisplayObject;
      
      private var _backGrid:Shape;
      
      private var _title:DisplayObject;
      
      private var _getButton:BaseButton;
      
      public function CalendarGrid(param1:CalendarModel)
      {
         this._dayCells = new Vector.<DayCell>();
         super();
         this._model = param1;
         this.configUI();
         this.addEvent();
      }
      
      private function configUI() : void
      {
         var _loc4_:calendar.view.DayCell = null;
         var _loc6_:Point = null;
         var _loc1_:Date = null;
         var _loc2_:int = 0;
         var _loc3_:Date = null;
         _loc4_ = null;
         this._back = ComponentFactory.Instance.creatComponentByStylename("Calendar.GridBack");
         addChild(this._back);
         this._backGrid = new Shape();
         this._backGrid.x = 10;
         this._backGrid.y = 40;
         this._backGrid.filters = [new DropShadowFilter(1,45,4993566,0.6)];
         var _loc5_:Graphics = this._backGrid.graphics;
         _loc5_.lineStyle(1,8414016,1,true,"normal");
         _loc5_.beginFill(16513516);
         _loc5_.drawRoundRect(0,0,410,220,16);
         _loc5_.endFill();
         addChild(this._backGrid);
         this._title = ComponentFactory.Instance.creatBitmap("Calendar.Grid.Title");
         addChild(this._title);
         _loc1_ = this._model.today;
         this._monthField = ComponentFactory.Instance.creatComponentByStylename("CalendarGrid.NumMonthField");
         this._monthField.text = String(_loc1_.month + 1);
         addChild(this._monthField);
         this._enMonthField = ComponentFactory.Instance.creatComponentByStylename("CalendarGrid.EnMonthField");
         this._enMonthField.text = LanguageMgr.GetTranslation("tank.calendar.grid.month" + _loc1_.month);
         this._enMonthField.x = this._monthField.x + this._monthField.width;
         addChild(this._enMonthField);
         this._todyField = ComponentFactory.Instance.creatComponentByStylename("CalendarGrid.TodayField");
         this._todyField.text = LanguageMgr.GetTranslation("tank.calendar.grid.today",_loc1_.fullYear,_loc1_.month + 1,_loc1_.date);
         this._todyField.text += LanguageMgr.GetTranslation("tank.calendar.grid.week" + _loc1_.day);
         addChild(this._todyField);
         this._getButton = ComponentFactory.Instance.creatComponentByStylename("Calendar.Grid.GetButton");
         addChild(this._getButton);
         _loc6_ = ComponentFactory.Instance.creatCustomObject("CalendarGrid.TopLeft");
         var _loc7_:Date = new Date();
         _loc7_.time = _loc1_.time;
         _loc7_.setDate(1);
         if(_loc7_.day != 0)
         {
            if(_loc7_.month > 0)
            {
               _loc7_.setMonth(_loc1_.month - 1,CalendarModel.getMonthMaxDay(_loc1_.month - 1,_loc1_.fullYear) - _loc7_.day + 1);
            }
            else
            {
               _loc7_.setFullYear(_loc1_.fullYear - 1,11,31 - _loc7_.day + 1);
            }
         }
         _loc2_ = 0;
         while(_loc2_ < 42)
         {
            _loc3_ = new Date();
            _loc3_.time = _loc7_.time + _loc2_ * CalendarModel.MS_of_Day;
            _loc4_ = new calendar.view.DayCell(_loc3_,this._model);
            _loc4_.x = _loc6_.x + _loc2_ % 7 * 57;
            _loc4_.y = _loc6_.y + Math.floor(_loc2_ / 7) * 26;
            addChild(_loc4_);
            this._dayCells.push(_loc4_);
            _loc2_++;
         }
      }
      
      private function drawLayer() : void
      {
      }
      
      private function addEvent() : void
      {
         this._model.addEventListener(CalendarEvent.TodayChanged,this.__todayChanged);
         this._getButton.addEventListener(MouseEvent.CLICK,this.__getAward);
      }
      
      private function __getAward(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         CalendarManager.getInstance().reciveDayAward();
      }
      
      private function __signCountChanged(param1:Event) : void
      {
         var _loc2_:int = int(this._dayCells.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this._dayCells[_loc3_].signed = this._model.hasSigned(this._dayCells[_loc3_].date);
            _loc3_++;
         }
      }
      
      private function __todayChanged(param1:Event) : void
      {
         var _loc3_:Date = null;
         var _loc2_:Date = null;
         _loc3_ = this._model.today;
         this._monthField.text = String(_loc3_.month + 1);
         this._enMonthField.text = LanguageMgr.GetTranslation("tank.calendar.grid.month" + _loc3_.month);
         this._enMonthField.x = this._monthField.x + this._monthField.width;
         this._todyField.text = LanguageMgr.GetTranslation("tank.calendar.grid.today",_loc3_.fullYear,_loc3_.month + 1,_loc3_.date);
         this._todyField.text += LanguageMgr.GetTranslation("tank.calendar.grid.week" + _loc3_.day);
         var _loc4_:Date = new Date();
         _loc4_.time = _loc3_.time;
         _loc4_.setDate(1);
         if(_loc4_.day != 0)
         {
            if(_loc4_.month > 0)
            {
               _loc4_.setMonth(_loc3_.month - 1,CalendarModel.getMonthMaxDay(_loc3_.month - 1,_loc3_.fullYear) - _loc4_.day + 1);
            }
            else
            {
               _loc4_.setUTCFullYear(_loc3_.fullYear - 1,11,31 - _loc4_.day + 1);
            }
         }
         var _loc5_:int = int(this._dayCells.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc2_ = new Date();
            _loc2_.time = _loc4_.time + _loc6_ * CalendarModel.MS_of_Day;
            this._dayCells[_loc6_].date = _loc2_;
            this._dayCells[_loc6_].signed = this._model.hasSigned(this._dayCells[_loc6_].date);
            _loc6_++;
         }
      }
      
      private function removeEvent() : void
      {
         this._model.removeEventListener(CalendarEvent.TodayChanged,this.__todayChanged);
         this._getButton.removeEventListener(MouseEvent.CLICK,this.__getAward);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._backGrid);
         this._backGrid = null;
         ObjectUtils.disposeObject(this._title);
         this._title = null;
         ObjectUtils.disposeObject(this._monthField);
         this._monthField = null;
         ObjectUtils.disposeObject(this._enMonthField);
         this._enMonthField = null;
         ObjectUtils.disposeObject(this._todyField);
         this._todyField = null;
         if(Boolean(this._getButton))
         {
            ObjectUtils.disposeObject(this._getButton);
         }
         this._getButton = null;
         var _loc1_:calendar.view.DayCell = this._dayCells.shift();
         while(_loc1_ != null)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = this._dayCells.shift();
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
