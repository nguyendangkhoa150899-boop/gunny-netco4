package store.data
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.StoneType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import store.events.StoreBagEvent;
   import store.events.UpdateItemEvent;
   
   public class StoreModel extends EventDispatcher
   {
      
      private static const FORMULA_FLOCCULANT:int = 11301;
      
      private static const FORMULA_BIRD:int = 11201;
      
      private static const FORMULA_SNAKE:int = 11202;
      
      private static const FORMULA_DRAGON:int = 11203;
      
      private static const FORMULA_TIGER:int = 11204;
      
      private static const FORMULA_RING:int = 11302;
      
      private static const FORMULA_BANGLE:int = 11303;
      
      private static const RING_TIANYU:int = 9002;
      
      private static const RIN_GZHUFU:int = 8002;
      
      private static var _holeExpModel:store.data.HoleExpModel;
       
      
      private var _info:SelfInfo;
      
      private var _equipmentBag:DictionaryData;
      
      private var _propBag:DictionaryData;
      
      private var _canCpsEquipmentList:DictionaryData;
      
      private var _canStrthEqpmtList:DictionaryData;
      
      private var _strthAndANchList:DictionaryData;
      
      private var _cpsAndANchList:DictionaryData;
      
      private var _cpsAndStrthAndformula:DictionaryData;
      
      private var _canRongLiangPropList:DictionaryData;
      
      private var _canTransEquipmengtList:DictionaryData;
      
      private var _canRongLiangEquipmengtList:DictionaryData;
      
      private var _canLianhuaEquipList:DictionaryData;
      
      private var _canLianhuaPropList:DictionaryData;
      
      private var _canEmbedEquipList:DictionaryData;
      
      private var _canEmbedPropList:DictionaryData;
      
      private var _canExaltEqpmtList:DictionaryData;
      
      private var _exaltRock:DictionaryData;
      
      private var _canWishBeadEqpmtList:DictionaryData;
      
      private var _wishBeadRock:DictionaryData;
      
      private var _currentPanel:int;
      
      private var _needAutoLink:int = 0;
      
      public var rateList1:Dictionary;
      
      public var rateList2:Dictionary;
      
      public var rateList3:Dictionary;
      
      public var rateList4:Dictionary;
      
      private var _canGhostEquipList:DictionaryData;
      
      private var _canGhostPropList:DictionaryData;
      
      public function StoreModel(param1:PlayerInfo)
      {
         super();
         this._info = param1 as SelfInfo;
         this._equipmentBag = this._info.Bag.items;
         this._propBag = this._info.PropBag.items;
         this.initData();
         this.initEvent();
      }
      
      public static function getHoleMaxLv() : int
      {
         if(_holeExpModel == null)
         {
            _holeExpModel = ComponentFactory.Instance.creatCustomObject("HoleExpModel");
         }
         return _holeExpModel.getMaxLv();
      }
      
      public static function getHoleMaxOpLv() : int
      {
         if(_holeExpModel == null)
         {
            _holeExpModel = ComponentFactory.Instance.creatCustomObject("HoleExpModel");
         }
         return _holeExpModel.getMaxOpLv();
      }
      
      public static function getHoleExpByLv(param1:int) : int
      {
         if(_holeExpModel == null)
         {
            _holeExpModel = ComponentFactory.Instance.creatCustomObject("HoleExpModel");
         }
         return _holeExpModel.getExpByLevel(param1);
      }
      
      private function initData() : void
      {
         this._canStrthEqpmtList = new DictionaryData();
         this._canCpsEquipmentList = new DictionaryData();
         this._strthAndANchList = new DictionaryData();
         this._cpsAndANchList = new DictionaryData();
         this._canTransEquipmengtList = new DictionaryData();
         this._canLianhuaEquipList = new DictionaryData();
         this._canLianhuaPropList = new DictionaryData();
         this._canEmbedEquipList = new DictionaryData();
         this._canEmbedPropList = new DictionaryData();
         this._canExaltEqpmtList = new DictionaryData();
         this._canWishBeadEqpmtList = new DictionaryData();
         this._canGhostEquipList = new DictionaryData();
         this._canGhostPropList = new DictionaryData();
         this._exaltRock = new DictionaryData();
         this._wishBeadRock = new DictionaryData();
         this._canRongLiangPropList = new DictionaryData();
         this._canRongLiangEquipmengtList = new DictionaryData();
         this.pickValidItemsOutOf(this._equipmentBag,true);
         this.pickValidItemsOutOf(this._propBag,false);
         this._canStrthEqpmtList = this.sortEquipList(this._canStrthEqpmtList);
         this._canCpsEquipmentList = this.sortEquipList(this._canCpsEquipmentList);
         this._strthAndANchList = this.sortPropList(this._strthAndANchList);
         this._cpsAndANchList = this.sortPropList(this._cpsAndANchList,true);
         this._canRongLiangPropList = this.sortPropList(this._canRongLiangPropList);
         this._canTransEquipmengtList = this.sortEquipList(this._canTransEquipmengtList);
         this._canLianhuaEquipList = this.sortEquipList(this._canLianhuaEquipList);
         this._canLianhuaPropList = this.sortPropList(this._canLianhuaPropList);
         this._canEmbedEquipList = this.sortEquipList(this._canEmbedEquipList);
         this._canEmbedPropList = this.sortPropList(this._canEmbedPropList);
         this._canExaltEqpmtList = this.sortEquipList(this._canExaltEqpmtList);
         this._canWishBeadEqpmtList = this.sortEquipList(this._canWishBeadEqpmtList);
         this._canRongLiangEquipmengtList = this.sortRoogEquipList(this._canRongLiangEquipmengtList);
         this._canGhostEquipList = this.sortEquipList(this._canGhostEquipList);
      }
      
      private function pickValidItemsOutOf(param1:DictionaryData, param2:Boolean) : void
      {
         var _loc3_:InventoryItemInfo = null;
         for each(_loc3_ in param1)
         {
            if(param2)
            {
               if(this.isProperTo_CanStrthEqpmtList(_loc3_))
               {
                  this._canStrthEqpmtList.add(this._canStrthEqpmtList.length,_loc3_);
               }
               if(this.isProperTo_CanGhostEquipList(_loc3_))
               {
                  this._canGhostEquipList.add(this._canGhostEquipList.length,_loc3_);
               }
               if(this.isProperTo_CanCpsEquipmentList(_loc3_))
               {
                  this._canCpsEquipmentList.add(this._canCpsEquipmentList.length,_loc3_);
               }
               if(this.isProperTo_CanRongLiangEquipmengtList(_loc3_))
               {
                  this._canRongLiangEquipmengtList.add(this._canRongLiangEquipmengtList.length,_loc3_);
               }
               if(this.isProperTo_CanTransEquipmengtList(_loc3_))
               {
                  this._canTransEquipmengtList.add(this._canTransEquipmengtList.length,_loc3_);
               }
               if(this.isProperTo_canLianhuaEquipList(_loc3_))
               {
                  this._canLianhuaEquipList.add(this._canLianhuaEquipList.length,_loc3_);
               }
               if(this.isProperTo_CanEmbedEquipList(_loc3_))
               {
                  this._canEmbedEquipList.add(this._canEmbedEquipList.length,_loc3_);
               }
               if(this.isProperTo_CanExaltEqpmtList(_loc3_))
               {
                  this._canExaltEqpmtList.add(this._canExaltEqpmtList.length,_loc3_);
               }
               if(this.isProperTo_CanWishBeadEqpmtList(_loc3_))
               {
                  this._canWishBeadEqpmtList.add(this._canWishBeadEqpmtList.length,_loc3_);
               }
            }
            else
            {
               if(this.isProperTo_StrthAndANchList(_loc3_))
               {
                  this._strthAndANchList.add(this._strthAndANchList.length,_loc3_);
               }
               if(this.isProperTo_CpsAndANchList(_loc3_))
               {
                  this._cpsAndANchList.add(this._cpsAndANchList.length,_loc3_);
               }
               if(this.isProperTo_canLianhuaPropList(_loc3_))
               {
                  this._canLianhuaPropList.add(this._canLianhuaPropList.length,_loc3_);
               }
               if(this.isProperTo_CanEmbedPropList(_loc3_))
               {
                  this._canEmbedPropList.add(this._canEmbedPropList.length,_loc3_);
               }
               if(this.isProperTo_canRongLiangProperList(_loc3_))
               {
                  this._canRongLiangPropList.add(this._canRongLiangPropList.length,_loc3_);
               }
               if(this.isProperTo_ExaltList(_loc3_))
               {
                  this._exaltRock.add(this._exaltRock.length,_loc3_);
               }
               if(this.isProperTo_WishBeadList(_loc3_))
               {
                  this._wishBeadRock.add(this._wishBeadRock.length,_loc3_);
               }
               if(this.isProperTo_CanGhostPropList(_loc3_))
               {
                  this._canGhostPropList.add(this._canGhostPropList.length,_loc3_);
               }
            }
         }
      }
      
      private function isProperTo_ExaltList(param1:InventoryItemInfo) : Boolean
      {
         if(param1.getRemainDate() <= 0)
         {
            return false;
         }
         if(param1.CategoryID == 11 && param1.Property1 == "45")
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_WishBeadList(param1:InventoryItemInfo) : Boolean
      {
         if(param1.getRemainDate() <= 0)
         {
            return false;
         }
         if(param1.CategoryID == 11 && param1.Property1 == "10")
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_canRongLiangProperList(param1:InventoryItemInfo) : Boolean
      {
         if(param1.Property1 == StoneType.FORMULA)
         {
            return true;
         }
         if(param1.FusionType != 0 && param1.getRemainDate() > 0)
         {
            return true;
         }
         return false;
      }
      
      private function initEvent() : void
      {
         this._info.PropBag.addEventListener(BagEvent.UPDATE,this.updateBag);
         this._info.Bag.addEventListener(BagEvent.UPDATE,this.updateBag);
         this._info.PropBag.addEventListener(BagEvent.UPDATE_Exalt,this.updateBag);
         this._info.Bag.addEventListener(BagEvent.UPDATE_Exalt,this.updateBag);
      }
      
      private function updateBag(param1:BagEvent) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:BagInfo = param1.target as BagInfo;
         var _loc5_:Dictionary = param1.changedSlots;
         for each(_loc2_ in _loc5_)
         {
            _loc3_ = _loc4_.getItemAt(_loc2_.Place);
            if(Boolean(_loc3_))
            {
               if(_loc4_.BagType == BagInfo.EQUIPBAG)
               {
                  this.__updateEquip(_loc3_);
               }
               else if(_loc4_.BagType == BagInfo.PROPBAG)
               {
                  this.__updateProp(_loc3_);
               }
            }
            else if(_loc4_.BagType == BagInfo.EQUIPBAG)
            {
               this.removeFrom(_loc2_,this._canStrthEqpmtList);
               this.removeFrom(_loc2_,this._canCpsEquipmentList);
               this.removeFrom(_loc2_,this._canTransEquipmengtList);
               this.removeFrom(_loc2_,this._canLianhuaEquipList);
               this.removeFrom(_loc2_,this._canEmbedEquipList);
               this.removeFrom(_loc2_,this._canRongLiangEquipmengtList);
               this.removeFrom(_loc2_,this._canExaltEqpmtList);
               this.removeFrom(_loc2_,this._canWishBeadEqpmtList);
               this.removeFrom(_loc2_,this._canGhostEquipList);
            }
            else
            {
               this.removeFrom(_loc2_,this._strthAndANchList);
               this.removeFrom(_loc2_,this._cpsAndANchList);
               this.removeFrom(_loc2_,this._canRongLiangPropList);
               this.removeFrom(_loc2_,this._canLianhuaPropList);
               this.removeFrom(_loc2_,this._canEmbedPropList);
               this.removeFrom(_loc2_,this._exaltRock);
               this.removeFrom(_loc2_,this._wishBeadRock);
               this.removeFrom(_loc2_,this._canGhostPropList);
            }
         }
      }
      
      private function isProperTo_CanGhostEquipList(param1:InventoryItemInfo) : Boolean
      {
         var _loc2_:Array = [1,5,7];
         if(param1.Place > 30 || _loc2_.lastIndexOf(param1.CategoryID) == -1)
         {
            return false;
         }
         var _loc3_:InventoryItemInfo = PlayerManager.Instance.Self.Bag.getItemAt(param1.Place);
         return _loc3_ != null;
      }
      
      private function __updateEquip(param1:InventoryItemInfo) : void
      {
         if(this.isProperTo_CanGhostEquipList(param1))
         {
            this.updateDic(this._canGhostEquipList,param1);
         }
         else
         {
            this.removeFrom(param1,this._canGhostEquipList);
         }
         if(this.isProperTo_CanStrthEqpmtList(param1))
         {
            this.updateDic(this._canStrthEqpmtList,param1);
         }
         else
         {
            this.removeFrom(param1,this._canStrthEqpmtList);
         }
         if(this.isProperTo_CanCpsEquipmentList(param1))
         {
            this.updateDic(this._canCpsEquipmentList,param1);
         }
         else
         {
            this.removeFrom(param1,this._canCpsEquipmentList);
         }
         if(this.isProperTo_CanTransEquipmengtList(param1))
         {
            this.updateDic(this._canTransEquipmengtList,param1);
         }
         else
         {
            this.removeFrom(param1,this._canTransEquipmengtList);
         }
         if(this.isProperTo_CanRongLiangEquipmengtList(param1))
         {
            this.updateDic(this._canRongLiangEquipmengtList,param1);
         }
         else
         {
            this.removeFrom(param1,this._canRongLiangEquipmengtList);
         }
         if(this.isProperTo_canLianhuaEquipList(param1))
         {
            this.updateDic(this._canLianhuaEquipList,param1);
         }
         else
         {
            this.removeFrom(param1,this._canLianhuaEquipList);
         }
         if(this.isProperTo_CanEmbedEquipList(param1))
         {
            this.updateDic(this._canEmbedEquipList,param1);
         }
         else
         {
            this.removeFrom(param1,this._canEmbedEquipList);
         }
         if(this.isProperTo_CanExaltEqpmtList(param1))
         {
            this.updateDic(this._canExaltEqpmtList,param1);
         }
         else
         {
            this.removeFrom(param1,this._canExaltEqpmtList);
         }
         if(this.isProperTo_CanWishBeadEqpmtList(param1))
         {
            this.updateDic(this._canWishBeadEqpmtList,param1);
         }
         else
         {
            this.removeFrom(param1,this._canWishBeadEqpmtList);
         }
      }
      
      private function __updateProp(param1:InventoryItemInfo) : void
      {
         if(this.isProperTo_CpsAndANchList(param1))
         {
            this.updateDic(this._cpsAndANchList,param1);
         }
         else
         {
            this.removeFrom(param1,this._cpsAndANchList);
         }
         if(this.isProperTo_ExaltList(param1))
         {
            this.updateDic(this._exaltRock,param1);
         }
         else
         {
            this.removeFrom(param1,this._exaltRock);
         }
         if(this.isProperTo_WishBeadList(param1))
         {
            this.updateDic(this._wishBeadRock,param1);
         }
         else
         {
            this.removeFrom(param1,this._wishBeadRock);
         }
         if(this.isProperTo_canRongLiangProperList(param1))
         {
            this.updateDic(this._canRongLiangPropList,param1);
         }
         else
         {
            this.removeFrom(param1,this._canRongLiangPropList);
         }
         if(this.isProperTo_StrthAndANchList(param1))
         {
            this.updateDic(this._strthAndANchList,param1);
         }
         else
         {
            this.removeFrom(param1,this._strthAndANchList);
         }
         if(this.isProperTo_canLianhuaPropList(param1))
         {
            this.updateDic(this._canLianhuaPropList,param1);
         }
         else
         {
            this.removeFrom(param1,this._canLianhuaPropList);
         }
         if(this.isProperTo_CanEmbedPropList(param1))
         {
            this.updateDic(this._canEmbedPropList,param1);
         }
         else
         {
            this.removeFrom(param1,this._canEmbedPropList);
         }
         if(this.isProperTo_CanGhostPropList(param1))
         {
            this.updateDic(this._canGhostPropList,param1);
         }
         else
         {
            this.removeFrom(param1,this._canGhostPropList);
         }
      }
      
      private function isProperTo_CanGhostPropList(param1:InventoryItemInfo) : Boolean
      {
         if(param1.CategoryID == 11 && (param1.Property1 == "117" || param1.Property1 == "118"))
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_CanCpsEquipmentList(param1:InventoryItemInfo) : Boolean
      {
         if(param1.CanCompose && param1.getRemainDate() > 0)
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_CanStrthEqpmtList(param1:InventoryItemInfo) : Boolean
      {
         if(param1.CanStrengthen && param1.getRemainDate() > 0)
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_StrthAndANchList(param1:InventoryItemInfo) : Boolean
      {
         if(param1.getRemainDate() <= 0)
         {
            return false;
         }
         if(EquipType.isStrengthStone(param1) || param1.CategoryID == 11 && param1.Property1 == StoneType.SOULSYMBOL || param1.CategoryID == 11 && param1.Property1 == StoneType.LUCKY)
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_CpsAndANchList(param1:InventoryItemInfo) : Boolean
      {
         if(param1.getRemainDate() <= 0)
         {
            return false;
         }
         if(EquipType.isComposeStone(param1) || param1.CategoryID == 11 && param1.Property1 == StoneType.LUCKY)
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_CpsAndStrthAndformula(param1:InventoryItemInfo) : Boolean
      {
         if(param1.getRemainDate() <= 0)
         {
            return false;
         }
         if(param1.FusionType != 0)
         {
            return true;
         }
         if(EquipType.isComposeStone(param1) || param1.CategoryID == 11 && param1.Property1 == StoneType.FORMULA || EquipType.isStrengthStone(param1))
         {
            return true;
         }
         if(param1.CategoryID == 11 && param1.Property1 == "31")
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_CanRongLiangEquipmengtList(param1:InventoryItemInfo) : Boolean
      {
         if(param1.FusionType != 0 && param1.getRemainDate() > 0 && param1.FusionRate > 0)
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_canLianhuaEquipList(param1:InventoryItemInfo) : Boolean
      {
         if(param1.RefineryLevel >= 0 && param1.getRemainDate() >= 0)
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_canLianhuaPropList(param1:InventoryItemInfo) : Boolean
      {
         if(param1.getRemainDate() <= 0)
         {
            return false;
         }
         if(param1.CategoryID == 11 && (param1.Property1 == "32" || param1.Property1 == "33") || param1.CategoryID == 11 && param1.Property1 == StoneType.LUCKY)
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_CanTransEquipmengtList(param1:InventoryItemInfo) : Boolean
      {
         if(param1.CategoryID == 27)
         {
            return false;
         }
         if(param1.Quality >= 4 && (param1.CanCompose || param1.CanStrengthen || param1.isCanLatentEnergy))
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_CanEmbedEquipList(param1:InventoryItemInfo) : Boolean
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         if(param1.getRemainDate() <= 0 || param1.CategoryID == 27)
         {
            return false;
         }
         var _loc4_:Array = param1.Hole.split("|");
         for each(_loc2_ in _loc4_)
         {
            _loc3_ = _loc2_.split(",");
            if(_loc3_[1] == "-1")
            {
               return false;
            }
         }
         return true;
      }
      
      private function isProperTo_CanExaltEqpmtList(param1:InventoryItemInfo) : Boolean
      {
         if(param1.CanStrengthen && param1.getRemainDate() > 0 && param1.StrengthenLevel >= 12)
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_CanWishBeadEqpmtList(param1:InventoryItemInfo) : Boolean
      {
         if(param1.CanStrengthen && param1.getRemainDate() > 0 && param1.StrengthenLevel >= 12)
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_CanEmbedPropList(param1:InventoryItemInfo) : Boolean
      {
         if(param1.getRemainDate() <= 0)
         {
            return false;
         }
         if(EquipType.isDrill(param1))
         {
            return true;
         }
         if(param1.CategoryID == 11 && (param1.Property1 == "31" || param1.Property1 == "16"))
         {
            return true;
         }
         return false;
      }
      
      private function updateDic(param1:DictionaryData, param2:InventoryItemInfo) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] != null && param1[_loc3_].Place == param2.Place)
            {
               param1.add(_loc3_,param2);
               param1.dispatchEvent(new UpdateItemEvent(UpdateItemEvent.UPDATEITEMEVENT,_loc3_,param2));
               return;
            }
            _loc3_++;
         }
         this.addItemToTheFirstNullCell(param2,param1);
      }
      
      private function __removeEquip(param1:DictionaryEvent) : void
      {
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         this.removeFrom(_loc2_,this._canCpsEquipmentList);
         this.removeFrom(_loc2_,this._canStrthEqpmtList);
         this.removeFrom(_loc2_,this._canTransEquipmengtList);
         this.removeFrom(_loc2_,this._canRongLiangEquipmengtList);
      }
      
      private function addItemToTheFirstNullCell(param1:InventoryItemInfo, param2:DictionaryData) : void
      {
         param2.add(this.findFirstNullCellID(param2),param1);
      }
      
      private function findFirstNullCellID(param1:DictionaryData) : int
      {
         var _loc2_:int = -1;
         var _loc3_:int = param1.length;
         var _loc4_:int = 0;
         while(_loc4_ <= _loc3_)
         {
            if(param1[_loc4_] == null)
            {
               _loc2_ = _loc4_;
               break;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function removeFrom(param1:InventoryItemInfo, param2:DictionaryData) : void
      {
         var _loc3_:int = param2.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(Boolean(param2[_loc4_]) && param2[_loc4_].Place == param1.Place)
            {
               param2[_loc4_] = null;
               param2.dispatchEvent(new StoreBagEvent(StoreBagEvent.REMOVE,_loc4_,param1));
               break;
            }
            _loc4_++;
         }
      }
      
      public function sortEquipList(param1:DictionaryData) : DictionaryData
      {
         var _loc2_:DictionaryData = param1;
         param1 = new DictionaryData();
         this.fillByCategoryID(_loc2_,param1,EquipType.ARM);
         this.fillByCategoryID(_loc2_,param1,EquipType.CLOTH);
         this.fillByCategoryID(_loc2_,param1,EquipType.HEAD);
         this.fillByCategoryID(_loc2_,param1,EquipType.GLASS);
         this.fillByCategoryID(_loc2_,param1,EquipType.ARMLET);
         this.fillByCategoryID(_loc2_,param1,EquipType.RING);
         this.fillByCategoryID(_loc2_,param1,EquipType.OFFHAND);
         return param1;
      }
      
      public function sortRoogEquipList(param1:DictionaryData) : DictionaryData
      {
         var _loc2_:DictionaryData = param1;
         param1 = new DictionaryData();
         this.rongLiangFill(_loc2_,param1,EquipType.CLOTH);
         this.rongLiangFill(_loc2_,param1,EquipType.HEAD);
         this.rongLiangFill(_loc2_,param1,EquipType.ARM);
         this.rongLiangFill(_loc2_,param1,EquipType.OFFHAND);
         this.rongLiangFill(_loc2_,param1,EquipType.ARMLET);
         this.rongLiangFill(_loc2_,param1,EquipType.RING);
         this.rongLiangFill(_loc2_,param1,EquipType.NECKLACE);
         this.rongLiangFill(_loc2_,param1,EquipType.HEALSTONE);
         return param1;
      }
      
      private function fillByCategoryID(param1:DictionaryData, param2:DictionaryData, param3:int) : void
      {
         var _loc4_:InventoryItemInfo = null;
         for each(_loc4_ in param1)
         {
            if(_loc4_.CategoryID == param3)
            {
               param2.add(param2.length,_loc4_);
            }
         }
      }
      
      private function rongLiangFill(param1:DictionaryData, param2:DictionaryData, param3:int) : void
      {
         var _loc4_:InventoryItemInfo = null;
         for each(_loc4_ in param1)
         {
            if(_loc4_.CategoryID == param3)
            {
               param2.add(param2.length,_loc4_);
            }
         }
      }
      
      private function rongLiangFunFill(param1:DictionaryData, param2:DictionaryData) : void
      {
         var _loc3_:InventoryItemInfo = null;
         for each(_loc3_ in param1)
         {
            if(_loc3_.Property1 == StoneType.FORMULA)
            {
               param2.add(param2.length,_loc3_);
            }
         }
      }
      
      private function fillByTemplateID(param1:DictionaryData, param2:DictionaryData, param3:int) : void
      {
         var _loc4_:InventoryItemInfo = null;
         for each(_loc4_ in param1)
         {
            if(_loc4_.TemplateID == param3)
            {
               param2.add(param2.length,_loc4_);
            }
         }
      }
      
      private function fillByProperty1AndProperty3(param1:DictionaryData, param2:DictionaryData, param3:String, param4:String) : void
      {
         var _loc5_:InventoryItemInfo = null;
         var _loc6_:Array = [];
         for each(_loc5_ in param1)
         {
            if(_loc5_.Property1 == param3 && _loc5_.Property3 == param4)
            {
               _loc6_.push(_loc5_);
            }
         }
         this.bubbleSort(_loc6_);
         for each(_loc5_ in _loc6_)
         {
            param2.add(param2.length,_loc5_);
         }
      }
      
      private function fillByProperty1(param1:DictionaryData, param2:DictionaryData, param3:String) : void
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:Array = [];
         for each(_loc4_ in param1)
         {
            if(_loc4_.Property1 == param3)
            {
               _loc5_.push(_loc4_);
            }
         }
         this.bubbleSort(_loc5_);
         for each(_loc4_ in _loc5_)
         {
            param2.add(param2.length,_loc4_);
         }
      }
      
      private function findByTemplateID(param1:DictionaryData, param2:DictionaryData, param3:int) : void
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:Array = [];
         for each(_loc4_ in param1)
         {
            if(_loc4_.TemplateID == param3)
            {
               _loc5_.push(_loc4_);
            }
         }
         this.bubbleSort(_loc5_);
         for each(_loc4_ in _loc5_)
         {
            param2.add(param2.length,_loc4_);
         }
      }
      
      public function sortPropList(param1:DictionaryData, param2:Boolean = false) : DictionaryData
      {
         var _loc3_:DictionaryData = param1;
         param1 = new DictionaryData();
         this.rongLiangFunFill(_loc3_,param1);
         this.fillByProperty1(_loc3_,param1,StoneType.STRENGTH);
         this.fillByProperty1(_loc3_,param1,StoneType.STRENGTH_1);
         this.fillByProperty1(_loc3_,param1,StoneType.LIANHUA_MAIN_MATIERIAL);
         this.fillByProperty1(_loc3_,param1,StoneType.LIANHUA_AIDED_MATIERIAL);
         this.fillByProperty1(_loc3_,param1,StoneType.OPENHOLE);
         this.fillByProperty1(_loc3_,param1,"31");
         this.fillByProperty1AndProperty3(_loc3_,param1,StoneType.COMPOSE,StoneType.BIRD);
         this.fillByProperty1AndProperty3(_loc3_,param1,StoneType.COMPOSE,StoneType.SNAKE);
         this.fillByProperty1AndProperty3(_loc3_,param1,StoneType.COMPOSE,StoneType.DRAGON);
         this.fillByProperty1AndProperty3(_loc3_,param1,StoneType.COMPOSE,StoneType.TIGER);
         if(!param2)
         {
            this.fillByProperty1(_loc3_,param1,StoneType.SOULSYMBOL);
         }
         this.fillByProperty1(_loc3_,param1,StoneType.LUCKY);
         this.rongLiangFill(_loc3_,param1,8);
         this.rongLiangFill(_loc3_,param1,9);
         this.rongLiangFill(_loc3_,param1,14);
         this.fillByProperty1(_loc3_,param1,StoneType.BADGE);
         this.fillByProperty1(_loc3_,param1,"117");
         this.fillByProperty1(_loc3_,param1,"118");
         return param1;
      }
      
      private function bubbleSort(param1:Array) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:int = int(param1.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc2_ = true;
            _loc3_ = 0;
            while(_loc3_ < _loc5_ - 1)
            {
               if(param1[_loc3_].Quality < param1[_loc3_ + 1].Quality)
               {
                  _loc4_ = param1[_loc3_];
                  param1[_loc3_] = param1[_loc3_ + 1];
                  param1[_loc3_ + 1] = _loc4_;
                  _loc2_ = false;
               }
               _loc3_++;
            }
            if(_loc2_)
            {
               return;
            }
            _loc6_++;
         }
      }
      
      public function get info() : PlayerInfo
      {
         return this._info;
      }
      
      public function set currentPanel(param1:int) : void
      {
         this._currentPanel = param1;
      }
      
      public function get currentPanel() : int
      {
         return this._currentPanel;
      }
      
      public function get canCpsEquipmentList() : DictionaryData
      {
         return this._canCpsEquipmentList;
      }
      
      public function get canLianhuaEquipList() : DictionaryData
      {
         return this._canLianhuaEquipList;
      }
      
      public function get canLianhuaPropList() : DictionaryData
      {
         return this._canLianhuaPropList;
      }
      
      public function get exaltRock() : DictionaryData
      {
         return this._exaltRock;
      }
      
      public function get wishBeadRock() : DictionaryData
      {
         return this._wishBeadRock;
      }
      
      public function get canStrthEqpmtList() : DictionaryData
      {
         return this._canStrthEqpmtList;
      }
      
      public function get strthAndANchList() : DictionaryData
      {
         return this._strthAndANchList;
      }
      
      public function get cpsAndANchList() : DictionaryData
      {
         return this._cpsAndANchList;
      }
      
      public function get canExaltEqpmtList() : DictionaryData
      {
         return this._canExaltEqpmtList;
      }
      
      public function get canWishBeadEqpmtList() : DictionaryData
      {
         return this._canWishBeadEqpmtList;
      }
      
      public function get cpsAndStrthAndformula() : DictionaryData
      {
         return this._cpsAndStrthAndformula;
      }
      
      public function get canRongLiangPropList() : DictionaryData
      {
         return this._canRongLiangPropList;
      }
      
      public function get canTransEquipmengtList() : DictionaryData
      {
         return this._canTransEquipmengtList;
      }
      
      public function get canRongLiangEquipmengtList() : DictionaryData
      {
         return this._canRongLiangEquipmengtList;
      }
      
      public function get canEmbedEquipList() : DictionaryData
      {
         return this._canEmbedEquipList;
      }
      
      public function get canEmbedPropList() : DictionaryData
      {
         return this._canEmbedPropList;
      }
      
      public function set NeedAutoLink(param1:int) : void
      {
         this._needAutoLink = param1;
      }
      
      public function get NeedAutoLink() : int
      {
         return this._needAutoLink;
      }
      
      public function checkEmbeded() : Boolean
      {
         var _loc1_:* = null;
         var _loc2_:InventoryItemInfo = null;
         for(_loc1_ in this._canEmbedEquipList)
         {
            _loc2_ = this._canEmbedEquipList[int(_loc1_)] as InventoryItemInfo;
            if(_loc2_ && _loc2_.Hole1 != -1 && _loc2_.Hole1 != 0)
            {
               return false;
            }
            if(_loc2_ && _loc2_.Hole2 != -1 && _loc2_.Hole2 != 0)
            {
               return false;
            }
            if(_loc2_ && _loc2_.Hole3 != -1 && _loc2_.Hole3 != 0)
            {
               return false;
            }
            if(_loc2_ && _loc2_.Hole4 != -1 && _loc2_.Hole4 != 0)
            {
               return false;
            }
            if(_loc2_ && _loc2_.Hole5 != -1 && _loc2_.Hole5 != 0)
            {
               return false;
            }
            if(_loc2_ && _loc2_.Hole6 != -1 && _loc2_.Hole6 != 0)
            {
               return false;
            }
         }
         return true;
      }
      
      public function loadBagData() : void
      {
         this.initData();
      }
      
      public function clear() : void
      {
         this._info.PropBag.removeEventListener(BagEvent.UPDATE,this.updateBag);
         this._info.Bag.removeEventListener(BagEvent.UPDATE,this.updateBag);
         this._info.PropBag.removeEventListener(BagEvent.UPDATE_Exalt,this.updateBag);
         this._info.Bag.removeEventListener(BagEvent.UPDATE_Exalt,this.updateBag);
         this._info = null;
         this._propBag = null;
         this._equipmentBag = null;
      }
      
      public function get canGhostEquipList() : DictionaryData
      {
         return this._canGhostEquipList;
      }
      
      public function get canGhostPropList() : DictionaryData
      {
         return this._canGhostPropList;
      }
   }
}
