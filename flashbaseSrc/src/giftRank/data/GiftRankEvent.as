package giftRank.data
{
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class GiftRankEvent extends Event
   {
      
      public static const UPDATE:String = "updateGiftRank";
       
      
      private var _pkg:PackageIn;
      
      public function GiftRankEvent(param1:String, param2:PackageIn = null)
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
