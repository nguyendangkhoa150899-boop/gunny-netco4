package consortionBattle.view
{
   import church.view.churchScene.MoonSceneMap;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import consortionBattle.event.ConsBatEvent;
   import consortionBattle.player.ConsortiaBattlePlayer;
   import consortionBattle.player.ConsortiaBattlePlayerInfo;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddt.view.scenePathSearcher.PathMapHitTester;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class ConsortiaBattleMapView extends Sprite implements Disposeable
   {
      
      public static const MAP_SIZE:Array = [3208,2000];
       
      
      protected var _mapClassDefinition:String;
      
      protected var _playerModel:DictionaryData;
      
      protected var _bgLayer:Sprite;
      
      protected var _articleLayer:Sprite;
      
      protected var _decorationLayer:Sprite;
      
      protected var _meshLayer:Sprite;
      
      protected var _sceneScene:SceneScene;
      
      protected var _selfPlayer:ConsortiaBattlePlayer;
      
      protected var _lastClick:Number = 0;
      
      protected var _clickInterval:Number = 200;
      
      protected var _mouseMovie:MovieClip;
      
      protected var _characters:DictionaryData;
      
      protected var _clickEnemy:ConsortiaBattlePlayer;
      
      protected var _judgeCreateCount:int = 0;
      
      public function ConsortiaBattleMapView(param1:String, param2:DictionaryData)
      {
         super();
         this._mapClassDefinition = param1;
         this._playerModel = param2;
         this.initData();
         this.initMap();
         this.initMouseMovie();
         this.initSceneScene();
         this.initEvent();
         this.initBeforeTimeView();
      }
      
      private function initBeforeTimeView() : void
      {
         var _loc1_:ConsBatBeforeTimer = null;
         var _loc2_:int = ConsortiaBattleManager.instance.beforeStartTime;
         if(_loc2_ > 0)
         {
            _loc1_ = new ConsBatBeforeTimer(_loc2_);
            LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_DYNAMIC_LAYER,true);
         }
      }
      
      protected function initData() : void
      {
         this._characters = new DictionaryData(true);
      }
      
      protected function initMap() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:Sprite = null;
         _loc1_ = null;
         _loc2_ = null;
         _loc1_ = null;
         _loc2_ = null;
         var _loc3_:MovieClip = new (ClassUtils.uiSourceDomain.getDefinition(this._mapClassDefinition) as Class)() as MovieClip;
         var _loc4_:Sprite = _loc3_.getChildByName("articleLayer") as Sprite;
         _loc1_ = _loc3_.getChildByName("mesh") as Sprite;
         var _loc5_:Sprite = _loc3_.getChildByName("bg") as Sprite;
         _loc2_ = _loc3_.getChildByName("bgSize") as Sprite;
         var _loc6_:Sprite = _loc3_.getChildByName("decoration") as Sprite;
         this._bgLayer = _loc5_ == null ? new Sprite() : _loc5_;
         this._articleLayer = _loc4_ == null ? new Sprite() : _loc4_;
         this._decorationLayer = _loc6_ == null ? new Sprite() : _loc6_;
         this._decorationLayer.mouseChildren = this._decorationLayer.mouseEnabled = false;
         this._meshLayer = _loc1_ == null ? new Sprite() : _loc1_;
         this._meshLayer.alpha = 0;
         this._meshLayer.mouseChildren = false;
         this._meshLayer.mouseEnabled = false;
         this.addChild(this._bgLayer);
         this.addChild(this._articleLayer);
         this.addChild(this._decorationLayer);
         this.addChild(this._meshLayer);
         if(Boolean(_loc2_))
         {
            MAP_SIZE[0] = _loc2_.width;
            MAP_SIZE[1] = _loc2_.height;
         }
         else
         {
            MAP_SIZE[0] = _loc5_.width;
            MAP_SIZE[1] = _loc5_.height;
         }
      }
      
      protected function initMouseMovie() : void
      {
         var _loc1_:Class = ClassUtils.uiSourceDomain.getDefinition("asset.consortiaBattle.MouseClickMovie") as Class;
         this._mouseMovie = new _loc1_() as MovieClip;
         this._mouseMovie.mouseChildren = false;
         this._mouseMovie.mouseEnabled = false;
         this._mouseMovie.stop();
         this._bgLayer.addChild(this._mouseMovie);
      }
      
      protected function initSceneScene() : void
      {
         this._sceneScene = new SceneScene();
         this._sceneScene.setHitTester(new PathMapHitTester(this._meshLayer));
      }
      
      protected function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__click);
         addEventListener(Event.ENTER_FRAME,this.updateMap);
         this._playerModel.addEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._playerModel.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._playerModel.addEventListener(DictionaryEvent.UPDATE,this.__updatePlayerStatus);
         addEventListener(ConsortiaBattlePlayer.CLICK,this.playerClickHandler);
         ConsortiaBattleManager.instance.addEventListener(ConsortiaBattleManager.MOVE_PLAYER,this.movePlayer);
         ConsortiaBattleManager.instance.addEventListener(ConsortiaBattleManager.HIDE_RECORD_CHANGE,this.hidePlayer);
      }
      
      private function hidePlayer(param1:Event) : void
      {
         var _loc2_:ConsortiaBattlePlayer = null;
         for each(_loc2_ in this._characters)
         {
            _loc2_.visible = ConsortiaBattleManager.instance.judgePlayerVisible(_loc2_);
         }
      }
      
      private function playerClickHandler(param1:Event) : void
      {
         this._clickEnemy = param1.target as ConsortiaBattlePlayer;
      }
      
      protected function __addPlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:ConsortiaBattlePlayerInfo = param1.data as ConsortiaBattlePlayerInfo;
         var _loc3_:ConsortiaBattlePlayer = new ConsortiaBattlePlayer(_loc2_,this.addPlayerCallBack);
      }
      
      protected function addPlayerCallBack(param1:ConsortiaBattlePlayer, param2:Boolean, param3:int) : void
      {
         if(param3 == 0)
         {
            if(!this._articleLayer || !param1)
            {
               return;
            }
            param1.playerPoint = param1.playerData.pos;
            param1.sceneCharacterStateType = "natural";
            param1.setSceneCharacterDirectionDefault = param1.sceneCharacterDirection = SceneCharacterDirection.RB;
            if(!this._selfPlayer && param1.playerData.id == PlayerManager.Instance.Self.ID)
            {
               this._selfPlayer = param1;
               this._articleLayer.addChild(this._selfPlayer);
               this._selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
               this.setCenter(null,false);
               this._selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
               SocketManager.Instance.out.sendConsBatRequestPlayerInfo();
               SocketManager.Instance.out.sendConsBatConfirmEnter();
            }
            else
            {
               this._articleLayer.addChild(param1);
            }
            this._characters.add(param1.playerData.id,param1);
         }
      }
      
      protected function __removePlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:int = (param1.data as ConsortiaBattlePlayerInfo).id;
         var _loc3_:ConsortiaBattlePlayer = this._characters[_loc2_] as ConsortiaBattlePlayer;
         this._characters.remove(_loc2_);
         if(_loc3_ == this._clickEnemy)
         {
            this._clickEnemy = null;
         }
         if(Boolean(_loc3_))
         {
            if(Boolean(_loc3_.parent))
            {
               _loc3_.parent.removeChild(_loc3_);
            }
            _loc3_.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
            _loc3_.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
            _loc3_.dispose();
         }
         _loc3_ = null;
      }
      
      protected function __updatePlayerStatus(param1:DictionaryEvent) : void
      {
         var _loc2_:ConsortiaBattlePlayer = null;
         var _loc3_:int = (param1.data as ConsortiaBattlePlayerInfo).id;
         if(Boolean(this._characters[_loc3_]))
         {
            _loc2_ = this._characters[_loc3_] as ConsortiaBattlePlayer;
            _loc2_.refreshStatus();
         }
      }
      
      private function playerActionChange(param1:SceneCharacterEvent) : void
      {
         var _loc2_:String = String(param1.data.toString());
         if(_loc2_ == "naturalStandFront" || _loc2_ == "naturalStandBack")
         {
            if(Boolean(this._mouseMovie))
            {
               this._mouseMovie.gotoAndStop(1);
            }
         }
      }
      
      public function setCenter(param1:SceneCharacterEvent = null, param2:Boolean = true, param3:Point = null) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Point = null;
         if(!this._selfPlayer && !param3 || param2 && ConsortiaBattleManager.instance.beforeStartTime > 0)
         {
            return;
         }
         if(Boolean(this._selfPlayer))
         {
            _loc6_ = this._selfPlayer.playerPoint;
         }
         else
         {
            _loc6_ = param3;
         }
         _loc4_ = -(_loc6_.x - MoonSceneMap.GAME_WIDTH / 2);
         _loc5_ = -(_loc6_.y - MoonSceneMap.GAME_HEIGHT / 2) + 50;
         if(_loc4_ > 0)
         {
            _loc4_ = 0;
         }
         if(_loc4_ < MoonSceneMap.GAME_WIDTH - MAP_SIZE[0])
         {
            _loc4_ = MoonSceneMap.GAME_WIDTH - MAP_SIZE[0];
         }
         if(_loc5_ > 0)
         {
            _loc5_ = 0;
         }
         if(_loc5_ < MoonSceneMap.GAME_HEIGHT - MAP_SIZE[1])
         {
            _loc5_ = MoonSceneMap.GAME_HEIGHT - MAP_SIZE[1];
         }
         x = _loc4_;
         y = _loc5_;
      }
      
      protected function __click(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         _loc2_ = null;
         if(!this._selfPlayer || !this._selfPlayer.isCanWalk)
         {
            return;
         }
         _loc2_ = this.globalToLocal(new Point(param1.stageX,param1.stageY));
         if(getTimer() - this._lastClick > this._clickInterval)
         {
            this._lastClick = getTimer();
            if(!this._sceneScene.hit(_loc2_))
            {
               this._selfPlayer.walkPath = this._sceneScene.searchPath(this._selfPlayer.playerPoint,_loc2_);
               this._selfPlayer.walkPath.shift();
               this._selfPlayer.isWalkPathChange = true;
               this.sendMyPosition(this._selfPlayer.walkPath.concat());
               this._mouseMovie.x = _loc2_.x;
               this._mouseMovie.y = _loc2_.y;
               this._mouseMovie.play();
            }
         }
      }
      
      protected function sendMyPosition(param1:Array) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Array = [];
         while(_loc2_ < param1.length)
         {
            _loc3_.push(int(param1[_loc2_].x),int(param1[_loc2_].y));
            _loc2_++;
         }
         var _loc4_:String = String(_loc3_.toString());
         SocketManager.Instance.out.sendConsBatMove(param1[param1.length - 1].x,param1[param1.length - 1].y,_loc4_);
      }
      
      protected function movePlayer(param1:ConsBatEvent) : void
      {
         var _loc2_:ConsortiaBattlePlayer = null;
         var _loc3_:int = int(param1.data.id);
         var _loc4_:Array = param1.data.path;
         if(Boolean(this._characters[_loc3_]))
         {
            _loc2_ = this._characters[_loc3_] as ConsortiaBattlePlayer;
            _loc2_.walkPath = _loc4_;
            _loc2_.isWalkPathChange = true;
            _loc2_.playerWalk(_loc4_);
         }
      }
      
      protected function updateMap(param1:Event) : void
      {
         var _loc2_:ConsortiaBattlePlayer = null;
         ++this._judgeCreateCount;
         if(this._judgeCreateCount > 25)
         {
            ConsortiaBattleManager.instance.judgeCreatePlayer(this.x,this.y);
            this._judgeCreateCount = 0;
         }
         if(!this._characters || this._characters.length <= 0)
         {
            return;
         }
         for each(_loc2_ in this._characters)
         {
            _loc2_.updatePlayer();
         }
         this.BuildEntityDepth();
         this.judgeEnemy();
      }
      
      protected function judgeEnemy() : void
      {
         if(!this._clickEnemy || !this._selfPlayer)
         {
            return;
         }
         if(Point.distance(new Point(this._selfPlayer.x,this._selfPlayer.y),new Point(this._clickEnemy.x,this._clickEnemy.y)) < 100)
         {
            SocketManager.Instance.out.sendConsBatChallenge(this._clickEnemy.playerData.id);
            this._clickEnemy = null;
         }
      }
      
      protected function BuildEntityDepth() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:DisplayObject = null;
         var _loc7_:Number = NaN;
         var _loc8_:int = this._articleLayer.numChildren;
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_ - 1)
         {
            _loc1_ = this._articleLayer.getChildAt(_loc9_);
            _loc2_ = this.getPointDepth(_loc1_.x,_loc1_.y);
            _loc4_ = Number.MAX_VALUE;
            _loc5_ = _loc9_ + 1;
            while(_loc5_ < _loc8_)
            {
               _loc6_ = this._articleLayer.getChildAt(_loc5_);
               _loc7_ = this.getPointDepth(_loc6_.x,_loc6_.y);
               if(_loc7_ < _loc4_)
               {
                  _loc3_ = _loc5_;
                  _loc4_ = _loc7_;
               }
               _loc5_++;
            }
            if(_loc2_ > _loc4_)
            {
               this._articleLayer.swapChildrenAt(_loc9_,_loc3_);
            }
            _loc9_++;
         }
      }
      
      protected function getPointDepth(param1:Number, param2:Number) : Number
      {
         return MAP_SIZE[0] * param2 + param1;
      }
      
      public function addSelfPlayer() : void
      {
         var _loc1_:ConsortiaBattlePlayerInfo = null;
         var _loc2_:ConsortiaBattlePlayer = null;
         if(!this._selfPlayer)
         {
            _loc1_ = ConsortiaBattleManager.instance.getPlayerInfo(PlayerManager.Instance.Self.ID);
            _loc2_ = new ConsortiaBattlePlayer(_loc1_,this.addPlayerCallBack);
            this.setCenter(null,false,_loc1_.pos);
         }
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__click);
         removeEventListener(Event.ENTER_FRAME,this.updateMap);
         if(Boolean(this._playerModel))
         {
            this._playerModel.removeEventListener(DictionaryEvent.ADD,this.__addPlayer);
         }
         if(Boolean(this._playerModel))
         {
            this._playerModel.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         }
         if(Boolean(this._playerModel))
         {
            this._playerModel.removeEventListener(DictionaryEvent.UPDATE,this.__updatePlayerStatus);
         }
         removeEventListener(ConsortiaBattlePlayer.CLICK,this.playerClickHandler);
         ConsortiaBattleManager.instance.removeEventListener(ConsortiaBattleManager.MOVE_PLAYER,this.movePlayer);
         ConsortiaBattleManager.instance.removeEventListener(ConsortiaBattleManager.HIDE_RECORD_CHANGE,this.hidePlayer);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._playerModel = null;
         if(Boolean(this._mouseMovie))
         {
            this._mouseMovie.gotoAndStop(1);
         }
         ObjectUtils.disposeAllChildren(this._articleLayer);
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this._sceneScene))
         {
            this._sceneScene.dispose();
         }
         this._bgLayer = null;
         this._articleLayer = null;
         this._decorationLayer = null;
         this._meshLayer = null;
         this._sceneScene = null;
         this._selfPlayer = null;
         this._clickEnemy = null;
         this._mouseMovie = null;
         this._characters = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
