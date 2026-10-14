package game.view
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayPool;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffType;
   import ddt.data.map.MissionInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.DungeonInfoEvent;
   import ddt.events.GameEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.BitmapManager;
   import ddt.manager.BuffManager;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.IMEManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.states.BaseStateView;
   import ddt.utils.MenoryUtil;
   import ddt.utils.PositionUtils;
   import ddt.view.MainToolBar;
   import ddt.view.chat.ChatBugleView;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import game.GameManager;
   import game.actions.ViewEachPlayerAction;
   import game.animations.DirectionMovingAnimation;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.model.Player;
   import game.model.TurnedLiving;
   import game.objects.GameLiving;
   import game.objects.GameLocalPlayer;
   import game.objects.GamePlayer;
   import game.view.buff.SelfBuffBar;
   import game.view.control.ControlState;
   import game.view.control.FightControlBar;
   import game.view.control.LiveState;
   import game.view.map.MapView;
   import game.view.playerThumbnail.PlayerThumbnailController;
   import game.view.propContainer.PlayerStateContainer;
   import road7th.data.DictionaryData;
   import road7th.data.StringObject;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import trainer.controller.NewHandGuideManager;
   import trainer.controller.WeakGuildManager;
   import trainer.data.Step;
   
   public class GameViewBase extends BaseStateView
   {
       
      
      protected var _arrowLeft:game.view.SpringArrowView;
      
      protected var _arrowRight:game.view.SpringArrowView;
      
      protected var _arrowUp:game.view.SpringArrowView;
      
      protected var _arrowDown:game.view.SpringArrowView;
      
      protected var _selfUsedProp:PlayerStateContainer;
      
      protected var _leftPlayerView:game.view.LeftPlayerCartoonView;
      
      protected var _missionHelp:game.view.DungeonHelpView;
      
      protected var _fightControlBar:FightControlBar;
      
      protected var _cs:ControlState;
      
      protected var _vane:game.view.VaneView;
      
      protected var _playerThumbnailLController:PlayerThumbnailController;
      
      protected var _map:MapView;
      
      protected var _players:Dictionary;
      
      protected var _gameInfo:GameInfo;
      
      protected var _selfGamePlayer:GameLocalPlayer;
      
      protected var _selfBuffBar:SelfBuffBar;
      
      protected var _selfMarkBar:game.view.SelfMarkBar;
      
      protected var _achievBar:game.view.FightAchievBar;
      
      private var _exitRoomTypeArray:Array;
      
      protected var _bitmapMgr:BitmapManager;
      
      protected var _barrier:game.view.DungeonInfoView;
      
      private const GUIDEID:int = 10029;
      
      protected var _barrierVisible:Boolean = true;
      
      protected var _gameCountDownView:game.view.GameCountDownView;
      
      public function GameViewBase()
      {
         this._exitRoomTypeArray = [RoomInfo.FRESHMAN_ROOM,RoomInfo.CONSORTIA_BATTLE,RoomInfo.RING_STATION,RoomInfo.ACTIVITY_DUNGEON_ROOM,RoomInfo.CATCH_BEAST];
         super();
      }
      
      override public function prepare() : void
      {
         super.prepare();
      }
      
      override public function fadingComplete() : void
      {
         super.fadingComplete();
         if(this._barrierVisible)
         {
            this.drawMissionInfo();
         }
         if(!RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this._cs = this._fightControlBar.setState(FightControlBar.LIVE);
         }
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         var _loc3_:Living = null;
         super.enter(param1,param2);
         this._bitmapMgr = BitmapManager.getBitmapMgr("GameView");
         SharedManager.Instance.propTransparent = false;
         this._gameInfo = GameManager.Instance.Current;
         MainToolBar.Instance.hide();
         LayerManager.Instance.clearnStageDynamic();
         ChatBugleView.instance.hide();
         PlayerManager.Instance.Self.TempBag.clearnAll();
         GameManager.Instance.Current.selfGamePlayer.petSkillEnabled = true;
         for each(_loc3_ in this._gameInfo.livings)
         {
            if(_loc3_ is Player)
            {
               Player(_loc3_).isUpGrade = false;
               Player(_loc3_).LockState = false;
            }
         }
         this._map = this.newMap();
         this._map.gameView = this;
         this._map.x = this._map.y = 0;
         addChild(this._map);
         this._map.smallMap.x = StageReferance.stageWidth - this._map.smallMap.width - 1;
         this._map.smallMap.enableExit = this._exitRoomTypeArray.indexOf(this._gameInfo.roomType) == -1;
         addChild(this._map.smallMap);
         this._map.smallMap.hideSpliter();
         this._selfMarkBar = new game.view.SelfMarkBar(GameManager.Instance.Current.selfGamePlayer,this);
         this._selfMarkBar.x = 500;
         this._selfMarkBar.y = 79;
         this._fightControlBar = new FightControlBar(this._gameInfo.selfGamePlayer,this);
         GameManager.Instance.Current.selfGamePlayer.addEventListener(LivingEvent.DIE,this.__selfDie);
         this._leftPlayerView = new game.view.LeftPlayerCartoonView();
         this._vane = new game.view.VaneView();
         this._vane.setUpCenter(446,0);
         addChild(this._vane);
         SoundManager.instance.playGameBackMusic(this._map.info.BackMusic);
         this._arrowUp = new game.view.SpringArrowView(DirectionMovingAnimation.UP,this._map);
         this._arrowDown = new game.view.SpringArrowView(DirectionMovingAnimation.DOWN,this._map);
         this._arrowLeft = new game.view.SpringArrowView(DirectionMovingAnimation.RIGHT,this._map);
         this._arrowRight = new game.view.SpringArrowView(DirectionMovingAnimation.LEFT,this._map);
         addChild(this._arrowUp);
         addChild(this._arrowDown);
         addChild(this._arrowLeft);
         addChild(this._arrowRight);
         this._selfBuffBar = ComponentFactory.Instance.creatCustomObject("SelfBuffBar",[this,this._arrowDown]);
         addChildAt(this._selfBuffBar,this.numChildren - 1);
         this._players = new Dictionary();
         this._playerThumbnailLController = new PlayerThumbnailController(this._gameInfo);
         var _loc4_:Point = ComponentFactory.Instance.creatCustomObject("asset.game.ThumbnailLPos");
         this._playerThumbnailLController.x = _loc4_.x;
         this._playerThumbnailLController.y = _loc4_.y;
         addChildAt(this._playerThumbnailLController,getChildIndex(this._map.smallMap));
         SharedManager.Instance.addEventListener(Event.CHANGE,this.__soundChange);
         this.__soundChange(null);
         this.setupGameData();
         ChatManager.Instance.state = ChatManager.CHAT_GAME_STATE;
         addChild(ChatManager.Instance.view);
         if(WeakGuildManager.Instance.switchUserGuide)
         {
            this.loadWeakGuild();
         }
         this.defaultForbidDragFocus();
         this.initEvent();
         this.initGameCountDownView();
      }
      
      private function initGameCountDownView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = RoomManager.Instance.current.type;
         if(_loc2_ == RoomInfo.CONSORTIA_BATTLE)
         {
            _loc1_ = 300 - int((TimeManager.Instance.Now().getTime() - GameManager.Instance.Current.startTime.getTime()) / 1000);
            this._gameCountDownView = new game.view.GameCountDownView(_loc1_);
            this._gameCountDownView.x = this._map.smallMap.x - this._gameCountDownView.width - 1;
            this._gameCountDownView.y = 2;
            addChild(this._gameCountDownView);
         }
      }
      
      protected function __selfDie(param1:LivingEvent) : void
      {
         var _loc2_:Living = null;
         var _loc3_:Living = param1.currentTarget as Living;
         var _loc4_:DictionaryData = this._gameInfo.findTeam(_loc3_.team);
         for each(_loc2_ in _loc4_)
         {
            if(_loc2_.isLiving)
            {
               this._fightControlBar.setState(FightControlBar.SOUL);
               return;
            }
         }
      }
      
      protected function drawMissionInfo() : void
      {
         if(this._gameInfo.roomType >= 2 && this._gameInfo.roomType != 5)
         {
            this._map.smallMap.titleBar.addEventListener(DungeonInfoEvent.DungeonHelpChanged,this.__dungeonVisibleChanged);
            this._barrier = new game.view.DungeonInfoView(this._map.smallMap.titleBar.turnButton,this);
            this._barrier.addEventListener(GameEvent.DungeonHelpVisibleChanged,this.__dungeonHelpChanged);
            this._barrier.addEventListener(GameEvent.UPDATE_SMALLMAPVIEW,this.__updateSmallMapView);
            this._missionHelp = new game.view.DungeonHelpView(this._map.smallMap.titleBar.turnButton,this._barrier,this);
            addChild(this._missionHelp);
            this._barrier.open();
         }
      }
      
      protected function __updateSmallMapView(param1:GameEvent) : void
      {
         var _loc2_:MissionInfo = GameManager.Instance.Current.missionInfo;
         if(_loc2_.currentValue1 != -1 && _loc2_.totalValue1 > 0)
         {
            this._map.smallMap.setBarrier(_loc2_.currentValue1,_loc2_.totalValue1);
         }
      }
      
      protected function __dungeonHelpChanged(param1:GameEvent) : void
      {
         var _loc2_:Rectangle = null;
         if(Boolean(this._missionHelp))
         {
            if(param1.data)
            {
               if(this._missionHelp.opened)
               {
                  _loc2_ = this._barrier.getBounds(this);
                  _loc2_.width = _loc2_.height = 1;
                  this._missionHelp.close(_loc2_);
               }
               else
               {
                  this._missionHelp.open();
               }
            }
            else if(this._missionHelp.opened)
            {
               _loc2_ = this._map.smallMap.titleBar.turnButton.getBounds(this);
               this._missionHelp.close(_loc2_);
            }
         }
      }
      
      protected function __dungeonVisibleChanged(param1:DungeonInfoEvent) : void
      {
         if(Boolean(this._barrier) && this._barrierVisible)
         {
            if(Boolean(this._barrier.parent))
            {
               this._barrier.close();
            }
            else
            {
               this._barrier.open();
            }
         }
      }
      
      private function __onMissonHelpClick(param1:MouseEvent) : void
      {
         StageReferance.stage.focus = this._map;
      }
      
      private function __rightPropThreeSkillClick(param1:Event) : void
      {
         this.useThreeSkill();
      }
      
      private function __selfPropThreeClick(param1:Event) : void
      {
         this.useThreeSkill();
      }
      
      private function useThreeSkill() : void
      {
      }
      
      protected function initEvent() : void
      {
      }
      
      protected function loadWeakGuild() : void
      {
         this._vane.visible = PlayerManager.Instance.Self.IsWeakGuildFinish(Step.VANE_OPEN);
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.VANE_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.VANE_SHOW))
         {
            setTimeout(this.propOpenShow,2000,"asset.trainer.openVane");
            SocketManager.Instance.out.syncWeakStep(Step.VANE_SHOW);
         }
      }
      
      private function propOpenShow(param1:String) : void
      {
         var _loc2_:MovieClipWrapper = new MovieClipWrapper(ClassUtils.CreatInstance(param1),true,true);
         LayerManager.Instance.addToLayer(_loc2_.movie,LayerManager.GAME_UI_LAYER,false);
      }
      
      protected function newMap() : MapView
      {
         if(Boolean(this._map))
         {
            throw new Error(LanguageMgr.GetTranslation("tank.game.mapGenerated"));
         }
         return new MapView(this._gameInfo,this._gameInfo.loaderMap);
      }
      
      private function __soundChange(param1:Event) : void
      {
         var _loc2_:SoundTransform = new SoundTransform();
         if(SharedManager.Instance.allowSound)
         {
            _loc2_.volume = SharedManager.Instance.soundVolumn / 100;
            this.soundTransform = _loc2_;
         }
         else
         {
            _loc2_.volume = 0;
            this.soundTransform = _loc2_;
         }
      }
      
      public function restoreSmallMap() : void
      {
         this._map.smallMap.restore();
      }
      
      protected function disposeUI() : void
      {
         if(Boolean(this._missionHelp))
         {
            this._missionHelp.removeEventListener(MouseEvent.CLICK,this.__onMissonHelpClick);
            ObjectUtils.disposeObject(this._missionHelp);
            this._missionHelp = null;
         }
         if(Boolean(this._arrowDown))
         {
            this._arrowDown.dispose();
         }
         if(Boolean(this._arrowUp))
         {
            this._arrowUp.dispose();
         }
         if(Boolean(this._arrowLeft))
         {
            this._arrowLeft.dispose();
         }
         if(Boolean(this._arrowRight))
         {
            this._arrowRight.dispose();
         }
         this._arrowDown = null;
         this._arrowLeft = null;
         this._arrowRight = null;
         this._arrowUp = null;
         ObjectUtils.disposeObject(this._achievBar);
         this._achievBar = null;
         if(Boolean(this._playerThumbnailLController))
         {
            this._playerThumbnailLController.dispose();
         }
         this._playerThumbnailLController = null;
         ObjectUtils.disposeObject(this._selfUsedProp);
         this._selfUsedProp = null;
         if(Boolean(this._leftPlayerView))
         {
            this._leftPlayerView.dispose();
         }
         this._leftPlayerView = null;
         this._cs = null;
         ObjectUtils.disposeObject(this._fightControlBar);
         this._fightControlBar = null;
         ObjectUtils.disposeObject(this._selfMarkBar);
         this._selfMarkBar = null;
         ObjectUtils.disposeObject(this._selfBuffBar);
         this._selfBuffBar = null;
         if(Boolean(this._vane))
         {
            this._vane.dispose();
            this._vane = null;
         }
         DisplayPool.Instance.clearAll();
         ObjectUtils.disposeObject(this._gameCountDownView);
         this._gameCountDownView = null;
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         super.leaving(param1);
         this.disposeUI();
         this.removeGameData();
         ObjectUtils.disposeObject(this._bitmapMgr);
         this._bitmapMgr = null;
         this._map.smallMap.titleBar.removeEventListener(DungeonInfoEvent.DungeonHelpChanged,this.__dungeonVisibleChanged);
         PlayerInfoViewControl.clearView();
         LayerManager.Instance.clearnGameDynamic();
         removeChild(this._map);
         this._map.dispose();
         this._map = null;
         SharedManager.Instance.removeEventListener(Event.CHANGE,this.__soundChange);
         ObjectUtils.disposeObject(this._missionHelp);
         this._missionHelp = null;
         GameManager.Instance.Current.selfGamePlayer.removeEventListener(LivingEvent.DIE,this.__selfDie);
         IMEManager.enable();
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         MenoryUtil.clearMenory();
         if(Boolean(this._barrier))
         {
            this._barrier.removeEventListener(GameEvent.DungeonHelpVisibleChanged,this.__dungeonHelpChanged);
            this._barrier.removeEventListener(GameEvent.UPDATE_SMALLMAPVIEW,this.__updateSmallMapView);
            ObjectUtils.disposeObject(this._barrier);
            this._barrier = null;
         }
      }
      
      protected function setupGameData() : void
      {
         var _loc1_:Living = null;
         var _loc2_:GameLiving = null;
         var _loc3_:Player = null;
         var _loc4_:RoomPlayer = null;
         var _loc5_:* = null;
         var _loc6_:Array = new Array();
         for each(_loc1_ in this._gameInfo.livings)
         {
            if(_loc1_ is Player)
            {
               _loc3_ = _loc1_ as Player;
               _loc4_ = RoomManager.Instance.current.findPlayerByID(_loc3_.playerInfo.ID);
               if(_loc3_.isSelf)
               {
                  _loc2_ = new GameLocalPlayer(this._gameInfo.selfGamePlayer,_loc3_.character,_loc3_.movie);
                  this._selfGamePlayer = _loc2_ as GameLocalPlayer;
               }
               else
               {
                  _loc2_ = new GamePlayer(_loc3_,_loc3_.character,_loc3_.movie);
               }
               if(Boolean(_loc3_.movie))
               {
                  _loc3_.movie.setDefaultAction(_loc3_.movie.standAction);
                  _loc3_.movie.doAction(_loc3_.movie.standAction);
               }
               for(_loc5_ in _loc3_.outProperty)
               {
                  this.setProperty(_loc2_,_loc5_,_loc3_.outProperty[_loc5_]);
               }
               _loc6_.push(_loc2_);
               this._map.addPhysical(_loc2_);
               this._players[_loc1_] = _loc2_;
            }
         }
         this._map.wind = GameManager.Instance.Current.wind;
         this._map.currentTurn = 1;
         this._vane.initialize();
         this._vane.update(this._map.wind);
         this._map.act(new ViewEachPlayerAction(this._map,_loc6_));
      }
      
      protected function setProperty(param1:GameLiving, param2:String, param3:String) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Living = null;
         var _loc7_:StringObject = new StringObject(param3);
         switch(param2)
         {
            case "system":
               if(Boolean(param1))
               {
                  _loc4_ = 0;
                  _loc5_ = _loc7_.getBoolean();
                  _loc6_ = param1.info;
                  _loc6_.LockType = _loc4_;
                  _loc6_.LockState = _loc5_;
                  if(param1.info.isSelf)
                  {
                     GameManager.Instance.Current.selfGamePlayer.lockDeputyWeapon = _loc5_;
                     GameManager.Instance.Current.selfGamePlayer.lockFly = _loc5_;
                     GameManager.Instance.Current.selfGamePlayer.lockSpellKill = _loc5_;
                     GameManager.Instance.Current.selfGamePlayer.rightPropEnabled = !_loc5_;
                     GameManager.Instance.Current.selfGamePlayer.customPropEnabled = !_loc5_;
                     GameManager.Instance.Current.selfGamePlayer.petSkillEnabled = !_loc5_;
                  }
               }
               break;
            case "systemII":
               if(Boolean(param1))
               {
                  _loc4_ = 0;
                  _loc5_ = _loc7_.getBoolean();
                  _loc6_ = param1.info;
                  if(param1.info.isSelf)
                  {
                     GameManager.Instance.Current.selfGamePlayer.lockFly = _loc5_;
                     GameManager.Instance.Current.selfGamePlayer.lockDeputyWeapon = _loc5_;
                     GameManager.Instance.Current.selfGamePlayer.petSkillEnabled = !_loc5_;
                  }
               }
               break;
            case "propzxc":
               if(Boolean(param1))
               {
                  _loc4_ = 3;
                  _loc5_ = _loc7_.getBoolean();
                  _loc6_ = param1.info;
                  _loc6_.LockType = _loc4_;
                  _loc6_.LockState = _loc5_;
                  if(param1.info.isSelf)
                  {
                     GameManager.Instance.Current.selfGamePlayer.customPropEnabled = _loc5_;
                  }
               }
               break;
            case "silencedSpecial":
               if(Boolean(param1))
               {
                  _loc4_ = 3;
                  _loc5_ = _loc7_.getBoolean();
                  _loc6_ = param1.info;
                  _loc6_.LockType = _loc4_;
                  _loc6_.LockState = _loc5_;
                  if(param1.info.isSelf)
                  {
                     GameManager.Instance.Current.selfGamePlayer.lockFly = _loc5_;
                     GameManager.Instance.Current.selfGamePlayer.lockDeputyWeapon = _loc5_;
                     GameManager.Instance.Current.selfGamePlayer.lockSpellKill = _loc5_;
                     GameManager.Instance.Current.selfGamePlayer.rightPropEnabled = !_loc5_;
                     GameManager.Instance.Current.selfGamePlayer.customPropEnabled = !_loc5_;
                  }
               }
               break;
            case "silenced":
               if(Boolean(param1))
               {
                  _loc4_ = 1;
                  _loc5_ = _loc7_.getBoolean();
                  _loc6_ = param1.info;
                  _loc6_.LockType = _loc4_;
                  _loc6_.LockState = _loc5_;
                  if(param1.info.isSelf)
                  {
                     GameManager.Instance.Current.selfGamePlayer.rightPropEnabled = !_loc5_;
                     GameManager.Instance.Current.selfGamePlayer.customPropEnabled = !_loc5_;
                     GameManager.Instance.Current.selfGamePlayer.lockDeputyWeapon = _loc5_;
                  }
               }
               break;
            case "nofly":
               _loc4_ = 2;
               _loc5_ = _loc7_.getBoolean();
               _loc6_ = param1.info;
               _loc6_.LockType = _loc4_;
               _loc6_.LockState = _loc5_;
               if(param1.info.isSelf)
               {
                  GameManager.Instance.Current.selfGamePlayer.lockFly = _loc5_;
               }
               break;
            case "silenceMany":
               _loc4_ = 1;
               _loc5_ = _loc7_.getBoolean();
               _loc6_ = param1.info;
               if(_loc5_)
               {
                  _loc6_.addBuff(BuffManager.creatBuff(BuffType.LockState));
               }
               else
               {
                  _loc6_.removeBuff(BuffType.LockState);
               }
               if(param1.info.isSelf)
               {
                  GameManager.Instance.Current.selfGamePlayer.lockDeputyWeapon = _loc5_;
                  GameManager.Instance.Current.selfGamePlayer.lockFly = _loc5_;
                  GameManager.Instance.Current.selfGamePlayer.lockRightProp = _loc5_;
               }
               break;
            case "hideBossThumbnail":
               if(Boolean(param1))
               {
                  this._playerThumbnailLController.removeThumbnailContainer();
               }
               break;
            case "energy":
               if(Boolean(param1))
               {
                  param1.info.maxEnergy = _loc7_.getNumber();
                  param1.info.energy = _loc7_.getNumber();
               }
               break;
            case "energy2":
               if(Boolean(param1))
               {
                  param1.info.energy = _loc7_.getNumber();
               }
               break;
            default:
               param1.setProperty(param2,param3);
         }
      }
      
      private function removeGameData() : void
      {
         var _loc1_:GameLiving = null;
         for each(_loc1_ in this._players)
         {
            _loc1_.dispose();
            delete this._players[_loc1_.info];
         }
         this._players = null;
         this._selfGamePlayer = null;
         this._gameInfo = null;
         this._barrierVisible = true;
      }
      
      public function addLiving(param1:Living) : void
      {
      }
      
      private function updatePlayerState(param1:Living) : void
      {
         if(this._selfUsedProp == null)
         {
            this._selfUsedProp = new PlayerStateContainer(12);
            PositionUtils.setPos(this._selfUsedProp,"asset.game.selfUsedProp");
            addChild(this._selfUsedProp);
         }
         if(Boolean(this._selfUsedProp))
         {
            this._selfUsedProp.disposeAllChildren();
         }
         if(Boolean(this._selfUsedProp) && Boolean(this._selfBuffBar))
         {
            this._selfUsedProp.x = this._selfBuffBar.right;
         }
         if(param1 is TurnedLiving)
         {
            this._selfUsedProp.info = TurnedLiving(param1);
         }
         if(GameManager.Instance.Current.selfGamePlayer.isAutoGuide && GameManager.Instance.Current.currentLiving.LivingID == GameManager.Instance.Current.selfGamePlayer.LivingID)
         {
            GameManager.Instance.Current.selfGamePlayer.useItem(ItemManager.Instance.getTemplateById(this.GUIDEID));
            GameInSocketOut.sendUseProp(2,-1,this.GUIDEID);
            MessageTipManager.getInstance().show(String(GameManager.Instance.Current.selfGamePlayer.LivingID),3);
         }
      }
      
      public function setCurrentPlayer(param1:Living) : void
      {
         if(param1 && param1.isSelf && param1.isLiving)
         {
            if(Boolean(this._selfBuffBar))
            {
               this._selfBuffBar.propertyWaterBuffBarVisible = true;
            }
         }
         else if(Boolean(this._selfBuffBar))
         {
            this._selfBuffBar.propertyWaterBuffBarVisible = false;
         }
         if(!GameManager.Instance.Current.selfGamePlayer.isLiving)
         {
            if(Boolean(this._selfBuffBar))
            {
               this._selfBuffBar.visible = false;
            }
         }
         else if(Boolean(this._selfBuffBar))
         {
            this._selfBuffBar.visible = true;
         }
         if(!RoomManager.Instance.current.selfRoomPlayer.isViewer && param1 && Boolean(this._selfBuffBar))
         {
            this._selfBuffBar.drawBuff(param1);
         }
         if(Boolean(this._leftPlayerView))
         {
            this._leftPlayerView.info = param1;
         }
         this._map.bringToFront(param1);
         if(Boolean(this._map.currentPlayer) && !(param1 is TurnedLiving))
         {
            this._map.currentPlayer.isAttacking = false;
            this._map.currentPlayer = null;
         }
         else
         {
            this._map.currentPlayer = param1 as TurnedLiving;
         }
         this.updatePlayerState(param1);
         if(Boolean(this._leftPlayerView))
         {
            addChildAt(this._leftPlayerView,this.numChildren - 3);
         }
         var _loc2_:LocalPlayer = GameManager.Instance.Current.selfGamePlayer;
         if(Boolean(this._map.currentPlayer))
         {
            if(Boolean(_loc2_))
            {
               _loc2_.soulPropEnabled = !_loc2_.isLiving && this._map.currentPlayer.team == _loc2_.team;
            }
         }
         else if(Boolean(_loc2_))
         {
            _loc2_.soulPropEnabled = false;
         }
      }
      
      public function updateControlBarState(param1:Living) : void
      {
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         if(GameManager.Instance.Current.selfGamePlayer.LockState)
         {
            this.setPropBarClickEnable(false,true);
            return;
         }
         if(param1 is TurnedLiving && param1.isLiving && GameManager.Instance.Current.selfGamePlayer.canUseProp(param1 as TurnedLiving))
         {
            this.setPropBarClickEnable(true,false);
         }
         else if(Boolean(param1))
         {
            if(!(!GameManager.Instance.Current.selfGamePlayer.isLiving && param1.isSelf))
            {
               if(!(!GameManager.Instance.Current.selfGamePlayer.isLiving && GameManager.Instance.Current.selfGamePlayer.team != param1.team))
               {
                  this.setPropBarClickEnable(true,false);
               }
            }
         }
         else
         {
            this.setPropBarClickEnable(true,false);
         }
      }
      
      protected function setPropBarClickEnable(param1:Boolean, param2:Boolean) : void
      {
         GameManager.Instance.Current.selfGamePlayer.rightPropEnabled = param1;
         GameManager.Instance.Current.selfGamePlayer.customPropEnabled = param1;
      }
      
      protected function gameOver() : void
      {
         this._map.smallMap.enableExit = false;
         if(!NewHandGuideManager.Instance.isNewHandFB())
         {
            SoundManager.instance.stopMusic();
         }
         else
         {
            SoundManager.instance.setMusicVolumeByRatio(0.5);
         }
         this.setPropBarClickEnable(false,false);
         this._leftPlayerView.gameOver();
         this._leftPlayerView.visible = false;
         this._selfMarkBar.shutdown();
      }
      
      protected function set barrierInfo(param1:CrazyTankSocketEvent) : void
      {
         if(Boolean(this._barrier))
         {
            this._barrier.barrierInfoHandler(param1);
         }
      }
      
      protected function set arrowHammerEnable(param1:Boolean) : void
      {
      }
      
      public function blockHammer() : void
      {
      }
      
      public function allowHammer() : void
      {
      }
      
      protected function defaultForbidDragFocus() : void
      {
      }
      
      protected function setBarrierVisible(param1:Boolean) : void
      {
         this._barrierVisible = param1;
      }
      
      protected function setVaneVisible(param1:Boolean) : void
      {
         this._vane.visible = param1;
      }
      
      protected function setPlayerThumbVisible(param1:Boolean) : void
      {
         this._playerThumbnailLController.visible = param1;
      }
      
      protected function setEnergyVisible(param1:Boolean) : void
      {
         var _loc2_:LiveState = this._cs as LiveState;
         if(Boolean(_loc2_))
         {
            _loc2_.setEnergyVisible(param1);
         }
      }
      
      public function setRecordRotation() : void
      {
      }
      
      public function get map() : MapView
      {
         return this._map;
      }
   }
}
