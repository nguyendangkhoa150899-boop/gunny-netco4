package shop.manager
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemPrice;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.ShopManager;
   import farm.viewx.shop.FarmShopPayPnl;
   import flash.display.DisplayObject;
   import shop.view.BuyMultiGoodsView;
   import shop.view.BuySingleGoodsView;
   
   public class ShopBuyManager
   {
      
      private static var _instance:shop.manager.ShopBuyManager;
       
      
      private var view:DisplayObject;
      
      private var farmview:DisplayObject;
      
      public function ShopBuyManager()
      {
         super();
      }
      
      public static function get Instance() : shop.manager.ShopBuyManager
      {
         if(_instance == null)
         {
            _instance = new shop.manager.ShopBuyManager();
         }
         return _instance;
      }
      
      public static function calcPrices(param1:Vector.<ShopCarItemInfo>) : Array
      {
         var _loc2_:ItemPrice = new ItemPrice(null,null,null);
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         while(_loc7_ < param1.length)
         {
            _loc2_.addItemPrice(param1[_loc7_].getCurrentPrice());
            _loc7_++;
         }
         _loc3_ = _loc2_.goldValue;
         _loc4_ = _loc2_.moneyValue;
         _loc5_ = _loc2_.giftValue;
         _loc6_ = _loc2_.getOtherValue(EquipType.MEDAL);
         return [_loc3_,_loc4_,_loc5_,_loc6_];
      }
      
      public function buy(param1:int) : void
      {
         this.view = new BuySingleGoodsView();
         BuySingleGoodsView(this.view).goodsID = param1;
         LayerManager.Instance.addToLayer(this.view,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function buyFarmShop(param1:int, param2:int = 88) : void
      {
         this.farmview = ComponentFactory.Instance.creatComponentByStylename("farm.farmShopPayPnl.shopPay");
         FarmShopPayPnl(this.farmview).goodsID = param1;
         FarmShopPayPnl(this.farmview).shopType = param2;
         LayerManager.Instance.addToLayer(this.farmview,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function buyAvatar(param1:PlayerInfo) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:ShopItemInfo = null;
         var _loc4_:ShopCarItemInfo = null;
         var _loc5_:Array = [];
         var _loc6_:Vector.<ShopCarItemInfo> = new Vector.<ShopCarItemInfo>();
         if(Boolean(param1.Bag.items[0]))
         {
            _loc5_.push(param1.Bag.items[0]);
         }
         if(Boolean(param1.Bag.items[1]))
         {
            _loc5_.push(param1.Bag.items[1]);
         }
         if(Boolean(param1.Bag.items[2]))
         {
            _loc5_.push(param1.Bag.items[2]);
         }
         if(Boolean(param1.Bag.items[3]))
         {
            _loc5_.push(param1.Bag.items[3]);
         }
         if(Boolean(param1.Bag.items[4]))
         {
            _loc5_.push(param1.Bag.items[4]);
         }
         if(Boolean(param1.Bag.items[5]))
         {
            _loc5_.push(param1.Bag.items[5]);
         }
         if(Boolean(param1.Bag.items[11]))
         {
            _loc5_.push(param1.Bag.items[11]);
         }
         if(Boolean(param1.Bag.items[13]))
         {
            _loc5_.push(param1.Bag.items[13]);
         }
         for each(_loc2_ in _loc5_)
         {
            _loc3_ = ShopManager.Instance.getMoneyShopItemByTemplateID(_loc2_.TemplateID,true);
            if(_loc3_ == null)
            {
               _loc3_ = ShopManager.Instance.getGiftShopItemByTemplateID(_loc2_.TemplateID,true);
            }
            if(_loc3_ == null)
            {
               _loc3_ = ShopManager.Instance.getMedalShopItemByTemplateID(_loc2_.TemplateID,true);
            }
            if(_loc3_ != null)
            {
               _loc4_ = new ShopCarItemInfo(_loc3_.GoodsID,_loc3_.TemplateID);
               ObjectUtils.copyProperties(_loc4_,_loc3_);
               _loc4_.Color = _loc2_.Color;
               _loc4_.skin = _loc2_.Skin;
               _loc6_.push(_loc4_);
            }
         }
         if(_loc6_.length == 0 || _loc6_.length < _loc5_.length)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.buyAvatarFail"));
         }
         if(_loc6_.length > 0)
         {
            this.buyMutiGoods(_loc6_);
         }
      }
      
      public function buyMutiGoods(param1:Vector.<ShopCarItemInfo>) : void
      {
         this.view = new BuyMultiGoodsView();
         BuyMultiGoodsView(this.view).setGoods(param1);
         BuyMultiGoodsView(this.view).show();
      }
      
      public function get isShow() : Boolean
      {
         return Boolean(this.view) && Boolean(this.view.parent);
      }
      
      public function dispose() : void
      {
         if(Boolean(this.view) && Boolean(this.view.parent))
         {
            Disposeable(this.view).dispose();
            this.view = null;
         }
         if(Boolean(this.farmview) && Boolean(this.farmview.parent))
         {
            Disposeable(this.farmview).dispose();
            this.farmview = null;
         }
      }
   }
}
