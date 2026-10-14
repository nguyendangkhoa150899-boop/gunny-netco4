package ddt.utils
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.EventDispatcher;
   
   public class CheckMoneyUtils extends EventDispatcher
   {
      
      private static var _instance:ddt.utils.CheckMoneyUtils;
       
      
      private var _isBind:Boolean;
      
      private var _needMoney:int;
      
      private var _completeFun:Function;
      
      private var _cancelFun:Function;
      
      public function CheckMoneyUtils()
      {
         super();
      }
      
      public static function get instance() : ddt.utils.CheckMoneyUtils
      {
         if(!_instance)
         {
            _instance = new ddt.utils.CheckMoneyUtils();
         }
         return _instance;
      }
      
      public function checkMoney(param1:Boolean, param2:int, param3:Function, param4:Function = null, param5:Boolean = true) : void
      {
         var _loc6_:* = null;
         this._isBind = param1;
         this._needMoney = param2;
         this._completeFun = param3;
         this._cancelFun = param4;
         if(this._isBind && PlayerManager.Instance.Self.Gift < this._needMoney)
         {
            if(param5)
            {
               (_loc6_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("sevenDouble.game.useSkillNoEnoughReConfirm"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,1)).moveEnable = false;
               _loc6_.addEventListener("response",this.reConfirmHandler,false,0,true);
               return;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("bindMoneyPoorNote"));
            this.cancel();
            return;
         }
         if(!this._isBind && PlayerManager.Instance.Self.Money < this._needMoney)
         {
            LeavePageManager.showFillFrame();
            this.cancel();
            return;
         }
         this.complete();
      }
      
      protected function reConfirmHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener("response",this.reConfirmHandler);
         if(param1.responseCode == 3 || param1.responseCode == 2)
         {
            if(PlayerManager.Instance.Self.Money < this._needMoney)
            {
               LeavePageManager.showFillFrame();
               this.cancel();
               return;
            }
            this._isBind = false;
            this.complete();
            return;
         }
         this.cancel();
      }
      
      private function complete() : void
      {
         this._completeFun();
      }
      
      private function cancel() : void
      {
         if(this._cancelFun != null)
         {
            this._cancelFun();
         }
      }
      
      public function get isBind() : Boolean
      {
         return this._isBind;
      }
   }
}
