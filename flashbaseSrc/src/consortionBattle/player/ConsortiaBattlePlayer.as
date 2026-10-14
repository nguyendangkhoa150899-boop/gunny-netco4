package consortionBattle.player
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import consortionBattle.view.ConsBatResurrectView;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import flash.utils.setTimeout;
   
   public class ConsortiaBattlePlayer extends ConsortiaBattlePlayerBase implements Disposeable
   {
      
      public static const CLICK:String = "consBatPlayerClick";
       
      
      private var _playerData:consortionBattle.player.ConsortiaBattlePlayerInfo;
      
      private var _swordIcon:MovieClip;
      
      private var _consortiaNameTxt:FilterFrameText;
      
      private var _tombstone:MovieClip;
      
      private var _fighting:MovieClip;
      
      private var _resurrectView:ConsBatResurrectView;
      
      private var _resurrectCartoon:MovieClip;
      
      private var _winningStreakMc:MovieClip;
      
      private var _character:Sprite;
      
      private var _isJustWin:Boolean;
      
      public function ConsortiaBattlePlayer(param1:consortionBattle.player.ConsortiaBattlePlayerInfo, param2:Function = null)
      {
         this._playerData = param1;
         super(param1,param2);
         this._character = character;
         this.initView();
         this.initEvent();
      }
      
      protected function initView() : void
      {
         this._consortiaNameTxt = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.consortiaNameTxt");
         this._consortiaNameTxt.text = this._playerData.consortiaName;
         if(this._playerData.id == PlayerManager.Instance.Self.ID)
         {
            this._consortiaNameTxt.textColor = 65280;
         }
         else if(this._playerData.selfOrEnemy == 1)
         {
            this._consortiaNameTxt.textColor = 52479;
         }
         else
         {
            this._consortiaNameTxt.textColor = 16711680;
         }
         addChild(this._consortiaNameTxt);
         this._tombstone = ComponentFactory.Instance.creat("asset.consortiaBattle.tombstone");
         PositionUtils.setPos(this._tombstone,"consortiaBattle.tombstonePos");
         this._tombstone.gotoAndStop(1);
         this._tombstone.visible = false;
         addChild(this._tombstone);
         this._fighting = ComponentFactory.Instance.creat("asset.consortiaBattle.fighting");
         PositionUtils.setPos(this._fighting,"consortiaBattle.fightingPos");
         this._fighting.gotoAndStop(2);
         this._fighting.visible = false;
         addChild(this._fighting);
         this._winningStreakMc = ComponentFactory.Instance.creat("asset.consortiaBattle.winningStreak.iconMc");
         PositionUtils.setPos(this._winningStreakMc,"consortiaBattle.winningStreakMcPos");
         this._winningStreakMc.gotoAndStop(1);
         addChild(this._winningStreakMc);
         this.refreshStatus();
      }
      
      public function refreshStatus() : void
      {
         var _loc1_:int = 0;
         _loc1_ = int((this._playerData.tombstoneEndTime.getTime() - TimeManager.Instance.Now().getTime()) / 1000);
         if(this.isInTomb && _loc1_ <= 0)
         {
            this.resurrectHandler();
            return;
         }
         if(_loc1_ > 0)
         {
            this._character.visible = false;
            this._fighting.gotoAndStop(2);
            this._fighting.visible = false;
            this._tombstone.visible = true;
            this._tombstone.gotoAndPlay(1);
            this.createRrsurrectView(_loc1_);
            this._consortiaNameTxt.y = -79;
         }
         else if(this._playerData.status == 2)
         {
            this._character.visible = true;
            this._fighting.gotoAndStop(1);
            this._fighting.visible = true;
            this._tombstone.visible = false;
            this._tombstone.gotoAndStop(1);
            this._consortiaNameTxt.y = -160;
         }
         else
         {
            this._character.visible = true;
            this._fighting.gotoAndStop(2);
            if(this._fighting.visible)
            {
               this._isJustWin = true;
               setTimeout(this.canClickedFight,7000);
            }
            this._fighting.visible = false;
            this._tombstone.visible = false;
            this._tombstone.gotoAndStop(1);
            this._consortiaNameTxt.y = -160;
         }
         if(this._playerData.winningStreak >= 10)
         {
            this._winningStreakMc.gotoAndStop(4);
         }
         else if(this._playerData.winningStreak >= 6)
         {
            this._winningStreakMc.gotoAndStop(3);
         }
         else if(this._playerData.winningStreak >= 3)
         {
            this._winningStreakMc.gotoAndStop(2);
         }
         else if(this._playerData.failBuffCount > 0)
         {
            this._winningStreakMc.gotoAndStop(5);
         }
         else
         {
            this._winningStreakMc.gotoAndStop(1);
         }
         this.visible = ConsortiaBattleManager.instance.judgePlayerVisible(this);
         if(Boolean(parent))
         {
            playerPoint = this._playerData.pos;
         }
      }
      
      private function canClickedFight() : void
      {
         this._isJustWin = false;
      }
      
      private function createRrsurrectView(param1:int) : void
      {
         var _loc2_:Point = null;
         _loc2_ = null;
         if(Boolean(this._resurrectView))
         {
            return;
         }
         if(this._playerData.id == PlayerManager.Instance.Self.ID)
         {
            this._resurrectView = new ConsBatResurrectView(param1);
            _loc2_ = this.localToGlobal(new Point(-113,-121));
            this._resurrectView.x = _loc2_.x;
            this._resurrectView.y = _loc2_.y;
            LayerManager.Instance.addToLayer(this._resurrectView,LayerManager.GAME_DYNAMIC_LAYER);
         }
      }
      
      private function resurrectHandler() : void
      {
         if(Boolean(this._resurrectView))
         {
            ObjectUtils.disposeObject(this._resurrectView);
            this._resurrectView = null;
         }
         this._resurrectCartoon = ComponentFactory.Instance.creat("asset.consortiaBattle.resurrectCartoon");
         this._resurrectCartoon.addEventListener(Event.COMPLETE,this.cartoonCompleteHandler,false,0,true);
         this._resurrectCartoon.gotoAndPlay(1);
         addChild(this._resurrectCartoon);
      }
      
      private function cartoonCompleteHandler(param1:Event) : void
      {
         if(Boolean(this._resurrectCartoon))
         {
            this._resurrectCartoon.removeEventListener(Event.COMPLETE,this.cartoonCompleteHandler);
            removeChild(this._resurrectCartoon);
            this._resurrectCartoon = null;
         }
         this._tombstone.visible = false;
         this.refreshStatus();
         if(this._playerData.id == PlayerManager.Instance.Self.ID)
         {
            dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_MOVEMENT));
         }
      }
      
      protected function initEvent() : void
      {
         var _loc1_:Sprite = character;
         _loc1_.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
         _loc1_.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
         _loc1_.addEventListener(MouseEvent.CLICK,this.mouseClickHandler);
         addEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.characterDirectionChange);
      }
      
      private function mouseClickHandler(param1:MouseEvent) : void
      {
         if(this.isCanBeFight)
         {
            if(this._isJustWin)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.justWinProtectTxt"),0,true);
            }
            else
            {
               dispatchEvent(new Event(CLICK,true));
            }
         }
      }
      
      private function mouseOverHandler(param1:MouseEvent) : void
      {
         if(this.isCanBeFight)
         {
            setCharacterFilter(true);
            this.showSwordMouse();
         }
      }
      
      private function showSwordMouse() : void
      {
         if(!this._swordIcon)
         {
            this._swordIcon = ComponentFactory.Instance.creat("asset.consortiaBattle.overEnemySword");
            this._swordIcon.mouseChildren = false;
            this._swordIcon.mouseEnabled = false;
            LayerManager.Instance.addToLayer(this._swordIcon,LayerManager.GAME_DYNAMIC_LAYER);
         }
         Mouse.hide();
         this._swordIcon.visible = true;
         var _loc1_:Sprite = character;
         _loc1_.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
      }
      
      private function mouseMoveHandler(param1:MouseEvent) : void
      {
         this._swordIcon.x = param1.stageX;
         this._swordIcon.y = param1.stageY;
      }
      
      private function hideSwordMouse() : void
      {
         var _loc1_:Sprite = character;
         if(Boolean(_loc1_))
         {
            _loc1_.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         }
         if(Boolean(this._swordIcon))
         {
            this._swordIcon.visible = false;
         }
         Mouse.show();
      }
      
      private function mouseOutHandler(param1:MouseEvent) : void
      {
         if(isEnemy)
         {
            setCharacterFilter(false);
            this.hideSwordMouse();
         }
      }
      
      private function get isCanBeFight() : Boolean
      {
         return isEnemy && !this._tombstone.visible && !this._fighting.visible && ConsortiaBattleManager.instance.beforeStartTime <= 0;
      }
      
      public function set setSceneCharacterDirectionDefault(param1:SceneCharacterDirection) : void
      {
         if(param1 == SceneCharacterDirection.LT || param1 == SceneCharacterDirection.RT)
         {
            if(sceneCharacterStateType == "natural")
            {
               sceneCharacterActionType = "naturalStandBack";
            }
         }
         else if(param1 == SceneCharacterDirection.LB || param1 == SceneCharacterDirection.RB)
         {
            if(sceneCharacterStateType == "natural")
            {
               sceneCharacterActionType = "naturalStandFront";
            }
         }
      }
      
      public function get isCanWalk() : Boolean
      {
         return !this._tombstone.visible && !this._fighting.visible;
      }
      
      public function updatePlayer() : void
      {
         this.refreshCharacterState();
         this.characterMirror();
         this.playerWalkPath();
         update();
      }
      
      public function refreshCharacterState() : void
      {
         if((sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT) && _tween.isPlaying)
         {
            sceneCharacterActionType = "naturalWalkBack";
         }
         else if((sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB) && _tween.isPlaying)
         {
            sceneCharacterActionType = "naturalWalkFront";
         }
      }
      
      private function characterMirror() : void
      {
         if(!isDefaultCharacter)
         {
            character.scaleX = sceneCharacterDirection.isMirror ? Number(Number(-1)) : Number(Number(1));
            character.x = sceneCharacterDirection.isMirror ? Number(Number(playerWitdh / 2)) : Number(Number(-playerWitdh / 2));
         }
         else
         {
            character.scaleX = 1;
            character.x = -playerWitdh / 2;
         }
         character.y = -playerHeight + 12;
      }
      
      private function playerWalkPath() : void
      {
         if((!walkPath || walkPath.length <= 0) && !_tween.isPlaying)
         {
            return;
         }
         playerWalk(walkPath);
      }
      
      public function get playerData() : consortionBattle.player.ConsortiaBattlePlayerInfo
      {
         return this._playerData;
      }
      
      public function get isInTomb() : Boolean
      {
         return this._tombstone.visible;
      }
      
      public function get isInFighting() : Boolean
      {
         return this._fighting.visible;
      }
      
      private function characterDirectionChange(param1:SceneCharacterEvent) : void
      {
         if(Boolean(param1.data))
         {
            if(sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT)
            {
               if(sceneCharacterStateType == "natural")
               {
                  sceneCharacterActionType = "naturalWalkBack";
               }
            }
            else if(sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB)
            {
               if(sceneCharacterStateType == "natural")
               {
                  sceneCharacterActionType = "naturalWalkFront";
               }
            }
         }
         else if(sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT)
         {
            if(sceneCharacterStateType == "natural")
            {
               sceneCharacterActionType = "naturalStandBack";
            }
         }
         else if(sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB)
         {
            if(sceneCharacterStateType == "natural")
            {
               sceneCharacterActionType = "naturalStandFront";
            }
         }
      }
      
      protected function removeEvent() : void
      {
         var _loc1_:Sprite = character;
         if(Boolean(_loc1_))
         {
            _loc1_.removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
            _loc1_.removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
            _loc1_.removeEventListener(MouseEvent.CLICK,this.mouseClickHandler);
         }
         removeEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.characterDirectionChange);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this._playerData = null;
         ObjectUtils.disposeObject(this._swordIcon);
         this._swordIcon = null;
         ObjectUtils.disposeObject(this._consortiaNameTxt);
         this._consortiaNameTxt = null;
         ObjectUtils.disposeObject(this._tombstone);
         this._tombstone = null;
         if(Boolean(this._fighting))
         {
            this._fighting.gotoAndStop(2);
         }
         ObjectUtils.disposeObject(this._fighting);
         this._fighting = null;
         if(Boolean(this._resurrectView))
         {
            ObjectUtils.disposeObject(this._resurrectView);
            this._resurrectView = null;
         }
         if(Boolean(this._resurrectCartoon))
         {
            this._resurrectCartoon.removeEventListener(Event.COMPLETE,this.cartoonCompleteHandler);
            removeChild(this._resurrectCartoon);
            this._resurrectCartoon = null;
         }
         this._character = null;
         super.dispose();
      }
   }
}
