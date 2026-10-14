package pyramid.model
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import pyramid.data.PyramidSystemItemsInfo;
   import pyramid.event.PyramidEvent;
   
   public class PyramidModel extends EventDispatcher
   {
       
      
      public var isOpen:Boolean;
      
      public var isScoreExchange:Boolean;
      
      public var turnCardPrice:int;
      
      public var revivePrice:Array;
      
      public var freeCount:int;
      
      public var beginTime:Date;
      
      public var endTime:Date;
      
      public var currentLayer:int;
      
      public var position:int;
      
      public var maxLayer:int;
      
      private var _totalPoint:int;
      
      public var turnPoint:int;
      
      public var pointRatio:int;
      
      public var currentFreeCount:int;
      
      public var currentReviveCount:int;
      
      public var isPyramidStart:Boolean;
      
      public var selectLayerItems:Dictionary;
      
      public var templateID:int;
      
      public var isPyramidDie:Boolean;
      
      public var isUp:Boolean;
      
      public var items:Array;
      
      public function PyramidModel(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public function getLevelCardItems(param1:int) : Array
      {
         return this.items[param1 - 1];
      }
      
      public function getLevelCardItem(param1:int, param2:int) : PyramidSystemItemsInfo
      {
         var _loc3_:PyramidSystemItemsInfo = null;
         var _loc4_:Array = null;
         var _loc5_:PyramidSystemItemsInfo = null;
         if(this.isUp)
         {
            _loc4_ = this.items[param1 - 2];
         }
         else
         {
            _loc4_ = this.items[param1 - 1];
         }
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc5_ = _loc4_[_loc6_];
            if(_loc5_.TemplateID == param2)
            {
               _loc3_ = _loc5_;
               break;
            }
            _loc6_++;
         }
         return _loc3_;
      }
      
      public function getInventoryItemInfo(param1:PyramidSystemItemsInfo) : InventoryItemInfo
      {
         var _loc2_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(param1.TemplateID);
         var _loc3_:InventoryItemInfo = new InventoryItemInfo();
         ObjectUtils.copyProperties(_loc3_,_loc2_);
         _loc3_.LuckCompose = param1.TemplateID;
         _loc3_.ValidDate = param1.ValidDate;
         _loc3_.Count = param1.Count;
         _loc3_.IsBinds = param1.IsBind;
         _loc3_.StrengthenLevel = param1.StrengthLevel;
         _loc3_.AttackCompose = param1.AttackCompose;
         _loc3_.DefendCompose = param1.DefendCompose;
         _loc3_.AgilityCompose = param1.AgilityCompose;
         _loc3_.LuckCompose = param1.LuckCompose;
         _loc3_.isShowBind = false;
         return _loc3_;
      }
      
      public function get activityTime() : String
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = "";
         if(Boolean(this.beginTime) && Boolean(this.endTime))
         {
            _loc1_ = this.beginTime.minutes > 9 ? this.beginTime.minutes + "" : "0" + this.beginTime.minutes;
            _loc2_ = this.endTime.minutes > 9 ? this.endTime.minutes + "" : "0" + this.endTime.minutes;
            _loc3_ = this.beginTime.fullYear + "." + (this.beginTime.month + 1) + "." + this.beginTime.date + " " + this.beginTime.hours + ":" + _loc1_ + " - " + this.endTime.fullYear + "." + (this.endTime.month + 1) + "." + this.endTime.date + " " + this.endTime.hours + ":" + _loc2_;
         }
         return _loc3_;
      }
      
      public function get isShuffleMovie() : Boolean
      {
         var _loc1_:Object = null;
         if(this.currentLayer >= 8)
         {
            return false;
         }
         if(!this.isPyramidStart)
         {
            return false;
         }
         if(this.isUp)
         {
            return true;
         }
         var _loc2_:int = 0;
         var _loc3_:Dictionary = this.selectLayerItems[this.currentLayer];
         for each(_loc1_ in _loc3_)
         {
            _loc2_++;
         }
         if(_loc2_ > 0)
         {
            return false;
         }
         return true;
      }
      
      public function dataChange(param1:String, param2:Object = null) : void
      {
         dispatchEvent(new PyramidEvent(param1,param2));
      }
      
      public function set totalPoint(param1:int) : void
      {
         this._totalPoint = param1;
         dispatchEvent(new PyramidEvent(PyramidEvent.DATA_CHANGE));
      }
      
      public function get totalPoint() : int
      {
         return this._totalPoint;
      }
   }
}
