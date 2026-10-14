package ddt.data.player
{
   import flash.events.EventDispatcher;
   
   public class AcademyPlayerInfo extends EventDispatcher
   {
       
      
      private var _info:ddt.data.player.PlayerInfo;
      
      public var Introduction:String;
      
      public var IsPublishEquip:Boolean;
      
      public function AcademyPlayerInfo()
      {
         super();
      }
      
      public function set info(param1:ddt.data.player.PlayerInfo) : void
      {
         this._info = param1;
      }
      
      public function get info() : ddt.data.player.PlayerInfo
      {
         return this._info;
      }
   }
}
