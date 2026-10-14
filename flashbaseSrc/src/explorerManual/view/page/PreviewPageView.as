package explorerManual.view.page
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import explorerManual.data.model.ManualPageItemInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class PreviewPageView extends Sprite implements Disposeable
   {
       
      
      private var _bor:Bitmap;
      
      private var _preViewTxt:Bitmap;
      
      private var _iconCell:explorerManual.view.page.ManualPreIconCell;
      
      public function PreviewPageView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._iconCell = ComponentFactory.Instance.creatComponentByStylename("explorerManual.preview.Icon");
         addChild(this._iconCell);
         this._iconCell.mouseEnabled = true;
         this._bor = ComponentFactory.Instance.creat("asset.explorerManual.chapterShowBorderIcon");
         addChild(this._bor);
         this._preViewTxt = ComponentFactory.Instance.creat("asset.explorerManual.pageRightView.previewTxtIcon");
         addChild(this._preViewTxt);
      }
      
      public function set tipData(param1:ManualPageItemInfo) : void
      {
         this._iconCell.pageInfo = param1;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._iconCell);
         this._iconCell = null;
         ObjectUtils.disposeObject(this._bor);
         this._bor = null;
         ObjectUtils.disposeObject(this._preViewTxt);
         this._preViewTxt = null;
      }
   }
}
