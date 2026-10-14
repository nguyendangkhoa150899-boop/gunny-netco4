package store.view.exalt
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.view.tips.GoodTipInfo;
   import store.view.strength.LaterEquipmentView;
   import store.view.strength.StrengthTips;
   import store.view.strength.manager.ItemStrengthenGoodsInfoManager;
   import store.view.strength.vo.ItemStrengthenGoodsInfo;
   
   public class ExaltTips extends StrengthTips
   {
       
      
      public function ExaltTips()
      {
         super();
      }
      
      override protected function laterEquipment(param1:GoodTipInfo) : void
      {
         var _loc2_:ItemStrengthenGoodsInfo = null;
         var _loc3_:ItemTemplateInfo = null;
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:GoodTipInfo = null;
         var _loc6_:InventoryItemInfo = null;
         if(syahTip != null)
         {
            syahTip.visible = false;
         }
         if(Boolean(param1))
         {
            _loc6_ = param1.itemInfo as InventoryItemInfo;
         }
         if(Boolean(_loc6_) && _loc6_.StrengthenLevel < 15)
         {
            _loc5_ = new GoodTipInfo();
            _loc4_ = new InventoryItemInfo();
            ObjectUtils.copyProperties(_loc4_,_loc6_);
            _loc4_.StrengthenLevel += 1;
            _loc2_ = ItemStrengthenGoodsInfoManager.findItemStrengthenGoodsInfo(_loc4_.TemplateID,_loc4_.StrengthenLevel);
            if(Boolean(_loc2_))
            {
               _loc4_.TemplateID = _loc2_.GainEquip;
               _loc3_ = ItemManager.Instance.getTemplateById(_loc4_.TemplateID);
               if(Boolean(_loc3_))
               {
                  _loc4_.Attack = _loc3_.Attack;
                  _loc4_.Defence = _loc3_.Defence;
                  _loc4_.Agility = _loc3_.Agility;
                  _loc4_.Luck = _loc3_.Luck;
               }
            }
            _loc5_.itemInfo = _loc4_;
            if(!_laterEquipmentView)
            {
               _laterEquipmentView = new LaterEquipmentView();
            }
            _laterEquipmentView.x = _tipbackgound.x + _tipbackgound.width + 35;
            if(!this.contains(_laterEquipmentView))
            {
               addChild(_laterEquipmentView);
            }
            _laterEquipmentView.tipData = _loc5_;
         }
         else
         {
            if(Boolean(_laterEquipmentView))
            {
               ObjectUtils.disposeObject(_laterEquipmentView);
            }
            _laterEquipmentView = null;
         }
      }
   }
}
