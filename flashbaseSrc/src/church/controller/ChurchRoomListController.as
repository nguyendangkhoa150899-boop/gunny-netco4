package church.controller
{
   import church.model.ChurchRoomListModel;
   import church.view.ChurchMainView;
   import ddt.data.ChurchRoomInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChurchManager;
   import ddt.manager.ExternalInterfaceManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class ChurchRoomListController extends BaseStateView
   {
      
      public static const UNMARRY:String = "unmarry";
       
      
      private var _model:ChurchRoomListModel;
      
      private var _view:ChurchMainView;
      
      private var _mapSrcLoaded:Boolean = false;
      
      private var _mapServerReady:Boolean = false;
      
      public function ChurchRoomListController()
      {
         super();
      }
      
      override public function prepare() : void
      {
         super.prepare();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1,param2);
         this.init();
         this.addEvent();
         MainToolBar.Instance.show();
         SoundManager.instance.playMusic("062");
      }
      
      private function init() : void
      {
         this._model = new ChurchRoomListModel();
         this._view = new ChurchMainView(this,this._model);
         this._view.show();
      }
      
      private function addEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_CREATE,this.__addRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_DISPOSE,this.__removeRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_UPDATE,this.__updateRoom);
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MARRY_ROOM_CREATE,this.__addRoom);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MARRY_ROOM_DISPOSE,this.__removeRoom);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MARRY_ROOM_UPDATE,this.__updateRoom);
      }
      
      private function __addRoom(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:SelfInfo = null;
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:Boolean = _loc3_.readBoolean();
         if(!_loc4_)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.weddingRoom.WeddingRoomControler.addRoom"));
            return;
         }
         var _loc5_:ChurchRoomInfo = new ChurchRoomInfo();
         _loc5_.id = _loc3_.readInt();
         _loc5_.isStarted = _loc3_.readBoolean();
         _loc5_.roomName = _loc3_.readUTF();
         _loc5_.isLocked = _loc3_.readBoolean();
         _loc5_.mapID = _loc3_.readInt();
         _loc5_.valideTimes = _loc3_.readInt();
         _loc5_.currentNum = _loc3_.readInt();
         _loc5_.createID = _loc3_.readInt();
         _loc5_.createName = _loc3_.readUTF();
         _loc5_.groomID = _loc3_.readInt();
         _loc5_.groomName = _loc3_.readUTF();
         _loc5_.brideID = _loc3_.readInt();
         _loc5_.brideName = _loc3_.readUTF();
         _loc5_.creactTime = _loc3_.readDate();
         var _loc6_:int = _loc3_.readByte();
         if(_loc6_ == 1)
         {
            _loc5_.status = ChurchRoomInfo.WEDDING_NONE;
         }
         else
         {
            _loc5_.status = ChurchRoomInfo.WEDDING_ING;
         }
         if(PathManager.solveExternalInterfaceEnabel())
         {
            _loc2_ = PlayerManager.Instance.Self;
            ExternalInterfaceManager.sendToAgent(8,_loc2_.ID,_loc2_.NickName,ServerManager.Instance.zoneName,-1,"",_loc2_.SpouseName);
         }
         _loc5_.discription = _loc3_.readUTF();
         this._model.addRoom(_loc5_);
      }
      
      private function __removeRoom(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         this._model.removeRoom(_loc2_);
      }
      
      private function __updateRoom(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:ChurchRoomInfo = null;
         var _loc3_:int = 0;
         var _loc4_:PackageIn = param1.pkg;
         var _loc5_:Boolean = _loc4_.readBoolean();
         if(_loc5_)
         {
            _loc2_ = new ChurchRoomInfo();
            _loc2_.id = _loc4_.readInt();
            _loc2_.isStarted = _loc4_.readBoolean();
            _loc2_.roomName = _loc4_.readUTF();
            _loc2_.isLocked = _loc4_.readBoolean();
            _loc2_.mapID = _loc4_.readInt();
            _loc2_.valideTimes = _loc4_.readInt();
            _loc2_.currentNum = _loc4_.readInt();
            _loc2_.createID = _loc4_.readInt();
            _loc2_.createName = _loc4_.readUTF();
            _loc2_.groomID = _loc4_.readInt();
            _loc2_.groomName = _loc4_.readUTF();
            _loc2_.brideID = _loc4_.readInt();
            _loc2_.brideName = _loc4_.readUTF();
            _loc2_.creactTime = _loc4_.readDate();
            _loc3_ = _loc4_.readByte();
            if(_loc3_ == 1)
            {
               _loc2_.status = ChurchRoomInfo.WEDDING_NONE;
            }
            else
            {
               _loc2_.status = ChurchRoomInfo.WEDDING_ING;
            }
            _loc2_.discription = _loc4_.readUTF();
            this._model.updateRoom(_loc2_);
         }
      }
      
      public function createRoom(param1:ChurchRoomInfo) : void
      {
         if(Boolean(ChurchManager.instance.selfRoom))
         {
            SocketManager.Instance.out.sendEnterRoom(0,"");
         }
         SocketManager.Instance.out.sendCreateRoom(param1.roomName,Boolean(param1.password) ? param1.password : "",param1.mapID,param1.valideTimes,param1.canInvite,param1.discription);
      }
      
      public function unmarry(param1:Boolean = false) : void
      {
         if(Boolean(ChurchManager.instance._selfRoom))
         {
            if(ChurchManager.instance._selfRoom.status == ChurchRoomInfo.WEDDING_ING)
            {
               SocketManager.Instance.out.sendUnmarry(true);
               SocketManager.Instance.out.sendUnmarry(param1);
               if(Boolean(this._model) && Boolean(ChurchManager.instance._selfRoom))
               {
                  this._model.removeRoom(ChurchManager.instance._selfRoom.id);
               }
               dispatchEvent(new Event(UNMARRY));
               return;
            }
         }
         SocketManager.Instance.out.sendUnmarry(param1);
         if(Boolean(this._model) && Boolean(ChurchManager.instance._selfRoom))
         {
            this._model.removeRoom(ChurchManager.instance._selfRoom.id);
         }
         dispatchEvent(new Event(UNMARRY));
      }
      
      public function changeViewState(param1:String) : void
      {
         this._view.changeState(param1);
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         super.leaving(param1);
         SocketManager.Instance.out.sendExitMarryRoom();
         MainToolBar.Instance.backFunction = null;
         MainToolBar.Instance.hide();
         this.dispose();
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getType() : String
      {
         return StateType.CHURCH_ROOM_LIST;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._model))
         {
            this._model.dispose();
         }
         this._model = null;
         if(Boolean(this._view))
         {
            if(Boolean(this._view.parent))
            {
               this._view.parent.removeChild(this._view);
            }
            this._view.dispose();
         }
         this._view = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
