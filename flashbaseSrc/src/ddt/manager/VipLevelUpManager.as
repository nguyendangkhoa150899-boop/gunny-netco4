package ddt.manager
{
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.action.FrameShowAction;
   import ddt.constants.CacheConsts;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.view.bossbox.VipLevelUpAwardsView;
   import flash.events.EventDispatcher;
   import road7th.comm.PackageIn;
   
   public class VipLevelUpManager extends EventDispatcher
   {
      
      private static var _instance:ddt.manager.VipLevelUpManager;
       
      
      private var awardsFrame:VipLevelUpAwardsView;
      
      public function VipLevelUpManager()
      {
         super();
      }
      
      public static function get instance() : ddt.manager.VipLevelUpManager
      {
         if(_instance == null)
         {
            _instance = new ddt.manager.VipLevelUpManager();
         }
         return _instance;
      }
      
      public function initVIPLevelUpEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.VIP_LEVELUP,this.__vipLevelUp);
      }
      
      private function __vipLevelUp(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:String = _loc3_.readUTF();
         var _loc5_:int = int(_loc3_.readByte());
         var _loc6_:Array = [];
         while(Boolean(_loc3_.bytesAvailable))
         {
            _loc2_ = new InventoryItemInfo();
            _loc2_.TemplateID = _loc3_.readInt();
            _loc2_ = ItemManager.fill(_loc2_);
            _loc2_.Count = _loc3_.readInt();
            _loc2_.IsBinds = _loc3_.readBoolean();
            _loc2_.ValidDate = _loc3_.readInt();
            _loc2_.StrengthenLevel = _loc3_.readInt();
            _loc2_.AttackCompose = _loc3_.readInt();
            _loc2_.DefendCompose = _loc3_.readInt();
            _loc2_.AgilityCompose = _loc3_.readInt();
            _loc2_.LuckCompose = _loc3_.readInt();
            _loc6_.push(_loc2_);
         }
         this.awardsFrame = ComponentFactory.Instance.creat("vip.vipLevelUpawardFrame");
         this.awardsFrame.vipLevelUpGoodsList = _loc6_;
         if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
         {
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,new FrameShowAction(this.awardsFrame));
         }
         else
         {
            this.awardsFrame.show();
         }
      }
   }
}
