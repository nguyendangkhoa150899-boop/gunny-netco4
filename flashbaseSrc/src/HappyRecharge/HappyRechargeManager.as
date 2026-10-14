package HappyRecharge
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.utils.HelperUIModuleLoad;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import hallIcon.HallIconManager;
   import road7th.comm.PackageIn;
   
   public class HappyRechargeManager extends EventDispatcher
   {
      
      private static var happyRechargeManager:HappyRecharge.HappyRechargeManager;
       
      
      public var mouseClickEnable:Boolean;
      
      private var _frame:HappyRecharge.HappyRechargeFrame;
      
      private var _isOpen:Boolean = false;
      
      private var _enterBtn:SimpleBitmapButton;
      
      private var _lotteryCount:int;
      
      private var _prizeItemID:int;
      
      private var _prizeItem:InventoryItemInfo;
      
      private var _prizeCount:int;
      
      private var _exchangeItems:Array;
      
      private var _ticketCount:int = 5;
      
      private var _activityData:String;
      
      private var _specialPrizeCount:Array;
      
      private var _currentPrizeItemID:int;
      
      private var _currentPrizeItemSortID:int;
      
      private var _currentPrizeItemCount:int;
      
      private var _turnItems:Array;
      
      private var _recordArr:Array;
      
      private var _moneyCount:int;
      
      public var isAutoStart:Boolean = false;
      
      public function HappyRechargeManager(param1:HappyRechargeInstance, param2:IEventDispatcher = null)
      {
         super(param2);
      }
      
      public static function get instance() : HappyRecharge.HappyRechargeManager
      {
         if(happyRechargeManager == null)
         {
            happyRechargeManager = new HappyRecharge.HappyRechargeManager(new HappyRechargeInstance());
         }
         return happyRechargeManager;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function get lotteryCount() : int
      {
         return this._lotteryCount;
      }
      
      public function get prizeItemID() : int
      {
         return this._prizeItemID;
      }
      
      public function get prizeItem() : InventoryItemInfo
      {
         return this._prizeItem;
      }
      
      public function get prizeCount() : int
      {
         return this._prizeCount;
      }
      
      public function get exchangeItems() : Array
      {
         return this._exchangeItems;
      }
      
      public function get ticketCount() : int
      {
         return this._ticketCount;
      }
      
      public function get activityData() : String
      {
         return this._activityData;
      }
      
      public function get specialPrizeCount() : Array
      {
         if(this._specialPrizeCount == null)
         {
            this._specialPrizeCount = ServerConfigManager.instance.getHappyRechargeSpecialItemCount();
         }
         return this._specialPrizeCount;
      }
      
      public function get currentPrizeItemID() : int
      {
         return this._currentPrizeItemID;
      }
      
      public function get currentPrizeItemSortID() : int
      {
         return this._currentPrizeItemSortID;
      }
      
      public function get currentPrizeItemCount() : int
      {
         return this._currentPrizeItemCount;
      }
      
      public function get turnItems() : Array
      {
         return this._turnItems;
      }
      
      public function get recordArr() : Array
      {
         return this._recordArr;
      }
      
      public function get moneyCount() : int
      {
         return this._moneyCount;
      }
      
      public function loadResource() : void
      {
         if(StateManager.currentStateType == "main")
         {
            new HelperUIModuleLoad().loadUIModule(["happyRecharge"],this.createFrame);
         }
      }
      
      private function createFrame() : void
      {
         SocketManager.Instance.out.happyRechargeEnter();
      }
      
      private function _socketManagerHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:* = param1._cmd & 255;
         switch(int(_loc3_) - 176)
         {
            case 0:
               this._happyRechargePlayResponseHandler(_loc2_);
               break;
            case 1:
               this._happyRechargeExchangeResponseHandler(_loc2_);
               break;
            case 2:
               this._happyRechargeOpenResponseHandler(_loc2_);
               break;
            case 3:
               this._happyRechargeEnterResponseHandler(_loc2_);
               break;
            case 4:
               this._happyRechargeUpdateResponseHandler(_loc2_);
         }
      }
      
      private function _happyRechargePlayResponseHandler(param1:PackageIn) : void
      {
         this._currentPrizeItemID = param1.readInt();
         this._currentPrizeItemSortID = param1.readInt();
         this._currentPrizeItemCount = param1.readInt();
         this._lotteryCount = param1.readInt();
         this._ticketCount = param1.readInt();
         if(HappyRechargeManager.instance.isAutoStart)
         {
            this._frame.autoStartTuren(this._currentPrizeItemSortID);
         }
         else
         {
            this._frame.startTurn(this._currentPrizeItemSortID);
         }
      }
      
      private function _happyRechargeExchangeResponseHandler(param1:PackageIn) : void
      {
         this._ticketCount = param1.readInt();
         dispatchEvent(new Event("HAPPYRECHARGE_UPDATE_TICKET"));
      }
      
      private function _happyRechargeOpenResponseHandler(param1:PackageIn) : void
      {
         this._isOpen = param1.readBoolean();
         if(this._isOpen)
         {
            this.createIcon();
         }
         else
         {
            this.removeIcon();
         }
      }
      
      private function _happyRechargeEnterResponseHandler(param1:PackageIn) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:* = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:* = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:* = null;
         var _loc18_:int = 0;
         var _loc19_:* = null;
         this._moneyCount = param1.readInt();
         this._lotteryCount = param1.readInt();
         this._ticketCount = param1.readInt();
         var _loc20_:Date = param1.readDate();
         var _loc21_:Date = param1.readDate();
         this._createActivityDate(_loc20_,_loc21_);
         this._prizeItemID = param1.readInt();
         this._prizeCount = param1.readInt();
         var _loc22_:int = param1.readInt();
         var _loc23_:String = param1.readUTF();
         var _loc24_:int = param1.readInt();
         this._prizeItem = this.__createPrizeItemInfo(this._prizeItemID,this._prizeCount,_loc22_,_loc23_,_loc24_);
         if(this._turnItems == null)
         {
            this._turnItems = [];
         }
         else
         {
            while(this._turnItems.length > 0)
            {
               this._turnItems.pop();
            }
         }
         var _loc25_:int = param1.readInt();
         _loc2_ = 0;
         while(_loc2_ < _loc25_)
         {
            _loc3_ = param1.readInt();
            _loc4_ = param1.readInt();
            _loc5_ = param1.readInt();
            _loc6_ = param1.readUTF();
            _loc7_ = param1.readInt();
            _loc8_ = param1.readInt();
            _loc9_ = this._createTurnItemInfo(_loc7_,_loc3_,_loc4_,_loc5_,_loc6_,_loc8_);
            this._turnItems.push(_loc9_);
            _loc2_++;
         }
         if(this._exchangeItems == null)
         {
            this._exchangeItems = [];
         }
         else
         {
            while(this._exchangeItems.length > 0)
            {
               this._exchangeItems.pop();
            }
         }
         var _loc26_:int = param1.readInt();
         _loc10_ = 0;
         while(_loc10_ < _loc26_)
         {
            _loc11_ = param1.readInt();
            _loc12_ = param1.readInt();
            _loc13_ = param1.readInt();
            _loc14_ = param1.readUTF();
            _loc15_ = int(param1.readUTF());
            _loc16_ = param1.readInt();
            _loc17_ = this._createExchangeItemInfo(_loc11_,_loc12_,_loc13_,_loc14_,_loc15_,_loc16_);
            this._exchangeItems.push(_loc17_);
            _loc10_++;
         }
         if(this._recordArr == null)
         {
            this._recordArr = [];
         }
         else
         {
            while(this._recordArr.length > 0)
            {
               this._recordArr.pop();
            }
         }
         var _loc27_:int = param1.readInt();
         _loc18_ = 0;
         while(_loc18_ < _loc27_)
         {
            (_loc19_ = new HappyRechargeRecordItem()).prizeType = param1.readInt();
            _loc19_.count = param1.readInt();
            _loc19_.nickName = param1.readUTF();
            this._recordArr.push(_loc19_);
            _loc18_++;
         }
         this._frame = ComponentFactory.Instance.creatComponentByStylename("happyrecharge.mainframe");
         LayerManager.Instance.addToLayer(this._frame,3,true,1);
      }
      
      private function _happyRechargeUpdateResponseHandler(param1:PackageIn) : void
      {
         var _loc6_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         if((_loc6_ = param1.readInt()) == 1)
         {
            this._prizeCount = param1.readInt();
            _loc2_ = param1.readInt();
            _loc3_ = param1.readUTF();
            _loc4_ = param1.readInt();
            if(Boolean(this._frame))
            {
               if(_loc2_ > 9 && _loc2_ < 13)
               {
                  (_loc5_ = new HappyRechargeRecordItem()).prizeType = _loc2_;
                  _loc5_.nickName = _loc3_;
                  _loc5_.count = _loc4_;
               }
               this._frame.updateView(_loc5_);
            }
         }
         else if(_loc6_ == 2)
         {
            this._lotteryCount = param1.readInt();
         }
      }
      
      private function _createActivityDate(param1:Date, param2:Date) : void
      {
         if(Boolean(param1) && Boolean(param2))
         {
            this._activityData = param1.getFullYear() + "/" + (param1.getMonth() + 1) + "/" + param1.getDate() + " " + param1.getHours() + ":" + param1.getMinutes() + ":" + param1.getSeconds() + " - " + param2.getFullYear() + "/" + (param2.getMonth() + 1) + "/" + param2.getDate() + " " + param2.getHours() + ":" + param2.getMinutes() + ":" + param2.getSeconds();
         }
         else
         {
            this._activityData = "1989/02/08 06:00:00 - ????/??/?? 00:00:00";
         }
      }
      
      private function __createPrizeItemInfo(param1:int, param2:int, param3:int, param4:String, param5:int) : InventoryItemInfo
      {
         var _loc6_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(param1);
         var _loc7_:InventoryItemInfo = new InventoryItemInfo();
         ObjectUtils.copyProperties(_loc7_,_loc6_);
         _loc7_.ValidDate = param3;
         this._createAttribute(_loc7_,param4);
         _loc7_.IsBinds = param5 == 1 ? true : false;
         return _loc7_;
      }
      
      private function _createTurnItemInfo(param1:int, param2:int, param3:int, param4:int, param5:String, param6:int) : HappyRechargeTurnItemInfo
      {
         var _loc7_:HappyRechargeTurnItemInfo = null;
         (_loc7_ = new HappyRechargeTurnItemInfo()).indexId = param1;
         var _loc8_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(param2);
         var _loc9_:InventoryItemInfo = new InventoryItemInfo();
         ObjectUtils.copyProperties(_loc9_,_loc8_);
         _loc9_.Count = param3;
         _loc9_.ValidDate = Number(param4);
         this._createAttribute(_loc9_,param5);
         _loc7_.itemInfo = _loc9_;
         _loc7_.itemInfo.IsBinds = param6 == 1 ? true : false;
         return _loc7_;
      }
      
      private function _createExchangeItemInfo(param1:int, param2:int, param3:int, param4:String, param5:int, param6:int) : HappyRechargeExchangeItem
      {
         var _loc7_:HappyRechargeExchangeItem = new HappyRechargeExchangeItem();
         var _loc8_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(param1);
         var _loc9_:InventoryItemInfo = new InventoryItemInfo();
         ObjectUtils.copyProperties(_loc9_,_loc8_);
         _loc9_.Count = param2;
         _loc9_.ValidDate = param3;
         _loc9_.IsBinds = param6 == 1 ? true : false;
         this._createAttribute(_loc9_,param4);
         _loc7_.info = _loc9_;
         _loc7_.count = param2;
         _loc7_.needCount = param5;
         return _loc7_;
      }
      
      private function _createAttribute(param1:InventoryItemInfo, param2:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Array = param2.split(",");
         _loc3_ = 0;
         while(_loc3_ < _loc4_.length)
         {
            switch(int(_loc3_))
            {
               case 0:
                  param1.StrengthenLevel = _loc4_[_loc3_];
                  break;
               case 1:
                  param1.AttackCompose = _loc4_[_loc3_];
                  break;
               case 2:
                  param1.DefendCompose = _loc4_[_loc3_];
                  break;
               case 3:
                  param1.AgilityCompose = _loc4_[_loc3_];
                  break;
               case 4:
                  param1.LuckCompose = _loc4_[_loc3_];
                  break;
               case 5:
                  break;
               case 6:
                  break;
               case 7:
                  break;
               case 8:
                  param1._StrengthenExp = _loc4_[_loc3_];
                  break;
            }
            _loc3_++;
         }
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener("happyRecharge",this._socketManagerHandler);
      }
      
      public function createIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler("happyRecharge",true);
      }
      
      public function removeIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler("happyRecharge",false);
      }
      
      protected function onEnterClick(param1:MouseEvent) : void
      {
         HappyRechargeManager.instance.loadResource();
      }
   }
}

class HappyRechargeInstance
{
    
   
   public function HappyRechargeInstance()
   {
      super();
   }
}
