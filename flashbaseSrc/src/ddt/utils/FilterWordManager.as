package ddt.utils
{
   import ddt.data.analyze.FilterWordAnalyzer;
   import road7th.utils.StringHelper;
   
   public class FilterWordManager
   {
      
      private static var unableChar:String = "";
      
      private static var CHANNEL_WORDS:Array = ["当前","公会","组队","私聊","小喇叭","大喇叭","跨区大喇叭"];
      
      private static var WORDS:Array = [];
      
      private static var SERVER_WORDS:Array = [];
      
      private static var REPLACEWORD:String = "~!@#$@#$%~!@#$@#%^&@~!@#$@##$%*~!@#$$@#%^&@~!@#$@#@#";
      
      private static const FILTER_TYPE_ALL:String = "all";
      
      private static const FILTER_TYPE_CHAT:String = "chat";
      
      private static const FILTER_TYPE_NAME:String = "name";
      
      private static const FILTER_TYPE_SERVER:String = "server";
       
      
      public function FilterWordManager()
      {
         super();
      }
      
      public static function setup(param1:FilterWordAnalyzer) : void
      {
         WORDS = param1.words;
         SERVER_WORDS = param1.serverWords;
         unableChar = param1.unableChar;
         clearnUpNaN_Char(WORDS);
         clearnUpNaN_Char(SERVER_WORDS);
      }
      
      private static function clearnUpNaN_Char(param1:Array) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if(StringHelper.trim(param1[_loc2_]).length == 0)
            {
               param1.splice(_loc2_,1);
            }
            else
            {
               _loc2_++;
            }
         }
      }
      
      public static function containUnableChar(param1:String) : Boolean
      {
         var _loc2_:int = param1.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(unableChar.indexOf(param1.charAt(_loc3_)) > -1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public static function isGotForbiddenWords(param1:String, param2:String = "chat") : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:String = StringHelper.trimAll(param1.toLocaleLowerCase());
         var _loc5_:uint = WORDS.length;
         if(param2 == FILTER_TYPE_NAME || param2 == FILTER_TYPE_CHAT || param2 == FILTER_TYPE_ALL)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               if(_loc4_.indexOf(WORDS[_loc3_]) > -1)
               {
                  return true;
               }
               _loc3_++;
            }
         }
         if(param2 == FILTER_TYPE_SERVER)
         {
            _loc5_ = SERVER_WORDS.length;
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               if(_loc4_.indexOf(SERVER_WORDS[_loc3_]) > -1)
               {
                  return true;
               }
               _loc3_++;
            }
         }
         return false;
      }
      
      private static function formatForbiddenWords(param1:String, param2:Array) : String
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         if(param2 != SERVER_WORDS)
         {
            _loc3_ = StringHelper.trimAll(param1.toLocaleLowerCase());
         }
         else
         {
            _loc3_ = param1;
         }
         var _loc5_:int = int(param2.length);
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            if(_loc3_.indexOf(param2[_loc7_]) > -1)
            {
               _loc6_ = true;
               _loc4_ = new Object();
               _loc4_["word"] = param2[_loc7_];
               _loc4_["idx"] = _loc3_.indexOf(param2[_loc7_]);
               _loc4_["length"] = _loc4_["word"].length;
               _loc3_ = replaceUpperOrLowerCase(_loc3_,_loc4_);
               param1 = replaceUpperOrLowerCase(param1,_loc4_);
               _loc7_ = 0;
            }
            _loc7_++;
         }
         return param1;
      }
      
      private static function formatChannelWords(param1:String) : String
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(!param1)
         {
            return undefined;
         }
         var _loc5_:int = int(CHANNEL_WORDS.length);
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            _loc2_ = uint(param1.indexOf(CHANNEL_WORDS[_loc7_]));
            _loc3_ = uint(_loc2_ - 1);
            _loc4_ = _loc2_ + CHANNEL_WORDS[_loc7_].length;
            if(_loc2_ > -1)
            {
               if(_loc3_ > -1 && _loc4_ <= param1.length - 1)
               {
                  if(param1.slice(_loc3_,_loc3_ + 1) == "[" && param1.slice(_loc4_,_loc4_ + 1) == "]")
                  {
                     _loc6_ = true;
                     param1 = param1.slice(0,_loc2_) + getXXX(CHANNEL_WORDS[_loc7_].length) + param1.slice(_loc4_);
                  }
               }
            }
            _loc7_++;
         }
         if(_loc6_ && Boolean(param1))
         {
            return param1;
         }
         return undefined;
      }
      
      private static function replaceUpperOrLowerCase(param1:String, param2:Object) : String
      {
         var _loc3_:String = null;
         var _loc4_:int = int(param2["idx"]);
         var _loc5_:int = int(param2["length"]);
         if(_loc4_ + _loc5_ >= param1.length)
         {
            _loc3_ = param1.slice(_loc4_);
         }
         else
         {
            _loc3_ = param1.slice(_loc4_,_loc4_ + _loc5_);
         }
         return param1.replace(_loc3_,getXXX(_loc5_));
      }
      
      public static function filterWrod(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = StringHelper.trimAll(param1);
         var _loc5_:String = formatChannelWords(_loc4_);
         if(Boolean(_loc5_))
         {
            _loc2_ = formatForbiddenWords(_loc5_,WORDS);
         }
         else
         {
            _loc2_ = formatForbiddenWords(_loc4_,WORDS);
         }
         if(Boolean(_loc3_))
         {
            return _loc3_;
         }
         if(Boolean(_loc2_))
         {
            return _loc2_;
         }
         if(Boolean(_loc5_))
         {
            return _loc5_;
         }
         return _loc4_;
      }
      
      public static function filterWrodFromServer(param1:String) : String
      {
         if(isGotForbiddenWords(param1,FILTER_TYPE_SERVER))
         {
            param1 = formatForbiddenWords(param1,SERVER_WORDS);
         }
         return param1;
      }
      
      public static function IsNullorEmpty(param1:String) : Boolean
      {
         param1 = StringHelper.trim(param1);
         return StringHelper.isNullOrEmpty(param1);
      }
      
      private static function getXXX(param1:int) : String
      {
         var _loc2_:uint = Math.round(Math.random() * (REPLACEWORD.length / 4));
         return REPLACEWORD.slice(_loc2_,_loc2_ + param1);
      }
   }
}
