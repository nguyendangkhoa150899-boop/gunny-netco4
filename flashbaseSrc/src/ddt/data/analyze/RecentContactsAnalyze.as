package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerState;
   import road7th.data.DictionaryData;
   
   public class RecentContactsAnalyze extends DataAnalyzer
   {
       
      
      public var recentContacts:DictionaryData;
      
      public function RecentContactsAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:FriendListPlayer = null;
         var _loc5_:PlayerState = null;
         var _loc6_:XML = new XML(param1);
         this.recentContacts = new DictionaryData();
         if(_loc6_.@value == "true")
         {
            _loc2_ = _loc6_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new FriendListPlayer();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               _loc5_ = new PlayerState(int(_loc6_.Item[_loc3_].@State));
               _loc4_.playerState = _loc5_;
               this.recentContacts.add(_loc4_.ID,_loc4_);
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc6_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
