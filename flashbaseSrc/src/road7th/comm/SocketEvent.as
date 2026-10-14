package road7th.comm
{
   import flash.events.Event;
   
   public class SocketEvent extends Event
   {
      
      public static const DATA:String = "data";
       
      
      private var _data:road7th.comm.PackageIn;
      
      public function SocketEvent(param1:String, param2:road7th.comm.PackageIn)
      {
         super(param1);
         this._data = param2;
      }
      
      public function get data() : road7th.comm.PackageIn
      {
         return this._data;
      }
   }
}
