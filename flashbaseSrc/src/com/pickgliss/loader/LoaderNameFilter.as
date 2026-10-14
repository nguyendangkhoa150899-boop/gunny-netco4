package com.pickgliss.loader
{
   import flash.utils.Dictionary;
   
   public class LoaderNameFilter
   {
      
      private static var _loadNameList:Dictionary = null;
      
      private static var _pathList:Dictionary;
       
      
      public function LoaderNameFilter()
      {
         super();
      }
      
      public static function setLoadNameContent(param1:XML) : void
      {
         var _loc6_:XMLList = null;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         _loadNameList = new Dictionary();
         _pathList = new Dictionary();
         var _loc7_:int = (_loc6_ = param1..Item).length();
         _loc2_ = 0;
         while(_loc2_ < _loc7_)
         {
            _loc3_ = _loc6_[_loc2_].@name;
            _loc4_ = _loc6_[_loc2_].@loadName;
            _loc5_ = (String(_loc6_[_loc2_].@path) + _loc3_).replace(/\\|\//g,"_");
            _loadNameList[_loc3_] = _loc4_;
            if(_loc5_ != "" && _pathList[_loc5_] == null)
            {
               _pathList[_loc5_] = true;
            }
            _loc2_++;
         }
      }
      
      private static function isFilter(param1:String) : Boolean
      {
         var _loc3_:* = undefined;
         var _loc2_:String = param1.replace(/\\|\//g,"_").toLocaleLowerCase();
         for(_loc3_ in _pathList)
         {
            if(_loc2_.indexOf(_loc3_.toLocaleLowerCase()) != -1)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function getLoadFilePath(param1:String) : String
      {
         var _loc4_:* = undefined;
         var _loc2_:* = null;
         if(_loadNameList == null || !isFilter(param1))
         {
            return param1;
         }
         var _loc3_:* = param1;
         for(_loc4_ in _loadNameList)
         {
            _loc2_ = "/" + _loc4_;
            if(_loc3_.indexOf(_loc2_) != -1)
            {
               _loc3_ = _loc3_.replace(_loc4_,_loadNameList[_loc4_]);
               break;
            }
         }
         return _loc3_;
      }
      
      public static function getRealFilePath(param1:String) : String
      {
         var _loc3_:* = undefined;
         if(_loadNameList == null)
         {
            return param1;
         }
         var _loc2_:* = param1;
         for(_loc3_ in _loadNameList)
         {
            if(param1.indexOf(_loadNameList[_loc3_]) != -1)
            {
               _loc2_ = param1.replace(_loadNameList[_loc3_],_loc3_);
               break;
            }
         }
         return _loc2_;
      }
   }
}
