package consortion.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import consortion.ConsortionModelControl;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.data.player.PlayerState;
   import ddt.manager.PlayerManager;
   import road7th.data.DictionaryData;
   
   public class ConsortionMemberAnalyer extends DataAnalyzer
   {
       
      
      public var consortionMember:DictionaryData;
      
      public function ConsortionMemberAnalyer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc4_:ConsortiaPlayerInfo = null;
         _loc2_ = null;
         var _loc3_:int = 0;
         _loc4_ = null;
         var _loc5_:PlayerState = null;
         var _loc6_:XML = new XML(param1);
         this.consortionMember = new DictionaryData();
         if(_loc6_.@value == "true")
         {
            ConsortionModelControl.Instance.model.systemDate = XML(_loc6_).@currentDate;
            _loc2_ = _loc6_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new ConsortiaPlayerInfo();
               _loc4_.beginChanges();
               _loc4_.IsVote = this.converBoolean(_loc2_[_loc3_].@IsVote);
               _loc4_.privateID = _loc2_[_loc3_].@ID;
               _loc4_.ConsortiaID = PlayerManager.Instance.Self.ConsortiaID;
               _loc4_.ConsortiaName = PlayerManager.Instance.Self.ConsortiaName;
               _loc4_.DutyID = _loc2_[_loc3_].@DutyID;
               _loc4_.DutyName = _loc2_[_loc3_].@DutyName;
               _loc4_.GP = _loc2_[_loc3_].@GP;
               _loc4_.Grade = _loc2_[_loc3_].@Grade;
               _loc4_.FightPower = _loc2_[_loc3_].@FightPower;
               _loc4_.AchievementPoint = _loc2_[_loc3_].@AchievementPoint;
               _loc4_.honor = _loc2_[_loc3_].@Rank;
               _loc4_.IsChat = this.converBoolean(_loc2_[_loc3_].@IsChat);
               _loc4_.IsDiplomatism = this.converBoolean(_loc2_[_loc3_].@IsDiplomatism);
               _loc4_.IsDownGrade = this.converBoolean(_loc2_[_loc3_].@IsDownGrade);
               _loc4_.IsEditorDescription = this.converBoolean(_loc2_[_loc3_].@IsEditorDescription);
               _loc4_.IsEditorPlacard = this.converBoolean(_loc2_[_loc3_].@IsEditorPlacard);
               _loc4_.IsEditorUser = this.converBoolean(_loc2_[_loc3_].@IsEditorUser);
               _loc4_.IsExpel = this.converBoolean(_loc2_[_loc3_].@IsExpel);
               _loc4_.IsInvite = this.converBoolean(_loc2_[_loc3_].@IsInvite);
               _loc4_.IsManageDuty = this.converBoolean(_loc2_[_loc3_].@IsManageDuty);
               _loc4_.IsRatify = this.converBoolean(_loc2_[_loc3_].@IsRatify);
               _loc4_.IsUpGrade = this.converBoolean(_loc2_[_loc3_].@IsUpGrade);
               _loc4_.IsBandChat = this.converBoolean(_loc2_[_loc3_].@IsBanChat);
               _loc4_.Offer = int(_loc2_[_loc3_].@Offer);
               _loc4_.RatifierID = _loc2_[_loc3_].@RatifierID;
               _loc4_.RatifierName = _loc2_[_loc3_].@RatifierName;
               _loc4_.Remark = _loc2_[_loc3_].@Remark;
               _loc4_.Repute = _loc2_[_loc3_].@Repute;
               _loc5_ = new PlayerState(int(_loc2_[_loc3_].@State));
               _loc4_.playerState = _loc5_;
               _loc4_.LastDate = _loc2_[_loc3_].@LastDate;
               _loc4_.ID = _loc2_[_loc3_].@UserID;
               _loc4_.NickName = _loc2_[_loc3_].@UserName;
               _loc4_.typeVIP = _loc2_[_loc3_].@typeVIP;
               _loc4_.VIPLevel = _loc2_[_loc3_].@VIPLevel;
               _loc4_.LoginName = _loc2_[_loc3_].@LoginName;
               _loc4_.Sex = this.converBoolean(_loc2_[_loc3_].@Sex);
               _loc4_.EscapeCount = _loc2_[_loc3_].@EscapeCount;
               _loc4_.Right = _loc2_[_loc3_].@Right;
               _loc4_.WinCount = _loc2_[_loc3_].@WinCount;
               _loc4_.TotalCount = _loc2_[_loc3_].@TotalCount;
               _loc4_.RichesOffer = _loc2_[_loc3_].@RichesOffer;
               _loc4_.RichesRob = _loc2_[_loc3_].@RichesRob;
               _loc4_.UseOffer = _loc2_[_loc3_].@TotalRichesOffer;
               _loc4_.DutyLevel = _loc2_[_loc3_].@DutyLevel;
               _loc4_.LastWeekRichesOffer = parseInt(_loc2_[_loc3_].@LastWeekRichesOffer);
               _loc4_.commitChanges();
               this.consortionMember.add(_loc4_.ID,_loc4_);
               if(_loc4_.ID == PlayerManager.Instance.Self.ID)
               {
                  PlayerManager.Instance.Self.ConsortiaID = _loc4_.ConsortiaID;
                  PlayerManager.Instance.Self.DutyLevel = _loc4_.DutyLevel;
                  PlayerManager.Instance.Self.DutyName = _loc4_.DutyName;
                  PlayerManager.Instance.Self.Right = _loc4_.Right;
               }
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
      
      private function converBoolean(param1:String) : Boolean
      {
         return param1 == "true" ? Boolean(true) : Boolean(false);
      }
   }
}
