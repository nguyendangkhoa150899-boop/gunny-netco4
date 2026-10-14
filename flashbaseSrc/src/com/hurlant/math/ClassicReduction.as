package com.hurlant.math
{
   internal class ClassicReduction implements IReduction
   {
       
      
      private var m:com.hurlant.math.BigInteger;
      
      public function ClassicReduction(param1:com.hurlant.math.BigInteger)
      {
         super();
         this.m = param1;
      }
      
      public function revert(param1:com.hurlant.math.BigInteger) : com.hurlant.math.BigInteger
      {
         return param1;
      }
      
      public function reduce(param1:com.hurlant.math.BigInteger) : void
      {
         param1.bi_internal::divRemTo(this.m,null,param1);
      }
      
      public function convert(param1:com.hurlant.math.BigInteger) : com.hurlant.math.BigInteger
      {
         if(param1.bi_internal::s < 0 || param1.compareTo(this.m) >= 0)
         {
            return param1.mod(this.m);
         }
         return param1;
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
