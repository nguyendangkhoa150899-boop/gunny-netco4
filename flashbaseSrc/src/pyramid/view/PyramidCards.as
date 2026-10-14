package pyramid.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import pyramid.PyramidManager;
   import pyramid.data.PyramidSystemItemsInfo;
   import pyramid.event.PyramidEvent;
   
   public class PyramidCards extends Sprite implements Disposeable
   {
      
      public static const SHUFFLE:String = "shuffle";
      
      public static const OPEN:String = "open";
      
      public static const CLOSE:String = "close";
      
      public static const BG:String = "bg";
       
      
      private var _topBox:pyramid.view.PyramidTopBox;
      
      private var _cards:Dictionary;
      
      private var _cardsSprite:Sprite;
      
      private var _currentCard:pyramid.view.PyramidCard;
      
      private var _shuffleMovie:MovieClip;
      
      private var _movieCountArr:Array;
      
      private var _playLevel:int;
      
      private var _shuffleWaitTimer:Timer;
      
      private var _timerCurrentCount:int;
      
      private var _playLevelMovieStep:int = 0;
      
      private var _timerOutNum:uint;
      
      public function PyramidCards()
      {
         super();
         this.initView();
         this.initEvent();
         this.initData();
      }
      
      private function initView() : void
      {
         this._shuffleMovie = ComponentFactory.Instance.creat("assets.pyramid.shuffle");
         this._shuffleMovie.gotoAndStop(1);
         PositionUtils.setPos(this._shuffleMovie,"pyramid.view.shufflePos");
         this._shuffleMovie.visible = false;
         addChild(this._shuffleMovie);
         this._cardsSprite = new Sprite();
         addChild(this._cardsSprite);
         this._topBox = ComponentFactory.Instance.creatCustomObject("pyramid.topBox");
         this._topBox.addTopBoxMovie(this);
         addChild(this._topBox);
         if(PyramidManager.instance.model.currentLayer >= 8)
         {
            this.topBoxMovieMode(1);
         }
         else
         {
            this.topBoxMovieMode();
         }
         this._shuffleWaitTimer = new Timer(800,1);
      }
      
      private function initEvent() : void
      {
         this._topBox.addEventListener(MouseEvent.CLICK,this.__cardClickHandler);
         this._shuffleWaitTimer.addEventListener(TimerEvent.TIMER,this.__shuffleWaitTimerHandler);
      }
      
      private function initData() : void
      {
         var _loc1_:int = 0;
         this._cards = new Dictionary();
         var _loc2_:int = 7;
         while(_loc2_ >= 1)
         {
            this._cards[_loc2_] = new Dictionary();
            _loc1_ = 8;
            while(_loc1_ >= _loc2_)
            {
               this.createCard(_loc2_,9 - _loc1_);
               _loc1_--;
            }
            _loc2_--;
         }
         this.updateSelectItems();
         this.playShuffleFullMovie();
      }
      
      private function createCard(param1:int, param2:int) : void
      {
         var _loc3_:pyramid.view.PyramidCard = null;
         var _loc4_:Point = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc3_ = new pyramid.view.PyramidCard();
         _loc3_.index = param1 + "_" + param2;
         _loc4_ = PositionUtils.creatPoint("pyramid.view.cardPos" + _loc3_.index);
         _loc3_.x = _loc4_.x;
         _loc3_.y = _loc4_.y;
         this._cards[param1][param2] = _loc3_;
         _loc3_.addEventListener(MouseEvent.CLICK,this.__cardClickHandler);
         _loc3_.addEventListener(PyramidEvent.OPENANDCLOSE_MOVIE,this.__cardOpenMovieHandler);
         this._cardsSprite.addChild(_loc3_);
      }
      
      public function topBoxMovieMode(param1:int = 0) : void
      {
         this._topBox.topBoxMovieMode(param1);
      }
      
      private function __cardClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:pyramid.view.PyramidCard = null;
         SoundManager.instance.play("008");
         if(PyramidManager.instance.clickRateGo)
         {
            return;
         }
         if(PyramidManager.instance.movieLock)
         {
            return;
         }
         if(!PyramidManager.instance.model.isOpen)
         {
            return;
         }
         if(param1.currentTarget == this._topBox && this._topBox.state == 1)
         {
            this.openTopBox();
         }
         else if(param1.currentTarget is PyramidCard && !PyramidManager.instance.isAutoOpenCard)
         {
            _loc2_ = PyramidCard(param1.currentTarget);
            this.openCurrendCard(_loc2_);
         }
      }
      
      private function openTopBox() : void
      {
         this._currentCard = null;
         this.topBoxMovieMode(2);
         GameInSocketOut.sendPyramidTurnCard(8,1);
      }
      
      private function openCurrendCard(param1:pyramid.view.PyramidCard) : void
      {
         this._currentCard = param1;
         if(this._currentCard.state != 3)
         {
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:int = PyramidManager.instance.model.freeCount - PyramidManager.instance.model.currentFreeCount;
         if(_loc2_ <= 0)
         {
            if(PlayerManager.Instance.Self.Money < PyramidManager.instance.model.turnCardPrice)
            {
               LeavePageManager.showFillFrame();
               PyramidManager.instance.isAutoOpenCard = false;
               return;
            }
         }
         var _loc3_:Array = this._currentCard.index.split("_");
         if(_loc2_ <= 0 && PyramidManager.instance.isShowBuyFrameSelectedCheck)
         {
            PyramidManager.instance.showFrame(5,_loc3_);
            return;
         }
         PyramidManager.instance.movieLock = true;
         GameInSocketOut.sendPyramidTurnCard(_loc3_[0],_loc3_[1]);
      }
      
      public function playTurnCardMovie() : void
      {
         PyramidManager.instance.movieLock = true;
         this._movieCountArr = [1,0];
         var _loc1_:int = PyramidManager.instance.model.currentLayer;
         var _loc2_:int = PyramidManager.instance.model.templateID;
         var _loc3_:PyramidSystemItemsInfo = PyramidManager.instance.model.getLevelCardItem(_loc1_,_loc2_);
         this._currentCard.cardState(2,_loc3_);
         this.checkAutoOpenCard();
      }
      
      private function __cardOpenMovieHandler(param1:PyramidEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(!this._movieCountArr)
         {
            return;
         }
         var _loc5_:int = int(this._movieCountArr[0]);
         var _loc6_:int = int(this._movieCountArr[1]);
         _loc6_++;
         this._movieCountArr[1] = _loc6_;
         if(_loc5_ == _loc6_)
         {
            this._movieCountArr = null;
            if(this._playLevelMovieStep == 1)
            {
               _loc2_ = PyramidManager.instance.model.getLevelCardItems(this._playLevel);
               _loc3_ = 9 - this._playLevel;
               _loc4_ = _loc2_.length / (9 - this._playLevel);
               if(_loc2_.length % _loc3_ > 0)
               {
                  _loc4_++;
               }
               this._shuffleWaitTimer.repeatCount = _loc4_;
               this._timerCurrentCount = 0;
               this._shuffleWaitTimer.reset();
               this._shuffleWaitTimer.start();
            }
            else if(this._playLevelMovieStep == 2)
            {
               this.playShuffleMovie();
            }
            else
            {
               PyramidManager.instance.movieLock = false;
               this.playShuffleFullMovie();
            }
         }
      }
      
      public function playShuffleFullMovie() : void
      {
         if(PyramidManager.instance.model.isShuffleMovie)
         {
            PyramidManager.instance.movieLock = true;
            this.playLevelMovie(PyramidManager.instance.model.currentLayer,BG);
            this.playLevelMovie(PyramidManager.instance.model.currentLayer,OPEN);
            this._playLevelMovieStep = 1;
         }
      }
      
      private function __shuffleWaitTimerHandler(param1:TimerEvent) : void
      {
         ++this._timerCurrentCount;
         if(this._timerCurrentCount >= this._shuffleWaitTimer.repeatCount)
         {
            this.playLevelMovie(this._playLevel,CLOSE);
            this._shuffleWaitTimer.stop();
            this._playLevelMovieStep = 2;
         }
         else
         {
            this.cardLevelTimerDataUpdate(this._playLevel,this._timerCurrentCount);
         }
      }
      
      private function playShuffleMovie() : void
      {
         this.cardLevelVisible(this._playLevel,false);
         this.playLevelMovie(this._playLevel,SHUFFLE);
         this._playLevelMovieStep = 3;
      }
      
      private function shuffleFrameScript() : void
      {
         if(Boolean(this._cards))
         {
            this.cardLevelState(this._playLevel,3);
            this.cardLevelVisible(this._playLevel,true);
         }
         this._playLevelMovieStep = 0;
         PyramidManager.instance.movieLock = false;
         this.checkAutoOpenCard();
      }
      
      public function checkAutoOpenCard() : void
      {
         if(this._timerOutNum != 0)
         {
            clearTimeout(this._timerOutNum);
         }
         this._timerOutNum = setTimeout(this.exeAutoOpenCard,1000);
      }
      
      private function exeAutoOpenCard() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Dictionary = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:pyramid.view.PyramidCard = null;
         if(PyramidManager.instance.model.isPyramidStart && PyramidManager.instance.isAutoOpenCard)
         {
            if(PyramidManager.instance.model.currentLayer >= 8)
            {
               this.openTopBox();
               --PyramidManager.instance.autoCount;
               if(PyramidManager.instance.autoCount > 0)
               {
                  PyramidManager.instance.isAutoOpenCard = true;
               }
               else
               {
                  PyramidManager.instance.isAutoOpenCard = false;
               }
            }
            else
            {
               _loc1_ = [];
               _loc2_ = Dictionary(this._cards[this._playLevel]);
               _loc3_ = 1;
               while(_loc3_ <= 9 - this._playLevel)
               {
                  if(_loc2_[_loc3_].state == 3)
                  {
                     _loc1_.push(_loc3_);
                  }
                  _loc3_++;
               }
               if(_loc1_.length > 0)
               {
                  _loc4_ = int(Math.random() * _loc1_.length);
                  _loc5_ = this._cards[this._playLevel][_loc1_[_loc4_]];
                  this.openCurrendCard(_loc5_);
               }
            }
         }
      }
      
      public function playLevelMovie(param1:int, param2:String) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:Array = null;
         var _loc5_:Dictionary = null;
         var _loc6_:int = 0;
         var _loc7_:PyramidSystemItemsInfo = null;
         var _loc8_:Dictionary = null;
         var _loc9_:pyramid.view.PyramidCard = null;
         this._playLevel = param1;
         if(param2 == SHUFFLE || param2 == BG)
         {
            this._shuffleMovie.visible = true;
            this._shuffleMovie.gotoAndStop(this._playLevel);
            _loc3_ = MovieClip(this._shuffleMovie["level" + this._playLevel]);
            if(Boolean(_loc3_))
            {
               if(param2 == SHUFFLE)
               {
                  _loc3_.addFrameScript(_loc3_.totalFrames - 2,this.shuffleFrameScript);
                  _loc3_.gotoAndPlay(param2);
               }
               else
               {
                  _loc3_.gotoAndStop(param2);
               }
            }
         }
         else if(param2 == OPEN)
         {
            _loc4_ = PyramidManager.instance.model.getLevelCardItems(this._playLevel);
            _loc5_ = Dictionary(this._cards[this._playLevel]);
            _loc6_ = 1;
            while(_loc6_ <= 9 - this._playLevel)
            {
               _loc7_ = _loc4_[_loc6_ - 1];
               _loc5_[_loc6_].cardState(2,_loc7_);
               _loc6_++;
            }
            this._movieCountArr = [9 - this._playLevel,0];
            PyramidManager.instance.movieLock = true;
         }
         else if(param2 == CLOSE)
         {
            _loc8_ = Dictionary(this._cards[this._playLevel]);
            for each(_loc9_ in _loc8_)
            {
               _loc9_.cardState(4);
            }
            this._movieCountArr = [9 - this._playLevel,0];
            PyramidManager.instance.movieLock = true;
         }
      }
      
      private function cardLevelVisible(param1:int, param2:Boolean) : void
      {
         var _loc3_:pyramid.view.PyramidCard = null;
         var _loc4_:Dictionary = Dictionary(this._cards[param1]);
         for each(_loc3_ in _loc4_)
         {
            _loc3_.visible = param2;
         }
      }
      
      private function cardLevelState(param1:int, param2:int) : void
      {
         var _loc3_:pyramid.view.PyramidCard = null;
         var _loc4_:Dictionary = Dictionary(this._cards[param1]);
         for each(_loc3_ in _loc4_)
         {
            _loc3_.cardState(param2);
         }
      }
      
      private function cardLevelTimerDataUpdate(param1:int, param2:int) : void
      {
         var _loc3_:PyramidSystemItemsInfo = null;
         var _loc4_:int = 0;
         if(param2 > 0)
         {
            _loc4_ = param2 * (9 - param1);
         }
         var _loc5_:Array = PyramidManager.instance.model.getLevelCardItems(param1);
         var _loc6_:Dictionary = Dictionary(this._cards[param1]);
         var _loc7_:int = 1;
         while(_loc7_ <= 9 - param1)
         {
            if(_loc5_.length <= _loc4_)
            {
               break;
            }
            _loc3_ = _loc5_[_loc4_];
            _loc6_[_loc7_].cardState(5,_loc3_);
            _loc4_++;
            _loc7_++;
         }
      }
      
      public function updateSelectItems() : void
      {
         var _loc1_:Dictionary = null;
         var _loc2_:* = null;
         var _loc3_:Dictionary = null;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:PyramidSystemItemsInfo = null;
         var _loc8_:Dictionary = null;
         var _loc9_:pyramid.view.PyramidCard = null;
         if(PyramidManager.instance.model.isPyramidStart)
         {
            _loc1_ = PyramidManager.instance.model.selectLayerItems;
            for(_loc2_ in _loc1_)
            {
               _loc3_ = _loc1_[_loc2_];
               for(_loc4_ in _loc3_)
               {
                  _loc5_ = int(_loc3_[_loc4_]);
                  _loc6_ = int(_loc2_);
                  _loc7_ = PyramidManager.instance.model.getLevelCardItem(_loc6_,_loc5_);
                  PyramidCard(this._cards[_loc2_][_loc4_]).cardState(1,_loc7_);
               }
            }
            if(!PyramidManager.instance.model.isShuffleMovie && PyramidManager.instance.model.isPyramidStart && PyramidManager.instance.model.currentLayer < 8)
            {
               this.playLevelMovie(PyramidManager.instance.model.currentLayer,BG);
               _loc8_ = Dictionary(this._cards[PyramidManager.instance.model.currentLayer]);
               for each(_loc9_ in _loc8_)
               {
                  if(_loc9_.state == 0)
                  {
                     _loc9_.cardState(3);
                  }
               }
            }
         }
         else if(PyramidManager.instance.movieLock && Boolean(this._cardsSprite))
         {
            if(!this._cardsSprite.hasEventListener(Event.ENTER_FRAME))
            {
               this._cardsSprite.addEventListener(Event.ENTER_FRAME,this.__delayReset);
            }
         }
         else
         {
            this.reset();
         }
      }
      
      private function __delayReset(param1:Event) : void
      {
         if(!PyramidManager.instance.movieLock)
         {
            this.reset();
            this._cardsSprite.removeEventListener(Event.ENTER_FRAME,this.__delayReset);
         }
      }
      
      public function upClear() : void
      {
         var _loc1_:Dictionary = null;
         var _loc2_:pyramid.view.PyramidCard = null;
         if(!PyramidManager.instance.model.isUp)
         {
            return;
         }
         var _loc3_:int = PyramidManager.instance.model.currentLayer;
         if(_loc3_ - 1 > 0)
         {
            _loc1_ = Dictionary(this._cards[_loc3_ - 1]);
            for each(_loc2_ in _loc1_)
            {
               if(_loc2_.state == 3)
               {
                  _loc2_.cardState(0);
               }
            }
         }
      }
      
      public function reset() : void
      {
         var _loc1_:Dictionary = null;
         var _loc2_:pyramid.view.PyramidCard = null;
         for each(_loc1_ in this._cards)
         {
            for each(_loc2_ in _loc1_)
            {
               _loc2_.reset();
            }
         }
         this._playLevelMovieStep = 0;
         this._timerCurrentCount = 0;
         this._shuffleMovie.gotoAndStop(1);
         this._shuffleMovie.visible = false;
         this.topBoxMovieMode();
      }
      
      public function dispose() : void
      {
         var _loc1_:Dictionary = null;
         var _loc2_:pyramid.view.PyramidCard = null;
         if(this._timerOutNum != 0)
         {
            clearTimeout(this._timerOutNum);
         }
         PyramidManager.instance.isAutoOpenCard = false;
         this._topBox.removeEventListener(MouseEvent.CLICK,this.__cardClickHandler);
         this._shuffleWaitTimer.stop();
         this._shuffleWaitTimer.removeEventListener(TimerEvent.TIMER,this.__shuffleWaitTimerHandler);
         this._shuffleWaitTimer = null;
         for each(_loc1_ in this._cards)
         {
            for each(_loc2_ in _loc1_)
            {
               _loc2_.removeEventListener(MouseEvent.CLICK,this.__cardClickHandler);
               _loc2_.removeEventListener(PyramidEvent.OPENANDCLOSE_MOVIE,this.__cardOpenMovieHandler);
               _loc2_.dispose();
            }
         }
         this._cards = null;
         this._currentCard = null;
         this._movieCountArr = null;
         if(Boolean(this._cardsSprite))
         {
            this._cardsSprite.removeEventListener(Event.ENTER_FRAME,this.__delayReset);
            ObjectUtils.disposeAllChildren(this._cardsSprite);
            ObjectUtils.disposeObject(this._cardsSprite);
            this._cardsSprite = null;
         }
         ObjectUtils.disposeObject(this._topBox);
         this._topBox = null;
         ObjectUtils.disposeObject(this._shuffleMovie);
         this._shuffleMovie = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
