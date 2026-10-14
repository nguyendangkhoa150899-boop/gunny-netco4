package consumeRank.data
{
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class ConsumeRankEvent extends Event
   {
      
      public static const UPDATE:String = "updateConsumeRank";
       
      
      private var _pkg:PackageIn;
      
      public function ConsumeRankEvent(param1:String, param2:PackageIn = null)
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
