package latentEnergy
{
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class LatentEnergyManager extends EventDispatcher
   {
      
      public static const EQUIP_MOVE:String = "latentEnergy_equip_move";
      
      public static const EQUIP_MOVE2:String = "latentEnergy_equip_move2";
      
      public static const ITEM_MOVE:String = "latentEnergy_item_move";
      
      public static const ITEM_MOVE2:String = "latentEnergy_item_move2";
      
      public static const EQUIP_CHANGE:String = "latentEnergy_equip_change";
      
      private static var _instance:latentEnergy.LatentEnergyManager;
       
      
      private var _cacheDataList:Array;
      
      private var _timer:Timer;
      
      public function LatentEnergyManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : latentEnergy.LatentEnergyManager
      {
         if(_instance == null)
         {
            _instance = new latentEnergy.LatentEnergyManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LATENT_ENERGY,this.equipChangeHandler);
         this._cacheDataList = [];
         this._timer = new Timer(200,25);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.timerCompleteHandler,false,0,true);
      }
      
      private function equipChangeHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Object = {};
         _loc3_.place = _loc2_.readInt();
         _loc3_.curStr = _loc2_.readUTF();
         _loc3_.newStr = _loc2_.readUTF();
         _loc3_.endTime = _loc2_.readDate();
         var _loc4_:InventoryItemInfo = PlayerManager.Instance.Self.Bag.items[_loc3_.place] as InventoryItemInfo;
         if(Boolean(_loc4_))
         {
            this.doChange(_loc4_,_loc3_);
         }
         else
         {
            this._cacheDataList.push(_loc3_);
            this._timer.reset();
            this._timer.start();
         }
      }
      
      private function doChange(param1:InventoryItemInfo, param2:Object) : void
      {
         param1.latentEnergyCurStr = param2.curStr;
         param1.latentEnergyNewStr = param2.newStr;
         param1.latentEnergyEndTime = param2.endTime;
         param1.IsBinds = true;
         dispatchEvent(new Event(EQUIP_CHANGE));
      }
      
      private function timerHandler(param1:TimerEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:int = int(this._cacheDataList.length);
         if(_loc4_ > 0)
         {
            _loc2_ = _loc4_ - 1;
            while(_loc2_ >= 0)
            {
               _loc3_ = PlayerManager.Instance.Self.Bag.items[this._cacheDataList[_loc2_].place] as InventoryItemInfo;
               if(Boolean(_loc3_))
               {
                  this.doChange(_loc3_,this._cacheDataList[_loc2_]);
                  this._cacheDataList.splice(_loc2_,1);
               }
               _loc2_--;
            }
         }
         else
         {
            this._timer.stop();
         }
      }
      
      private function timerCompleteHandler(param1:TimerEvent) : void
      {
         this._cacheDataList = [];
      }
      
      public function getCanLatentEnergyData() : BagInfo
      {
         var _loc1_:InventoryItemInfo = null;
         var _loc2_:DictionaryData = PlayerManager.Instance.Self.Bag.items;
         var _loc3_:BagInfo = new BagInfo(BagInfo.EQUIPBAG,21);
         for each(_loc1_ in _loc2_)
         {
            if(_loc1_.isCanLatentEnergy)
            {
               if(_loc1_.getRemainDate() > 0)
               {
                  _loc3_.addItem(_loc1_);
               }
            }
         }
         return _loc3_;
      }
      
      public function getLatentEnergyItemData() : BagInfo
      {
         var _loc1_:InventoryItemInfo = null;
         var _loc2_:DictionaryData = PlayerManager.Instance.Self.PropBag.items;
         var _loc3_:BagInfo = new BagInfo(BagInfo.PROPBAG,21);
         for each(_loc1_ in _loc2_)
         {
            if(_loc1_.CategoryID == 11 && int(_loc1_.Property1) == 101)
            {
               _loc3_.addItem(_loc1_);
            }
         }
         return _loc3_;
      }
   }
}
