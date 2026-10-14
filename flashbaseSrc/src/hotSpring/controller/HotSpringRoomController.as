package hotSpring.controller
{
   import ddt.data.HotSpringRoomInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.HotSpringManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import hotSpring.model.HotSpringRoomModel;
   import hotSpring.view.HotSpringRoomView;
   import hotSpring.vo.PlayerVO;
   import road7th.comm.PackageIn;
   
   public class HotSpringRoomController extends BaseStateView
   {
       
      
      private var _model:HotSpringRoomModel;
      
      private var _view:HotSpringRoomView;
      
      private var _isActive:Boolean = true;
      
      private var _messageTip:String;
      
      public function HotSpringRoomController()
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
         HotSpringManager.instance.removeLoadingEvent();
         this._model = HotSpringRoomModel.Instance;
         if(Boolean(this._view))
         {
            this._view.hide();
            this._view.dispose();
         }
         this._view = null;
         this._view = new HotSpringRoomView(this,this._model);
         this._view.show();
         graphics.beginFill(0);
         graphics.drawRect(0,0,995,595);
         graphics.endFill();
         this.setEvent();
      }
      
      private function setEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_ADD_OR_UPDATE,this.roomAddOrUpdate);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_ADD,this.roomPlayerAdd);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_REMOVE_NOTICE,this.roomPlayerRemoveNotice);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_TARGET_POINT,this.roomPlayerTargetPoint);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONTINU_BY_MONEY_SUCCESS,this.updateTime);
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_ADD_OR_UPDATE,this.roomAddOrUpdate);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_ADD,this.roomPlayerAdd);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_REMOVE_NOTICE,this.roomPlayerRemoveNotice);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_TARGET_POINT,this.roomPlayerTargetPoint);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONTINU_BY_MONEY_SUCCESS,this.updateTime);
         removeEventListener(Event.ACTIVATE,this.__activeChange);
         removeEventListener(Event.DEACTIVATE,this.__activeChange);
         removeEventListener(MouseEvent.CLICK,this.__activeChange);
      }
      
      private function updateTime(param1:CrazyTankSocketEvent) : void
      {
         this._view.updataRoomTime();
      }
      
      public function hotAddtime() : void
      {
         SocketManager.Instance.out.sendHotAddTime();
      }
      
      private function __activeChange(param1:Event) : void
      {
         if(param1.type == Event.DEACTIVATE)
         {
            this._isActive = false;
         }
         else
         {
            this._isActive = true;
         }
      }
      
      private function roomAddOrUpdate(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:HotSpringRoomInfo = new HotSpringRoomInfo();
         _loc3_.roomNumber = _loc2_.readInt();
         _loc3_.roomID = _loc2_.readInt();
         _loc3_.roomName = _loc2_.readUTF();
         _loc3_.roomPassword = _loc2_.readUTF();
         _loc3_.effectiveTime = _loc2_.readInt();
         _loc3_.curCount = _loc2_.readInt();
         _loc3_.playerID = _loc2_.readInt();
         _loc3_.playerName = _loc2_.readUTF();
         _loc3_.startTime = _loc2_.readDate();
         _loc3_.roomIntroduction = _loc2_.readUTF();
         _loc3_.roomType = _loc2_.readInt();
         _loc3_.maxCount = _loc2_.readInt();
         _loc3_.roomIsPassword = _loc3_.roomPassword != "" && _loc3_.roomPassword.length > 0;
         if(Boolean(HotSpringManager.instance.roomCurrently) && _loc3_.roomID == HotSpringManager.instance.roomCurrently.roomID)
         {
            HotSpringManager.instance.roomCurrently = _loc3_;
         }
      }
      
      private function roomPlayerAdd(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PlayerVO = null;
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:int = _loc3_.readInt();
         if(_loc4_ == PlayerManager.Instance.Self.ID)
         {
            _loc2_ = this._model.selfVO;
         }
         else
         {
            _loc2_ = new PlayerVO();
         }
         var _loc5_:PlayerInfo = PlayerManager.Instance.findPlayer(_loc4_);
         _loc5_.beginChanges();
         _loc5_.Grade = _loc3_.readInt();
         _loc5_.Hide = _loc3_.readInt();
         _loc5_.Repute = _loc3_.readInt();
         _loc5_.NickName = _loc3_.readUTF();
         _loc5_.typeVIP = _loc3_.readByte();
         _loc5_.VIPLevel = _loc3_.readInt();
         _loc5_.Sex = _loc3_.readBoolean();
         _loc5_.Style = _loc3_.readUTF();
         _loc5_.Colors = _loc3_.readUTF();
         _loc5_.Skin = _loc3_.readUTF();
         var _loc6_:Point = new Point(_loc3_.readInt(),_loc3_.readInt());
         _loc5_.FightPower = _loc3_.readInt();
         _loc5_.WinCount = _loc3_.readInt();
         _loc5_.TotalCount = _loc3_.readInt();
         _loc2_.playerDirection = _loc3_.readInt();
         _loc5_.commitChanges();
         _loc2_.playerInfo = _loc5_;
         _loc2_.playerPos = _loc6_;
         if(_loc4_ == PlayerManager.Instance.Self.ID)
         {
            this._model.selfVO = _loc2_;
         }
         this._model.roomPlayerAddOrUpdate(_loc2_);
      }
      
      public function roomPlayerRemoveSend(param1:String = "") : void
      {
         HotSpringManager.instance.messageTip = param1;
         SocketManager.Instance.out.sendHotSpringRoomPlayerRemove();
      }
      
      private function roomPlayerRemoveNotice(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         this._model.roomPlayerRemove(_loc3_);
      }
      
      public function roomPlayerTargetPointSend(param1:PlayerVO) : void
      {
         SocketManager.Instance.out.sendHotSpringRoomPlayerTargetPoint(param1);
      }
      
      private function roomPlayerTargetPoint(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Point = null;
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:String = _loc3_.readUTF();
         var _loc5_:int = _loc3_.readInt();
         var _loc6_:int = _loc3_.readInt();
         var _loc7_:int = _loc3_.readInt();
         var _loc8_:Array = _loc4_.split(",");
         var _loc9_:Array = [];
         var _loc10_:uint = 0;
         while(_loc10_ < _loc8_.length)
         {
            _loc2_ = new Point(_loc8_[_loc10_],_loc8_[_loc10_ + 1]);
            _loc9_.push(_loc2_);
            _loc10_ += 2;
         }
         var _loc11_:PlayerVO = this._model.roomPlayerList[_loc5_] as PlayerVO;
         if(!_loc11_)
         {
            return;
         }
         if(this._isActive)
         {
            _loc11_.currentWalkStartPoint = new Point(_loc6_,_loc7_);
            _loc11_.walkPath = _loc9_;
            this._model.roomPlayerAddOrUpdate(_loc11_);
         }
         else
         {
            _loc11_.playerPos = _loc9_.pop();
         }
      }
      
      public function roomRenewalFee(param1:HotSpringRoomInfo) : void
      {
         SocketManager.Instance.out.sendHotSpringRoomRenewalFee(param1.roomID);
      }
      
      public function roomEdit(param1:HotSpringRoomInfo) : void
      {
         SocketManager.Instance.out.sendHotSpringRoomEdit(param1);
      }
      
      public function roomPlayerContinue(param1:Boolean) : void
      {
         SocketManager.Instance.out.sendHotSpringRoomPlayerContinue(param1);
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         this.roomPlayerRemoveSend();
         this.dispose();
         super.leaving(param1);
      }
      
      override public function getBackType() : String
      {
         return StateType.HOT_SPRING_ROOM_LIST;
      }
      
      override public function getType() : String
      {
         return StateType.HOT_SPRING_ROOM;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(Boolean(this._view))
         {
            this._view.hide();
            this._view.dispose();
         }
         this._view = null;
         if(Boolean(this._model))
         {
            this._model.dispose();
         }
         this._model = null;
      }
   }
}
