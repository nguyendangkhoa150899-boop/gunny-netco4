package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.map.OpenMapInfo;
   
   public class WeekOpenMapAnalyze extends DataAnalyzer
   {
      
      public static const PATH:String = "MapServerList.xml";
       
      
      public var list:Vector.<OpenMapInfo>;
      
      public function WeekOpenMapAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:OpenMapInfo = null;
         var _loc5_:XML = new XML(param1);
         var _loc6_:String = _loc5_.@value;
         if(_loc6_ == "true")
         {
            this.list = new Vector.<OpenMapInfo>();
            _loc2_ = _loc5_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new OpenMapInfo();
               _loc4_.maps = _loc2_[_loc3_].@OpenMap.split(",");
               _loc4_.serverID = _loc2_[_loc3_].@ServerID;
               this.list.push(_loc4_);
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc5_.@message;
            onAnalyzeError();
         }
      }
   }
}
