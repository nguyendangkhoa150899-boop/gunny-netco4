package game.view
{
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.data.BuffType;
   import ddt.data.EquipType;
   import ddt.data.FightAchievModel;
   import ddt.data.FightBuffInfo;
   import ddt.data.PropInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.GameEvent;
   import ddt.events.LivingEvent;
   import ddt.events.PhyobjEvent;
   import ddt.manager.BallManager;
   import ddt.manager.BuffManager;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PageInterfaceManager;
   import ddt.manager.PathManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SkillManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.StatisticManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.MenoryUtil;
   import ddt.view.BackgoundView;
   import ddt.view.PropItemView;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import game.GameManager;
   import game.TryAgain;
   import game.actions.ChangeBallAction;
   import game.actions.ChangeNpcAction;
   import game.actions.ChangePlayerAction;
   import game.actions.GameOverAction;
   import game.actions.MissionOverAction;
   import game.actions.PickBoxAction;
   import game.actions.PrepareShootAction;
   import game.actions.ViewEachObjectAction;
   import game.model.GameNeedMovieInfo;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.model.MissionAgainInfo;
   import game.model.Player;
   import game.model.SimpleBoss;
   import game.model.SmallEnemy;
   import game.model.TurnedLiving;
   import game.objects.ActionType;
   import game.objects.BombAction;
   import game.objects.GameLiving;
   import game.objects.GamePlayer;
   import game.objects.GameSimpleBoss;
   import game.objects.GameSmallEnemy;
   import game.objects.GameSysMsgType;
   import game.objects.SimpleBox;
   import game.objects.SimpleObject;
   import game.objects.TransmissionGate;
   import game.view.control.LiveState;
   import game.view.effects.BaseMirariEffectIcon;
   import game.view.effects.MirariEffectIconManager;
   import game.view.experience.ExpView;
   import org.aswing.KeyboardManager;
   import pet.date.PetSkillTemplateInfo;
   import phy.object.PhysicalObj;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import road7th.utils.AutoDisappear;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   
   public class GameView extends GameViewBase
   {
       
      
      private const ZXC_OFFSET:int = 24;
      
      protected var _msg:String = "";
      
      protected var _tipItems:Dictionary;
      
      protected var _tipLayers:Sprite;
      
      protected var _result:ExpView;
      
      private var numCh:Number;
      
      private var _soundPlayFlag:Boolean;
      
      private var _ignoreSmallEnemy:Boolean;
      
      private var _boxArr:Array;
      
      private var _missionAgain:MissionAgainInfo;
      
      protected var _expView:ExpView;
      
      public function GameView()
      {
         super();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         GameManager.Instance.gameView = this;
         super.enter(param1,param2);
         MenoryUtil.clearMenory();
         KeyboardManager.getInstance().isStopDispatching = false;
         KeyboardShortcutsManager.Instance.forbiddenSection(KeyboardShortcutsManager.GAME,false);
         _gameInfo.resetResultCard();
         _gameInfo.livings.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         _gameInfo.addEventListener(GameEvent.WIND_CHANGED,this.__windChanged);
         PlayerManager.Instance.Self.FightBag.addEventListener(BagEvent.UPDATE,this.__selfObtainItem);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.__updateProp);
         PlayerManager.Instance.Self.TempBag.addEventListener(BagEvent.UPDATE,this.__getTempItem);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_OVER,this.__gameOver);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_SHOOT,this.__shoot);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_START_MOVE,this.__startMove);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_CHANGE,this.__playerChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_VANE,this.__changWind);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_HIDE,this.__playerHide);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_NONOLE,this.__playerNoNole);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_PROP,this.__playerUsingItem);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_DANDER,this.__dander);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REDUCE_DANDER,this.__reduceDander);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_ADDATTACK,this.__changeShootCount);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SUICIDE,this.__suicide);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_SHOOT_TAG,this.__beginShoot);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHANGE_BALL,this.__changeBall);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_FROST,this.__forstPlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAY_MOVIE,this.__playMovie);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_CHAGEANGLE,this.__livingTurnRotation);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAY_SOUND,this.__playSound);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_MOVETO,this.__livingMoveto);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_JUMP,this.__livingJump);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_BEAT,this.__livingBeat);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_SAY,this.__livingSay);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_RANGEATTACKING,this.__livingRangeAttacking);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DIRECTION_CHANGED,this.__livingDirChanged);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FOCUS_ON_OBJECT,this.__focusOnObject);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHANGE_STATE,this.__changeState);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BARRIER_INFO,this.__barrierInfoHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BOX_DISAPPEAR,this.__removePhysicObject);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_TIP_LAYER,this.__addTipLayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FORBID_DRAG,this.__forbidDragFocus);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TOP_LAYER,this.__topLayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONTROL_BGM,this.__controlBGM);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_BOLTMOVE,this.__onLivingBoltmove);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHANGE_TARGET,this.__onChangePlayerTarget);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHT_ACHIEVEMENT,this.__fightAchievement);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_BUFF,this.__updateBuff);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAMESYSMESSAGE,this.__gameSysMessage);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USE_PET_SKILL,this.__usePetSkill);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PET_BUFF,this.__updatePetBuff);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SKIPNEXT,this.__skipNextHandler);
         StatisticManager.Instance().startAction(StatisticManager.GAME,"yes");
         this._tipItems = new Dictionary(true);
         CacheSysManager.lock(CacheConsts.ALERT_IN_FIGHT);
         PlayerManager.Instance.Self.isUpGradeInGame = false;
         BackgoundView.Instance.hide();
         GameManager.Instance.viewCompleteFlag = true;
         BuffManager.startLoadBuffEffect();
         var _loc3_:Vector.<CrazyTankSocketEvent> = GameManager.Instance.addLivingEvtVec;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            this.addliving(_loc3_[_loc4_]);
            _loc4_++;
         }
         var _loc5_:Vector.<CrazyTankSocketEvent> = GameManager.Instance.setPropertyEvtVec;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            this.objectSetProperty(_loc5_[_loc6_]);
            _loc6_++;
         }
         var _loc7_:Vector.<CrazyTankSocketEvent> = GameManager.Instance.livingFallingEvtVec;
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_.length)
         {
            this.livingFalling(_loc7_[_loc8_]);
            _loc8_++;
         }
         var _loc9_:Vector.<CrazyTankSocketEvent> = GameManager.Instance.livingShowBloodEvtVec;
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_.length)
         {
            this.livingShowBlood(_loc9_[_loc10_]);
            _loc10_++;
         }
         var _loc11_:Vector.<CrazyTankSocketEvent> = GameManager.Instance.addMapThingEvtVec;
         var _loc12_:int = 0;
         while(_loc12_ < _loc11_.length)
         {
            this.addMapThing(_loc11_[_loc12_]);
            _loc12_++;
         }
         var _loc13_:Vector.<CrazyTankSocketEvent> = GameManager.Instance.livingActionMappingEvtVec;
         var _loc14_:int = 0;
         while(_loc14_ < _loc13_.length)
         {
            this.livingActionMapping(_loc13_[_loc14_]);
            _loc14_++;
         }
         var _loc15_:Vector.<CrazyTankSocketEvent> = GameManager.Instance.updatePhysicObjectEvtVec;
         var _loc16_:int = 0;
         while(_loc16_ < _loc15_.length)
         {
            this.updatePhysicObject(_loc15_[_loc16_]);
            _loc16_++;
         }
         var _loc17_:Vector.<CrazyTankSocketEvent> = GameManager.Instance.playerBloodEvtVec;
         var _loc18_:int = 0;
         while(_loc18_ < _loc17_.length)
         {
            this.playerBlood(_loc17_[_loc18_]);
            _loc18_++;
         }
         GameManager.Instance.ClearAllCrazyTankSocketEvent();
      }
      
      private function __skipNextHandler(param1:CrazyTankSocketEvent) : void
      {
         if(_gameInfo.roomType == RoomInfo.ACTIVITY_DUNGEON_ROOM)
         {
            setTimeout(this.delayFocusSimpleBoss,250);
         }
      }
      
      private function delayFocusSimpleBoss() : void
      {
         if(!_map)
         {
            return;
         }
         var _loc1_:GameSimpleBoss = _map.getOneSimpleBoss;
         if(Boolean(_loc1_))
         {
            _loc1_.needFocus(0,0,{"priority":3});
         }
      }
      
      private function __updatePetBuff(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.extend1;
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:String = _loc2_.readUTF();
         var _loc6_:String = _loc2_.readUTF();
         var _loc7_:String = _loc2_.readUTF();
         var _loc8_:String = _loc2_.readUTF();
         var _loc9_:Boolean = _loc2_.readBoolean();
         var _loc10_:Living = _gameInfo.findLiving(_loc3_);
         var _loc11_:FightBuffInfo = new FightBuffInfo(_loc4_);
         _loc11_.buffPic = _loc7_;
         _loc11_.buffEffect = _loc8_;
         _loc11_.type = BuffType.PET_BUFF;
         var _loc12_:Object = BuffManager.getBuffById(_loc4_);
         if(Boolean(_loc12_))
         {
            _loc11_.buffName = _loc12_.Name;
            _loc11_.description = _loc12_.Description;
         }
         else
         {
            _loc11_.buffName = _loc5_;
            _loc11_.description = _loc6_;
         }
         if(Boolean(_loc10_))
         {
            if(_loc9_)
            {
               _loc10_.addPetBuff(_loc11_);
            }
            else
            {
               _loc10_.removePetBuff(_loc11_);
            }
         }
      }
      
      private function __usePetSkill(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.extend1;
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:Boolean = _loc2_.readBoolean();
         var _loc6_:Player = _gameInfo.findPlayer(_loc3_);
         var _loc7_:int = _loc2_.readInt();
         if(_loc7_ != 2)
         {
            if(_loc6_ && _loc6_.currentPet && _loc5_)
            {
               _loc6_.usePetSkill(_loc4_,_loc5_);
               if(PetSkillManager.getSkillByID(_loc4_).BallType == PetSkillTemplateInfo.BALL_TYPE_2)
               {
                  _loc6_.isAttacking = false;
                  GameManager.Instance.Current.selfGamePlayer.beginShoot();
               }
            }
            if(!_loc5_)
            {
               GameManager.Instance.dispatchEvent(new LivingEvent(LivingEvent.PETSKILL_USED_FAIL));
            }
         }
      }
      
      private function __gameSysMessage(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:String = _loc2_.readUTF();
         var _loc5_:int = _loc2_.readInt();
         switch(_loc3_)
         {
            case GameSysMsgType.GET_ITEM_INVENTORY_FULL:
               MessageTipManager.getInstance().show(String(_loc5_),2);
         }
      }
      
      private function __changeMaxForce(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.extend1;
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:Living = _gameInfo.findLiving(_loc3_);
         if(Boolean(_loc5_) && _loc5_.isSelf)
         {
            Player(_loc5_).maxForce = _loc4_;
         }
      }
      
      private function __fightAchievement(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:AchieveAnimation = null;
         var _loc3_:PackageIn = null;
         var _loc4_:Living = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:AchieveAnimation = null;
         if(PathManager.getFightAchieveEnable())
         {
            if(_achievBar == null)
            {
               _achievBar = ComponentFactory.Instance.creatCustomObject("FightAchievBar");
               addChild(_achievBar);
            }
            _loc3_ = param1.pkg;
            _loc4_ = GameManager.Instance.Current.findLiving(_loc3_.clientId);
            _loc5_ = _loc3_.readInt();
            _loc6_ = _loc3_.readInt();
            _loc7_ = _loc3_.readInt();
            _loc8_ = getTimer();
            _loc9_ = _achievBar.getAnimate(_loc5_);
            if(_loc9_ == null)
            {
               _achievBar.addAnimate(ComponentFactory.Instance.creatCustomObject("AchieveAnimation",[_loc5_,_loc6_,_loc7_,_loc8_]));
            }
            else if(FightAchievModel.getInstance().isNumAchiev(_loc5_))
            {
               _loc9_.setNum(_loc6_);
            }
            else
            {
               _achievBar.rePlayAnimate(_loc9_);
            }
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = null;
         this.numCh = 0;
         var _loc3_:int = 0;
         while(_loc3_ < stage.numChildren)
         {
            _loc2_ = StageReferance.stage.getChildAt(_loc3_);
            _loc2_.visible = true;
            ++this.numCh;
            if(_loc2_ is DisplayObjectContainer)
            {
               this.show(DisplayObjectContainer(_loc2_));
            }
            _loc3_++;
         }
      }
      
      private function show(param1:DisplayObjectContainer) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:int = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc2_ = param1.getChildAt(_loc3_);
            _loc2_.visible = true;
            ++this.numCh;
            if(_loc2_ is DisplayObjectContainer)
            {
               this.show(DisplayObjectContainer(_loc2_));
            }
            _loc3_++;
         }
      }
      
      private function __windChanged(param1:GameEvent) : void
      {
         _map.wind = param1.data.wind;
         _vane.update(_map.wind,param1.data.isSelfTurn,param1.data.windNumArr);
      }
      
      override public function getType() : String
      {
         return StateType.FIGHTING;
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         var _loc2_:SimpleObject = null;
         GameManager.Instance.viewCompleteFlag = false;
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.onClick);
         SoundManager.instance.stopMusic();
         PageInterfaceManager.restorePageTitle();
         KeyboardShortcutsManager.Instance.forbiddenSection(KeyboardShortcutsManager.GAME,true);
         if(PlayerManager.Instance.hasTempStyle)
         {
            PlayerManager.Instance.readAllTempStyleEvent();
         }
         _gameInfo.removeEventListener(GameEvent.WIND_CHANGED,this.__windChanged);
         _gameInfo.livings.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         _gameInfo.removeAllMonsters();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_SHOOT,this.__shoot);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_START_MOVE,this.__startMove);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_CHANGE,this.__playerChange);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_VANE,this.__changWind);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_HIDE,this.__playerHide);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_NONOLE,this.__playerNoNole);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_PROP,this.__playerUsingItem);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_DANDER,this.__dander);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.REDUCE_DANDER,this.__reduceDander);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_ADDATTACK,this.__changeShootCount);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SUICIDE,this.__suicide);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_SHOOT_TAG,this.__beginShoot);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PET_BUFF,this.__updatePetBuff);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.USE_PET_SKILL,this.__usePetSkill);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CHANGE_BALL,this.__changeBall);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_FROST,this.__forstPlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_OVER,this.__gameOver);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAY_MOVIE,this.__playMovie);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_CHAGEANGLE,this.__livingTurnRotation);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAY_SOUND,this.__playSound);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_MOVETO,this.__livingMoveto);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_JUMP,this.__livingJump);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_BEAT,this.__livingBeat);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_SAY,this.__livingSay);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_RANGEATTACKING,this.__livingRangeAttacking);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.DIRECTION_CHANGED,this.__livingDirChanged);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FOCUS_ON_OBJECT,this.__focusOnObject);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CHANGE_STATE,this.__changeState);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BARRIER_INFO,this.__barrierInfoHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BOX_DISAPPEAR,this.__removePhysicObject);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ADD_TIP_LAYER,this.__addTipLayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FORBID_DRAG,this.__forbidDragFocus);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.TOP_LAYER,this.__topLayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONTROL_BGM,this.__controlBGM);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_BOLTMOVE,this.__onLivingBoltmove);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CHANGE_TARGET,this.__onChangePlayerTarget);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FIGHT_ACHIEVEMENT,this.__fightAchievement);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SKIPNEXT,this.__skipNextHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.UPDATE_BUFF,this.__updateBuff);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAMESYSMESSAGE,this.__gameSysMessage);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PICK_BOX,this.__pickBox);
         PlayerManager.Instance.Self.FightBag.removeEventListener(BagEvent.UPDATE,this.__selfObtainItem);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.__updateProp);
         PlayerManager.Instance.Self.TempBag.removeEventListener(BagEvent.UPDATE,this.__getTempItem);
         for each(_loc2_ in this._tipItems)
         {
            delete this._tipLayers[_loc2_.Id];
            _loc2_.dispose();
            _loc2_ = null;
         }
         this._tipItems = null;
         if(Boolean(this._tipLayers))
         {
            if(Boolean(this._tipLayers.parent))
            {
               this._tipLayers.parent.removeChild(this._tipLayers);
            }
         }
         this._tipLayers = null;
         _gameInfo.resetBossCardCnt();
         if(Boolean(this._expView))
         {
            this._expView.removeEventListener(GameEvent.EXPSHOWED,this.__expShowed);
         }
         super.leaving(param1);
         if(StateManager.isExitRoom(param1.getType()) && RoomManager.Instance.isReset(RoomManager.Instance.current.type))
         {
            GameManager.Instance.reset();
            RoomManager.Instance.reset();
         }
         else if(StateManager.isExitGame(param1.getType()) && RoomManager.Instance.isReset(RoomManager.Instance.current.type))
         {
            GameManager.Instance.reset();
         }
         BallManager.clearAsset();
         BackgoundView.Instance.show();
      }
      
      override public function addedToStage() : void
      {
         super.addedToStage();
         stage.focus = _map;
      }
      
      override public function getBackType() : String
      {
         if(_gameInfo.roomType == RoomInfo.CHALLENGE_ROOM)
         {
            return StateType.CHALLENGE_ROOM;
         }
         if(_gameInfo.roomType == RoomInfo.MATCH_ROOM)
         {
            return StateType.MATCH_ROOM;
         }
         if(_gameInfo.roomType == RoomInfo.FIGHT_LIB_ROOM)
         {
            return StateType.FIGHT_LIB;
         }
         if(_gameInfo.roomType == RoomInfo.FRESHMAN_ROOM)
         {
            return StateType.FRESHMAN_ROOM;
         }
         return StateType.DUNGEON_ROOM;
      }
      
      protected function __playerChange(param1:CrazyTankSocketEvent) : void
      {
         PageInterfaceManager.restorePageTitle();
         _selfMarkBar.shutdown();
         _map.currentFocusedLiving = null;
         var _loc2_:int = param1.pkg.extend1;
         var _loc3_:Living = _gameInfo.findLiving(_loc2_);
         _gameInfo.currentLiving = _loc3_;
         if(_loc3_ is TurnedLiving)
         {
            this._ignoreSmallEnemy = false;
            if(!_loc3_.isLiving)
            {
               setCurrentPlayer(null);
               return;
            }
            if(_loc3_.playerInfo == PlayerManager.Instance.Self)
            {
               PageInterfaceManager.changePageTitle("");
            }
            param1.executed = false;
            this._soundPlayFlag = true;
            _map.act(new ChangePlayerAction(_map,_loc3_ as TurnedLiving,param1,param1.pkg));
         }
         else
         {
            _map.act(new ChangeNpcAction(this,_map,_loc3_ as Living,param1,param1.pkg,this._ignoreSmallEnemy));
            if(!this._ignoreSmallEnemy)
            {
               this._ignoreSmallEnemy = true;
            }
         }
         var _loc4_:LiveState = _cs as LiveState;
         PrepareShootAction.hasDoSkillAnimation = false;
      }
      
      private function __playMovie(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(Boolean(_loc3_))
         {
            _loc2_ = param1.pkg.readUTF();
            _loc3_.playMovie(_loc2_);
            _map.bringToFront(_loc3_);
         }
      }
      
      private function __livingTurnRotation(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(Boolean(_loc5_))
         {
            _loc2_ = param1.pkg.readInt() / 10;
            _loc3_ = param1.pkg.readInt() / 10;
            _loc4_ = param1.pkg.readUTF();
            _loc5_.turnRotation(_loc2_,_loc3_,_loc4_);
            _map.bringToFront(_loc5_);
         }
      }
      
      public function addliving(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = null;
         var _loc3_:GameLiving = null;
         var _loc4_:* = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:FightBuffInfo = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:PackageIn = param1.pkg;
         var _loc11_:int = _loc10_.readByte();
         var _loc12_:int = _loc10_.readInt();
         var _loc13_:String = _loc10_.readUTF();
         var _loc14_:String = _loc10_.readUTF();
         var _loc15_:String = _loc10_.readUTF();
         var _loc16_:Point = new Point(_loc10_.readInt(),_loc10_.readInt());
         var _loc17_:int = _loc10_.readInt();
         var _loc18_:int = _loc10_.readInt();
         var _loc19_:int = _loc10_.readInt();
         var _loc20_:int = _loc10_.readByte();
         var _loc21_:int = _loc10_.readByte();
         var _loc22_:Boolean = _loc21_ == 0 ? Boolean(true) : Boolean(false);
         var _loc23_:Boolean = _loc10_.readBoolean();
         var _loc24_:Boolean = _loc10_.readBoolean();
         var _loc25_:int = _loc10_.readInt();
         var _loc26_:Dictionary = new Dictionary();
         var _loc27_:int = 0;
         while(_loc27_ < _loc25_)
         {
            _loc5_ = _loc10_.readUTF();
            _loc6_ = _loc10_.readUTF();
            _loc26_[_loc5_] = _loc6_;
            _loc27_++;
         }
         var _loc28_:int = _loc10_.readInt();
         var _loc29_:Vector.<FightBuffInfo> = new Vector.<FightBuffInfo>();
         var _loc30_:int = 0;
         while(_loc30_ < _loc28_)
         {
            _loc7_ = BuffManager.creatBuff(_loc10_.readInt());
            _loc29_.push(_loc7_);
            _loc30_++;
         }
         var _loc31_:Boolean = _loc10_.readBoolean();
         var _loc32_:Boolean = _loc10_.readBoolean();
         var _loc33_:Boolean = _loc10_.readBoolean();
         var _loc34_:Boolean = _loc10_.readBoolean();
         var _loc35_:int = _loc10_.readInt();
         var _loc36_:Dictionary = new Dictionary();
         var _loc37_:int = 0;
         while(_loc37_ < _loc35_)
         {
            _loc8_ = _loc10_.readUTF();
            _loc9_ = _loc10_.readUTF();
            _loc36_[_loc8_] = _loc9_;
            _loc37_++;
         }
         if(Boolean(_map.getPhysical(_loc12_)))
         {
            _map.getPhysical(_loc12_).dispose();
         }
         if(_loc11_ != 4 && _loc11_ != 5 && _loc11_ != 6)
         {
            _loc2_ = new SmallEnemy(_loc12_,_loc19_,_loc18_);
            _loc2_.typeLiving = _loc11_;
            _loc2_.actionMovieName = _loc14_;
            _loc2_.direction = _loc20_;
            _loc2_.pos = _loc16_;
            _loc2_.name = _loc13_;
            _loc2_.isBottom = _loc22_;
            _gameInfo.addGamePlayer(_loc2_);
            _loc3_ = new GameSmallEnemy(_loc2_ as SmallEnemy);
            if(_loc17_ != _loc2_.maxBlood)
            {
               _loc2_.initBlood(_loc17_);
            }
         }
         else
         {
            _loc2_ = new SimpleBoss(_loc12_,_loc19_,_loc18_);
            _loc2_.typeLiving = _loc11_;
            _loc2_.actionMovieName = _loc14_;
            _loc2_.direction = _loc20_;
            _loc2_.pos = _loc16_;
            _loc2_.name = _loc13_;
            _loc2_.isBottom = _loc22_;
            _gameInfo.addGamePlayer(_loc2_);
            _loc3_ = new GameSimpleBoss(_loc2_ as SimpleBoss);
            if(_loc17_ != _loc2_.maxBlood)
            {
               _loc2_.initBlood(_loc17_);
            }
         }
         _loc3_.name = _loc13_;
         _map.addPhysical(_loc3_);
         if(_loc15_.length > 0)
         {
            _loc3_.doAction(_loc15_);
         }
         else
         {
            _loc3_.doAction(Living.BORN_ACTION);
         }
         if(_loc15_.length > 0)
         {
            _loc3_.doAction(_loc15_);
         }
         else if(!_loc26_[Living.STAND_ACTION])
         {
            _loc3_.doAction(Living.BORN_ACTION);
         }
         else
         {
            _loc3_.doAction(Living.STAND_ACTION);
         }
         _loc3_.info.isFrozen = _loc31_;
         _loc3_.info.isHidden = _loc32_;
         _loc3_.info.isNoNole = _loc33_;
         for(_loc4_ in _loc36_)
         {
            setProperty(_loc3_,_loc4_,_loc36_[_loc4_]);
         }
         _playerThumbnailLController.addLiving(_loc3_);
         addChild(_playerThumbnailLController);
         if(_loc2_ is SimpleBoss)
         {
            _map.setCenter(_loc3_.x,_loc3_.y - 150,false);
         }
         else
         {
            _map.setCenter(_loc3_.x,_loc3_.y - 150,true);
         }
      }
      
      private function __addTipLayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Class = null;
         var _loc4_:MovieClipWrapper = null;
         var _loc5_:SimpleObject = null;
         var _loc6_:int = param1.pkg.readInt();
         var _loc7_:int = param1.pkg.readInt();
         var _loc8_:int = param1.pkg.readInt();
         var _loc9_:int = param1.pkg.readInt();
         var _loc10_:String = param1.pkg.readUTF();
         var _loc11_:String = param1.pkg.readUTF();
         var _loc12_:int = param1.pkg.readInt();
         var _loc13_:int = param1.pkg.readInt();
         if(_loc7_ == 10)
         {
            if(ModuleLoader.hasDefinition(_loc10_))
            {
               _loc3_ = ModuleLoader.getDefinition(_loc10_) as Class;
               _loc2_ = new _loc3_() as MovieClip;
               _loc4_ = new MovieClipWrapper(_loc2_,false,true);
               this.addTipSprite(_loc4_.movie);
               _loc4_.gotoAndPlay(1);
            }
         }
         else
         {
            if(Boolean(this._tipItems[_loc6_]))
            {
               _loc5_ = this._tipItems[_loc6_] as SimpleObject;
            }
            else
            {
               _loc5_ = new SimpleObject(_loc6_,_loc7_,_loc10_,_loc11_);
               this.addTipSprite(_loc5_);
            }
            _loc5_.playAction(_loc11_);
            this._tipItems[_loc6_] = _loc5_;
         }
      }
      
      private function addTipSprite(param1:Sprite) : void
      {
         if(!this._tipLayers)
         {
            this._tipLayers = new Sprite();
            this._tipLayers.mouseChildren = this._tipLayers.mouseEnabled = false;
            addChild(this._tipLayers);
         }
         this._tipLayers.addChild(param1);
      }
      
      protected function __pickBox(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Array = [];
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_.push(_loc2_.readInt());
            _loc5_++;
         }
         _map.dropOutBox(_loc3_);
         this.hideAllOther();
      }
      
      public function addMapThing(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:int = param1.pkg.readInt();
         var _loc6_:String = param1.pkg.readUTF();
         var _loc7_:String = param1.pkg.readUTF();
         var _loc8_:int = param1.pkg.readInt();
         var _loc9_:int = param1.pkg.readInt();
         var _loc10_:int = param1.pkg.readInt();
         var _loc11_:int = param1.pkg.readInt();
         var _loc12_:int = param1.pkg.readInt();
         var _loc13_:SimpleObject = null;
         switch(_loc3_)
         {
            case 1:
               _loc13_ = new SimpleBox(_loc2_,_loc6_);
               break;
            case 2:
               _loc13_ = new SimpleObject(_loc2_,1,_loc6_,_loc7_);
               break;
            case 3:
               _loc13_ = new TransmissionGate(_loc2_,_loc3_,"asset.game.transmitted",_loc7_);
               this.hideAllOther();
               break;
            default:
               _loc13_ = new SimpleObject(_loc2_,0,_loc6_,_loc7_,_loc11_ == 6);
         }
         _loc13_.x = _loc4_;
         _loc13_.y = _loc5_;
         _loc13_.scaleX = _loc8_;
         _loc13_.scaleY = _loc9_;
         _loc13_.rotation = _loc10_;
         if(_loc3_ == 1)
         {
            this.addBox(_loc13_);
         }
         this.addEffect(_loc13_,_loc12_,_loc11_);
      }
      
      private function addBox(param1:SimpleObject) : void
      {
         if(GameManager.Instance.Current.selfGamePlayer.isLiving)
         {
            if(!this._boxArr)
            {
               this._boxArr = new Array();
            }
            this._boxArr.push(param1);
         }
         else
         {
            this.addEffect(param1);
         }
      }
      
      private function addEffect(param1:SimpleObject, param2:int = 0, param3:int = 0) : void
      {
         switch(param2)
         {
            case -1:
               this.addStageCurtain(param1);
               break;
            case 0:
               _map.addPhysical(param1);
               if(param3 > 0 && param3 != 6)
               {
                  _map.phyBringToFront(param1);
               }
               break;
            default:
               _map.addObject(param1);
               this.getGameLivingByID(param2 - 1).addChild(param1);
         }
      }
      
      public function updatePhysicObject(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:SimpleObject = _map.getPhysical(_loc2_) as SimpleObject;
         if(!_loc3_)
         {
            _loc3_ = this._tipItems[_loc2_] as SimpleObject;
         }
         var _loc4_:String = param1.pkg.readUTF();
         if(Boolean(_loc3_))
         {
            _loc3_.playAction(_loc4_);
         }
         var _loc5_:PhyobjEvent = new PhyobjEvent(_loc4_);
         dispatchEvent(_loc5_);
      }
      
      private function __applySkill(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         SkillManager.applySkillToLiving(_loc3_,_loc4_,_loc2_);
      }
      
      private function __removeSkill(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         SkillManager.removeSkillFromLiving(_loc3_,_loc4_,_loc2_);
      }
      
      private function __mirariEffectShowHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:BaseMirariEffectIcon = null;
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:int = _loc3_.extend1;
         var _loc5_:int = _loc3_.readInt();
         var _loc6_:Boolean = _loc3_.readBoolean();
         var _loc7_:Living = _gameInfo.findLiving(_loc4_);
         if(Boolean(_loc7_) && Boolean(_loc7_.playerInfo))
         {
            if(_loc7_.playerInfo.ID == _gameInfo.selfGamePlayer.playerInfo.ID)
            {
               _loc7_ = _gameInfo.selfGamePlayer;
            }
         }
         if(Boolean(_loc7_))
         {
            _loc2_ = MirariEffectIconManager.getInstance().createEffectIcon(_loc5_);
            if(_loc2_ == null)
            {
               return;
            }
            if(_loc6_)
            {
               _loc7_.handleMirariEffect(_loc2_);
            }
            else
            {
               _loc7_.removeMirariEffect(_loc2_);
            }
         }
      }
      
      private function __removePhysicObject(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:PhysicalObj = this.getGameLivingByID(_loc2_);
         var _loc4_:Boolean = true;
         if(Boolean(_loc3_) && Boolean(_loc3_.parent))
         {
            _map.removePhysical(_loc3_);
         }
         if(Boolean(_loc3_) && Boolean(_loc3_.parent))
         {
            _loc3_.parent.removeChild(_loc3_);
         }
         if(_loc4_ && Boolean(_loc3_))
         {
            if(!(_loc3_ is GameLiving) || GameLiving(_loc3_).isExist)
            {
               _loc3_.dispose();
            }
         }
      }
      
      private function __focusOnObject(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:Array = [];
         var _loc4_:Object = new Object();
         _loc4_.x = param1.pkg.readInt();
         _loc4_.y = param1.pkg.readInt();
         _loc3_.push(_loc4_);
         _map.act(new ViewEachObjectAction(_map,_loc3_,_loc2_));
      }
      
      private function __barrierInfoHandler(param1:CrazyTankSocketEvent) : void
      {
         barrierInfo = param1;
      }
      
      private function __livingMoveto(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(Boolean(_loc7_))
         {
            _loc2_ = new Point(param1.pkg.readInt(),param1.pkg.readInt());
            _loc3_ = new Point(param1.pkg.readInt(),param1.pkg.readInt());
            _loc4_ = param1.pkg.readInt();
            _loc5_ = param1.pkg.readUTF();
            _loc6_ = param1.pkg.readUTF();
            _loc7_.pos = _loc2_;
            _loc7_.moveTo(0,_loc3_,0,true,_loc5_,_loc4_,_loc6_);
            _map.bringToFront(_loc7_);
         }
      }
      
      public function livingFalling(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         var _loc3_:Point = new Point(param1.pkg.readInt(),param1.pkg.readInt());
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:String = param1.pkg.readUTF();
         var _loc6_:int = param1.pkg.readInt();
         if(Boolean(_loc2_))
         {
            _loc2_.fallTo(_loc3_,_loc4_,_loc5_,_loc6_);
            if(_loc3_.y - _loc2_.pos.y > 50)
            {
               _map.setCenter(_loc3_.x,_loc3_.y - 150,false);
            }
            _map.bringToFront(_loc2_);
         }
      }
      
      private function __livingJump(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         var _loc3_:Point = new Point(param1.pkg.readInt(),param1.pkg.readInt());
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:String = param1.pkg.readUTF();
         var _loc6_:int = param1.pkg.readInt();
         _loc2_.jumpTo(_loc3_,_loc4_,_loc5_,_loc6_);
         _map.bringToFront(_loc2_);
      }
      
      private function __livingBeat(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:PackageIn = param1.pkg;
         var _loc9_:Living = _gameInfo.findLiving(_loc8_.extend1);
         var _loc10_:String = _loc8_.readUTF();
         var _loc11_:uint = uint(_loc8_.readInt());
         var _loc12_:Array = new Array();
         var _loc13_:uint = 0;
         while(_loc13_ < _loc11_)
         {
            _loc2_ = _gameInfo.findLiving(_loc8_.readInt());
            _loc3_ = _loc8_.readInt();
            _loc4_ = _loc8_.readInt();
            _loc5_ = _loc8_.readInt();
            _loc6_ = _loc8_.readInt();
            _loc7_ = new Object();
            _loc7_["action"] = _loc10_;
            _loc7_["target"] = _loc2_;
            _loc7_["damage"] = _loc3_;
            _loc7_["targetBlood"] = _loc4_;
            _loc7_["dander"] = _loc5_;
            _loc7_["attackEffect"] = _loc6_;
            _loc12_.push(_loc7_);
            if(_loc2_ && _loc2_.isPlayer() && _loc2_.isLiving)
            {
               (_loc2_ as Player).dander = _loc5_;
            }
            _loc13_++;
         }
         if(Boolean(_loc9_))
         {
            _loc9_.beat(_loc12_);
         }
      }
      
      private function __livingSay(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(!_loc2_ || !_loc2_.isLiving)
         {
            return;
         }
         var _loc3_:String = param1.pkg.readUTF();
         var _loc4_:int = param1.pkg.readInt();
         _map.bringToFront(_loc2_);
         _loc2_.say(_loc3_,_loc4_);
      }
      
      private function __livingRangeAttacking(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Living = null;
         var _loc8_:int = param1.pkg.readInt();
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            _loc2_ = param1.pkg.readInt();
            _loc3_ = param1.pkg.readInt();
            _loc4_ = param1.pkg.readInt();
            _loc5_ = param1.pkg.readInt();
            _loc6_ = param1.pkg.readInt();
            _loc7_ = _gameInfo.findLiving(_loc2_);
            if(Boolean(_loc7_))
            {
               _loc7_.isHidden = false;
               _loc7_.isFrozen = false;
               _loc7_.updateBlood(_loc4_,_loc6_);
               _loc7_.showAttackEffect(1);
               _map.bringToFront(_loc7_);
               if(_loc7_.isSelf)
               {
                  _map.setCenter(_loc7_.pos.x,_loc7_.pos.y,false);
               }
               if(_loc7_.isPlayer() && _loc7_.isLiving)
               {
                  (_loc7_ as Player).dander = _loc5_;
               }
            }
            _loc9_++;
         }
      }
      
      private function __livingDirChanged(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(Boolean(_loc3_))
         {
            _loc2_ = param1.pkg.readInt();
            _loc3_.direction = _loc2_;
            _map.bringToFront(_loc3_);
         }
      }
      
      private function __removePlayer(param1:DictionaryEvent) : void
      {
         this._msg = RoomManager.Instance._removeRoomMsg;
         var _loc2_:Player = param1.data as Player;
         var _loc3_:GamePlayer = _players[_loc2_];
         if(Boolean(_loc3_) && Boolean(_loc2_))
         {
            if(_map.currentPlayer == _loc2_)
            {
               setCurrentPlayer(null);
            }
            if(_loc2_.isSelf)
            {
               if(RoomManager.Instance.current.type == RoomInfo.MATCH_ROOM || RoomManager.Instance.current.type == RoomInfo.CHALLENGE_ROOM)
               {
                  StateManager.setState(StateType.ROOM_LIST);
               }
               else if(RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM)
               {
                  StateManager.setState(StateType.DUNGEON_LIST);
               }
               else if(RoomManager.Instance.current.type == 26)
               {
                  StateManager.setState(StateType.MAIN);
               }
            }
            _map.removePhysical(_loc3_);
            _loc3_.dispose();
            delete _players[_loc2_];
         }
      }
      
      private function __beginShoot(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:GamePlayer = null;
         if(_map.currentPlayer && _map.currentPlayer.isPlayer() && param1.pkg.clientId != _map.currentPlayer.playerInfo.ID && _gameInfo.roomType != RoomInfo.ACTIVITY_DUNGEON_ROOM)
         {
            _map.executeAtOnce();
            _map.setCenter(_map.currentPlayer.pos.x,_map.currentPlayer.pos.y - 150,false);
            _loc2_ = _players[_map.currentPlayer];
         }
         if(_gameInfo.roomType != RoomInfo.ACTIVITY_DUNGEON_ROOM || _map.currentPlayer && _map.currentPlayer.isPlayer() && param1.pkg.clientId == _map.currentPlayer.playerInfo.ID)
         {
            setPropBarClickEnable(false,false);
            PrepareShootAction.hasDoSkillAnimation = false;
         }
      }
      
      protected function __shoot(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:LocalPlayer = null;
         var _loc3_:Number = NaN;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Number = NaN;
         var _loc11_:uint = 0;
         var _loc12_:int = 0;
         var _loc13_:Array = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:String = null;
         var _loc17_:Bomb = null;
         var _loc18_:int = 0;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:Living = null;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         var _loc29_:int = 0;
         var _loc30_:Object = null;
         var _loc31_:Point = null;
         var _loc32_:Dictionary = null;
         var _loc33_:Bomb = null;
         var _loc34_:PackageIn = param1.pkg;
         var _loc35_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(Boolean(_loc35_))
         {
            _loc2_ = GameManager.Instance.Current.selfGamePlayer;
            _loc3_ = _loc34_.readInt() / 10;
            _loc4_ = _loc34_.readBoolean();
            _loc5_ = _loc34_.readByte();
            _loc6_ = _loc34_.readByte();
            _loc7_ = _loc34_.readByte();
            _loc8_ = [_loc4_,_loc5_,_loc6_,_loc7_];
            GameManager.Instance.Current.setWind(_loc3_,_loc35_.isSelf,_loc8_);
            _loc9_ = new Array();
            _loc10_ = _loc34_.readInt();
            _loc11_ = 0;
            while(_loc11_ < _loc10_)
            {
               _loc17_ = new Bomb();
               _loc17_.number = _loc34_.readInt();
               _loc17_.shootCount = _loc34_.readInt();
               _loc17_.IsHole = _loc34_.readBoolean();
               _loc17_.Id = _loc34_.readInt();
               _loc17_.X = _loc34_.readInt();
               _loc17_.Y = _loc34_.readInt();
               _loc17_.VX = _loc34_.readInt();
               _loc17_.VY = _loc34_.readInt();
               _loc18_ = _loc34_.readInt();
               _loc17_.Template = BallManager.findBall(_loc18_);
               _loc17_.Actions = new Array();
               _loc17_.changedPartical = _loc34_.readUTF();
               _loc19_ = _loc34_.readInt() / 1000;
               _loc20_ = _loc34_.readInt() / 1000;
               _loc21_ = _loc19_ * _loc20_;
               _loc17_.damageMod = _loc21_;
               _loc22_ = _loc34_.readInt();
               _loc24_ = 0;
               while(_loc24_ < _loc22_)
               {
                  _loc23_ = _loc34_.readInt();
                  _loc17_.Actions.push(new BombAction(_loc23_,_loc34_.readInt(),_loc34_.readInt(),_loc34_.readInt(),_loc34_.readInt(),_loc34_.readInt()));
                  _loc24_++;
               }
               _loc9_.push(_loc17_);
               _loc11_++;
            }
            _loc35_.shoot(_loc9_,param1);
            _loc12_ = _loc34_.readInt();
            _loc13_ = [];
            _loc14_ = 0;
            while(_loc14_ < _loc12_)
            {
               _loc25_ = _loc34_.readInt();
               _loc26_ = _gameInfo.findLiving(_loc25_);
               _loc27_ = _loc34_.readInt();
               _loc28_ = _loc34_.readInt();
               _loc29_ = _loc34_.readInt();
               _loc30_ = {
                  "target":_loc26_,
                  "hp":_loc28_,
                  "damage":_loc27_,
                  "dander":_loc29_
               };
               _loc13_.push(_loc30_);
               _loc14_++;
            }
            _loc15_ = _loc34_.readInt();
            _loc16_ = "attack" + _loc15_.toString();
            if(_loc15_ != 0)
            {
               _loc31_ = null;
               if(_loc9_.length == 3)
               {
                  _loc31_ = Bomb(_loc9_[1]).target;
               }
               else if(_loc9_.length == 1)
               {
                  _loc31_ = Bomb(_loc9_[0]).target;
               }
               _loc32_ = Player(_loc35_).currentPet.petBeatInfo;
               _loc32_["actionName"] = _loc16_;
               _loc32_["targetPoint"] = _loc31_;
               _loc32_["targets"] = _loc13_;
               _loc33_ = Bomb(_loc9_[_loc9_.length == 3 ? 1 : 0]);
               _loc33_.Actions.push(new BombAction(0,ActionType.PET,param1.pkg.extend1,0,0,0));
            }
         }
      }
      
      private function __suicide(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(Boolean(_loc2_))
         {
            _loc2_.die();
         }
      }
      
      private function __changeBall(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Player = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(Boolean(_loc5_) && _loc5_ is Player)
         {
            _loc2_ = _loc5_ as Player;
            _loc3_ = param1.pkg.readBoolean();
            _loc4_ = param1.pkg.readInt();
            _map.act(new ChangeBallAction(_loc2_,_loc3_,_loc4_));
         }
      }
      
      private function __playerUsingItem(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:String = null;
         var _loc4_:PackageIn = param1.pkg;
         var _loc5_:int = _loc4_.readByte();
         var _loc6_:int = _loc4_.readInt();
         var _loc7_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_loc4_.readInt());
         var _loc8_:Living = _gameInfo.findLiving(_loc4_.extend1);
         var _loc9_:Living = _gameInfo.findLiving(_loc4_.readInt());
         var _loc10_:Boolean = _loc4_.readBoolean();
         if(Boolean(_loc8_) && Boolean(_loc7_))
         {
            if(_loc8_.isPlayer())
            {
               if(_loc7_.CategoryID == EquipType.Freeze)
               {
                  Player(_loc8_).skill == -1;
               }
               if(!(_loc8_ as Player).isSelf)
               {
                  if(_loc7_.CategoryID == EquipType.OFFHAND || _loc7_.CategoryID == EquipType.TEMP_OFFHAND)
                  {
                     _loc2_ = (_loc8_ as Player).currentDeputyWeaponInfo.getDeputyWeaponIcon();
                     _loc2_.x += 7;
                     (_loc8_ as Player).useItemByIcon(_loc2_);
                  }
                  else
                  {
                     (_loc8_ as Player).useItem(_loc7_);
                     _loc3_ = EquipType.hasPropAnimation(_loc7_);
                     if(_loc3_ != null && _loc9_ && _loc9_.LivingID != _loc8_.LivingID)
                     {
                        _loc9_.playSkillMovie(_loc3_);
                     }
                  }
               }
            }
            if(_map.currentPlayer && _loc9_.team == _map.currentPlayer.team && (RoomManager.Instance.current.type != RoomInfo.ACTIVITY_DUNGEON_ROOM || (_loc8_ as Player).isSelf))
            {
               _map.currentPlayer.addState(_loc7_.TemplateID);
            }
            if(!_loc9_.isLiving)
            {
               if(_loc9_.isPlayer())
               {
                  (_loc9_ as Player).addState(_loc7_.TemplateID);
               }
            }
            if(RoomManager.Instance.current.type != RoomInfo.ACTIVITY_DUNGEON_ROOM)
            {
               if(!_loc8_.isLiving && _loc9_ && _loc8_.team == _loc9_.team)
               {
                  MessageTipManager.getInstance().show(_loc8_.LivingID + "|" + _loc7_.TemplateID,1);
               }
               if(_loc10_)
               {
                  MessageTipManager.getInstance().show(String(_loc9_.LivingID),3);
               }
            }
         }
      }
      
      private function __updateProp(param1:BagEvent) : void
      {
      }
      
      private function __updateBuff(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:FightBuffInfo = null;
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:int = _loc3_.extend1;
         var _loc5_:int = _loc3_.readInt();
         var _loc6_:Boolean = _loc3_.readBoolean();
         var _loc7_:Living = _gameInfo.findLiving(_loc4_);
         if(Boolean(_loc7_) && _loc5_ != -1)
         {
            if(_loc6_)
            {
               _loc2_ = BuffManager.creatBuff(_loc5_);
               _loc7_.addBuff(_loc2_);
            }
            else
            {
               _loc7_.removeBuff(_loc5_);
            }
         }
      }
      
      private function __startMove(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Player = _gameInfo.findPlayer(param1.pkg.extend1);
         var _loc4_:Boolean = _loc2_.readBoolean();
         if(_loc4_)
         {
            if(!_loc3_.playerInfo.isSelf)
            {
               this.playerMove(_loc2_,_loc3_);
            }
         }
         else
         {
            this.playerMove(_loc2_,_loc3_);
         }
      }
      
      private function playerMove(param1:PackageIn, param2:Player) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:PickBoxAction = null;
         var _loc7_:int = param1.readByte();
         var _loc8_:Point = new Point(param1.readInt(),param1.readInt());
         var _loc9_:int = param1.readByte();
         var _loc10_:Boolean = param1.readBoolean();
         if(_loc7_ == 2)
         {
            _loc3_ = [];
            _loc4_ = param1.readInt();
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = new PickBoxAction(param1.readInt(),param1.readInt());
               _loc3_.push(_loc6_);
               _loc5_++;
            }
            if(Boolean(param2))
            {
               param2.playerMoveTo(_loc7_,_loc8_,_loc9_,_loc10_,_loc3_);
            }
         }
         else if(Boolean(param2))
         {
            param2.playerMoveTo(_loc7_,_loc8_,_loc9_,_loc10_);
         }
      }
      
      private function __onLivingBoltmove(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(Boolean(_loc3_))
         {
            _loc3_.pos = new Point(_loc2_.readInt(),_loc2_.readInt());
         }
      }
      
      public function playerBlood(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(Boolean(_loc6_))
         {
            _loc6_.updateBlood(_loc4_,_loc3_,_loc5_);
         }
      }
      
      private function __changWind(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         _map.wind = _loc2_.readInt() / 10;
         var _loc3_:Boolean = _loc2_.readBoolean();
         var _loc4_:int = _loc2_.readByte();
         var _loc5_:int = _loc2_.readByte();
         var _loc6_:int = _loc2_.readByte();
         var _loc7_:Array = new Array();
         _loc7_ = [_loc3_,_loc4_,_loc5_,_loc6_];
         _vane.update(_map.wind,false,_loc7_);
      }
      
      private function __playerNoNole(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(Boolean(_loc2_))
         {
            _loc2_.isNoNole = param1.pkg.readBoolean();
         }
      }
      
      private function __onChangePlayerTarget(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         if(_loc2_ == 0)
         {
            if(Boolean(_playerThumbnailLController))
            {
               _playerThumbnailLController.currentBoss = null;
            }
            return;
         }
         var _loc3_:Living = _gameInfo.findLiving(_loc2_);
         _playerThumbnailLController.currentBoss = _loc3_;
      }
      
      public function objectSetProperty(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:GameLiving = this.getGameLivingByID(param1.pkg.extend1) as GameLiving;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:String = param1.pkg.readUTF();
         var _loc4_:String = param1.pkg.readUTF();
         setProperty(_loc2_,_loc3_,_loc4_);
      }
      
      private function __playerHide(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(Boolean(_loc2_))
         {
            _loc2_.isHidden = param1.pkg.readBoolean();
         }
      }
      
      private function __gameOver(param1:CrazyTankSocketEvent) : void
      {
         this.gameOver();
         _map.act(new GameOverAction(_map,param1,this.showExpView));
      }
      
      private function __missionOver(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:* = null;
         this.gameOver();
         this._missionAgain = new MissionAgainInfo();
         this._missionAgain.value = _gameInfo.missionInfo.tryagain;
         var _loc3_:DictionaryData = RoomManager.Instance.current.players;
         for(_loc2_ in _loc3_)
         {
            if(RoomPlayer(_loc3_[_loc2_]).isHost)
            {
               this._missionAgain.host = RoomPlayer(_loc3_[_loc2_]).playerInfo.NickName;
            }
            if(RoomPlayer(_loc3_[_loc2_]).isSelf)
            {
               if(!GameManager.Instance.Current.selfGamePlayer.petSkillEnabled)
               {
                  GameManager.Instance.Current.selfGamePlayer.petSkillEnabled = true;
               }
            }
         }
         _map.act(new MissionOverAction(_map,param1,this.showExpView));
      }
      
      override protected function gameOver() : void
      {
         PageInterfaceManager.restorePageTitle();
         super.gameOver();
         KeyboardManager.getInstance().isStopDispatching = true;
      }
      
      private function showTryAgain() : void
      {
         var _loc1_:TryAgain = new TryAgain(this._missionAgain);
         _loc1_.addEventListener(GameEvent.TRYAGAIN,this.__tryAgain);
         _loc1_.addEventListener(GameEvent.GIVEUP,this.__giveup);
         _loc1_.addEventListener(GameEvent.TIMEOUT,this.__tryAgainTimeOut);
         _loc1_.show();
         addChild(_loc1_);
      }
      
      private function canShowTryAgainByRoomType() : Boolean
      {
         if(RoomManager.Instance.current.type == 15)
         {
            return false;
         }
         return true;
      }
      
      private function __tryAgainTimeOut(param1:GameEvent) : void
      {
         param1.currentTarget.removeEventListener(GameEvent.TRYAGAIN,this.__tryAgain);
         param1.currentTarget.removeEventListener(GameEvent.GIVEUP,this.__giveup);
         param1.currentTarget.removeEventListener(GameEvent.TIMEOUT,this.__tryAgainTimeOut);
         ObjectUtils.disposeObject(param1.currentTarget);
         if(Boolean(this._expView))
         {
            this._expView.close();
         }
         this._expView = null;
      }
      
      private function showExpView() : void
      {
         if(Boolean(ChatManager.Instance.input.parent))
         {
            ChatManager.Instance.switchVisible();
         }
         disposeUI();
         MenoryUtil.clearMenory();
         if(GameManager.Instance.Current.roomType == RoomInfo.WORLD_BOSS_FIGHT)
         {
            StateManager.setState(StateType.WORLDBOSS_ROOM);
            return;
         }
         if(GameManager.Instance.Current.roomType == RoomInfo.CONSORTIA_BATTLE)
         {
            StateManager.setState(StateType.CONSORTIA_BATTLE_SCENE);
            return;
         }
         if(GameManager.Instance.Current.roomType == RoomInfo.ACTIVITY_DUNGEON_ROOM)
         {
            StateManager.setState(StateType.DUNGEON_LIST);
            return;
         }
         if(GameManager.Instance.Current.roomType == 26)
         {
            StateManager.setState(StateType.MAIN);
            return;
         }
         this._expView = new ExpView(_map.mapBitmap);
         this._expView.addEventListener(GameEvent.EXPSHOWED,this.__expShowed);
         addChild(this._expView);
         this._expView.show();
      }
      
      private function __expShowed(param1:GameEvent) : void
      {
         var _loc2_:Living = null;
         var _loc3_:Living = null;
         this._expView.removeEventListener(GameEvent.EXPSHOWED,this.__expShowed);
         for each(_loc2_ in _gameInfo.livings.list)
         {
            if(_loc2_.isSelf)
            {
               if(Player(_loc2_).isWin && Boolean(this._missionAgain))
               {
                  this._missionAgain.win = true;
               }
               if(Player(_loc2_).hasLevelAgain && Boolean(this._missionAgain))
               {
                  this._missionAgain.hasLevelAgain = true;
               }
            }
         }
         for each(_loc3_ in _gameInfo.viewers.list)
         {
            if(_loc3_.isSelf)
            {
               if(Player(_loc3_).isWin && Boolean(this._missionAgain))
               {
                  this._missionAgain.win = true;
               }
               if(Player(_loc3_).hasLevelAgain && Boolean(this._missionAgain))
               {
                  this._missionAgain.hasLevelAgain = true;
               }
            }
         }
         if((GameManager.isDungeonRoom(_gameInfo) || GameManager.isAcademyRoom(_gameInfo)) && _gameInfo.missionInfo.tryagain > 0)
         {
            if(RoomManager.Instance.current.selfRoomPlayer.isViewer && !this._missionAgain.win && this.canShowTryAgainByRoomType())
            {
               this.showTryAgain();
               if(Boolean(this._expView))
               {
                  this._expView.visible = false;
               }
            }
            else if(RoomManager.Instance.current.selfRoomPlayer.isViewer && this._missionAgain.win)
            {
               if(Boolean(this._expView))
               {
                  this._expView.close();
               }
               this._expView = null;
            }
            else if(!_gameInfo.selfGamePlayer.isWin && this.canShowTryAgainByRoomType())
            {
               this.showTryAgain();
               if(Boolean(this._expView))
               {
                  this._expView.visible = false;
               }
            }
            else
            {
               this._expView.showCard();
               this._expView = null;
            }
         }
         else if(GameManager.isFightLib(_gameInfo))
         {
            this._expView.close();
            this._expView = null;
         }
         else if(RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this._expView.close();
            this._expView = null;
         }
         else
         {
            this._expView.showCard();
            this._expView = null;
         }
      }
      
      private function hideAllOther() : void
      {
         ObjectUtils.disposeObject(_selfMarkBar);
         _selfMarkBar = null;
         ObjectUtils.disposeObject(_cs);
         _cs = null;
         ObjectUtils.disposeObject(_selfBuffBar);
         _selfBuffBar = null;
         _playerThumbnailLController.visible = false;
         ChatManager.Instance.view.visible = false;
         _leftPlayerView.visible = false;
         _vane.visible = false;
         _barrier.visible = false;
      }
      
      private function __giveup(param1:GameEvent) : void
      {
         param1.currentTarget.removeEventListener(GameEvent.TRYAGAIN,this.__tryAgain);
         param1.currentTarget.removeEventListener(GameEvent.GIVEUP,this.__giveup);
         param1.currentTarget.removeEventListener(GameEvent.TIMEOUT,this.__tryAgainTimeOut);
         ObjectUtils.disposeObject(param1.currentTarget);
         if(RoomManager.Instance.current.selfRoomPlayer.isHost)
         {
            GameInSocketOut.sendMissionTryAgain(0,true);
         }
         this._expView.close();
         this._expView = null;
      }
      
      private function __tryAgain(param1:GameEvent) : void
      {
         param1.currentTarget.removeEventListener(GameEvent.TRYAGAIN,this.__tryAgain);
         param1.currentTarget.removeEventListener(GameEvent.GIVEUP,this.__giveup);
         param1.currentTarget.removeEventListener(GameEvent.TIMEOUT,this.__tryAgainTimeOut);
         ObjectUtils.disposeObject(param1.currentTarget);
         if(!RoomManager.Instance.current.selfRoomPlayer.isViewer || GameManager.Instance.TryAgain == GameManager.MissionAgain)
         {
            GameManager.Instance.Current.hasNextMission = true;
         }
         if(RoomManager.Instance.current.type != RoomInfo.LANBYRINTH_ROOM)
         {
            this._expView.close();
         }
         this._expView = null;
      }
      
      private function __dander(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(Boolean(_loc3_) && _loc3_ is Player)
         {
            _loc2_ = param1.pkg.readInt();
            (_loc3_ as Player).dander = _loc2_;
         }
      }
      
      private function __reduceDander(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(Boolean(_loc3_) && _loc3_ is Player)
         {
            _loc2_ = param1.pkg.readInt();
            (_loc3_ as Player).reduceDander(_loc2_);
         }
      }
      
      private function __changeState(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(Boolean(_loc2_))
         {
            _loc2_.State = param1.pkg.readInt();
            _map.setCenter(_loc2_.pos.x,_loc2_.pos.y,true);
         }
      }
      
      private function __selfObtainItem(param1:BagEvent) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:PropInfo = null;
         var _loc4_:AutoDisappear = null;
         var _loc5_:AutoDisappear = null;
         var _loc6_:AutoDisappear = null;
         var _loc7_:MovieClipWrapper = null;
         if(_gameInfo.roomType == RoomInfo.ACTIVITY_DUNGEON_ROOM)
         {
            return;
         }
         for each(_loc2_ in param1.changedSlots)
         {
            _loc3_ = new PropInfo(_loc2_);
            _loc3_.Place = _loc2_.Place;
            if(Boolean(PlayerManager.Instance.Self.FightBag.getItemAt(_loc2_.Place)))
            {
               _loc4_ = new AutoDisappear(ComponentFactory.Instance.creatBitmap("asset.game.getPropBgAsset"),3);
               _loc4_.x = _vane.x - _loc4_.width / 2 + 48;
               _loc4_.y = _selfMarkBar.y + _selfMarkBar.height + 70;
               LayerManager.Instance.addToLayer(_loc4_,LayerManager.GAME_DYNAMIC_LAYER,false);
               _loc5_ = new AutoDisappear(PropItemView.createView(_loc3_.Template.Pic,62,62),3);
               _loc5_.x = _vane.x - _loc5_.width / 2 + 47;
               _loc5_.y = _selfMarkBar.y + _selfMarkBar.height + 70;
               LayerManager.Instance.addToLayer(_loc5_,LayerManager.GAME_DYNAMIC_LAYER,false);
               _loc6_ = new AutoDisappear(ComponentFactory.Instance.creatBitmap("asset.game.getPropCiteAsset"),3);
               _loc6_.x = _vane.x - _loc6_.width / 2 + 45;
               _loc6_.y = _selfMarkBar.y + _selfMarkBar.height + 70;
               LayerManager.Instance.addToLayer(_loc6_,LayerManager.GAME_DYNAMIC_LAYER,false);
               _loc7_ = new MovieClipWrapper(ClassUtils.CreatInstance("asset.game.zxcTip"),true,true);
               _loc7_.movie.x += _loc7_.movie.width * _loc2_.Place - this.ZXC_OFFSET * _loc2_.Place;
               LayerManager.Instance.addToLayer(_loc7_.movie,LayerManager.GAME_UI_LAYER,false);
            }
         }
      }
      
      private function __getTempItem(param1:BagEvent) : void
      {
         var _loc2_:Boolean = GameManager.Instance.selfGetItemShowAndSound(param1.changedSlots);
         if(_loc2_ && this._soundPlayFlag)
         {
            this._soundPlayFlag = false;
            SoundManager.instance.play("1001");
         }
      }
      
      private function __forstPlayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(Boolean(_loc2_))
         {
            _loc2_.isFrozen = param1.pkg.readBoolean();
         }
      }
      
      private function __changeShootCount(param1:CrazyTankSocketEvent) : void
      {
         if(_gameInfo.roomType != RoomInfo.ACTIVITY_DUNGEON_ROOM || param1.pkg.extend1 == _gameInfo.selfGamePlayer.LivingID)
         {
            _gameInfo.selfGamePlayer.shootCount = param1.pkg.readByte();
         }
      }
      
      private function __playSound(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:String = param1.pkg.readUTF();
         SoundManager.instance.initSound(_loc2_);
         SoundManager.instance.play(_loc2_);
      }
      
      private function __controlBGM(param1:CrazyTankSocketEvent) : void
      {
         if(param1.pkg.readBoolean())
         {
            SoundManager.instance.resumeMusic();
         }
         else
         {
            SoundManager.instance.pauseMusic();
         }
      }
      
      private function __forbidDragFocus(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = param1.pkg.readBoolean();
         _map.smallMap.allowDrag = _loc2_;
         _arrowLeft.allowDrag = _arrowDown.allowDrag = _arrowRight.allowDrag = _arrowUp.allowDrag = _loc2_;
      }
      
      override protected function defaultForbidDragFocus() : void
      {
         _map.smallMap.allowDrag = true;
         _arrowLeft.allowDrag = _arrowDown.allowDrag = _arrowRight.allowDrag = _arrowUp.allowDrag = true;
      }
      
      private function __topLayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.readInt());
         if(Boolean(_loc2_))
         {
            _map.bringToFront(_loc2_);
         }
      }
      
      private function __loadResource(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:GameNeedMovieInfo = null;
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new GameNeedMovieInfo();
            _loc2_.type = param1.pkg.readInt();
            _loc2_.path = param1.pkg.readUTF();
            _loc2_.classPath = param1.pkg.readUTF();
            _loc2_.startLoad();
            _loc4_++;
         }
      }
      
      public function livingShowBlood(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:Boolean = Boolean(param1.pkg.readInt());
         (_map.getPhysical(_loc2_) as GameLiving).showBlood(_loc3_);
      }
      
      public function livingActionMapping(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:String = param1.pkg.readUTF();
         var _loc4_:String = param1.pkg.readUTF();
         if(Boolean(_map.getPhysical(_loc2_)))
         {
            _map.getPhysical(_loc2_).setActionMapping(_loc3_,_loc4_);
         }
      }
      
      private function getGameLivingByID(param1:int) : PhysicalObj
      {
         if(!_map)
         {
            return null;
         }
         return _map.getPhysical(param1);
      }
      
      private function addStageCurtain(param1:SimpleObject) : void
      {
         var obj:SimpleObject = null;
         obj = param1;
         obj.movie.addEventListener("playEnd",function():void
         {
            obj.movie.stop();
            if(Boolean(obj.parent))
            {
               obj.parent.removeChild(obj);
            }
            obj.dispose();
            obj = null;
         });
         addChild(obj);
      }
   }
}
