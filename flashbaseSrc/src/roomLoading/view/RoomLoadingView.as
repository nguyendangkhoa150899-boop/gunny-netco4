package roomLoading.view
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quint;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BallInfo;
   import ddt.loader.MapLoader;
   import ddt.loader.TrainerLoader;
   import ddt.manager.BallManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.LoadBombManager;
   import ddt.manager.MapManager;
   import ddt.manager.PathManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import game.model.GameInfo;
   import game.model.GameNeedPetSkillInfo;
   import game.model.Player;
   import im.IMController;
   import labyrinth.LabyrinthManager;
   import pet.date.PetInfo;
   import pet.date.PetSkillTemplateInfo;
   import road7th.data.DictionaryData;
   import room.RoomManager;
   import room.events.RoomPlayerEvent;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import trainer.controller.LevelRewardManager;
   import trainer.controller.NewHandGuideManager;
   import trainer.controller.WeakGuildManager;
   import worldboss.WorldBossManager;
   
   public class RoomLoadingView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _gameInfo:GameInfo;
      
      private var _versus:roomLoading.view.RoomLoadingVersusItem;
      
      private var _countDownTxt:roomLoading.view.RoomLoadingCountDownNum;
      
      private var _battleField:roomLoading.view.RoomLoadingBattleFieldItem;
      
      private var _tipsItem:roomLoading.view.RoomLoadingTipsItem;
      
      private var _viewerItem:roomLoading.view.RoomLoadingViewerItem;
      
      private var _dungeonMapItem:roomLoading.view.RoomLoadingDungeonMapItem;
      
      private var _characterItems:Vector.<roomLoading.view.RoomLoadingCharacterItem>;
      
      private var _countDownTimer:Timer;
      
      private var _selfFinish:Boolean;
      
      private var _trainerLoad:TrainerLoader;
      
      private var _startTime:Number;
      
      protected var _leaving:Boolean = false;
      
      protected var _amountOfFinishedPlayer:int = 0;
      
      protected var _hasLoadedFinished:DictionaryData;
      
      protected var blueCharacterIndex:int = 1;
      
      protected var redCharacterIndex:int = 1;
      
      private var _unloadedmsg:String = "";
      
      public function RoomLoadingView(param1:GameInfo)
      {
         this._hasLoadedFinished = new DictionaryData();
         super();
         this._gameInfo = param1;
         this.init();
      }
      
      private function init() : void
      {
         if(NewHandGuideManager.Instance.mapID == 111)
         {
            this._startTime = new Date().getTime();
         }
         TimeManager.Instance.enterFightTime = new Date().getTime();
         LevelRewardManager.Instance.hide();
         this._characterItems = new Vector.<RoomLoadingCharacterItem>();
         KeyboardShortcutsManager.Instance.forbiddenFull();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.roomLoading.Bg");
         this._versus = ComponentFactory.Instance.creatCustomObject("roomLoading.VersusItem",[RoomManager.Instance.current.gameMode]);
         this._countDownTxt = ComponentFactory.Instance.creatCustomObject("roomLoading.CountDownItem");
         this._battleField = ComponentFactory.Instance.creatCustomObject("roomLoading.BattleFieldItem",[this._gameInfo.mapIndex]);
         this._tipsItem = ComponentFactory.Instance.creatCustomObject("roomLoading.TipsItem");
         this._viewerItem = ComponentFactory.Instance.creatCustomObject("roomLoading.ViewerItem");
         if(this._gameInfo.gameMode == 7 || this._gameInfo.gameMode == 8 || this._gameInfo.gameMode == 10)
         {
            this._dungeonMapItem = ComponentFactory.Instance.creatCustomObject("roomLoading.DungeonMapItem");
         }
         this._selfFinish = false;
         addChild(this._bg);
         addChild(this._versus);
         addChild(this._countDownTxt);
         addChild(this._battleField);
         addChild(this._tipsItem);
         this.initLoadingItems();
         if(Boolean(this._dungeonMapItem))
         {
            addChild(this._dungeonMapItem);
         }
         var _loc1_:int = RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM || RoomManager.Instance.current.type == RoomInfo.ACADEMY_DUNGEON_ROOM ? int(94) : int(64);
         this._countDownTimer = new Timer(1000,_loc1_);
         this._countDownTimer.addEventListener(TimerEvent.TIMER,this.__countDownTick);
         this._countDownTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__countDownComplete);
         this._countDownTimer.start();
         StateManager.currentStateType = StateType.GAME_LOADING;
      }
      
      private function initLoadingItems() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:RoomPlayer = null;
         var _loc5_:RoomPlayer = null;
         var _loc6_:int = 0;
         var _loc7_:GameNeedPetSkillInfo = null;
         var _loc8_:RoomPlayer = null;
         var _loc9_:roomLoading.view.RoomLoadingCharacterItem = null;
         var _loc10_:Point = null;
         var _loc11_:Player = null;
         var _loc12_:PetInfo = null;
         var _loc13_:int = 0;
         var _loc14_:PetSkillTemplateInfo = null;
         var _loc15_:BallInfo = null;
         var _loc16_:int = int(this._gameInfo.roomPlayers.length);
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:Array = this._gameInfo.roomPlayers;
         LoadBombManager.Instance.loadFullRoomPlayersBomb(_loc19_);
         LoadBombManager.Instance.loadSpecialBomb();
         for each(_loc4_ in _loc19_)
         {
            if(PlayerManager.Instance.Self.ID == _loc4_.playerInfo.ID)
            {
               _loc3_ = _loc4_.team;
            }
         }
         for each(_loc5_ in _loc19_)
         {
            if(!_loc5_.isViewer)
            {
               if(_loc5_.team == RoomPlayer.BLUE_TEAM)
               {
                  _loc1_++;
               }
               else
               {
                  _loc2_++;
               }
               if(!(RoomManager.Instance.current.type == RoomInfo.FREE_MODE && _loc5_.team != _loc3_))
               {
                  IMController.Instance.saveRecentContactsID(_loc5_.playerInfo.ID);
               }
            }
         }
         _loc6_ = 0;
         while(_loc6_ < _loc16_)
         {
            _loc8_ = this._gameInfo.roomPlayers[_loc6_];
            _loc8_.addEventListener(RoomPlayerEvent.PROGRESS_CHANGE,this.__onLoadingFinished);
            if(_loc8_.isViewer)
            {
               if(contains(this._tipsItem))
               {
                  removeChild(this._tipsItem);
               }
               addChild(this._viewerItem);
            }
            else
            {
               _loc9_ = new roomLoading.view.RoomLoadingCharacterItem(_loc8_);
               if(_loc8_.team == RoomPlayer.BLUE_TEAM)
               {
                  PositionUtils.setPos(_loc9_,"asset.roomLoading.CharacterItemBluePos_" + _loc1_.toString() + "_" + (_loc17_ + 1).toString());
                  _loc10_ = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.CharacterItemBlueFromPos_" + (_loc17_ + 1).toString());
                  TweenMax.from(_loc9_,0.5,{
                     "x":_loc10_.x,
                     "y":_loc10_.y,
                     "ease":Quint.easeIn,
                     "delay":1 + _loc17_ * 0.2
                  });
                  _loc17_++;
               }
               else
               {
                  PositionUtils.setPos(_loc9_,"asset.roomLoading.CharacterItemRedPos_" + _loc2_.toString() + "_" + (_loc18_ + 1).toString());
                  _loc10_ = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.CharacterItemRedFromPos_" + (_loc18_ + 1).toString());
                  TweenMax.from(_loc9_,0.5,{
                     "x":_loc10_.x,
                     "y":_loc10_.y,
                     "ease":Quint.easeIn,
                     "delay":1 + _loc18_ * 0.2
                  });
                  _loc18_++;
               }
               this._characterItems.push(_loc9_);
               addChild(_loc9_);
               _loc11_ = this._gameInfo.findLivingByPlayerID(_loc8_.playerInfo.ID,_loc8_.playerInfo.ZoneID);
               _loc11_.movie = _loc8_.movie;
               _loc11_.character = _loc8_.character;
               _loc11_.character.showGun = true;
               if(_loc9_.x < 500)
               {
                  _loc11_.character.x = -118;
                  _loc11_.character.show(false,-1);
                  _loc9_.index = this.blueCharacterIndex;
                  ++this.blueCharacterIndex;
               }
               else
               {
                  _loc11_.character.x = 37;
                  _loc11_.character.show(false,1);
                  _loc9_.index = this.redCharacterIndex;
                  ++this.redCharacterIndex;
               }
               _loc11_.character.y = 32;
               _loc11_.movie.show(true,-1);
               _loc12_ = _loc11_.playerInfo.currentPet;
               if(Boolean(_loc12_))
               {
                  LoaderManager.Instance.creatAndStartLoad(PathManager.solvePetGameAssetUrl(_loc12_.GameAssetUrl),BaseLoader.MODULE_LOADER);
                  for each(_loc13_ in _loc12_.equipdSkills)
                  {
                     if(_loc13_ > 0)
                     {
                        _loc14_ = PetSkillManager.getSkillByID(_loc13_);
                        if(Boolean(_loc14_.EffectPic))
                        {
                           LoaderManager.Instance.creatAndStartLoad(PathManager.solvePetSkillEffect(_loc14_.EffectPic),BaseLoader.MODULE_LOADER);
                        }
                        if(_loc14_.NewBallID != -1)
                        {
                           _loc15_ = BallManager.findBall(_loc14_.NewBallID);
                           _loc15_.loadBombAsset();
                           _loc15_.loadCraterBitmap();
                        }
                     }
                  }
               }
            }
            _loc6_++;
         }
         var _loc20_:int = 0;
         while(_loc20_ < this._gameInfo.neededMovies.length)
         {
            if(this._gameInfo.neededMovies[_loc20_].type == 2)
            {
               this._gameInfo.neededMovies[_loc20_].startLoad();
            }
            else if(this._gameInfo.neededMovies[_loc20_].type == 1)
            {
               this._gameInfo.neededMovies[_loc20_].startLoad();
            }
            _loc20_++;
         }
         for each(_loc7_ in this._gameInfo.neededPetSkillResource)
         {
            _loc7_.startLoad();
         }
         this._gameInfo.loaderMap = new MapLoader(MapManager.getMapInfo(this._gameInfo.mapIndex));
         this._gameInfo.loaderMap.load();
         switch(NewHandGuideManager.Instance.mapID)
         {
            case 111:
               this._trainerLoad = new TrainerLoader("1");
               break;
            case 112:
               this._trainerLoad = new TrainerLoader("2");
               break;
            case 113:
               this._trainerLoad = new TrainerLoader("3");
               break;
            case 114:
               this._trainerLoad = new TrainerLoader("4");
               break;
            case 115:
               this._trainerLoad = new TrainerLoader("5");
               break;
            case 116:
               this._trainerLoad = new TrainerLoader("6");
         }
         if(Boolean(this._trainerLoad))
         {
            this._trainerLoad.load();
         }
      }
      
      protected function __onLoadingFinished(param1:Event) : void
      {
         var _loc2_:RoomPlayer = param1.currentTarget as RoomPlayer;
         if(_loc2_.progress < 100 || this._hasLoadedFinished.hasKey(_loc2_))
         {
            return;
         }
         ++this._amountOfFinishedPlayer;
         this._hasLoadedFinished.add(_loc2_,_loc2_);
         if(this._amountOfFinishedPlayer == this._gameInfo.roomPlayers.length)
         {
            this.leave();
         }
      }
      
      protected function leave() : void
      {
         if(!this._leaving)
         {
            this._characterItems.forEach(function(param1:roomLoading.view.RoomLoadingCharacterItem, param2:int, param3:Vector.<roomLoading.view.RoomLoadingCharacterItem>):void
            {
               param1.disappear(param1.index.toString());
            });
            this._leaving = true;
         }
      }
      
      private function __countDownTick(param1:TimerEvent) : void
      {
         this._selfFinish = this.checkProgress();
         this._countDownTxt.updateNum();
         if(this._selfFinish)
         {
            dispatchEvent(new Event(Event.COMPLETE));
            if(NewHandGuideManager.Instance.mapID == 111)
            {
               WeakGuildManager.Instance.timeStatistics(1,this._startTime);
            }
         }
      }
      
      private function __countDownComplete(param1:TimerEvent) : void
      {
         if(!this._selfFinish)
         {
            if(RoomManager.Instance.current.type == RoomInfo.MATCH_ROOM || RoomManager.Instance.current.type == RoomInfo.CHALLENGE_ROOM)
            {
               StateManager.setState(StateType.ROOM_LIST);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.FRESHMAN_ROOM)
            {
               StateManager.setState(StateType.MAIN);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.FIGHT_LIB_ROOM)
            {
               StateManager.setState(StateType.MAIN);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.LANBYRINTH_ROOM)
            {
               StateManager.setState(StateType.MAIN,LabyrinthManager.Instance.show);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.WORLD_BOSS_FIGHT)
            {
               WorldBossManager.IsSuccessStartGame = false;
               StateManager.setState(StateType.WORLDBOSS_ROOM);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.CONSORTIA_BATTLE)
            {
               StateManager.setState(StateType.MAIN);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.CRYPTBOSS_ROOM)
            {
               StateManager.setState(StateType.MAIN);
            }
            else
            {
               StateManager.setState(StateType.DUNGEON_LIST);
            }
            SocketManager.Instance.out.sendErrorMsg(this._unloadedmsg);
         }
      }
      
      private function checkProgress() : Boolean
      {
         var _loc1_:RoomPlayer = null;
         var _loc2_:GameNeedPetSkillInfo = null;
         var _loc3_:int = 0;
         var _loc4_:Player = null;
         var _loc5_:PetInfo = null;
         var _loc6_:int = 0;
         var _loc7_:PetSkillTemplateInfo = null;
         var _loc8_:BallInfo = null;
         this._unloadedmsg = "";
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         for each(_loc1_ in this._gameInfo.roomPlayers)
         {
            if(!_loc1_.isViewer)
            {
               _loc4_ = this._gameInfo.findLivingByPlayerID(_loc1_.playerInfo.ID,_loc1_.playerInfo.ZoneID);
               if(_loc4_.character.completed)
               {
                  _loc10_++;
               }
               else
               {
                  this._unloadedmsg += _loc1_.playerInfo.NickName + "gameplayer.character.completed false\n";
                  this._unloadedmsg += _loc4_.character.getCharacterLoadLog();
               }
               _loc9_++;
               if(_loc4_.movie.completed)
               {
                  _loc10_++;
               }
               else
               {
                  this._unloadedmsg += _loc1_.playerInfo.NickName + "gameplayer.movie.completed false\n";
               }
               _loc9_++;
               if(LoadBombManager.Instance.getLoadBombComplete(_loc1_.currentWeapInfo))
               {
                  _loc10_++;
               }
               else
               {
                  this._unloadedmsg += "LoadBombManager.getLoadBombComplete(info.currentWeapInfo) false" + LoadBombManager.Instance.getUnloadedBombString(_loc1_.currentWeapInfo) + "\n";
               }
               _loc9_++;
               _loc5_ = _loc4_.playerInfo.currentPet;
               if(Boolean(_loc5_))
               {
                  if(_loc5_.assetReady)
                  {
                     _loc10_++;
                  }
                  _loc9_++;
                  for each(_loc6_ in _loc5_.equipdSkills)
                  {
                     if(_loc6_ > 0)
                     {
                        _loc7_ = PetSkillManager.getSkillByID(_loc6_);
                        if(Boolean(_loc7_.EffectPic))
                        {
                           if(ModuleLoader.hasDefinition(_loc7_.EffectClassLink))
                           {
                              _loc10_++;
                           }
                           else
                           {
                              this._unloadedmsg += "ModuleLoader.hasDefinition(skill.EffectClassLink):" + _loc7_.EffectClassLink + " false\n";
                           }
                           _loc9_++;
                        }
                        if(_loc7_.NewBallID != -1)
                        {
                           _loc8_ = BallManager.findBall(_loc7_.NewBallID);
                           if(_loc8_.isComplete())
                           {
                              _loc10_++;
                           }
                           else
                           {
                              this._unloadedmsg += "BallManager.findBall(skill.NewBallID):" + _loc7_.NewBallID + "false\n";
                           }
                           _loc9_++;
                        }
                     }
                  }
               }
            }
         }
         for each(_loc2_ in this._gameInfo.neededPetSkillResource)
         {
            if(Boolean(_loc2_.effect))
            {
               if(ModuleLoader.hasDefinition(_loc2_.effectClassLink))
               {
                  _loc10_++;
               }
               else
               {
                  this._unloadedmsg += "ModuleLoader.hasDefinition(" + _loc2_.effectClassLink + ") false\n";
               }
               _loc9_++;
            }
         }
         _loc3_ = 0;
         while(_loc3_ < this._gameInfo.neededMovies.length)
         {
            if(this._gameInfo.neededMovies[_loc3_].type == 2)
            {
               if(ModuleLoader.hasDefinition(this._gameInfo.neededMovies[_loc3_].classPath))
               {
                  _loc10_++;
               }
               else
               {
                  this._unloadedmsg += "ModuleLoader.hasDefinition(_gameInfo.neededMovies[i].classPath):" + this._gameInfo.neededMovies[_loc3_].classPath + " false\n";
               }
               _loc9_++;
            }
            else if(this._gameInfo.neededMovies[_loc3_].type == 1)
            {
               if(LoadBombManager.Instance.getLivingBombComplete(this._gameInfo.neededMovies[_loc3_].bombId))
               {
                  _loc10_++;
               }
               else
               {
                  this._unloadedmsg += "LoadBombManager.getLivingBombComplete(_gameInfo.neededMovies[i].bombId):" + this._gameInfo.neededMovies[_loc3_].bombId + " false\n";
               }
               _loc9_++;
            }
            _loc3_++;
         }
         if(this._gameInfo.loaderMap.completed)
         {
            _loc10_++;
         }
         else
         {
            this._unloadedmsg += "_gameInfo.loaderMap.completed false\n";
         }
         _loc9_++;
         if(LoadBombManager.Instance.getLoadSpecialBombComplete())
         {
            _loc10_++;
         }
         else
         {
            this._unloadedmsg += "LoadBombManager.getLoadSpecialBombComplete() false  " + LoadBombManager.Instance.getUnloadedSpecialBombString() + "\n";
         }
         _loc9_++;
         if(Boolean(this._trainerLoad))
         {
            if(this._trainerLoad.completed)
            {
               _loc10_++;
            }
            else
            {
               this._unloadedmsg += "_trainerLoad.completed false\n";
            }
            _loc9_++;
         }
         var _loc11_:Number = int(_loc10_ / _loc9_ * 100);
         GameInSocketOut.sendLoadingProgress(_loc11_);
         RoomManager.Instance.current.selfRoomPlayer.progress = _loc11_;
         return _loc9_ == _loc10_;
      }
      
      public function dispose() : void
      {
         KeyboardShortcutsManager.Instance.cancelForbidden();
         this._countDownTimer.removeEventListener(TimerEvent.TIMER,this.__countDownTick);
         this._countDownTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__countDownComplete);
         this._countDownTimer.stop();
         this._countDownTimer = null;
         ObjectUtils.disposeObject(this._trainerLoad);
         ObjectUtils.disposeObject(this._bg);
         this._versus.dispose();
         this._countDownTxt.dispose();
         this._battleField.dispose();
         this._tipsItem.dispose();
         this._viewerItem.dispose();
         var _loc1_:int = 0;
         while(_loc1_ < this._characterItems.length)
         {
            TweenMax.killTweensOf(this._characterItems[_loc1_]);
            this._characterItems[_loc1_].dispose();
            this._characterItems[_loc1_] = null;
            _loc1_++;
         }
         if(Boolean(this._dungeonMapItem))
         {
            ObjectUtils.disposeObject(this._dungeonMapItem);
            this._dungeonMapItem = null;
         }
         this._characterItems = null;
         this._trainerLoad = null;
         this._bg = null;
         this._gameInfo = null;
         this._versus = null;
         this._countDownTxt = null;
         this._battleField = null;
         this._tipsItem = null;
         this._countDownTimer = null;
         this._viewerItem = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
