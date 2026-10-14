package
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ComplexItem extends BitmapRendItem
   {
       
      
      protected var _items:Vector.<BitmapRendItem>;
      
      private var item:BitmapRendItem;
      
      private var tempcopyInfo:Array;
      
      public function ComplexItem(param1:Number, param2:Number, param3:String = "original", param4:String = "auto", param5:Boolean = false)
      {
         super(param1,param2,param3,param4,param5);
         _type = BitmapRendItem.COMPLEX;
         this._items = new Vector.<BitmapRendItem>();
      }
      
      public function addItem(param1:FrameByFrameItem) : void
      {
         this._items.push(param1);
         if(rendMode == BitmapRendMode.COPY_PIXEL)
         {
            param1.scaleX = scaleX;
         }
      }
      
      public function removeItem(param1:FrameByFrameItem) : void
      {
         var _loc2_:int = this._items.indexOf(param1);
         if(_loc2_ > -1)
         {
            this._items.splice(_loc2_,1);
         }
      }
      
      override public function set scaleX(param1:Number) : void
      {
         var _loc2_:BitmapRendItem = null;
         super.scaleX = param1;
         if(rendMode == BitmapRendMode.COPY_PIXEL)
         {
            for each(_loc2_ in this._items)
            {
               _loc2_.scaleX = scaleX;
            }
         }
      }
      
      override protected function update() : void
      {
         var _loc1_:BitmapRendItem = null;
         var _loc2_:int = 0;
         if(_realRender && rendMode != BitmapRendMode.COPY_PIXEL)
         {
            bitmapData.lock();
            bitmapData.fillRect(_selfRect,0);
            _loc2_ = 0;
            while(_loc2_ < this._items.length)
            {
               _loc1_ = this._items[_loc2_];
               bitmapData.copyPixels(_loc1_.copyInfo[0],_loc1_.copyInfo[1],_loc1_.copyInfo[2],null,null,true);
               _loc2_++;
            }
            bitmapData.unlock();
         }
      }
      
      override internal function get copyInfo() : Array
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < this._items.length)
         {
            this.item = this._items[_loc3_];
            this.tempcopyInfo = this.item.copyInfo;
            _loc2_.push(this.tempcopyInfo[0]);
            if(scaleX == 1)
            {
               _loc2_.push(this.tempcopyInfo[1]);
               _loc2_.push(new Point(x + this.item.x,y + this.item.y));
            }
            else
            {
               _loc1_ = Rectangle(this.tempcopyInfo[1]);
               _loc2_.push(new Rectangle(x + this.item.x,y + this.item.y,_loc1_.width,_loc1_.height));
               _loc2_.push(new Point(-x + this.tempcopyInfo[2].x,y + this.tempcopyInfo[2].y));
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._items = null;
         this.item = null;
         this.tempcopyInfo = null;
      }
      
      override public function get typeToString() : String
      {
         return "复杂位图影片";
      }
      
      override public function toXml() : XML
      {
         var _loc1_:BitmapRendItem = null;
         var _loc2_:XML = <asset></asset>;
         var _loc3_:int = 0;
         while(_loc3_ < this._items.length)
         {
            _loc1_ = this._items[_loc3_];
            _loc2_.appendChild(_loc1_.toXml());
            _loc3_++;
         }
         _loc2_.@width = _itemWidth;
         _loc2_.@height = _itemHeight;
         _loc2_.@name = name;
         _loc2_.@type = _type;
         _loc2_.@x = x;
         _loc2_.@y = y;
         _loc2_.@rendMode = rendMode;
         return _loc2_;
      }
   }
}
