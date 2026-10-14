package explorerManual.view.chapter
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import explorerManual.ExplorerManualController;
   import explorerManual.data.ExplorerManualInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class ExplorerChapterView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _leftView:explorerManual.view.chapter.ExplorerChapterLeftView;
      
      private var _rightView:explorerManual.view.chapter.ExplorerChapterRightView;
      
      private var _model:ExplorerManualInfo;
      
      private var _ctrl:ExplorerManualController;
      
      public function ExplorerChapterView(param1:ExplorerManualInfo, param2:ExplorerManualController)
      {
         super();
         this._model = param1;
         this._ctrl = param2;
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("asset.explorerManual.chapterBgAsset");
         this._leftView = new explorerManual.view.chapter.ExplorerChapterLeftView(this._model,this._ctrl);
         this._rightView = new explorerManual.view.chapter.ExplorerChapterRightView(this._model,this._ctrl);
         addChild(this._bg);
         addChild(this._leftView);
         addChild(this._rightView);
      }
      
      public function dispose() : void
      {
         this._model = null;
         this._ctrl = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._leftView);
         this._leftView = null;
         ObjectUtils.disposeObject(this._rightView);
         this._rightView = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
