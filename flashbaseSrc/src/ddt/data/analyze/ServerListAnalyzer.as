package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ServerInfo;
   
   public class ServerListAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Vector.<ServerInfo>;
      
      public var agentId:int;
      
      public var zoneName:String;
      
      public function ServerListAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:ServerInfo = null;
         var _loc5_:XML = new XML(param1);
         if(_loc5_.@value == "true")
         {
            this.agentId = _loc5_.@agentId;
            this.zoneName = _loc5_.@AreaName;
            message = _loc5_.@message;
            _loc2_ = _loc5_..Item;
            this.list = new Vector.<ServerInfo>();
            if(_loc2_.length() > 0)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length())
               {
                  _loc4_ = new ServerInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
                  this.list.push(_loc4_);
                  _loc3_++;
               }
               onAnalyzeComplete();
            }
         }
         else
         {
            message = _loc5_.@message;
            onAnalyzeError();
         }
      }
   }
}
