package conRecharge.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import conRecharge.ConRechargeManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.view.bossbox.TimeCountDown;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import road7th.utils.DateUtils;
   import wonderfulActivity.WonderfulActivityManager;
   
   public class ConRechargeFrame extends Frame
   {
       
      
      private var _topBg:Bitmap;
      
      private var _rightBg:Bitmap;
      
      private var _leftBg:Bitmap;
      
      private var _activityTime:FilterFrameText;
      
      private var _totalRechargeTxt:FilterFrameText;
      
      private var _rechargeBtn:BaseButton;
      
      private var _leftView:conRecharge.view.ConRechargeLeftItem;
      
      private var _rightView:conRecharge.view.ConRechargeRightItem;
      
      private var _time:TimeCountDown;
      
      public function ConRechargeFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = null;
         this._time = new TimeCountDown(1000);
         this._topBg = ComponentFactory.Instance.creatBitmap("asset.conRecharge.topBg");
         addToContent(this._topBg);
         this._leftBg = ComponentFactory.Instance.creatBitmap("asset.conRecharge.leftBg");
         addToContent(this._leftBg);
         this._rightBg = ComponentFactory.Instance.creatBitmap("asset.conRecharge.rightBg");
         addToContent(this._rightBg);
         this._leftView = new conRecharge.view.ConRechargeLeftItem();
         addToContent(this._leftView);
         PositionUtils.setPos(this._leftView,"conRecharge.leftView.pos");
         this._rightView = new conRecharge.view.ConRechargeRightItem();
         addToContent(this._rightView);
         PositionUtils.setPos(this._rightView,"conRecharge.rightView.pos");
         this._activityTime = ComponentFactory.Instance.creatComponentByStylename("conRecharge.activityTime.txt");
         addToContent(this._activityTime);
         var _loc7_:Array = WonderfulActivityManager.Instance.getActivityInitDataById(ConRechargeManager.instance.actId).statusArr;
         _loc2_ = 0;
         while(_loc2_ < _loc7_.length)
         {
            if(_loc7_[_loc2_].statusID == 0)
            {
               _loc1_ = int(_loc7_[_loc2_].statusValue);
               break;
            }
            _loc2_++;
         }
         this._totalRechargeTxt = ComponentFactory.Instance.creatComponentByStylename("conRecharge.totalRecharge.txt");
         addToContent(this._totalRechargeTxt);
         this._totalRechargeTxt.text = LanguageMgr.GetTranslation("ddt.conRecharge.totalRecharge",_loc1_);
         this._rechargeBtn = ComponentFactory.Instance.creatComponentByStylename("conRecharge.rechargeBtn");
         addToContent(this._rechargeBtn);
         var _loc8_:String = LanguageMgr.GetTranslation("ddt.conRecharge.chargeTip");
         var _loc9_:Array = WonderfulActivityManager.Instance.getActivityInitDataById(ConRechargeManager.instance.actId).statusArr;
         _loc3_ = 0;
         while(_loc3_ < _loc9_.length)
         {
            _loc4_ = _loc9_[_loc3_];
            if(_loc4_.statusID != 0)
            {
               _loc5_ = String(_loc4_.statusID);
               _loc6_ = _loc5_.substr(0,4) + "/" + _loc5_.substr(4,2) + "/" + _loc5_.substr(6,2);
               _loc8_ += "\n" + LanguageMgr.GetTranslation("ddt.conRecharge.moneyTxt",_loc6_ + "--" + String(_loc4_.statusValue));
            }
            _loc3_++;
         }
         this._rechargeBtn.tipData = _loc8_;
      }
      
      private function addEvent() : void
      {
         addEventListener("response",this._responseHandle);
         this._time.addEventListener("TIME_countdown_complete",this._timeOver);
         this._time.addEventListener("countdown_one",this._timeOne);
         var _loc1_:int = DateUtils.getHourDifference(DateUtils.getDateByStr(ConRechargeManager.instance.beginTime).valueOf(),DateUtils.getDateByStr(ConRechargeManager.instance.endTime).valueOf());
         this._time.setTimeOnMinute(_loc1_ * 60);
         this._rechargeBtn.addEventListener("click",this.__onSupplyClick);
      }
      
      private function __onSupplyClick(param1:MouseEvent) : void
      {
         LeavePageManager.leaveToFillPath();
      }
      
      private function _timeOver(param1:Event) : void
      {
      }
      
      private function _timeOne(param1:Event) : void
      {
         var _loc2_:Date = DateUtils.getDateByStr(ConRechargeManager.instance.endTime);
         var _loc3_:String = TimeManager.Instance.getMaxRemainDateStr(_loc2_);
         this._activityTime.text = LanguageMgr.GetTranslation("ddt.conRecharge.activityTime",_loc3_);
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this._responseHandle);
         this._time.removeEventListener("TIME_countdown_complete",this._timeOver);
         this._time.removeEventListener("countdown_one",this._timeOne);
         this._time.dispose();
         this._rechargeBtn.removeEventListener("click",this.__onSupplyClick);
      }
      
      protected function _responseHandle(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(int(param1.responseCode))
         {
            case 0:
            case 1:
               this.dispose();
               break;
            case 4:
               break;
            default:
               this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         SocketManager.Instance.out.requestWonderfulActInit(2);
         this.removeEvent();
         super.dispose();
         ObjectUtils.disposeObject(this._topBg);
         this._topBg = null;
         ObjectUtils.disposeObject(this._leftBg);
         this._leftBg = null;
         ObjectUtils.disposeObject(this._rightBg);
         this._rightBg = null;
         ObjectUtils.disposeObject(this._activityTime);
         this._activityTime = null;
         ObjectUtils.disposeObject(this._totalRechargeTxt);
         this._totalRechargeTxt = null;
         ObjectUtils.disposeObject(this._rechargeBtn);
         this._rechargeBtn = null;
         ObjectUtils.disposeObject(this._leftView);
         this._leftView = null;
         ObjectUtils.disposeObject(this._rightView);
         this._rightView = null;
      }
   }
}
