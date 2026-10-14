package com.pickgliss.ui.controls.container
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class HBox extends BoxContainer
   {
       
      
      public function HBox()
      {
         super();
      }
      
      override public function arrange() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Number = NaN;
         var _loc4_:int = 0;
         _loc1_ = null;
         _width = 0;
         _height = 0;
         _loc2_ = 0;
         var _loc3_:Number = 0;
         _loc4_ = 0;
         while(_loc4_ < _childrenList.length)
         {
            _loc1_ = _childrenList[_loc4_];
            _loc1_.x = _loc2_;
            _loc2_ += this.getItemWidth(_loc1_);
            _loc2_ += _spacing;
            if(_autoSize == CENTER && _loc4_ != 0)
            {
               _loc3_ = _childrenList[0].y - (_loc1_.height - _childrenList[0].height) / 2;
            }
            else if(_autoSize == RIGHT_OR_BOTTOM && _loc4_ != 0)
            {
               _loc3_ = _childrenList[0].y - (_loc1_.height - _childrenList[0].height);
            }
            else
            {
               _loc3_ = _childrenList[0].y;
            }
            _loc1_.y = _loc3_;
            _width += this.getItemWidth(_loc1_);
            _height = Math.max(_height,_loc1_.height);
            _loc4_++;
         }
         _width += _spacing * (numChildren - 1);
         _width = Math.max(0,_width);
         dispatchEvent(new Event(Event.RESIZE));
      }
      
      private function getItemWidth(param1:DisplayObject) : Number
      {
         if(isStrictSize)
         {
            return _strictSize;
         }
         return param1.width;
      }
   }
}
