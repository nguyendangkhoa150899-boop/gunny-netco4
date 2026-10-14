package church.view.churchScene
{
   import church.model.ChurchRoomModel;
   import church.player.ChurchPlayer;
   import church.view.churchFire.ChurchFireEffectPlayer;
   import church.vo.FatherBallConfigVO;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ChurchRoomInfo;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.ChurchManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.BitmapUtils;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import road7th.data.DictionaryData;
   
   public class WeddingSceneMap extends SceneMap
   {
      
      public static const MOVE_SPEED:Number = 0.055;
      
      public static const MOVE_SPEEDII:Number = 0.15;
       
      
      private var _model:ChurchRoomModel;
      
      private var father_read:MovieClip;
      
      private var father_com:MovieClip;
      
      private var bride:ChurchPlayer;
      
      private var groom:ChurchPlayer;
      
      private var guestPos:Array;
      
      private var _fatherPaopaoBg:ScaleFrameImage;
      
      private var _fatherPaopao:ScaleFrameImage;
      
      private var _fatherPaopaoConfig:Array;
      
      private var frame:uint = 1;
      
      private var _brideName:FilterFrameText;
      
      private var _groomName:FilterFrameText;
      
      private var kissMovie:MovieClip;
      
      private var fireTimer:Timer;
      
      public function WeddingSceneMap(param1:ChurchRoomModel, param2:SceneScene, param3:DictionaryData, param4:Sprite, param5:Sprite, param6:Sprite = null, param7:Sprite = null)
      {
         this._fatherPaopaoConfig = [];
         this._model = param1;
         super(this._model,param2,param3,param4,param5,param6,param7);
         SoundManager.instance.playMusic("3002");
         this.initFather();
      }
      
      private function initFather() : void
      {
         if(bgLayer != null)
         {
            this.father_read = bgLayer.getChildByName("father_read") as MovieClip;
            this.father_com = bgLayer.getChildByName("father_com") as MovieClip;
            if(Boolean(this.father_read))
            {
               this.father_read.visible = false;
            }
         }
      }
      
      public function fireImdily(param1:Point, param2:uint, param3:Boolean = false) : void
      {
         var _loc4_:ChurchFireEffectPlayer = null;
         _loc4_ = null;
         if(param2 > 1)
         {
            return;
         }
         var _loc5_:int = int(this._model.fireTemplateIDList[param2]);
         _loc4_ = new ChurchFireEffectPlayer(_loc5_);
         _loc4_.x = param1.x;
         _loc4_.y = param1.y;
         addChild(_loc4_);
         _loc4_.firePlayer(param3);
      }
      
      public function playWeddingMovie() : void
      {
         var _loc1_:Point = null;
         _loc1_ = null;
         this.bride = _characters[ChurchManager.instance.currentRoom.brideID] as ChurchPlayer;
         this.groom = _characters[ChurchManager.instance.currentRoom.groomID] as ChurchPlayer;
         this.bride.moveSpeed = MOVE_SPEED;
         this.groom.moveSpeed = MOVE_SPEED;
         _loc1_ = ComponentFactory.Instance.creatCustomObject("church.WeddingSceneMap.bridePos");
         this.bride.x = _loc1_.x;
         this.bride.y = _loc1_.y;
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("church.WeddingSceneMap.groomPos");
         this.groom.x = _loc2_.x;
         this.groom.y = _loc2_.y;
         this.rangeGuest();
         ajustScreen(this.bride);
         this.bride.addEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP,this.__arrive);
         this.groom.addEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP,this.__arrive);
         this.bride.sceneCharacterActionType = "naturalWalkBack";
         this.bride.playerVO.walkPath = [new Point(1104,660)];
         this.bride.playerWalk(this.bride.playerVO.walkPath);
         this.groom.sceneCharacterActionType = "naturalWalkBack";
         this.groom.playerVO.walkPath = [new Point(1003,651)];
         this.groom.playerWalk(this.groom.playerVO.walkPath);
      }
      
      public function stopWeddingMovie() : void
      {
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("church.WeddingSceneMap.bridePosII");
         this.bride.x = _loc1_.x;
         this.bride.y = _loc1_.y;
         this.bride.sceneCharacterDirection = SceneCharacterDirection.LB;
         this.groom.moveSpeed = MOVE_SPEEDII;
         this.groom.moveSpeed = MOVE_SPEEDII;
         ajustScreen(_selfPlayer);
         setCenter(null);
         if(Boolean(this.father_read))
         {
            this.father_read.visible = false;
         }
         if(Boolean(this.father_com))
         {
            this.father_com.visible = true;
         }
         this.hideDialogue();
         this.stopKissMovie();
         this.stopFireMovie();
         this.bride.removeEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP,this.__arrive);
      }
      
      private function __arrive(param1:SceneCharacterEvent) : void
      {
         this.bride.removeEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP,this.__arrive);
         this.groom.removeEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP,this.__arrive);
         ajustScreen(null);
         this.bride.sceneCharacterActionType = "naturalStandFront";
         this.groom.sceneCharacterActionType = "naturalStandFront";
         this.bride.sceneCharacterDirection = SceneCharacterDirection.LB;
         this.groom.sceneCharacterDirection = SceneCharacterDirection.LB;
         this.playDialogue();
      }
      
      public function rangeGuest() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:ChurchPlayer = null;
         this.getGuestPos();
         var _loc4_:Array = _characters.list;
         _loc4_.sortOn("ID",Array.NUMERIC);
         while(_loc2_ < _characters.length)
         {
            _loc3_ = _loc4_[_loc2_] as ChurchPlayer;
            if(!ChurchManager.instance.isAdmin(_loc3_.playerVO.playerInfo))
            {
               if(Boolean(_loc1_ % 2))
               {
                  _loc3_.x = (this.guestPos[0][0] as Point).x;
                  _loc3_.y = (this.guestPos[0][0] as Point).y;
                  (this.guestPos[0] as Array).shift();
                  _loc3_.sceneCharacterActionType = "naturalStandBack";
                  _loc3_.sceneCharacterDirection = SceneCharacterDirection.RT;
               }
               else
               {
                  _loc3_.x = (this.guestPos[1][0] as Point).x;
                  _loc3_.y = (this.guestPos[1][0] as Point).y;
                  (this.guestPos[1] as Array).shift();
                  _loc3_.sceneCharacterActionType = "naturalStandBack";
                  _loc3_.sceneCharacterDirection = SceneCharacterDirection.LT;
                  if((this.guestPos[1] as Array).length == 0)
                  {
                     this.guestPos.shift();
                     this.guestPos.shift();
                  }
               }
               _loc1_++;
            }
            _loc2_++;
         }
      }
      
      private function getGuestPos() : void
      {
         var _loc1_:uint = 0;
         this.guestPos = [];
         var _loc2_:Class = ClassUtils.uiSourceDomain.getDefinition("asset.church.room.GuestLineAsset") as Class;
         var _loc3_:MovieClip = new _loc2_() as MovieClip;
         addChild(_loc3_);
         var _loc4_:uint = 1;
         while(_loc4_ <= 8)
         {
            if(_loc4_ == 1 || _loc4_ == 2)
            {
               _loc1_ = 19;
               this.guestPos.push(this.spliceLine(_loc3_["line" + _loc4_],_loc1_,false,false));
            }
            else if(_loc4_ == 3 || _loc4_ == 5 || _loc4_ == 7)
            {
               _loc1_ = 9;
               this.guestPos.push(this.spliceLine(_loc3_["line" + _loc4_],_loc1_,false,true));
            }
            else
            {
               _loc1_ = 9;
               this.guestPos.push(this.spliceLine(_loc3_["line" + _loc4_],_loc1_,true,false));
            }
            _loc4_++;
         }
         removeChild(_loc3_);
      }
      
      private function spliceLine(param1:DisplayObject, param2:uint, param3:Boolean, param4:Boolean) : Array
      {
         var _loc5_:uint = 0;
         var _loc6_:Point = null;
         var _loc7_:Number = param1.width / param2;
         var _loc8_:Number = param1.height / param2;
         var _loc9_:int = param3 ? int(1) : int(-1);
         var _loc10_:int = param4 ? int(-1) : int(1);
         var _loc11_:Array = [];
         while(_loc5_ <= param2)
         {
            _loc6_ = new Point();
            _loc6_.x = param1.x + _loc7_ * _loc5_ * _loc9_;
            _loc6_.y = param1.y + _loc8_ * _loc5_ * _loc10_;
            _loc11_.push(_loc6_);
            _loc5_++;
         }
         return _loc11_;
      }
      
      private function playDialogue() : void
      {
         var _loc1_:FatherBallConfigVO = null;
         this.frame = 1;
         if(Boolean(this.father_read))
         {
            this.father_read.visible = true;
         }
         if(Boolean(this.father_com))
         {
            this.father_com.visible = false;
         }
         var _loc2_:int = 0;
         while(_loc2_ < 23)
         {
            _loc1_ = ComponentFactory.Instance.creatCustomObject("church.room.FatherBallConfigVO" + (_loc2_ + 1));
            this._fatherPaopaoConfig.push(_loc1_);
            _loc2_++;
         }
         this._fatherPaopaoBg = ComponentFactory.Instance.creatComponentByStylename("church.room.FatherPaopaoBg");
         this._fatherPaopaoBg.setFrame(this.frame);
         addChild(this._fatherPaopaoBg);
         this._fatherPaopao = ComponentFactory.Instance.creatComponentByStylename("church.room.FatherPaopao");
         this._fatherPaopao.setFrame(this.frame);
         addChild(this._fatherPaopao);
         this.playerFatherPaopaoFrame();
      }
      
      private function playerFatherPaopaoFrame() : void
      {
         var _loc1_:Shape = null;
         ObjectUtils.disposeObject(this._brideName);
         this._brideName = null;
         ObjectUtils.disposeObject(this._groomName);
         this._groomName = null;
         if(!this._fatherPaopaoBg || !this._fatherPaopao)
         {
            return;
         }
         if(this._fatherPaopao.getFrame >= this._fatherPaopao.totalFrames)
         {
            this.hideDialogue();
            this.readyForKiss();
            return;
         }
         this._fatherPaopaoBg.setFrame(this.frame);
         this._fatherPaopao.setFrame(this.frame);
         switch(this.frame)
         {
            case 3:
               this._brideName = ComponentFactory.Instance.creat("church.room.FatherPaopaoBrideName");
               this._brideName.text = ChurchManager.instance.currentRoom.brideName;
               addChild(this._brideName);
               break;
            case 7:
               this._groomName = ComponentFactory.Instance.creat("church.room.FatherPaopaoGroomName");
               this._groomName.text = ChurchManager.instance.currentRoom.groomName;
               addChild(this._groomName);
               break;
            case 22:
               this._groomName = ComponentFactory.Instance.creat("church.room.FatherPaopaoGroomName2");
               this._groomName.text = ChurchManager.instance.currentRoom.groomName;
               addChild(this._groomName);
               this._brideName = ComponentFactory.Instance.creat("church.room.FatherPaopaoBrideName2");
               this._brideName.text = ChurchManager.instance.currentRoom.brideName;
               addChild(this._brideName);
         }
         var _loc2_:FatherBallConfigVO = this._fatherPaopaoConfig[this.frame - 1] as FatherBallConfigVO;
         if(_loc2_.isMask == "true")
         {
            _loc1_ = new Shape();
            _loc1_.x = this._fatherPaopao.x + this._fatherPaopao.getFrameImage(this.frame - 1).x;
            _loc1_.y = this._fatherPaopao.y + this._fatherPaopao.getFrameImage(this.frame - 1).y;
         }
         ++this.frame;
         BitmapUtils.maskMovie(this._fatherPaopao,_loc1_,_loc2_.isMask,_loc2_.rowNumber,_loc2_.rowWitdh,_loc2_.rowHeight,_loc2_.frameStep,_loc2_.sleepSecond,this.playerFatherPaopaoFrame);
      }
      
      private function readyForKiss() : void
      {
         this.bride.moveSpeed = 0.025;
         this.groom.moveSpeed = 0.025;
         this.groom.sceneCharacterActionType = "naturalWalkFront";
         this.groom.playerVO.walkPath = [new Point(1026,666)];
         this.groom.playerWalk(this.groom.playerVO.walkPath);
         this.bride.sceneCharacterActionType = "naturalWalkBack";
         this.bride.playerVO.walkPath = [new Point(1060,707),new Point(1044,694)];
         this.bride.playerWalk(this.bride.playerVO.walkPath);
         this.playKissMovie();
         this.playFireMovie();
         this.ajustPosition();
      }
      
      private function ajustPosition() : void
      {
         SocketManager.Instance.out.sendPosition(_selfPlayer.x,_selfPlayer.y);
      }
      
      private function hideDialogue() : void
      {
         ObjectUtils.disposeObject(this._fatherPaopaoBg);
         this._fatherPaopaoBg = null;
         ObjectUtils.disposeObject(this._fatherPaopao);
         this._fatherPaopao = null;
         if(Boolean(this.father_read))
         {
            this.father_read.visible = false;
         }
         if(Boolean(this.father_com))
         {
            this.father_com.visible = true;
         }
      }
      
      private function playKissMovie() : void
      {
         var _loc1_:Class = ClassUtils.uiSourceDomain.getDefinition("tank.church.KissMovie") as Class;
         this.kissMovie = new _loc1_() as MovieClip;
         this.kissMovie.x = 1040;
         this.kissMovie.y = 610;
         addChild(this.kissMovie);
      }
      
      private function stopKissMovie() : void
      {
         if(Boolean(this.kissMovie))
         {
            removeChild(this.kissMovie);
         }
         this.kissMovie = null;
      }
      
      public function playFireMovie() : void
      {
         this.fireTimer = new Timer(100);
         this.fireTimer.addEventListener(TimerEvent.TIMER,this.__fireTimer);
         this.fireTimer.start();
      }
      
      private function __fireTimer(param1:TimerEvent) : void
      {
         var _loc2_:Point = null;
         var _loc3_:uint = 0;
         var _loc4_:Boolean = false;
         _loc2_ = this.getFirePosition();
         _loc3_ = Math.round(Math.random() * 3);
         _loc4_ = !(Math.round(Math.random() * 9) % 3) ? Boolean(true) : Boolean(false);
         this.fireImdily(_loc2_,_loc3_,_loc4_);
      }
      
      private function getFirePosition() : Point
      {
         var _loc1_:Point = null;
         var _loc2_:Number = Math.round(Math.random() * (1000 - 100)) + 50;
         var _loc3_:Number = Math.round(Math.random() * (600 - 100)) + 50;
         return this.globalToLocal(new Point(_loc2_,_loc3_));
      }
      
      private function __fireTimerComplete(param1:TimerEvent) : void
      {
         if(!this.fireTimer)
         {
            return;
         }
         this.fireTimer.stop();
         this.fireTimer.removeEventListener(TimerEvent.TIMER,this.__fireTimer);
         this.fireTimer = null;
      }
      
      private function stopFireMovie() : void
      {
         this.__fireTimerComplete(null);
      }
      
      override protected function __click(param1:MouseEvent) : void
      {
         if(ChurchManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_ING)
         {
            return;
         }
         super.__click(param1);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this.bride))
         {
            this.bride.removeEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP,this.__arrive);
         }
         if(Boolean(this.groom))
         {
            this.groom.removeEventListener(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP,this.__arrive);
         }
         if(Boolean(this.fireTimer))
         {
            this.fireTimer.stop();
            this.fireTimer.removeEventListener(TimerEvent.TIMER,this.__fireTimer);
         }
         this.fireTimer = null;
         this.stopKissMovie();
         this.stopFireMovie();
         ObjectUtils.disposeObject(this._fatherPaopaoBg);
         this._fatherPaopaoBg = null;
         ObjectUtils.disposeObject(this._fatherPaopao);
         this._fatherPaopao = null;
         if(Boolean(this.father_read) && Boolean(this.father_read.parent))
         {
            this.father_read.parent.removeChild(this.father_read);
         }
         this.father_read = null;
         if(Boolean(this.father_com) && Boolean(this.father_com.parent))
         {
            this.father_com.parent.removeChild(this.father_com);
         }
         this.father_com = null;
         this.bride = null;
         this.groom = null;
         if(Boolean(parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
