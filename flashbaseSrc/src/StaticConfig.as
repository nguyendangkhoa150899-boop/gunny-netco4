package
{
   public class StaticConfig
   {
      
      public static const BG:Array = ["images/bg/1.jpg","images/bg/2.jpg","images/bg/3.jpg","images/bg/4.jpg"];
      
      public static var ConfigPath:String = "config.xml";
      
      public static var MD5Path:String = "md5.xml";
      
      public static var RegisterPath:String = "DDT_Register.png";
      
      public static var TrainPath:String = "DDT_Trainer.png";
      
      public static var CorePath:String = "DDT.png";
      
      public static var CorePathTwo:String = "DDT_Core.png";
      
      public static var CorePathThree:String = "DDT_Five.png";
      
      public static var SavePlayerAction:String = "SavePlayerAction.ashx";
      
      public static var LoginSelectList:String = "LoginSelectList.ashx";
      
      public static var LogTime:String = "LogTime.ashx";
      
      public static const EnterRegisterStateFunctionName:String = "register.RegisterState";
      
      public static const TrainDefinition:String = "road7th.Trainer";
      
      public static const RegisterUIModule:String = "choicefigure";
      
      public static const ROAD_COMPONENT:String = "roadComponent";
      
      public static const DDT_CLASS_PATH:String = "ddt.DDT";
      
      public static const StartupLoaderClass:String = "ddt.loader.StartupResourceLoader";
      
      public static const SmallLoadingDefinition:String = "SmallLoading";
      
      public static var isDebug:Boolean;
      
      public static var isRegisterPlayer:Boolean;
      
      public static var registerSelectLevel:Boolean;
      
      public static var user:String;
      
      public static var key:String;
      
      public static var rid:String = "";
      
      public static var baiduEnterCode:String;
      
      public static var site:String = "";
      
      public static var config:XML;
      
      public static var requestPath:String = "";
      
      public static var flashSite:String = "";
      
      public static var resFlashSite:String = "";
      
      public static var resourceSite:String = "";
      
      public static var language:String = "";
      
      public static var versionUpFileName:String = "resourceUpFile";
      
      public static var versionUpFileEnabel:Boolean;
      
      public static var loginPath:String = "";
      
      private static var _instance:StaticConfig;
      
      public static var IsLauncher:Boolean;
      
      public static var AreaId:String = "";
      
      public static var SectionId:String = "";
       
      
      public function StaticConfig()
      {
         super();
      }
      
      public static function setConfig(param1:XML) : void
      {
         flashSite = param1.FLASHSITE.@value;
         resourceSite = param1.SITE.@value;
         resFlashSite = param1.RESOURCE_SITE.@value;
         requestPath = param1.REQUEST_PATH.@value;
         language = param1.LANGUAGE.@value;
         loginPath = param1.LOGIN_PATH.@value;
         if(param1.RESOURCE_UPFILE_NAME != null)
         {
            versionUpFileEnabel = true;
            versionUpFileName = param1.RESOURCE_UPFILE_NAME.@value;
         }
         AreaId = param1.AREA_ID.@value;
         SectionId = param1.SECTION_ID.@value;
         config = param1;
      }
      
      public static function areaAvailable(param1:int) : Boolean
      {
         if(param1 == 1)
         {
            return true;
         }
         var _loc2_:Array = SectionId.split(",");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_] == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public static function getPathByRequestPath(param1:String) : String
      {
         return requestPath + param1;
      }
      
      public static function getPathByFlashSite(param1:String) : String
      {
         return flashSite + param1;
      }
      
      public static function getPathByResFlashSite(param1:String) : String
      {
         return resFlashSite + param1;
      }
      
      public static function getSwfPath(param1:*) : String
      {
         return resFlashSite + "ui/" + language + "/swf/" + param1;
      }
      
      public static function get versionUpFilePath() : String
      {
         return flashSite + versionUpFileName + ".xml";
      }
      
      public static function get instance() : StaticConfig
      {
         if(!_instance)
         {
            _instance = new StaticConfig();
         }
         return _instance;
      }
   }
}
