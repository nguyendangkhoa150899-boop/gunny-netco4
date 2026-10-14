package littleGame.data
{
   public class BinaryHeap
   {
       
      
      public var a:Array;
      
      private var _justMinFunc:Function;
      
      public function BinaryHeap(param1:Function)
      {
         this.a = new Array();
         super();
         this.a.push(-1);
         this._justMinFunc = param1;
      }
      
      public function ins(param1:Node) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = int(this.a.length);
         this.a[_loc3_] = param1;
         var _loc4_:int = _loc3_ >> 1;
         while(_loc3_ > 1 && this._justMinFunc(this.a[_loc3_],this.a[_loc4_]))
         {
            _loc2_ = this.a[_loc3_];
            this.a[_loc3_] = this.a[_loc4_];
            this.a[_loc4_] = _loc2_;
            _loc3_ = _loc4_;
            _loc4_ = _loc3_ >> 1;
         }
      }
      
      public function pop() : Node
      {
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         var _loc3_:Object = this.a[1];
         this.a[1] = this.a[this.a.length - 1];
         this.a.pop();
         var _loc4_:int = 1;
         var _loc5_:int = int(this.a.length);
         var _loc6_:int = _loc4_ << 1;
         var _loc7_:int = _loc6_ + 1;
         while(_loc6_ < _loc5_)
         {
            if(_loc7_ < _loc5_)
            {
               _loc1_ = Boolean(this._justMinFunc(this.a[_loc7_],this.a[_loc6_])) ? int(_loc7_) : int(_loc6_);
            }
            else
            {
               _loc1_ = _loc6_;
            }
            if(!this._justMinFunc(this.a[_loc1_],this.a[_loc4_]))
            {
               break;
            }
            _loc2_ = this.a[_loc4_];
            this.a[_loc4_] = this.a[_loc1_];
            this.a[_loc1_] = _loc2_;
            _loc4_ = _loc1_;
            _loc6_ = _loc4_ << 1;
            _loc7_ = _loc6_ + 1;
         }
         return _loc3_ as Node;
      }
   }
}
