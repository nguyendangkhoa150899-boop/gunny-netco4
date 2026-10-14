package com.hurlant.math
{
   internal class BarrettReduction implements IReduction
   {
       
      
      private var r2:com.hurlant.math.BigInteger;
      
      private var q3:com.hurlant.math.BigInteger;
      
      private var mu:com.hurlant.math.BigInteger;
      
      private var m:com.hurlant.math.BigInteger;
      
      public function BarrettReduction(param1:com.hurlant.math.BigInteger)
      {
         super();
         this.r2 = new com.hurlant.math.BigInteger();
         this.q3 = new com.hurlant.math.BigInteger();
         BigInteger.ONE.bi_internal::dlShiftTo(2 * param1.t,this.r2);
         this.mu = this.r2.divide(param1);
         this.m = param1;
      }
      
      public function reduce(param1:com.hurlant.math.BigInteger) : void
      {
         var _loc2_:com.hurlant.math.BigInteger = null;
         _loc2_ = param1 as BigInteger;
         _loc2_.bi_internal::drShiftTo(this.m.t - 1,this.r2);
         if(_loc2_.t > this.m.t + 1)
         {
            _loc2_.t = this.m.t + 1;
            _loc2_.bi_internal::clamp();
         }
         this.mu.bi_internal::multiplyUpperTo(this.r2,this.m.t + 1,this.q3);
         this.m.bi_internal::multiplyLowerTo(this.q3,this.m.t + 1,this.r2);
         while(_loc2_.compareTo(this.r2) < 0)
         {
            _loc2_.bi_internal::dAddOffset(1,this.m.t + 1);
         }
         _loc2_.bi_internal::subTo(this.r2,_loc2_);
         while(_loc2_.compareTo(this.m) >= 0)
         {
            _loc2_.bi_internal::subTo(this.m,_loc2_);
         }
      }
      
      public function revert(param1:com.hurlant.math.BigInteger) : com.hurlant.math.BigInteger
      {
         return param1;
      }
      
      public function convert(param1:com.hurlant.math.BigInteger) : com.hurlant.math.BigInteger
      {
         var _loc2_:com.hurlant.math.BigInteger = null;
         if(param1.bi_internal::s < 0 || param1.t > 2 * this.m.t)
         {
            return param1.mod(this.m);
         }
         if(param1.compareTo(this.m) < 0)
         {
            return param1;
         }
         _loc2_ = new com.hurlant.math.BigInteger();
         param1.bi_internal::copyTo(_loc2_);
         this.reduce(_loc2_);
         return _loc2_;
      }
      
      public function sqrTo(param1:com.hurlant.math.BigInteger, param2:com.hurlant.math.BigInteger) : void
      {
         param1.bi_internal::squareTo(param2);
         this.reduce(param2);
      }
      
      public function mulTo(param1:com.hurlant.math.BigInteger, param2:com.hurlant.math.BigInteger, param3:com.hurlant.math.BigInteger) : void
      {
         param1.bi_internal::multiplyTo(param2,param3);
         this.reduce(param3);
      }
   }
}
