package carnivalActivity
{
   import ddt.manager.TimeManager;
   
   public class CarnivalActivityManager
   {
      
      private static var _instance:carnivalActivity.CarnivalActivityManager;
       
      
      public var currentType:int;
      
      public var currentChildType:int;
      
      public var actBeginTime:Number;
      
      public var actEndTime:Number;
      
      public var getBeginTime:Number;
      
      public var getEndTime:Number;
      
      public var lastClickTime:int;
      
      public function CarnivalActivityManager()
      {
         super();
      }
      
      public static function get instance() : carnivalActivity.CarnivalActivityManager
      {
         if(!_instance)
         {
            _instance = new carnivalActivity.CarnivalActivityManager();
         }
         return _instance;
      }
      
      public function canGetAward() : Boolean
      {
         var _loc1_:Number = TimeManager.Instance.Now().time;
         if(_loc1_ >= this.getBeginTime && _loc1_ <= this.getEndTime)
         {
            return true;
         }
         return false;
      }
      
      public function rookieRankCanGetAward() : Boolean
      {
         var _loc1_:Number = TimeManager.Instance.Now().time;
         if(_loc1_ >= this.actEndTime && _loc1_ <= this.getEndTime)
         {
            return true;
         }
         return false;
      }
   }
}
