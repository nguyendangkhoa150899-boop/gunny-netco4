package ddt.utils
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.QueueLoader;
   import ddt.manager.PathManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class HelperDataModuleLoad
   {
      
      private static var _loadedDic:Dictionary = new Dictionary();
       
      
      private var _loaderQueue:QueueLoader;
      
      private var _loadProgress:int = 0;
      
      private var _list:Array;
      
      private var _update:Function;
      
      private var _params:Array;
      
      public function HelperDataModuleLoad()
      {
         super();
      }
      
      public function loadDataModule(param1:Array, param2:Function, param3:Array = null, param4:Boolean = false, param5:Boolean = true) : void
      {
         var _loc6_:int = 0;
         var _loc7_:* = null;
         var _loc8_:* = null;
         this._list = param1;
         this._update = param2;
         this._params = param3;
         this._loaderQueue = new QueueLoader();
         var _loc9_:int = int(param1.length);
         _loc6_ = 0;
         for(; _loc6_ < _loc9_; _loc6_++)
         {
            if(param1[_loc6_] is BaseLoader)
            {
               _loc7_ = param1[_loc6_] as BaseLoader;
            }
            else
            {
               if(!(param1[_loc6_] is Function))
               {
                  continue;
               }
               _loc7_ = (param1[_loc6_] as Function).call();
            }
            _loc8_ = PathManager.getLoaderFileName(_loc7_.url);
            if(param4 || _loadedDic[_loc8_] == null)
            {
               _loc7_.addEventListener(LoaderEvent.COMPLETE,this.__onDataLoadProgress);
               this._loaderQueue.addLoader(_loc7_);
            }
         }
         if(this._loaderQueue.length <= 0)
         {
            param2.apply(null,param3);
            this._loaderQueue.dispose();
            this._loaderQueue = null;
            return;
         }
         if(param5)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         }
         this._loaderQueue.addEventListener(Event.COMPLETE,this.__onDataLoadComplete);
         this._loaderQueue.start();
      }
      
      protected function __onClose(param1:Event) : void
      {
         this.removeSmallLoading();
         if(Boolean(this._loaderQueue) && this._loaderQueue.length <= 0)
         {
            this._loaderQueue.dispose();
            this._loaderQueue = null;
         }
      }
      
      private function removeSmallLoading() : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
      }
      
      private function __onDataLoadProgress(param1:LoaderEvent) : void
      {
         var _loc2_:BaseLoader = param1.currentTarget as BaseLoader;
         _loc2_.removeEventListener(LoaderEvent.COMPLETE,this.__onDataLoadProgress);
         var _loc3_:String = PathManager.getLoaderFileName(_loc2_.url);
         _loadedDic[_loc3_] = 1;
         _loc2_ = null;
         ++this._loadProgress;
         var _loc4_:Number = this._loadProgress / this._list.length;
         UIModuleSmallLoading.Instance.progress = _loc4_ * 100;
      }
      
      private function __onDataLoadComplete(param1:Event) : void
      {
         this._update.apply(null,this._params);
         this._loaderQueue.removeEventListener(Event.COMPLETE,this.__onDataLoadComplete);
         this._loaderQueue.dispose();
         this._loaderQueue = null;
         this.dispose();
      }
      
      private function dispose() : void
      {
         this.removeSmallLoading();
         if(this._list.length > 0)
         {
            this._list.length = 0;
            this._list = null;
         }
         this._update = null;
         this._params = null;
      }
   }
}
