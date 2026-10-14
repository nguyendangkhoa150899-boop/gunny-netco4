package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerState;
   import road7th.data.DictionaryData;
   import road7th.utils.DateUtils;
   
   public class MyAcademyPlayersAnalyze extends DataAnalyzer
   {
       
      
      public var myAcademyPlayers:DictionaryData;
      
      public function MyAcademyPlayersAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:FriendListPlayer = null;
         var _loc5_:PlayerState = null;
         var _loc6_:String = null;
         var _loc7_:XML = new XML(param1);
         this.myAcademyPlayers = new DictionaryData();
         if(_loc7_.@value == "true")
         {
            _loc2_ = _loc7_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new FriendListPlayer();
               _loc4_.ID = _loc2_[_loc3_].@UserID;
               _loc5_ = new PlayerState(int(_loc2_[_loc3_].@State));
               _loc4_.playerState = _loc5_;
               _loc4_.apprenticeshipState = _loc2_[_loc3_].@ApprenticeshipState;
               _loc4_.IsMarried = _loc2_[_loc3_].@IsMarried;
               _loc6_ = _loc2_[_loc3_].@LastDate;
               _loc4_.lastDate = DateUtils.dealWithStringDate(_loc6_);
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               this.myAcademyPlayers.add(_loc4_.ID,_loc4_);
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc7_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
