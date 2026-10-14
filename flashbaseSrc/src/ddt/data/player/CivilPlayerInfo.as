package ddt.data.player
{
   import flash.events.EventDispatcher;
   
   public class CivilPlayerInfo extends EventDispatcher
   {
       
      
      private var _info:ddt.data.player.PlayerInfo;
      
      public var MarryInfoID:int;
      
      public var IsPublishEquip:Boolean;
      
      public var Introduction:String;
      
      public var IsConsortia:Boolean;
      
      public var UserId:Number;
      
      public function CivilPlayerInfo()
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
