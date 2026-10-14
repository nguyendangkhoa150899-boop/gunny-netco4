package com.pickgliss.ui.controls.container
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class VBox extends BoxContainer
   {
       
      
      public function VBox()
      {
         super();
      }
      
      override public function arrange() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Number = NaN;
         _loc1_ = null;
         _width = 0;
         _height = 0;
         _loc2_ = 0;
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _childrenList.length)
         {
            _loc1_ = _childrenList[_loc4_];
            _loc1_.y = _loc2_;
            _loc2_ += this.getItemHeight(_loc1_);
            _loc2_ += _spacing;
            if(_autoSize == CENTER && _loc4_ != 0)
            {
               _loc3_ = _childrenList[0].x - (_loc1_.width - _childrenList[0].width) / 2;
            }
            else if(_autoSize == RIGHT_OR_BOTTOM && _loc4_ != 0)
            {
               _loc3_ = _childrenList[0].x - (_loc1_.width - _childrenList[0].width);
            }
            else
            {
               _loc3_ = _loc1_.x;
            }
            _loc1_.x = _loc3_;
            _height += this.getItemHeight(_loc1_);
            _width = Math.max(_width,_loc1_.width);
            _loc4_++;
         }
         _height += _spacing * (numChildren - 1);
         _height = Math.max(0,_height);
         dispatchEvent(new Event(Event.RESIZE));
      }
      
      private function getItemHeight(param1:DisplayObject) : Number
      {
         if(isStrictSize)
         {
            return _strictSize;
         }
         return param1.height;
      }
   }
}
