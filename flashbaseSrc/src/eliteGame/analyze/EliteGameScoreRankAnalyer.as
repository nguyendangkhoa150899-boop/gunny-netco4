package eliteGame.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import eliteGame.info.EliteGameAllScoreRankInfo;
   import eliteGame.info.EliteGameScroeRankInfo;
   
   public class EliteGameScoreRankAnalyer extends DataAnalyzer
   {
       
      
      public var scoreRankInfo:EliteGameAllScoreRankInfo;
      
      public function EliteGameScoreRankAnalyer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:XMLList = null;
         var _loc5_:Vector.<EliteGameScroeRankInfo> = null;
         var _loc6_:int = 0;
         var _loc7_:EliteGameScroeRankInfo = null;
         this.scoreRankInfo = new EliteGameAllScoreRankInfo();
         var _loc8_:XML = new XML(param1);
         if(_loc8_.@value == "true")
         {
            this.scoreRankInfo.lassUpdateTime = _loc8_.@lastUpdateTime;
            _loc2_ = _loc8_.ItemSet;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = _loc2_[_loc3_].Item;
               _loc5_ = new Vector.<EliteGameScroeRankInfo>();
               _loc6_ = 0;
               while(_loc6_ < _loc4_.length())
               {
                  _loc7_ = new EliteGameScroeRankInfo();
                  _loc7_.nickName = _loc4_[_loc6_].@PlayerName;
                  _loc7_.rank = _loc4_[_loc6_].@PlayerRank;
                  _loc7_.scroe = _loc4_[_loc6_].@PlayerScore;
                  _loc5_.push(_loc7_);
                  _loc6_++;
               }
               _loc5_.sort(this.compare);
               if(_loc2_[_loc3_].@value == "1")
               {
                  this.scoreRankInfo.rank30_40 = _loc5_;
               }
               else
               {
                  this.scoreRankInfo.rank41_50 = _loc5_;
               }
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc8_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      private function compare(param1:EliteGameScroeRankInfo, param2:EliteGameScroeRankInfo) : Number
      {
         return param1.rank > param2.rank ? Number(1) : (param1.rank == param2.rank ? Number(0) : Number(-1));
      }
   }
}
