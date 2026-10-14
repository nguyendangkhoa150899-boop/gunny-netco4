package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.player.AcademyPlayerInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.PlayerState;
   
   public class AcademyMemberListAnalyze extends DataAnalyzer
   {
       
      
      public var academyMemberList:Vector.<AcademyPlayerInfo>;
      
      public var totalPage:int;
      
      public var selfIsRegister:Boolean;
      
      public var selfDescribe:String;
      
      public var isAlter:Boolean;
      
      public var isSelfPublishEquip:Boolean;
      
      public function AcademyMemberListAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc4_:PlayerInfo = null;
         _loc2_ = null;
         var _loc3_:int = 0;
         _loc4_ = null;
         var _loc5_:PlayerState = null;
         var _loc6_:AcademyPlayerInfo = null;
         var _loc7_:XML = new XML(param1);
         this.academyMemberList = new Vector.<AcademyPlayerInfo>();
         if(_loc7_.@value == "true")
         {
            _loc2_ = _loc7_..Info;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new PlayerInfo();
               _loc4_.beginChanges();
               _loc4_.ID = _loc2_[_loc3_].@UserID;
               _loc4_.NickName = _loc2_[_loc3_].@NickName;
               _loc4_.ConsortiaID = _loc2_[_loc3_].@ConsortiaID;
               _loc4_.ConsortiaName = _loc2_[_loc3_].@ConsortiaName;
               _loc4_.Sex = this.converBoolean(_loc2_[_loc3_].@Sex);
               _loc4_.WinCount = _loc2_[_loc3_].@Win;
               _loc4_.TotalCount = _loc2_[_loc3_].@Total;
               _loc4_.EscapeCount = _loc2_[_loc3_].@Escape;
               _loc4_.GP = _loc2_[_loc3_].@GP;
               _loc4_.Style = _loc2_[_loc3_].@Style;
               _loc4_.Colors = _loc2_[_loc3_].@Colors;
               _loc4_.Hide = _loc2_[_loc3_].@Hide;
               _loc4_.Grade = _loc2_[_loc3_].@Grade;
               _loc4_.playerState = new PlayerState(int(_loc2_[_loc3_].@State));
               _loc4_.Repute = _loc2_[_loc3_].@Repute;
               _loc4_.Skin = _loc2_[_loc3_].@Skin;
               _loc4_.Offer = _loc2_[_loc3_].@Offer;
               _loc4_.IsMarried = this.converBoolean(_loc2_[_loc3_].@IsMarried);
               _loc4_.Nimbus = int(_loc2_[_loc3_].@Nimbus);
               _loc4_.DutyName = _loc2_[_loc3_].@DutyName;
               _loc4_.FightPower = _loc2_[_loc3_].@FightPower;
               _loc4_.AchievementPoint = _loc2_[_loc3_].@AchievementPoint;
               _loc4_.honor = _loc2_[_loc3_].@Rank;
               _loc4_.typeVIP = _loc2_[_loc3_].@typeVIP;
               _loc4_.VIPLevel = _loc2_[_loc3_].@VIPLevel;
               _loc4_.SpouseID = _loc2_[_loc3_].@SpouseID;
               _loc4_.SpouseName = _loc2_[_loc3_].@SpouseName;
               _loc4_.WeaponID = _loc2_[_loc3_].@WeaponID;
               _loc4_.graduatesCount = _loc2_[_loc3_].@GraduatesCount;
               _loc4_.honourOfMaster = _loc2_[_loc3_].@HonourOfMaster;
               _loc4_.badgeID = _loc2_[_loc3_].@BadgeID;
               _loc5_ = new PlayerState(_loc2_[_loc3_].@State);
               _loc4_.playerState = _loc5_;
               _loc6_ = new AcademyPlayerInfo();
               _loc6_.IsPublishEquip = this.converBoolean(_loc2_[_loc3_].@IsPublishEquip);
               _loc6_.Introduction = _loc2_[_loc3_].@Introduction;
               _loc6_.info = _loc4_;
               this.academyMemberList.push(_loc6_);
               _loc4_.commitChanges();
               _loc3_++;
            }
            this.totalPage = Math.ceil(int(_loc7_.@total) / 9);
            this.selfIsRegister = this.converBoolean(_loc7_.@isPlayerRegeisted);
            if(_loc7_.@isPlayerRegeisted == "")
            {
               this.isAlter = false;
            }
            else
            {
               this.isAlter = true;
            }
            this.selfDescribe = _loc7_.@selfMessage;
            this.isSelfPublishEquip = this.converBoolean(_loc7_.@isSelfPublishEquip);
            onAnalyzeComplete();
         }
         else
         {
            message = _loc7_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      private function converBoolean(param1:String) : Boolean
      {
         if(param1 == "true")
         {
            return true;
         }
         return false;
      }
   }
}
