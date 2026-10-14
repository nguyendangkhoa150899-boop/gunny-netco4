package game.actions
{
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.PathInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import game.GameManager;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.model.TurnedLiving;
   import game.objects.GameLiving;
   import game.objects.SimpleBox;
   import game.view.map.MapView;
   import org.aswing.KeyboardManager;
   import road7th.comm.PackageIn;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   
   public class ChangePlayerAction extends BaseAction
   {
       
      
      private var _map:MapView;
      
      private var _info:Living;
      
      private var _count:int;
      
      private var _changed:Boolean;
      
      private var _pkg:PackageIn;
      
      private var _event:CrazyTankSocketEvent;
      
      public function ChangePlayerAction(param1:MapView, param2:Living, param3:CrazyTankSocketEvent, param4:PackageIn, param5:Number = 200)
      {
         super();
         this._event = param3;
         this._event.executed = false;
         this._pkg = param4;
         this._map = param1;
         this._info = param2;
         this._count = param5 / 40;
      }
      
      private function syncMap() : void
      {
         var _loc4_:int = 0;
         var _loc6_:SimpleBox = null;
         var _loc1_:LocalPlayer = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc4_ = 0;
         var _loc5_:int = 0;
         _loc6_ = null;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Boolean = false;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:Living = null;
         var _loc21_:Boolean = this._pkg.readBoolean();
         var _loc22_:int = this._pkg.readByte();
         var _loc23_:int = this._pkg.readByte();
         var _loc24_:int = this._pkg.readByte();
         var _loc25_:Array = new Array();
         _loc25_ = [_loc21_,_loc22_,_loc23_,_loc24_];
         GameManager.Instance.Current.setWind(GameManager.Instance.Current.wind,this._info.LivingID == GameManager.Instance.Current.selfGamePlayer.LivingID,_loc25_);
         this._info.isHidden = this._pkg.readBoolean();
         var _loc26_:int = this._pkg.readInt();
         if(this._info is LocalPlayer)
         {
            _loc1_ = LocalPlayer(this._info);
            if(_loc26_ > 0)
            {
               _loc1_.turnTime = _loc26_;
            }
            else
            {
               _loc1_.turnTime = RoomManager.getTurnTimeByType(RoomManager.Instance.current.timeType);
            }
            if(_loc26_ != RoomManager.getTurnTimeByType(RoomManager.Instance.current.timeType))
            {
            }
         }
         var _loc27_:int = this._pkg.readInt();
         var _loc28_:uint = 0;
         while(_loc28_ < _loc27_)
         {
            _loc2_ = this._pkg.readInt();
            _loc3_ = this._pkg.readInt();
            _loc4_ = this._pkg.readInt();
            _loc5_ = this._pkg.readInt();
            _loc6_ = new SimpleBox(_loc2_,String(PathInfo.GAME_BOXPIC),_loc5_);
            _loc6_.x = _loc3_;
            _loc6_.y = _loc4_;
            this._map.addPhysical(_loc6_);
            _loc28_++;
         }
         var _loc29_:int = this._pkg.readInt();
         var _loc30_:int = 0;
         while(_loc30_ < _loc29_)
         {
            _loc7_ = this._pkg.readInt();
            _loc8_ = this._pkg.readBoolean();
            _loc9_ = this._pkg.readInt();
            _loc10_ = this._pkg.readInt();
            _loc11_ = this._pkg.readInt();
            _loc12_ = this._pkg.readBoolean();
            _loc13_ = this._pkg.readInt();
            _loc14_ = this._pkg.readInt();
            _loc15_ = this._pkg.readInt();
            _loc16_ = this._pkg.readInt();
            _loc17_ = this._pkg.readInt();
            _loc18_ = this._pkg.readInt();
            _loc19_ = this._pkg.readInt();
            _loc20_ = GameManager.Instance.Current.livings[_loc7_];
            if(Boolean(_loc20_))
            {
               _loc20_.updateBlood(_loc11_,5);
               _loc20_.isNoNole = _loc12_;
               _loc20_.maxEnergy = _loc13_;
               _loc20_.psychic = _loc14_;
               if(_loc20_.isSelf)
               {
                  _loc1_ = LocalPlayer(_loc20_);
                  _loc1_.energy = _loc20_.maxEnergy;
                  _loc1_.shootCount = _loc18_;
                  _loc1_.dander = _loc15_;
                  if(Boolean(_loc1_.currentPet))
                  {
                     _loc1_.currentPet.MaxMP = _loc16_;
                     _loc1_.currentPet.MP = _loc17_;
                  }
                  _loc1_.soulPropCount = 0;
                  _loc1_.flyCount = _loc19_;
               }
               if(!_loc8_)
               {
                  _loc20_.die();
               }
               else
               {
                  _loc20_.onChange = false;
                  _loc20_.pos = new Point(_loc9_,_loc10_);
                  _loc20_.onChange = true;
               }
            }
            _loc30_++;
         }
         this._map.currentTurn = this._pkg.readInt();
      }
      
      override public function execute() : void
      {
         if(!this._changed)
         {
            if(this._map.hasSomethingMoving() == false && (this._map.currentPlayer == null || this._map.currentPlayer.actionCount == 0))
            {
               this.executeImp(false);
            }
         }
         else
         {
            --this._count;
            if(this._count <= 0)
            {
               this.changePlayer();
            }
         }
      }
      
      private function changePlayer() : void
      {
         if(this._info is TurnedLiving)
         {
            TurnedLiving(this._info).isAttacking = true;
         }
         this._map.gameView.updateControlBarState(this._info);
         _isFinished = true;
      }
      
      override public function cancel() : void
      {
         this._event.executed = true;
      }
      
      private function executeImp(param1:Boolean) : void
      {
         var _loc3_:MovieClipWrapper = null;
         var _loc2_:Living = null;
         _loc3_ = null;
         if(!this._info.isExist)
         {
            _isFinished = true;
            this._map.gameView.updateControlBarState(null);
            return;
         }
         if(!this._changed)
         {
            this._event.executed = true;
            this._changed = true;
            if(Boolean(this._pkg))
            {
               this.syncMap();
            }
            for each(_loc2_ in GameManager.Instance.Current.livings)
            {
               _loc2_.beginNewTurn();
            }
            this._map.gameView.setCurrentPlayer(this._info);
            (this._map.getPhysical(this._info.LivingID) as GameLiving).needFocus(0,0,{"priority":3});
            this._info.gemDefense = false;
            if(this._info is LocalPlayer && !param1)
            {
               KeyboardManager.getInstance().reset();
               SoundManager.instance.play("016");
               _loc3_ = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.TurnAsset")),true,true);
               _loc3_.repeat = false;
               _loc3_.movie.mouseChildren = _loc3_.movie.mouseEnabled = false;
               _loc3_.movie.x = 440;
               _loc3_.movie.y = 180;
               this._map.gameView.addChild(_loc3_.movie);
            }
            else
            {
               SoundManager.instance.play("038");
               this.changePlayer();
            }
         }
      }
      
      override public function executeAtOnce() : void
      {
         super.executeAtOnce();
         this.executeImp(true);
      }
   }
}
