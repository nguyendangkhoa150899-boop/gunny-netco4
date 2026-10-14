package ddt.utils
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.alert.SimpleAlertWithNotShowAgain;
   import ddt.events.CEvent;
   import flash.events.EventDispatcher;
   
   public class ConfirmAlertHelper extends EventDispatcher
   {
      
      public static const CHECK_OUT:String = "check_out";
      
      public static const CONFIRM_TO_PAY:String = "confirm_to_pay";
      
      public static const CANCEL:String = "cancel";
       
      
      private var _frame:BaseAlerFrame;
      
      private var _frameStyle:String;
      
      public var onConfirm:Function;
      
      public var onCheckOut:Function;
      
      public var onCancel:Function;
      
      private var _data:ddt.utils.ConfirmAlertData;
      
      public function ConfirmAlertHelper(param1:ddt.utils.ConfirmAlertData)
      {
         super();
         this._data = param1;
      }
      
      public function get frame() : BaseAlerFrame
      {
         return this._frame;
      }
      
      public function alertQuick(param1:String, param2:String = "SimpleAlert") : void
      {
         this.alert("Cảnh cáo：",param1,"O K","Hủy",true,false,false,2,null,param2,30,true,0);
      }
      
      public function alert(param1:String, param2:String, param3:String = "", param4:String = "", param5:Boolean = false, param6:Boolean = false, param7:Boolean = false, param8:int = 2, param9:String = null, param10:String = "SimpleAlert", param11:int = 30, param12:Boolean = true, param13:int = 0, param14:int = 0) : void
      {
         this._frameStyle = param10;
         if(this._data.notShowAlertAgain == true)
         {
            CheckMoneyUtils.instance.checkMoney(this._data.isBind,this._data.moneyNeeded,this.onCheckComplete,this.onCheckCancel);
            return;
         }
         this._frame = AlertManager.Instance.simpleAlert(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13,param14);
         this._frame.addEventListener("response",this.confirmResponse);
      }
      
      protected function confirmResponse(param1:FrameEvent) : void
      {
         this._frame.removeEventListener("response",this.confirmResponse);
         if(this._frame is SimpleAlertWithNotShowAgain)
         {
            this._data.notShowAlertAgain = (this._frame as SimpleAlertWithNotShowAgain).isNoPrompt;
         }
         this._data.isBind = this._frame.isBand;
         if(param1.responseCode == 2 || param1.responseCode == 3)
         {
            this.onConfirm && this.onConfirm(this._frame);
            this.onConfirm = null;
            dispatchEvent(new CEvent("confirm_to_pay"));
            CheckMoneyUtils.instance.checkMoney(this._data.isBind,this._data.moneyNeeded,this.onCheckComplete,this.onCheckCancel);
         }
         else if(param1.responseCode == 4 || param1.responseCode == 0 || param1.responseCode == 1)
         {
            this.onCheckCancel();
         }
         this._frame.dispose();
      }
      
      private function onCheckCancel() : void
      {
         this.onCancel && this.onCancel();
         this.onCancel = null;
         dispatchEvent(new CEvent("cancel"));
      }
      
      protected function onCheckComplete() : void
      {
         this._data.isBind = CheckMoneyUtils.instance.isBind;
         this.onCheckOut && this.onCheckOut();
         this.onCheckOut = null;
         dispatchEvent(new CEvent("check_out"));
      }
   }
}
