package com.pickgliss.loader
{
   import com.pickgliss.utils.ClassUtils;
   import flash.system.ApplicationDomain;
   import road7th.data.DictionaryData;
   
   public class CodeModuleLoader extends ModuleLoader
   {
      
      private static var LoadClassName:DictionaryData = new DictionaryData();
       
      
      public var className:String;
      
      public function CodeModuleLoader(param1:int, param2:String, param3:ApplicationDomain)
      {
         super(param1,param2,param3);
      }
      
      override protected function fireCompleteEvent() : void
      {
         var _loc1_:* = undefined;
         if(!LoadClassName.hasKey(this.className))
         {
            _loc1_ = ClassUtils.CreatInstance(this.className);
            if(!_loc1_)
            {
               throw new Error("CodeModuleLoader :: 代码加载出错!!!!立刻检查!!" + _url);
            }
            CodeLoader.addLoadURL("2.png");
            _loc1_["setup"]();
            LoadClassName.add(this.className,true);
         }
         super.fireCompleteEvent();
      }
      
      override public function get type() : int
      {
         return 9;
      }
   }
}
