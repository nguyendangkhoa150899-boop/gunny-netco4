package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerState;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import im.IMController;
   import im.info.CustomInfo;
   import road7th.data.DictionaryData;
   
   public class FriendListAnalyzer extends DataAnalyzer
   {
       
      
      public var customList:Vector.<CustomInfo>;
      
      public var friendlist:DictionaryData;
      
      public var blackList:DictionaryData;
      
      public function FriendListAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:XMLList = null;
         var _loc6_:int = 0;
         var _loc7_:CustomInfo = null;
         var _loc8_:CustomInfo = null;
         var _loc9_:FriendListPlayer = null;
         var _loc10_:PlayerState = null;
         var _loc11_:Array = null;
         var _loc12_:XML = new XML(param1);
         this.friendlist = new DictionaryData();
         this.blackList = new DictionaryData();
         this.customList = new Vector.<CustomInfo>();
         if(_loc12_.@value == "true")
         {
            _loc2_ = _loc12_..customList;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               if(_loc2_[_loc3_].@Name != "")
               {
                  _loc7_ = new CustomInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc7_,_loc2_[_loc3_]);
                  this.customList.push(_loc7_);
               }
               _loc3_++;
            }
            _loc4_ = 0;
            while(_loc4_ < this.customList.length)
            {
               if(this.customList[_loc4_].ID == 1)
               {
                  _loc8_ = this.customList[_loc4_];
                  this.customList.splice(_loc4_,1);
                  this.customList.push(_loc8_);
               }
               _loc4_++;
            }
            _loc5_ = _loc12_..Item;
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length())
            {
               _loc9_ = new FriendListPlayer();
               ObjectUtils.copyPorpertiesByXML(_loc9_,_loc5_[_loc6_]);
               if(_loc9_.Birthday != "Null")
               {
                  _loc11_ = _loc9_.Birthday.split(/-/g);
                  _loc9_.BirthdayDate = new Date();
                  _loc9_.BirthdayDate.fullYearUTC = Number(_loc11_[0]);
                  _loc9_.BirthdayDate.monthUTC = Number(_loc11_[1]) - 1;
                  _loc9_.BirthdayDate.dateUTC = Number(_loc11_[2]);
               }
               _loc10_ = new PlayerState(int(_loc12_.Item[_loc6_].@State));
               _loc9_.playerState = _loc10_;
               _loc9_.apprenticeshipState = _loc12_.Item[_loc6_].@ApprenticeshipState;
               if(_loc9_.Relation != 1)
               {
                  this.friendlist.add(_loc9_.ID,_loc9_);
               }
               else
               {
                  this.blackList.add(_loc9_.ID,_loc9_);
               }
               _loc6_++;
            }
            if(PlayerManager.Instance.Self.IsFirst == 1 && PathManager.CommunityExist())
            {
               IMController.Instance.createConsortiaLoader();
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc12_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
