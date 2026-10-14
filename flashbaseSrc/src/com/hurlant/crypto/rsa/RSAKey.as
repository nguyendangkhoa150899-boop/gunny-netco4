package com.hurlant.crypto.rsa
{
   import com.hurlant.crypto.prng.Random;
   import com.hurlant.math.BigInteger;
   import com.hurlant.util.Memory;
   import flash.utils.ByteArray;
   
   public class RSAKey
   {
       
      
      public var dmp1:BigInteger;
      
      protected var canDecrypt:Boolean;
      
      public var d:BigInteger;
      
      public var e:int;
      
      public var dmq1:BigInteger;
      
      public var n:BigInteger;
      
      public var p:BigInteger;
      
      public var q:BigInteger;
      
      protected var canEncrypt:Boolean;
      
      public var coeff:BigInteger;
      
      public function RSAKey(param1:BigInteger, param2:int, param3:BigInteger = null, param4:BigInteger = null, param5:BigInteger = null, param6:BigInteger = null, param7:BigInteger = null, param8:BigInteger = null)
      {
         super();
         this.n = param1;
         this.e = param2;
         this.d = param3;
         this.p = param4;
         this.q = param5;
         this.dmp1 = param6;
         this.dmq1 = param7;
         this.coeff = param8;
         this.canEncrypt = this.n != null && this.e != 0;
         this.canDecrypt = this.canEncrypt && this.d != null;
      }
      
      protected static function bigRandom(param1:int, param2:Random) : BigInteger
      {
         var _loc3_:ByteArray = null;
         var _loc4_:BigInteger = null;
         if(param1 < 2)
         {
            return BigInteger.nbv(1);
         }
         _loc3_ = new ByteArray();
         param2.nextBytes(_loc3_,param1 >> 3);
         _loc3_.position = 0;
         _loc4_ = new BigInteger(_loc3_);
         _loc4_.primify(param1,1);
         return _loc4_;
      }
      
      public static function parsePublicKey(param1:String, param2:String) : RSAKey
      {
         return new RSAKey(new BigInteger(param1,16),parseInt(param2,16));
      }
      
      public static function generate(param1:uint, param2:String) : RSAKey
      {
         var _loc3_:Random = null;
         var _loc4_:uint = 0;
         var _loc5_:RSAKey = null;
         var _loc6_:BigInteger = null;
         var _loc7_:BigInteger = null;
         var _loc8_:BigInteger = null;
         var _loc9_:BigInteger = null;
         var _loc10_:BigInteger = null;
         _loc3_ = new Random();
         _loc4_ = uint(param1 >> 1);
         _loc5_ = new RSAKey(null,0,null);
         _loc5_.e = parseInt(param2,16);
         _loc6_ = new BigInteger(param2,16);
         while(true)
         {
            while(true)
            {
               _loc5_.p = bigRandom(param1 - _loc4_,_loc3_);
               if(_loc5_.p.subtract(BigInteger.ONE).gcd(_loc6_).compareTo(BigInteger.ONE) == 0 && _loc5_.p.isProbablePrime(10))
               {
                  break;
               }
            }
            while(true)
            {
               _loc5_.q = bigRandom(_loc4_,_loc3_);
               if(_loc5_.q.subtract(BigInteger.ONE).gcd(_loc6_).compareTo(BigInteger.ONE) == 0 && _loc5_.q.isProbablePrime(10))
               {
                  break;
               }
            }
            if(_loc5_.p.compareTo(_loc5_.q) <= 0)
            {
               _loc10_ = _loc5_.p;
               _loc5_.p = _loc5_.q;
               _loc5_.q = _loc10_;
            }
            _loc7_ = _loc5_.p.subtract(BigInteger.ONE);
            _loc8_ = _loc5_.q.subtract(BigInteger.ONE);
            _loc9_ = _loc7_.multiply(_loc8_);
            if(_loc9_.gcd(_loc6_).compareTo(BigInteger.ONE) == 0)
            {
               _loc5_.n = _loc5_.p.multiply(_loc5_.q);
               _loc5_.d = _loc6_.modInverse(_loc9_);
               _loc5_.dmp1 = _loc5_.d.mod(_loc7_);
               _loc5_.dmq1 = _loc5_.d.mod(_loc8_);
               _loc5_.coeff = _loc5_.q.modInverse(_loc5_.p);
               break;
            }
         }
         return _loc5_;
      }
      
      public static function parsePrivateKey(param1:String, param2:String, param3:String, param4:String = null, param5:String = null, param6:String = null, param7:String = null, param8:String = null) : RSAKey
      {
         if(param4 == null)
         {
            return new RSAKey(new BigInteger(param1,16),parseInt(param2,16),new BigInteger(param3,16));
         }
         return new RSAKey(new BigInteger(param1,16),parseInt(param2,16),new BigInteger(param3,16),new BigInteger(param4,16),new BigInteger(param5,16),new BigInteger(param6,16),new BigInteger(param7),new BigInteger(param8));
      }
      
      public function verify(param1:ByteArray, param2:ByteArray, param3:uint, param4:Function = null) : void
      {
         this._decrypt(this.doPublic,param1,param2,param3,param4,1);
      }
      
      public function dump() : String
      {
         var _loc1_:String = null;
         _loc1_ = "N=" + this.n.toString(16) + "\n" + "E=" + this.e.toString(16) + "\n";
         if(this.canDecrypt)
         {
            _loc1_ += "D=" + this.d.toString(16) + "\n";
            if(this.p != null && this.q != null)
            {
               _loc1_ += "P=" + this.p.toString(16) + "\n";
               _loc1_ += "Q=" + this.q.toString(16) + "\n";
               _loc1_ += "DMP1=" + this.dmp1.toString(16) + "\n";
               _loc1_ += "DMQ1=" + this.dmq1.toString(16) + "\n";
               _loc1_ += "IQMP=" + this.coeff.toString(16) + "\n";
            }
         }
         return _loc1_;
      }
      
      protected function doPrivate2(param1:BigInteger) : BigInteger
      {
         var _loc2_:BigInteger = null;
         var _loc3_:BigInteger = null;
         var _loc4_:BigInteger = null;
         if(this.p == null && this.q == null)
         {
            return param1.modPow(this.d,this.n);
         }
         _loc2_ = param1.mod(this.p).modPow(this.dmp1,this.p);
         _loc3_ = param1.mod(this.q).modPow(this.dmq1,this.q);
         while(_loc2_.compareTo(_loc3_) < 0)
         {
            _loc2_ = _loc2_.add(this.p);
         }
         return _loc2_.subtract(_loc3_).multiply(this.coeff).mod(this.p).multiply(this.q).add(_loc3_);
      }
      
      public function decrypt(param1:ByteArray, param2:ByteArray, param3:uint, param4:Function = null) : void
      {
         this._decrypt(this.doPrivate2,param1,param2,param3,param4,2);
      }
      
      private function _decrypt(param1:Function, param2:ByteArray, param3:ByteArray, param4:uint, param5:Function, param6:int) : void
      {
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:BigInteger = null;
         var _loc10_:BigInteger = null;
         var _loc11_:ByteArray = null;
         if(param5 == null)
         {
            param5 = this.pkcs1unpad;
         }
         if(param2.position >= param2.length)
         {
            param2.position = 0;
         }
         _loc7_ = this.getBlockSize();
         _loc8_ = int(param2.position + param4);
         while(param2.position < _loc8_)
         {
            _loc9_ = new BigInteger(param2,param4);
            _loc10_ = param1(_loc9_);
            _loc11_ = param5(_loc10_,_loc7_);
            param3.writeBytes(_loc11_);
         }
      }
      
      protected function doPublic(param1:BigInteger) : BigInteger
      {
         return param1.modPowInt(this.e,this.n);
      }
      
      public function dispose() : void
      {
         this.e = 0;
         this.n.dispose();
         this.n = null;
         Memory.gc();
      }
      
      private function _encrypt(param1:Function, param2:ByteArray, param3:ByteArray, param4:uint, param5:Function, param6:int) : void
      {
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:BigInteger = null;
         var _loc10_:BigInteger = null;
         if(param5 == null)
         {
            param5 = this.pkcs1pad;
         }
         if(param2.position >= param2.length)
         {
            param2.position = 0;
         }
         _loc7_ = this.getBlockSize();
         _loc8_ = int(param2.position + param4);
         while(param2.position < _loc8_)
         {
            _loc9_ = new BigInteger(param5(param2,_loc8_,_loc7_,param6),_loc7_);
            _loc10_ = param1(_loc9_);
            _loc10_.toArray(param3);
         }
      }
      
      private function rawpad(param1:ByteArray, param2:int, param3:uint) : ByteArray
      {
         return param1;
      }
      
      public function encrypt(param1:ByteArray, param2:ByteArray, param3:uint, param4:Function = null) : void
      {
         this._encrypt(this.doPublic,param1,param2,param3,param4,2);
      }
      
      private function pkcs1pad(param1:ByteArray, param2:int, param3:uint, param4:uint = 2) : ByteArray
      {
         var _loc5_:ByteArray = null;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:Random = null;
         var _loc9_:int = 0;
         _loc5_ = new ByteArray();
         _loc6_ = param1.position;
         param2 = Math.min(param2,param1.length,_loc6_ + param3 - 11);
         param1.position = param2;
         _loc7_ = param2 - 1;
         while(_loc7_ >= _loc6_ && param3 > 11)
         {
            var _loc11_:* = --param3;
            _loc5_[_loc11_] = param1[_loc7_--];
         }
         _loc11_ = --param3;
         _loc5_[_loc11_] = 0;
         _loc8_ = new Random();
         while(param3 > 2)
         {
            _loc9_ = 0;
            while(_loc9_ == 0)
            {
               _loc9_ = param4 == 2 ? int(_loc8_.nextByte()) : int(255);
            }
            var _loc12_:* = --param3;
            _loc5_[_loc12_] = _loc9_;
         }
         _loc12_ = --param3;
         _loc5_[_loc12_] = param4;
         var _loc10_:* = --param3;
         _loc5_[_loc10_] = 0;
         return _loc5_;
      }
      
      private function pkcs1unpad(param1:BigInteger, param2:uint, param3:uint = 2) : ByteArray
      {
         var _loc4_:ByteArray = null;
         var _loc5_:ByteArray = null;
         var _loc6_:int = 0;
         _loc4_ = param1.toByteArray();
         _loc5_ = new ByteArray();
         _loc6_ = 0;
         while(_loc6_ < _loc4_.length && _loc4_[_loc6_] == 0)
         {
            _loc6_++;
         }
         if(_loc4_.length - _loc6_ != param2 - 1 || _loc4_[_loc6_] > 2)
         {
            return null;
         }
         _loc6_++;
         while(_loc4_[_loc6_] != 0)
         {
            if(++_loc6_ >= _loc4_.length)
            {
               return null;
            }
         }
         while(++_loc6_ < _loc4_.length)
         {
            _loc5_.writeByte(_loc4_[_loc6_]);
         }
         _loc5_.position = 0;
         return _loc5_;
      }
      
      public function getBlockSize() : uint
      {
         return (this.n.bitLength() + 7) / 8;
      }
      
      public function toString() : String
      {
         return "rsa";
      }
      
      public function sign(param1:ByteArray, param2:ByteArray, param3:uint, param4:Function = null) : void
      {
         this._encrypt(this.doPrivate2,param1,param2,param3,param4,1);
      }
      
      protected function doPrivate(param1:BigInteger) : BigInteger
      {
         var _loc2_:BigInteger = null;
         var _loc3_:BigInteger = null;
         if(this.p == null || this.q == null)
         {
            return param1.modPow(this.d,this.n);
         }
         _loc2_ = param1.mod(this.p).modPow(this.dmp1,this.p);
         _loc3_ = param1.mod(this.q).modPow(this.dmq1,this.q);
         while(_loc2_.compareTo(_loc3_) < 0)
         {
            _loc2_ = _loc2_.add(this.p);
         }
         return _loc2_.subtract(_loc3_).multiply(this.coeff).mod(this.p).multiply(this.q).add(_loc3_);
      }
   }
}
