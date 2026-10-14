package ddt.view.scenePathSearcher
{
   import flash.geom.Point;
   
   public class PathAstarSearcher implements PathIPathSearcher
   {
       
      
      private var open_list:Array;
      
      private var close_list:Array;
      
      private var path_arr:Array;
      
      private var setOut_point:ddt.view.scenePathSearcher.PathAstarPoint;
      
      private var aim_point:ddt.view.scenePathSearcher.PathAstarPoint;
      
      private var current_point:ddt.view.scenePathSearcher.PathAstarPoint;
      
      private var step_len:int;
      
      private var hittest:ddt.view.scenePathSearcher.PathIHitTester;
      
      private var record_start_point:ddt.view.scenePathSearcher.PathAstarPoint;
      
      public function PathAstarSearcher(param1:int)
      {
         super();
         this.step_len = param1;
      }
      
      public function search(param1:Point, param2:Point, param3:ddt.view.scenePathSearcher.PathIHitTester) : Array
      {
         this.aim_point = new ddt.view.scenePathSearcher.PathAstarPoint(param2.x,param2.y);
         this.record_start_point = new ddt.view.scenePathSearcher.PathAstarPoint(param1.x,param1.y);
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param2.x > param1.x)
         {
            _loc4_ = param1.x - (this.step_len - Math.abs(param2.x - param1.x) % this.step_len);
         }
         else
         {
            _loc4_ = param1.x + (this.step_len - Math.abs(param2.x - param1.x) % this.step_len);
         }
         if(param2.y > param1.y)
         {
            _loc5_ = param1.y - (this.step_len - Math.abs(param2.y - param1.y) % this.step_len);
         }
         else
         {
            _loc5_ = param1.y + (this.step_len - Math.abs(param2.y - param1.y) % this.step_len);
         }
         this.setOut_point = new ddt.view.scenePathSearcher.PathAstarPoint(_loc4_,_loc5_);
         this.current_point = this.setOut_point;
         this.hittest = param3;
         this.init();
         this.findPath();
         return this.path_arr;
      }
      
      private function init() : void
      {
         this.open_list = new Array();
         this.close_list = new Array();
         this.path_arr = new Array();
      }
      
      private function findPath() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         this.open_list.push(this.setOut_point);
         var _loc6_:Boolean = true;
         while(this.open_list.length > 0 && _loc6_)
         {
            this.current_point = this.open_list.shift();
            if(this.current_point.x == this.aim_point.x && this.current_point.y == this.aim_point.y)
            {
               _loc6_ = false;
               this.aim_point = _loc1_[_loc5_];
               this.aim_point.source_point = this.current_point;
               break;
            }
            _loc1_ = new Array();
            _loc1_ = this.createNode(this.current_point);
            _loc2_ = 0;
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = 0;
            while(_loc5_ < _loc1_.length)
            {
               if(_loc1_[_loc5_].x == this.aim_point.x && _loc1_[_loc5_].y == this.aim_point.y)
               {
                  _loc6_ = false;
                  this.aim_point = _loc1_[_loc5_];
                  this.aim_point.source_point = this.current_point;
                  break;
               }
               if(this.existInArray(this.open_list,_loc1_[_loc5_]) == -1 && this.existInArray(this.close_list,_loc1_[_loc5_]) == -1)
               {
                  if(!this.hittest.isHit(_loc1_[_loc5_]))
                  {
                     _loc1_[_loc5_].source_point = this.current_point;
                     _loc2_ = this.getEvaluateG(_loc1_[_loc5_]);
                     _loc4_ = this.getEvaluateH(_loc1_[_loc5_]);
                     this.setEvaluate(_loc1_[_loc5_],_loc2_,_loc4_);
                     this.open_list.push(_loc1_[_loc5_]);
                  }
               }
               else if(this.existInArray(this.open_list,_loc1_[_loc5_]) != -1)
               {
                  _loc2_ = this.getEvaluateG(_loc1_[_loc5_]);
                  _loc4_ = this.getEvaluateH(_loc1_[_loc5_]);
                  _loc3_ = _loc2_ + _loc4_;
                  if(_loc3_ < _loc1_[_loc5_].f)
                  {
                     _loc1_[_loc5_].source_point = this.current_point;
                     this.setEvaluate(_loc1_[_loc5_],_loc2_,_loc4_);
                  }
               }
               else
               {
                  _loc2_ = this.getEvaluateG(_loc1_[_loc5_]);
                  _loc4_ = this.getEvaluateH(_loc1_[_loc5_]);
                  _loc3_ = _loc2_ + _loc4_;
                  if(_loc3_ < _loc1_[_loc5_].f)
                  {
                     _loc1_[_loc5_].source_point = this.current_point;
                     this.setEvaluate(_loc1_[_loc5_],_loc2_,_loc4_);
                     this.open_list.push(_loc1_[_loc5_]);
                     this.close_list.splice(this.existInArray(this.close_list,_loc1_[_loc5_]),1);
                  }
               }
               _loc5_++;
            }
            this.close_list.push(this.current_point);
            this.open_list.sortOn("f",Array.NUMERIC);
            if(this.open_list.length > 30)
            {
               this.open_list = this.open_list.slice(0,30);
            }
         }
         this.createPath();
      }
      
      private function createPath() : void
      {
         var _loc1_:ddt.view.scenePathSearcher.PathAstarPoint = new ddt.view.scenePathSearcher.PathAstarPoint();
         _loc1_ = this.aim_point;
         while(_loc1_ != this.setOut_point)
         {
            this.path_arr.unshift(_loc1_);
            if(_loc1_.source_point == null)
            {
               this.path_arr = new Array();
               this.path_arr.push(this.record_start_point,this.record_start_point);
               return;
            }
            _loc1_ = _loc1_.source_point;
         }
         this.path_arr.splice(0,0,this.record_start_point);
      }
      
      private function setEvaluate(param1:ddt.view.scenePathSearcher.PathAstarPoint, param2:Number, param3:Number) : void
      {
         param1.g = param2;
         param1.h = param3;
         param1.f = param1.g + param1.h;
      }
      
      private function getEvaluateG(param1:ddt.view.scenePathSearcher.PathAstarPoint) : int
      {
         var _loc2_:int = 0;
         if(this.current_point.x == param1.x || this.current_point.y == param1.y)
         {
            _loc2_ = 10;
         }
         else
         {
            _loc2_ = 14;
         }
         return _loc2_ + this.current_point.g;
      }
      
      private function getEvaluateH(param1:ddt.view.scenePathSearcher.PathAstarPoint) : int
      {
         return Math.abs(this.aim_point.x - param1.x) * 10 + Math.abs(this.aim_point.y - param1.y) * 10;
      }
      
      private function createNode(param1:ddt.view.scenePathSearcher.PathAstarPoint) : Array
      {
         var _loc2_:Array = new Array();
         _loc2_.push(new ddt.view.scenePathSearcher.PathAstarPoint(param1.x,param1.y - this.step_len));
         _loc2_.push(new ddt.view.scenePathSearcher.PathAstarPoint(param1.x - this.step_len,param1.y));
         _loc2_.push(new ddt.view.scenePathSearcher.PathAstarPoint(param1.x + this.step_len,param1.y));
         _loc2_.push(new ddt.view.scenePathSearcher.PathAstarPoint(param1.x,param1.y + this.step_len));
         _loc2_.push(new ddt.view.scenePathSearcher.PathAstarPoint(param1.x - this.step_len,param1.y - this.step_len));
         _loc2_.push(new ddt.view.scenePathSearcher.PathAstarPoint(param1.x + this.step_len,param1.y - this.step_len));
         _loc2_.push(new ddt.view.scenePathSearcher.PathAstarPoint(param1.x - this.step_len,param1.y + this.step_len));
         _loc2_.push(new ddt.view.scenePathSearcher.PathAstarPoint(param1.x + this.step_len,param1.y + this.step_len));
         return _loc2_;
      }
      
      private function existInArray(param1:Array, param2:ddt.view.scenePathSearcher.PathAstarPoint) : int
      {
         var _loc3_:int = -1;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(param1[_loc4_].x == param2.x && param1[_loc4_].y == param2.y)
            {
               _loc3_ = _loc4_;
               break;
            }
            _loc4_++;
         }
         return _loc3_;
      }
   }
}
