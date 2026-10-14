package roomList.pveRoomList
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.ChatManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.geom.Point;
   import roomList.LookupEnumerate;
   import roomList.movingNotification.MovingNotificationManager;
   import roomList.pvpRoomList.RoomListPlayerListView;
   
   public class DungeonListView extends Sprite implements Disposeable
   {
       
      
      private var _dungeonListBGView:roomList.pveRoomList.DungeonListBGView;
      
      private var _chatView:Sprite;
      
      private var _playerList:RoomListPlayerListView;
      
      private var _model:roomList.pveRoomList.DungeonListModel;
      
      private var _controlle:roomList.pveRoomList.DungeonListController;
      
      public function DungeonListView(param1:roomList.pveRoomList.DungeonListController, param2:roomList.pveRoomList.DungeonListModel)
      {
         this._controlle = param1;
         this._model = param2;
         super();
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:Point = null;
         this._dungeonListBGView = new roomList.pveRoomList.DungeonListBGView(this._controlle,this._model);
         addChild(this._dungeonListBGView);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("dungeonList.playerListPos");
         this._playerList = new RoomListPlayerListView(this._model.getPlayerList());
         this._playerList.type = LookupEnumerate.DUNGEON_LIST;
         this._playerList.x = _loc1_.x;
         this._playerList.y = _loc1_.y;
         addChild(this._playerList);
         MovingNotificationManager.Instance.showIn(this);
         PositionUtils.setPos(MovingNotificationManager.Instance.view,"roomList.MovingNotificationDungeonPos");
         ChatManager.Instance.state = ChatManager.CHAT_DUNGEONLIST_STATE;
         this._chatView = ChatManager.Instance.view;
         addChild(this._chatView);
      }
      
      public function dispose() : void
      {
         MovingNotificationManager.Instance.hide();
         if(Boolean(this._dungeonListBGView) && Boolean(this._dungeonListBGView.parent))
         {
            this._dungeonListBGView.parent.removeChild(this._dungeonListBGView);
            this._dungeonListBGView.dispose();
            this._dungeonListBGView = null;
         }
         if(Boolean(this._playerList) && Boolean(this._playerList.parent))
         {
            this._playerList.parent.removeChild(this._playerList);
            this._playerList.dispose();
            this._playerList = null;
         }
         this._model = null;
         this._controlle = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
