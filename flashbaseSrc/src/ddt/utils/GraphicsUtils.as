package ddt.utils
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class GraphicsUtils
   {
       
      
      public function GraphicsUtils()
      {
         super();
      }
      
      public static function drawSector(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Sprite
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Sprite = new Sprite();
         var _loc9_:Number = param3;
         var _loc10_:Number = 0;
         if(param4 != 0)
         {
            _loc9_ = Math.cos(param4 * Math.PI / 180) * param3;
            _loc10_ = Math.sin(param4 * Math.PI / 180) * param3;
         }
         _loc8_.graphics.beginFill(16776960,1);
         _loc8_.graphics.moveTo(param1,param2);
         _loc8_.graphics.lineTo(param1 + _loc9_,param2 - _loc10_);
         var _loc11_:Number = param5 * Math.PI / 180 / param5;
         var _loc12_:Number = Math.cos(_loc11_);
         var _loc13_:Number = Math.sin(_loc11_);
         var _loc14_:Number = 0;
         var _loc15_:Number = 0;
         while(_loc15_ < param5)
         {
            _loc6_ = _loc12_ * _loc9_ - _loc13_ * _loc10_;
            _loc7_ = _loc12_ * _loc10_ + _loc13_ * _loc9_;
            _loc9_ = _loc6_;
            _loc10_ = _loc7_;
            _loc8_.graphics.lineTo(_loc9_ + param1,-_loc10_ + param2);
            _loc15_++;
         }
         _loc8_.graphics.lineTo(param1,param2);
         _loc8_.graphics.endFill();
         return _loc8_;
      }
      
      public static function drawDisplayMask(param1:DisplayObject) : DisplayObject
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Number = NaN;
         var _loc6_:BitmapData = new BitmapData(param1.width,param1.height,true,16711680);
         _loc6_.draw(param1);
         var _loc7_:Shape = new Shape();
         _loc7_.cacheAsBitmap = true;
         var _loc8_:uint = 0;
         while(_loc8_ < _loc6_.width)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc6_.height)
            {
               _loc3_ = _loc6_.getPixel32(_loc8_,_loc2_);
               _loc4_ = uint(_loc3_ >> 24 & 255);
               _loc5_ = _loc4_ / 255;
               if(_loc3_ > 0)
               {
                  _loc7_.graphics.beginFill(0,_loc5_);
                  _loc7_.graphics.drawCircle(_loc8_,_loc2_,1);
               }
               _loc2_++;
            }
            _loc8_++;
         }
         return _loc7_;
      }
      
      public static function changeSectorAngle(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         param1.graphics.clear();
         var _loc9_:Number = param4;
         var _loc10_:Number = 0;
         if(param5 != 0)
         {
            _loc9_ = Math.cos(param5 * Math.PI / 180) * param4;
            _loc10_ = Math.sin(param5 * Math.PI / 180) * param4;
         }
         param1.graphics.beginFill(16776960,1);
         param1.graphics.moveTo(param2,param3);
         param1.graphics.lineTo(param2 + _loc9_,param3 - _loc10_);
         var _loc11_:Number = param6 * Math.PI / 180 / param6;
         var _loc12_:Number = Math.cos(_loc11_);
         var _loc13_:Number = Math.sin(_loc11_);
         var _loc14_:Number = 0;
         var _loc15_:Number = 0;
         while(_loc15_ < param6)
         {
            _loc7_ = _loc12_ * _loc9_ - _loc13_ * _loc10_;
            _loc8_ = _loc12_ * _loc10_ + _loc13_ * _loc9_;
            _loc9_ = _loc7_;
            _loc10_ = _loc8_;
            param1.graphics.lineTo(_loc9_ + param2,-_loc10_ + param3);
            _loc15_++;
         }
         param1.graphics.lineTo(param2,param3);
         param1.graphics.endFill();
      }
   }
}
