package cryptBoss
{
   import cryptBoss.data.CryptBossItemInfo;
   import cryptBoss.event.CryptBossEvent;
   import ddt.CoreManager;
   import ddt.events.PkgEvent;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import flash.utils.Dictionary;
   import hallIcon.HallIconManager;
   import road7th.comm.PackageIn;
   
   public class CryptBossManager extends CoreManager
   {
      
      private static var _instance:cryptBoss.CryptBossManager;
      
      public static var loadComplete:Boolean = false;
       
      
      public var RoomType:int = 0;
      
      public var openWeekDaysDic:Dictionary;
      
      public function CryptBossManager()
      {
         super();
      }
      
      public static function get instance() : cryptBoss.CryptBossManager
      {
         if(!_instance)
         {
            _instance = new cryptBoss.CryptBossManager();
         }
         return _instance;
      }
      
      public function setUp() : void
      {
         this.openWeekDaysDic = new Dictionary();
         SocketManager.Instance.addEventListener(PkgEvent.format(275),this.pkgHandler);
      }
      
      protected function pkgHandler(param1:PkgEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         switch(int(_loc3_) - 1)
         {
            case 0:
               this.initAllData(_loc2_);
               break;
            case 1:
               this.updateSingleData(_loc2_);
         }
      }
      
      private function updateSingleData(param1:PackageIn) : void
      {
         var _loc5_:CryptBossItemInfo = null;
         var _loc2_:int = param1.readInt();
         var _loc3_:int = param1.readInt();
         var _loc4_:int = param1.readInt();
         (_loc5_ = this.openWeekDaysDic[_loc2_]).id = _loc2_;
         _loc5_.star = _loc3_;
         _loc5_.state = _loc4_;
         dispatchEvent(new CryptBossEvent("cryptBossUpdateView"));
      }
      
      private function initAllData(param1:PackageIn) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:int = 0;
         var _loc8_:int = param1.readInt();
         if(_loc8_ == 0)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc8_)
         {
            (_loc3_ = new CryptBossItemInfo()).id = param1.readInt();
            _loc3_.star = param1.readInt();
            _loc3_.state = param1.readInt();
            this.openWeekDaysDic[_loc3_.id] = _loc3_;
            _loc2_++;
         }
         var _loc9_:Array = ServerConfigManager.instance.cryptBossOpenDay;
         _loc4_ = 0;
         while(_loc4_ < _loc9_.length)
         {
            _loc5_ = _loc9_[_loc4_].split(",");
            _loc6_ = [];
            _loc7_ = 1;
            while(_loc7_ < _loc5_.length)
            {
               _loc6_.push(_loc5_[_loc7_]);
               _loc7_++;
            }
            (this.openWeekDaysDic[_loc5_[0]] as CryptBossItemInfo).openWeekDaysArr = _loc6_;
            _loc4_++;
         }
         dispatchEvent(new CryptBossEvent("cryptBossUpdateView"));
      }
      
      override protected function start() : void
      {
         dispatchEvent(new CryptBossEvent("cryptBossOpenView"));
      }
      
      public function showIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler("cryptBoss",true);
      }
   }
}
