package com.hurlant.math
{
   internal class MontgomeryReduction implements IReduction
   {
       
      
      private var um:int;
      
      private var mp:int;
      
      private var mph:int;
      
      private var mpl:int;
      
      private var mt2:int;
      
      private var m:com.hurlant.math.BigInteger;
      
      public function MontgomeryReduction(param1:com.hurlant.math.BigInteger)
      {
         super();
         this.m = param1;
         this.mp = param1.bi_internal::invDigit();
         this.mpl = this.mp & 32767;
         this.mph = this.mp >> 15;
         this.um = (1 << BigInteger.DB - 15) - 1;
         this.mt2 = 2 * param1.t;
      }
      
      public function mulTo(param1:com.hurlant.math.BigInteger, param2:com.hurlant.math.BigInteger, param3:com.hurlant.math.BigInteger) : void
      {
         param1.bi_internal::multiplyTo(param2,param3);
         this.reduce(param3);
      }
      
      public function revert(param1:com.hurlant.math.BigInteger) : com.hurlant.math.BigInteger
      {
         var _loc2_:com.hurlant.math.BigInteger = null;
         _loc2_ = new com.hurlant.math.BigInteger();
         param1.bi_internal::copyTo(_loc2_);
         this.reduce(_loc2_);
         return _loc2_;
      }
      
      public function convert(param1:com.hurlant.math.BigInteger) : com.hurlant.math.BigInteger
      {
         var _loc2_:com.hurlant.math.BigInteger = null;
         _loc2_ = new com.hurlant.math.BigInteger();
         param1.abs().bi_internal::dlShiftTo(this.m.t,_loc2_);
         _loc2_.bi_internal::divRemTo(this.m,null,_loc2_);
         if(param1.bi_internal::s < 0 && _loc2_.compareTo(BigInteger.ZERO) > 0)
         {
            this.m.bi_internal::subTo(_loc2_,_loc2_);
         }
         return _loc2_;
      }
      
      public function reduce(param1:com.hurlant.math.BigInteger) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(param1.t <= this.mt2)
         {
            var _loc5_:* = param1.t++;
            param1.bi_internal::a[_loc5_] = 0;
         }
         _loc2_ = 0;
         while(_loc2_ < this.m.t)
         {
            _loc3_ = param1.bi_internal::a[_loc2_] & 32767;
            _loc4_ = _loc3_ * this.mpl + ((_loc3_ * this.mph + (param1.bi_internal::a[_loc2_] >> 15) * this.mpl & this.um) << 15) & BigInteger.DM;
            _loc3_ = _loc2_ + this.m.t;
            param1.bi_internal::a[_loc3_] += this.m.bi_internal::am(0,_loc4_,param1,_loc2_,0,this.m.t);
            while(param1.bi_internal::a[_loc3_] >= BigInteger.DV)
            {
               param1.bi_internal::a[_loc3_] -= BigInteger.DV;
               ++param1.bi_internal::a[++_loc3_];
            }
            _loc2_++;
         }
         param1.bi_internal::clamp();
         param1.bi_internal::drShiftTo(this.m.t,param1);
         if(param1.compareTo(this.m) >= 0)
         {
            param1.bi_internal::subTo(this.m,param1);
         }
      }
      
      public function sqrTo(param1:com.hurlant.math.BigInteger, param2:com.hurlant.math.BigInteger) : void
      {
         param1.bi_internal::squareTo(param2);
         this.reduce(param2);
      }
   }
}
