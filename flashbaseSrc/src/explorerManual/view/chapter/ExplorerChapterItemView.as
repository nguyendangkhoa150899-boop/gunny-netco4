package explorerManual.view.chapter
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class ExplorerChapterItemView extends Sprite implements Disposeable
   {
       
      
      private var _titleIcon:Bitmap;
      
      private var _itemBtnIcon:Bitmap;
      
      private var _progressTxt:FilterFrameText;
      
      private var _chapterID:int;
      
      public function ExplorerChapterItemView(param1:int)
      {
         super();
         this._chapterID = param1;
         this.initView();
         buttonMode = true;
      }
      
      private function initView() : void
      {
         this._titleIcon = ComponentFactory.Instance.creat("asset.explorerManual.chaptertxtAsset" + this._chapterID);
         addChild(this._titleIcon);
         this._itemBtnIcon = ComponentFactory.Instance.creat("asset.explorerManual.chapterItembgAsset" + this._chapterID);
         addChild(this._itemBtnIcon);
         this._progressTxt = ComponentFactory.Instance.creatComponentByStylename("explorerManual.chapterRight.itemProgressTxt");
         addChild(this._progressTxt);
      }
      
      public function updateProgress(param1:String) : void
      {
         this._progressTxt.htmlText = param1;
      }
      
      public function get chapterID() : int
      {
         return this._chapterID;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._titleIcon))
         {
            ObjectUtils.disposeObject(this._titleIcon);
         }
         this._titleIcon = null;
         if(Boolean(this._itemBtnIcon))
         {
            ObjectUtils.disposeObject(this._itemBtnIcon);
         }
         this._itemBtnIcon = null;
         if(Boolean(this._progressTxt))
         {
            ObjectUtils.disposeObject(this._progressTxt);
         }
         this._progressTxt = null;
      }
   }
}
