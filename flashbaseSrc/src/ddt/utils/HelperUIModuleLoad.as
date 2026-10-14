package ddt.utils
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class HelperUIModuleLoad
   {
      
      private static var _loadedDic:Dictionary = new Dictionary();
       
      
      private var _loadProgress:int = 0;
      
      private var _UILoadComplete:Boolean = false;
      
      private var _loadlist:Array;
      
      private var _update:Function;
      
      private var _params:Array;
      
      public function HelperUIModuleLoad()
      {
         super();
      }
      
      public function loadUIModule(param1:Array, param2:Function, param3:Array = null) : void
      {
         var _loc6_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         this._update = param2;
         this._params = param3;
         this._loadlist = [];
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1[_loc4_];
            if(_loadedDic[_loc5_] == null)
            {
               this._loadlist.push(_loc5_);
            }
            _loc4_++;
         }
         if(this._loadlist.length > 0)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener("close",this.__onClose);
            UIModuleLoader.Instance.addEventListener("uiModuleComplete",this.__onUIModuleComplete);
            UIModuleLoader.Instance.addEventListener("uiMoudleProgress",this.__onProgress);
            for each(_loc6_ in this._loadlist)
            {
               UIModuleLoader.Instance.addUIModuleImp(_loc6_);
            }
         }
         else
         {
            this._update.apply(null,this._params);
         }
      }
      
      protected function __onProgress(param1:UIModuleEvent) : void
      {
         var _loc2_:Number = (this._loadProgress + param1.loader.progress) / this._loadlist.length;
         UIModuleSmallLoading.Instance.progress = _loc2_ * 100;
      }
      
      protected function __onUIModuleComplete(param1:UIModuleEvent) : void
      {
         this.checkComplete(param1.module);
         if(this._UILoadComplete)
         {
            UIModuleLoader.Instance.removeEventListener("uiModuleComplete",this.__onUIModuleComplete);
            UIModuleLoader.Instance.removeEventListener("uiMoudleProgress",this.__onProgress);
            UIModuleSmallLoading.Instance.removeEventListener("close",this.__onClose);
            UIModuleSmallLoading.Instance.hide();
            this._update.apply(null,this._params);
            this.dispose();
         }
      }
      
      private function checkComplete(param1:String) : void
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in this._loadlist)
         {
            if(_loc2_ == param1)
            {
               _loadedDic[param1] = 1;
               ++this._loadProgress;
               if(this._loadProgress >= this._loadlist.length)
               {
                  this._UILoadComplete = true;
               }
            }
         }
      }
      
      protected function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener("close",this.__onClose);
         UIModuleLoader.Instance.removeEventListener("uiModuleComplete",this.__onUIModuleComplete);
         UIModuleLoader.Instance.removeEventListener("uiMoudleProgress",this.__onProgress);
         this.dispose();
      }
      
      private function dispose() : void
      {
         if(this._loadlist.length > 0)
         {
            this._loadlist.length = 0;
            this._loadlist = null;
         }
         this._update = null;
         this._params = null;
      }
   }
}
