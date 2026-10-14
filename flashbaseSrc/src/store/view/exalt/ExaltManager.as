package store.view.exalt
{
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.data.DictionaryData;
   
   public class ExaltManager extends EventDispatcher
   {
      
      public static const EQUIP_MOVE:String = "exalt_equip_move";
      
      public static const EQUIP_MOVE2:String = "exalt_equip_move2";
      
      public static const ITEM_MOVE:String = "exalt_item_move";
      
      public static const ITEM_MOVE2:String = "exalt_item_move2";
      
      private static var _instance:store.view.exalt.ExaltManager;
       
      
      public function ExaltManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : store.view.exalt.ExaltManager
      {
         if(_instance == null)
         {
            _instance = new store.view.exalt.ExaltManager();
         }
         return _instance;
      }
      
      public function getCanWishBeadData() : BagInfo
      {
         var _loc1_:InventoryItemInfo = null;
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:DictionaryData = PlayerManager.Instance.Self.Bag.items;
         var _loc4_:BagInfo = new BagInfo(BagInfo.EQUIPBAG,21);
         var _loc5_:Array = new Array();
         for each(_loc1_ in _loc3_)
         {
            if(_loc1_.StrengthenLevel >= 12 && (_loc1_.CategoryID == EquipType.ARM || _loc1_.CategoryID == EquipType.CLOTH || _loc1_.CategoryID == EquipType.HEAD))
            {
               if(_loc1_.Place < 17)
               {
                  _loc4_.addItem(_loc1_);
               }
               else
               {
                  _loc5_.push(_loc1_);
               }
            }
         }
         for each(_loc2_ in _loc5_)
         {
            _loc4_.addItem(_loc2_);
         }
         return _loc4_;
      }
      
      public function getWishBeadItemData() : BagInfo
      {
         var _loc1_:InventoryItemInfo = null;
         var _loc2_:DictionaryData = PlayerManager.Instance.Self.PropBag.items;
         var _loc3_:BagInfo = new BagInfo(BagInfo.PROPBAG,21);
         for each(_loc1_ in _loc2_)
         {
            if(_loc1_.TemplateID == EquipType.WISHBEAD_ATTACK || _loc1_.TemplateID == EquipType.WISHBEAD_DEFENSE || _loc1_.TemplateID == EquipType.WISHBEAD_AGILE)
            {
               _loc3_.addItem(_loc1_);
            }
         }
         return _loc3_;
      }
   }
}
