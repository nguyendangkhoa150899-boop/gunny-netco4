package pyramid
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.NumberSelecter;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import pyramid.event.PyramidEvent;
   import pyramid.model.PyramidModel;
   import road7th.comm.PackageIn;
   
   public class PyramidManager extends EventDispatcher
   {
      
      private static var _instance:pyramid.PyramidManager;
       
      
      private var _isShowIcon:Boolean = false;
      
      private var _model:PyramidModel;
      
      private var _movieLock:Boolean = false;
      
      private var _clickRate:Number = 0;
      
      public var isShowBuyFrameSelectedCheck:Boolean = true;
      
      public var isShowReviveBuyFrameSelectedCheck:Boolean = true;
      
      public var isShowAutoOpenFrameSelectedCheck:Boolean = true;
      
      private var _isAutoOpenCard:Boolean = false;
      
      private var _tipsframe:BaseAlerFrame;
      
      private var _selectedCheckButton:SelectedCheckButton;
      
      private var _tipsType:int;
      
      private var _tipsData:Object;
      
      public var autoCount:int;
      
      private var _numberSelecter:NumberSelecter;
      
      private var _text:FilterFrameText;
      
      public function PyramidManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : pyramid.PyramidManager
      {
         if(_instance == null)
         {
            _instance = new pyramid.PyramidManager();
         }
         return _instance;
      }
      
      public function set movieLock(param1:Boolean) : void
      {
         this._movieLock = param1;
         dispatchEvent(new PyramidEvent(PyramidEvent.MOVIE_LOCK));
      }
      
      public function get movieLock() : Boolean
      {
         return this._movieLock;
      }
      
      public function get isAutoOpenCard() : Boolean
      {
         return this._isAutoOpenCard;
      }
      
      public function set isAutoOpenCard(param1:Boolean) : void
      {
         if(this._isAutoOpenCard != param1)
         {
            this._isAutoOpenCard = param1;
            dispatchEvent(new PyramidEvent(PyramidEvent.AUTO_OPENCARD));
            if(this._isAutoOpenCard)
            {
               this.isShowReviveBuyFrameSelectedCheck = false;
            }
            else
            {
               this.isShowReviveBuyFrameSelectedCheck = true;
            }
         }
      }
      
      public function get clickRateGo() : Boolean
      {
         var _loc1_:Number = new Date().time;
         if(_loc1_ - this._clickRate > 500)
         {
            this._clickRate = _loc1_;
            return false;
         }
         return true;
      }
      
      public function get model() : PyramidModel
      {
         return this._model;
      }
      
      public function setup() : void
      {
         this._model = new PyramidModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PYRAMID_SYSTEM,this.pkgHandler);
      }
      
      private function pkgHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = param1._cmd;
         switch(_loc3_)
         {
            case PyramidPackageType.PYRAMID_OPENORCLOSE:
               this.openOrclose(_loc2_);
               break;
            case PyramidPackageType.PYRAMID_ENTER:
               this.iconEnter(_loc2_);
               break;
            case PyramidPackageType.PYRAMID_STARTORSTOP:
               this.startOrstop(_loc2_);
               break;
            case PyramidPackageType.PYRAMID_RESULT:
               this.cardResult(_loc2_);
               break;
            case PyramidPackageType.PYRAMID_DIEEVENT:
               this.dieEvent(_loc2_);
               break;
            case PyramidPackageType.PYRAMID_SCORECONVERT:
               this.scoreConvert(_loc2_);
         }
      }
      
      private function openOrclose(param1:PackageIn) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.model.isOpen = param1.readBoolean();
         this.model.isScoreExchange = param1.readBoolean();
         if(this.model.isOpen)
         {
            this.model.beginTime = param1.readDate();
            this.model.endTime = param1.readDate();
            this.model.freeCount = param1.readInt();
            this.model.turnCardPrice = param1.readInt();
            this.model.revivePrice = [];
            _loc2_ = param1.readInt();
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               this.model.revivePrice.push(param1.readInt());
               _loc3_++;
            }
         }
         if(this.model.isOpen)
         {
            this.showEnterIcon();
         }
         else
         {
            this.hideEnterIcon();
            if(StateManager.currentStateType == StateType.PYRAMID)
            {
               StateManager.setState(StateType.MAIN);
            }
         }
         this.clearFrame();
      }
      
      private function iconEnter(param1:PackageIn) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         this.model.isUp = false;
         this.model.currentLayer = param1.readInt();
         this.model.maxLayer = param1.readInt();
         this.model.totalPoint = param1.readInt();
         this.model.turnPoint = param1.readInt();
         this.model.pointRatio = param1.readInt();
         this.model.currentFreeCount = param1.readInt();
         this.model.currentReviveCount = param1.readInt();
         this.model.isPyramidStart = param1.readBoolean();
         if(this.model.isPyramidStart)
         {
            _loc2_ = param1.readInt();
            this.model.selectLayerItems = new Dictionary();
            _loc3_ = 1;
            while(_loc3_ <= _loc2_)
            {
               _loc4_ = param1.readInt();
               this.model.selectLayerItems[_loc4_] = new Dictionary();
               _loc5_ = param1.readInt();
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  _loc7_ = param1.readInt();
                  _loc8_ = param1.readInt();
                  this.model.selectLayerItems[_loc4_][_loc8_] = _loc7_;
                  _loc6_++;
               }
               _loc3_++;
            }
         }
         if(StateManager.currentStateType != StateType.PYRAMID)
         {
            StateManager.setState(StateType.PYRAMID);
         }
      }
      
      private function startOrstop(param1:PackageIn) : void
      {
         this.model.isPyramidStart = param1.readBoolean();
         if(!this.model.isPyramidStart)
         {
            this.model.totalPoint = param1.readInt();
            this.model.turnPoint = param1.readInt();
            this.model.pointRatio = param1.readInt();
            this.model.currentLayer = param1.readInt();
            this.model.currentReviveCount = 0;
         }
         this.model.selectLayerItems = new Dictionary();
         this.model.dataChange(PyramidEvent.START_OR_STOP);
         this.clearFrame();
         if(this.autoCount > 0 && this.model.isPyramidStart == false && this.isAutoOpenCard)
         {
            GameInSocketOut.sendPyramidStartOrstop(true);
            return;
         }
         if(!this.model.isPyramidStart)
         {
            this.isAutoOpenCard = false;
         }
      }
      
      private function cardResult(param1:PackageIn) : void
      {
         this.model.templateID = param1.readInt();
         this.model.position = param1.readInt();
         this.model.isPyramidDie = param1.readBoolean();
         this.model.isUp = param1.readBoolean();
         this.model.currentLayer = param1.readInt();
         this.model.maxLayer = param1.readInt();
         this.model.totalPoint = param1.readInt();
         this.model.turnPoint = param1.readInt();
         this.model.pointRatio = param1.readInt();
         this.model.currentFreeCount = param1.readInt();
         var _loc2_:int = this.model.currentLayer;
         if(this.model.isUp)
         {
            _loc2_--;
         }
         var _loc3_:Dictionary = this.model.selectLayerItems[_loc2_];
         if(!_loc3_)
         {
            _loc3_ = new Dictionary();
         }
         _loc3_[this.model.position] = this.model.templateID;
         this.model.selectLayerItems[_loc2_] = _loc3_;
         this.model.dataChange(PyramidEvent.CARD_RESULT);
      }
      
      private function dieEvent(param1:PackageIn) : void
      {
         this.model.isPyramidStart = param1.readBoolean();
         this.model.currentLayer = param1.readInt();
         this.model.totalPoint = param1.readInt();
         this.model.turnPoint = param1.readInt();
         this.model.pointRatio = param1.readInt();
         this.model.currentReviveCount = param1.readInt();
         this.model.dataChange(PyramidEvent.DIE_EVENT);
         this.clearFrame();
      }
      
      private function scoreConvert(param1:PackageIn) : void
      {
         this.model.totalPoint = param1.readInt();
         this.model.dataChange(PyramidEvent.SCORE_CONVERT);
      }
      
      public function showEnterIcon() : void
      {
         this._isShowIcon = true;
         if(PlayerManager.Instance.Self.Grade >= 13)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.PYRAMID,true);
         }
         else
         {
            HallIconManager.instance.executeCacheRightIconLevelLimit(HallIconType.PYRAMID,true,13);
         }
      }
      
      public function hideEnterIcon() : void
      {
         this._isShowIcon = false;
         HallIconManager.instance.updateSwitchHandler(HallIconType.PYRAMID,false);
         HallIconManager.instance.executeCacheRightIconLevelLimit(HallIconType.PYRAMID,false);
      }
      
      public function onClickPyramidIcon(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         GameInSocketOut.sendRequestEnterPyramidSystem();
         if(StateManager.currentStateType != StateType.PYRAMID)
         {
            StateManager.setState(StateType.PYRAMID);
         }
      }
      
      public function templateDataSetup(param1:Array) : void
      {
         this.model.items = param1;
      }
      
      public function showFrame(param1:int, param2:Object = null) : void
      {
         var _loc3_:int = 0;
         var _loc4_:FilterFrameText = null;
         var _loc5_:FilterFrameText = null;
         this._tipsType = param1;
         switch(this._tipsType)
         {
            case 1:
               _loc3_ = int(this.model.revivePrice[this.model.currentReviveCount]);
               this._tipsframe = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("ddt.pyramid.cardFrameReviveTitle"),LanguageMgr.GetTranslation("ddt.pyramid.cardFrameReviveContent",_loc3_),"",LanguageMgr.GetTranslation("cancel"),true,true,false,2);
               _loc4_ = ComponentFactory.Instance.creatComponentByStylename("pyramid.view.cardFrameReviveCount");
               _loc4_.text = LanguageMgr.GetTranslation("ddt.pyramid.cardFrameReviveCount",this.model.revivePrice.length - this.model.currentReviveCount,this.model.revivePrice.length);
               this._tipsframe.addToContent(_loc4_);
               break;
            case 2:
               this._tipsframe = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.pyramid.cardFrameReviveEndContent"),"","",true,false,false,2);
               break;
            case 3:
               this._tipsframe = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.pyramid.stopMsg"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
               break;
            case 4:
               this._tipsframe = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.pyramid.scoreConvertMsg"),"","",true,false,false,2);
               break;
            case 5:
               this._tipsData = param2;
               this._tipsframe = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.pyramid.turnCardMoneyMsg",this.model.turnCardPrice),"",LanguageMgr.GetTranslation("cancel"),true,true,false,2);
               this._selectedCheckButton = ComponentFactory.Instance.creatComponentByStylename("pyramid.buyFrameSelectedCheckButton");
               this._selectedCheckButton.text = LanguageMgr.GetTranslation("ddt.pyramid.buyFrameSelectedCheckButtonTextMsg");
               this._selectedCheckButton.addEventListener(MouseEvent.CLICK,this.__onselectedCheckButtoClick);
               this._tipsframe.addToContent(this._selectedCheckButton);
               break;
            case 6:
               this._tipsframe = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.pyramid.endScoreConvertTime"),"","",true,false,false,2);
               break;
            case 7:
               this._tipsframe = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.pyramid.cardFrameReviveEndContent2"),"","",true,false,false,2);
               break;
            case 8:
               this._tipsframe = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.pyramid.autoOpenCardFrameMsg"),"",LanguageMgr.GetTranslation("cancel"),true,true,false,2);
               this._tipsframe.height = 250;
               this._text = ComponentFactory.Instance.creatComponentByStylename("pyramid.autoCountSelectFrame.Text");
               this._text.text = LanguageMgr.GetTranslation("ddt.pyramid.autoOpenCount.text");
               this._numberSelecter = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.NumberSelecter");
               this._numberSelecter.addEventListener(Event.CHANGE,this.__seleterChange);
               PositionUtils.setPos(this._numberSelecter,"pyramid.view.autoCountPos");
               _loc5_ = ComponentFactory.Instance.creatComponentByStylename("pyramid.TipTxt");
               _loc5_.text = LanguageMgr.GetTranslation("pyramid.tipText.content");
               this._tipsframe.addToContent(this._numberSelecter);
               this._tipsframe.addToContent(this._text);
               this._tipsframe.addToContent(_loc5_);
               this._numberSelecter.valueLimit = "1,50";
         }
         this._tipsframe.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __seleterChange(param1:Event) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.tipsDispose();
         switch(this._tipsType)
         {
            case -1:
               break;
            case 1:
               if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
               {
                  GameInSocketOut.sendPyramidRevive(true);
               }
               else
               {
                  GameInSocketOut.sendPyramidRevive(false);
               }
               break;
            case 2:
               GameInSocketOut.sendPyramidRevive(false);
               break;
            case 3:
               if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
               {
                  GameInSocketOut.sendPyramidStartOrstop(false);
               }
               break;
            case 4:
               break;
            case 5:
               if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
               {
                  GameInSocketOut.sendPyramidTurnCard(this._tipsData[0],this._tipsData[1]);
               }
               this._tipsData = null;
               break;
            case 6:
               break;
            case 7:
               GameInSocketOut.sendPyramidRevive(false);
               break;
            case 8:
               if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
               {
                  this.isShowBuyFrameSelectedCheck = false;
                  this.isAutoOpenCard = true;
                  if(Boolean(this._numberSelecter))
                  {
                     this.autoCount = this._numberSelecter.currentValue;
                  }
               }
         }
      }
      
      private function __onselectedCheckButtoClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.isShowBuyFrameSelectedCheck = !this._selectedCheckButton.selected;
      }
      
      private function tipsDispose() : void
      {
         if(Boolean(this._selectedCheckButton))
         {
            this._selectedCheckButton.removeEventListener(MouseEvent.CLICK,this.__onselectedCheckButtoClick);
            ObjectUtils.disposeObject(this._selectedCheckButton);
            this._selectedCheckButton = null;
         }
         if(Boolean(this._tipsframe))
         {
            this._tipsframe.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
            ObjectUtils.disposeAllChildren(this._tipsframe);
            ObjectUtils.disposeObject(this._tipsframe);
            this._tipsframe = null;
         }
      }
      
      public function clearFrame() : void
      {
         if(Boolean(this._tipsframe))
         {
            this._tipsframe.dispatchEvent(new FrameEvent(-1));
         }
      }
   }
}
