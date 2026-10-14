package explorerManual.view.page
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CEvent;
   import ddt.utils.PositionUtils;
   import explorerManual.ExplorerManualManager;
   import explorerManual.data.ExplorerManualInfo;
   import explorerManual.data.model.ManualPageItemInfo;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   
   public class ExplorerPageDirectorItemView extends Sprite implements Disposeable
   {
      
      public static const ITEM_CLICK:String = "directorItemClick";
      
      private static const OMIT_STR:String = "....................................................................";
       
      
      private var _totalLen:int = 90;
      
      private var _itemTxt:FilterFrameText;
      
      private var _processText:FilterFrameText;
      
      private var _index:int;
      
      private var _info:ManualPageItemInfo;
      
      private var _model:ExplorerManualInfo;
      
      private var _icon:MovieClip;
      
      private var _selectedBg:Bitmap;
      
      public function ExplorerPageDirectorItemView(param1:int, param2:ExplorerManualInfo)
      {
         super();
         this._index = param1;
         this._model = param2;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._selectedBg = ComponentFactory.Instance.creat("asset.explorerManual.dicSelectedItem.bg");
         addChild(this._selectedBg);
         PositionUtils.setPos(this._selectedBg,"explorerManual.directorItem.selectedBgPos");
         this._selectedBg.visible = false;
         this._itemTxt = ComponentFactory.Instance.creatComponentByStylename("explorerManual.pageDirectoryView.itemTxt");
         addChild(this._itemTxt);
         this._icon = ComponentFactory.Instance.creat("asset.explorerManual.sighIcon");
         PositionUtils.setPos(this._icon,"explorerManual.directorItem.sighIconPos");
         this._icon.visible = false;
         addChild(this._icon);
         this._processText = ComponentFactory.Instance.creatComponentByStylename("explorerManual.pageDirectoryView.itemProgressTxt");
         addChild(this._processText);
      }
      
      private function initEvent() : void
      {
         if(Boolean(this._itemTxt))
         {
            this._itemTxt.addEventListener("link",this.itemLinkClick_Handler);
         }
         this.addEventListener("mouseOver",this.__mouseOverHandler);
         this.addEventListener("mouseOut",this.__mouseOutHandler);
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._itemTxt))
         {
            this._itemTxt.removeEventListener("link",this.itemLinkClick_Handler);
         }
         this.removeEventListener("mouseOut",this.__mouseOutHandler);
         this.removeEventListener("mouseOver",this.__mouseOverHandler);
      }
      
      private function __mouseOverHandler(param1:MouseEvent) : void
      {
         this._selectedBg.visible = true;
      }
      
      private function __mouseOutHandler(param1:MouseEvent) : void
      {
         this._selectedBg.visible = false;
      }
      
      private function itemLinkClick_Handler(param1:TextEvent) : void
      {
         if(Boolean(this._info) && this._icon.visible)
         {
            ExplorerManualManager.instance.removeNewDebrisForPages(this._info.ID);
            this._icon.visible = false;
         }
         this.dispatchEvent(new CEvent("directorItemClick",param1.text));
      }
      
      public function set info(param1:ManualPageItemInfo) : void
      {
         this._info = param1;
         if(this._info == null)
         {
            return;
         }
         this.createItem();
         this.showSighIcon();
      }
      
      private function showSighIcon() : void
      {
         if(this._icon == null || this._info == null)
         {
            return;
         }
         this._icon.visible = ExplorerManualManager.instance.isHaveNewDebrisForPage(this._info.ID);
      }
      
      private function createItem() : void
      {
         var _loc1_:* = null;
         var _loc2_:String = this._info.Name;
         _loc1_ = _loc2_ + "....................................................................";
         var _loc3_:int = int(this._model.debrisInfo.getHaveDebrisByPageID(this._info.ID).length);
         var _loc4_:int = this._info.DebrisCount;
         this._processText.text = this._index + " ( " + _loc3_ + "/" + _loc4_ + " )";
         this._itemTxt.htmlText = "<a href=\'event:" + this._info.Sort + "\'>" + _loc1_ + "</a>";
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._itemTxt);
         this._itemTxt = null;
         ObjectUtils.disposeObject(this._selectedBg);
         this._selectedBg = null;
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         ObjectUtils.disposeObject(this._processText);
         this._processText = null;
         this._info = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
