package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.LikeFriendInfo;
   
   public class LikeFriendAnalyzer extends DataAnalyzer
   {
       
      
      public var likeFriendList:Array;
      
      public function LikeFriendAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:LikeFriendInfo = null;
         this.likeFriendList = new Array();
         var _loc4_:XML = new XML(param1);
         var _loc5_:XMLList = _loc4_..Item;
         if(_loc4_.@value == "true")
         {
            _loc2_ = 0;
            while(_loc2_ < _loc5_.length())
            {
               _loc3_ = new LikeFriendInfo();
               ObjectUtils.copyPorpertiesByXML(_loc3_,_loc5_[_loc2_]);
               this.likeFriendList.push(_loc3_);
               _loc2_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc4_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
