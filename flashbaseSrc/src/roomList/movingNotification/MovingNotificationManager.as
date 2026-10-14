package roomList.movingNotification
{
   import ddt.data.analyze.MovingNotificationAnalyzer;
   import flash.display.DisplayObjectContainer;
   
   public class MovingNotificationManager
   {
      
      private static var _instance:roomList.movingNotification.MovingNotificationManager;
       
      
      private var _list:Array;
      
      private var _view:roomList.movingNotification.MovingNotificationView;
      
      public function MovingNotificationManager()
      {
         super();
         this._list = [];
      }
      
      public static function get Instance() : roomList.movingNotification.MovingNotificationManager
      {
         if(!_instance)
         {
            _instance = new roomList.movingNotification.MovingNotificationManager();
         }
         return _instance;
      }
      
      public function setup(param1:MovingNotificationAnalyzer) : void
      {
         this._list = param1.list;
      }
      
      public function showIn(param1:DisplayObjectContainer) : void
      {
         if(!this._view)
         {
            this._view = new roomList.movingNotification.MovingNotificationView();
         }
         this._view.list = this._list;
         param1.addChild(this._view);
      }
      
      public function get view() : roomList.movingNotification.MovingNotificationView
      {
         return this._view;
      }
      
      public function hide() : void
      {
         if(Boolean(this._view))
         {
            this._view.dispose();
         }
         this._view = null;
      }
   }
}
