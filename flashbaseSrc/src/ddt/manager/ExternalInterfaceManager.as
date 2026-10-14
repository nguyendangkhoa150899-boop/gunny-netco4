package ddt.manager
{
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.net.sendToURL;
   
   public class ExternalInterfaceManager
   {
      
      private static var loader:URLLoader;
       
      
      public function ExternalInterfaceManager()
      {
         super();
      }
      
      public static function sendToAgent(param1:int, param2:int = -1, param3:String = "", param4:String = "", param5:int = -1, param6:String = "", param7:String = "") : void
      {
         var _loc8_:URLRequest = new URLRequest(PathManager.solveExternalInterfacePath());
         var _loc9_:URLVariables = new URLVariables();
         _loc9_["op"] = param1;
         if(param2 > -1)
         {
            _loc9_["uid"] = param2;
         }
         if(param3 != "")
         {
            _loc9_["role"] = param3;
         }
         if(param4 != "")
         {
            _loc9_["ser"] = param4;
         }
         if(param5 > -1)
         {
            _loc9_["num"] = param5;
         }
         if(param6 != "")
         {
            _loc9_["pn"] = param6;
         }
         if(param7 != "")
         {
            _loc9_["role2"] = param7;
         }
         _loc8_.data = _loc9_;
         sendToURL(_loc8_);
      }
      
      public static function sendTo360Agent(param1:int) : void
      {
         var _loc2_:URLRequest = null;
         var _loc3_:URLVariables = null;
         var _loc4_:String = PathManager.solveFillPage();
         var _loc5_:Number = _loc4_.indexOf("server_id=") + 10;
         var _loc6_:Number = _loc4_.indexOf("&uid");
         var _loc7_:String = _loc4_.slice(_loc5_,_loc6_);
         if(PathManager.ExternalInterface360Enabel())
         {
            _loc2_ = new URLRequest(PathManager.ExternalInterface360Path());
            _loc3_ = new URLVariables();
            _loc3_["game"] = "ddt";
            _loc3_["server"] = _loc7_;
            _loc3_["qid"] = PlayerManager.Instance.Account.Account;
            _loc3_["event"] = getEvent(param1);
            _loc3_["time"] = new Date().getTime();
            _loc2_.data = _loc3_;
            sendToURL(_loc2_);
         }
      }
      
      private static function getEvent(param1:int) : String
      {
         switch(param1)
         {
            case 0:
               return "pageload";
            case 1:
               return "beforeloadflash";
            case 2:
               return "flashloaded";
            case 3:
               return "playercreated";
            case 4:
               return "entergame";
            default:
               return "";
         }
      }
   }
}
