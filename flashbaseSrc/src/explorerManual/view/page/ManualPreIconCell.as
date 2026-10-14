package explorerManual.view.page
{
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PathManager;
   import explorerManual.data.model.ManualPageItemInfo;
   import flash.display.Bitmap;
   
   public class ManualPreIconCell extends Component
   {
       
      
      private var _loaderPic:DisplayLoader;
      
      private var _info:ManualPageItemInfo;
      
      public function ManualPreIconCell()
      {
         super();
      }
      
      public function set pageInfo(param1:ManualPageItemInfo) : void
      {
         this._info = param1;
         tipData = param1;
         this.clearLoader();
         this.loadIcon();
      }
      
      private function loadIcon() : void
      {
         var _loc1_:String = "/explorerManual/preview/" + this._info.ID;
         this._loaderPic = LoadResourceManager.Instance.createLoader(PathManager.ManualDebrisIconPath(_loc1_),0);
         this._loaderPic.addEventListener("complete",this.__picComplete);
         LoadResourceManager.Instance.startLoad(this._loaderPic);
      }
      
      private function __picComplete(param1:LoaderEvent) : void
      {
         ObjectUtils.disposeAllChildren(this);
         if(param1.loader.isSuccess)
         {
            addChild(param1.loader.content as Bitmap);
         }
         this.clearLoader();
      }
      
      private function clearLoader() : void
      {
         if(Boolean(this._loaderPic))
         {
            this._loaderPic.removeEventListener("complete",this.__picComplete);
            this._loaderPic = null;
         }
      }
      
      override public function dispose() : void
      {
         this._info = null;
         ObjectUtils.disposeAllChildren(this);
         this.clearLoader();
         super.dispose();
      }
   }
}
