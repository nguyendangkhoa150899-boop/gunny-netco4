package explorerManual.view.chapter
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import explorerManual.ExplorerManualController;
   import explorerManual.ExplorerManualManager;
   import explorerManual.data.ExplorerManualInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ExplorerChapterRightView extends Sprite implements Disposeable
   {
       
      
      private var _chapterList:explorerManual.view.chapter.ChapterListView;
      
      private var _model:ExplorerManualInfo;
      
      private var _ctrl:ExplorerManualController;
      
      public function ExplorerChapterRightView(param1:ExplorerManualInfo, param2:ExplorerManualController)
      {
         super();
         this._model = param1;
         this._ctrl = param2;
         this.initView();
         this.initData();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._chapterList = new explorerManual.view.chapter.ChapterListView(this._ctrl);
         this._chapterList.hSpace = 56;
         this._chapterList.vSpace = 32;
         PositionUtils.setPos(this._chapterList,"explorerManual.chapterListPos");
         addChild(this._chapterList);
      }
      
      private function initData() : void
      {
         var _loc1_:Array = ExplorerManualManager.instance.getChaptersInfo();
         if(_loc1_ != null)
         {
            _loc1_.sortOn("Sort");
            this._chapterList.templeteData = _loc1_;
         }
      }
      
      private function initEvent() : void
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
         this._chapterList.updateProgress(this._model);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._chapterList))
         {
            ObjectUtils.disposeObject(this._chapterList);
         }
         this._chapterList = null;
         this._model = null;
         this._ctrl = null;
      }
   }
}
