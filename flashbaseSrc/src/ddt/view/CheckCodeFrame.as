package ddt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.CheckCodeData;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.FilterWordManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class CheckCodeFrame extends BaseAlerFrame
   {
      
      private static var _instance:ddt.view.CheckCodeFrame;
       
      
      private const BACK_GOUND_GAPE:int = 3;
      
      private var _time:int;
      
      private var _bgI:Bitmap;
      
      private var _bgII:Scale9CornerImage;
      
      private var _isShowed:Boolean = true;
      
      private var _inputArr:Array;
      
      private var _input:String;
      
      private var _countDownTxt:FilterFrameText;
      
      private var _secondTxt:FilterFrameText;
      
      private var coutTimer:Timer;
      
      private var coutTimer_1:Timer;
      
      private var checkCount:int = 0;
      
      private var _alertInfo:AlertInfo;
      
      private var okBtn:BaseButton;
      
      private var clearBtn:BaseButton;
      
      private var _numberArr:Array;
      
      private var _numViewArr:Array;
      
      private var _NOBtnIsOver:Boolean = false;
      
      private var _cheatTime:uint = 0;
      
      private var speed:Number = 10;
      
      private var currentPic:Bitmap;
      
      private var _showTimer:Timer;
      
      private var count:int;
      
      public function CheckCodeFrame()
      {
         var _loc1_:int = 0;
         var _loc2_:FilterFrameText = null;
         var _loc3_:BaseButton = null;
         var _loc5_:Bitmap = null;
         var _loc6_:Object = null;
         var _loc7_:Sprite = null;
         _loc1_ = 0;
         _loc2_ = null;
         _loc3_ = null;
         var _loc4_:ScaleFrameImage = null;
         _loc5_ = null;
         _loc6_ = null;
         _loc7_ = null;
         this._showTimer = new Timer(1000);
         super();
         this._bgI = ComponentFactory.Instance.creatBitmap("asset.core.checkCodeBgAsset");
         addToContent(this._bgI);
         this._bgII = ComponentFactory.Instance.creatComponentByStylename("store.checkCodeScale9BG");
         addToContent(this._bgII);
         this._inputArr = new Array();
         var _loc8_:int = 0;
         while(_loc8_ < 4)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("core.checkCodeInputTxt");
            _loc2_.type = TextFieldType.DYNAMIC;
            _loc2_.text = "*";
            _loc2_.x += _loc8_ * 39;
            this._inputArr.push(_loc2_);
            _loc2_.visible = false;
            addToContent(_loc2_);
            _loc8_++;
         }
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.view.enthrallCheckFrame.checkCode"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("clear"));
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this.okBtn = _submitButton;
         this.okBtn.addEventListener(MouseEvent.CLICK,this.__okBtnClick);
         this.okBtn.enable = false;
         this.clearBtn = _cancelButton;
         this.clearBtn.addEventListener(MouseEvent.CLICK,this.__clearBtnClick);
         this.clearBtn.enable = false;
         this._countDownTxt = ComponentFactory.Instance.creatComponentByStylename("core.checkCodeCountDownTxt");
         addToContent(this._countDownTxt);
         this._secondTxt = ComponentFactory.Instance.creatComponentByStylename("core.checkCodeSecTxt");
         addToContent(this._secondTxt);
         this._secondTxt.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.second");
         this._numberArr = new Array();
         this._numViewArr = new Array();
         _loc1_ = _loc1_;
         while(_loc1_ < 10)
         {
            _loc3_ = ComponentFactory.Instance.creatComponentByStylename("core.checkCodeNOBtn");
            _loc4_ = ComponentFactory.Instance.creatComponentByStylename("core.checkCodeNOBtnBg");
            _loc3_.backgound = _loc4_;
            _loc5_ = ComponentFactory.Instance.creatBitmap("asset.core.checkCodeNO" + String(_loc1_) + "Asset");
            _loc5_.x = (_loc3_.width - _loc5_.width) / 2;
            _loc5_.y = (_loc3_.height - _loc5_.height) / 2;
            _loc3_.addChild(_loc5_);
            _loc6_ = new Object();
            _loc7_ = new Sprite();
            _loc3_.x = -_loc3_.width / 2;
            _loc3_.y = -_loc3_.height / 2;
            _loc7_.addChild(_loc3_);
            _loc6_.view = _loc7_;
            _loc6_.NOView = _loc5_;
            _loc6_.id = _loc1_;
            _loc6_.angle = _loc1_ * 0.628;
            _loc6_.axisZ = 100;
            this._numberArr.push(_loc6_);
            this._numViewArr.push(_loc7_);
            addToContent(_loc7_);
            _loc7_.addEventListener(MouseEvent.CLICK,this.clicknumSp);
            _loc7_.addEventListener(MouseEvent.MOUSE_OVER,this.overnumSp);
            _loc7_.addEventListener(MouseEvent.MOUSE_OUT,this.outnumSp);
            _loc1_++;
         }
         this.setnumViewCoord();
      }
      
      public static function get Instance() : ddt.view.CheckCodeFrame
      {
         if(_instance == null)
         {
            _instance = ComponentFactory.Instance.creatCustomObject("core.checkCodeFrame");
         }
         return _instance;
      }
      
      public function get time() : int
      {
         return this._time;
      }
      
      public function set time(param1:int) : void
      {
         this._time = param1;
      }
      
      private function clicknumSp(param1:MouseEvent) : void
      {
         if(this._cheatTime == 0)
         {
            this._cheatTime = getTimer();
         }
         SoundManager.instance.play("008");
         if(this._input.length >= 4)
         {
            return;
         }
         this._input += String(this._numViewArr.indexOf(param1.currentTarget));
         this.textChange();
      }
      
      private function overnumSp(param1:MouseEvent) : void
      {
         this._NOBtnIsOver = true;
      }
      
      private function outnumSp(param1:MouseEvent) : void
      {
         this._NOBtnIsOver = false;
      }
      
      private function setnumViewCoord() : void
      {
      }
      
      private function math_z(param1:Object) : void
      {
      }
      
      private function inFrameStart(param1:Event) : void
      {
         var _loc2_:int = Math.abs(Math.sqrt((mouseX - 356) * (mouseX - 356) + (mouseY - 166) * (mouseY - 166)) - 100);
         if(_loc2_ <= 100)
         {
            this.speed = _loc2_ / 200;
         }
         if(_loc2_ > 100)
         {
            this.speed = 0.5;
         }
         if(this._NOBtnIsOver == true)
         {
            this.speed = 0.02;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this._numberArr.length)
         {
            this._numberArr[_loc3_].NOView.visible = true;
            if(this._NOBtnIsOver)
            {
               this._numberArr[_loc3_].NOView.visible = false;
            }
            this._numberArr[_loc3_].angle += this.speed * 0.1;
            this._numberArr[_loc3_].view.y = this._numberArr[_loc3_].axisZ * Math.cos(this._numberArr[_loc3_].angle) + 166;
            this._numberArr[_loc3_].view.x = this._numberArr[_loc3_].axisZ * Math.sin(this._numberArr[_loc3_].angle) + 356;
            _loc3_++;
         }
      }
      
      public function set data(param1:CheckCodeData) : void
      {
         if(Boolean(this.currentPic) && Boolean(this.currentPic.parent))
         {
            removeChild(this.currentPic);
            this.currentPic.bitmapData.dispose();
            this.currentPic = null;
         }
         this.currentPic = param1.pic;
         this.currentPic.width = 170 - 2 * this.BACK_GOUND_GAPE;
         this.currentPic.height = 75 - 2 * this.BACK_GOUND_GAPE;
         this.currentPic.x = 30 + Math.random() * 2 * this.BACK_GOUND_GAPE;
         this.currentPic.y = 75 + Math.random() * 2 * this.BACK_GOUND_GAPE;
         addChild(this.currentPic);
      }
      
      private function __onTimeComplete(param1:TimerEvent) : void
      {
         this._input = "";
         this.coutTimer.stop();
         this.coutTimer.reset();
         this.sendSelected();
      }
      
      private function __onTimeComplete_1(param1:TimerEvent) : void
      {
         this._countDownTxt.text = (int(this._countDownTxt.text) - 1).toString();
      }
      
      private function textChange() : void
      {
         this.okBtn.enable = this.isValidText();
         this.clearBtn.enable = this.haveValidText();
         var _loc1_:int = 0;
         while(_loc1_ < this._inputArr.length)
         {
            this._inputArr[_loc1_].visible = false;
            if(_loc1_ < this._input.length)
            {
               this._inputArr[_loc1_].visible = true;
            }
            _loc1_++;
         }
      }
      
      private function haveValidText() : Boolean
      {
         if(this._input.length == 0)
         {
            return false;
         }
         return true;
      }
      
      private function isValidText() : Boolean
      {
         if(FilterWordManager.IsNullorEmpty(this._input))
         {
            return false;
         }
         if(this._input.length != 4)
         {
            return false;
         }
         return true;
      }
      
      public function set tip(param1:String) : void
      {
      }
      
      public function show() : void
      {
         this.count = this.time;
         this._countDownTxt.text = (this.time - 1).toString();
         if(Boolean(this.coutTimer))
         {
            this.coutTimer.stop();
            this.coutTimer.removeEventListener(TimerEvent.TIMER,this.__onTimeComplete);
         }
         if(Boolean(this.coutTimer_1))
         {
            this.coutTimer_1.stop();
            this.coutTimer_1.removeEventListener(TimerEvent.TIMER,this.__onTimeComplete);
         }
         this.coutTimer = new Timer(this.time * 1000,1);
         this.coutTimer_1 = new Timer(1000,this.time);
         if(StateManager.currentStateType == StateType.FIGHTING)
         {
            this._showTimer.addEventListener(TimerEvent.TIMER,this.__show);
            this._showTimer.start();
         }
         else
         {
            this.popup();
         }
      }
      
      private function __show(param1:TimerEvent) : void
      {
         if(StateManager.currentStateType != StateType.FIGHTING)
         {
            this._showTimer.removeEventListener(TimerEvent.TIMER,this.__show);
            this._showTimer.stop();
            this.popup();
         }
      }
      
      private function popup() : void
      {
         SoundManager.instance.play("057");
         this.isShowed = true;
         this.x = 220 + (Math.random() * 150 - 75);
         this.y = 110 + (Math.random() * 200 - 100);
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
         this._input = "";
         this.restartTimer();
      }
      
      public function close() : void
      {
         if(Boolean(this.coutTimer))
         {
            this.coutTimer.stop();
            this.coutTimer.removeEventListener(TimerEvent.TIMER,this.__onTimeComplete);
         }
         if(Boolean(this.coutTimer_1))
         {
            this.coutTimer_1.stop();
            this.coutTimer_1.removeEventListener(TimerEvent.TIMER,this.__onTimeComplete);
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this.checkCount = 0;
         this._input = "";
         addEventListener(KeyboardEvent.KEY_DOWN,this.__resposeHandler);
         removeEventListener(Event.ENTER_FRAME,this.inFrameStart);
         dispatchEvent(new Event(Event.CLOSE));
         this.textChange();
      }
      
      override protected function __onAddToStage(param1:Event) : void
      {
         addEventListener(KeyboardEvent.KEY_DOWN,this.__resposeHandler);
      }
      
      private function __okBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(getTimer() - this._cheatTime <= 500)
         {
            this._input = "";
            SocketManager.Instance.out.sendCheckCode("cheat");
            return;
         }
         if(this.isValidText())
         {
            this.sendSelected();
         }
      }
      
      private function __clearBtnClick(param1:MouseEvent) : void
      {
         if(this.haveValidText())
         {
            SoundManager.instance.play("008");
            this._input = "";
            this.textChange();
         }
      }
      
      private function __resposeHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.__okBtnClick(null);
         }
      }
      
      private function sendSelected() : void
      {
         this.coutTimer.removeEventListener(TimerEvent.TIMER,this.__onTimeComplete);
         if(!FilterWordManager.IsNullorEmpty(this._input))
         {
            SocketManager.Instance.out.sendCheckCode(this._input);
         }
         else
         {
            SocketManager.Instance.out.sendCheckCode("");
            this.restartTimer();
         }
         this._input = "";
         ++this.checkCount;
         if(this.checkCount == 10)
         {
            this.checkCount = 0;
            this.coutTimer.removeEventListener(TimerEvent.TIMER,this.__onTimeComplete);
            this.close();
         }
      }
      
      private function restartTimer() : void
      {
         this._cheatTime = 0;
         this.coutTimer.stop();
         this.coutTimer.reset();
         this.coutTimer.addEventListener(TimerEvent.TIMER,this.__onTimeComplete);
         this.coutTimer.start();
         this.coutTimer_1.stop();
         this.coutTimer_1.reset();
         this.coutTimer_1.addEventListener(TimerEvent.TIMER,this.__onTimeComplete_1);
         this.coutTimer_1.start();
         this._countDownTxt.text = (this.count - 1).toString();
         this.okBtn.enable = false;
         this.clearBtn.enable = false;
         removeEventListener(Event.ENTER_FRAME,this.inFrameStart);
         addEventListener(Event.ENTER_FRAME,this.inFrameStart);
         this.textChange();
      }
      
      public function get isShowed() : Boolean
      {
         return this._isShowed;
      }
      
      public function set isShowed(param1:Boolean) : void
      {
         this._isShowed = param1;
      }
   }
}
