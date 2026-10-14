package com.pickgliss.utils
{
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class PNGHitAreaFactory
   {
      
      private static var points1:Vector.<Point>;
      
      private static var points2:Vector.<Point>;
      
      private static var coord:Vector.<Number>;
      
      private static var commands:Vector.<int>;
       
      
      public function PNGHitAreaFactory()
      {
         super();
      }
      
      public static function drawHitArea(param1:BitmapData) : Sprite
      {
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         getPointAroundImage(param1);
         for each(_loc2_ in points1)
         {
            coord.push(_loc2_.x);
            coord.push(_loc2_.y);
         }
         for each(_loc3_ in points2)
         {
            coord.push(_loc3_.x);
            coord.push(_loc3_.y);
         }
         _loc4_ = points1.length + points2.length;
         commands.push(1);
         _loc5_ = 1;
         while(_loc5_ < _loc4_)
         {
            commands.push(2);
            _loc5_++;
         }
         var _loc6_:Sprite = new Sprite();
         _loc6_.graphics.beginFill(16711680);
         _loc6_.graphics.drawPath(commands,coord);
         _loc6_.graphics.endFill();
         return _loc6_;
      }
      
      private static function getPointAroundImage(param1:BitmapData) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         points1 = new Vector.<Point>();
         points2 = new Vector.<Point>();
         commands = new Vector.<int>();
         coord = new Vector.<Number>();
         var _loc7_:int = param1.width;
         var _loc8_:int = param1.height;
         _loc2_ = 1;
         while(_loc2_ <= _loc7_)
         {
            _loc3_ = 1;
            while(_loc3_ <= _loc8_)
            {
               _loc5_ = uint(param1.getPixel32(_loc2_,_loc3_) >> 24 & 255);
               if(_loc5_ != 0)
               {
                  points1.push(new Point(_loc2_,_loc3_));
                  break;
               }
               _loc3_++;
            }
            _loc4_ = _loc8_;
            while(_loc4_ > 0)
            {
               _loc6_ = uint(param1.getPixel32(_loc2_,_loc4_) >> 24 & 255);
               if(_loc6_ != 0 && _loc2_ != _loc4_)
               {
                  points2.unshift(new Point(_loc2_,_loc4_));
                  break;
               }
               _loc4_--;
            }
            _loc2_++;
         }
      }
   }
}
