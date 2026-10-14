package AvatarCollection.view
{
   import AvatarCollection.AvatarCollectionManager;
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import times.utils.timerManager.TimerJuggler;
   import times.utils.timerManager.TimerManager;
   
   public class AvatarCollectionTimeView extends Sprite implements Disposeable
   {
       
      
      private var _txt:FilterFrameText;
      
      private var _btnDelayTime:SimpleBitmapButton;
      
      private var _btnSelectAll:SimpleBitmapButton;
      
      private var _btnUnSelectAll:SimpleBitmapButton;
      
      private var _timer:TimerJuggler;
      
      private var _data:AvatarCollectionUnitVo;
      
      private var _needHonor:int;
      
      public function AvatarCollectionTimeView()
      {
         super();
         this.x = 202;
         this.y = 391;
         this.initView();
         this.initEvent();
         this.initTimer();
         this.setDefaultView();
      }
      
      private function initView() : void
      {
         this._txt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.timeView.txt");
         this._btnSelectAll = ComponentFactory.Instance.creatComponentByStylename("avatarColl.selectAll.btn");
         this._btnUnSelectAll = ComponentFactory.Instance.creatComponentByStylename("avatarColl.unSelectAll.btn");
         this._btnUnSelectAll.visible = false;
         this._btnDelayTime = ComponentFactory.Instance.creatComponentByStylename("avatarColl.timeView.btn");
         addChild(this._txt);
         addChild(this._btnSelectAll);
         addChild(this._btnUnSelectAll);
         addChild(this._btnDelayTime);
      }
      
      private function initEvent() : void
      {
         this._btnDelayTime.addEventListener("click",this.delayTimeClickHandler,false,0,true);
         this._btnSelectAll.addEventListener("click",this.selectAllClickHandler);
         this._btnUnSelectAll.addEventListener("click",this.unSelectAllClickHandler);
         AvatarCollectionManager.instance.addEventListener("avatar_collection_select_all",this.onSetSelectedAll);
      }
      
      protected function onSetSelectedAll(param1:CEvent) : void
      {
         var _loc2_:Boolean = Boolean(param1.data);
         this._btnSelectAll.visible = !_loc2_;
         this._btnUnSelectAll.visible = _loc2_;
      }
      
      protected function unSelectAllClickHandler(param1:MouseEvent) : void
      {
         this.onSelectChange();
      }
      
      protected function selectAllClickHandler(param1:MouseEvent) : void
      {
         this.onSelectChange();
      }
      
      public function onSelectChange() : void
      {
         SoundManager.instance.play("008");
         this._btnSelectAll.visible = !this._btnSelectAll.visible;
         this._btnUnSelectAll.visible = !this._btnUnSelectAll.visible;
         AvatarCollectionManager.instance.selectAllClicked();
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._btnSelectAll.visible = !param1;
         this._btnUnSelectAll.visible = param1;
      }
      
      private function delayTimeClickHandler(param1:MouseEvent) : void
      {
         var _loc4_:AvatarCollectionDelayConfirmFrame = null;
         var _loc2_:* = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._needHonor = AvatarCollectionManager.instance.honourNeedTotalPerDay();
         if(this._needHonor == 0)
         {
            _loc2_ = LanguageMgr.GetTranslation("avatarCollection.selectOne");
            MessageTipManager.getInstance().show(_loc2_,0,false,1);
            return;
         }
         var _loc3_:int = PlayerManager.Instance.Self.myHonor / this._needHonor;
         (_loc4_ = ComponentFactory.Instance.creatComponentByStylename("avatarColl.delayConfirmFrame")).show(this._needHonor,_loc3_);
         _loc4_.addEventListener("response",this.__onConfirmResponse);
         LayerManager.Instance.addToLayer(_loc4_,3,true,1);
      }
      
      protected function __onConfirmResponse(param1:FrameEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.play("008");
         var _loc3_:AvatarCollectionDelayConfirmFrame = param1.currentTarget as AvatarCollectionDelayConfirmFrame;
         _loc3_.removeEventListener("response",this.__onConfirmResponse);
         if(param1.responseCode == 2 || param1.responseCode == 3)
         {
            _loc2_ = _loc3_.selectValue;
            if(PlayerManager.Instance.Self.myHonor < this._needHonor * _loc2_)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("avatarCollection.delayConfirmFrame.noEnoughHonor"));
            }
            else
            {
               AvatarCollectionManager.instance.delayTheTimeConfirmed(_loc2_);
            }
         }
         _loc3_.dispose();
      }
      
      private function initTimer() : void
      {
         this._timer = TimerManager.getInstance().addTimerJuggler(1000);
         this._timer.addEventListener("timer",this.timerHandler,false,0,true);
      }
      
      private function timerHandler(param1:Event) : void
      {
         this.refreshTimePlayTxt();
      }
      
      public function refreshView(param1:AvatarCollectionUnitVo) : void
      {
         this._data = param1;
         if(!this._data)
         {
            this.setDefaultView();
            this._timer.stop();
            return;
         }
         var _loc2_:int = int(this._data.totalItemList.length);
         var _loc3_:int = this._data.totalActivityItemCount;
         if(_loc3_ < _loc2_ / 2)
         {
            this.setDefaultView();
            this._timer.stop();
            return;
         }
         this._btnDelayTime.enable = true;
         this._btnSelectAll.enable = true;
         this.refreshTimePlayTxt();
         this._timer.start();
      }
      
      private function refreshTimePlayTxt() : void
      {
         var _loc1_:* = null;
         var _loc2_:Number = this._data.endTime.getTime();
         var _loc3_:Number = TimeManager.Instance.Now().getTime();
         var _loc4_:Number = _loc2_ - _loc3_;
         _loc4_ = _loc4_ < 0 ? 0 : Number(_loc4_);
         var _loc5_:int = 0;
         if(_loc4_ / 86400000 > 1)
         {
            _loc5_ = _loc4_ / 86400000;
            _loc1_ = _loc5_ + LanguageMgr.GetTranslation("day");
         }
         else if(_loc4_ / 3600000 > 1)
         {
            _loc5_ = _loc4_ / 3600000;
            _loc1_ = _loc5_ + LanguageMgr.GetTranslation("hour");
         }
         else if(_loc4_ / 60000 > 1)
         {
            _loc5_ = _loc4_ / 60000;
            _loc1_ = _loc5_ + LanguageMgr.GetTranslation("minute");
         }
         else
         {
            _loc5_ = _loc4_ / 1000;
            _loc1_ = _loc5_ + LanguageMgr.GetTranslation("second");
         }
         this._txt.text = LanguageMgr.GetTranslation("avatarCollection.timeView.txt") + _loc1_;
      }
      
      private function setDefaultView() : void
      {
         this._txt.text = LanguageMgr.GetTranslation("avatarCollection.timeView.txt") + 0 + LanguageMgr.GetTranslation("day");
      }
      
      private function removeEvent() : void
      {
         this._btnDelayTime.removeEventListener("click",this.delayTimeClickHandler);
         this._btnSelectAll.removeEventListener("click",this.selectAllClickHandler);
         this._btnUnSelectAll.removeEventListener("click",this.unSelectAllClickHandler);
         AvatarCollectionManager.instance.removeEventListener("avatar_collection_select_all",this.onSetSelectedAll);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener("timer",this.timerHandler);
            TimerManager.getInstance().removeTimerJuggler(this._timer.id);
         }
         ObjectUtils.disposeAllChildren(this);
         this._txt = null;
         this._btnDelayTime = null;
         this._timer = null;
         this._data = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
