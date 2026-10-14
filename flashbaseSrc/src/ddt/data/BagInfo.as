package ddt.data
{
   import cardSystem.CardControl;
   import cardSystem.data.CardInfo;
   import cardSystem.data.SetsInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   import store.forge.ForgeMainView;
   
   [Event(name="update",type="ddt.events.BagEvent")]
   public class BagInfo extends EventDispatcher
   {
      
      public static const EQUIPBAG:int = 0;
      
      public static const PROPBAG:int = 1;
      
      public static const TASKBAG:int = 2;
      
      public static const FIGHTBAG:int = 3;
      
      public static const TEMPBAG:int = 4;
      
      public static const CADDYBAG:int = 5;
      
      public static const BANKBAG:int = 51;
      
      public static const CONSORTIA:int = 11;
      
      public static const FARM:int = 13;
      
      public static const VEGETABLE:int = 14;
      
      public static const FOOD_OLD:int = 32;
      
      public static const FOOD:int = 34;
      
      public static const PETEGG:int = 35;
      
      public static const MAXPROPCOUNT:int = 48;
      
      public static const STOREBAG:int = 12;
      
      public static const PERSONAL_EQUIP_COUNT:int = 30;
       
      
      private var _type:int;
      
      private var _capability:int;
      
      private var _items:DictionaryData;
      
      private var _changedCount:int = 0;
      
      private var _changedSlots:Dictionary;
      
      public const NUMBER:Number = 1;
      
      public function BagInfo(param1:int, param2:int)
      {
         this._changedSlots = new Dictionary();
         super();
         this._type = param1;
         this._items = new DictionaryData();
         this._capability = param2;
      }
      
      public static function parseCategoryID(param1:int, param2:int) : int
      {
         var _loc3_:int = -1;
         if(param1 != 0 || param2 > 30)
         {
            return _loc3_;
         }
         switch(int(param2))
         {
            case 0:
               _loc3_ = 1;
               break;
            case 4:
               _loc3_ = 5;
               break;
            case 6:
               _loc3_ = 7;
         }
         return _loc3_;
      }
      
      public function getBagFullByIndex(param1:int, param2:int) : Boolean
      {
         var _loc3_:* = 0;
         _loc3_ = param1;
         while(_loc3_ < param2)
         {
            if(this._items[_loc3_] == null)
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      public function get BagType() : int
      {
         return this._type;
      }
      
      public function getItemAt(param1:int) : InventoryItemInfo
      {
         return this._items[param1];
      }
      
      public function get items() : DictionaryData
      {
         return this._items;
      }
      
      public function get itemNumber() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < 49)
         {
            if(this._items[_loc2_] != null)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function set items(param1:DictionaryData) : void
      {
         this._items = param1;
      }
      
      public function addItem(param1:InventoryItemInfo) : void
      {
         param1.fromBag = true;
         param1.BagType = this._type;
         this._items.add(param1.Place,param1);
         this.onItemChanged(param1.Place,param1);
      }
      
      public function addItemIntoFightBag(param1:int, param2:int = 1) : void
      {
         var _loc3_:InventoryItemInfo = new InventoryItemInfo();
         _loc3_.BagType = FIGHTBAG;
         _loc3_.Place = this.findFirstPlace();
         _loc3_.Count = param2;
         _loc3_.TemplateID = param1;
         ItemManager.fill(_loc3_);
         this.addItem(_loc3_);
      }
      
      private function findFirstPlace() : int
      {
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            if(this.getItemAt(_loc1_) == null)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return -1;
      }
      
      public function removeItemAt(param1:int) : void
      {
         var _loc2_:InventoryItemInfo = this._items[param1];
         if(Boolean(_loc2_))
         {
            _loc2_.fromBag = false;
            this._items.remove(param1);
            if(this._type == TEMPBAG && StateManager.currentStateType == StateType.FIGHTING)
            {
               return;
            }
            this.onItemChanged(param1,_loc2_);
         }
      }
      
      public function updateItem(param1:InventoryItemInfo) : void
      {
         if(param1.BagType == this._type)
         {
            this.onItemChanged(param1.Place,param1);
         }
      }
      
      public function beginChanges() : void
      {
         ++this._changedCount;
      }
      
      public function commiteChanges() : void
      {
         --this._changedCount;
         if(this._changedCount <= 0)
         {
            this._changedCount = 0;
            this.updateChanged();
         }
      }
      
      protected function onItemChanged(param1:int, param2:InventoryItemInfo) : void
      {
         this._changedSlots[param1] = param2;
         if(this._changedCount <= 0)
         {
            this._changedCount = 0;
            this.updateChanged();
         }
      }
      
      protected function updateChanged() : void
      {
         if(ForgeMainView.IsExalt == true)
         {
            dispatchEvent(new BagEvent(BagEvent.UPDATE_Exalt,this._changedSlots));
         }
         else
         {
            dispatchEvent(new BagEvent(BagEvent.UPDATE,this._changedSlots));
         }
         this._changedSlots = new Dictionary();
      }
      
      public function findItems(param1:int, param2:Boolean = true) : Array
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:Array = new Array();
         for each(_loc3_ in this._items)
         {
            if(_loc3_.CategoryID == param1)
            {
               if(!param2 || _loc3_.getRemainDate() > 0)
               {
                  _loc4_.push(_loc3_);
               }
            }
         }
         return _loc4_;
      }
      
      public function findFirstItem(param1:int, param2:Boolean = true) : InventoryItemInfo
      {
         var _loc3_:InventoryItemInfo = null;
         for each(_loc3_ in this._items)
         {
            if(_loc3_.CategoryID == param1)
            {
               if(!param2 || _loc3_.getRemainDate() > 0)
               {
                  return _loc3_;
               }
            }
         }
         return null;
      }
      
      public function findEquipedItemByTemplateId(param1:int, param2:Boolean = true) : InventoryItemInfo
      {
         var _loc3_:InventoryItemInfo = null;
         for each(_loc3_ in this._items)
         {
            if(_loc3_.TemplateID == param1)
            {
               if(_loc3_.Place <= 30)
               {
                  if(!param2 || _loc3_.getRemainDate() > 0)
                  {
                     return _loc3_;
                  }
               }
            }
         }
         return null;
      }
      
      public function findOvertimeItems(param1:Number = 0) : Array
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:Number = NaN;
         var _loc4_:Array = new Array();
         for each(_loc2_ in this._items)
         {
            _loc3_ = _loc2_.getRemainDate();
            if(_loc3_ > param1 && _loc3_ < this.NUMBER)
            {
               _loc4_.push(_loc2_);
            }
         }
         return _loc4_;
      }
      
      public function getItemByTemplateId(param1:int) : InventoryItemInfo
      {
         var _loc2_:InventoryItemInfo = null;
         for each(_loc2_ in this._items)
         {
            if(_loc2_.TemplateID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function findOvertimeItemsByBody() : Array
      {
         var _loc1_:Number = NaN;
         var _loc2_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < 30)
         {
            if(Boolean(this._items[_loc3_] as InventoryItemInfo))
            {
               _loc1_ = (this._items[_loc3_] as InventoryItemInfo).getRemainDate();
               if(_loc1_ <= 0 && ShopManager.Instance.canAddPrice((this._items[_loc3_] as InventoryItemInfo).TemplateID))
               {
                  _loc2_.push(this._items[_loc3_]);
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function findOvertimeItemsByBodyII() : Array
      {
         var _loc1_:Number = NaN;
         var _loc2_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < 80)
         {
            if(Boolean(this._items[_loc3_] as InventoryItemInfo))
            {
               if(_loc3_ < 30)
               {
                  _loc1_ = (this._items[_loc3_] as InventoryItemInfo).getRemainDate();
               }
               if((this._items[_loc3_] as InventoryItemInfo).isGold)
               {
                  _loc1_ = (this._items[_loc3_] as InventoryItemInfo).getGoldRemainDate();
               }
               if(_loc1_ <= 0)
               {
                  _loc2_.push(this._items[_loc3_]);
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function findItemsForEach(param1:int, param2:Boolean = true) : Array
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:DictionaryData = new DictionaryData();
         for each(_loc3_ in this._items)
         {
            if(_loc3_.CategoryID == param1 && _loc4_[_loc3_.TemplateID] == null)
            {
               if(!param2 || _loc3_.getRemainDate() > 0)
               {
                  _loc4_.add(_loc3_.TemplateID,_loc3_);
               }
            }
         }
         return _loc4_.list;
      }
      
      public function findFistItemByTemplateId(param1:int, param2:Boolean = true, param3:Boolean = false) : InventoryItemInfo
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:InventoryItemInfo = null;
         var _loc6_:InventoryItemInfo = null;
         for each(_loc4_ in this._items)
         {
            if(_loc4_.TemplateID == param1 && (!param2 || _loc4_.getRemainDate() > 0))
            {
               if(!param3)
               {
                  return _loc4_;
               }
               if(_loc4_.IsUsed)
               {
                  if(_loc5_ == null)
                  {
                     _loc5_ = _loc4_;
                  }
               }
               else if(_loc6_ == null)
               {
                  _loc6_ = _loc4_;
               }
            }
         }
         return Boolean(_loc5_) ? _loc5_ : _loc6_;
      }
      
      public function findBodyThingByCategory(param1:int) : Array
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < 30)
         {
            _loc2_ = this._items[_loc4_] as InventoryItemInfo;
            if(_loc2_ != null)
            {
               if(_loc2_.CategoryID == param1)
               {
                  _loc3_.push(_loc2_);
               }
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getItemCountByTemplateId(param1:int, param2:Boolean = true) : int
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:int = 0;
         for each(_loc3_ in this._items)
         {
            if(_loc3_.TemplateID == param1 && (!param2 || _loc3_.getRemainDate() > 0))
            {
               _loc4_ += _loc3_.Count;
            }
         }
         return _loc4_;
      }
      
      public function findItemsByTempleteID(param1:int, param2:Boolean = true) : Array
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:DictionaryData = new DictionaryData();
         for each(_loc3_ in this._items)
         {
            if(_loc3_.TemplateID == param1 && _loc4_[_loc3_.TemplateID] == null)
            {
               if(!param2 || _loc3_.getRemainDate() > 0)
               {
                  _loc4_.add(_loc3_.TemplateID,_loc3_);
               }
            }
         }
         return _loc4_.list;
      }
      
      public function findCellsByTempleteID(param1:int, param2:Boolean = true) : Array
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:Array = new Array();
         for each(_loc3_ in this._items)
         {
            if(_loc3_.TemplateID == param1 && (!param2 || _loc3_.getRemainDate() > 0))
            {
               _loc4_.push(_loc3_);
            }
         }
         return _loc4_;
      }
      
      public function clearnAll() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 49)
         {
            this.removeItemAt(_loc1_);
            _loc1_++;
         }
      }
      
      public function unlockItem(param1:InventoryItemInfo) : void
      {
         param1.lock = false;
         this.onItemChanged(param1.Place,param1);
      }
      
      public function unLockAll() : void
      {
         var _loc1_:InventoryItemInfo = null;
         this.beginChanges();
         for each(_loc1_ in this._items)
         {
            if(_loc1_.lock)
            {
               this.onItemChanged(_loc1_.Place,_loc1_);
            }
            _loc1_.lock = false;
         }
         this.commiteChanges();
      }
      
      public function sortBag(param1:int, param2:BagInfo, param3:int, param4:int, param5:Boolean = false) : void
      {
         var _loc6_:DictionaryData = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:ByteArray = null;
         if(param1 != 2)
         {
            _loc6_ = param2.items;
            _loc7_ = [];
            _loc8_ = [];
            _loc9_ = 0;
            _loc10_ = int(_loc6_.list.length);
            _loc11_ = 0;
            if(param2 == PlayerManager.Instance.Self.Bag)
            {
               _loc11_ = 31;
            }
            while(_loc12_ < _loc10_)
            {
               if(int(_loc6_.list[_loc12_].Place) >= _loc11_)
               {
                  _loc7_.push({
                     "TemplateID":_loc6_.list[_loc12_].TemplateID,
                     "ItemID":_loc6_.list[_loc12_].ItemID,
                     "CategoryIDSort":this.getBagGoodsCategoryIDSort(uint(_loc6_.list[_loc12_].CategoryID)),
                     "Place":_loc6_.list[_loc12_].Place,
                     "RemainDate":_loc6_.list[_loc12_].getRemainDate() > 0,
                     "CanStrengthen":_loc6_.list[_loc12_].CanStrengthen,
                     "StrengthenLevel":_loc6_.list[_loc12_].StrengthenLevel,
                     "IsBinds":_loc6_.list[_loc12_].IsBinds
                  });
               }
               _loc12_++;
            }
            _loc13_ = new ByteArray();
            _loc13_.writeObject(_loc7_);
            _loc13_.position = 0;
            _loc8_ = _loc13_.readObject() as Array;
            _loc7_.sortOn(["RemainDate","CategoryIDSort","TemplateID","CanStrengthen","IsBinds","StrengthenLevel","Place"],[Array.DESCENDING,Array.NUMERIC,Array.NUMERIC | Array.DESCENDING,Array.DESCENDING,Array.DESCENDING,Array.NUMERIC | Array.DESCENDING,Array.NUMERIC]);
            if(this.bagComparison(_loc7_,_loc8_,_loc11_) && !param5)
            {
               return;
            }
            SocketManager.Instance.out.sendMoveGoodsAll(param2.BagType,_loc7_,_loc11_,param5);
         }
         else if(param1 == 2 && param5)
         {
            this.sortCard();
         }
      }
      
      private function sortCard() : void
      {
         var _loc1_:Vector.<int> = null;
         var _loc2_:int = 0;
         var _loc3_:DictionaryData = null;
         var _loc4_:CardInfo = null;
         var _loc5_:Vector.<int> = new Vector.<int>();
         var _loc6_:Vector.<SetsInfo> = CardControl.Instance.model.setsSortRuleVector;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_.length)
         {
            _loc1_ = _loc6_[_loc7_].cardIdVec;
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               _loc3_ = PlayerManager.Instance.Self.cardBagDic;
               for each(_loc4_ in _loc3_)
               {
                  if(_loc4_.TemplateID == _loc1_[_loc2_])
                  {
                     _loc5_.push(_loc4_.Place);
                     break;
                  }
               }
               _loc2_++;
            }
            _loc7_++;
         }
         SocketManager.Instance.out.sendSortCards(_loc5_);
      }
      
      public function getBagGoodsCategoryIDSort(param1:uint) : int
      {
         var _loc2_:Array = [EquipType.ARM,EquipType.OFFHAND,EquipType.HEAD,EquipType.CLOTH,EquipType.ARMLET,EquipType.RING,EquipType.GLASS,EquipType.NECKLACE,EquipType.SUITS,EquipType.WING,EquipType.HAIR,EquipType.FACE,EquipType.EFF,EquipType.CHATBALL];
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(param1 == _loc2_[_loc3_])
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return 9999;
      }
      
      private function bagComparison(param1:Array, param2:Array, param3:int) : Boolean
      {
         if(param1.length < param2.length)
         {
            return false;
         }
         var _loc4_:int = int(param1.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(_loc5_ + param3 != param2[_loc5_].Place || param1[_loc5_].ItemID != param2[_loc5_].ItemID || param1[_loc5_].TemplateID != param2[_loc5_].TemplateID)
            {
               return false;
            }
            _loc5_++;
         }
         return true;
      }
      
      public function itemBgNumber(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = param1;
         while(_loc4_ <= param2)
         {
            if(this._items[_loc4_] != null)
            {
               _loc3_++;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getLimitSLItemCountByTemplateId(param1:int, param2:int = -1, param3:Boolean = true) : int
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:int = 0;
         for each(_loc4_ in this._items)
         {
            if(_loc4_.TemplateID == param1 && _loc4_.Place > 30 && (_loc4_.StrengthenLevel == param2 || param2 == -1) && (!param3 || _loc4_.getRemainDate() > 0))
            {
               _loc5_ += _loc4_.Count;
            }
         }
         return _loc5_;
      }
   }
}
