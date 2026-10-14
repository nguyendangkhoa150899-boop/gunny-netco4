package explorerManual.view.page
{
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PathManager;
   import explorerManual.data.model.ManualDebrisInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class ManualPiecesItem extends Sprite implements Disposeable
   {
       
      
      private var _index:int;
      
      private var _info:ManualDebrisInfo;
      
      private var _loaderPic:DisplayLoader;
      
      private var _xOffset:int;
      
      private var _yOffset:int;
      
      public function ManualPiecesItem(param1:int, param2:int, param3:int)
      {
         this.index = param1;
         super();
      }
      
      public function get yOffset() : int
      {
         return this._yOffset;
      }
      
      public function set yOffset(param1:int) : void
      {
         this._yOffset = param1;
      }
      
      public function get xOffset() : int
      {
         return this._xOffset;
      }
      
      public function set xOffset(param1:int) : void
      {
         this._xOffset = param1;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(param1:int) : void
      {
         this._index = param1;
      }
      
      public function set info(param1:ManualDebrisInfo) : void
      {
         this._info = param1;
         this.clearLoader();
         this.initView();
      }
      
      public function get info() : ManualDebrisInfo
      {
         return this._info;
      }
      
      public function get isRight() : Boolean
      {
         return this.index + 1 == this._info.Sort;
      }
      
      private function initView() : void
      {
         if(Boolean(this._info))
         {
            this._loaderPic = LoadResourceManager.Instance.createLoader(PathManager.ManualDebrisIconPath(this._info.ImagePath),0);
            this._loaderPic.addEventListener("complete",this.__picComplete);
            LoadResourceManager.Instance.startLoad(this._loaderPic);
         }
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
      
      public function dispose() : void
      {
         this.clearLoader();
         ObjectUtils.disposeAllChildren(this);
         this._info = null;
      }
   }
}
