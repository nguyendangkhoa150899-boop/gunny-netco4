package com.pickgliss.ui.controls.container
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class GridBox extends BoxContainer
   {
       
      
      public var alwaysLast:DisplayObject;
      
      public var lastRowWidthMax:Number = 320;
      
      public var columnNumber:int = 5;
      
      public var cellHeght:Number = 100;
      
      public var align:String = "right";
      
      private var __checkAlignFunction:Function;
      
      public function GridBox()
      {
         super();
         this.checkAlignForFirstRow = false;
      }
      
      public function set checkAlignForFirstRow(param1:Boolean) : void
      {
         var value:* = param1;
         if(value)
         {
            this.__checkAlignFunction = function():Boolean
            {
               return true;
            };
         }
         else
         {
            this.__checkAlignFunction = function():Boolean
            {
               return _childrenList.length > columnNumber;
            };
         }
      }
      
      override public function arrange() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         if(_childrenList == null)
         {
            return;
         }
         if(_childrenList.length <= 0)
         {
            return;
         }
         if(this.alwaysLast != null)
         {
            this.alwaysLast.parent && removeChild(this.alwaysLast);
            addChild(this.alwaysLast);
         }
         _width = 0;
         _height = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < _childrenList.length)
         {
            _loc2_ = _childrenList[_loc1_];
            if(_loc1_ % this.columnNumber == 0)
            {
               _loc5_ = 0;
            }
            _loc2_.x = _loc5_;
            _loc5_ += this.getItemWidth(_loc2_);
            _loc5_ += _spacing;
            if(_autoSize == 2 && _loc1_ != 0)
            {
               _loc6_ = Number(_childrenList[0].y - (_loc2_.height - _childrenList[0].height) / 2);
            }
            else if(_autoSize == 1 && _loc1_ != 0)
            {
               _loc6_ = Number(_childrenList[0].y - (_loc2_.height - _childrenList[0].height));
            }
            else if(_autoSize == 3)
            {
               _loc6_ = 0;
            }
            else
            {
               _loc6_ = Number(_childrenList[0].y);
            }
            _loc6_ += this.cellHeght * int(_loc1_ / this.columnNumber);
            _loc2_.y = _loc6_;
            if(_loc1_ < this.columnNumber)
            {
               _width += this.getItemWidth(_loc2_) + _spacing;
            }
            _height = Math.max(_height,(int(_loc1_ / this.columnNumber) + (_loc1_ % this.columnNumber > 0 ? 1 : 0)) * this.cellHeght);
            _loc1_++;
         }
         if(this.align == "right" && this.__checkAlignFunction())
         {
            _loc3_ = _childrenList[_childrenList.length - 1] as DisplayObject;
            _loc4_ = this.lastRowWidthMax - _loc3_.x - _loc3_.width;
            _loc1_ = int(_childrenList.length / this.columnNumber) * this.columnNumber;
            while(_loc1_ < _childrenList.length)
            {
               _childrenList[_loc1_].x += _loc4_;
               _loc1_++;
            }
         }
         _width = Math.max(0,_width);
         dispatchEvent(new Event("resize"));
      }
      
      private function getItemHeight(param1:DisplayObject) : Number
      {
         if(isStrictSize)
         {
            return _strictSize;
         }
         return param1.height;
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
