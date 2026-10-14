package ddt.view.scenePathSearcher
{
   import ddt.utils.Geometry;
   import flash.geom.Point;
   
   public class PathRoboSearcher implements PathIPathSearcher
   {
      
      private static var LEFT:Number = -1;
      
      private static var RIGHT:Number = 1;
       
      
      private var step:Number;
      
      private var maxCount:Number;
      
      private var maxDistance:Number;
      
      private var stepTurnNum:Number;
      
      public function PathRoboSearcher(param1:Number, param2:Number, param3:Number = 4)
      {
         super();
         this.step = param1;
         this.maxDistance = param2;
         this.maxCount = Math.ceil(param2 / param1) * 2;
         this.stepTurnNum = param3;
      }
      
      public function setStepTurnNum(param1:Number) : void
      {
         this.stepTurnNum = param1;
      }
      
      public function search(param1:Point, param2:Point, param3:PathIHitTester) : Array
      {
         var _loc4_:Array = [param1,param1];
         if(param1.equals(param2))
         {
            return _loc4_;
         }
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         var _loc7_:Boolean = this.searchWithWish(param1,param2,param3,LEFT,_loc5_);
         var _loc8_:Boolean = this.searchWithWish(param1,param2,param3,RIGHT,_loc6_);
         if(_loc7_ && _loc8_)
         {
            if(_loc5_.length < _loc6_.length)
            {
               return _loc5_;
            }
            return _loc6_;
         }
         if(_loc7_)
         {
            return _loc5_;
         }
         if(_loc8_)
         {
            return _loc6_;
         }
         return _loc4_;
      }
      
      private function searchWithWish(param1:Point, param2:Point, param3:PathIHitTester, param4:Number, param5:Array) : Boolean
      {
         var _loc6_:Point = null;
         var _loc7_:Boolean = false;
         var _loc8_:Array = null;
         var _loc9_:Boolean = false;
         var _loc10_:Point = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Point = null;
         if(param3.isHit(param2))
         {
            param2 = this.findReversseNearestBlankPoint(param1,param2,param3);
            if(param2 == null)
            {
               return false;
            }
            if(param3.isHit(param1))
            {
               param5.push(param1);
               param5.push(param2);
               return true;
            }
         }
         else if(param3.isHit(param1))
         {
            _loc6_ = this.findReversseNearestBlankPoint(param2,param1,param3);
            if(_loc6_ == null)
            {
               return false;
            }
            _loc7_ = this.searchWithWish(_loc6_,param2,param3,param4,param5);
            if(_loc7_)
            {
               param5.splice(0,0,param1);
               return true;
            }
            return false;
         }
         if(Point.distance(param1,param2) > this.maxDistance)
         {
            param5.push(param1);
            param2 = this.findFarestBlankPoint(param1,param2,param3);
            if(param2 == null)
            {
               return false;
            }
            param5.push(param2);
            return true;
         }
         var _loc14_:Boolean = this.doSearchWithWish(param1,param2,param3,param4,param5);
         if(!_loc14_)
         {
            return false;
         }
         if(param5.length > 4)
         {
            _loc8_ = new Array();
            _loc9_ = this.doSearchWithWish(param2,param5[0],param3,0 - param4,_loc8_);
            if(_loc9_)
            {
               _loc10_ = Point(_loc8_[_loc8_.length - 2]);
               _loc11_ = this.step;
               _loc12_ = 1;
               while(_loc12_ < param5.length - 1)
               {
                  _loc13_ = Point(param5[_loc12_]);
                  if(Point.distance(_loc13_,_loc10_) < _loc11_)
                  {
                     param5.splice(1,_loc12_,_loc10_);
                     return true;
                  }
                  _loc12_++;
               }
            }
         }
         return true;
      }
      
      private function findFarestBlankPoint(param1:Point, param2:Point, param3:PathIHitTester) : Point
      {
         var _loc4_:Point = null;
         if(param3.isHit(param1))
         {
            return this.findReversseNearestBlankPoint(param2,param1,param3);
         }
         var _loc5_:Number = this.countHeading(param1,param2);
         var _loc6_:Number = Point.distance(param1,param2);
         var _loc7_:Point = param1;
         while(!param3.isHit(param1))
         {
            _loc7_ = param1;
            param1 = Geometry.nextPoint(param1,_loc5_,this.step);
            _loc6_ -= this.step;
            if(_loc6_ <= 0)
            {
               return null;
            }
         }
         param1 = _loc7_;
         var _loc8_:Number = 8;
         var _loc9_:Number = Math.PI / _loc8_;
         var _loc10_:Number = 1;
         while(_loc10_ < _loc8_)
         {
            _loc4_ = Geometry.nextPoint(param1,_loc5_ + _loc10_ * _loc9_,this.step * 2);
            if(!param3.isHit(_loc4_))
            {
               return _loc4_;
            }
            _loc4_ = Geometry.nextPoint(param1,_loc5_ - _loc10_ * _loc9_,this.step * 2);
            if(!param3.isHit(_loc4_))
            {
               return _loc4_;
            }
            _loc10_++;
         }
         return param1;
      }
      
      private function findReversseNearestBlankPoint(param1:Point, param2:Point, param3:PathIHitTester) : Point
      {
         var _loc4_:Point = null;
         var _loc5_:Number = this.countHeading(param2,param1);
         var _loc6_:Number = Point.distance(param2,param1);
         while(param3.isHit(param2))
         {
            param2 = Geometry.nextPoint(param2,_loc5_,this.step);
            _loc6_ -= this.step;
            if(_loc6_ <= 0)
            {
               return null;
            }
         }
         var _loc7_:Number = 12;
         var _loc8_:Number = Math.PI / _loc7_;
         _loc5_ += Math.PI;
         var _loc9_:Number = 1;
         while(_loc9_ < _loc7_)
         {
            _loc4_ = Geometry.nextPoint(param2,_loc5_ + _loc9_ * _loc8_,this.step * 2);
            if(!param3.isHit(_loc4_))
            {
               return _loc4_;
            }
            _loc4_ = Geometry.nextPoint(param2,_loc5_ - _loc9_ * _loc8_,this.step * 2);
            if(!param3.isHit(_loc4_))
            {
               return _loc4_;
            }
            _loc9_++;
         }
         return param2;
      }
      
      private function doSearchWithWish(param1:Point, param2:Point, param3:PathIHitTester, param4:Number, param5:Array) : Boolean
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Point = null;
         var _loc10_:Point = null;
         var _loc11_:Number = NaN;
         var _loc12_:Boolean = false;
         var _loc13_:Number = NaN;
         param5.push(param1);
         var _loc14_:Number = param4 * Math.PI / this.stepTurnNum;
         var _loc15_:Number = param4 * Math.PI / 2;
         var _loc16_:Number = 1;
         var _loc17_:Number = this.step;
         var _loc18_:Number = this.countHeading(param1,param2);
         var _loc19_:Number = Point.distance(param1,param2);
         while(true)
         {
            if(!(_loc19_ > _loc17_ && _loc16_++ < this.maxCount))
            {
               if(_loc16_ <= this.maxCount)
               {
                  param5.push(param2);
                  return true;
               }
               return false;
            }
            _loc6_ = this.countHeading(param1,param2);
            _loc7_ = _loc18_ - _loc15_;
            _loc8_ = this.bearing(_loc6_,_loc7_);
            if(param4 > 0 && _loc8_ < 0 || param4 < 0 && _loc8_ > 0)
            {
               _loc7_ = _loc6_;
            }
            _loc9_ = Geometry.nextPoint(param1,_loc7_,this.step);
            _loc10_ = param1;
            if(param3.isHit(_loc9_))
            {
               _loc12_ = false;
               _loc13_ = 2;
               while(_loc13_ < this.stepTurnNum * 2)
               {
                  _loc7_ += _loc14_;
                  _loc9_ = Geometry.nextPoint(param1,_loc7_,this.step);
                  if(!param3.isHit(_loc9_))
                  {
                     param1 = _loc9_;
                     _loc11_ = Point.distance(param1,param2);
                     _loc12_ = true;
                     break;
                  }
                  _loc13_++;
               }
               if(!_loc12_)
               {
                  break;
               }
            }
            else
            {
               param1 = _loc9_;
               _loc11_ = Point.distance(param1,param2);
            }
            if(Math.abs(this.bearing(_loc18_,_loc7_)) > 0.01)
            {
               param5.push(_loc10_);
               _loc18_ = _loc7_;
            }
            _loc19_ = _loc11_;
         }
         param5.splice(0);
         return false;
      }
      
      private function countHeading(param1:Point, param2:Point) : Number
      {
         return Math.atan2(param2.y - param1.y,param2.x - param1.x);
      }
      
      private function bearing(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = param2 - param1;
         _loc3_ = (_loc3_ + Math.PI * 4) % (Math.PI * 2);
         if(_loc3_ < -Math.PI)
         {
            _loc3_ += Math.PI * 2;
         }
         else if(_loc3_ > Math.PI)
         {
            _loc3_ -= Math.PI * 2;
         }
         return _loc3_;
      }
   }
}
