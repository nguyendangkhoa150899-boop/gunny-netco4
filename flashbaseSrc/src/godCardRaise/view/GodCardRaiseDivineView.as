package godCardRaise.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import godCardRaise.GodCardRaiseManager;
   
   public class GodCardRaiseDivineView extends Sprite implements Disposeable
   {
      
      public static const OPENCARDLOCK_CHANGE:String = "openCardLockChange";
       
      
      private var _bg:MutipleImage;
      
      private var _tipTxt:FilterFrameText;
      
      private var _divineBtn:BaseButton;
      
      private var _manyDivineBtn:BaseButton;
      
      private var _freeCountBg:Bitmap;
      
      private var _freeCountTxt:FilterFrameText;
      
      private var _buyCount:int = 1;
      
      private var _buyMoney:int = 0;
      
      private var _openCardsMovie:MovieClip;
      
      private var _cardsLoader:godCardRaise.view.GodCardRaiseDivineCardsLoader;
      
      private var _openCardLock:Boolean = false;
      
      private var _selectedBtn:SelectedCheckButton;
      
      protected var _selectedCB:ComboBox;
      
      private var godcardLevels:Array;
      
      public var continueOpen:int = 0;
      
      private var _currentCards:Array;
      
      private var _card1:MovieClip;
      
      private var _card2:MovieClip;
      
      private var _card3:MovieClip;
      
      private var _card4:MovieClip;
      
      private var _card5:MovieClip;
      
      public function GodCardRaiseDivineView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:* = 0;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseDivineView.bg");
         addChild(this._bg);
         this._divineBtn = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseDivineView.divineBtn");
         addChild(this._divineBtn);
         this.setButtonFrame(this._divineBtn,1);
         this._freeCountBg = ComponentFactory.Instance.creatBitmap("asset.godCardRaiseDivineView.freeCountBg");
         addChild(this._freeCountBg);
         this._freeCountTxt = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseDivineView.freeCountTxt");
         addChild(this._freeCountTxt);
         this._manyDivineBtn = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseDivineView.manyDivineBtn");
         addChild(this._manyDivineBtn);
         this.setButtonFrame(this._manyDivineBtn,1);
         this._tipTxt = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseDivineView.tipTxt");
         this._tipTxt.text = LanguageMgr.GetTranslation("godCardRaiseDivineView.tipTxtMsg");
         addChild(this._tipTxt);
         this._openCardsMovie = ClassUtils.CreatInstance("asset.godCardRaiseDivineView.openCardsMovie");
         PositionUtils.setPos(this._openCardsMovie,"godCardRaiseDivineView.openCardsMoviePos");
         this._openCardsMovie.addFrameScript(60,this.exeScriptHandler,this._openCardsMovie.totalFrames - 2,this.playEndMovie);
         addChild(this._openCardsMovie);
         this._cardsLoader = new godCardRaise.view.GodCardRaiseDivineCardsLoader();
         this.showFreeCount();
         this._selectedBtn = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseDivineView.selectBtn");
         this._selectedBtn.text = LanguageMgr.GetTranslation("godCardRaiseDivineView.selectBtnMsg");
         addChild(this._selectedBtn);
         this._selectedCB = ComponentFactory.Instance.creatComponentByStylename("friendGroupFrame.choose");
         addChild(this._selectedCB);
         this._selectedCB.beginChanges();
         var _loc2_:* = this._selectedCB.listPanel.vectorListModel;
         _loc2_.clear();
         this.godcardLevels = LanguageMgr.GetTranslation("godCardRaiseDivineView.godcardLevelsMsg").split("|");
         _loc1_ = 0;
         while(_loc1_ < this.godcardLevels.length)
         {
            _loc2_.append(this.godcardLevels[_loc1_]);
            _loc1_++;
         }
         this._selectedCB.commitChanges();
         this._selectedCB.textField.text = this.godcardLevels[this.godcardLevels.length - 1];
         this._selectedCB.visible = false;
         this._selectedBtn.visible = false;
      }
      
      private function initEvent() : void
      {
         this._divineBtn.addEventListener("click",this.__divineClickHandler);
         this._manyDivineBtn.addEventListener("click",this.__manyDivineClickHandler);
         this._selectedCB.listPanel.list.addEventListener("listItemClick",this.__onListClicked);
      }
      
      private function setButtonFrame(param1:BaseButton, param2:int) : void
      {
      }
      
      private function getButtonCurrentFrame(param1:BaseButton) : int
      {
         var _loc2_:* = param1.backgound as ScaleFrameImage;
         return _loc2_.getFrame;
      }
      
      private function __onListClicked(param1:ListItemEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:* = this.godcardLevels.indexOf(param1.cellValue);
      }
      
      private function showFreeCount() : void
      {
         this._freeCountTxt.text = LanguageMgr.GetTranslation("godCardRaiseDivineView.freeCountTxtMsg",this.freeCount);
         var _loc1_:* = this.freeCount > 0;
         this._freeCountTxt.visible = this.freeCount > 0;
         this._freeCountBg.visible = _loc1_;
      }
      
      private function get freeCount() : int
      {
         return ServerConfigManager.instance.godCardDailyFreeCount - GodCardRaiseManager.Instance.model.freeCount;
      }
      
      private function __divineClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(this.freeCount > 0)
         {
            this.sendOpenCard(1,false);
         }
         else
         {
            this._buyCount = 1;
            this._buyMoney = ServerConfigManager.instance.godCardOpenOneTimeMoney;
            this.buyAlert();
         }
      }
      
      private function __manyDivineClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(this.openCardLock)
         {
            return;
         }
         this._buyCount = 5;
         this._buyMoney = ServerConfigManager.instance.godCardOpenFiveTimeMoney;
         this.buyAlert();
      }
      
      private function buyAlert() : void
      {
         var _loc1_:String = LanguageMgr.GetTranslation("godCardRaise.godCardRaiseDivineView.divineMsg",this._buyMoney,this._buyCount);
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),_loc1_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,2);
         _loc2_.addEventListener("response",this.MuaThe);
      }
      
      private function MuaThe(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (param1.currentTarget as BaseAlerFrame).removeEventListener("response",this.MuaThe);
         switch(int(param1.responseCode))
         {
            case 3:
               if(this._buyMoney > PlayerManager.Instance.Self.Money)
               {
                  MessageTipManager.getInstance().show("Xu không đủ, vui lòng nạp thêm");
                  return;
               }
               this.sendOpenCard(this._buyCount,false);
               break;
         }
      }
      
      private function sendOpenCard(param1:int, param2:Boolean) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._selectedBtn.selected)
         {
            this.continueOpen = param1;
         }
         else
         {
            this.continueOpen = 0;
         }
         GameInSocketOut.sendGodCardOpenCard(param1,param2);
         this.openCardLock = true;
      }
      
      public function set openCardLock(param1:Boolean) : void
      {
         this._openCardLock = param1;
         var _loc2_:* = !this._openCardLock;
         this._manyDivineBtn.enable = !this._openCardLock;
         this._divineBtn.enable = _loc2_;
         _loc2_ = !this._openCardLock;
         this._selectedBtn.enable = _loc2_;
         this._selectedCB.enable = _loc2_;
         if(this._openCardLock)
         {
            if(this.continueOpen == 1)
            {
               this._divineBtn.enable = true;
               this.setButtonFrame(this._divineBtn,2);
            }
            else if(this.continueOpen == 5)
            {
               this._manyDivineBtn.enable = true;
               this.setButtonFrame(this._manyDivineBtn,2);
            }
         }
         else
         {
            this.setButtonFrame(this._divineBtn,1);
            this.setButtonFrame(this._manyDivineBtn,1);
         }
         dispatchEvent(new Event("openCardLockChange"));
      }
      
      public function get openCardLock() : Boolean
      {
         return this._openCardLock;
      }
      
      public function playCardMovie(param1:Array) : void
      {
         this._currentCards = param1;
         this._cardsLoader.loadCards(this._currentCards,this.loaderCardsComplete);
      }
      
      private function playEndMovie() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         var _loc3_:* = false;
         var _loc4_:* = this.godcardLevels.indexOf(this._selectedCB.textField.text) + 3;
         _loc1_ = 0;
         while(_loc1_ < this._currentCards.length)
         {
            _loc2_ = GodCardRaiseManager.Instance.godCardListInfoList[this._currentCards[_loc1_]];
            if(_loc2_ && _loc2_.Level == _loc4_)
            {
               _loc3_ = true;
               break;
            }
            _loc1_++;
         }
         if(this.continueOpen == 0 || _loc3_)
         {
            this.openCardLock = false;
         }
         else if(this.continueOpen == 1)
         {
            if(this.freeCount > 0)
            {
               this.sendOpenCard(1,false);
            }
            else
            {
               this._buyCount = 1;
               this._buyMoney = ServerConfigManager.instance.godCardOpenOneTimeMoney;
               this.buyAlert();
            }
         }
         else if(this.continueOpen == 5)
         {
            this._buyCount = 5;
            this._buyMoney = ServerConfigManager.instance.godCardOpenFiveTimeMoney;
            this.buyAlert();
         }
      }
      
      private function loaderCardsComplete() : void
      {
         SoundManager.instance.play("217");
         this._openCardsMovie.gotoAndPlay(2);
      }
      
      private function exeScriptHandler() : void
      {
         if(Boolean(this._currentCards))
         {
            this._card1 = this._openCardsMovie.getChildByName("card1") as MovieClip;
            this._card2 = this._openCardsMovie.getChildByName("card2") as MovieClip;
            this._card3 = this._openCardsMovie.getChildByName("card3") as MovieClip;
            this._card4 = this._openCardsMovie.getChildByName("card4") as MovieClip;
            this._card5 = this._openCardsMovie.getChildByName("card5") as MovieClip;
            if(this._currentCards.length == 1)
            {
               this._card3.addFrameScript(1,this.cardScript3,5,this.cardScript3,10,this.cardScript3);
            }
            else
            {
               this._card1.addFrameScript(1,this.cardScript1,5,this.cardScript1,10,this.cardScript1);
               this._card2.addFrameScript(1,this.cardScript2,5,this.cardScript2,10,this.cardScript2);
               this._card3.addFrameScript(1,this.cardScript3,5,this.cardScript3,10,this.cardScript3);
               this._card4.addFrameScript(1,this.cardScript4,5,this.cardScript4,10,this.cardScript4);
               this._card5.addFrameScript(1,this.cardScript5,5,this.cardScript5,10,this.cardScript5);
            }
         }
      }
      
      private function cardScript1() : void
      {
         var _loc1_:* = this._card1.getChildByName("card") as MovieClip;
         var _loc2_:* = this._currentCards[0];
         this.addCardToMovie(_loc1_,_loc2_);
      }
      
      private function cardScript2() : void
      {
         var _loc1_:* = this._card2.getChildByName("card") as MovieClip;
         var _loc2_:* = this._currentCards[1];
         this.addCardToMovie(_loc1_,_loc2_);
      }
      
      private function cardScript3() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = this._card3.getChildByName("card") as MovieClip;
         if(this._currentCards.length == 1)
         {
            _loc1_ = this._currentCards[0];
         }
         else
         {
            _loc1_ = this._currentCards[2];
         }
         this.addCardToMovie(_loc2_,_loc1_);
      }
      
      private function cardScript4() : void
      {
         var _loc1_:* = this._card4.getChildByName("card") as MovieClip;
         var _loc2_:* = this._currentCards[3];
         this.addCardToMovie(_loc1_,_loc2_);
      }
      
      private function cardScript5() : void
      {
         var _loc1_:* = this._card5.getChildByName("card") as MovieClip;
         var _loc2_:* = this._currentCards[4];
         this.addCardToMovie(_loc1_,_loc2_);
      }
      
      private function clearMovie(param1:MovieClip) : void
      {
         var _loc2_:* = null;
         if(Boolean(param1))
         {
            while(param1.numChildren > 0)
            {
               _loc2_ = param1.getChildAt(0);
               param1.removeChild(_loc2_);
            }
         }
      }
      
      private function addCardToMovie(param1:MovieClip, param2:int) : void
      {
         var _loc3_:* = null;
         this.clearMovie(param1);
         var _loc4_:* = this._cardsLoader.displayCards[param2] as Bitmap;
         if(Boolean(this._cardsLoader.displayCards[param2] as Bitmap))
         {
            _loc3_ = new Bitmap(_loc4_.bitmapData,_loc4_.pixelSnapping,true);
            _loc3_.x = -83;
            _loc3_.y = -123;
            param1.addChild(_loc3_);
         }
      }
      
      public function updateView() : void
      {
         this.showFreeCount();
      }
      
      private function removeEvent() : void
      {
         this._divineBtn.removeEventListener("click",this.__divineClickHandler);
         this._manyDivineBtn.removeEventListener("click",this.__manyDivineClickHandler);
         this._selectedCB.listPanel.list.removeEventListener("listItemClick",this.__onListClicked);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._cardsLoader);
         this._cardsLoader = null;
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._divineBtn = null;
         this._freeCountBg = null;
         this._freeCountTxt = null;
         this._manyDivineBtn = null;
         this._tipTxt = null;
         if(Boolean(this._openCardsMovie))
         {
            this._openCardsMovie.stop();
            this._openCardsMovie = null;
         }
         this._selectedBtn = null;
         this._selectedCB = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
