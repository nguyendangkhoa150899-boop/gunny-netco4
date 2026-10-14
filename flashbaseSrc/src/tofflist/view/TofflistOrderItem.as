package tofflist.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.view.selfConsortia.Badge;
   import ddt.data.ConsortiaInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.LevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextFormat;
   import tofflist.TofflistEvent;
   import tofflist.TofflistModel;
   import tofflist.data.TofflistConsortiaData;
   import tofflist.data.TofflistConsortiaInfo;
   import tofflist.data.TofflistPlayerInfo;
   import vip.VipController;
   
   public class TofflistOrderItem extends Sprite implements Disposeable
   {
       
      
      private var _consortiaInfo:TofflistConsortiaInfo;
      
      private var _badge:Badge;
      
      private var _index:int;
      
      private var _info:TofflistPlayerInfo;
      
      private var _isSelect:Boolean;
      
      private var _itemBgAsset:Bitmap;
      
      private var _level:LevelIcon;
      
      private var _vipName:GradientText;
      
      private var _topThreeRink:ScaleFrameImage;
      
      private var _resourceArr:Array;
      
      private var _styleLinkArr:Array;
      
      public function TofflistOrderItem()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      public function get currentText() : String
      {
         return this._resourceArr[2].dis["text"];
      }
      
      public function dispose() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.removeEvent();
         if(Boolean(this._resourceArr))
         {
            _loc2_ = 0;
            _loc3_ = this._resourceArr.length;
            while(_loc2_ < _loc3_)
            {
               _loc1_ = this._resourceArr[_loc2_].dis;
               ObjectUtils.disposeObject(_loc1_);
               _loc1_ = null;
               this._resourceArr[_loc2_] = null;
               _loc2_++;
            }
            this._resourceArr = null;
         }
         this._styleLinkArr = null;
         this._badge.dispose();
         this._badge = null;
         ObjectUtils.disposeAllChildren(this);
         this._itemBgAsset = null;
         if(Boolean(this._topThreeRink))
         {
            this._topThreeRink.dispose();
         }
         this._topThreeRink = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(param1:int) : void
      {
         this._index = param1;
      }
      
      public function get info() : Object
      {
         return this._info;
      }
      
      public function set info(param1:Object) : void
      {
         var _loc2_:TofflistConsortiaData = null;
         if(param1 is PlayerInfo)
         {
            this._info = param1 as TofflistPlayerInfo;
         }
         else if(param1 is TofflistConsortiaData)
         {
            _loc2_ = param1 as TofflistConsortiaData;
            if(Boolean(_loc2_))
            {
               this._info = _loc2_.playerInfo;
               this._consortiaInfo = _loc2_.consortiaInfo;
            }
         }
         if(Boolean(this._info))
         {
            this.upView();
         }
      }
      
      public function set isSelect(param1:Boolean) : void
      {
         this._itemBgAsset.visible = this._isSelect = param1;
         if(param1)
         {
            this.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_ITEM_SELECT,this));
         }
      }
      
      public function set resourceLink(param1:String) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Object = null;
         this._resourceArr = [];
         var _loc4_:Array = param1.replace(/(\s*)|(\s*$)/g,"").split("|");
         var _loc5_:uint = 0;
         var _loc6_:uint = _loc4_.length;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = {};
            _loc3_.id = _loc4_[_loc5_].split("#")[0];
            _loc3_.className = _loc4_[_loc5_].split("#")[1];
            _loc2_ = ComponentFactory.Instance.creat(_loc3_.className);
            addChild(_loc2_);
            _loc3_.dis = _loc2_;
            this._resourceArr.push(_loc3_);
            _loc5_++;
         }
      }
      
      public function set setAllStyleXY(param1:String) : void
      {
         this._styleLinkArr = param1.replace(/(\s*)|(\s*$)/g,"").split("~");
         this.updateStyleXY();
      }
      
      public function updateStyleXY(param1:int = 0) : void
      {
         var _loc3_:uint = 0;
         var _loc7_:Point = null;
         var _loc2_:DisplayObject = null;
         _loc3_ = 0;
         var _loc4_:uint = 0;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         _loc7_ = null;
         var _loc8_:uint = this._resourceArr.length;
         _loc5_ = this._styleLinkArr[param1].split("|");
         _loc8_ = _loc5_.length;
         _loc3_ = 0;
         while(_loc3_ < _loc8_)
         {
            _loc2_ = null;
            _loc6_ = int(_loc5_[_loc3_].split("#")[0]);
            _loc4_ = 0;
            while(_loc4_ < this._resourceArr.length)
            {
               if(_loc6_ == this._resourceArr[_loc4_].id)
               {
                  _loc2_ = this._resourceArr[_loc4_].dis;
                  break;
               }
               _loc4_++;
            }
            if(Boolean(_loc2_))
            {
               _loc7_ = new Point();
               _loc7_.x = _loc5_[_loc3_].split("#")[1].split(",")[0];
               _loc7_.y = _loc5_[_loc3_].split("#")[1].split(",")[1];
               _loc2_.x = _loc7_.x;
               _loc2_.y = _loc7_.y;
               if(Boolean(_loc5_[_loc3_].split("#")[1].split(",")[2]))
               {
                  _loc2_.width = _loc5_[_loc3_].split("#")[1].split(",")[2];
               }
               if(Boolean(_loc5_[_loc3_].split("#")[1].split(",")[3]))
               {
                  _loc2_.height = _loc5_[_loc3_].split("#")[1].split(",")[3];
               }
               _loc2_["text"] = _loc2_["text"];
               _loc2_.visible = true;
            }
            _loc3_++;
         }
         if(this._index < 4)
         {
            this._topThreeRink.x = this._resourceArr[0].dis.x - 9;
            this._topThreeRink.y = this._resourceArr[0].dis.y - 2;
            this._topThreeRink.visible = true;
            this._topThreeRink.setFrame(this._index);
            this._resourceArr[0].dis.visible = false;
         }
      }
      
      private function get NO_ID() : String
      {
         var _loc1_:String = "";
         switch(this._index)
         {
            case 1:
               _loc1_ = 1 + "st";
               break;
            case 2:
               _loc1_ = 2 + "nd";
               break;
            case 3:
               _loc1_ = 3 + "rd";
               break;
            default:
               _loc1_ = this._index + "th";
         }
         return _loc1_;
      }
      
      private function __itemClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._isSelect)
         {
            this.isSelect = true;
         }
      }
      
      private function __itemMouseOutHandler(param1:MouseEvent) : void
      {
         if(this._isSelect)
         {
            return;
         }
         this._itemBgAsset.visible = false;
      }
      
      private function __itemMouseOverHandler(param1:MouseEvent) : void
      {
         this._itemBgAsset.visible = true;
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__itemClickHandler);
         addEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOutHandler);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__offerChange);
      }
      
      private function __offerChange(param1:PlayerPropertyEvent) : void
      {
         if(Boolean(param1.changedProperties["isVip"]))
         {
            this.upView();
         }
      }
      
      private function init() : void
      {
         this.graphics.beginFill(0,0);
         this.graphics.drawRect(0,0,495,30);
         this.graphics.endFill();
         this.buttonMode = true;
         this._itemBgAsset = ComponentFactory.Instance.creat("asset.Toffilist.itemBgAsset");
         this._itemBgAsset.visible = false;
         addChild(this._itemBgAsset);
         this._badge = new Badge();
         this._badge.visible = false;
         addChild(this._badge);
         PositionUtils.setPos(this._badge,"tofflist.item.badgePos");
         this._level = new LevelIcon();
         this._level.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._level);
         this._level.visible = false;
         this._topThreeRink = ComponentFactory.Instance.creat("toffilist.topThreeRink");
         addChild(this._topThreeRink);
         this._topThreeRink.visible = false;
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__itemClickHandler);
         removeEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOverHandler);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOutHandler);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__offerChange);
      }
      
      private function upView() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:uint = 0;
         var _loc3_:TextFormat = null;
         var _loc4_:TextFormat = null;
         var _loc5_:uint = this._resourceArr.length;
         _loc2_ = 0;
         while(_loc2_ < _loc5_)
         {
            _loc1_ = this._resourceArr[_loc2_].dis;
            _loc1_["text"] = "";
            _loc1_.visible = false;
            _loc2_++;
         }
         this._resourceArr[0].dis["text"] = this.NO_ID;
         switch(TofflistModel.firstMenuType)
         {
            case TofflistStairMenu.PERSONAL:
               this._resourceArr[1].dis["text"] = this._info.NickName;
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this.updateStyleXY(0);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._info.FightPower;
                     }
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this.updateStyleXY(1);
                     if(Boolean(this._vipName))
                     {
                        this._vipName.x = this._resourceArr[1].dis.x - this._vipName.width / 2;
                     }
                     this._level.x = 286;
                     this._level.y = 5;
                     this._level.setInfo(this._info.Grade,this._info.Repute,this._info.WinCount,this._info.TotalCount,this._info.FightPower,this._info.Offer,true,false);
                     this._level.visible = true;
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._info.AddDayGP;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._info.AddWeekGP;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._info.GP;
                     }
                     break;
                  case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                     this.updateStyleXY(2);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._info.AddDayAchievementPoint;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._info.AddWeekAchievementPoint;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._info.AchievementPoint;
                     }
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this.updateStyleXY(3);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._info.AddDayGiftGp;
                           this._resourceArr[3].dis["text"] = this._info.GiftLevel;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._info.AddWeekGiftGp;
                           this._resourceArr[3].dis["text"] = this._info.GiftLevel;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._info.GiftGp;
                           this._resourceArr[3].dis["text"] = this._info.GiftLevel;
                     }
                     break;
                  case TofflistTwoGradeMenu.MATCHES:
                     this.updateStyleXY(4);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._info.AddWeekLeagueScore;
                     }
               }
               if(this._info.IsVIP)
               {
                  if(Boolean(this._vipName))
                  {
                     ObjectUtils.disposeObject(this._vipName);
                  }
                  this._vipName = VipController.instance.getVipNameTxt(1,this._info.typeVIP);
                  _loc3_ = new TextFormat();
                  _loc3_.align = "center";
                  _loc3_.bold = true;
                  this._vipName.textField.defaultTextFormat = _loc3_;
                  this._vipName.textSize = 16;
                  this._vipName.textField.width = this._resourceArr[1].dis.width;
                  this._vipName.x = this._resourceArr[1].dis.x;
                  this._vipName.y = this._resourceArr[1].dis.y;
                  this._vipName.text = this._info.NickName;
                  this._resourceArr[1].dis["text"] = "";
                  this._resourceArr[1].dis.visible = false;
                  addChild(this._vipName);
               }
               else if(Boolean(this._vipName) && Boolean(this._vipName.parent))
               {
                  this._vipName.parent.removeChild(this._vipName);
               }
               break;
            case TofflistStairMenu.CROSS_SERVER_PERSONAL:
               this._resourceArr[1].dis["text"] = this._info.NickName;
               this._resourceArr[3].dis["text"] = Boolean(this._info.AreaName) ? this._info.AreaName : "";
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this.updateStyleXY(9);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._info.FightPower;
                     }
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this.updateStyleXY(10);
                     if(Boolean(this._vipName))
                     {
                        this._vipName.x = this._resourceArr[1].dis.x - this._vipName.width / 2;
                     }
                     this._level.x = 212;
                     this._level.y = 5;
                     this._level.setInfo(this._info.Grade,this._info.Repute,this._info.WinCount,this._info.TotalCount,this._info.FightPower,this._info.Offer,true,false);
                     this._level.visible = true;
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._info.AddDayGP;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._info.AddWeekGP;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._info.GP;
                     }
                     break;
                  case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                     this.updateStyleXY(11);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._info.AddDayAchievementPoint;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._info.AddWeekAchievementPoint;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._info.AchievementPoint;
                     }
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this.updateStyleXY(12);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._info.AddDayGiftGp;
                           this._resourceArr[4].dis["text"] = this._info.GiftLevel;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._info.AddWeekGiftGp;
                           this._resourceArr[4].dis["text"] = this._info.GiftLevel;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._info.GiftGp;
                           this._resourceArr[4].dis["text"] = this._info.GiftLevel;
                     }
               }
               if(this._info.IsVIP)
               {
                  if(Boolean(this._vipName))
                  {
                     ObjectUtils.disposeObject(this._vipName);
                  }
                  this._vipName = VipController.instance.getVipNameTxt(1,this._info.typeVIP);
                  _loc4_ = new TextFormat();
                  _loc4_.align = "center";
                  _loc4_.bold = true;
                  this._vipName.textField.defaultTextFormat = _loc4_;
                  this._vipName.textSize = 16;
                  this._vipName.textField.width = this._resourceArr[1].dis.width;
                  this._vipName.x = this._resourceArr[1].dis.x;
                  this._vipName.y = this._resourceArr[1].dis.y;
                  this._vipName.text = this._info.NickName;
                  this._resourceArr[1].dis["text"] = "";
                  this._resourceArr[1].dis.visible = false;
                  addChild(this._vipName);
               }
               else if(Boolean(this._vipName) && Boolean(this._vipName.parent))
               {
                  this._vipName.parent.removeChild(this._vipName);
               }
               break;
            case TofflistStairMenu.CONSORTIA:
               if(!this._consortiaInfo)
               {
                  break;
               }
               this._badge.visible = this._consortiaInfo.BadgeID > 0;
               this._badge.badgeID = this._consortiaInfo.BadgeID;
               this._resourceArr[1].dis["text"] = this._consortiaInfo.ConsortiaName;
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this.updateStyleXY(5);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.FightPower;
                     }
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this.updateStyleXY(6);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.LastDayRiches;
                           this._resourceArr[3].dis["text"] = this._consortiaInfo.Level;
                     }
                     break;
                  case TofflistTwoGradeMenu.ASSETS:
                     this.updateStyleXY(7);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.AddDayRiches;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.AddWeekRiches;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.LastDayRiches;
                     }
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this.updateStyleXY(8);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.ConsortiaAddDayGiftGp;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.ConsortiaAddWeekGiftGp;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.ConsortiaGiftGp;
                     }
               }
               break;
            case TofflistStairMenu.CROSS_SERVER_CONSORTIA:
               if(!this._consortiaInfo)
               {
                  break;
               }
               this._badge.visible = this._consortiaInfo.BadgeID > 0;
               this._badge.badgeID = this._consortiaInfo.BadgeID;
               this._resourceArr[1].dis["text"] = this._consortiaInfo.ConsortiaName;
               if(Boolean(this._consortiaInfo.AreaName))
               {
                  this._resourceArr[3].dis["text"] = this._consortiaInfo.AreaName;
               }
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this.updateStyleXY(13);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.FightPower;
                     }
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this.updateStyleXY(14);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.LastDayRiches;
                           this._resourceArr[4].dis["text"] = this._consortiaInfo.Level;
                     }
                     break;
                  case TofflistTwoGradeMenu.ASSETS:
                     this.updateStyleXY(15);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.AddDayRiches;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.AddWeekRiches;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.LastDayRiches;
                     }
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this.updateStyleXY(16);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.ConsortiaAddDayGiftGp;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.ConsortiaAddWeekGiftGp;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.ConsortiaGiftGp;
                     }
               }
               break;
         }
      }
      
      public function get consortiaInfo() : ConsortiaInfo
      {
         return this._consortiaInfo;
      }
   }
}
