package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.CMFriendInfo;
   import ddt.manager.PlayerManager;
   import road7th.data.DictionaryData;
   
   public class LoadCMFriendList extends DataAnalyzer
   {
       
      
      public function LoadCMFriendList(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:CMFriendInfo = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:DictionaryData = new DictionaryData();
         var _loc7_:XML = new XML(param1);
         var _loc8_:XMLList = _loc7_..Item;
         if(_loc7_.@value == "true")
         {
            _loc2_ = 0;
            while(_loc2_ < _loc8_.length())
            {
               _loc3_ = new CMFriendInfo();
               _loc3_.NickName = _loc8_[_loc2_].@NickName;
               _loc3_.UserName = _loc8_[_loc2_].@UserName;
               _loc3_.UserId = _loc8_[_loc2_].@UserId;
               _loc3_.Photo = _loc8_[_loc2_].@Photo;
               _loc3_.PersonWeb = _loc8_[_loc2_].@PersonWeb;
               _loc3_.OtherName = _loc8_[_loc2_].@OtherName;
               _loc3_.level = _loc8_[_loc2_].@Level;
               _loc4_ = int(_loc8_[_loc2_].@Sex);
               if(_loc4_ == 0)
               {
                  _loc3_.sex = false;
               }
               else
               {
                  _loc3_.sex = true;
               }
               _loc5_ = _loc8_[_loc2_].@IsExist;
               if(_loc5_ == "true")
               {
                  _loc3_.IsExist = true;
               }
               else
               {
                  _loc3_.IsExist = false;
               }
               if(!(_loc3_.IsExist && PlayerManager.Instance.friendList[_loc3_.UserId]))
               {
                  _loc6_.add(_loc3_.UserName,_loc3_);
               }
               _loc2_++;
            }
            PlayerManager.Instance.CMFriendList = _loc6_;
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
