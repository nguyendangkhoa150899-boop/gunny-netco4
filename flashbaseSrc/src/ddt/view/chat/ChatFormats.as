package ddt.view.chat
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.QualityType;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.Helpers;
   import flash.text.StyleSheet;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   import road7th.utils.StringHelper;
   
   public class ChatFormats
   {
      
      public static const CHAT_COLORS:Array = [2358015,16751360,16740090,4970320,8423901,16777215,16776960,16776960,16776960,16777215,5035345,16724787,16777011,16777215,16711846,16711680,16777215,16777215,16777215,16777215,16777215,16777215,16777215,16777215,16777215,16777215,16777215];
      
      public static const BIG_BUGGLE_COLOR:Array = [11408476,16635586,15987916,16514727,12053748];
      
      public static const BIG_BUGGLE_TYPE_STRING:Array = ["Mối tình đầu","Chúc mừng sinh nhật","Lá lành đùm lá rách","Vua thách đấu","Đời không đối thủ"];
      
      public static const CLICK_CHANNEL:int = 0;
      
      public static const CLICK_GOODS:int = 2;
      
      public static const CLICK_USERNAME:int = 1;
      
      public static const CLICK_DIFF_ZONE:int = 4;
      
      public static const CLICK_INVENTORY_GOODS:int = 3;
      
      public static const CLICK_EFFORT:int = 100;
      
      public static var CLICK_ACT_TIP:int = 1000;
      
      public static const AVATAR_COLLECTION_TIP:int = 108;
      
      public static const Channel_Set:Object = {
         0:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.big"),
         1:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.small"),
         2:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.private"),
         3:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.consortia"),
         4:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.ream"),
         5:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.current"),
         9:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.current"),
         12:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.cross"),
         13:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.current"),
         15:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.crossBugle")
      };
      
      public static var hasYaHei:Boolean;
      
      private static var _formats:Dictionary;
      
      private static var _styleSheet:StyleSheet;
      
      private static var _gameStyleSheet:StyleSheet;
      
      private static var _styleSheetData:Dictionary;
      
      private static var _chatData:ddt.view.chat.ChatData;
      
      private static const unacceptableChar:Array = ["\"","\'","<",">"];
      
      private static const IN_GAME:uint = 1;
      
      private static const NORMAL:uint = 0;
       
      
      public function ChatFormats()
      {
         super();
      }
      
      public static function formatChatStyle(param1:ddt.view.chat.ChatData) : void
      {
         if(param1.htmlMessage != "")
         {
            return;
         }
         param1.msg = StringHelper.rePlaceHtmlTextField(param1.msg);
         var _loc2_:Array = getTagsByChannel(param1.channel);
         var _loc3_:String = creatChannelTag(param1.channel,param1.bigBuggleType,param1);
         var _loc4_:String = creatSenderTag(param1);
         var _loc5_:String = creatContentTag(param1);
         param1.htmlMessage = _loc2_[0] + _loc3_ + _loc4_ + _loc5_ + _loc2_[1] + "<BR>";
      }
      
      public static function creatBracketsTag(param1:String, param2:int, param3:Array = null, param4:ddt.view.chat.ChatData = null) : String
      {
         var _loc5_:String = null;
         var _loc6_:RegExp = /\[([^\]]*)]*/g;
         var _loc7_:Array = param1.match(_loc6_);
         var _loc8_:String = "";
         if(param2 == 102 || param2 == 108 || param2 == 110 || param2 > CLICK_ACT_TIP)
         {
            param1 = param1.split("|")[0] + "@@" + "<u>" + "<a href=\"event:" + "clicktype:" + param2.toString() + "|rewardType:" + param4.actId + "\">" + param1.split("|")[1] + "</a>" + "</u>";
         }
         if(Boolean(param3))
         {
            _loc8_ = param3.join("|");
         }
         var _loc9_:int = 0;
         while(_loc9_ < _loc7_.length)
         {
            _loc5_ = String(_loc7_[_loc9_].substr(1,_loc7_[_loc9_].length - 2));
            if(param2 != CLICK_USERNAME || _loc5_ != PlayerManager.Instance.Self.NickName)
            {
               if(Boolean(param4) && param4.channel == ChatInputView.CROSS_NOTICE)
               {
                  param1 = param1.replace("[" + _loc5_ + "]","<a href=\"event:" + "clicktype:" + param2.toString() + "|tagname:" + _loc5_ + "|zoneID:" + String(param4.zoneID) + _loc8_ + "\">" + Helpers.enCodeString("[" + _loc5_ + "]") + "</a>");
               }
               else if(_loc5_ == Channel_Set[12])
               {
                  param1 = "";
               }
               else
               {
                  param1 = param1.replace("[" + _loc5_ + "]","<a href=\"event:" + "clicktype:" + param2.toString() + "|tagname:" + _loc5_ + "|" + _loc8_ + "\">" + Helpers.enCodeString("[" + _loc5_ + "]") + "</a>");
               }
            }
            else
            {
               param1 = param1.replace("[" + _loc5_ + "]",Helpers.enCodeString("[" + _loc5_ + "]"));
            }
            _loc9_++;
         }
         return param1;
      }
      
      public static function creatGoodTag(param1:String, param2:int, param3:int, param4:int, param5:Boolean, param6:ddt.view.chat.ChatData = null, param7:String = "", param8:int = -1) : String
      {
         var _loc9_:String = null;
         var _loc10_:Array = getTagsByQuality(param4);
         var _loc11_:RegExp = /\[([^\]]*)]*/g;
         var _loc12_:Array = param1.match(_loc11_);
         var _loc13_:int = param6.zoneID;
         var _loc14_:int = 0;
         while(_loc14_ < _loc12_.length)
         {
            _loc9_ = String(_loc12_[_loc14_].substr(1,_loc12_[_loc14_].length - 2));
            param1 = param1.replace("[" + _loc9_ + "]",_loc10_[0] + "<a href=\"event:" + "clicktype:" + param2.toString() + "|type:" + param8 + "|tagname:" + _loc9_ + "|isBind:" + param5.toString() + "|templeteIDorItemID:" + param3.toString() + "|key:" + param7 + "|zoneID:" + _loc13_ + "\">" + Helpers.enCodeString("[" + _loc9_ + "]") + "</a>" + _loc10_[1]);
            _loc14_++;
         }
         return param1;
      }
      
      public static function getColorByChannel(param1:int) : int
      {
         return CHAT_COLORS[param1];
      }
      
      public static function getColorByBigBuggleType(param1:int) : int
      {
         return BIG_BUGGLE_COLOR[param1];
      }
      
      public static function getTagsByChannel(param1:int) : Array
      {
         return ["<CT" + param1.toString() + ">","</CT" + param1.toString() + ">"];
      }
      
      public static function getTagsByQuality(param1:int) : Array
      {
         return ["<QT" + param1.toString() + ">","</QT" + param1.toString() + ">"];
      }
      
      public static function getTextFormatByChannel(param1:int) : TextFormat
      {
         return _formats[param1];
      }
      
      public static function setup() : void
      {
         setupFormat();
         setupStyle();
      }
      
      public static function get styleSheet() : StyleSheet
      {
         return _styleSheet;
      }
      
      public static function get gameStyleSheet() : StyleSheet
      {
         return _gameStyleSheet;
      }
      
      private static function getBigBuggleTypeString(param1:int) : String
      {
         return BIG_BUGGLE_TYPE_STRING[param1 - 1];
      }
      
      private static function creatChannelTag(param1:int, param2:int = 0, param3:ddt.view.chat.ChatData = null) : String
      {
         var _loc4_:String = "";
         if(Boolean(Channel_Set[param1]) && param1 != ChatInputView.PRIVATE)
         {
            if(param2 == 0)
            {
               if(param1 != 15)
               {
                  _loc4_ = creatBracketsTag("[" + Channel_Set[param1] + "]",CLICK_CHANNEL,["channel:" + param1.toString()]);
               }
               else
               {
                  _loc4_ = creatBracketsTag("[" + Channel_Set[param1] + "]" + "&lt;" + param3.zoneName + "&gt;",CLICK_CHANNEL,["channel:" + param1.toString()]);
               }
            }
            else
            {
               _loc4_ = "[" + getBigBuggleTypeString(param2) + Channel_Set[param1] + "]";
            }
         }
         return _loc4_;
      }
      
      private static function creatContentTag(param1:ddt.view.chat.ChatData) : String
      {
         var _loc2_:Object = null;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:ItemTemplateInfo = null;
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         var _loc8_:String = null;
         var _loc9_:String = param1.msg;
         var _loc10_:uint = 0;
         if(Boolean(param1.link))
         {
            param1.link.sortOn("index");
            for each(_loc2_ in param1.link)
            {
               _loc3_ = Number(_loc2_.ItemID);
               _loc4_ = int(_loc2_.TemplateID);
               _loc5_ = ItemManager.Instance.getTemplateById(_loc4_);
               _loc6_ = String(_loc2_.key);
               _loc7_ = _loc2_.index + _loc10_;
               if(_loc3_ <= 0)
               {
                  _loc8_ = creatGoodTag("[" + _loc5_.Name + "]",CLICK_GOODS,_loc5_.TemplateID,_loc5_.Quality,true,param1);
               }
               else if(param1.type == 20 || param1.type == 18)
               {
                  _loc8_ = creatGoodTag("[" + _loc5_.Name + "]",CLICK_INVENTORY_GOODS,_loc3_,_loc5_.Quality,true,param1,_loc6_,param1.type);
               }
               else
               {
                  _loc8_ = creatGoodTag("[" + _loc5_.Name + "]",CLICK_INVENTORY_GOODS,_loc3_,_loc5_.Quality,true,param1,_loc6_);
               }
               _loc9_ = _loc9_.substring(0,_loc7_) + _loc8_ + _loc9_.substring(_loc7_);
               _loc10_ += _loc8_.length;
            }
         }
         if(param1.type == CLICK_EFFORT)
         {
            return creatBracketsTag(_loc9_,CLICK_EFFORT,null,param1);
         }
         if(param1.type == 108 || param1.type > CLICK_ACT_TIP)
         {
            return creatBracketsTag(_loc9_,param1.type,null,param1);
         }
         if(param1.channel <= 5)
         {
            if(param1.type == CLICK_USERNAME || param1.type == CLICK_DIFF_ZONE)
            {
               return creatBracketsTag(_loc9_,CLICK_USERNAME,null,param1);
            }
            return _loc9_;
         }
         return creatBracketsTag(_loc9_,CLICK_USERNAME,null,param1);
      }
      
      private static function creatSenderTag(param1:ddt.view.chat.ChatData) : String
      {
         var _loc2_:String = "";
         if(param1.sender == "")
         {
            return _loc2_;
         }
         if(param1.channel == ChatInputView.PRIVATE)
         {
            if(param1.sender == PlayerManager.Instance.Self.NickName)
            {
               _loc2_ = creatBracketsTag(LanguageMgr.GetTranslation("tank.view.chatsystem.sendTo") + "[" + param1.receiver + "]: ",CLICK_USERNAME,null,param1);
            }
            else
            {
               _loc2_ = creatBracketsTag("[" + param1.sender + "]" + LanguageMgr.GetTranslation("tank.view.chatsystem.privateSayToYou"),CLICK_USERNAME,null,param1);
            }
         }
         else if(param1.zoneID == PlayerManager.Instance.Self.ZoneID || param1.zoneID <= 0)
         {
            _loc2_ = creatBracketsTag("[" + param1.sender + "]: ",CLICK_USERNAME,null,param1);
         }
         else
         {
            _loc2_ = creatBracketsTag("[" + param1.sender + "]: ",CLICK_DIFF_ZONE,null,param1);
         }
         return _loc2_;
      }
      
      public static function replaceUnacceptableChar(param1:String) : String
      {
         var _loc2_:int = 0;
         while(_loc2_ < unacceptableChar.length)
         {
            param1 = param1.replace(unacceptableChar[_loc2_],"");
            _loc2_++;
         }
         return param1;
      }
      
      private static function creatStyleObject(param1:int, param2:uint = 0) : Object
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         switch(param2)
         {
            case NORMAL:
               _loc4_ = "13";
               break;
            case IN_GAME:
               _loc4_ = "12";
         }
         return {
            "color":"#" + param1.toString(16),
            "leading":"5",
            "fontFamily":"Arial",
            "display":"inline",
            "fontSize":_loc4_
         };
      }
      
      private static function setupFormat() : void
      {
         var _loc1_:TextFormat = null;
         _formats = new Dictionary();
         var _loc2_:int = 0;
         while(_loc2_ < CHAT_COLORS.length)
         {
            _loc1_ = new TextFormat();
            _loc1_.font = "Arial";
            _loc1_.size = 13;
            _loc1_.color = CHAT_COLORS[_loc2_];
            _formats[_loc2_] = _loc1_;
            _loc2_++;
         }
      }
      
      private static function setupStyle() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         _styleSheetData = new Dictionary();
         _styleSheet = new StyleSheet();
         _gameStyleSheet = new StyleSheet();
         var _loc5_:int = 0;
         while(_loc5_ < QualityType.QUALITY_COLOR.length)
         {
            _loc1_ = creatStyleObject(QualityType.QUALITY_COLOR[_loc5_]);
            _loc2_ = creatStyleObject(QualityType.QUALITY_COLOR[_loc5_],1);
            _styleSheetData["QT" + _loc5_] = _loc1_;
            _styleSheet.setStyle("QT" + _loc5_,_loc1_);
            _gameStyleSheet.setStyle("QT" + _loc5_,_loc2_);
            _loc5_++;
         }
         var _loc6_:int = 0;
         while(_loc6_ <= CHAT_COLORS.length)
         {
            _loc3_ = creatStyleObject(CHAT_COLORS[_loc6_]);
            _loc4_ = creatStyleObject(CHAT_COLORS[_loc6_],1);
            _styleSheetData["CT" + String(_loc6_)] = _loc3_;
            _styleSheet.setStyle("CT" + String(_loc6_),_loc3_);
            _gameStyleSheet.setStyle("CT" + String(_loc6_),_loc4_);
            _loc6_++;
         }
      }
   }
}
