package roomList.pvpRoomList
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.ChatManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.geom.Point;
   import roomList.movingNotification.MovingNotificationManager;
   
   public class RoomListView extends Sprite implements Disposeable
   {
       
      
      private var _roomListBg:roomList.pvpRoomList.RoomListBGView;
      
      private var _playerList:roomList.pvpRoomList.RoomListPlayerListView;
      
      private var _chatView:Sprite;
      
      private var _model:roomList.pvpRoomList.RoomListModel;
      
      private var _controller:roomList.pvpRoomList.RoomListController;
      
      public function RoomListView(param1:roomList.pvpRoomList.RoomListController, param2:roomList.pvpRoomList.RoomListModel)
      {
         var _loc3_:Point = null;
         this._model = param2;
         this._controller = param1;
         super();
         this._roomListBg = new roomList.pvpRoomList.RoomListBGView(this._controller,this._model);
         addChild(this._roomListBg);
         MovingNotificationManager.Instance.showIn(this);
         PositionUtils.setPos(MovingNotificationManager.Instance.view,"roomList.MovingNotificationRoomPos");
         ChatManager.Instance.state = ChatManager.CHAT_ROOMLIST_STATE;
         this._chatView = ChatManager.Instance.view;
         addChild(this._chatView);
         this._playerList = new roomList.pvpRoomList.RoomListPlayerListView(this._model.getPlayerList());
         _loc3_ = ComponentFactory.Instance.creatCustomObject("roomList.playerListPos");
         this._playerList.x = _loc3_.x;
         this._playerList.y = _loc3_.y;
         addChild(this._playerList);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._roomListBg) && Boolean(this._roomListBg.parent))
         {
            this._roomListBg.parent.removeChild(this._roomListBg);
            this._roomListBg.dispose();
            this._roomListBg = null;
         }
         MovingNotificationManager.Instance.hide();
         if(Boolean(this._chatView) && Boolean(this._chatView.parent))
         {
            this._chatView.parent.removeChild(this._chatView);
         }
         if(Boolean(this._playerList) && Boolean(this._playerList.parent))
         {
            this._playerList.parent.removeChild(this._playerList);
            this._playerList.dispose();
            this._playerList = null;
         }
         if(Boolean(parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
