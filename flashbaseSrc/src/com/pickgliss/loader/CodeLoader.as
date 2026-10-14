package com.pickgliss.loader
{
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.utils.ClassUtils;
   import flash.utils.Dictionary;
   
   public class CodeLoader
   {
      
      private static var _loadedDic:Dictionary = new Dictionary();
       
      
      private const DDT_CLASS_PATH:String = "DDT_Core";
      
      private var _onLoaded:Function;
      
      private var _url:String;
      
      private var _onProgress:Function;
      
      private var _coreLoader:com.pickgliss.loader.BaseLoader;
      
      public function CodeLoader()
      {
         super();
      }
      
      public static function loaded(param1:String) : Boolean
      {
         return _loadedDic[param1] != null;
      }
      
      public static function removeURL(param1:String) : void
      {
         delete _loadedDic[param1];
      }
      
      public static function addLoadURL(param1:String) : void
      {
         _loadedDic[param1] = 1;
      }
      
      public function loadPNG(param1:String, param2:Function, param3:Function) : void
      {
         this._url = param1;
         this._onLoaded = param2;
         this._onProgress = param3;
         this.startLoad();
      }
      
      public function stop() : void
      {
         this._coreLoader.removeEventListener("complete",this.__onloadCoreComplete);
         this._coreLoader.removeEventListener("progress",this.__onLoadCoreProgress);
      }
      
      private function startLoad() : void
      {
         var _loc1_:String = ComponentSetting.FLASHSITE + this._url;
         this._coreLoader = LoaderManager.Instance.creatLoader(_loc1_,4);
         this._coreLoader.addEventListener("complete",this.__onloadCoreComplete);
         this._coreLoader.addEventListener("progress",this.__onLoadCoreProgress);
         LoaderManager.Instance.startLoad(this._coreLoader);
      }
      
      protected function __onLoadCoreProgress(param1:LoaderEvent) : void
      {
         this._onProgress(param1.loader.progress);
      }
      
      private function __onloadCoreComplete(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener("complete",this.__onloadCoreComplete);
         param1.loader.removeEventListener("progress",this.__onLoadCoreProgress);
         var _loc2_:* = ClassUtils.CreatInstance("DDT_Core");
         if(_loc2_ != null)
         {
            LoaderSavingManager.saveFilesToLocal();
            _loc2_["setup"]();
            _loadedDic[this._url] = 1;
            if(this._onLoaded != null)
            {
               this._onLoaded();
            }
            this._coreLoader = null;
            this._onLoaded = null;
            this._onProgress = null;
            return;
         }
         throw "断网了，请刷新页面重试。";
      }
   }
}
