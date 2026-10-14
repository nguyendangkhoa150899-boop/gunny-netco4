package godCardRaise.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import godCardRaise.GodCardRaiseManager;
   import godCardRaise.info.GodCardListGroupInfo;
   
   public class GodCardRaiseExchangeLeftCell extends Sprite implements Disposeable, IListCell
   {
       
      
      private var _bg:ScaleFrameImage;
      
      private var _selectedLight:Scale9CornerImage;
      
      private var _nameTxt:FilterFrameText;
      
      private var _data:GodCardListGroupInfo;
      
      private var _getExchangeBmp:Bitmap;
      
      public function GodCardRaiseExchangeLeftCell()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseExchangeLeftView.listCellBG");
         this._bg.setFrame(1);
         addChild(this._bg);
         this._selectedLight = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseExchangeLeftView.listCellLight");
         addChild(this._selectedLight);
         this._selectedLight.visible = false;
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseExchangeLeftView.listCellTxt");
         this._nameTxt.setFrame(1);
         addChild(this._nameTxt);
         this._getExchangeBmp = ComponentFactory.Instance.creatBitmap("asset.godCardRaiseExchangeLeftView.getExchangeBmp");
         this._getExchangeBmp.visible = false;
         addChild(this._getExchangeBmp);
         this.buttonMode = true;
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
         this._selectedLight.visible = param2;
         if(param2)
         {
            this._bg.setFrame(2);
            this._nameTxt.setFrame(2);
         }
         else
         {
            this._bg.setFrame(1);
            this._nameTxt.setFrame(1);
         }
      }
      
      public function getCellValue() : *
      {
         return this._data;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._data = param1 as GodCardListGroupInfo;
         this.updateView();
      }
      
      public function updateView() : void
      {
         if(this._data == null)
         {
            return;
         }
         var _loc1_:int = int(GodCardRaiseManager.Instance.model.groups[this._data.GroupID]);
         var _loc2_:int = GodCardRaiseManager.Instance.calculateExchangeCount(this._data);
         var _loc3_:int = GodCardRaiseManager.Instance.getMyCardCount(13);
         this._nameTxt.text = this._data.GroupName + "(" + _loc2_ + "/" + this._data.Cards.length + ")";
         if(_loc2_ + _loc3_ >= this._data.Cards.length && _loc2_ != 0 && this._data.ExchangeTimes - _loc1_ > 0)
         {
            this._getExchangeBmp.visible = true;
         }
         else
         {
            this._getExchangeBmp.visible = false;
         }
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._selectedLight = null;
         this._nameTxt = null;
         this._getExchangeBmp = null;
         this._data = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
