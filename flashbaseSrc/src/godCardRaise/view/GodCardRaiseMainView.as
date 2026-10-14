package godCardRaise.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.HelpFrameUtils;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import godCardRaise.GodCardRaiseManager;
   import road7th.utils.DateUtils;
   import times.utils.timerManager.TimerJuggler;
   import times.utils.timerManager.TimerManager;
   
   public class GodCardRaiseMainView extends Frame
   {
       
      
      private var _selectGroup:SelectedButtonGroup;
      
      private var _divineBtn:SelectedButton;
      
      private var _exchangeBtn:SelectedButton;
      
      private var _atlasBtn:SelectedButton;
      
      private var _scoreBtn:SelectedButton;
      
      private var _time:FilterFrameText;
      
      private var _doubleTime:FilterFrameText;
      
      private var _timeLabel:FilterFrameText;
      
      private var _doubleTimeLabel:FilterFrameText;
      
      private var _divineView:godCardRaise.view.GodCardRaiseDivineView;
      
      private var _exchangeView:godCardRaise.view.GodCardRaiseExchangeView;
      
      private var _atlasView:godCardRaise.view.GodCardRaiseAtlasView;
      
      private var _scoreView:godCardRaise.view.GodCardRaiseScoreView;
      
      private var _timeFrame:int = 1;
      
      private var _timeRemainTimer:TimerJuggler;
      
      private var _btnHelp:BaseButton;
      
      public function GodCardRaiseMainView()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         titleText = LanguageMgr.GetTranslation("godCardRaise.title");
         escEnable = true;
         this.initView();
         this.addEvents();
      }
      
      private function initView() : void
      {
         this._btnHelp = HelpFrameUtils.Instance.simpleHelpButton(this,"core.helpButtonSmall",{
            "x":683,
            "y":5
         },LanguageMgr.GetTranslation("store.view.HelpButtonText"),"asset.godCardRaise.view.help",408,488);
         this._divineBtn = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseMainView.divineBtn");
         addToContent(this._divineBtn);
         this._exchangeBtn = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseMainView.exchangeBtn");
         addToContent(this._exchangeBtn);
         this._atlasBtn = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseMainView.atlasBtn");
         addToContent(this._atlasBtn);
         this._scoreBtn = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseMainView.scoreBtn");
         addToContent(this._scoreBtn);
         this._selectGroup = new SelectedButtonGroup();
         this._selectGroup.addSelectItem(this._divineBtn);
         this._selectGroup.addSelectItem(this._exchangeBtn);
         this._selectGroup.addSelectItem(this._atlasBtn);
         this._selectGroup.addSelectItem(this._scoreBtn);
         this._time = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseMainView.time");
         this._time.text = LanguageMgr.GetTranslation("godCardRaise.mainView.time1");
         addToContent(this._time);
         this._timeLabel = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseMainView.timeLabel");
         this._timeLabel.text = this.getCurrentTimeStr();
         addToContent(this._timeLabel);
         this._doubleTime = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseMainView.doubelTime");
         this._doubleTime.text = LanguageMgr.GetTranslation("godCardRaise.mainView.doubleTime");
         addToContent(this._doubleTime);
         this._doubleTimeLabel = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseMainView.doubleTimeLabel");
         this._doubleTimeLabel.text = this.getCurrentTimeStr();
         addToContent(this._doubleTimeLabel);
         this._timeRemainTimer = TimerManager.getInstance().addTimerJuggler(10000);
         this._timeRemainTimer.addEventListener("timer",this.__timeRemainHandler);
         this._timeRemainTimer.start();
         if(!this.checkIsEndActity())
         {
            this._selectGroup.selectIndex = 0;
         }
         this.showView();
      }
      
      private function __timeRemainHandler(param1:Event) : void
      {
         if(Boolean(this._timeLabel))
         {
            this._timeLabel.text = this.getCurrentTimeStr();
         }
         if(Boolean(this._doubleTimeLabel))
         {
            this._doubleTimeLabel.text = this.getCurrentDoubleTimeStr();
         }
         if(Boolean(this._scoreView))
         {
            this._scoreView.updateTime();
         }
         if(this.isEndActity() && this._divineBtn.enable)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("godCardRaiseMainView.endActityMsg"));
         }
         this.checkIsEndActity();
      }
      
      private function getCurrentDoubleTimeStr() : String
      {
         var _loc1_:Number = GodCardRaiseManager.Instance.doubleTime;
         if(_loc1_ <= 0)
         {
            return "";
         }
         return int(_loc1_ / 60) + 1 + LanguageMgr.GetTranslation("minute2");
      }
      
      private function getCurrentTimeStr() : String
      {
         var _loc1_:Number = NaN;
         if(this._timeFrame == 1)
         {
            _loc1_ = (GodCardRaiseManager.Instance.dataEnd.time - TimeManager.Instance.Now().time) / 1000;
         }
         else
         {
            _loc1_ = (GodCardRaiseManager.Instance.dataEnd.time - TimeManager.Instance.Now().time) / 1000 + 86400;
         }
         var _loc2_:Array = DateUtils.dateTimeRemainArr(_loc1_);
         return LanguageMgr.GetTranslation("tank.timeRemain.msg1",_loc2_[0],_loc2_[1],_loc2_[2]);
      }
      
      private function checkIsEndActity() : Boolean
      {
         if(this.isEndActity())
         {
            this._divineBtn.enable = false;
            if(this._selectGroup.selectIndex <= 0)
            {
               this._selectGroup.selectIndex = 1;
            }
            return true;
         }
         this._divineBtn.enable = true;
         return false;
      }
      
      private function isEndActity() : Boolean
      {
         var _loc1_:Number = GodCardRaiseManager.Instance.dataEnd.time - TimeManager.Instance.Now().time;
         return _loc1_ <= 0;
      }
      
      private function onSelectGroupChange(param1:Event) : void
      {
         SoundManager.instance.play("008");
         if(Boolean(this._divineView))
         {
            this._divineView.visible = false;
         }
         if(Boolean(this._exchangeView))
         {
            this._exchangeView.visible = false;
         }
         if(Boolean(this._atlasView))
         {
            this._atlasView.visible = false;
         }
         if(Boolean(this._scoreView))
         {
            this._scoreView.visible = false;
         }
         this.showView();
      }
      
      private function showView() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = undefined;
         _loc1_ = true;
         this._timeLabel.visible = _loc1_;
         this._time.visible = _loc1_;
         if(GodCardRaiseManager.Instance.doubleTime <= 0)
         {
            _loc1_ = false;
            this._doubleTimeLabel.visible = _loc1_;
            this._doubleTime.visible = _loc1_;
         }
         else
         {
            _loc1_ = true;
            this._doubleTimeLabel.visible = _loc1_;
            this._doubleTime.visible = _loc1_;
         }
         this._timeFrame = 1;
         if(this._selectGroup.selectIndex == 1)
         {
            this._timeFrame = 2;
            if(Boolean(this._exchangeView))
            {
               this._exchangeView.visible = true;
            }
            else
            {
               this._exchangeView = new godCardRaise.view.GodCardRaiseExchangeView();
               PositionUtils.setPos(this._exchangeView,"godCardRaiseMainView.godCardRaiseExchangeViewPos");
               addToContent(this._exchangeView);
            }
         }
         else if(this._selectGroup.selectIndex == 2)
         {
            this._timeFrame = 2;
            if(Boolean(this._atlasView))
            {
               this._atlasView.visible = true;
            }
            else
            {
               this._atlasView = new godCardRaise.view.GodCardRaiseAtlasView();
               PositionUtils.setPos(this._atlasView,"godCardRaiseMainView.godCardRaiseAtlasViewPos");
               addToContent(this._atlasView);
            }
         }
         else if(this._selectGroup.selectIndex == 3)
         {
            if(Boolean(this._scoreView))
            {
               this._scoreView.visible = true;
            }
            else
            {
               this._scoreView = new godCardRaise.view.GodCardRaiseScoreView();
               PositionUtils.setPos(this._scoreView,"godCardRaiseMainView.godCardRaiseScoreViewPos");
               addToContent(this._scoreView);
            }
            _loc1_ = false;
            this._timeLabel.visible = _loc1_;
            this._time.visible = _loc1_;
            _loc1_ = false;
            this._doubleTimeLabel.visible = _loc1_;
            this._doubleTime.visible = _loc1_;
         }
         else if(Boolean(this._divineView))
         {
            this._divineView.visible = true;
         }
         else
         {
            this._divineView = new godCardRaise.view.GodCardRaiseDivineView();
            this._divineView.addEventListener("openCardLockChange",this.__openCardLockChangeHandler);
            PositionUtils.setPos(this._divineView,"godCardRaiseMainView.godCardRaiseDivineViewPos");
            addToContent(this._divineView);
         }
         if(this._timeFrame == 1)
         {
            this._time.text = LanguageMgr.GetTranslation("godCardRaise.mainView.time2");
            _loc1_ = false;
            this._doubleTimeLabel.visible = _loc1_;
            this._doubleTime.visible = _loc1_;
            _loc1_ = 56;
            this._timeLabel.y = _loc1_;
            this._time.y = _loc1_;
         }
         else
         {
            this._time.text = LanguageMgr.GetTranslation("godCardRaise.mainView.time1");
            if(this._doubleTime.visible)
            {
               _loc1_ = 46;
               this._timeLabel.y = _loc1_;
               this._time.y = _loc1_;
            }
            else
            {
               _loc1_ = 56;
               this._timeLabel.y = _loc1_;
               this._time.y = _loc1_;
            }
         }
         if(Boolean(this._timeLabel))
         {
            this._timeLabel.text = this.getCurrentTimeStr();
         }
         if(Boolean(this._doubleTimeLabel))
         {
            this._doubleTimeLabel.text = this.getCurrentDoubleTimeStr();
         }
      }
      
      private function addEvents() : void
      {
         this._selectGroup.addEventListener("change",this.onSelectGroupChange);
         GodCardRaiseManager.Instance.addEventListener("openCard",this.__openCardUpdateHandler);
         GodCardRaiseManager.Instance.addEventListener("awardInfo",this.__awardInfoUpdateHandler);
         GodCardRaiseManager.Instance.addEventListener("operateCard",this.__operateCardUpdateHandler);
         GodCardRaiseManager.Instance.addEventListener("exchange",this.__exchangeUpdateHandler);
         addEventListener("response",this.__responseHandler);
      }
      
      private function __openCardUpdateHandler(param1:CEvent) : void
      {
         var _loc2_:Array = param1.data as Array;
         if(Boolean(this._divineView))
         {
            this._divineView.playCardMovie(_loc2_);
            this._divineView.updateView();
         }
         if(Boolean(this._atlasView))
         {
            this._atlasView.updateView();
         }
         if(Boolean(this._exchangeView))
         {
            this._exchangeView.updateView();
         }
         if(Boolean(this._scoreView))
         {
            this._scoreView.updateView();
         }
      }
      
      private function __openCardLockChangeHandler(param1:Event) : void
      {
         if(Boolean(this._divineView))
         {
            this.escEnable = !this._divineView.openCardLock;
            this.closeButton.enable = !this._divineView.openCardLock;
         }
      }
      
      private function __awardInfoUpdateHandler(param1:CEvent) : void
      {
         if(Boolean(this._scoreView))
         {
            this._scoreView.updateView();
         }
      }
      
      private function __operateCardUpdateHandler(param1:CEvent) : void
      {
         if(Boolean(this._atlasView))
         {
            this._atlasView.updateView();
         }
         if(Boolean(this._exchangeView))
         {
            this._exchangeView.updateView();
         }
      }
      
      private function __exchangeUpdateHandler(param1:CEvent) : void
      {
         if(Boolean(this._exchangeView))
         {
            this._exchangeView.updateView();
         }
         if(Boolean(this._atlasView))
         {
            this._atlasView.updateView();
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.dispose();
      }
      
      private function removeEvents() : void
      {
         this._selectGroup.removeEventListener("change",this.onSelectGroupChange);
         GodCardRaiseManager.Instance.removeEventListener("openCard",this.__openCardUpdateHandler);
         GodCardRaiseManager.Instance.removeEventListener("awardInfo",this.__awardInfoUpdateHandler);
         GodCardRaiseManager.Instance.removeEventListener("operateCard",this.__operateCardUpdateHandler);
         GodCardRaiseManager.Instance.removeEventListener("exchange",this.__exchangeUpdateHandler);
         if(Boolean(this._divineView))
         {
            this._divineView.removeEventListener("openCardLockChange",this.__openCardLockChangeHandler);
         }
         removeEventListener("response",this.__responseHandler);
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._timeRemainTimer))
         {
            this._timeRemainTimer.stop();
            this._timeRemainTimer.removeEventListener("timer",this.__timeRemainHandler);
            TimerManager.getInstance().removeJugglerByTimer(this._timeRemainTimer);
            this._timeRemainTimer = null;
         }
         this.removeEvents();
         ObjectUtils.disposeAllChildren(this);
         this._divineBtn = null;
         this._exchangeBtn = null;
         this._atlasBtn = null;
         this._scoreBtn = null;
         this._time = null;
         this._timeLabel = null;
         this._divineView = null;
         this._doubleTimeLabel = null;
         this._exchangeView = null;
         this._atlasView = null;
         this._scoreView = null;
         this._btnHelp = null;
         super.dispose();
      }
   }
}
