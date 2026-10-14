package explorerManual.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import explorerManual.ExplorerManualManager;
   import explorerManual.data.ExplorerManualInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ManualLeftMenu extends Sprite implements Disposeable
   {
       
      
      private var _activeIcon:ScaleFrameImage;
      
      private var _activeProgess:FilterFrameText;
      
      private var _unActiveIcon:ScaleFrameImage;
      
      private var _unActiveProgress:FilterFrameText;
      
      private var _model:ExplorerManualInfo;
      
      public function ManualLeftMenu(param1:ExplorerManualInfo)
      {
         super();
         this.initView();
         this._model = param1;
         this.addEvent();
         mouseEnabled = true;
         buttonMode = true;
      }
      
      private function initView() : void
      {
         this._activeIcon = ComponentFactory.Instance.creatComponentByStylename("explorerManual.activeIcon");
         addChild(this._activeIcon);
         this._activeIcon.tipData = LanguageMgr.GetTranslation("explorerManual.leftMenu.activeTips");
         this._activeProgess = ComponentFactory.Instance.creatComponentByStylename("explorerManual.activeProgessTxt");
         addChild(this._activeProgess);
         this._unActiveIcon = ComponentFactory.Instance.creatComponentByStylename("explorerManual.unActiveIcon");
         addChild(this._unActiveIcon);
         this._unActiveIcon.tipData = LanguageMgr.GetTranslation("explorerManual.leftMenu.unActiveTips");
         this._unActiveProgress = ComponentFactory.Instance.creatComponentByStylename("explorerManual.unActiveProgessTxt");
         addChild(this._unActiveProgress);
      }
      
      private function addEvent() : void
      {
         if(Boolean(this._model))
         {
            this._model.addEventListener("manualModelUpdate",this.__modelUpdateHandler);
         }
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._model))
         {
            this._model.removeEventListener("manualModelUpdate",this.__modelUpdateHandler);
         }
      }
      
      private function __modelUpdateHandler(param1:Event) : void
      {
         var _loc2_:int = int(this._model.activePageID.length);
         var _loc3_:int = this._model.havePage;
         var _loc4_:int = ExplorerManualManager.instance.getAllPageItemCount();
         this._activeProgess.text = _loc2_ + "/" + _loc3_;
         this._unActiveProgress.text = (_loc4_ - _loc3_).toString();
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._activeIcon);
         this._activeIcon = null;
         ObjectUtils.disposeObject(this._unActiveIcon);
         this._unActiveIcon = null;
         ObjectUtils.disposeObject(this._activeProgess);
         this._activeProgess = null;
         ObjectUtils.disposeObject(this._unActiveProgress);
         this._unActiveProgress = null;
         this._model = null;
      }
   }
}
