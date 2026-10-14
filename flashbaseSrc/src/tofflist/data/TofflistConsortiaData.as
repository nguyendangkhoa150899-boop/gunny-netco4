package tofflist.data
{
   public class TofflistConsortiaData
   {
       
      
      private var _playerInfo:tofflist.data.TofflistPlayerInfo;
      
      private var _consortiaInfo:tofflist.data.TofflistConsortiaInfo;
      
      public function TofflistConsortiaData()
      {
         super();
      }
      
      public function set playerInfo(param1:tofflist.data.TofflistPlayerInfo) : void
      {
         this._playerInfo = param1;
      }
      
      public function get playerInfo() : tofflist.data.TofflistPlayerInfo
      {
         return this._playerInfo;
      }
      
      public function set consortiaInfo(param1:tofflist.data.TofflistConsortiaInfo) : void
      {
         this._consortiaInfo = param1;
      }
      
      public function get consortiaInfo() : tofflist.data.TofflistConsortiaInfo
      {
         return this._consortiaInfo;
      }
   }
}
