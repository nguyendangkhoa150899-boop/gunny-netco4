package GodSyah
{
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   
   public class SyahManager extends EventDispatcher
   {
      
      private static var _syahManager:GodSyah.SyahManager;
       
      
      public const SYAHVIEW:String = "syahview";
      
      public const BAGANDOTHERS:String = "bagandothers";
      
      public const OTHERS:String = "others";
      
      public var totalDamage:int;
      
      public var totalArmor:int;
      
      private var _isOpen:Boolean = false;
      
      private var _syahItemVec:Vector.<GodSyah.SyahMode>;
      
      private var _valid:String;
      
      private var _description:String;
      
      private var _startTime:Date;
      
      private var _endTime:Date;
      
      private var _enableIndexs:Array;
      
      private var _earlyTime:Date;
      
      private var _isStart:Boolean;
      
      private var _timer:Timer;
      
      private var _login:Boolean;
      
      private var _cellItems:Vector.<InventoryItemInfo>;
      
      private var _cellItemsArray:Array;
      
      private var _inView:Boolean;
      
      public function SyahManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get Instance() : GodSyah.SyahManager
      {
         if(_syahManager == null)
         {
            _syahManager = new GodSyah.SyahManager();
         }
         return _syahManager;
      }
      
      private function setup() : void
      {
         this._isOpen = true;
         this.showIcon();
      }
      
      public function stopSyah() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.SYAH,false);
      }
      
      public function showIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.SYAH,true);
      }
      
      public function showFrame() : void
      {
         var _loc1_:SyahView = null;
         SoundManager.instance.play("008");
         _loc1_ = new SyahView();
         _loc1_.init();
         _loc1_.x = -227;
         HallIconManager.instance.showCommonFrame(_loc1_,"wonderfulActivityManager.btnTxt13");
      }
      
      public function godSyahLoaderCompleted(param1:SyahAnalyzer) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = param1.details;
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:Date = param1.nowTime;
         this._earlyTime = _loc3_[0][4];
         this._enableIndexs = null;
         this._enableIndexs = new Array();
         this._cellItemsArray = null;
         this._cellItemsArray = new Array();
         this._cellItems = null;
         this._cellItems = new Vector.<InventoryItemInfo>();
         this._syahItemVec = null;
         this._syahItemVec = new Vector.<SyahMode>();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            this._startTime = _loc3_[_loc5_][3];
            this._endTime = _loc3_[_loc5_][4];
            if(this._earlyTime.time > this._startTime.time)
            {
               this._earlyTime = this._startTime;
               this._valid = _loc3_[_loc5_][1];
               this._description = _loc3_[_loc5_][2];
            }
            if(_loc4_.time >= this._startTime.time && _loc4_.time < this._endTime.time)
            {
               this._enableIndexs.push(_loc5_);
               this._cellItemsArray.push(param1.infos[_loc5_]);
               _loc2_ = 0;
               while(_loc2_ < param1.modes[_loc5_].length)
               {
                  this._syahItemVec.push(param1.modes[_loc5_][_loc2_]);
                  _loc2_++;
               }
            }
            _loc5_++;
         }
         if(this._enableIndexs.length > 0)
         {
            this.setup();
         }
      }
      
      private function __checkSyahValid(param1:TimerEvent) : void
      {
         var _loc2_:Date = TimeManager.Instance.serverDate;
         if(this._isStart)
         {
            if(_loc2_.time > this._endTime.time)
            {
               this._timer.stop();
               this._timer.removeEventListener(TimerEvent.TIMER,this.__checkSyahValid);
               this._timer = null;
               this.stopSyah();
            }
         }
         else if(_loc2_.time >= this._startTime.time)
         {
            this.showIcon();
         }
      }
      
      public function selectFromBagAndInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Date = TimeManager.Instance.serverDate;
         var _loc3_:Number = this._endTime.time - _loc2_.time;
         var _loc4_:Array = PlayerManager.Instance.Self.Bag.items.list;
         var _loc5_:int = 0;
         while(_loc5_ < this._syahItemVec.length)
         {
            this._syahItemVec[_loc5_].isHold = false;
            this._syahItemVec[_loc5_].isValid = false;
            _loc1_ = 0;
            while(_loc1_ < _loc4_.length)
            {
               if(this._syahItemVec[_loc5_].level == -1 && this._syahItemVec[_loc5_].syahID == _loc4_[_loc1_].TemplateID)
               {
                  this._syahItemVec[_loc5_].isHold = true;
                  if(_loc4_[_loc1_].ValidDate == 0)
                  {
                     this._syahItemVec[_loc5_].isValid = true;
                  }
                  else if(_loc4_[_loc1_].getRemainDate() * 24 * 60 * 60 * 1000 >= _loc3_)
                  {
                     this._syahItemVec[_loc5_].isValid = true;
                  }
               }
               else if(this._syahItemVec[_loc5_].syahID == _loc4_[_loc1_].TemplateID && this._syahItemVec[_loc5_].isGold == _loc4_[_loc1_].isGold && this._syahItemVec[_loc5_].level == _loc4_[_loc1_].StrengthenLevel)
               {
                  this._syahItemVec[_loc5_].isHold = true;
                  if(_loc4_[_loc1_].ValidDate == 0)
                  {
                     this._syahItemVec[_loc5_].isValid = true;
                  }
                  else if(_loc4_[_loc1_].getRemainDate() * 24 * 60 * 60 * 1000 >= _loc3_)
                  {
                     this._syahItemVec[_loc5_].isValid = true;
                  }
               }
               _loc1_++;
            }
            _loc5_++;
         }
      }
      
      public function setModeValid(param1:Object) : Boolean
      {
         var _loc2_:Date = TimeManager.Instance.serverDate;
         var _loc3_:Number = this._endTime.time - _loc2_.time;
         if(param1 is InventoryItemInfo)
         {
            if(param1.ValidDate == 0)
            {
               return true;
            }
            if(param1.getRemainDate() * 24 * 60 * 60 * 1000 >= _loc3_)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getSyahModeByInfo(param1:ItemTemplateInfo) : GodSyah.SyahMode
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._syahItemVec.length)
         {
            if(param1 is InventoryItemInfo)
            {
               if(this._syahItemVec[_loc2_].level == -1 && this._syahItemVec[_loc2_].syahID == param1.TemplateID)
               {
                  return this._syahItemVec[_loc2_];
               }
               if(this._syahItemVec[_loc2_].syahID == param1.TemplateID && this._syahItemVec[_loc2_].isGold == (param1 as InventoryItemInfo).isGold && this._syahItemVec[_loc2_].level == (param1 as InventoryItemInfo).StrengthenLevel)
               {
                  return this._syahItemVec[_loc2_];
               }
            }
            else if(this._syahItemVec[_loc2_].syahID == param1.TemplateID)
            {
               return this._syahItemVec[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getSyahModeByID(param1:int) : GodSyah.SyahMode
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._syahItemVec.length)
         {
            if(this._syahItemVec[_loc2_].syahID == param1)
            {
               return this._syahItemVec[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function get syahItemVec() : Vector.<GodSyah.SyahMode>
      {
         return this._syahItemVec;
      }
      
      public function get valid() : String
      {
         return this._valid;
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function set isOpen(param1:Boolean) : void
      {
         this._isOpen = param1;
      }
      
      public function get login() : Boolean
      {
         return this._login;
      }
      
      public function set login(param1:Boolean) : void
      {
         this._login = param1;
      }
      
      public function get isStart() : Boolean
      {
         return this._isStart;
      }
      
      public function get cellItems() : Vector.<InventoryItemInfo>
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<InventoryItemInfo> = new Vector.<InventoryItemInfo>();
         var _loc3_:int = 0;
         while(_loc3_ < this._cellItemsArray.length)
         {
            _loc1_ = 0;
            while(_loc1_ < this._cellItemsArray[_loc3_].length)
            {
               _loc2_.push(this._cellItemsArray[_loc3_][_loc1_]);
               _loc1_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function get inView() : Boolean
      {
         return this._inView;
      }
      
      public function set inView(param1:Boolean) : void
      {
         this._inView = param1;
      }
   }
}
