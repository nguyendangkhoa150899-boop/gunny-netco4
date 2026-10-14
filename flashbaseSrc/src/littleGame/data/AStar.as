package littleGame.data
{
   import com.pickgliss.ui.core.Disposeable;
   import flash.geom.Point;
   import flash.utils.getTimer;
   
   public class AStar implements Disposeable
   {
       
      
      public var heuristic:Function;
      
      private var _straightCost:Number = 1;
      
      private var _diagCost:Number = 1.41421;
      
      private var nowversion:int = 0;
      
      private var TwoOneTwoZero:Number;
      
      private var _endNode:littleGame.data.Node;
      
      private var _startNode:littleGame.data.Node;
      
      private var _grid:littleGame.data.Grid;
      
      private var _open:littleGame.data.BinaryHeap;
      
      private var _path:Array;
      
      private var _floydPath:Array;
      
      public function AStar(param1:littleGame.data.Grid)
      {
         this.TwoOneTwoZero = 2 * Math.cos(Math.PI / 3);
         super();
         this._grid = param1;
         this.heuristic = this.euclidian2;
      }
      
      public function dispose() : void
      {
         this._open = null;
         this.heuristic = null;
         this._endNode = this._startNode = null;
         this._grid = null;
         this._path = null;
      }
      
      private function justMin(param1:littleGame.data.Node, param2:littleGame.data.Node) : Boolean
      {
         return param1.f < param2.f;
      }
      
      public function manhattan(param1:littleGame.data.Node) : Number
      {
         return Math.abs(param1.x - this._endNode.x) + Math.abs(param1.y - this._endNode.y);
      }
      
      public function manhattan2(param1:littleGame.data.Node) : Number
      {
         var _loc2_:Number = Math.abs(param1.x - this._endNode.x);
         var _loc3_:Number = Math.abs(param1.y - this._endNode.y);
         return _loc2_ + _loc3_ + Math.abs(_loc2_ - _loc3_) / 1000;
      }
      
      public function euclidian(param1:littleGame.data.Node) : Number
      {
         var _loc2_:Number = param1.x - this._endNode.x;
         var _loc3_:Number = param1.y - this._endNode.y;
         return Math.sqrt(_loc2_ * _loc2_ + _loc3_ * _loc3_);
      }
      
      public function chineseCheckersEuclidian2(param1:littleGame.data.Node) : Number
      {
         var _loc2_:Number = param1.y / this.TwoOneTwoZero;
         var _loc3_:Number = param1.x + param1.y / 2;
         var _loc4_:Number = _loc3_ - this._endNode.x - this._endNode.y / 2;
         var _loc5_:Number = _loc2_ - this._endNode.y / this.TwoOneTwoZero;
         return this.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_);
      }
      
      private function sqrt(param1:Number) : Number
      {
         return Math.sqrt(param1);
      }
      
      public function euclidian2(param1:littleGame.data.Node) : Number
      {
         var _loc2_:Number = param1.x - this._endNode.x;
         var _loc3_:Number = param1.y - this._endNode.y;
         return _loc2_ * _loc2_ + _loc3_ * _loc3_;
      }
      
      public function fillPath() : Boolean
      {
         this._endNode = this._grid.endNode;
         this._startNode = this._grid.startNode;
         ++this.nowversion;
         this._open = new littleGame.data.BinaryHeap(this.justMin);
         this._startNode.g = 0;
         var _loc1_:int = getTimer();
         return Boolean(this.search());
      }
      
      public function search() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:littleGame.data.Node = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:littleGame.data.Node = this._startNode;
         _loc8_.version = this.nowversion;
         while(_loc8_ != this._endNode)
         {
            _loc1_ = int(_loc8_.links.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = _loc8_.links[_loc2_].node;
               _loc4_ = Number(_loc8_.links[_loc2_].cost);
               _loc5_ = _loc8_.g + _loc4_;
               _loc6_ = this.heuristic(_loc3_);
               _loc7_ = _loc5_ + _loc6_;
               if(_loc3_.version == this.nowversion)
               {
                  if(_loc3_.f > _loc7_)
                  {
                     _loc3_.f = _loc7_;
                     _loc3_.g = _loc5_;
                     _loc3_.h = _loc6_;
                     _loc3_.parent = _loc8_;
                  }
               }
               else
               {
                  _loc3_.f = _loc7_;
                  _loc3_.g = _loc5_;
                  _loc3_.h = _loc6_;
                  _loc3_.parent = _loc8_;
                  this._open.ins(_loc3_);
                  _loc3_.version = this.nowversion;
               }
               _loc2_++;
            }
            if(this._open.a.length == 1)
            {
               return false;
            }
            _loc8_ = this._open.pop() as Node;
         }
         this.buildPath();
         return true;
      }
      
      private function buildPath() : void
      {
         this._path = [];
         var _loc1_:littleGame.data.Node = this._endNode;
         this._path.push(_loc1_);
         while(_loc1_ != this._startNode)
         {
            _loc1_ = _loc1_.parent;
            this._path.unshift(_loc1_);
         }
      }
      
      public function get path() : Array
      {
         return this._path;
      }
      
      public function floyd() : void
      {
         var _loc1_:littleGame.data.Node = null;
         var _loc2_:littleGame.data.Node = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this.path == null)
         {
            return;
         }
         this._floydPath = this.path.concat();
         var _loc6_:int = int(this._floydPath.length);
         if(_loc6_ > 2)
         {
            _loc1_ = new littleGame.data.Node(0,0);
            _loc2_ = new littleGame.data.Node(0,0);
            this.floydVector(_loc1_,this._floydPath[_loc6_ - 1],this._floydPath[_loc6_ - 2]);
            _loc3_ = this._floydPath.length - 3;
            while(_loc3_ >= 0)
            {
               this.floydVector(_loc2_,this._floydPath[_loc3_ + 1],this._floydPath[_loc3_]);
               if(_loc1_.x == _loc2_.x && _loc1_.y == _loc2_.y)
               {
                  this._floydPath.splice(_loc3_ + 1,1);
               }
               else
               {
                  _loc1_.x = _loc2_.x;
                  _loc1_.y = _loc2_.y;
               }
               _loc3_--;
            }
         }
         _loc6_ = int(this._floydPath.length);
         _loc3_ = _loc6_ - 1;
         while(_loc3_ >= 0)
         {
            _loc4_ = 0;
            while(_loc4_ <= _loc3_ - 2)
            {
               if(this.floydCrossAble(this._floydPath[_loc3_],this._floydPath[_loc4_]))
               {
                  _loc5_ = _loc3_ - 1;
                  while(_loc5_ > _loc4_)
                  {
                     this._floydPath.splice(_loc5_,1);
                     _loc5_--;
                  }
                  _loc3_ = _loc4_;
                  _loc6_ = int(this._floydPath.length);
                  break;
               }
               _loc4_++;
            }
            _loc3_--;
         }
      }
      
      private function floydCrossAble(param1:littleGame.data.Node, param2:littleGame.data.Node) : Boolean
      {
         var _loc3_:Array = this.bresenhamNodes(new Point(param1.x,param1.y),new Point(param2.x,param2.y));
         var _loc4_:int = _loc3_.length - 2;
         while(_loc4_ > 0)
         {
            if(!this._grid.getNode(_loc3_[_loc4_].x,_loc3_[_loc4_].y).walkable)
            {
               return false;
            }
            _loc4_--;
         }
         return true;
      }
      
      private function floydVector(param1:littleGame.data.Node, param2:littleGame.data.Node, param3:littleGame.data.Node) : void
      {
         param1.x = param2.x - param3.x;
         param1.y = param2.y - param3.y;
      }
      
      private function bresenhamNodes(param1:Point, param2:Point) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = Math.abs(param2.y - param1.y) > Math.abs(param2.x - param1.x);
         if(_loc6_)
         {
            _loc3_ = param1.x;
            param1.x = param1.y;
            param1.y = _loc3_;
            _loc3_ = param2.x;
            param2.x = param2.y;
            param2.y = _loc3_;
         }
         var _loc7_:int = param2.x > param1.x ? int(1) : (param2.x < param1.x ? int(-1) : int(0));
         var _loc8_:int = param2.y > param1.y ? int(1) : (param2.y < param1.y ? int(-1) : int(0));
         var _loc9_:Number = (param2.y - param1.y) / Math.abs(param2.x - param1.x);
         var _loc10_:Array = [];
         var _loc11_:Number = param1.x + _loc7_;
         var _loc12_:Number = param1.y + _loc9_;
         if(_loc6_)
         {
            _loc10_.push(new Point(param1.y,param1.x));
         }
         else
         {
            _loc10_.push(new Point(param1.x,param1.y));
         }
         while(_loc11_ != param2.x)
         {
            _loc4_ = Math.floor(_loc12_);
            _loc5_ = Math.ceil(_loc12_);
            if(_loc6_)
            {
               _loc10_.push(new Point(_loc4_,_loc11_));
            }
            else
            {
               _loc10_.push(new Point(_loc11_,_loc4_));
            }
            if(_loc4_ != _loc5_)
            {
               if(_loc6_)
               {
                  _loc10_.push(new Point(_loc5_,_loc11_));
               }
               else
               {
                  _loc10_.push(new Point(_loc11_,_loc5_));
               }
            }
            _loc11_ += _loc7_;
            _loc12_ += _loc9_;
         }
         if(_loc6_)
         {
            _loc10_.push(new Point(param2.y,param2.x));
         }
         else
         {
            _loc10_.push(new Point(param2.x,param2.y));
         }
         return _loc10_;
      }
      
      public function get floydPath() : Array
      {
         return this._floydPath;
      }
   }
}
