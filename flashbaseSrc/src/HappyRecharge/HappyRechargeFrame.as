package HappyRecharge
{
   import bagAndInfo.cell.BagCell;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.roulette.TurnSoundControl;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class HappyRechargeFrame extends Frame implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _helpFrame:Frame;
      
      private var _bgHelp:Scale9CornerImage;
      
      private var _content:FilterFrameText;
      
      private var _btnOk:TextButton;
      
      private var _prizeArr:Array;
      
      private var _lotteryCountArr:Array;
      
      private var _prizeCountArr:Array;
      
      private var _prizeCell:BagCell;
      
      private var _startBtn:SimpleBitmapButton;
      
      private var _startAllBtn:SimpleBitmapButton;
      
      private var _stopAutoBtn:SimpleBitmapButton;
      
      private var _haloMc:MovieClip;
      
      private var _pointerMc:MovieClip;
      
      private var _bottomBack:MovieClip;
      
      private var _cellShine:MovieClip;
      
      private var _shineObject:Component;
      
      private var _bigYellowCircle:Bitmap;
      
      private var _smallCircleBack:Bitmap;
      
      private var _recordContents:VBox;
      
      private var _recordPanel:ScrollPanel;
      
      private var _exchangeContents:VBox;
      
      private var _exchangePanel:ScrollPanel;
      
      private var _activityData:FilterFrameText;
      
      private var _rotationArr:Array;
      
      private var _currentRotation:int;
      
      private var _frameIndex:int;
      
      private var _cellShineIndex:int;
      
      private var _sound:TurnSoundControl;
      
      public function HappyRechargeFrame()
      {
         this._rotationArr = [15,45,75,105,135,165,-165,-135,-107,-77,-47,-17];
         super();
         this._initView();
         this._initEvent();
      }
      
      public function updateView(param1:HappyRechargeRecordItem = null) : void
      {
         var _loc2_:* = null;
         this.refreshLotteryCount();
         this.refreshPrizeCount();
         if(param1 != null)
         {
            _loc2_ = new HappyRechargeRecordView(param1.prizeType);
            _loc2_.setText(param1.nickName,this._prizeCell.info.Name,param1.count);
            this._recordContents.addChild(_loc2_);
            this._recordContents.arrange();
            this._recordPanel.invalidateViewport();
         }
      }
      
      public function startTurn(param1:int = 6) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         !this._sound && (this._sound = new TurnSoundControl());
         _loc2_ = 0;
         while(_loc2_ < this._prizeArr.length)
         {
            if(this._prizeArr[_loc2_] is HappyRechargeTurnItemInfo)
            {
               _loc3_ = this._prizeArr[_loc2_] as HappyRechargeTurnItemInfo;
               if(_loc3_.indexId == param1)
               {
                  this._currentRotation = _loc2_;
                  break;
               }
            }
            else if(this._prizeArr[_loc2_] == param1)
            {
               this._currentRotation = _loc2_;
               break;
            }
            _loc2_++;
         }
         addEventListener("enterFrame",this.__startroll);
         this._showHaloMc();
      }
      
      private function __startroll(param1:Event) : void
      {
         this._sound.playThreeStep(3);
         if(this._frameIndex < 8)
         {
            this._pointerMc.rotation += 20;
         }
         else if(this._frameIndex < 23)
         {
            this._pointerMc.rotation += 45;
         }
         else if(this._frameIndex < 30)
         {
            this._pointerMc.rotation += 10;
         }
         else if(Math.abs(this._pointerMc.rotation - this._rotationArr[this._currentRotation]) > 10)
         {
            this._pointerMc.rotation += 10;
         }
         else
         {
            this._pointerMc.rotation = this._rotationArr[this._currentRotation];
            this._stopRoll();
         }
         ++this._frameIndex;
         this._pointerMc.rotation = this._pointerMc.rotation == 360 ? 0 : Number(this._pointerMc.rotation);
         this._pointerMc.rotation = this._pointerMc.rotation > 360 ? 10 : Number(this._pointerMc.rotation);
      }
      
      public function autoStartTuren(param1:int) : void
      {
         var item:ItemTemplateInfo;
         var time:uint = 0;
         var info:HappyRechargeTurnItemInfo = null;
         var tips:String = null;
         var index:int = param1;
         ;
         var i:int = 0;
         while(i < this._prizeArr.length)
         {
            if(this._prizeArr[i] is HappyRechargeTurnItemInfo)
            {
               info = this._prizeArr[i] as HappyRechargeTurnItemInfo;
               if(info.indexId == index)
               {
                  this._currentRotation = i;
                  break;
               }
            }
            else if(this._prizeArr[i] == index)
            {
               this._currentRotation = i;
               break;
            }
            i++;
         }
         item = ItemManager.Instance.getTemplateById(HappyRechargeManager.instance.currentPrizeItemID);
         if(item != null)
         {
            tips = LanguageMgr.GetTranslation("horseDaren.skill.descTxt",item.Name) + "x1";
            MessageTipManager.getInstance().show(tips,0,true);
            ChatManager.Instance.sysChatYellow(tips);
         }
         this._pointerMc.rotation = this._rotationArr[this._currentRotation];
         SocketManager.Instance.out.happyRechargeQuestGetItem();
         HappyRechargeManager.instance.dispatchEvent(new Event("HAPPYRECHARGE_UPDATE_TICKET"));
         time = setTimeout(function():void
         {
            clearTimeout(time);
            if(HappyRechargeManager.instance.isAutoStart)
            {
               startTrun();
            }
         },500);
      }
      
      private function _stopRoll() : void
      {
         removeEventListener("enterFrame",this.__startroll);
         this._frameIndex = 0;
         this._hideHaloMc();
         this._createCellShine();
      }
      
      private function _showHaloMc() : void
      {
         this._haloMc.visible = true;
         this._haloMc.gotoAndPlay(1);
      }
      
      private function _hideHaloMc() : void
      {
         this._haloMc.visible = false;
         this._haloMc.gotoAndStop(1);
      }
      
      private function _createCellShine() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         this._cellShine = ClassUtils.CreatInstance("happyRecharge.mainFrame.cellbackhalo");
         addToContent(this._cellShine);
         PositionUtils.setPos(this._cellShine,"mainframe.cellshinemc.pos." + this._currentRotation);
         this._shineObject = new Component();
         var _loc5_:int = HappyRechargeManager.instance.currentPrizeItemID;
         if(_loc5_ > 12)
         {
            _loc1_ = ItemManager.Instance.getTemplateById(_loc5_);
            _loc3_ = (_loc2_ = new BagCell(0,_loc1_)).getContent();
            this._shineObject.addChild(_loc3_);
         }
         else
         {
            _loc4_ = ComponentFactory.Instance.creatBitmap("happyRecharge.mainFrame.bigcell.image." + _loc5_);
            this._shineObject.addChild(_loc4_);
         }
         addToContent(this._shineObject);
         PositionUtils.setPos(this._shineObject,"mainframe.cellshineobject.pos." + this._currentRotation);
         addEventListener("enterFrame",this.__cellShineHandler);
      }
      
      private function _removeCellShine() : void
      {
         this._cellShineIndex = 0;
         HappyRechargeManager.instance.mouseClickEnable = true;
         SocketManager.Instance.out.happyRechargeQuestGetItem();
         HappyRechargeManager.instance.dispatchEvent(new Event("HAPPYRECHARGE_UPDATE_TICKET"));
         ObjectUtils.disposeObject(this._cellShine);
         this._cellShine = null;
         removeEventListener("enterFrame",this.__cellShineHandler);
         this._cellFlyToBag();
      }
      
      private function __cellShineHandler(param1:Event) : void
      {
         if(this._cellShineIndex == 10)
         {
            this._cellShineScale();
         }
         if(this._cellShineIndex < 50)
         {
            ++this._cellShineIndex;
         }
         else
         {
            this._removeCellShine();
         }
      }
      
      private function _cellShineScale() : void
      {
         TweenLite.to(this._shineObject,0.3,{
            "scaleX":1.2,
            "scaleY":1.2,
            "x":this._shineObject.x - 4,
            "y":this._shineObject.y - 4,
            "ease":Linear.easeNone
         });
      }
      
      private function _cellFlyToBag() : void
      {
         TweenLite.to(this._shineObject,0.5,{
            "scaleX":0.3,
            "scaleY":0.3,
            "x":500,
            "y":478,
            "ease":Linear.easeNone
         });
         setTimeout(this._cellFlyToBagComplete,510);
      }
      
      private function _cellFlyToBagComplete() : void
      {
         this.updateState();
         ObjectUtils.disposeObject(this._shineObject);
         this._shineObject = null;
      }
      
      private function _initView() : void
      {
         HappyRechargeManager.instance.mouseClickEnable = true;
         this._bg = ComponentFactory.Instance.creatBitmap("happyRecharge.mainFrame.bg");
         addToContent(this._bg);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("happyrecharge.mainframe.helpbt");
         addToContent(this._helpBtn);
         this.refreshLotteryCount();
         this.refreshPrizeCount();
         this.setPrizeCell();
         this.setPrizeAreaCell();
         this._bottomBack = ClassUtils.CreatInstance("happyRecharge.mainFrame.pointerbottom");
         PositionUtils.setPos(this._bottomBack,"mainframe.bottomBack.mc.pos");
         addToContent(this._bottomBack);
         this._bigYellowCircle = ComponentFactory.Instance.creatBitmap("happyRecharge.mainFrame.pointerbigcircleback");
         addToContent(this._bigYellowCircle);
         this._haloMc = ClassUtils.CreatInstance("happyRecharge.mainFrame.pointerhalo");
         this._haloMc.gotoAndStop(1);
         this._haloMc.visible = false;
         PositionUtils.setPos(this._haloMc,"mainframe.pointerbackhalo.mc.pos");
         addToContent(this._haloMc);
         this._pointerMc = ClassUtils.CreatInstance("happyRecharge.mainFrame.pointer");
         PositionUtils.setPos(this._pointerMc,"mainframe.pointer.mc.pos");
         addToContent(this._pointerMc);
         this._smallCircleBack = ComponentFactory.Instance.creatBitmap("happyRecharge.mainFrame.startsmallcircleback");
         addToContent(this._smallCircleBack);
         this._startBtn = ComponentFactory.Instance.creatComponentByStylename("happyRecharge.mainFrame.startBtn");
         addToContent(this._startBtn);
         this._startAllBtn = ComponentFactory.Instance.creatComponentByStylename("happyRecharge.mainFrame.startAllBtn");
         addToContent(this._startAllBtn);
         this._stopAutoBtn = ComponentFactory.Instance.creatComponentByStylename("happyRecharge.mainFrame.stopAutoBtn");
         addToContent(this._stopAutoBtn);
         this.updateState();
         this._recordContents = ComponentFactory.Instance.creatComponentByStylename("mainframe.recordView.Vbox");
         this._recordContents.isReverAdd = true;
         this._recordPanel = ComponentFactory.Instance.creatComponentByStylename("mainframe.recordViewList");
         this._recordPanel.setView(this._recordContents);
         addToContent(this._recordPanel);
         this.createRecord();
         this._exchangeContents = ComponentFactory.Instance.creatComponentByStylename("mainframe.exchangeView.Vbox");
         this._exchangePanel = ComponentFactory.Instance.creatComponentByStylename("mainframe.exchangeViewList");
         this._exchangePanel.setView(this._exchangeContents);
         addToContent(this._exchangePanel);
         this.createExchangeView();
         this._activityData = ComponentFactory.Instance.creatComponentByStylename("mainframe.activityData.Txt");
         this._activityData.text = LanguageMgr.GetTranslation("happyRecharge.mainFrame.activityData",HappyRechargeManager.instance.activityData);
         addToContent(this._activityData);
      }
      
      private function _initEvent() : void
      {
         addEventListener("response",this.__response);
         this._helpBtn.addEventListener("click",this.__helpBtnHandler);
         this._startBtn.addEventListener("click",this.___startBtnHandler);
         this._startAllBtn.addEventListener("click",this.__onClickStartAll);
         this._stopAutoBtn.addEventListener("click",this.__onClickStopAuto);
      }
      
      private function updateState(param1:int = 0) : void
      {
         if(param1 == 0)
         {
            this._startAllBtn.enable = true;
            this._startAllBtn.visible = true;
            this._startBtn.enable = true;
            this._stopAutoBtn.visible = false;
            HappyRechargeManager.instance.mouseClickEnable = true;
         }
         else if(param1 == 1)
         {
            this._startAllBtn.enable = false;
            this._startAllBtn.visible = true;
            this._startBtn.enable = false;
            this._stopAutoBtn.visible = false;
            HappyRechargeManager.instance.mouseClickEnable = false;
         }
         else if(param1 == 2)
         {
            this._startAllBtn.enable = false;
            this._startAllBtn.visible = false;
            this._startBtn.enable = false;
            this._stopAutoBtn.enable = true;
            this._stopAutoBtn.visible = true;
            HappyRechargeManager.instance.mouseClickEnable = false;
         }
      }
      
      private function __onClickStopAuto(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         HappyRechargeManager.instance.isAutoStart = false;
         this.updateState();
      }
      
      private function __onClickStartAll(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         HappyRechargeManager.instance.isAutoStart = true;
         this.updateState(2);
         this.startTrun();
      }
      
      private function ___startBtnHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         HappyRechargeManager.instance.isAutoStart = false;
         this.updateState(1);
         this.startTrun();
      }
      
      public function startTrun() : void
      {
         if(HappyRechargeManager.instance.lotteryCount > 0)
         {
            SocketManager.Instance.out.happyRechargeStartLottery();
         }
         else
         {
            this.updateState();
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("happyRecharge.mainFrame.countless",HappyRechargeManager.instance.moneyCount));
         }
      }
      
      private function _removeEvent() : void
      {
         removeEventListener("response",this.__response);
         if(Boolean(this._helpBtn))
         {
            this._helpBtn.removeEventListener("click",this.__helpBtnHandler);
         }
         if(Boolean(this._startBtn))
         {
            this._startBtn.removeEventListener("click",this.___startBtnHandler);
         }
         if(Boolean(this._startAllBtn))
         {
            this._startAllBtn.removeEventListener("click",this.__onClickStartAll);
         }
         if(Boolean(this._stopAutoBtn))
         {
            this._stopAutoBtn.removeEventListener("click",this.__onClickStopAuto);
         }
         if(this.hasEventListener("enterFrame"))
         {
            removeEventListener("enterFrame",this.__startroll);
            removeEventListener("enterFrame",this.__cellShineHandler);
         }
      }
      
      private function refreshLotteryCount() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         if(this._lotteryCountArr == null)
         {
            this._lotteryCountArr = [];
         }
         else
         {
            while(this._lotteryCountArr.length > 0)
            {
               _loc1_ = this._lotteryCountArr.pop();
               ObjectUtils.disposeObject(_loc1_);
               _loc1_ = null;
            }
         }
         var _loc5_:String = HappyRechargeManager.instance.lotteryCount.toString();
         _loc2_ = 0;
         while(_loc2_ < _loc5_.length)
         {
            _loc3_ = ComponentFactory.Instance.creatBitmap("happyRecharge.mainFrame.lotteryCount." + _loc5_.charAt(_loc2_));
            addToContent(_loc3_);
            _loc4_ = PositionUtils.creatPoint("mainframe.lotterycount.pos");
            _loc3_.x = _loc4_.x + 13 * _loc2_;
            _loc3_.y = _loc4_.y;
            this._lotteryCountArr.push(_loc3_);
            _loc2_++;
         }
      }
      
      private function refreshPrizeCount() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         if(this._prizeCountArr == null)
         {
            this._prizeCountArr = [];
         }
         else
         {
            while(this._prizeCountArr.length > 0)
            {
               _loc1_ = this._prizeCountArr.pop();
               ObjectUtils.disposeObject(_loc1_);
               _loc1_ = null;
            }
         }
         var _loc5_:String = HappyRechargeManager.instance.prizeCount.toString();
         _loc2_ = 0;
         while(_loc2_ < _loc5_.length)
         {
            _loc3_ = ComponentFactory.Instance.creatBitmap("happyRecharge.mainFrame.prizeCount." + _loc5_.charAt(_loc2_));
            addToContent(_loc3_);
            _loc4_ = PositionUtils.creatPoint("mainframe.prizecount.pos");
            _loc3_.x = _loc4_.x + 13 * _loc2_;
            _loc3_.y = _loc4_.y;
            this._prizeCountArr.push(_loc3_);
            _loc2_++;
         }
         var _loc6_:Bitmap = ComponentFactory.Instance.creatBitmap("happyRecharge.mainFrame.prizeCount.x");
         addToContent(_loc6_);
         PositionUtils.setPos(_loc6_,"mainframe.prizecount.x.pos");
      }
      
      private function setPrizeCell() : void
      {
         var _loc1_:ItemTemplateInfo = HappyRechargeManager.instance.prizeItem;
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(16711680,0);
         _loc2_.graphics.drawRect(0,0,42,42);
         _loc2_.graphics.endFill();
         this._prizeCell = new BagCell(0,_loc1_,false,_loc2_);
         this._prizeCell.setCountNotVisible();
         PositionUtils.setPos(this._prizeCell,"mainframe.prizecell.pos");
         addToContent(this._prizeCell);
      }
      
      private function setPrizeAreaCell() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:int = 0;
         var _loc7_:* = null;
         var _loc8_:* = null;
         var _loc9_:* = null;
         var _loc10_:Array = HappyRechargeManager.instance.turnItems;
         if(this._prizeArr == null)
         {
            this._prizeArr = [];
         }
         else
         {
            while(this._prizeArr.length > 0)
            {
               this._prizeArr.pop();
            }
         }
         while(_loc10_.length > 0)
         {
            _loc1_ = Math.random() * _loc10_.length;
            this._prizeArr.push(_loc10_[_loc1_]);
            _loc10_.splice(_loc1_,1);
         }
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            _loc3_ = Math.random() * this._prizeArr.length;
            this._prizeArr.splice(_loc3_,0,_loc2_ + 9);
            _loc2_++;
         }
         _loc4_ = 0;
         while(_loc4_ < 12)
         {
            if(this._prizeArr[_loc4_] is HappyRechargeTurnItemInfo)
            {
               _loc5_ = new BagCell(0,(this._prizeArr[_loc4_] as HappyRechargeTurnItemInfo).itemInfo,false,ComponentFactory.Instance.creatBitmap("happyRecharge.mainFrame.cellbg"));
               addToContent(_loc5_);
               _loc5_.setContentSize(44,44);
               _loc5_.PicPos = new Point(4.5,4.5);
               PositionUtils.setPos(_loc5_,"mainframe.prizeAreacell.pos." + _loc4_);
            }
            else
            {
               _loc6_ = int(this._prizeArr[_loc4_]);
               _loc7_ = ClassUtils.CreatInstance("happyRecharge.mainFrame.bigcellbg");
               addToContent(_loc7_);
               PositionUtils.setPos(_loc7_,"mainframe.prizeAreacell.pos." + _loc4_);
               _loc8_ = ComponentFactory.Instance.creatComponentByStylename("mainframe.bigcell." + _loc6_);
               addToContent(_loc8_);
               _loc8_.x = _loc7_.x + 5;
               _loc8_.y = _loc7_.y + 5;
               _loc9_ = new HappyRechargeSpecialItemTipInfo();
               _loc9_._title = LanguageMgr.GetTranslation("happyRecharge.mainFrame.bigcell.tipTitle" + _loc6_);
               if(_loc6_ == 9 || _loc6_ == 12)
               {
                  _loc9_._body = LanguageMgr.GetTranslation("happyRecharge.mainFrame.bigcell.tipContext" + _loc6_);
               }
               else
               {
                  _loc9_._body = LanguageMgr.GetTranslation("happyRecharge.mainFrame.bigcell.tipContext" + _loc6_,HappyRechargeManager.instance.specialPrizeCount[_loc6_ - 10]);
               }
               _loc8_.tipData = _loc9_;
            }
            _loc4_++;
         }
      }
      
      private function createExchangeView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:Array = HappyRechargeManager.instance.exchangeItems;
         _loc1_ = 0;
         while(_loc1_ < _loc5_.length)
         {
            _loc2_ = _loc5_[_loc1_] as HappyRechargeExchangeItem;
            (_loc3_ = new HappyRechargeExchangeView()).setInfo(_loc2_.info,_loc2_.count,HappyRechargeManager.instance.ticketCount,_loc2_.needCount);
            this._exchangeContents.addChild(_loc3_);
            if(_loc1_ + 1 < _loc5_.length)
            {
               _loc4_ = ComponentFactory.Instance.creatBitmap("happyRecharge.mainFrame.exchangeItem.line");
               this._exchangeContents.addChild(_loc4_);
            }
            _loc1_++;
         }
         this._exchangePanel.invalidateViewport();
      }
      
      private function createRecord() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:Array = HappyRechargeManager.instance.recordArr;
         _loc1_ = 0;
         while(_loc1_ < _loc4_.length)
         {
            _loc2_ = _loc4_[_loc1_] as HappyRechargeRecordItem;
            if(_loc2_.prizeType > 9 && _loc2_.prizeType < 13)
            {
               _loc3_ = new HappyRechargeRecordView(_loc2_.prizeType);
               _loc3_.setText(_loc2_.nickName,this._prizeCell.info.Name,_loc2_.count);
               this._recordContents.addChild(_loc3_);
            }
            _loc1_++;
         }
         this._recordPanel.invalidateViewport();
      }
      
      private function createPrizeAreaCellInfoForTest() : Array
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:Array = [];
         var _loc4_:Array = [11901,11902,11903,11904,11905,11906,11025,100100];
         _loc1_ = 0;
         while(_loc1_ < _loc4_.length)
         {
            _loc2_ = ItemManager.Instance.getTemplateById(_loc4_[_loc1_]);
            _loc3_.push(_loc2_);
            _loc1_++;
         }
         return _loc3_;
      }
      
      private function createExchangeItems() : Array
      {
         return [];
      }
      
      private function createTestRecordData() : Array
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:Array = [];
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = new HappyRechargeRecordItem();
            _loc2_.nickName = "呵呵哒";
            _loc2_.prizeType = int(Math.random() * 3 + 10);
            _loc2_.count = int(Math.random() * 1000);
            _loc3_.push(_loc2_);
            _loc1_++;
         }
         return _loc3_;
      }
      
      private function __response(param1:FrameEvent) : void
      {
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            SoundManager.instance.play("008");
            if(HappyRechargeManager.instance.mouseClickEnable)
            {
               SocketManager.Instance.out.happyRechargeQuestGetItem(1);
               this.dispose();
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("happyRecharge.mainFrame.inrolling"));
            }
         }
      }
      
      private function __helpBtnHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         SoundManager.instance.playButtonSound();
         if(!this._helpFrame)
         {
            _loc2_ = HappyRechargeManager.instance.moneyCount;
            _loc3_ = int(HappyRechargeManager.instance.specialPrizeCount[0]);
            _loc4_ = int(HappyRechargeManager.instance.specialPrizeCount[1]);
            this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.main");
            this._helpFrame.titleText = LanguageMgr.GetTranslation("happyRecharge.mainFrame.titleTxt");
            this._helpFrame.addEventListener("response",this.__helpFrameRespose);
            this._bgHelp = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.bgHelp");
            this._content = ComponentFactory.Instance.creatComponentByStylename("mainframe.helpframe.contentTxt");
            this._content.htmlText = LanguageMgr.GetTranslation("happyRecharge.mainFrame.helpContentTxt",_loc2_,_loc2_,_loc2_ * 2.5,_loc3_,_loc4_);
            this._btnOk = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.btnOk");
            this._btnOk.text = LanguageMgr.GetTranslation("ok");
            this._btnOk.addEventListener("click",this.__closeHelpFrame);
            this._helpFrame.addToContent(this._bgHelp);
            this._helpFrame.addToContent(this._content);
            this._helpFrame.addToContent(this._btnOk);
         }
         LayerManager.Instance.addToLayer(this._helpFrame,3,true,2);
      }
      
      private function __helpFrameRespose(param1:FrameEvent) : void
      {
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            SoundManager.instance.playButtonSound();
            this._helpFrame.parent.removeChild(this._helpFrame);
         }
      }
      
      private function __closeHelpFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._helpFrame.parent.removeChild(this._helpFrame);
      }
      
      override public function dispose() : void
      {
         this._removeEvent();
         this._sound && this._sound.dispose();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         ObjectUtils.disposeObject(this._helpFrame);
         this._helpFrame = null;
         ObjectUtils.disposeObject(this._bgHelp);
         this._bgHelp = null;
         ObjectUtils.disposeObject(this._content);
         this._content = null;
         ObjectUtils.disposeObject(this._btnOk);
         this._btnOk = null;
         ObjectUtils.disposeObject(this._exchangeContents);
         this._exchangeContents = null;
         ObjectUtils.disposeObject(this._exchangePanel);
         this._exchangePanel = null;
         ObjectUtils.disposeObject(this._startBtn);
         this._startBtn = null;
         super.dispose();
      }
   }
}
