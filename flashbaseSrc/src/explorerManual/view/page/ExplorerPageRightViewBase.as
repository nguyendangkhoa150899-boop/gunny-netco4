package explorerManual.view.page
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import explorerManual.ExplorerManualController;
   import explorerManual.data.ExplorerManualInfo;
   import explorerManual.data.model.ManualPageItemInfo;
   import explorerManual.view.shop.ExplorerManualShop;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ExplorerPageRightViewBase extends Sprite implements Disposeable
   {
       
      
      protected var _hasPieces:Bitmap;
      
      protected var _piecesPregress:FilterFrameText;
      
      protected var _associationBtn:BaseButton;
      
      protected var _model:ExplorerManualInfo;
      
      protected var _ctrl:ExplorerManualController;
      
      protected var _chapterID:int;
      
      protected var _pageInfo:ManualPageItemInfo;
      
      private var _shopFrame:ExplorerManualShop;
      
      public function ExplorerPageRightViewBase(param1:int, param2:ExplorerManualInfo, param3:ExplorerManualController)
      {
         super();
         this._model = param2;
         this._ctrl = param3;
         this._chapterID = param1;
         this.initView();
         this.initEvent();
      }
      
      protected function initView() : void
      {
         this._hasPieces = ComponentFactory.Instance.creat("asset.explorerManual.pageRightView.hasPiecesTxtIcon");
         addChild(this._hasPieces);
         this._piecesPregress = ComponentFactory.Instance.creatComponentByStylename("explorerManual.haspiecesPregressTxt");
         addChild(this._piecesPregress);
         this._associationBtn = ComponentFactory.Instance.creatComponentByStylename("explorerManual.pageRight.associationBtn");
         addChild(this._associationBtn);
      }
      
      protected function initEvent() : void
      {
         if(Boolean(this._model))
         {
            this._model.addEventListener("manualModelUpdate",this.__modelUpdateHandler);
         }
         if(Boolean(this._associationBtn))
         {
            this._associationBtn.addEventListener("click",this.__associationClickHandler);
         }
      }
      
      protected function removeEvent() : void
      {
         if(Boolean(this._model))
         {
            this._model.removeEventListener("manualModelUpdate",this.__modelUpdateHandler);
         }
         if(Boolean(this._associationBtn))
         {
            this._associationBtn.removeEventListener("click",this.__associationClickHandler);
         }
      }
      
      private function __associationClickHandler(param1:MouseEvent) : void
      {
         this._shopFrame = ComponentFactory.Instance.creat("explorerManual.ExplorerManualShop.Frame",[this._ctrl]);
         this._shopFrame.show();
      }
      
      protected function __modelUpdateHandler(param1:Event) : void
      {
         this.updateShowView();
      }
      
      private function getPregressValue(param1:int, param2:int) : String
      {
         var _loc3_:* = null;
         return "<FONT FACE=\'Arial\' SIZE=\'14\' COLOR=\'#FF0000\' ><B>" + param1 + "</B></FONT>" + "/" + param2;
      }
      
      public function set pageInfo(param1:ManualPageItemInfo) : void
      {
         this._pageInfo = param1;
         this.updateShowView();
      }
      
      protected function updateShowView() : void
      {
         this.piecesPregress();
      }
      
      private function piecesPregress() : void
      {
         var _loc1_:Array = this._model.debrisInfo.getHaveDebrisByPageID(this._pageInfo.ID);
         this._piecesPregress.htmlText = this.getPregressValue(_loc1_.length,this._pageInfo.DebrisCount);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._piecesPregress);
         this._piecesPregress = null;
         ObjectUtils.disposeObject(this._hasPieces);
         this._hasPieces = null;
         ObjectUtils.disposeObject(this._associationBtn);
         this._associationBtn = null;
         this._shopFrame = null;
         this._model = null;
         this._ctrl = null;
         this._pageInfo = null;
      }
   }
}
