package explorerManual.view.shop
{
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import shop.view.ShopItemCell;
   
   public class ManualShopCell extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _nameTxt:FilterFrameText;
      
      private var _needMoneyTxt:FilterFrameText;
      
      private var _integral:FilterFrameText;
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _confirmFrame:BaseAlerFrame;
      
      private var _itemCell:ShopItemCell;
      
      private var _shopItemInfo:ShopItemInfo;
      
      public function ManualShopCell()
      {
         super();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.manualShopView.bg");
         addChild(this._bg);
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("explorerManual.shop.buyBtn");
         addChild(this._buyBtn);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("explorerManual.shop.nameTxt");
         addChild(this._nameTxt);
         this._needMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("explorerManual.needMoneyTxt");
         addChild(this._needMoneyTxt);
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,30,30);
         _loc1_.graphics.endFill();
         this._itemCell = CellFactory.instance.createShopItemCell(_loc1_,null,true,true) as ShopItemCell;
         PositionUtils.setPos(this._itemCell,"explorerManual.itemCell.pos");
         addChild(this._itemCell);
         this._integral = ComponentFactory.Instance.creatComponentByStylename("explorerManual.integral");
         this._integral.text = LanguageMgr.GetTranslation("explorerManual.shop.point");
         addChild(this._integral);
         this._buyBtn.addEventListener("click",this.buyHandler,false,0,true);
      }
      
      private function buyHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:ManualShopQuickBuy = ComponentFactory.Instance.creatComponentByStylename("explorerManual.shop.QuickBuyAlert");
         _loc2_.setData(this._shopItemInfo.TemplateID,this._shopItemInfo.GoodsID,this._shopItemInfo.AValue1);
         LayerManager.Instance.addToLayer(_loc2_,2,true,1);
      }
      
      public function refreshShow(param1:ShopItemInfo) : void
      {
         this._shopItemInfo = param1;
         this._itemCell.info = this._shopItemInfo.TemplateInfo;
         this._itemCell.tipInfo = this._shopItemInfo;
         this._nameTxt.text = this._itemCell.info.Name;
         this._needMoneyTxt.text = this._shopItemInfo.AValue1.toString();
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._shopItemInfo = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         if(Boolean(this._buyBtn))
         {
            this._buyBtn.removeEventListener("click",this.buyHandler);
         }
         ObjectUtils.disposeObject(this._buyBtn);
         this._buyBtn = null;
         ObjectUtils.disposeObject(this._nameTxt);
         this._nameTxt = null;
         ObjectUtils.disposeObject(this._needMoneyTxt);
         this._needMoneyTxt = null;
         ObjectUtils.disposeObject(this._integral);
         this._integral = null;
         ObjectUtils.disposeObject(this._itemCell);
         this._itemCell = null;
         if(Boolean(this.parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
