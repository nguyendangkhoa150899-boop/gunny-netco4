package ddt.manager
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.ShopType;
   import ddt.data.analyze.ShopItemAnalyzer;
   import ddt.data.analyze.ShopItemDisCountAnalyzer;
   import ddt.data.analyze.ShopItemSortAnalyzer;
   import ddt.data.goods.ItemPrice;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.states.StateType;
   import flash.events.EventDispatcher;
   import flash.net.URLVariables;
   import flash.utils.Dictionary;
   import gemstone.GemstoneManager;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class ShopManager extends EventDispatcher
   {
      
      private static var _instance:ddt.manager.ShopManager;
       
      
      public var initialized:Boolean = false;
      
      private var _shopGoods:DictionaryData;
      
      private var _shopSortList:Dictionary;
      
      private var _shopRealTimesDisCountGoods:Dictionary;
      
      public function ShopManager(param1:SingletonEnfocer)
      {
         super();
      }
      
      public static function get Instance() : ddt.manager.ShopManager
      {
         if(_instance == null)
         {
            _instance = new ddt.manager.ShopManager(new SingletonEnfocer());
         }
         return _instance;
      }
      
      public function setup(param1:ShopItemAnalyzer) : void
      {
         this._shopGoods = param1.shopinfolist;
         this.initialized = true;
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GOODS_COUNT,this.__updateGoodsCount);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REALlTIMES_ITEMS_BY_DISCOUNT,this.__updateGoodsDisCount);
      }
      
      public function updateShopGoods(param1:ShopItemAnalyzer) : void
      {
         this._shopGoods = param1.shopinfolist;
      }
      
      public function sortShopItems(param1:ShopItemSortAnalyzer) : void
      {
         this._shopSortList = param1.shopSortedGoods;
      }
      
      public function getResultPages(param1:int, param2:int = 8) : int
      {
         var _loc3_:Vector.<ShopItemInfo> = this.getValidGoodByType(param1);
         return int(Math.ceil(_loc3_.length / param2));
      }
      
      public function buyIt(param1:Array) : Array
      {
         var _loc2_:ShopCarItemInfo = null;
         var _loc3_:SelfInfo = PlayerManager.Instance.Self;
         var _loc4_:Array = [];
         var _loc5_:int = _loc3_.Gold;
         var _loc6_:int = _loc3_.Money;
         var _loc7_:int = _loc3_.Gift;
         var _loc8_:int = _loc3_.medal;
         for each(_loc2_ in param1)
         {
            if(_loc5_ >= _loc2_.getItemPrice(_loc2_.currentBuyType).goldValue && _loc6_ >= _loc2_.getItemPrice(_loc2_.currentBuyType).moneyValue && _loc7_ >= _loc2_.getItemPrice(_loc2_.currentBuyType).giftValue && _loc8_ >= _loc2_.getItemPrice(_loc2_.currentBuyType).medalValue)
            {
               _loc5_ -= _loc2_.getItemPrice(_loc2_.currentBuyType).goldValue;
               _loc6_ -= _loc2_.getItemPrice(_loc2_.currentBuyType).moneyValue;
               _loc7_ -= _loc2_.getItemPrice(_loc2_.currentBuyType).giftValue;
               _loc8_ -= _loc2_.getItemPrice(_loc2_.currentBuyType).medalValue;
               _loc4_.push(_loc2_);
            }
         }
         return _loc4_;
      }
      
      public function giveGift(param1:Array, param2:SelfInfo) : Array
      {
         var _loc3_:ItemPrice = null;
         var _loc4_:ShopCarItemInfo = null;
         var _loc5_:Array = [];
         var _loc6_:int = param2.Money;
         for each(_loc4_ in param1)
         {
            _loc3_ = _loc4_.getItemPrice(_loc4_.currentBuyType);
            if(_loc6_ >= _loc3_.moneyValue && _loc3_.giftValue == 0 && _loc3_.goldValue == 0 && _loc3_.getOtherValue(EquipType.MEDAL) == 0)
            {
               _loc6_ -= _loc3_.moneyValue;
               _loc5_.push(_loc4_);
            }
         }
         return _loc5_;
      }
      
      private function __updateGoodsCount(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ShopItemInfo = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:ShopItemInfo = null;
         var _loc8_:PackageIn = param1.pkg;
         var _loc9_:int = StateManager.currentStateType == StateType.CONSORTIA ? int(2) : int(1);
         var _loc10_:int = _loc8_.readInt();
         var _loc11_:int = 0;
         while(_loc11_ < _loc10_)
         {
            _loc2_ = _loc8_.readInt();
            _loc3_ = _loc8_.readInt();
            _loc4_ = this.getShopItemByGoodsID(_loc2_);
            if(Boolean(_loc4_) && _loc9_ == 1)
            {
               _loc4_.LimitCount = _loc3_;
            }
            _loc11_++;
         }
         var _loc12_:int = _loc8_.readInt();
         var _loc13_:int = _loc8_.readInt();
         var _loc14_:int = 0;
         while(_loc14_ < _loc13_)
         {
            _loc5_ = _loc8_.readInt();
            _loc6_ = _loc8_.readInt();
            _loc7_ = this.getShopItemByGoodsID(_loc5_);
            if(_loc7_ && _loc9_ == 2 && _loc12_ == PlayerManager.Instance.Self.ConsortiaID)
            {
               _loc7_.LimitCount = _loc6_;
            }
            _loc14_++;
         }
         var _loc15_:int = _loc8_.readInt();
         GemstoneManager.Instance.upDataFitCount();
      }
      
      public function getShopItemByGoodsID(param1:int) : ShopItemInfo
      {
         var _loc2_:ShopItemInfo = null;
         for each(_loc2_ in this._shopGoods)
         {
            if(_loc2_.GoodsID == param1)
            {
               return this.usediscountGoodsByID(_loc2_);
            }
         }
         return null;
      }
      
      public function getCloneShopItemByGoodsID(param1:int) : ShopItemInfo
      {
         var _loc2_:ShopItemInfo = null;
         var _loc3_:ShopItemInfo = null;
         for each(_loc2_ in this._shopGoods)
         {
            if(_loc2_.GoodsID == param1)
            {
               _loc3_ = new ShopItemInfo(_loc2_.GoodsID,_loc2_.GoodsID);
               ObjectUtils.copyProperties(_loc3_,_loc2_);
               break;
            }
         }
         return _loc3_;
      }
      
      public function getValidSortedGoodsByType(param1:int, param2:int, param3:int = 8) : Vector.<ShopItemInfo>
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         var _loc8_:Vector.<ShopItemInfo> = this.getValidGoodByType(param1);
         var _loc9_:int = Math.ceil(_loc8_.length / param3);
         if(param2 > 0 && param2 <= _loc9_)
         {
            _loc4_ = 0 + param3 * (param2 - 1);
            _loc5_ = Math.min(_loc8_.length - _loc4_,8);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_.push(_loc8_[_loc4_ + _loc6_]);
               _loc6_++;
            }
         }
         return this.usediscountgoods(_loc7_);
      }
      
      public function getGoodsByType(param1:int) : Vector.<ShopItemInfo>
      {
         return this.usediscountgoods(this._shopSortList[param1] as Vector.<ShopItemInfo>);
      }
      
      public function getValidGoodByType(param1:int) : Vector.<ShopItemInfo>
      {
         var _loc2_:ShopItemInfo = null;
         var _loc3_:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         var _loc4_:Vector.<ShopItemInfo> = this._shopSortList[param1];
         for each(_loc2_ in _loc4_)
         {
            if(_loc2_.isValid)
            {
               _loc3_.push(_loc2_);
            }
         }
         return this.usediscountgoods(_loc3_);
      }
      
      public function consortiaShopLevelTemplates(param1:int) : Vector.<ShopItemInfo>
      {
         return this.usediscountgoods(this._shopSortList[ShopType.GUILD_SHOP_1 + param1 - 1] as Vector.<ShopItemInfo>);
      }
      
      public function canAddPrice(param1:int) : Boolean
      {
         if(!this.getGoodsByTemplateID(param1) || !this.getGoodsByTemplateID(param1).IsContinue)
         {
            return false;
         }
         if(this.getShopRechargeItemByTemplateId(param1).length <= 0)
         {
            return false;
         }
         return true;
      }
      
      public function getShopRechargeItemByTemplateId(param1:int) : Array
      {
         var _loc2_:ShopItemInfo = null;
         var _loc3_:ShopItemInfo = null;
         var _loc4_:ShopItemInfo = null;
         var _loc5_:Vector.<ShopItemInfo> = this._shopSortList[ShopType.RECHARGE];
         var _loc6_:Array = [];
         for each(_loc2_ in this._shopSortList[ShopType.RECHARGE])
         {
            if(_loc2_.TemplateID == param1 && _loc2_.IsContinue)
            {
               _loc6_.push(_loc2_);
            }
         }
         if(_loc6_.length > 0)
         {
            return _loc6_;
         }
         for each(_loc3_ in this._shopGoods)
         {
            if(_loc3_.TemplateID == param1 && _loc3_.getItemPrice(1).moneyValue > 0 && _loc3_.IsContinue)
            {
               _loc6_.push(_loc3_);
            }
         }
         for each(_loc4_ in this._shopGoods)
         {
            if(_loc4_.TemplateID == param1 && _loc4_.getItemPrice(1).giftValue > 0 && _loc4_.IsContinue)
            {
               _loc6_.push(_loc4_);
            }
         }
         return this.usediscountgoodsByArr(_loc6_);
      }
      
      public function getMoneyShopItemByTemplateID(param1:int, param2:Boolean = false) : ShopItemInfo
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<ShopItemInfo> = null;
         var _loc6_:ShopItemInfo = null;
         var _loc7_:ShopItemInfo = null;
         if(param2)
         {
            _loc3_ = this.getType(ShopType.MALE_TYPE).concat(this.getType(ShopType.FEMALE_TYPE));
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = this.getValidGoodByType(_loc4_);
               for each(_loc6_ in _loc5_)
               {
                  if(_loc6_.TemplateID == param1 && _loc6_.getItemPrice(1).moneyValue > 0)
                  {
                     return this.usediscountGoodsByID(_loc6_);
                  }
               }
            }
         }
         else
         {
            for each(_loc7_ in this._shopGoods)
            {
               if(_loc7_.TemplateID == param1 && _loc7_.getItemPrice(1).moneyValue > 0)
               {
                  if(_loc7_.isValid)
                  {
                     return this.usediscountGoodsByID(_loc7_);
                  }
               }
            }
         }
         return null;
      }
      
      public function getMoneyShopItemByTemplateIDForGiftSystem(param1:int) : ShopItemInfo
      {
         var _loc2_:ShopItemInfo = null;
         for each(_loc2_ in this._shopGoods)
         {
            if(_loc2_.TemplateID == param1)
            {
               return this.usediscountGoodsByID(_loc2_);
            }
         }
         return null;
      }
      
      public function getGoodsByTemplateID(param1:int) : ShopItemInfo
      {
         var _loc2_:ShopItemInfo = null;
         for each(_loc2_ in this._shopGoods)
         {
            if(_loc2_.TemplateID == param1)
            {
               return this.usediscountGoodsByID(_loc2_);
            }
         }
         return null;
      }
      
      public function getGiftShopItemByTemplateID(param1:int, param2:Boolean = false) : ShopItemInfo
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<ShopItemInfo> = null;
         var _loc6_:ShopItemInfo = null;
         var _loc7_:ShopItemInfo = null;
         if(param2)
         {
            _loc3_ = this.getType(ShopType.MALE_TYPE).concat(this.getType(ShopType.FEMALE_TYPE));
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = this.getValidGoodByType(_loc4_);
               for each(_loc6_ in _loc5_)
               {
                  if(_loc6_.TemplateID == param1)
                  {
                     if(_loc6_.getItemPrice(1).giftValue > 0)
                     {
                        return this.usediscountGoodsByID(_loc6_);
                     }
                  }
               }
            }
         }
         else
         {
            for each(_loc7_ in this._shopGoods)
            {
               if(_loc7_.TemplateID == param1 && _loc7_.getItemPrice(1).giftValue > 0)
               {
                  if(_loc7_.isValid)
                  {
                     return this.usediscountGoodsByID(_loc7_);
                  }
               }
            }
         }
         return null;
      }
      
      private function getType(param1:*) : Array
      {
         var _loc2_:* = undefined;
         var _loc3_:Array = [];
         if(param1 is Array)
         {
            for each(_loc2_ in param1)
            {
               _loc3_ = _loc3_.concat(this.getType(_loc2_));
            }
         }
         else
         {
            _loc3_.push(param1);
         }
         return _loc3_;
      }
      
      public function getMedalShopItemByTemplateID(param1:int, param2:Boolean = false) : ShopItemInfo
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<ShopItemInfo> = null;
         var _loc6_:ShopItemInfo = null;
         var _loc7_:ShopItemInfo = null;
         if(param2)
         {
            _loc3_ = this.getType(ShopType.MALE_TYPE).concat(this.getType(ShopType.FEMALE_TYPE));
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = this.getValidGoodByType(_loc4_);
               for each(_loc6_ in _loc5_)
               {
                  if(_loc6_.TemplateID == param1 && _loc6_.getItemPrice(1).medalValue > 0)
                  {
                     return this.usediscountGoodsByID(_loc6_);
                  }
               }
            }
         }
         else
         {
            for each(_loc7_ in this._shopGoods)
            {
               if(_loc7_.TemplateID == param1 && _loc7_.getItemPrice(1).medalValue > 0)
               {
                  if(_loc7_.isValid)
                  {
                     return this.usediscountGoodsByID(_loc7_) as ShopItemInfo;
                  }
               }
            }
         }
         return null;
      }
      
      public function getGoldShopItemByTemplateID(param1:int) : ShopItemInfo
      {
         var _loc2_:ShopItemInfo = null;
         for each(_loc2_ in this._shopSortList[ShopType.ROOM_PROP])
         {
            if(_loc2_.TemplateID == param1)
            {
               if(_loc2_.isValid)
               {
                  return this.usediscountGoodsByID(_loc2_) as ShopItemInfo;
               }
            }
         }
         return null;
      }
      
      public function moneyGoods(param1:Array, param2:SelfInfo) : Array
      {
         var _loc3_:ItemPrice = null;
         var _loc4_:ShopCarItemInfo = null;
         var _loc5_:Array = [];
         for each(_loc4_ in param1)
         {
            _loc3_ = _loc4_.getItemPrice(_loc4_.currentBuyType);
            if(_loc3_.moneyValue > 0)
            {
               _loc5_.push(_loc4_);
            }
         }
         return _loc5_;
      }
      
      public function buyLeastGood(param1:Array, param2:SelfInfo) : Boolean
      {
         var _loc3_:ShopCarItemInfo = null;
         for each(_loc3_ in param1)
         {
            if(param2.Gold >= _loc3_.getItemPrice(_loc3_.currentBuyType).goldValue && param2.Money >= _loc3_.getItemPrice(_loc3_.currentBuyType).moneyValue && param2.Gift >= _loc3_.getItemPrice(_loc3_.currentBuyType).giftValue && param2.medal >= _loc3_.getItemPrice(_loc3_.currentBuyType).getOtherValue(EquipType.MEDAL))
            {
               return true;
            }
         }
         return false;
      }
      
      public function getDesignatedAllShopItem(param1:Array) : Vector.<ShopItemInfo>
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc2_ = int(param1[_loc4_]);
            _loc3_ = _loc3_.concat(this.getGoodsByType(_loc2_));
            _loc4_++;
         }
         return this.usediscountgoods(_loc3_);
      }
      
      public function fuzzySearch(param1:Vector.<ShopItemInfo>, param2:String) : Vector.<ShopItemInfo>
      {
         var _loc3_:ShopItemInfo = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:ShopItemInfo = null;
         var _loc7_:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         for each(_loc3_ in param1)
         {
            if(_loc3_.isValid && Boolean(_loc3_.TemplateInfo))
            {
               _loc4_ = _loc3_.TemplateInfo.Name.indexOf(param2);
               if(_loc4_ > -1)
               {
                  _loc5_ = true;
                  for each(_loc6_ in _loc7_)
                  {
                     if(_loc6_.GoodsID == _loc3_.GoodsID)
                     {
                        _loc5_ = false;
                     }
                  }
                  if(_loc5_)
                  {
                     _loc7_.push(_loc3_);
                  }
               }
            }
         }
         return this.usediscountgoods(_loc7_);
      }
      
      private function usediscountgoods(param1:Vector.<ShopItemInfo>) : Vector.<ShopItemInfo>
      {
         var _loc2_:ShopItemInfo = null;
         var _loc3_:ShopItemInfo = null;
         var _loc4_:Vector.<ShopItemInfo> = param1.concat();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc2_ = _loc4_[_loc5_];
            for each(_loc3_ in this._shopRealTimesDisCountGoods)
            {
               if(_loc3_.isValid && _loc2_.GoodsID == _loc3_.GoodsID)
               {
                  _loc4_[_loc5_] = _loc3_;
                  break;
               }
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      private function usediscountgoodsByArr(param1:Array) : Array
      {
         var _loc2_:ShopItemInfo = null;
         var _loc3_:ShopItemInfo = null;
         var _loc4_:Array = param1.concat();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc2_ = _loc4_[_loc5_];
            for each(_loc3_ in this._shopRealTimesDisCountGoods)
            {
               if(_loc3_.isValid && _loc2_.GoodsID == _loc3_.GoodsID)
               {
                  _loc4_[_loc5_] = _loc3_;
                  break;
               }
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      private function usediscountGoodsByID(param1:ShopItemInfo) : ShopItemInfo
      {
         var _loc2_:ShopItemInfo = null;
         for each(_loc2_ in this._shopRealTimesDisCountGoods)
         {
            if(_loc2_.isValid && param1.GoodsID == _loc2_.GoodsID)
            {
               return _loc2_;
            }
         }
         return param1;
      }
      
      private function __updateGoodsDisCount(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_["rnd"] = Math.random();
         var _loc3_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ShopCheapItemList.ashx"),BaseLoader.REQUEST_LOADER,_loc2_);
         _loc3_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.ShopDisCountRealTimesFailure");
         _loc3_.analyzer = new ShopItemDisCountAnalyzer(ShopManager.Instance.updateRealTimesItemsByDisCount,false);
         LoaderManager.Instance.startLoad(_loc3_);
      }
      
      public function updateRealTimesItemsByDisCount(param1:ShopItemDisCountAnalyzer) : void
      {
         this._shopRealTimesDisCountGoods = param1.shopDisCountGoods;
      }
      
      public function getDisCountValidGoodByType(param1:int) : Vector.<ShopItemInfo>
      {
         var _loc2_:DictionaryData = null;
         var _loc3_:ShopItemInfo = null;
         var _loc4_:ShopItemInfo = null;
         var _loc5_:ShopItemInfo = null;
         var _loc6_:ShopItemInfo = null;
         var _loc7_:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         if(param1 != 1)
         {
            _loc2_ = this._shopRealTimesDisCountGoods[param1];
            if(Boolean(_loc2_))
            {
               for each(_loc3_ in _loc2_.list)
               {
                  if(_loc3_.isValid && _loc3_.TemplateInfo.CategoryID != EquipType.GIFTGOODS)
                  {
                     _loc7_.push(_loc3_);
                  }
               }
            }
            return _loc7_;
         }
         if(param1 == 1)
         {
            _loc2_ = this._shopRealTimesDisCountGoods[param1];
            if(Boolean(_loc2_))
            {
               for each(_loc4_ in _loc2_.list)
               {
                  if(_loc4_.isValid && _loc4_.TemplateInfo.CategoryID != EquipType.GIFTGOODS)
                  {
                     _loc7_.push(_loc4_);
                  }
               }
            }
            _loc2_ = this._shopRealTimesDisCountGoods[8];
            if(Boolean(_loc2_))
            {
               for each(_loc5_ in _loc2_.list)
               {
                  if(_loc5_.isValid && _loc5_.TemplateInfo.CategoryID != EquipType.GIFTGOODS)
                  {
                     _loc7_.push(_loc5_);
                  }
               }
            }
            _loc2_ = this._shopRealTimesDisCountGoods[9];
            if(Boolean(_loc2_))
            {
               for each(_loc6_ in _loc2_.list)
               {
                  if(_loc6_.isValid && _loc6_.TemplateInfo.CategoryID != EquipType.GIFTGOODS)
                  {
                     _loc7_.push(_loc6_);
                  }
               }
            }
            return _loc7_;
         }
         return _loc7_;
      }
      
      public function getShopItemByTemplateID(param1:int, param2:int) : ShopItemInfo
      {
         var _loc3_:ShopItemInfo = null;
         var _loc4_:ShopItemInfo = null;
         var _loc5_:ShopItemInfo = null;
         switch(param2)
         {
            case 1:
               for each(_loc3_ in this._shopGoods)
               {
                  if(_loc3_.TemplateID == param1 && _loc3_.getItemPrice(1).hardCurrencyValue > 0)
                  {
                     if(_loc3_.isValid)
                     {
                        return _loc3_;
                     }
                  }
               }
               break;
            case 2:
               for each(_loc4_ in this._shopGoods)
               {
                  if(_loc4_.TemplateID == param1 && _loc4_.getItemPrice(1).gesteValue > 0)
                  {
                     if(_loc4_.isValid)
                     {
                        return _loc4_;
                     }
                  }
               }
               break;
            case 3:
               return this.getMoneyShopItemByTemplateID(param1);
            case 5:
               for each(_loc5_ in this._shopGoods)
               {
                  if(_loc5_.TemplateID == param1 && _loc5_.getItemPrice(1).scoreValue > 0)
                  {
                     if(_loc5_.isValid)
                     {
                        return _loc5_;
                     }
                  }
               }
         }
         return null;
      }
      
      public function getDisCountGoods(param1:int = 1, param2:int = 1, param3:int = 8) : Vector.<ShopItemInfo>
      {
         var _loc9_:Vector.<ShopItemInfo> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         if(Boolean(_loc9_ = this.getDisCountValidGoodByType(param1)))
         {
            _loc4_ = Math.ceil(_loc9_.length / param3);
            if(param2 > 0 && param2 <= _loc4_)
            {
               _loc5_ = 0 + param3 * (param2 - 1);
               _loc6_ = Math.min(_loc9_.length - _loc5_,param3);
               _loc7_ = 0;
               while(_loc7_ < _loc6_)
               {
                  _loc8_.push(_loc9_[_loc5_ + _loc7_]);
                  _loc7_++;
               }
            }
         }
         return _loc8_;
      }
      
      public function getGoodsByTempId(param1:int) : ShopItemInfo
      {
         var _loc2_:int = 0;
         var _loc3_:ShopItemInfo = null;
         var _loc4_:Vector.<ShopItemInfo> = this.getDisCountGoods();
         _loc2_ = 0;
         while(_loc2_ < _loc4_.length)
         {
            if(param1 == _loc4_[_loc2_].TemplateID)
            {
               _loc3_ = _loc4_[_loc2_];
               break;
            }
            _loc2_++;
         }
         return _loc3_;
      }
   }
}

class SingletonEnfocer
{
    
   
   public function SingletonEnfocer()
   {
      super();
   }
}
