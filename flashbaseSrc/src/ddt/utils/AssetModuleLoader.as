package ddt.utils
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.XMLNativeAnalyzer;
   import ddt.manager.PathManager;
   import flash.events.Event;
   import road7th.data.DictionaryData;
   
   public class AssetModuleLoader
   {
      
      public static const UI_TYPE:int = 1;
      
      public static const XML_TYPE:int = 2;
      
      public static const SWF_TYPE:int = 4;
      
      public static const XML_SWF_TYPE:int = 6;
      
      public static const UI_SWF_TYPE:int = 5;
      
      public static const UI_XML_TYPE:int = 3;
      
      public static const UI_XML_SWF_TYPE:int = 7;
      
      private static var _loaderQueue:ddt.utils.QueueLoaderUtil = new ddt.utils.QueueLoaderUtil();
      
      private static var _loaderData:DictionaryData = new DictionaryData();
      
      private static var _loaderList:Vector.<BaseLoader> = new Vector.<BaseLoader>();
      
      private static var _call:Function;
      
      private static var _params:Array;
       
      
      public function AssetModuleLoader()
      {
         super();
      }
      
      public static function addModelLoader(param1:String, param2:int) : void
      {
         var _loc3_:Vector.<BaseLoader> = getLoaderResList(param1,param2);
         _loaderList = _loaderList.concat(_loc3_);
      }
      
      public static function addRequestLoader(param1:BaseLoader, param2:Boolean = false) : void
      {
         if(param2)
         {
            _loaderData.remove(param1.id);
         }
         _loaderList.push(param1);
      }
      
      public static function startLoader(param1:Function = null, param2:Array = null, param3:Boolean = true) : void
      {
         var _loc4_:int = 0;
         var _loc5_:* = null;
         _loaderQueue.reset();
         _call = param1;
         _params = param2;
         var _loc6_:int = int(_loaderList.length);
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            if((_loc5_ = _loaderList[_loc4_] as BaseLoader) == null)
            {
               throw new Error("AssetModelLoader :: 加载项类型错误！请检查");
            }
            if(!_loaderData.hasKey(_loc5_.id))
            {
               _loaderQueue.addLoader(_loc5_);
            }
            _loc4_++;
         }
         _loaderList.splice(0,_loaderList.length);
         if(_loaderQueue.length <= 0)
         {
            if(Boolean(_call))
            {
               _call.apply(null,_params);
            }
         }
         else
         {
            _loaderQueue.addEventListener("complete",__onLoadComplete);
            _loaderQueue.addEventListener("close",__onLoadClose);
            _loaderQueue.start(param3);
         }
      }
      
      public static function startCodeLoader(param1:Function = null, param2:Array = null, param3:Boolean = true, param4:String = "2.png", param5:String = "DDT_Core") : void
      {
         startLoader(param1,param2,param3);
      }
      
      private static function getLoaderResList(param1:String, param2:int) : Vector.<BaseLoader>
      {
         var _loc3_:* = null;
         var _loc4_:Vector.<BaseLoader> = new Vector.<BaseLoader>();
         if(PathManager.FLASHSITE == null || PathManager.FLASHSITE == "")
         {
            if(Boolean(param2 >> 1 & 1))
            {
               (_loc3_ = LoadResourceManager.Instance.createLoader(PathManager.getXMLPath(param1),2)).analyzer = new XMLNativeAnalyzer(null);
               _loc4_.push(_loc3_);
            }
         }
         if(Boolean(param2 >> 0 & 1))
         {
            _loc4_.push(LoadResourceManager.Instance.createLoader(PathManager.getMornUIPath(param1),8));
         }
         if(Boolean(param2 >> 2 & 1))
         {
            _loc4_.push(LoadResourceManager.Instance.createLoader(PathManager.getSwfPath(param1),4));
         }
         return _loc4_;
      }
      
      private static function __onLoadComplete(param1:Event) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _loaderQueue.loaders.length)
         {
            if(_loaderQueue.loaders[_loc2_].isComplete)
            {
               _loaderData.add(_loaderQueue.loaders[_loc2_].id,true);
            }
            _loc2_++;
         }
         _loaderQueue.removeEventListener("complete",__onLoadComplete);
         _loaderQueue.removeEventListener("close",__onLoadClose);
         if(Boolean(_call))
         {
            _call.apply(null,_params);
         }
         _call = null;
         _params = null;
      }
      
      private static function __onLoadClose(param1:Event) : void
      {
         _loaderQueue.removeEventListener("complete",__onLoadComplete);
         _loaderQueue.removeEventListener("close",__onLoadClose);
      }
   }
}
