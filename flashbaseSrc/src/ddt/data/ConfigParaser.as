package ddt.data
{
   import com.pickgliss.utils.StringUtils;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.StatisticManager;
   import flash.display.LoaderInfo;
   import flash.system.Security;
   import game.GameManager;
   
   public class ConfigParaser
   {
       
      
      public function ConfigParaser()
      {
         super();
      }
      
      public static function paras(param1:XML, param2:LoaderInfo, param3:String) : void
      {
         var _loc4_:XML = null;
         var _loc5_:PathInfo = new PathInfo();
         _loc5_.SITEII = String(param2.parameters["site"]);
         if(_loc5_.SITEII == "undefined")
         {
            _loc5_.SITEII = "";
         }
         _loc5_.SITE = param1.SITE.@value;
         _loc5_.WEEKLY_SITE = param1.WEEKLYSITE.@value;
         _loc5_.BACKUP_FLASHSITE = param1.BACKUP_FLASHSITE.@value;
         _loc5_.FLASHSITE = param1.FLASHSITE.@value;
         _loc5_.COMMUNITY_FRIEND_PATH = param1.COMMUNITY_FRIEND_PATH.@value;
         _loc5_.CROSSBUGGlLEBTN_ENABLE = StringUtils.converBoolean(param1.CROSSBUGGlLEBTN.@enable);
         if(param1.COMMUNITY_MICROBLOG.hasOwnProperty("@value"))
         {
            _loc5_.COMMUNITY_MICROBLOG = StringUtils.converBoolean(param1.COMMUNITY_MICROBLOG.@value);
         }
         if(param1.COMMUNITY_SINA_SECOND_MICROBLOG.hasOwnProperty("@value"))
         {
            _loc5_.COMMUNITY_SINA_SECOND_MICROBLOG = StringUtils.converBoolean(param1.COMMUNITY_SINA_SECOND_MICROBLOG.@value);
         }
         if(param1.COMMUNITY_FRIEND_PATH.hasOwnProperty("@isUser"))
         {
            PathInfo.isUserAddFriend = StringUtils.converBoolean(param1.COMMUNITY_FRIEND_PATH.@isUser);
         }
         if(param1.LOTTERY.hasOwnProperty("@enable"))
         {
            _loc5_.LOTTERY_ENABLE = param1.LOTTERY.@enable != "false";
         }
         if(Boolean(param1.SHORTCUT))
         {
            if(param1.SHORTCUT.hasOwnProperty("@enable"))
            {
               _loc5_.SHORTCUT_ENABLE = String(param1.SHORTCUT.@enable) == "true" ? Boolean(true) : Boolean(false);
            }
         }
         _loc5_.LUCKY_NUMBER_ENABLE = StringUtils.converBoolean(param1.LUCKY_NUMBER.@enable);
         _loc5_.STYLE_PATH = param1.STYLE_PATH.@value;
         _loc5_.FIRSTPAGE = param1.FIRSTPAGE.@value;
         _loc5_.REGISTER = param1.REGISTER.@value;
         _loc5_.REQUEST_PATH = param1.REQUEST_PATH.@value;
         _loc5_.FILL_PATH = String(param1.FILL_PATH.@value).replace("{user}",param3);
         _loc5_.FILL_PATH = _loc5_.FILL_PATH.replace("{site}",_loc5_.SITEII);
         _loc5_.LOGIN_PATH = String(param1.LOGIN_PATH.@value).replace("{user}",param3);
         _loc5_.LOGIN_PATH = _loc5_.LOGIN_PATH.replace("{site}",_loc5_.SITEII);
         _loc5_.OFFICIAL_SITE = param1.OFFICIAL_SITE.@value;
         _loc5_.GAME_FORUM = param1.GAME_FORUM.@value;
         _loc5_.DISABLE_TASK_ID = param1.DISABLE_TASK_ID.@value;
         _loc5_.LITTLEGAMEMINLV = param1.LITTLEGAMEMINLV.@value;
         if(param1.LOGIN_PATH.hasOwnProperty("@siteName"))
         {
            StatisticManager.siteName = param1.LOGIN_PATH.@siteName;
         }
         _loc5_.TRAINER_STANDALONE = String(param1.TRAINER_STANDALONE.@value) == "false" ? Boolean(false) : Boolean(true);
         _loc5_.TRAINER_PATH = param1.TRAINER_PATH.@value;
         _loc5_.COUNT_PATH = param1.COUNT_PATH.@value;
         _loc5_.PARTER_ID = param1.PARTER_ID.@value;
         _loc5_.CLIENT_DOWNLOAD = param1.CLIENT_DOWNLOAD.@value;
         if(param1.STATISTIC.hasOwnProperty("@value"))
         {
         }
         var _loc6_:int = int(param1.SUCIDE_TIME.@value);
         if(_loc6_ > 0)
         {
            PathInfo.SUCIDE_TIME = _loc6_ * 1000;
         }
         var _loc7_:int = int(param1.BOX_STYLE.@value);
         if(_loc7_ != 0)
         {
         }
         _loc5_.PHP_PATH = param1.PHP.@site;
         if(param1.PHP.hasOwnProperty("@link"))
         {
            _loc5_.PHP_IMAGE_LINK = StringUtils.converBoolean(param1.PHP.@link);
         }
         _loc5_.WEB_PLAYER_INFO_PATH = param1.PHP.@infoPath;
         if(param1.PHP.hasOwnProperty("@isShow"))
         {
            PlayerManager.isShowPHP = StringUtils.converBoolean(param1.PHP.@isShow);
         }
         if(param1.PHP.hasOwnProperty("@link"))
         {
            _loc5_.PHP_IMAGE_LINK = StringUtils.converBoolean(param1.PHP.@link);
         }
         PathInfo.MUSIC_LIST = String(param1.MUSIC_LIST.@value).split(",");
         PathInfo.LANGUAGE = String(param1.LANGUAGE.@value);
         var _loc8_:XMLList = param1.POLICY_FILES.file;
         for each(_loc4_ in _loc8_)
         {
            Security.loadPolicyFile(_loc4_.@value);
         }
         if(param1.GAME_BOXPIC.hasOwnProperty("@value"))
         {
            PathInfo.GAME_BOXPIC = param1.GAME_BOXPIC.@value;
         }
         if(param1.ISTOPDERIICT.hasOwnProperty("@value"))
         {
            PathInfo.ISTOPDERIICT = StringUtils.converBoolean(param1.ISTOPDERIICT.@value);
         }
         _loc5_.COMMUNITY_INVITE_PATH = param1.COMMUNITY_INVITE_PATH.@value;
         _loc5_.COMMUNITY_FRIEND_LIST_PATH = param1.COMMUNITY_FRIEND_LIST_PATH.@value;
         _loc5_.SNS_PATH = param1.COMMUNITY_FRIEND_LIST_PATH.@snsPath;
         _loc5_.MICROCOBOL_PATH = param1.COMMUNITY_FRIEND_LIST_PATH.@microcobolPath;
         if(param1.COMMUNITY_FRIEND_LIST_PATH.hasOwnProperty("@isexist"))
         {
            _loc5_.COMMUNITY_EXIST = StringUtils.converBoolean(param1.COMMUNITY_FRIEND_LIST_PATH.@isexist);
         }
         if(param1.COMMUNITY_FRIEND_INVITED_SWITCH.hasOwnProperty("@value"))
         {
            _loc5_.COMMUNITY_FRIEND_INVITED_SWITCH = StringUtils.converBoolean(param1.COMMUNITY_FRIEND_INVITED_SWITCH.@value);
         }
         if(param1.COMMUNITY_FRIEND_INVITED_SWITCH.hasOwnProperty("@invitedOnline"))
         {
            _loc5_.COMMUNITY_FRIEND_INVITED_ONLINE_SWITCH = StringUtils.converBoolean(param1.COMMUNITY_FRIEND_INVITED_SWITCH.@invitedOnline);
         }
         if(param1.COMMUNITY_FRIEND_LIST_PATH.hasOwnProperty("@isexistBtnVisble"))
         {
            _loc5_.IS_VISIBLE_EXISTBTN = StringUtils.converBoolean(param1.COMMUNITY_FRIEND_LIST_PATH.@isexistBtnVisble);
         }
         _loc5_.ALLOW_POPUP_FAVORITE = String(param1.ALLOW_POPUP_FAVORITE.@value) == "true" ? Boolean(true) : Boolean(false);
         if(param1.FILL_JS_COMMAND.hasOwnProperty("@enable"))
         {
            _loc5_.FILL_JS_COMMAND_ENABLE = StringUtils.converBoolean(param1.FILL_JS_COMMAND.@enable);
         }
         if(param1.FILL_JS_COMMAND.hasOwnProperty("@value"))
         {
            _loc5_.FILL_JS_COMMAND_VALUE = param1.FILL_JS_COMMAND.@value;
         }
         if(param1.MINLEVELDUPLICATE.hasOwnProperty("@value"))
         {
            GameManager.MinLevelDuplicate = param1.MINLEVELDUPLICATE.@value;
         }
         _loc5_.FIGHTLIB_ENABLE = StringUtils.converBoolean(param1.FIGHTLIB.@value);
         if(Boolean(param1.FEEDBACK))
         {
            if(param1.FEEDBACK.hasOwnProperty("@enable"))
            {
               _loc5_.FEEDBACK_ENABLE = String(param1.FEEDBACK.@enable) == "true" ? Boolean(true) : Boolean(false);
               _loc5_.FEEDBACK_TEL_NUMBER = param1.FEEDBACK.@telNumber;
            }
         }
         if(param1.MODULE != null && param1.MODULE.SPA != null && Boolean(param1.MODULE.SPA.hasOwnProperty("@enable")))
         {
            _loc5_.SPA_ENABLE = param1.MODULE.SPA.@enable != "false";
         }
         if(param1.MODULE != null && param1.MODULE.CIVIL != null && Boolean(param1.MODULE.CIVIL.hasOwnProperty("@enable")))
         {
            _loc5_.CIVIL_ENABLE = param1.MODULE.CIVIL.@enable != "false";
         }
         if(param1.MODULE != null && param1.MODULE.CHURCH != null && Boolean(param1.MODULE.CHURCH.hasOwnProperty("@enable")))
         {
            _loc5_.CHURCH_ENABLE = param1.MODULE.CHURCH.@enable != "false";
         }
         if(param1.MODULE != null && param1.MODULE.WEEKLY != null && Boolean(param1.MODULE.WEEKLY.hasOwnProperty("@enable")))
         {
            _loc5_.WEEKLY_ENABLE = param1.MODULE.WEEKLY.@enable != "false";
         }
         if(param1.FORTH_ENABLE.hasOwnProperty("@value"))
         {
            _loc5_.FORTH_ENABLE = param1.FORTH_ENABLE.@value != "false";
         }
         if(param1.STHRENTH_MAX.hasOwnProperty("@value"))
         {
            _loc5_.STHRENTH_MAX = int(param1.STHRENTH_MAX.@value);
         }
         if(param1.USER_GUILD_ENABLE.hasOwnProperty("@value"))
         {
            _loc5_.USER_GUILD_ENABLE = StringUtils.converBoolean(param1.USER_GUILD_ENABLE.@value);
         }
         if(param1.ACHIEVE_ENABLE.hasOwnProperty("@value"))
         {
            _loc5_.ACHIEVE_ENABLE = param1.ACHIEVE_ENABLE.@value != "false";
         }
         if(param1.CHAT_FACE != null && param1.CHAT_FACE.DISABLED_LIST != null && Boolean(param1.CHAT_FACE.DISABLED_LIST.hasOwnProperty("@list")))
         {
            _loc5_.CHAT_FACE_DISABLED_LIST = String(param1.CHAT_FACE.DISABLED_LIST.@list).split(",");
         }
         if(param1.STATISTICS.hasOwnProperty("@enable"))
         {
            _loc5_.STATISTICS = param1.STATISTICS.@enable != "false";
         }
         if(param1.USER_GUIDE.hasOwnProperty("@value") || true)
         {
         }
         if(param1.GAME_FRAME_CONFIG != null && param1.GAME_FRAME_CONFIG.FRAME_TIME_OVER_TAG != null && Boolean(param1.GAME_FRAME_CONFIG.FRAME_TIME_OVER_TAG.hasOwnProperty("@value")))
         {
            _loc5_.FRAME_TIME_OVER_TAG = int(param1.GAME_FRAME_CONFIG.FRAME_TIME_OVER_TAG.@value);
         }
         if(param1.GAME_FRAME_CONFIG != null && param1.GAME_FRAME_CONFIG.FRAME_OVER_COUNT_TAG != null && Boolean(param1.GAME_FRAME_CONFIG.FRAME_OVER_COUNT_TAG.hasOwnProperty("@value")))
         {
            _loc5_.FRAME_OVER_COUNT_TAG = int(param1.GAME_FRAME_CONFIG.FRAME_OVER_COUNT_TAG.@value);
         }
         if(param1.EXTERNAL_INTERFACE_360 != null && param1.EXTERNAL_INTERFACE_360.hasOwnProperty("@value"))
         {
            _loc5_.EXTERNAL_INTERFACE_PATH_360 = String(param1.EXTERNAL_INTERFACE_360.@value);
         }
         if(param1.EXTERNAL_INTERFACE_360 != null && param1.EXTERNAL_INTERFACE_360.hasOwnProperty("@enable"))
         {
            _loc5_.EXTERNAL_INTERFACE_ENABLE_360 = param1.EXTERNAL_INTERFACE_360.@enable != "false";
         }
         if(param1.FACEBOOK.hasOwnProperty("@enable"))
         {
            _loc5_.FACEBOOK_ENABLE = param1.FACEBOOK.@enable == "true";
            _loc5_.FACEBOOK_FEEDPAGE_LINK = param1.FACEBOOK.@feedPageLink;
         }
         if(param1.PETS_EAT != null && param1.PETS_EAT.hasOwnProperty("@enable"))
         {
            _loc5_.PETS_EAT = param1.PETS_EAT.@enable == "true";
         }
         if(Boolean(param1.DUNGEON_OPEN) && param1.DUNGEON_OPEN.hasOwnProperty("@value"))
         {
            _loc5_.DUNGEON_OPEN = String(param1.DUNGEON_OPEN.@value).split(",");
         }
         if(param1.SUIT.hasOwnProperty("@enable"))
         {
            _loc5_.SUIT_ENABLE = param1.SUIT.@enable != "false";
         }
         if(param1.GODSYAH.hasOwnProperty("@enable"))
         {
            _loc5_.GODSYAH_ENABLE = param1.GODSYAH.@enable == "true";
         }
         if(param1.GEMSTONE.hasOwnProperty("@enable"))
         {
            _loc5_.GEMSTONE_ENABLE = param1.GEMSTONE.@enable != "false";
         }
         if(param1.TOTEM.hasOwnProperty("@enable"))
         {
            _loc5_.TOTEM_ENABLE = param1.TOTEM.@enable == "true";
         }
         if(param1.ITEMADVANCE.hasOwnProperty("@enable"))
         {
            _loc5_.ITEMADVANCE_ENABLE = param1.ITEMADVANCE.@enable == "true";
         }
         if(param1.LATEN.hasOwnProperty("@enable"))
         {
            _loc5_.LATEN_ENABLE = param1.LATEN.@enable == "true";
         }
         if(param1.GEMSTORE.hasOwnProperty("@enable"))
         {
            _loc5_.GEMSTONE_ENABLE_STORE = param1.GEMSTORE.@enable == "true";
         }
         if(param1.NECKLACE.hasOwnProperty("@enable"))
         {
            _loc5_.NECKLACE_ENABLE = param1.NECKLACE.@enable == "true";
         }
         if(param1.LOVERING.hasOwnProperty("@enable"))
         {
            _loc5_.LOVERING_ENABLE = param1.LOVERING.@enable == "true";
         }
         if(param1.OPEN_WONDERFUL_ACTIVITY != null && param1.OPEN_WONDERFUL_ACTIVITY.hasOwnProperty("@enable"))
         {
            _loc5_.OPEN_WONDERFUL_ACTIVITY = param1.OPEN_WONDERFUL_ACTIVITY.@enable == "true";
         }
         if(param1.HOTSPRING_CONTINUE.hasOwnProperty("@enable"))
         {
            _loc5_.HOTSPRING_CONTINUE = param1.HOTSPRING_CONTINUE.@enable == "false";
         }
         PathManager.setup(_loc5_);
      }
   }
}
