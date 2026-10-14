package GodSyah
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   
   public class SyahAnalyzer extends DataAnalyzer
   {
       
      
      private var _details:Array;
      
      private var _modes:Vector.<GodSyah.SyahMode>;
      
      private var _infos:Vector.<InventoryItemInfo>;
      
      private var _nowTime:Date;
      
      private var _syahArr:Array;
      
      private var _detailsArr:Array;
      
      private var _modeArr:Array;
      
      public function SyahAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:GodSyah.SyahMode = null;
         var _loc7_:InventoryItemInfo = null;
         var _loc8_:XML = new XML(param1);
         this._nowTime = this._getEndTime(_loc8_.@nowTime,_loc8_.@nowTime);
         if(_loc8_.@value == "true")
         {
            this._details = new Array();
            this._modes = new Vector.<SyahMode>();
            this._infos = new Vector.<InventoryItemInfo>();
            this._syahArr = new Array();
            this._detailsArr = new Array();
            this._modeArr = new Array();
            _loc2_ = _loc8_..Condition;
            _loc3_ = 0;
            while(_loc3_ < _loc8_.child("Active").length())
            {
               this._detailsArr[_loc3_] = new Vector.<InventoryItemInfo>();
               this._modeArr[_loc3_] = new Vector.<SyahMode>();
               _loc4_ = new Array();
               _loc4_[0] = _loc8_.child("Active")[_loc3_].@IsOpen;
               _loc4_[1] = this._createValid(_loc8_.child("Active")[_loc3_].@StartDate,_loc8_.child("Active")[_loc3_].@EndDate);
               _loc4_[2] = _loc8_.child("Active")[_loc3_].@ActiveInfo;
               _loc4_[3] = this._getEndTime(_loc8_.child("Active")[_loc3_].@StartDate,_loc8_.child("Active")[_loc3_].@StartTime);
               _loc4_[4] = this._getEndTime(_loc8_.child("Active")[_loc3_].@EndDate,_loc8_.child("Active")[_loc3_].@EndTime);
               _loc4_[5] = _loc8_.child("Active")[_loc3_].@SubID;
               this._syahArr[_loc3_] = _loc4_;
               _loc5_ = 0;
               while(_loc5_ < _loc2_.length())
               {
                  if(_loc8_.child("Active")[_loc3_].@SubID == _loc2_[_loc5_].@SubID)
                  {
                     _loc6_ = this._createModeValue(_loc2_[_loc5_].@Value);
                     _loc6_.syahID = _loc2_[_loc5_].@ConditionID;
                     _loc6_.level = _loc6_.isGold ? int(int(_loc2_[_loc5_].@Type - 100)) : int(int(_loc2_[_loc5_].@Type));
                     _loc6_.valid = this._createValid(_loc8_.child("Active")[_loc3_].@StartDate,_loc8_.child("Active")[_loc3_].@EndDate);
                     this._modeArr[_loc3_].push(_loc6_);
                     _loc7_ = new InventoryItemInfo();
                     _loc7_.TemplateID = _loc6_.syahID;
                     _loc7_ = ItemManager.fill(_loc7_);
                     _loc7_.StrengthenLevel = _loc6_.level;
                     _loc7_.isGold = _loc6_.isGold;
                     this._detailsArr[_loc3_].push(_loc7_);
                  }
                  _loc5_++;
               }
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc8_.@message;
            onAnalyzeComplete();
         }
      }
      
      private function _createModeValue(param1:String) : GodSyah.SyahMode
      {
         var _loc2_:Array = param1.split("-");
         var _loc3_:GodSyah.SyahMode = new GodSyah.SyahMode();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            switch(_loc2_[_loc4_])
            {
               case "1":
                  _loc3_.attack = _loc2_[_loc4_ + 1];
                  break;
               case "2":
                  _loc3_.defense = _loc2_[_loc4_ + 1];
                  break;
               case "3":
                  _loc3_.agility = _loc2_[_loc4_ + 1];
                  break;
               case "4":
                  _loc3_.lucky = _loc2_[_loc4_ + 1];
                  break;
               case "5":
                  _loc3_.hp = _loc2_[_loc4_ + 1];
                  break;
               case "6":
                  _loc3_.damage = _loc2_[_loc4_ + 1];
                  break;
               case "7":
                  _loc3_.armor = _loc2_[_loc4_ + 1];
                  break;
               case "11":
                  _loc3_.isGold = _loc2_[_loc4_ + 1] == 1 ? Boolean(Boolean(true)) : Boolean(Boolean(false));
                  break;
            }
            _loc4_ += 2;
         }
         return _loc3_;
      }
      
      private function _createValid(param1:String, param2:String) : String
      {
         return param1.split(" ")[0].replace("-",".").replace("-",".") + "-" + param2.split(" ")[0].replace("-",".").replace("-",".");
      }
      
      private function _getEndTime(param1:String, param2:String) : Date
      {
         var _loc3_:Array = param1.split(" ")[0].split("-");
         var _loc4_:String = _loc3_[1] + "/" + _loc3_[2] + "/" + _loc3_[0] + " " + param2.split(" ")[1];
         return new Date(_loc4_);
      }
      
      public function get modes() : Array
      {
         return this._modeArr;
      }
      
      public function get details() : Array
      {
         return this._syahArr;
      }
      
      public function get infos() : Array
      {
         return this._detailsArr;
      }
      
      public function get nowTime() : Date
      {
         return this._nowTime;
      }
   }
}
