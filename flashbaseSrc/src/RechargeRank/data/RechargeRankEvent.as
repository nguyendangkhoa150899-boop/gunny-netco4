package RechargeRank.data
{
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class RechargeRankEvent extends Event
   {
      
      public static const RECHARGERANKUPDATE:String = "RechargeRankupdate";
       
      
      private var _pkg:PackageIn;
      
      public function RechargeRankEvent(param1:String, param2:PackageIn = null)
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
