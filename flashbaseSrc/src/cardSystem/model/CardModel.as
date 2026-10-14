package cardSystem.model
{
   import cardSystem.CardEvent;
   import cardSystem.data.CardInfo;
   import cardSystem.data.SetsInfo;
   import cardSystem.data.SetsUpgradeRuleInfo;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   import road7th.data.DictionaryData;
   
   public class CardModel extends EventDispatcher
   {
      
      public static const OPEN_FOUR_NEEDS_TWOSTAR:int = 1;
      
      public static const OPEN_FIVE_NEEDS_THREESTAR:int = 2;
      
      public static const OPEN_FIVE_NEEDS_THREESTARTWO:int = 3;
      
      public static const MONSTER_CARDS:int = 0;
      
      public static const WEQPON_CARDS:int = 1;
      
      public static const PVE_CARDS:int = 2;
      
      public static const CELLS_SUM:int = 15;
      
      public static const EQUIP_CELLS_SUM:int = 5;
       
      
      private var _setsList:DictionaryData;
      
      private var _setsSortRuleVector:Vector.<SetsInfo>;
      
      public var upgradeRuleVec:Vector.<SetsUpgradeRuleInfo>;
      
      public var propIncreaseDic:DictionaryData;
      
      public function CardModel()
      {
         super();
      }
      
      public function get setsSortRuleVector() : Vector.<SetsInfo>
      {
         return this._setsSortRuleVector;
      }
      
      public function set setsSortRuleVector(param1:Vector.<SetsInfo>) : void
      {
         this._setsSortRuleVector = param1;
         dispatchEvent(new CardEvent(CardEvent.SETSSORTRULE_INIT_COMPLETE,this.setsSortRuleVector));
      }
      
      public function get setsList() : DictionaryData
      {
         return this._setsList;
      }
      
      public function set setsList(param1:DictionaryData) : void
      {
         this._setsList = param1;
         dispatchEvent(new CardEvent(CardEvent.SETSPROP_INIT_COMPLETE,this.setsList));
      }
      
      public function fourIsOpen() : Boolean
      {
         var _loc1_:CardInfo = null;
         var _loc2_:int = 0;
         for each(_loc1_ in PlayerManager.Instance.Self.cardBagDic)
         {
            if(_loc1_.Level >= 20)
            {
               _loc2_++;
            }
         }
         return _loc2_ >= OPEN_FOUR_NEEDS_TWOSTAR;
      }
      
      public function fiveIsOpen() : Boolean
      {
         var _loc1_:CardInfo = null;
         var _loc2_:int = 0;
         for each(_loc1_ in PlayerManager.Instance.Self.cardBagDic)
         {
            if(_loc1_.Level == 30)
            {
               _loc2_++;
            }
         }
         return _loc2_ >= OPEN_FOUR_NEEDS_TWOSTAR;
      }
      
      public function fiveIsOpen2() : Boolean
      {
         var _loc1_:CardInfo = null;
         var _loc2_:int = 0;
         for each(_loc1_ in PlayerManager.Instance.Self.cardBagDic)
         {
            if(_loc1_.Level >= 20)
            {
               _loc2_++;
            }
         }
         return _loc2_ >= OPEN_FIVE_NEEDS_THREESTARTWO;
      }
      
      public function get Pages() : int
      {
         return Math.ceil(PlayerManager.Instance.Self.cardBagDic.length / CELLS_SUM);
      }
      
      public function getDataByPage(param1:int) : DictionaryData
      {
         var _loc2_:CardInfo = null;
         var _loc3_:DictionaryData = new DictionaryData();
         var _loc4_:DictionaryData = PlayerManager.Instance.Self.cardBagDic;
         var _loc5_:int = (param1 - 1) * CELLS_SUM + EQUIP_CELLS_SUM;
         var _loc6_:int = _loc5_ + CELLS_SUM;
         for each(_loc2_ in _loc4_)
         {
            if(_loc2_.Place >= _loc5_ && _loc2_.Place < _loc6_)
            {
               _loc3_[_loc2_.Place] = _loc2_;
            }
         }
         return _loc3_;
      }
      
      public function getBagListData() : Array
      {
         var _loc1_:CardInfo = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = new Array();
         var _loc5_:DictionaryData = PlayerManager.Instance.Self.cardBagDic;
         var _loc6_:int = 0;
         for each(_loc1_ in _loc5_)
         {
            _loc2_ = _loc1_.Place % 4 == 0 ? int(_loc1_.Place / 4 - 2) : int(_loc1_.Place / 4 - 1);
            if(_loc4_[_loc2_] == null)
            {
               _loc4_[_loc2_] = new Array();
            }
            _loc3_ = _loc1_.Place % 4 == 0 ? int(4) : int(_loc1_.Place % 4);
            _loc4_[_loc2_][0] = _loc2_ + 1;
            _loc4_[_loc2_][_loc3_] = _loc1_;
            if(_loc2_ + 1 > _loc6_)
            {
               _loc6_ = _loc2_ + 1;
            }
         }
         if(_loc6_ < 3)
         {
            _loc6_ = 3;
         }
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            if(_loc4_[_loc7_] == null)
            {
               _loc4_[_loc7_] = new Array();
               _loc4_[_loc7_][0] = _loc7_ + 1;
            }
            _loc7_++;
         }
         return _loc4_;
      }
      
      public function getSetsCardFromCardBag(param1:String) : Vector.<CardInfo>
      {
         var _loc2_:CardInfo = null;
         var _loc3_:DictionaryData = PlayerManager.Instance.Self.cardBagDic;
         var _loc4_:Vector.<CardInfo> = new Vector.<CardInfo>();
         for each(_loc2_ in _loc3_)
         {
            if(_loc2_.templateInfo.Property7 == param1)
            {
               _loc4_.push(_loc2_);
            }
         }
         return _loc4_;
      }
   }
}
