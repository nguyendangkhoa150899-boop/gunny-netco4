package road7th.math
{
   import flash.geom.Point;
   
   public class XLine
   {
       
      
      protected var list:Array;
      
      protected var fix:Boolean = true;
      
      protected var fixValue:Number = 1;
      
      public function XLine(... rest)
      {
         super();
         this.line = rest;
      }
      
      public static function ToString(param1:Array) : String
      {
         var _loc2_:Point = null;
         var _loc3_:String = "";
         try
         {
            for each(_loc2_ in param1)
            {
               _loc3_ += _loc2_.x + ":" + _loc2_.y + ",";
            }
         }
         catch(e:Error)
         {
         }
         return _loc3_;
      }
      
      public static function parse(param1:String) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Array = new Array();
         try
         {
            _loc2_ = param1.match(/([-]?\d+[\.]?\d*)/g);
            _loc3_ = new Array();
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc5_.push(new Point(Number(_loc2_[_loc4_]),Number(_loc2_[_loc4_ + 1])));
               _loc4_ += 2;
            }
         }
         catch(e:Error)
         {
         }
         return _loc5_;
      }
      
      public function set line(param1:Array) : void
      {
         this.list = param1;
         if(this.list == null || this.list.length == 0)
         {
            this.fix = true;
            this.fixValue = 1;
         }
         else if(this.list.length == 1)
         {
            this.fix = true;
            this.fixValue = this.list[0].y;
         }
         else if(this.list.length == 2 && this.list[0].y == this.list[1].y)
         {
            this.fix = true;
            this.fixValue = this.list[0].y;
         }
         else
         {
            this.fix = false;
         }
      }
      
      public function get line() : Array
      {
         return this.list;
      }
      
      public function interpolate(param1:Number) : Number
      {
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc4_:int = 0;
         if(!this.fix)
         {
            _loc4_ = 1;
            while(_loc4_ < this.list.length)
            {
               _loc3_ = this.list[_loc4_];
               _loc2_ = this.list[_loc4_ - 1];
               if(_loc3_.x > param1)
               {
                  break;
               }
               _loc4_++;
            }
            return interpolatePointByX(_loc2_,_loc3_,param1);
         }
         return this.fixValue;
      }
   }
}
