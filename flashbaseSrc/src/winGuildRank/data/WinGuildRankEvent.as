package winGuildRank.data
{
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class WinGuildRankEvent extends Event
   {
      
      public static const UPDATE:String = "updateWinGuildRank";
       
      
      private var _pkg:PackageIn;
      
      public function WinGuildRankEvent(param1:String, param2:PackageIn = null)
      {
         super(param1,bubbles,cancelable);
         this._pkg = param2;
      }
      
      public function get pkg() : PackageIn
      {
         return this._pkg;
      }
   }
}
