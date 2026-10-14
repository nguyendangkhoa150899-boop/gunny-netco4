package noviceactivity
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class NoviceActivityAnalyzer extends DataAnalyzer
   {
       
      
      private var _activityInfos:Array;
      
      private var _firstrechargeawards:Array;
      
      public function NoviceActivityAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:XMLList = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:NoviceActivityInfo = null;
         var _loc8_:XMLList = null;
         var _loc9_:int = 0;
         var _loc10_:NoviceActivityRightAwardInfo = null;
         var _loc11_:XMLList = null;
         var _loc12_:int = 0;
         var _loc13_:Object = null;
         var _loc14_:XML = new XML(param1);
         if(_loc14_.@value == "true")
         {
            _loc2_ = _loc14_..ActivityType;
            this._activityInfos = [];
            this._firstrechargeawards = [];
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               if(_loc2_[_loc3_].@value == 6)
               {
                  _loc4_ = new XMLList();
                  _loc4_ = _loc2_[_loc3_].children()[0].children();
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_.length())
                  {
                     _loc6_ = new Object();
                     _loc6_.TemplateID = _loc4_[_loc5_].@TemplateId;
                     _loc6_.Count = _loc4_[_loc5_].@Count;
                     _loc6_.StrengthLevel = _loc4_[_loc5_].@StrengthLevel;
                     _loc6_.AttackCompose = _loc4_[_loc5_].@AttackCompose;
                     _loc6_.DefendCompose = _loc4_[_loc5_].@DefendCompose;
                     _loc6_.LuckCompose = _loc4_[_loc5_].@LuckCompose;
                     _loc6_.AgilityCompose = _loc4_[_loc5_].@AgilityCompose;
                     _loc6_.IsBind = _loc4_[_loc5_].@IsBind;
                     _loc6_.ValidDate = _loc4_[_loc5_].@ValidDate;
                     this._firstrechargeawards.push(_loc6_);
                     _loc5_++;
                  }
               }
               else
               {
                  _loc7_ = new NoviceActivityInfo();
                  _loc7_.activityType = _loc2_[_loc3_].@value;
                  _loc7_.awardList = [];
                  _loc8_ = _loc2_[_loc3_].children();
                  _loc9_ = 0;
                  while(_loc9_ < _loc8_.length())
                  {
                     _loc10_ = new NoviceActivityRightAwardInfo();
                     _loc10_.subActivityType = _loc8_[_loc9_].@SubActivityType;
                     _loc10_.condition = _loc8_[_loc9_].@Condition;
                     _loc10_.awardList = [];
                     _loc11_ = _loc8_[_loc9_].children();
                     _loc12_ = 0;
                     while(_loc12_ < _loc11_.length())
                     {
                        _loc13_ = new Object();
                        _loc13_.TemplateID = _loc11_[_loc12_].@TemplateId;
                        _loc13_.Count = _loc11_[_loc12_].@Count;
                        _loc13_.StrengthLevel = _loc11_[_loc12_].@StrengthLevel;
                        _loc13_.AttackCompose = _loc11_[_loc12_].@AttackCompose;
                        _loc13_.DefendCompose = _loc11_[_loc12_].@DefendCompose;
                        _loc13_.LuckCompose = _loc11_[_loc12_].@LuckCompose;
                        _loc13_.AgilityCompose = _loc11_[_loc12_].@AgilityCompose;
                        _loc13_.IsBind = _loc11_[_loc12_].@IsBind;
                        _loc13_.ValidDate = _loc11_[_loc12_].@ValidDate;
                        _loc10_.awardList.push(_loc13_);
                        _loc12_++;
                     }
                     _loc7_.awardList.push(_loc10_);
                     _loc9_++;
                  }
                  this._activityInfos.push(_loc7_);
               }
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc14_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      public function get activityInfos() : Array
      {
         return this._activityInfos;
      }
      
      public function get firstrechargeawards() : Array
      {
         return this._firstrechargeawards;
      }
   }
}
