package AvatarCollection.data
{
   import AvatarCollection.AvatarCollectionManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   
   public class AvatarCollectionItemVo
   {
       
      
      public var id:int;
      
      public var itemId:int;
      
      public var OtherTemplateID:String = "";
      
      public var sex:int;
      
      public var proArea:String;
      
      public var selected:Boolean = false;
      
      public var needGold:int;
      
      public var isActivity:Boolean;
      
      public var buyPrice:int = -1;
      
      public var isDiscount:int = -1;
      
      public var goodsId:int = -1;
      
      private var _canBuyStatus:int = -1;
      
      public var Type:int;
      
      public function AvatarCollectionItemVo()
      {
         super();
      }
      
      public function get activateItem() : InventoryItemInfo
      {
         var _loc1_:int = 0;
         var _loc2_:Array = this.OtherTemplateID == "" ? [] : this.OtherTemplateID.split("|");
         var _loc3_:BagInfo = PlayerManager.Instance.Self.getBag(0);
         var _loc4_:InventoryItemInfo = null;
         _loc2_.unshift(this.itemId);
         _loc1_ = 0;
         while(_loc1_ < _loc2_.length)
         {
            if(int(_loc2_[_loc1_]) != 0)
            {
               if((_loc4_ = _loc3_.getItemByTemplateId(int(_loc2_[_loc1_]))) != null)
               {
                  break;
               }
            }
            _loc1_++;
         }
         return _loc4_;
      }
      
      public function get isHas() : Boolean
      {
         return this.activateItem != null;
      }
      
      public function get itemInfo() : ItemTemplateInfo
      {
         return ItemManager.Instance.getTemplateById(this.itemId);
      }
      
      public function get canBuyStatus() : int
      {
         var _loc1_:* = null;
         if(this._canBuyStatus == -1)
         {
            _loc1_ = AvatarCollectionManager.instance.getShopItemInfoByItemId(this.itemId,this.sex,this.Type);
            if(_loc1_)
            {
               this._canBuyStatus = 1;
               this.buyPrice = _loc1_.getItemPrice(1).moneyValue;
               if(this.buyPrice <= 0)
               {
                  this.buyPrice = _loc1_.getItemPrice(1).bothMoneyValue;
               }
               this.isDiscount = _loc1_.isDiscount;
               this.goodsId = _loc1_.GoodsID;
            }
            else
            {
               this._canBuyStatus = 0;
            }
         }
         return this._canBuyStatus;
      }
      
      public function get priceType() : int
      {
         var _loc1_:int = 1;
         var _loc2_:ShopItemInfo = ShopManager.Instance.getGoodsByTempId(this.itemId);
         if(Boolean(_loc2_))
         {
            _loc1_ = _loc2_.APrice1 == -8 ? 0 : _loc1_;
         }
         return _loc1_;
      }
      
      public function set canBuyStatus(param1:int) : void
      {
         this._canBuyStatus = param1;
      }
      
      public function get typeToString() : String
      {
         if(this.Type == 1)
         {
            return LanguageMgr.GetTranslation("avatarCollection.select.decorate");
         }
         return LanguageMgr.GetTranslation("avatarCollection.select.weapon");
      }
   }
}
