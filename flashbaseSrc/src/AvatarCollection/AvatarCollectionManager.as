package AvatarCollection
{
   import AvatarCollection.data.AvatarCollectionItemDataAnalyzer;
   import AvatarCollection.data.AvatarCollectionItemVo;
   import AvatarCollection.data.AvatarCollectionUnitDataAnalyzer;
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.CEvent;
   import ddt.events.PkgEvent;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.utils.AssetModuleLoader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class AvatarCollectionManager extends EventDispatcher
   {
      
      public static const REFRESH_VIEW:String = "avatar_collection_refresh_view";
      
      public static const DATA_COMPLETE:String = "avatar_collection_data_complete";
      
      public static const SELECT_ALL:String = "avatar_collection_select_all";
      
      public static const VISIBLE:String = "visible";
      
      public static const RESET_LEFT:String = "reset_left";
      
      private static var _instance:AvatarCollection.AvatarCollectionManager;
       
      
      public var isDataComplete:Boolean;
      
      private var _realItemIdDic:DictionaryData;
      
      private var _maleItemDic:DictionaryData;
      
      private var _femaleItemDic:DictionaryData;
      
      private var _weaponItemDic:DictionaryData;
      
      private var _allGoodsTemplateIDlist:DictionaryData;
      
      private var _maleItemList:Vector.<AvatarCollectionItemVo>;
      
      private var _femaleItemList:Vector.<AvatarCollectionItemVo>;
      
      private var _weaponItemList:Vector.<AvatarCollectionItemVo>;
      
      private var _maleUnitList:Array;
      
      private var _femaleUnitList:Array;
      
      private var _weaponUnitList:Array;
      
      private var _maleUnitDic:DictionaryData;
      
      private var _femaleUnitDic:DictionaryData;
      
      private var _weaponUnitDic:DictionaryData;
      
      private var _maleShopItemInfoList:Vector.<ShopItemInfo>;
      
      private var _femaleShopItemInfoList:Vector.<ShopItemInfo>;
      
      private var _weaponShopItemInfoList:Vector.<ShopItemInfo>;
      
      private var _isHasCheckedBuy:Boolean = false;
      
      public var isCheckedAvatarTime:Boolean = false;
      
      public var isSkipFromHall:Boolean = false;
      
      public var skipId:int;
      
      private var _isSelectAll:Boolean = false;
      
      private var _pageType:int;
      
      private var _listState:String = "normal";
      
      private var _gotAllInfo:Boolean = false;
      
      private var cevent:CEvent;
      
      public function AvatarCollectionManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : AvatarCollection.AvatarCollectionManager
      {
         if(_instance == null)
         {
            _instance = new AvatarCollection.AvatarCollectionManager();
         }
         return _instance;
      }
      
      private function honourNeedPerPage(param1:AvatarCollectionUnitVo) : Number
      {
         var _loc2_:int = 0;
         if(!param1)
         {
            return 0;
         }
         var _loc3_:int = int(param1.totalItemList.length);
         var _loc4_:int = param1.totalActivityItemCount;
         if(_loc4_ < _loc3_ / 2)
         {
            return 0;
         }
         if(_loc4_ == _loc3_)
         {
            return param1.needHonor * 2;
         }
         return param1.needHonor;
      }
      
      public function honourNeedTotalPerDay() : Number
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc1_:* = 0;
         for each(_loc2_ in this._maleUnitList)
         {
            if(Boolean(_loc2_.selected))
            {
               _loc1_ += this.honourNeedPerPage(_loc2_);
            }
         }
         for each(_loc3_ in this._femaleUnitList)
         {
            if(Boolean(_loc3_.selected))
            {
               _loc1_ += this.honourNeedPerPage(_loc3_);
            }
         }
         for each(_loc4_ in this._weaponUnitList)
         {
            if(Boolean(_loc4_.selected))
            {
               _loc1_ += this.honourNeedPerPage(_loc4_);
            }
         }
         return _loc1_;
      }
      
      public function onListCellClick(param1:AvatarCollectionUnitVo, param2:Boolean) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = null;
         if(param1.Type == 1)
         {
            _loc3_ = param1.sex == 1 ? this._maleItemList : this._femaleItemList;
         }
         else
         {
            _loc3_ = this._weaponItemList;
         }
         if(param1.Type == 1)
         {
            _loc4_ = param1.sex == 1 ? this._maleUnitList : this._femaleUnitList;
         }
         else
         {
            _loc4_ = this._weaponUnitList;
         }
         for each(_loc5_ in _loc3_)
         {
            if(_loc5_.id == param1.id)
            {
               _loc5_.selected = param2;
               break;
            }
         }
         for each(_loc6_ in _loc4_)
         {
            if(_loc6_.id == param1.id)
            {
               _loc6_.selected = param2;
               break;
            }
         }
      }
      
      public function get isSelectAll() : Boolean
      {
         return this._isSelectAll;
      }
      
      public function set isSelectAll(param1:Boolean) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         this._isSelectAll = param1;
         if(this._pageType == 0)
         {
            for each(_loc2_ in this._maleItemList)
            {
               _loc2_.selected = param1;
            }
            for each(_loc3_ in this._femaleItemList)
            {
               _loc3_.selected = param1;
            }
            for each(_loc4_ in this._maleUnitList)
            {
               _loc4_.selected = param1;
            }
            for each(_loc5_ in this._femaleUnitList)
            {
               _loc5_.selected = param1;
            }
         }
         else
         {
            for each(_loc6_ in this._weaponUnitList)
            {
               _loc6_.selected = param1;
            }
            for each(_loc7_ in this._weaponItemList)
            {
               _loc7_.selected = param1;
            }
         }
      }
      
      public function getSelectState(param1:AvatarCollectionUnitVo) : Boolean
      {
         var _loc3_:* = undefined;
         var _loc2_:* = undefined;
         if(param1.Type == 1)
         {
            _loc2_ = param1.sex == 1 ? this._maleItemList : this._femaleItemList;
         }
         else
         {
            _loc2_ = this._weaponItemList;
         }
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.id == param1.id)
            {
               return _loc3_.selected;
            }
         }
         return false;
      }
      
      public function get pageType() : int
      {
         return this._pageType;
      }
      
      public function set pageType(param1:int) : void
      {
         this._pageType = param1;
      }
      
      public function selectAllClicked(param1:Object = null) : void
      {
         if(param1 != null)
         {
            this.isSelectAll = Boolean(param1);
         }
         else if(this._listState != "normal")
         {
            dispatchEvent(new CEvent("reset_left"));
            this.isSelectAll = true;
            this._listState = "normal";
         }
         else
         {
            this.isSelectAll = !this.isSelectAll;
         }
         dispatchEvent(new CEvent("avatar_collection_select_all",this._isSelectAll));
      }
      
      public function getDelayTimeCollectionCount() : Number
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc1_:* = 0;
         for each(_loc2_ in this._maleUnitList)
         {
            if(_loc2_.selected == true)
            {
               _loc1_++;
            }
         }
         for each(_loc3_ in this._femaleUnitList)
         {
            if(_loc3_.selected == true)
            {
               _loc1_++;
            }
         }
         for each(_loc4_ in this._weaponUnitList)
         {
            if(_loc4_.selected == true)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      public function delayTheTimeConfirmed(param1:int) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         for each(_loc2_ in this._maleUnitList)
         {
            if(Boolean(_loc2_.selected))
            {
               SocketManager.Instance.out.sendAvatarCollectionDelayTime(_loc2_.id,param1,1);
            }
         }
         for each(_loc3_ in this._femaleUnitList)
         {
            if(Boolean(_loc3_.selected))
            {
               SocketManager.Instance.out.sendAvatarCollectionDelayTime(_loc3_.id,param1,1);
            }
         }
         for each(_loc4_ in this._weaponUnitList)
         {
            if(Boolean(_loc4_.selected))
            {
               SocketManager.Instance.out.sendAvatarCollectionDelayTime(_loc4_.id,param1,2);
            }
         }
      }
      
      public function listState(param1:String) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         this._isSelectAll = true;
         this._listState = param1;
         for(_loc2_ in this._maleUnitList)
         {
            this._maleUnitList[_loc2_].selected = false;
         }
         for(_loc3_ in this._femaleUnitList)
         {
            this._femaleUnitList[_loc3_].selected = false;
         }
         for(_loc4_ in this._weaponUnitList)
         {
            this._weaponUnitList[_loc4_].selected = false;
         }
         for each(_loc5_ in this._maleItemList)
         {
            _loc5_.selected = false;
         }
         for each(_loc6_ in this._femaleItemList)
         {
            _loc6_.selected = false;
         }
         for each(_loc7_ in this._weaponItemList)
         {
            _loc7_.selected = false;
         }
      }
      
      public function getListState() : String
      {
         return this._listState;
      }
      
      public function resetListCellData() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         this._isSelectAll = false;
         this._listState = "normal";
         for(_loc1_ in this._maleUnitList)
         {
            this._maleUnitList[_loc1_].selected = false;
         }
         for(_loc2_ in this._femaleUnitList)
         {
            this._femaleUnitList[_loc2_].selected = false;
         }
         for(_loc3_ in this._weaponUnitList)
         {
            this._weaponUnitList[_loc3_].selected = false;
         }
         for each(_loc4_ in this._maleItemList)
         {
            _loc4_.selected = false;
         }
         for each(_loc5_ in this._femaleItemList)
         {
            _loc5_.selected = false;
         }
         for each(_loc6_ in this._weaponItemList)
         {
            _loc6_.selected = false;
         }
      }
      
      public function get maleUnitList() : Array
      {
         return this._maleUnitList;
      }
      
      public function get femaleUnitList() : Array
      {
         return this._femaleUnitList;
      }
      
      public function get weaponUnitList() : Array
      {
         return this._weaponUnitList;
      }
      
      public function getItemListById(param1:int, param2:int, param3:int = 1) : Array
      {
         if(param3 == 1)
         {
            if(param1 == 1)
            {
               return this._maleItemDic[param2].list;
            }
            return this._femaleItemDic[param2].list;
         }
         if(param3 == 2)
         {
            return this._weaponItemDic[param2].list;
         }
         return null;
      }
      
      public function unitListDataSetup(param1:AvatarCollectionUnitDataAnalyzer) : void
      {
         if(Boolean(this._maleUnitDic))
         {
            this.unitDicDataConvert(this._maleUnitDic,param1.maleUnitDic);
         }
         else
         {
            this._maleUnitDic = param1.maleUnitDic;
         }
         if(Boolean(this._femaleUnitDic))
         {
            this.unitDicDataConvert(this._femaleUnitDic,param1.femaleUnitDic);
         }
         else
         {
            this._femaleUnitDic = param1.femaleUnitDic;
         }
         if(Boolean(this._weaponUnitDic))
         {
            this.unitDicDataConvert(this._weaponUnitDic,param1.weaponUnitDic);
         }
         else
         {
            this._weaponUnitDic = param1.weaponUnitDic;
         }
         this._maleUnitList = this._maleUnitDic.list;
         this._femaleUnitList = this._femaleUnitDic.list;
         this._weaponUnitList = this._weaponUnitDic.list;
      }
      
      private function unitDicDataConvert(param1:DictionaryData, param2:DictionaryData) : void
      {
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:* = null;
         _loc3_ = 0;
         while(_loc3_ < param2.list.length)
         {
            _loc4_ = param2.list[_loc3_];
            if(_loc5_ = param1[_loc4_.id])
            {
               _loc4_.endTime = _loc5_.endTime;
            }
            param1.add(_loc4_.id,_loc4_);
            _loc3_++;
         }
      }
      
      public function itemListDataSetup(param1:AvatarCollectionItemDataAnalyzer) : void
      {
         if(Boolean(this._maleItemDic))
         {
            this.itemDicDataConvert(this._maleItemDic,param1.maleItemDic);
         }
         else
         {
            this._maleItemDic = param1.maleItemDic;
         }
         if(Boolean(this._femaleItemDic))
         {
            this.itemDicDataConvert(this._femaleItemDic,param1.femaleItemDic);
         }
         else
         {
            this._femaleItemDic = param1.femaleItemDic;
         }
         if(Boolean(this._weaponItemDic))
         {
            this.itemDicDataConvert(this._weaponItemDic,param1.weaponItemDic);
         }
         else
         {
            this._weaponItemDic = param1.weaponItemDic;
         }
         this._maleItemList = param1.maleItemList;
         this._femaleItemList = param1.femaleItemList;
         this._weaponItemList = param1.weaponItemList;
         this._allGoodsTemplateIDlist = param1.allGoodsTemplateIDlist;
         this._realItemIdDic = param1.realItemIdDic;
      }
      
      private function itemDicDataConvert(param1:DictionaryData, param2:DictionaryData) : void
      {
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = null;
         for(_loc7_ in param2)
         {
            _loc3_ = param2[_loc7_];
            if(_loc4_ = param1[_loc7_])
            {
               for(_loc8_ in _loc3_)
               {
                  _loc5_ = _loc3_[_loc8_];
                  if(_loc6_ = _loc4_[_loc8_])
                  {
                     _loc5_.isActivity = _loc6_.isActivity;
                  }
                  _loc4_.add(_loc8_,_loc5_);
               }
            }
            param1.add(_loc7_,_loc3_);
         }
      }
      
      public function initShopItemInfoList() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:* = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(!this._maleShopItemInfoList)
         {
            this._maleShopItemInfoList = new Vector.<ShopItemInfo>();
            _loc1_ = [7,9,11,13,15,17,19,21,23];
            _loc2_ = int(_loc1_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               this._maleShopItemInfoList = this._maleShopItemInfoList.concat(ShopManager.Instance.getValidGoodByType(_loc1_[_loc3_]));
               _loc3_++;
            }
            this._maleShopItemInfoList = this._maleShopItemInfoList.concat(ShopManager.Instance.getDisCountValidGoodByType(1));
         }
         if(!this._femaleShopItemInfoList)
         {
            this._femaleShopItemInfoList = new Vector.<ShopItemInfo>();
            _loc5_ = int((_loc4_ = [8,10,12,14,16,18,20,22,24]).length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               this._femaleShopItemInfoList = this._femaleShopItemInfoList.concat(ShopManager.Instance.getValidGoodByType(_loc4_[_loc6_]));
               _loc6_++;
            }
            this._femaleShopItemInfoList = this._femaleShopItemInfoList.concat(ShopManager.Instance.getDisCountValidGoodByType(1));
         }
         if(!this._weaponShopItemInfoList)
         {
            this._weaponShopItemInfoList = new Vector.<ShopItemInfo>();
            _loc7_ = [5,6];
            _loc8_ = int(_loc7_.length);
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               this._weaponShopItemInfoList = this._weaponShopItemInfoList.concat(ShopManager.Instance.getValidGoodByType(_loc7_[_loc9_]));
               _loc9_++;
            }
            this._weaponShopItemInfoList = this._weaponShopItemInfoList.concat(ShopManager.Instance.getDisCountValidGoodByType(1));
         }
      }
      
      public function checkItemCanBuy() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         if(this._isHasCheckedBuy)
         {
            return;
         }
         for each(_loc1_ in this._maleItemList)
         {
            _loc1_.canBuyStatus = 0;
            for each(_loc4_ in this._maleShopItemInfoList)
            {
               if(_loc1_.itemId == _loc4_.TemplateID)
               {
                  _loc1_.canBuyStatus = 1;
                  _loc1_.buyPrice = _loc4_.getItemPrice(1).bothMoneyValue;
                  _loc1_.isDiscount = _loc4_.isDiscount;
                  _loc1_.goodsId = _loc4_.GoodsID;
                  break;
               }
            }
         }
         for each(_loc2_ in this._femaleItemList)
         {
            _loc2_.canBuyStatus = 0;
            for each(_loc5_ in this._femaleShopItemInfoList)
            {
               if(_loc2_.itemId == _loc5_.TemplateID)
               {
                  _loc2_.canBuyStatus = 1;
                  _loc2_.buyPrice = _loc5_.getItemPrice(1).bothMoneyValue;
                  _loc2_.isDiscount = _loc5_.isDiscount;
                  _loc2_.goodsId = _loc5_.GoodsID;
                  break;
               }
            }
         }
         for each(_loc3_ in this._weaponItemList)
         {
            _loc3_.canBuyStatus = 0;
            for each(_loc6_ in this._weaponShopItemInfoList)
            {
               if(_loc3_.itemId == _loc6_.TemplateID)
               {
                  _loc3_.canBuyStatus = 1;
                  _loc3_.buyPrice = _loc6_.getItemPrice(1).bothMoneyValue;
                  _loc3_.isDiscount = _loc6_.isDiscount;
                  _loc3_.goodsId = _loc6_.GoodsID;
                  break;
               }
            }
         }
         this._isHasCheckedBuy = true;
      }
      
      public function getShopItemInfoByItemId(param1:int, param2:int, param3:int) : ShopItemInfo
      {
         var _loc5_:* = undefined;
         var _loc4_:* = undefined;
         if(param3 == 1)
         {
            if(param2 == 1)
            {
               _loc4_ = this._maleShopItemInfoList;
            }
            else
            {
               _loc4_ = this._femaleShopItemInfoList;
            }
         }
         else
         {
            _loc4_ = this._weaponShopItemInfoList;
         }
         for each(_loc5_ in _loc4_)
         {
            if(param1 == _loc5_.TemplateID)
            {
               return _loc5_;
            }
         }
         return null;
      }
      
      public function setup() : void
      {
         this._maleUnitDic = new DictionaryData();
         this._maleItemDic = new DictionaryData();
         this._femaleUnitDic = new DictionaryData();
         this._femaleItemDic = new DictionaryData();
         this._weaponUnitDic = new DictionaryData();
         this._weaponItemDic = new DictionaryData();
         SocketManager.Instance.addEventListener(PkgEvent.format(402),this.pkgHandler);
      }
      
      private function pkgHandler(param1:PkgEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         switch(int(_loc3_) - 3)
         {
            case 0:
               this.activeHandler(_loc2_);
               break;
            case 1:
               this.delayTimeHandler(_loc2_);
               break;
            case 2:
               this.getAllInfoHandler(_loc2_);
         }
      }
      
      private function getAllInfoHandler(param1:PackageIn) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = null;
         var _loc9_:* = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = param1.readInt();
         _loc2_ = 0;
         while(_loc2_ < _loc14_)
         {
            _loc3_ = param1.readInt();
            _loc4_ = param1.readInt();
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = param1.readInt();
               _loc7_ = param1.readInt();
               _loc8_ = new AvatarCollectionUnitVo();
               if(_loc3_ == 1)
               {
                  if(_loc7_ == 1)
                  {
                     this._maleUnitDic.add(_loc6_,_loc8_);
                     _loc9_ = this._maleItemDic[_loc6_];
                  }
                  else
                  {
                     this._femaleUnitDic.add(_loc6_,_loc8_);
                     _loc9_ = this._femaleItemDic[_loc6_];
                  }
               }
               else if(_loc3_ == 2)
               {
                  this._weaponUnitDic.add(_loc6_,_loc8_);
                  _loc9_ = this._weaponItemDic[_loc6_];
               }
               _loc10_ = param1.readInt();
               _loc11_ = 0;
               while(_loc11_ < _loc10_)
               {
                  _loc12_ = param1.readInt();
                  _loc13_ = int(this._realItemIdDic[_loc12_]);
                  (_loc9_[_loc13_] as AvatarCollectionItemVo).isActivity = true;
                  _loc11_++;
               }
               _loc8_.endTime = param1.readDate();
               _loc5_++;
            }
            _loc2_++;
         }
         this.isDataComplete = true;
         dispatchEvent(new Event("avatar_collection_data_complete"));
      }
      
      private function activeHandler(param1:PackageIn) : void
      {
         var _loc5_:int = 0;
         var _loc2_:int = param1.readInt();
         var _loc3_:int = param1.readInt();
         _loc3_ = int(this._realItemIdDic[_loc3_]);
         var _loc4_:int = param1.readInt();
         if((_loc5_ = param1.readInt()) == 1)
         {
            if(_loc4_ == 1)
            {
               (this._maleItemDic[_loc2_][_loc3_] as AvatarCollectionItemVo).isActivity = true;
            }
            else
            {
               (this._femaleItemDic[_loc2_][_loc3_] as AvatarCollectionItemVo).isActivity = true;
            }
         }
         else if(_loc5_ == 2)
         {
            (this._weaponItemDic[_loc2_][_loc3_] as AvatarCollectionItemVo).isActivity = true;
         }
         dispatchEvent(new Event(REFRESH_VIEW));
      }
      
      private function delayTimeHandler(param1:PackageIn) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = param1.readInt();
         var _loc3_:int = param1.readInt();
         if((_loc4_ = param1.readInt()) == 1)
         {
            if(_loc3_ == 1)
            {
               (this._maleUnitDic[_loc2_] as AvatarCollectionUnitVo).endTime = param1.readDate();
            }
            else
            {
               (this._femaleUnitDic[_loc2_] as AvatarCollectionUnitVo).endTime = param1.readDate();
            }
         }
         else if(_loc4_ == 2)
         {
            (this._weaponUnitDic[_loc2_] as AvatarCollectionUnitVo).endTime = param1.readDate();
         }
         dispatchEvent(new Event(REFRESH_VIEW));
      }
      
      public function isCollectionGoodsByTemplateID(param1:int) : Boolean
      {
         return this._allGoodsTemplateIDlist[param1];
      }
      
      public function showFrame(param1:Sprite) : void
      {
         this.cevent = new CEvent("openview",{"parent":param1});
         AssetModuleLoader.addModelLoader("avatarcollection",6);
         AssetModuleLoader.startCodeLoader(this.show);
      }
      
      public function show() : void
      {
         dispatchEvent(this.cevent);
         this.cevent = null;
      }
      
      public function closeFrame() : void
      {
         this.resetListCellData();
         dispatchEvent(new CEvent("closeView"));
      }
      
      public function visible(param1:Boolean) : void
      {
         dispatchEvent(new CEvent("visible",{"visible":param1}));
      }
   }
}
