package homeTemple.view
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class N_BitmapDataNumber
   {
       
      
      public var numList:Vector.<BitmapData>;
      
      public var dot:BitmapData;
      
      public var sprit:BitmapData;
      
      public var add:BitmapData;
      
      public var reduce:BitmapData;
      
      public var gap:Number = 1;
      
      private var _rect:Rectangle;
      
      private var _bitmapdata:BitmapData;
      
      private var _tempRect:Rectangle;
      
      private var _point:Point;
      
      public function N_BitmapDataNumber()
      {
         this._point = new Point(0,0);
         super();
      }
      
      public function getNumber(param1:String, param2:String = "left") : BitmapData
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         this._bitmapdata = new BitmapData(this._bitmapdata.width,this._bitmapdata.height,true,0);
         var _loc7_:int = 0;
         var _loc8_:int = param1.length;
         _loc5_ = 0;
         while(_loc5_ < _loc8_)
         {
            if((_loc3_ = param1.charAt(_loc5_)) == ".")
            {
               _loc4_ = this.dot;
               this._tempRect.width = this.dot.width;
               this._tempRect.height = this.dot.height;
               this._point.x = _loc7_;
               this._point.y = 0;
            }
            else if(_loc3_ == "+")
            {
               _loc4_ = this.add;
               this._tempRect.width = this.add.width;
               this._tempRect.height = this.add.height;
               this._point.x = _loc7_;
               this._point.y = 0;
            }
            else if(_loc3_ == "/")
            {
               _loc4_ = this.sprit;
               this._tempRect.width = this.sprit.width;
               this._tempRect.height = this.sprit.height;
               this._point.x = _loc7_;
               this._point.y = 0;
            }
            else if(_loc3_ == "-")
            {
               _loc4_ = this.reduce;
               this._tempRect.width = this.reduce.width;
               this._tempRect.height = this.reduce.height;
               this._point.x = _loc7_;
               this._point.y = 0;
            }
            else
            {
               _loc4_ = this.numList[int(_loc3_)];
               this._tempRect.width = _loc4_.width;
               this._tempRect.height = _loc4_.height;
               this._tempRect.width = _loc4_.width;
               this._point.x = _loc7_;
               this._point.y = 0;
            }
            _loc7_ += _loc4_.width + this.gap;
            this._bitmapdata.copyPixels(_loc4_,this._tempRect,this._point);
            _loc5_++;
         }
         switch(param2)
         {
            case "center":
               _loc6_ = new BitmapData(this.rect.width,this.rect.height,true,0);
               this._tempRect.x = 0;
               this._tempRect.width = _loc7_;
               this._point.x = this._rect.width - _loc7_ >> 1;
               _loc6_.copyPixels(this._bitmapdata,this._tempRect,this._point);
               return _loc6_;
            case "right":
               _loc6_ = new BitmapData(this.rect.width,this.rect.height,true,0);
               this._tempRect.x = 0;
               this._tempRect.width = _loc7_;
               this._point.x = this._rect.width - _loc7_;
               _loc6_.copyPixels(this._bitmapdata,this._tempRect,this._point);
               return _loc6_;
            default:
               return this._bitmapdata;
         }
      }
      
      public function get rect() : Rectangle
      {
         return this._rect;
      }
      
      public function set rect(param1:Rectangle) : void
      {
         this._rect = param1;
         this._bitmapdata = new BitmapData(this._rect.width,this._rect.height);
         this._tempRect = new Rectangle(0,0,10,param1.height);
      }
   }
}
