package store.forge.wishBead
{
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.analyze.WishInfoAnalyzer;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.data.DictionaryData;
   
   public class WishBeadManager extends EventDispatcher
   {
      
      public static const EQUIP_MOVE:String = "wishBead_equip_move";
      
      public static const EQUIP_MOVE2:String = "wishBead_equip_move2";
      
      public static const ITEM_MOVE:String = "wishBead_item_move";
      
      public static const ITEM_MOVE2:String = "wishBead_item_move2";
      
      private static var _instance:store.forge.wishBead.WishBeadManager;
       
      
      public var wishInfoList:Vector.<store.forge.wishBead.WishChangeInfo>;
      
      public function WishBeadManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : store.forge.wishBead.WishBeadManager
      {
         if(_instance == null)
         {
            _instance = new store.forge.wishBead.WishBeadManager();
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
      
      public function getIsEquipMatchWishBead(param1:int, param2:int, param3:Boolean) : Boolean
      {
         switch(param1)
         {
            case EquipType.WISHBEAD_ATTACK:
               if(param2 == EquipType.ARM)
               {
                  return true;
               }
               if(param3)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wishBeadMainView.noMatchTipTxt"));
               }
               return false;
               break;
            case EquipType.WISHBEAD_DEFENSE:
               if(param2 == EquipType.CLOTH)
               {
                  return true;
               }
               if(param3)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wishBeadMainView.noMatchTipTxt2"));
               }
               return false;
               break;
            case EquipType.WISHBEAD_AGILE:
               if(param2 == EquipType.HEAD)
               {
                  return true;
               }
               if(param3)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wishBeadMainView.noMatchTipTxt3"));
               }
               return false;
               break;
            default:
               return false;
         }
      }
      
      public function getwishInfo(param1:WishInfoAnalyzer) : void
      {
         this.wishInfoList = param1._wishChangeInfo;
      }
      
      public function getWishInfoByTemplateID(param1:int, param2:int) : store.forge.wishBead.WishChangeInfo
      {
         var _loc3_:store.forge.wishBead.WishChangeInfo = null;
         var _loc4_:store.forge.wishBead.WishChangeInfo = null;
         for each(_loc3_ in this.wishInfoList)
         {
            if(_loc3_.OldTemplateId == param1)
            {
               return _loc3_;
            }
            if(_loc3_.OldTemplateId == -1 && _loc3_.CategoryID == param2)
            {
               _loc4_ = _loc3_;
            }
         }
         return _loc4_;
      }
   }
}
