package ddt.manager
{
   import GodSyah.SyahManager;
   import bagAndInfo.cell.BagCell;
   import baglocked.BagLockedController;
   import calendar.CalendarManager;
   import cardSystem.data.CardInfo;
   import cityWide.CityWideEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import consortion.ConsortionModelControl;
   import ddt.data.AccountInfo;
   import ddt.data.BagInfo;
   import ddt.data.BuffInfo;
   import ddt.data.CMFriendInfo;
   import ddt.data.CheckCodeData;
   import ddt.data.EquipType;
   import ddt.data.PathInfo;
   import ddt.data.analyze.FriendListAnalyzer;
   import ddt.data.analyze.MyAcademyPlayersAnalyze;
   import ddt.data.analyze.RecentContactsAnalyze;
   import ddt.data.club.ClubInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.PlayerPropertyType;
   import ddt.data.player.PlayerState;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.events.CEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PkgEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.view.CheckCodeFrame;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import game.GameManager;
   import gemstone.info.GemstListInfo;
   import gemstone.info.GemstonInitInfo;
   import giftSystem.GiftController;
   import giftSystem.data.MyGiftCellInfo;
   import im.AddCommunityFriend;
   import im.IMController;
   import im.IMEvent;
   import im.info.CustomInfo;
   import pet.date.PetEquipData;
   import pet.date.PetInfo;
   import pet.date.PetSkill;
   import petsBag.controller.PetBagController;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import road7th.utils.BitmapReader;
   import roomList.PassInputFrame;
   import store.equipGhost.data.EquipGhostData;
   
   public class PlayerManager extends EventDispatcher
   {
      
      public static const FRIEND_STATE_CHANGED:String = "friendStateChanged";
      
      public static const FRIENDLIST_COMPLETE:String = "friendListComplete";
      
      public static const RECENT_CONTAST_COMPLETE:String = "recentContactsComplete";
      
      public static const CIVIL_SELFINFO_CHANGE:String = "civilselfinfochange";
      
      public static const VIP_STATE_CHANGE:String = "VIPStateChange";
      
      public static const GIFT_INFO_CHANGE:String = "giftInfoChange";
      
      public static const SELF_GIFT_INFO_CHANGE:String = "selfGiftInfoChange";
      
      public static const NEW_GIFT_UPDATE:String = "newGiftUPDATE";
      
      public static const NEW_GIFT_ADD:String = "newGiftAdd";
      
      public static const FARM_BAG_UPDATE:String = "farmDataUpdate";
      
      public static const UPDATE_PLAYER_PROPERTY:String = "updatePlayerState";
      
      public static var isShowPHP:Boolean = false;
      
      public static const CUSTOM_MAX:int = 10;
      
      private static var _instance:ddt.manager.PlayerManager;
      
      public static var SelfStudyEnergy:Boolean = true;
       
      
      private var _recentContacts:DictionaryData;
      
      public var customList:Vector.<CustomInfo>;
      
      private var _friendList:DictionaryData;
      
      private var _cmFriendList:DictionaryData;
      
      private var _blackList:DictionaryData;
      
      private var _clubPlays:DictionaryData;
      
      private var _tempList:DictionaryData;
      
      private var _mailTempList:DictionaryData;
      
      private var _myAcademyPlayers:DictionaryData;
      
      private var _sameCityList:Array;
      
      private var _self:SelfInfo;
      
      public var SelfConsortia:ClubInfo;
      
      private var _account:AccountInfo;
      
      private var _propertyAdditions:DictionaryData;
      
      private var tempStyle:Array;
      
      private var changedStyle:DictionaryData;
      
      public var gemstoneInfoList:Vector.<GemstonInitInfo>;
      
      public function PlayerManager()
      {
         this.SelfConsortia = new ClubInfo();
         this.tempStyle = [];
         this.changedStyle = new DictionaryData();
         super();
         this._self = new SelfInfo();
         this._clubPlays = new DictionaryData();
         this._tempList = new DictionaryData();
         this._mailTempList = new DictionaryData();
      }
      
      public static function get Instance() : ddt.manager.PlayerManager
      {
         if(_instance == null)
         {
            _instance = new ddt.manager.PlayerManager();
         }
         return _instance;
      }
      
      public static function readLuckyPropertyName(param1:int) : String
      {
         switch(param1)
         {
            case PlayerPropertyType.Exp:
               return LanguageMgr.GetTranslation("exp");
            case PlayerPropertyType.Offer:
               return LanguageMgr.GetTranslation("offer");
            case PlayerPropertyType.Attack:
               return LanguageMgr.GetTranslation("attack");
            case PlayerPropertyType.Agility:
               return LanguageMgr.GetTranslation("agility");
            case PlayerPropertyType.Damage:
               return LanguageMgr.GetTranslation("damage");
            case PlayerPropertyType.Defence:
               return LanguageMgr.GetTranslation("defence");
            case PlayerPropertyType.Luck:
               return LanguageMgr.GetTranslation("luck");
            case PlayerPropertyType.MaxHp:
               return LanguageMgr.GetTranslation("MaxHp");
            case PlayerPropertyType.Recovery:
               return LanguageMgr.GetTranslation("recovery");
            default:
               return "";
         }
      }
      
      public function get Self() : SelfInfo
      {
         return this._self;
      }
      
      public function setup(param1:AccountInfo) : void
      {
         this._account = param1;
         this.customList = new Vector.<CustomInfo>();
         this._friendList = new DictionaryData();
         this._blackList = new DictionaryData();
         this.initEvents();
      }
      
      public function get Account() : AccountInfo
      {
         return this._account;
      }
      
      public function getDressEquipPlace(param1:InventoryItemInfo) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(EquipType.isWeddingRing(param1) && this.Self.Bag.getItemAt(16) == null)
         {
            return 16;
         }
         var _loc5_:Array = EquipType.CategeryIdToPlace(param1.CategoryID);
         if(_loc5_.length == 1)
         {
            _loc2_ = int(_loc5_[0]);
         }
         else
         {
            _loc3_ = 0;
            _loc4_ = 0;
            while(_loc4_ < _loc5_.length)
            {
               if(PlayerManager.Instance.Self.Bag.getItemAt(_loc5_[_loc4_]) == null)
               {
                  _loc2_ = int(_loc5_[_loc4_]);
                  break;
               }
               _loc3_++;
               if(_loc3_ == _loc5_.length)
               {
                  _loc2_ = int(_loc5_[0]);
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      private function __updateInventorySlot(param1:CrazyTankSocketEvent) : void
      {
         var i:int = 0;
         var slot:int = 0;
         var isUpdate:Boolean = false;
         var item:InventoryItemInfo = null;
         var evt:CrazyTankSocketEvent = param1;
         var pkg:PackageIn = evt.pkg as PackageIn;
         var bagType:int = pkg.readInt();
         var len:int = pkg.readInt();
         var bag:BagInfo = this._self.getBag(bagType);
         bag.beginChanges();
         try
         {
            i = 0;
            while(i < len)
            {
               slot = pkg.readInt();
               isUpdate = pkg.readBoolean();
               if(isUpdate)
               {
                  item = bag.getItemAt(slot);
                  if(item == null)
                  {
                     item = new InventoryItemInfo();
                     item.Place = slot;
                  }
                  item.UserID = pkg.readInt();
                  item.ItemID = pkg.readInt();
                  item.Count = pkg.readInt();
                  item.Place = pkg.readInt();
                  item.TemplateID = pkg.readInt();
                  item.AttackCompose = pkg.readInt();
                  item.DefendCompose = pkg.readInt();
                  item.AgilityCompose = pkg.readInt();
                  item.LuckCompose = pkg.readInt();
                  item.StrengthenLevel = pkg.readInt();
                  item.StrengthenExp = pkg.readInt();
                  item.IsBinds = pkg.readBoolean();
                  item.IsJudge = pkg.readBoolean();
                  item.BeginDate = pkg.readDateString();
                  item.ValidDate = pkg.readInt();
                  item.Color = pkg.readUTF();
                  item.Skin = pkg.readUTF();
                  item.IsUsed = pkg.readBoolean();
                  item.Hole1 = pkg.readInt();
                  item.Hole2 = pkg.readInt();
                  item.Hole3 = pkg.readInt();
                  item.Hole4 = pkg.readInt();
                  item.Hole5 = pkg.readInt();
                  item.Hole6 = pkg.readInt();
                  ItemManager.fill(item);
                  item.Pic = pkg.readUTF();
                  item.RefineryLevel = pkg.readInt();
                  item.DiscolorValidDate = pkg.readDateString();
                  item.StrengthenTimes = pkg.readInt();
                  item.Hole5Level = pkg.readByte();
                  item.Hole5Exp = pkg.readInt();
                  item.Hole6Level = pkg.readByte();
                  item.Hole6Exp = pkg.readInt();
                  item.curExp = pkg.readInt();
                  item.cellLocked = pkg.readBoolean();
                  item.isGold = pkg.readBoolean();
                  if(item.isGold)
                  {
                     item.goldValidDate = pkg.readInt();
                     item.goldBeginTime = pkg.readDateString();
                  }
                  item.latentEnergyCurStr = pkg.readUTF();
                  item.latentEnergyNewStr = pkg.readUTF();
                  item.latentEnergyEndTime = pkg.readDate();
                  if(EquipType.isWeddingRing(item))
                  {
                     item.RingExp = this._self.RingExp;
                  }
                  bag.addItem(item);
                  if(item.Place == 15 && bagType == 0 && item.UserID == this.Self.ID)
                  {
                     this._self.DeputyWeaponID = item.TemplateID;
                  }
                  if(PathManager.solveExternalInterfaceEnabel() && bagType == BagInfo.STOREBAG && item.StrengthenLevel >= 7)
                  {
                     ExternalInterfaceManager.sendToAgent(3,this.Self.ID,this.Self.NickName,ServerManager.Instance.zoneName,item.StrengthenLevel);
                  }
               }
               else
               {
                  bag.removeItemAt(slot);
               }
               i++;
            }
            return;
         }
         finally
         {
            bag.commiteChanges();
         }
      }
      
      private function __itemEquip(param1:CrazyTankSocketEvent) : void
      {
         var _loc17_:* = undefined;
         var _loc18_:uint = 0;
         var _loc19_:String = null;
         var _loc20_:Array = null;
         var _loc21_:int = 0;
         var _loc22_:Array = null;
         var _loc2_:GemstonInitInfo = null;
         var _loc3_:Vector.<GemstListInfo> = null;
         var _loc4_:GemstListInfo = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc8_:InventoryItemInfo = null;
         var _loc9_:PackageIn = param1.pkg;
         var _loc10_:int = 0;
         var _loc11_:* = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         _loc9_.deCompress();
         _loc5_ = _loc9_.readInt();
         var _loc15_:String = _loc9_.readUTF();
         var _loc16_:PlayerInfo = this.findPlayer(_loc5_,-1,_loc15_);
         _loc16_.ID = _loc5_;
         if(_loc16_ != null)
         {
            _loc16_.beginChanges();
            _loc16_.Agility = _loc9_.readInt();
            _loc16_.Attack = _loc9_.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc5_))
            {
               _loc16_.Colors = _loc9_.readUTF();
               _loc16_.Skin = _loc9_.readUTF();
            }
            else
            {
               _loc9_.readUTF();
               _loc9_.readUTF();
               _loc16_.Colors = this.changedStyle[_loc5_]["Colors"];
               _loc16_.Skin = this.changedStyle[_loc5_]["Skin"];
            }
            _loc16_.Defence = _loc9_.readInt();
            _loc16_.GP = _loc9_.readInt();
            _loc16_.Grade = _loc9_.readInt();
            _loc16_.Luck = _loc9_.readInt();
            _loc16_.hp = _loc9_.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc5_))
            {
               _loc16_.Hide = _loc9_.readInt();
            }
            else
            {
               _loc9_.readInt();
               _loc16_.Hide = this.changedStyle[_loc5_]["Hide"];
            }
            _loc16_.Repute = _loc9_.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc5_))
            {
               _loc16_.Sex = _loc9_.readBoolean();
               _loc16_.Style = _loc9_.readUTF();
            }
            else
            {
               _loc9_.readBoolean();
               _loc9_.readUTF();
               _loc16_.Sex = this.changedStyle[_loc5_]["Sex"];
               _loc16_.Style = this.changedStyle[_loc5_]["Style"];
            }
            _loc16_.Offer = _loc9_.readInt();
            _loc16_.NickName = _loc15_;
            _loc16_.typeVIP = _loc9_.readByte();
            _loc16_.VIPLevel = _loc9_.readInt();
            _loc16_.WinCount = _loc9_.readInt();
            _loc16_.TotalCount = _loc9_.readInt();
            _loc16_.EscapeCount = _loc9_.readInt();
            _loc16_.ConsortiaID = _loc9_.readInt();
            _loc16_.ConsortiaName = _loc9_.readUTF();
            _loc16_.badgeID = _loc9_.readInt();
            _loc16_.RichesOffer = _loc9_.readInt();
            _loc16_.RichesRob = _loc9_.readInt();
            _loc16_.IsMarried = _loc9_.readBoolean();
            _loc16_.SpouseID = _loc9_.readInt();
            _loc16_.SpouseName = _loc9_.readUTF();
            _loc16_.DutyName = _loc9_.readUTF();
            _loc16_.Nimbus = _loc9_.readInt();
            _loc16_.FightPower = _loc9_.readInt();
            _loc16_.apprenticeshipState = _loc9_.readInt();
            _loc16_.masterID = _loc9_.readInt();
            _loc16_.setMasterOrApprentices(_loc9_.readUTF());
            _loc16_.graduatesCount = _loc9_.readInt();
            _loc16_.honourOfMaster = _loc9_.readUTF();
            _loc16_.AchievementPoint = _loc9_.readInt();
            _loc16_.honor = _loc9_.readUTF();
            _loc16_.LastLoginDate = _loc9_.readDate();
            _loc16_.spdTexpExp = _loc9_.readInt();
            _loc16_.attTexpExp = _loc9_.readInt();
            _loc16_.defTexpExp = _loc9_.readInt();
            _loc16_.hpTexpExp = _loc9_.readInt();
            _loc16_.lukTexpExp = _loc9_.readInt();
            _loc16_.DailyLeagueFirst = _loc9_.readBoolean();
            _loc16_.DailyLeagueLastScore = _loc9_.readInt();
            _loc16_.totemId = _loc9_.readInt();
            _loc16_.necklaceExp = _loc9_.readInt();
            _loc16_.RingExp = _loc9_.readInt();
            _loc16_.commitChanges();
            _loc6_ = _loc9_.readInt();
            _loc16_.Bag.beginChanges();
            if(!(_loc16_ is SelfInfo))
            {
               _loc16_.Bag.clearnAll();
            }
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc8_ = new InventoryItemInfo();
               _loc8_.BagType = _loc9_.readByte();
               _loc8_.UserID = _loc9_.readInt();
               _loc8_.ItemID = _loc9_.readInt();
               _loc8_.Count = _loc9_.readInt();
               _loc8_.Place = _loc9_.readInt();
               _loc8_.TemplateID = _loc9_.readInt();
               _loc8_.AttackCompose = _loc9_.readInt();
               _loc8_.DefendCompose = _loc9_.readInt();
               _loc8_.AgilityCompose = _loc9_.readInt();
               _loc8_.LuckCompose = _loc9_.readInt();
               _loc8_.StrengthenLevel = _loc9_.readInt();
               _loc8_.IsBinds = _loc9_.readBoolean();
               _loc8_.IsJudge = _loc9_.readBoolean();
               _loc8_.BeginDate = _loc9_.readDateString();
               _loc8_.ValidDate = _loc9_.readInt();
               _loc8_.Color = _loc9_.readUTF();
               _loc8_.Skin = _loc9_.readUTF();
               _loc8_.IsUsed = _loc9_.readBoolean();
               ItemManager.fill(_loc8_);
               _loc8_.Hole1 = _loc9_.readInt();
               _loc8_.Hole2 = _loc9_.readInt();
               _loc8_.Hole3 = _loc9_.readInt();
               _loc8_.Hole4 = _loc9_.readInt();
               _loc8_.Hole5 = _loc9_.readInt();
               _loc8_.Hole6 = _loc9_.readInt();
               _loc8_.Pic = _loc9_.readUTF();
               _loc8_.RefineryLevel = _loc9_.readInt();
               _loc8_.DiscolorValidDate = _loc9_.readDateString();
               _loc8_.Hole5Level = _loc9_.readByte();
               _loc8_.Hole5Exp = _loc9_.readInt();
               _loc8_.Hole6Level = _loc9_.readByte();
               _loc8_.Hole6Exp = _loc9_.readInt();
               _loc8_.isGold = _loc9_.readBoolean();
               if(_loc8_.isGold)
               {
                  _loc8_.goldValidDate = _loc9_.readInt();
                  _loc8_.goldBeginTime = _loc9_.readDateString();
               }
               _loc8_.latentEnergyCurStr = _loc9_.readUTF();
               _loc8_.latentEnergyNewStr = _loc9_.readUTF();
               _loc8_.latentEnergyEndTime = _loc9_.readDate();
               if(EquipType.isWeddingRing(_loc8_))
               {
                  _loc8_.RingExp = _loc16_.RingExp;
               }
               _loc16_.Bag.addItem(_loc8_);
               _loc7_++;
            }
            _loc17_ = _loc9_.readInt();
            _loc18_ = 0;
            _loc19_ = null;
            _loc20_ = null;
            _loc21_ = 0;
            _loc22_ = null;
            this.gemstoneInfoList = new Vector.<GemstonInitInfo>();
            _loc18_ = 0;
            while(_loc18_ < _loc17_)
            {
               _loc2_ = new GemstonInitInfo();
               _loc2_.figSpiritId = _loc9_.readInt();
               _loc19_ = _loc9_.readUTF();
               _loc20_ = this.rezArr(_loc19_);
               _loc3_ = new Vector.<GemstListInfo>();
               _loc21_ = 0;
               while(_loc21_ < 3)
               {
                  _loc22_ = _loc20_[_loc21_].split(",");
                  _loc4_ = new GemstListInfo();
                  _loc4_.fightSpiritId = _loc2_.figSpiritId;
                  _loc4_.level = _loc22_[0];
                  _loc4_.exp = _loc22_[1];
                  _loc4_.place = _loc22_[2];
                  _loc3_.push(_loc4_);
                  _loc21_++;
               }
               _loc2_.equipPlace = _loc9_.readInt();
               if(Boolean(_loc16_.Bag.getItemAt(_loc2_.equipPlace)))
               {
                  _loc16_.Bag.getItemAt(_loc2_.equipPlace).gemstoneList = _loc3_;
               }
               _loc2_.list = _loc3_;
               this.gemstoneInfoList.push(_loc2_);
               _loc18_++;
            }
            _loc16_.gemstoneList = this.gemstoneInfoList;
            if((_loc10_ = _loc9_.readInt()) > 0)
            {
               _loc11_ = null;
               _loc12_ = 0;
               _loc13_ = 0;
               _loc14_ = 0;
               while(_loc14_ < _loc10_)
               {
                  _loc12_ = _loc9_.readInt();
                  _loc13_ = _loc9_.readInt();
                  (_loc11_ = new EquipGhostData(_loc12_,_loc13_)).level = _loc9_.readInt();
                  _loc11_.totalGhost = _loc9_.readInt();
                  _loc16_.addGhostData(_loc11_);
                  _loc14_++;
               }
            }
            _loc16_.manualProInfo.manual_Level = _loc9_.readInt();
            _loc16_.manualProInfo.pro_Agile = _loc9_.readInt();
            _loc16_.manualProInfo.pro_Armor = _loc9_.readInt();
            _loc16_.manualProInfo.pro_Attack = _loc9_.readInt();
            _loc16_.manualProInfo.pro_Damage = _loc9_.readInt();
            _loc16_.manualProInfo.pro_Defense = _loc9_.readInt();
            _loc16_.manualProInfo.pro_HP = _loc9_.readInt();
            _loc16_.manualProInfo.pro_Lucky = _loc9_.readInt();
            _loc16_.manualProInfo.pro_MagicAttack = _loc9_.readInt();
            _loc16_.manualProInfo.pro_MagicResistance = _loc9_.readInt();
            _loc16_.manualProInfo.pro_Stamina = _loc9_.readInt();
            _loc16_.Bag.commiteChanges();
            _loc16_.commitChanges();
            dispatchEvent(new CEvent("playerEquipItem",_loc5_));
         }
      }
      
      private function rezArr(param1:String) : Array
      {
         return param1.split("|");
      }
      
      private function __onsItemEquip(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:String = _loc2_.readUTF();
         var _loc5_:PlayerInfo = this.findPlayer(_loc3_);
         if(_loc5_ != null)
         {
            _loc5_.beginChanges();
            _loc5_.Agility = _loc2_.readInt();
            _loc5_.Attack = _loc2_.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc3_))
            {
               _loc5_.Colors = _loc2_.readUTF();
               _loc5_.Skin = _loc2_.readUTF();
            }
            else
            {
               _loc2_.readUTF();
               _loc2_.readUTF();
               _loc5_.Colors = this.changedStyle[_loc3_]["Colors"];
               _loc5_.Skin = this.changedStyle[_loc3_]["Skin"];
            }
            _loc5_.Defence = _loc2_.readInt();
            _loc5_.GP = _loc2_.readInt();
            _loc5_.Grade = _loc2_.readInt();
            _loc5_.Luck = _loc2_.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc3_))
            {
               _loc5_.Hide = _loc2_.readInt();
            }
            else
            {
               _loc2_.readInt();
               _loc5_.Hide = this.changedStyle[_loc3_]["Hide"];
            }
            _loc5_.Repute = _loc2_.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc3_))
            {
               _loc5_.Sex = _loc2_.readBoolean();
               _loc5_.Style = _loc2_.readUTF();
            }
            else
            {
               _loc2_.readBoolean();
               _loc2_.readUTF();
               _loc5_.Sex = this.changedStyle[_loc3_]["Sex"];
               _loc5_.Style = this.changedStyle[_loc3_]["Style"];
            }
            _loc5_.Offer = _loc2_.readInt();
            _loc5_.NickName = _loc4_;
            _loc5_.typeVIP = _loc2_.readByte();
            _loc5_.VIPLevel = _loc2_.readInt();
            _loc5_.WinCount = _loc2_.readInt();
            _loc5_.TotalCount = _loc2_.readInt();
            _loc5_.EscapeCount = _loc2_.readInt();
            _loc5_.ConsortiaID = _loc2_.readInt();
            _loc5_.ConsortiaName = _loc2_.readUTF();
            _loc5_.RichesOffer = _loc2_.readInt();
            _loc5_.RichesRob = _loc2_.readInt();
            _loc5_.IsMarried = _loc2_.readBoolean();
            _loc5_.SpouseID = _loc2_.readInt();
            _loc5_.SpouseName = _loc2_.readUTF();
            _loc5_.DutyName = _loc2_.readUTF();
            _loc5_.Nimbus = _loc2_.readInt();
            _loc5_.FightPower = _loc2_.readInt();
            _loc5_.apprenticeshipState = _loc2_.readInt();
            _loc5_.masterID = _loc2_.readInt();
            _loc5_.setMasterOrApprentices(_loc2_.readUTF());
            _loc5_.graduatesCount = _loc2_.readInt();
            _loc5_.honourOfMaster = _loc2_.readUTF();
            _loc5_.AchievementPoint = _loc2_.readInt();
            _loc5_.honor = _loc2_.readUTF();
            _loc5_.LastLoginDate = _loc2_.readDate();
            _loc5_.commitChanges();
            _loc5_.Bag.beginChanges();
            _loc5_.Bag.commiteChanges();
            _loc5_.commitChanges();
         }
         super.dispatchEvent(new CityWideEvent(CityWideEvent.ONS_PLAYERINFO,_loc5_));
      }
      
      private function __bagLockedHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:Boolean = param1.pkg.readBoolean();
         var _loc5_:Boolean = param1.pkg.readBoolean();
         var _loc6_:String = param1.pkg.readUTF();
         var _loc7_:int = param1.pkg.readInt();
         var _loc8_:String = param1.pkg.readUTF();
         var _loc9_:String = param1.pkg.readUTF();
         if(_loc4_)
         {
            switch(_loc3_)
            {
               case 1:
                  this._self.bagPwdState = true;
                  this._self.bagLocked = true;
                  this._self.onReceiveTypes(BagEvent.CHANGEPSW);
                  BagLockedController.PWD = BagLockedController.TEMP_PWD;
                  MessageTipManager.getInstance().show(_loc6_);
                  break;
               case 2:
                  this._self.bagPwdState = true;
                  this._self.bagLocked = false;
                  if(!ServerManager.AUTO_UNLOCK)
                  {
                     MessageTipManager.getInstance().show(_loc6_);
                     ServerManager.AUTO_UNLOCK = false;
                  }
                  BagLockedController.PWD = BagLockedController.TEMP_PWD;
                  this._self.onReceiveTypes(BagEvent.CLEAR);
                  break;
               case 3:
                  this._self.onReceiveTypes(BagEvent.UPDATE_SUCCESS);
                  BagLockedController.PWD = BagLockedController.TEMP_PWD;
                  MessageTipManager.getInstance().show(_loc6_);
                  break;
               case 4:
                  this._self.bagPwdState = false;
                  this._self.bagLocked = false;
                  this._self.onReceiveTypes(BagEvent.AFTERDEL);
                  MessageTipManager.getInstance().show(_loc6_);
                  break;
               case 5:
                  this._self.bagPwdState = true;
                  this._self.bagLocked = true;
                  MessageTipManager.getInstance().show(_loc6_);
                  break;
               case 6:
            }
         }
         else
         {
            MessageTipManager.getInstance().show(_loc6_);
         }
      }
      
      private function __friendAdd(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:FriendListPlayer = null;
         var _loc3_:PlayerInfo = null;
         var _loc4_:PackageIn = param1.pkg;
         var _loc5_:Boolean = _loc4_.readBoolean();
         if(_loc5_)
         {
            _loc2_ = new FriendListPlayer();
            _loc2_.beginChanges();
            _loc2_.ID = _loc4_.readInt();
            _loc2_.NickName = _loc4_.readUTF();
            _loc2_.typeVIP = _loc4_.readByte();
            _loc2_.VIPLevel = _loc4_.readInt();
            _loc2_.Sex = _loc4_.readBoolean();
            _loc3_ = this.findPlayer(_loc2_.ID);
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc2_.ID))
            {
               _loc2_.Style = _loc4_.readUTF();
               _loc2_.Colors = _loc4_.readUTF();
               _loc2_.Skin = _loc4_.readUTF();
            }
            else
            {
               _loc4_.readUTF();
               _loc4_.readUTF();
               _loc4_.readUTF();
               _loc2_.Style = _loc3_.Style;
               _loc2_.Colors = _loc3_.Colors;
               _loc2_.Skin = _loc3_.Skin;
            }
            _loc2_.playerState = new PlayerState(_loc4_.readInt());
            _loc2_.Grade = _loc4_.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_loc2_.ID))
            {
               _loc2_.Hide = _loc4_.readInt();
            }
            else
            {
               _loc4_.readInt();
               _loc2_.Hide = _loc3_.Hide;
            }
            _loc2_.ConsortiaName = _loc4_.readUTF();
            _loc2_.TotalCount = _loc4_.readInt();
            _loc2_.EscapeCount = _loc4_.readInt();
            _loc2_.WinCount = _loc4_.readInt();
            _loc2_.Offer = _loc4_.readInt();
            _loc2_.Repute = _loc4_.readInt();
            _loc2_.Relation = _loc4_.readInt();
            _loc2_.LoginName = _loc4_.readUTF();
            _loc2_.Nimbus = _loc4_.readInt();
            _loc2_.FightPower = _loc4_.readInt();
            _loc2_.apprenticeshipState = _loc4_.readInt();
            _loc2_.masterID = _loc4_.readInt();
            _loc2_.setMasterOrApprentices(_loc4_.readUTF());
            _loc2_.graduatesCount = _loc4_.readInt();
            _loc2_.honourOfMaster = _loc4_.readUTF();
            _loc2_.AchievementPoint = _loc4_.readInt();
            _loc2_.honor = _loc4_.readUTF();
            _loc2_.IsMarried = _loc4_.readBoolean();
            _loc2_.commitChanges();
            if(_loc2_.Relation != 1)
            {
               this.addFriend(_loc2_);
               if(PathInfo.isUserAddFriend)
               {
                  new AddCommunityFriend(_loc2_.LoginName,_loc2_.NickName);
               }
            }
            else
            {
               this.addBlackList(_loc2_);
            }
            dispatchEvent(new IMEvent(IMEvent.ADDNEW_FRIEND,_loc2_));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.playerManager.addFriend.isRefused"));
         }
      }
      
      public function addFriend(param1:PlayerInfo) : void
      {
         if(!this.blackList && !this.friendList)
         {
            return;
         }
         this.blackList.remove(param1.ID);
         this.friendList.add(param1.ID,param1);
      }
      
      public function addBlackList(param1:FriendListPlayer) : void
      {
         if(!this.blackList && !this.friendList)
         {
            return;
         }
         this.friendList.remove(param1.ID);
         this.blackList.add(param1.ID,param1);
      }
      
      public function removeFriend(param1:int) : void
      {
         if(!this.blackList && !this.friendList)
         {
            return;
         }
         this.friendList.remove(param1);
         this.blackList.remove(param1);
      }
      
      private function __friendRemove(param1:CrazyTankSocketEvent) : void
      {
         this.removeFriend(param1.pkg.clientId);
      }
      
      private function __playerState(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:PackageIn = param1.pkg;
         if(_loc7_.clientId != this._self.ID)
         {
            _loc2_ = _loc7_.clientId;
            _loc3_ = _loc7_.readInt();
            _loc4_ = _loc7_.readByte();
            _loc5_ = _loc7_.readInt();
            _loc6_ = _loc7_.readBoolean();
            this.playerStateChange(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_);
            if(_loc2_ == this.Self.SpouseID)
            {
               this.spouseStateChange(_loc3_);
            }
            ConsortionModelControl.Instance.model.consortiaPlayerStateChange(_loc2_,_loc3_);
         }
      }
      
      private function spouseStateChange(param1:int) : void
      {
         var _loc2_:String = null;
         if(param1 == PlayerState.ONLINE)
         {
            _loc2_ = this.Self.Sex ? LanguageMgr.GetTranslation("ddt.manager.playerManager.wifeOnline",this.Self.SpouseName) : LanguageMgr.GetTranslation("ddt.manager.playerManager.hushandOnline",this.Self.SpouseName);
            ChatManager.Instance.sysChatYellow(_loc2_);
         }
      }
      
      private function masterStateChange(param1:int, param2:int) : void
      {
         var _loc3_:String = null;
         if(param1 == PlayerState.ONLINE && param2 != this.Self.SpouseID)
         {
            if(param2 == this.Self.masterID)
            {
               _loc3_ = LanguageMgr.GetTranslation("ddt.manager.playerManager.masterState",this.Self.getMasterOrApprentices()[param2]);
            }
            else
            {
               if(!Boolean(this.Self.getMasterOrApprentices()[param2]))
               {
                  return;
               }
               _loc3_ = LanguageMgr.GetTranslation("ddt.manager.playerManager.ApprenticeState",this.Self.getMasterOrApprentices()[param2]);
            }
            ChatManager.Instance.sysChatYellow(_loc3_);
         }
      }
      
      public function playerStateChange(param1:int, param2:int, param3:int, param4:int, param5:Boolean) : void
      {
         var _loc6_:String = null;
         var _loc7_:PlayerInfo = null;
         var _loc8_:PlayerInfo = this.friendList[param1];
         if(Boolean(_loc8_))
         {
            if(_loc8_.playerState.StateID != param2 || _loc8_.typeVIP != param3 || _loc8_.isSameCity != param5)
            {
               _loc8_.typeVIP = param3;
               _loc8_.VIPLevel = param4;
               _loc8_.isSameCity = param5;
               _loc6_ = "";
               if(_loc8_.playerState.StateID != param2)
               {
                  _loc8_.playerState = new PlayerState(param2);
                  this.friendList.add(param1,_loc8_);
                  if(param1 == this.Self.SpouseID)
                  {
                     return;
                  }
                  if(param1 == this.Self.masterID || Boolean(this.Self.getMasterOrApprentices()[param1]))
                  {
                     this.masterStateChange(param2,param1);
                     return;
                  }
                  if(param2 == PlayerState.ONLINE && SharedManager.Instance.showOL)
                  {
                     _loc6_ = LanguageMgr.GetTranslation("tank.view.chat.ChatInputView.friend") + "[" + _loc8_.NickName + "]" + LanguageMgr.GetTranslation("tank.manager.PlayerManger.friendOnline");
                     ChatManager.Instance.sysChatYellow(_loc6_);
                     return;
                  }
                  return;
               }
            }
            this.friendList.add(param1,_loc8_);
         }
         else if(Boolean(this.myAcademyPlayers))
         {
            _loc7_ = this.myAcademyPlayers[param1];
            if(Boolean(_loc7_))
            {
               if(_loc7_.playerState.StateID != param2 || _loc7_.IsVIP != param3)
               {
                  _loc7_.typeVIP = param3;
                  _loc7_.VIPLevel = param4;
                  _loc7_.playerState = new PlayerState(param2);
                  this.myAcademyPlayers.add(param1,_loc7_);
               }
            }
         }
      }
      
      private function initEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GRID_GOODS,this.__updateInventorySlot);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_EQUIP,this.__itemEquip);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ONS_EQUIP,this.__onsItemEquip);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BAG_LOCKED,this.__bagLockedHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PRIVATE_INFO,this.__updatePrivateInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PLAYER_INFO,this.__updatePlayerInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TEMP_STYLE,this.__readTempStyle);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DAILY_AWARD,this.__dailyAwardHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHECK_CODE,this.__checkCodePopup);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_OBTAIN,this.__buffObtain);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_UPDATE,this.__buffUpdate);
         this.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__selfPopChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FRIEND_ADD,this.__friendAdd);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FRIEND_REMOVE,this.__friendRemove);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FRIEND_STATE,this.__playerState);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.VIP_IS_OPENED,this.__upVipInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USER_GET_GIFTS,this.__getGifts);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USER_UPDATE_GIFT,this.__addGiftItem);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USER_RELOAD_GIFT,this.__canReLoadGift);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CARDS_DATA,this.__getCards);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USER_ANSWER,this.__updateUerGuild);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHAT_FILTERING_FRIENDS_SHARE,this.__chatFilteringFriendsShare);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SAME_CITY_FRIEND,this.__sameCity);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ROOMLIST_PASS,this.__roomListPass);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PET,this.__updatePet);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.NECKLACE_STRENGTH,this.__necklaceStrengthInfoUpadte);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PLAYER_PROPERTY,this.__updatePlayerProperty);
         SocketManager.Instance.addEventListener(PkgEvent.format(321),this.__onGetPlayerRspecial);
      }
      
      private function __onGetPlayerRspecial(param1:PkgEvent) : void
      {
         var _loc11_:int = 0;
         var _loc12_:PackageIn = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if((_loc11_ = (_loc12_ = param1.pkg).readInt()) == 1)
         {
            _loc4_ = param1.pkg.readInt();
            _loc5_ = param1.pkg.readInt();
            this._self.uploadNum = _loc5_;
            this._self.ticketNum = _loc4_;
         }
         else if(_loc11_ == 2)
         {
            _loc2_ = _loc12_.readInt();
            _loc6_ = new DictionaryData();
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc7_ = _loc12_.readInt();
               _loc8_ = _loc12_.readInt();
               _loc6_.add(_loc7_,_loc8_);
               _loc3_++;
            }
            this._self.ringUseNum = _loc6_;
         }
         else if(_loc11_ == 3)
         {
            _loc2_ = _loc12_.readInt();
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc9_ = _loc12_.readInt();
               _loc10_ = _loc12_.readInt();
               this._self.setDungeonCount(_loc9_,_loc10_);
               _loc3_++;
            }
         }
      }
      
      protected function __necklaceStrengthInfoUpadte(param1:CrazyTankSocketEvent) : void
      {
         this.Self.necklaceExp = param1.pkg.readInt();
         this.Self.necklaceExpAdd = param1.pkg.readInt();
      }
      
      private function __updatePet(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:PetInfo = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Boolean = false;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:PetSkill = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:PetEquipData = null;
         var _loc19_:InventoryItemInfo = null;
         var _loc20_:InventoryItemInfo = null;
         var _loc21_:PackageIn = param1.pkg;
         var _loc22_:int = _loc21_.readInt();
         var _loc23_:int = _loc21_.readInt();
         var _loc24_:PlayerInfo = this.findPlayer(_loc22_,_loc23_);
         _loc24_.ID = _loc22_;
         var _loc25_:int = _loc21_.readInt();
         var _loc26_:int = 0;
         while(_loc26_ < _loc25_)
         {
            _loc2_ = _loc21_.readInt();
            _loc3_ = _loc21_.readBoolean();
            if(_loc3_)
            {
               _loc4_ = _loc21_.readInt();
               _loc5_ = _loc21_.readInt();
               _loc6_ = new PetInfo();
               _loc6_.TemplateID = _loc5_;
               _loc6_.ID = _loc4_;
               PetInfoManager.fillPetInfo(_loc6_);
               _loc6_.Name = _loc21_.readUTF();
               _loc6_.UserID = _loc21_.readInt();
               _loc6_.Attack = _loc21_.readInt();
               _loc6_.Defence = _loc21_.readInt();
               _loc6_.Luck = _loc21_.readInt();
               _loc6_.Agility = _loc21_.readInt();
               _loc6_.Blood = _loc21_.readInt();
               _loc6_.Damage = _loc21_.readInt();
               _loc6_.Guard = _loc21_.readInt();
               _loc6_.AttackGrow = _loc21_.readInt();
               _loc6_.DefenceGrow = _loc21_.readInt();
               _loc6_.LuckGrow = _loc21_.readInt();
               _loc6_.AgilityGrow = _loc21_.readInt();
               _loc6_.BloodGrow = _loc21_.readInt();
               _loc6_.DamageGrow = _loc21_.readInt();
               _loc6_.GuardGrow = _loc21_.readInt();
               _loc6_.Level = _loc21_.readInt();
               _loc6_.GP = _loc21_.readInt();
               _loc6_.MaxGP = _loc21_.readInt();
               _loc6_.Hunger = _loc21_.readInt();
               _loc6_.PetHappyStar = _loc21_.readInt();
               _loc6_.MP = _loc21_.readInt();
               _loc6_.clearSkills();
               _loc6_.clearEquipedSkills();
               _loc7_ = _loc21_.readInt();
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  _loc14_ = _loc21_.readInt();
                  _loc15_ = new PetSkill(_loc14_);
                  _loc6_.addSkill(_loc15_);
                  _loc21_.readInt();
                  _loc8_++;
               }
               _loc9_ = _loc21_.readInt();
               _loc10_ = 0;
               while(_loc10_ < _loc9_)
               {
                  _loc16_ = _loc21_.readInt();
                  _loc17_ = _loc21_.readInt();
                  _loc6_.equipdSkills.add(_loc16_,_loc17_);
                  _loc10_++;
               }
               _loc11_ = _loc21_.readBoolean();
               _loc6_.IsEquip = _loc11_;
               _loc6_.Place = _loc2_;
               _loc24_.pets.add(_loc6_.Place,_loc6_);
               _loc12_ = _loc21_.readInt();
               _loc13_ = 0;
               while(_loc13_ < _loc12_)
               {
                  _loc18_ = new PetEquipData();
                  _loc18_.eqType = _loc21_.readInt();
                  _loc18_.eqTemplateID = _loc21_.readInt();
                  _loc18_.startTime = _loc21_.readDateString();
                  _loc18_.ValidDate = _loc21_.readInt();
                  _loc19_ = new InventoryItemInfo();
                  _loc19_.TemplateID = _loc18_.eqTemplateID;
                  _loc19_.ValidDate = _loc18_.ValidDate;
                  _loc19_.BeginDate = _loc18_.startTime;
                  _loc19_.IsBinds = true;
                  _loc19_.IsUsed = true;
                  _loc19_.Place = _loc18_.eqType;
                  _loc20_ = ItemManager.fill(_loc19_) as InventoryItemInfo;
                  _loc6_.equipList.add(_loc20_.Place,_loc20_);
                  if(Boolean(PetBagController.instance().view) && Boolean(PetBagController.instance().view.parent))
                  {
                     PetBagController.instance().view.addPetEquip(_loc20_);
                  }
                  _loc13_++;
               }
               _loc6_.currentStarExp = _loc21_.readInt();
            }
            else
            {
               _loc24_.pets.remove(_loc2_);
            }
            _loc24_.commitChanges();
            _loc26_++;
         }
         dispatchEvent(new CEvent("updatePet"));
      }
      
      protected function __updatePlayerProperty(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:PlayerInfo = null;
         var _loc4_:PackageIn = param1.pkg;
         var _loc5_:Array = ["Attack","Defence","Agility","Luck"];
         var _loc6_:DictionaryData = new DictionaryData();
         var _loc7_:DictionaryData = null;
         var _loc8_:int = -1;
         _loc8_ = _loc4_.readInt();
         for each(_loc2_ in _loc5_)
         {
            _loc7_ = _loc6_[_loc2_] = new DictionaryData();
            _loc4_.readInt();
            _loc7_["Texp"] = _loc4_.readInt();
            _loc7_["Card"] = _loc4_.readInt();
            _loc7_["Pet"] = _loc4_.readInt();
            _loc7_["Suit"] = _loc4_.readInt();
            _loc7_["Avatar"] = _loc4_.readInt();
         }
         _loc7_ = _loc6_["HP"] = new DictionaryData();
         _loc4_.readInt();
         _loc7_["Texp"] = _loc4_.readInt();
         _loc7_["Pet"] = _loc4_.readInt();
         _loc7_["Suit"] = _loc4_.readInt();
         _loc7_["Avatar"] = _loc4_.readInt();
         _loc7_ = _loc6_["Damage"] = new DictionaryData();
         _loc7_["Suit"] = _loc4_.readInt();
         _loc7_ = _loc6_["Guard"] = new DictionaryData();
         _loc7_["Suit"] = _loc4_.readInt();
         _loc6_["Damage"]["Bead"] = _loc4_.readInt();
         _loc6_["Armor"] = new DictionaryData();
         _loc6_["Armor"]["Bead"] = _loc4_.readInt();
         _loc6_["Damage"]["Avatar"] = _loc4_.readInt();
         _loc6_["Armor"]["Avatar"] = _loc4_.readInt();
         SyahManager.Instance.totalDamage = _loc4_.readInt();
         SyahManager.Instance.totalArmor = _loc4_.readInt();
         _loc3_ = this.findPlayer(_loc8_);
         _loc3_.propertyAddition = _loc6_;
         _loc3_.commitChanges();
         dispatchEvent(new Event(UPDATE_PLAYER_PROPERTY));
      }
      
      public function get propertyAdditions() : DictionaryData
      {
         return this._propertyAdditions;
      }
      
      private function __roomListPass(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:PassInputFrame = ComponentFactory.Instance.creat("roomList.RoomList.passInputFrame");
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         _loc3_.ID = _loc2_;
      }
      
      private function __sameCity(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = param1.pkg.readInt();
         while(_loc2_ < _loc4_)
         {
            _loc3_ = param1.pkg.readInt();
            this.findPlayer(_loc3_,this.Self.ZoneID).isSameCity = true;
            if(!this._sameCityList)
            {
               this._sameCityList = new Array();
            }
            this._sameCityList.push(_loc3_);
            _loc2_++;
         }
         this.initSameCity();
      }
      
      private function initSameCity() : void
      {
         if(!this._sameCityList)
         {
            this._sameCityList = new Array();
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._sameCityList.length)
         {
            this.findPlayer(this._sameCityList[_loc1_]).isSameCity = true;
            _loc1_++;
         }
         this._friendList[this._self.ZoneID].dispatchEvent(new DictionaryEvent(DictionaryEvent.UPDATE));
      }
      
      private function __chatFilteringFriendsShare(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:CMFriendInfo = null;
         if(!this._cmFriendList)
         {
            return;
         }
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:int = _loc3_.readInt();
         var _loc5_:String = _loc3_.readUTF();
         var _loc6_:Boolean = false;
         for each(_loc2_ in this._cmFriendList)
         {
            if(_loc2_.UserId == _loc4_)
            {
               _loc6_ = true;
            }
         }
         if(_loc6_)
         {
            ChatManager.Instance.sysChatYellow(_loc5_);
         }
      }
      
      private function __updateUerGuild(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_.writeByte(param1.pkg.readByte());
            _loc4_++;
         }
         this._self.weaklessGuildProgress = _loc2_;
      }
      
      private function __getCards(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:CardInfo = null;
         var _loc5_:PackageIn = param1.pkg;
         var _loc6_:int = _loc5_.readInt();
         var _loc7_:int = _loc5_.readInt();
         var _loc8_:PlayerInfo = this.findPlayer(_loc6_);
         _loc8_.beginChanges();
         var _loc9_:int = 0;
         while(_loc9_ < _loc7_)
         {
            _loc2_ = _loc5_.readInt();
            _loc3_ = _loc5_.readBoolean();
            if(_loc3_)
            {
               _loc4_ = new CardInfo();
               _loc4_.CardID = _loc5_.readInt();
               _loc4_.UserID = _loc5_.readInt();
               _loc4_.Count = _loc5_.readInt();
               _loc4_.Place = _loc5_.readInt();
               _loc4_.TemplateID = _loc5_.readInt();
               _loc4_.Attack = _loc5_.readInt();
               _loc4_.Defence = _loc5_.readInt();
               _loc4_.Agility = _loc5_.readInt();
               _loc4_.Luck = _loc5_.readInt();
               _loc4_.Damage = _loc5_.readInt();
               _loc4_.Guard = _loc5_.readInt();
               _loc4_.Level = _loc5_.readInt();
               _loc4_.CardGP = _loc5_.readInt();
               _loc4_.isFirstGet = _loc5_.readBoolean();
               if(_loc4_.Place <= CardInfo.MAX_EQUIP_CARDS)
               {
                  _loc8_.cardEquipDic.add(_loc4_.Place,_loc4_);
               }
               else
               {
                  _loc8_.cardBagDic.add(_loc4_.Place,_loc4_);
               }
            }
            else if(_loc2_ <= CardInfo.MAX_EQUIP_CARDS)
            {
               _loc8_.cardEquipDic.remove(_loc2_);
            }
            else
            {
               _loc8_.cardBagDic.remove(_loc2_);
            }
            _loc9_++;
         }
         _loc8_.commitChanges();
      }
      
      private function __canReLoadGift(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = param1.pkg.readBoolean();
         if(_loc2_)
         {
            SocketManager.Instance.out.sendPlayerGift(this._self.ID);
         }
      }
      
      private function __addGiftItem(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:int = _loc3_.readInt();
         var _loc5_:int = _loc3_.readInt();
         var _loc6_:int = int(this._self.myGiftData.length);
         if(_loc6_ != 0)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc6_)
            {
               if(this._self.myGiftData[_loc2_].TemplateID == _loc4_)
               {
                  this._self.myGiftData[_loc2_].amount = _loc5_;
                  dispatchEvent(new DictionaryEvent(DictionaryEvent.UPDATE,this._self.myGiftData[_loc2_]));
                  break;
               }
               if(_loc2_ == _loc6_ - 1)
               {
                  this.addItem(_loc4_,_loc5_);
               }
               _loc2_++;
            }
         }
         else
         {
            this.addItem(_loc4_,_loc5_);
         }
         GiftController.Instance.loadRecord(GiftController.RECEIVEDPATH,this._self.ID);
      }
      
      private function addItem(param1:int, param2:int) : void
      {
         var _loc3_:MyGiftCellInfo = new MyGiftCellInfo();
         _loc3_.TemplateID = param1;
         _loc3_.amount = param2;
         this._self.myGiftData.push(_loc3_);
         dispatchEvent(new DictionaryEvent(DictionaryEvent.ADD,this._self.myGiftData[this._self.myGiftData.length - 1]));
      }
      
      private function __getGifts(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Vector.<MyGiftCellInfo> = null;
         var _loc3_:int = 0;
         var _loc4_:MyGiftCellInfo = null;
         var _loc5_:Vector.<MyGiftCellInfo> = null;
         var _loc6_:int = 0;
         var _loc7_:MyGiftCellInfo = null;
         var _loc8_:int = 0;
         var _loc9_:PackageIn = param1.pkg;
         var _loc10_:int = _loc9_.readInt();
         var _loc11_:PlayerInfo = this.findPlayer(_loc10_);
         if(_loc10_ == this._self.ID)
         {
            this._self.charmGP = _loc9_.readInt();
            _loc8_ = _loc9_.readInt();
            _loc2_ = new Vector.<MyGiftCellInfo>();
            _loc3_ = 0;
            while(_loc3_ < _loc8_)
            {
               _loc4_ = new MyGiftCellInfo();
               _loc4_.TemplateID = _loc9_.readInt();
               _loc4_.amount = _loc9_.readInt();
               _loc2_.push(_loc4_);
               _loc3_++;
            }
            this._self.myGiftData = _loc2_;
            dispatchEvent(new Event(SELF_GIFT_INFO_CHANGE));
         }
         else
         {
            _loc11_.beginChanges();
            _loc11_.charmGP = _loc9_.readInt();
            _loc8_ = _loc9_.readInt();
            _loc5_ = new Vector.<MyGiftCellInfo>();
            _loc6_ = 0;
            while(_loc6_ < _loc8_)
            {
               _loc7_ = new MyGiftCellInfo();
               _loc7_.TemplateID = _loc9_.readInt();
               _loc7_.amount = _loc9_.readInt();
               _loc5_.push(_loc7_);
               _loc6_++;
            }
            _loc11_.myGiftData = _loc5_;
            _loc11_.commitChanges();
            dispatchEvent(new Event(GIFT_INFO_CHANGE));
         }
      }
      
      private function __upVipInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._self.typeVIP = _loc2_.readByte();
         this._self.VIPLevel = _loc2_.readInt();
         this._self.VIPExp = _loc2_.readInt();
         this._self.VIPExpireDay = _loc2_.readDate();
         this._self.LastDate = _loc2_.readDate();
         this._self.VIPNextLevelDaysNeeded = _loc2_.readInt();
         this._self.canTakeVipReward = _loc2_.readBoolean();
         dispatchEvent(new Event(VIP_STATE_CHANGE));
      }
      
      public function setupFriendList(param1:FriendListAnalyzer) : void
      {
         this.customList = param1.customList;
         this.friendList = param1.friendlist;
         this.blackList = param1.blackList;
         this.initSameCity();
      }
      
      public function checkHasGroupName(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.customList.length)
         {
            if(this.customList[_loc2_].Name == param1)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.addFirend.repet"),0,true);
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function setupMyacademyPlayers(param1:MyAcademyPlayersAnalyze) : void
      {
         this._myAcademyPlayers = param1.myAcademyPlayers;
      }
      
      private function romoveAcademyPlayers() : void
      {
         var _loc1_:FriendListPlayer = null;
         for each(_loc1_ in this._myAcademyPlayers)
         {
            this.friendList.remove(_loc1_.ID);
         }
      }
      
      public function setupRecentContacts(param1:RecentContactsAnalyze) : void
      {
         this.recentContacts = param1.recentContacts;
      }
      
      public function set friendList(param1:DictionaryData) : void
      {
         this._friendList[this._self.ZoneID] = param1;
         IMController.Instance.isLoadComplete = true;
         dispatchEvent(new Event(FRIENDLIST_COMPLETE));
      }
      
      public function get friendList() : DictionaryData
      {
         if(this._friendList[this._self.ZoneID] == null)
         {
            this._friendList[PlayerManager.Instance.Self.ZoneID] = new DictionaryData();
         }
         return this._friendList[this._self.ZoneID];
      }
      
      public function getFriendForCustom(param1:int) : DictionaryData
      {
         var _loc2_:FriendListPlayer = null;
         var _loc3_:DictionaryData = new DictionaryData();
         if(this._friendList[this._self.ZoneID] == null)
         {
            this._friendList[PlayerManager.Instance.Self.ZoneID] = new DictionaryData();
         }
         for each(_loc2_ in this._friendList[this._self.ZoneID])
         {
            if(_loc2_.Relation == param1)
            {
               _loc3_.add(_loc2_.ID,_loc2_);
            }
         }
         return _loc3_;
      }
      
      public function deleteCustomGroup(param1:int) : void
      {
         var _loc2_:FriendListPlayer = null;
         for each(_loc2_ in this._friendList[this._self.ZoneID])
         {
            if(_loc2_.Relation == param1)
            {
               _loc2_.Relation = 0;
            }
         }
      }
      
      public function get myAcademyPlayers() : DictionaryData
      {
         return this._myAcademyPlayers;
      }
      
      public function get recentContacts() : DictionaryData
      {
         if(!this._recentContacts)
         {
            this._recentContacts = new DictionaryData();
         }
         return this._recentContacts;
      }
      
      public function set recentContacts(param1:DictionaryData) : void
      {
         this._recentContacts = param1;
         dispatchEvent(new Event(RECENT_CONTAST_COMPLETE));
      }
      
      public function get onlineRecentContactList() : Array
      {
         var _loc1_:FriendListPlayer = null;
         var _loc2_:Array = [];
         for each(_loc1_ in this.recentContacts)
         {
            if(_loc1_.playerState.StateID != PlayerState.OFFLINE || this.findPlayer(_loc1_.ID) && this.findPlayer(_loc1_.ID).playerState.StateID != PlayerState.OFFLINE)
            {
               _loc2_.push(_loc1_);
            }
         }
         return _loc2_;
      }
      
      public function get offlineRecentContactList() : Array
      {
         var _loc1_:FriendListPlayer = null;
         var _loc2_:Array = [];
         for each(_loc1_ in this.recentContacts)
         {
            if(_loc1_.playerState.StateID == PlayerState.OFFLINE)
            {
               _loc2_.push(_loc1_);
            }
         }
         return _loc2_;
      }
      
      public function getByNameFriend(param1:String) : FriendListPlayer
      {
         var _loc2_:FriendListPlayer = null;
         for each(_loc2_ in this.recentContacts)
         {
            if(_loc2_.NickName == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function deleteRecentContact(param1:int) : void
      {
         this.recentContacts.remove(param1);
      }
      
      public function get onlineFriendList() : Array
      {
         var _loc1_:FriendListPlayer = null;
         var _loc2_:Array = [];
         for each(_loc1_ in this.friendList)
         {
            if(_loc1_.playerState.StateID != PlayerState.OFFLINE)
            {
               _loc2_.push(_loc1_);
            }
         }
         return _loc2_;
      }
      
      public function getOnlineFriendForCustom(param1:int) : Array
      {
         var _loc2_:FriendListPlayer = null;
         var _loc3_:Array = [];
         for each(_loc2_ in this.friendList)
         {
            if(_loc2_.playerState.StateID != PlayerState.OFFLINE && _loc2_.Relation == param1)
            {
               _loc3_.push(_loc2_);
            }
         }
         return _loc3_;
      }
      
      public function get offlineFriendList() : Array
      {
         var _loc1_:FriendListPlayer = null;
         var _loc2_:Array = [];
         for each(_loc1_ in this.friendList)
         {
            if(_loc1_.playerState.StateID == PlayerState.OFFLINE)
            {
               _loc2_.push(_loc1_);
            }
         }
         return _loc2_;
      }
      
      public function getOfflineFriendForCustom(param1:int) : Array
      {
         var _loc2_:FriendListPlayer = null;
         var _loc3_:Array = [];
         for each(_loc2_ in this.friendList)
         {
            if(_loc2_.playerState.StateID == PlayerState.OFFLINE && _loc2_.Relation == param1)
            {
               _loc3_.push(_loc2_);
            }
         }
         return _loc3_;
      }
      
      public function get onlineMyAcademyPlayers() : Array
      {
         var _loc1_:PlayerInfo = null;
         var _loc2_:Array = [];
         for each(_loc1_ in this._myAcademyPlayers)
         {
            if(_loc1_.playerState.StateID != PlayerState.OFFLINE)
            {
               _loc2_.push(_loc1_ as FriendListPlayer);
            }
         }
         return _loc2_;
      }
      
      public function get offlineMyAcademyPlayers() : Array
      {
         var _loc1_:PlayerInfo = null;
         var _loc2_:Array = [];
         for each(_loc1_ in this._myAcademyPlayers)
         {
            if(_loc1_.playerState.StateID == PlayerState.OFFLINE)
            {
               _loc2_.push(_loc1_ as FriendListPlayer);
            }
         }
         return _loc2_;
      }
      
      public function set blackList(param1:DictionaryData) : void
      {
         this._blackList[this._self.ZoneID] = param1;
      }
      
      public function get blackList() : DictionaryData
      {
         if(this._blackList[this._self.ZoneID] == null)
         {
            this._blackList[PlayerManager.Instance.Self.ZoneID] = new DictionaryData();
         }
         return this._blackList[this._self.ZoneID];
      }
      
      public function get CMFriendList() : DictionaryData
      {
         return this._cmFriendList;
      }
      
      public function set CMFriendList(param1:DictionaryData) : void
      {
         this._cmFriendList = param1;
      }
      
      public function get PlayCMFriendList() : Array
      {
         if(Boolean(this._cmFriendList))
         {
            return this._cmFriendList.filter("IsExist",true);
         }
         return [];
      }
      
      public function get UnPlayCMFriendList() : Array
      {
         if(Boolean(this._cmFriendList))
         {
            return this._cmFriendList.filter("IsExist",false);
         }
         return [];
      }
      
      private function __updatePrivateInfo(param1:CrazyTankSocketEvent) : void
      {
         this._self.beginChanges();
         this._self.Money = param1.pkg.readInt();
         this._self.medal = param1.pkg.readInt();
         this._self.Score = param1.pkg.readInt();
         this._self.Gold = param1.pkg.readInt();
         this._self.Gift = param1.pkg.readInt();
         this._self.badLuckNumber = param1.pkg.readInt();
         if(ServerConfigManager.instance.petScoreEnable)
         {
            this._self.petScore = param1.pkg.readInt();
         }
         this._self.hardCurrency = param1.pkg.readInt();
         this._self.damageScores = param1.pkg.readInt();
         this._self.myHonor = param1.pkg.readInt();
         this._self.jampsCurrency = param1.pkg.readInt();
         this._self.commitChanges();
      }
      
      public function get hasTempStyle() : Boolean
      {
         return this.tempStyle.length > 0;
      }
      
      public function isChangeStyleTemp(param1:int) : Boolean
      {
         return this.changedStyle.hasOwnProperty(param1) && this.changedStyle[param1] != null;
      }
      
      public function setStyleTemply(param1:Object) : void
      {
         var _loc2_:PlayerInfo = this.findPlayer(param1.ID);
         if(Boolean(_loc2_))
         {
            this.storeTempStyle(_loc2_);
            _loc2_.beginChanges();
            _loc2_.Sex = param1.Sex;
            _loc2_.Hide = param1.Hide;
            _loc2_.Style = param1.Style;
            _loc2_.Colors = param1.Colors;
            _loc2_.Skin = param1.Skin;
            _loc2_.commitChanges();
         }
      }
      
      private function storeTempStyle(param1:PlayerInfo) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.Style = param1.getPrivateStyle();
         _loc2_.Hide = param1.Hide;
         _loc2_.Sex = param1.Sex;
         _loc2_.Skin = param1.Skin;
         _loc2_.Colors = param1.Colors;
         _loc2_.ID = param1.ID;
         this.tempStyle.push(_loc2_);
      }
      
      public function readAllTempStyleEvent() : void
      {
         var _loc1_:PlayerInfo = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.tempStyle.length)
         {
            _loc1_ = this.findPlayer(this.tempStyle[_loc2_].ID);
            if(Boolean(_loc1_))
            {
               _loc1_.beginChanges();
               _loc1_.Sex = this.tempStyle[_loc2_].Sex;
               _loc1_.Hide = this.tempStyle[_loc2_].Hide;
               _loc1_.Style = this.tempStyle[_loc2_].Style;
               _loc1_.Colors = this.tempStyle[_loc2_].Colors;
               _loc1_.Skin = this.tempStyle[_loc2_].Skin;
               _loc1_.commitChanges();
            }
            _loc2_++;
         }
         this.tempStyle = [];
         this.changedStyle.clear();
      }
      
      private function __readTempStyle(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:int = _loc3_.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = new Object();
            _loc2_.Style = _loc3_.readUTF();
            _loc2_.Hide = _loc3_.readInt();
            _loc2_.Sex = _loc3_.readBoolean();
            _loc2_.Skin = _loc3_.readUTF();
            _loc2_.Colors = _loc3_.readUTF();
            _loc2_.ID = _loc3_.readInt();
            this.setStyleTemply(_loc2_);
            this.changedStyle.add(_loc2_.ID,_loc2_);
            _loc5_++;
         }
      }
      
      private function __updatePlayerInfo(param1:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         var style:String = null;
         var arm:String = null;
         var offHand:String = null;
         var unknown1:int = 0;
         var unknown2:int = 0;
         var unknown3:int = 0;
         var len:int = 0;
         var n:int = 0;
         var gradeId:int = 0;
         var mapId:int = 0;
         var flag:int = 0;
         var evt:CrazyTankSocketEvent = param1;
         var info:PlayerInfo = this.findPlayer(evt.pkg.clientId);
         if(Boolean(info))
         {
            info.beginChanges();
            try
            {
               pkg = evt.pkg;
               info.GP = pkg.readInt();
               info.Offer = pkg.readInt();
               info.RichesOffer = pkg.readInt();
               info.RichesRob = pkg.readInt();
               info.WinCount = pkg.readInt();
               info.TotalCount = pkg.readInt();
               info.EscapeCount = pkg.readInt();
               info.Attack = pkg.readInt();
               info.Defence = pkg.readInt();
               info.Agility = pkg.readInt();
               info.Luck = pkg.readInt();
               info.hp = pkg.readInt();
               if(!this.isChangeStyleTemp(info.ID))
               {
                  info.Hide = pkg.readInt();
               }
               else
               {
                  pkg.readInt();
               }
               style = pkg.readUTF();
               if(!this.isChangeStyleTemp(info.ID))
               {
                  info.Style = style;
               }
               arm = String(style.split(",")[6].split("|")[0]);
               offHand = String(style.split(",")[10].split("|")[0]);
               if(arm == "-1" || arm == "0")
               {
                  info.WeaponID = -1;
               }
               else
               {
                  info.WeaponID = int(arm);
               }
               if(offHand == "0" || offHand == "")
               {
                  info.DeputyWeaponID = -1;
               }
               else
               {
                  info.DeputyWeaponID = int(offHand);
               }
               if(!this.isChangeStyleTemp(info.ID))
               {
                  info.Colors = pkg.readUTF();
                  info.Skin = pkg.readUTF();
               }
               else
               {
                  pkg.readUTF();
                  pkg.readUTF();
               }
               info.IsShowConsortia = pkg.readBoolean();
               info.ConsortiaID = pkg.readInt();
               info.ConsortiaName = pkg.readUTF();
               info.badgeID = pkg.readInt();
               unknown1 = pkg.readInt();
               unknown2 = pkg.readInt();
               info.Nimbus = pkg.readInt();
               info.PvePermission = pkg.readUTF();
               info.fightLibMission = pkg.readUTF();
               info.FightPower = pkg.readInt();
               info.apprenticeshipState = pkg.readInt();
               info.masterID = pkg.readInt();
               info.setMasterOrApprentices(pkg.readUTF());
               info.graduatesCount = pkg.readInt();
               info.honourOfMaster = pkg.readUTF();
               info.AchievementPoint = pkg.readInt();
               info.honor = pkg.readUTF();
               info.LastSpaDate = pkg.readDate();
               info.charmGP = pkg.readInt();
               unknown3 = pkg.readInt();
               info.shopFinallyGottenTime = pkg.readDate();
               info.UseOffer = pkg.readInt();
               info.matchInfo.dailyScore = pkg.readInt();
               info.matchInfo.dailyWinCount = pkg.readInt();
               info.matchInfo.dailyGameCount = pkg.readInt();
               info.matchInfo.weeklyScore = pkg.readInt();
               info.matchInfo.weeklyGameCount = pkg.readInt();
               info.spdTexpExp = pkg.readInt();
               info.attTexpExp = pkg.readInt();
               info.defTexpExp = pkg.readInt();
               info.hpTexpExp = pkg.readInt();
               info.lukTexpExp = pkg.readInt();
               info.texpTaskCount = pkg.readInt();
               info.texpCount = pkg.readInt();
               info.texpTaskDate = pkg.readDate();
               len = pkg.readInt();
               n = 0;
               while(n < len)
               {
                  mapId = pkg.readInt();
                  flag = pkg.readByte();
                  info.dungeonFlag[mapId] = flag;
                  n++;
               }
               gradeId = pkg.readInt();
               info.evolutionGrade = gradeId;
               info.evolutionExp = pkg.readInt();
               return;
            }
            finally
            {
               info.commitChanges();
            }
         }
      }
      
      public function getDeputyWeaponIcon(param1:InventoryItemInfo, param2:int = 0) : DisplayObject
      {
         var _loc3_:BagCell = null;
         if(Boolean(param1))
         {
            _loc3_ = new BagCell(param1.Place,param1);
            if(param2 == 0)
            {
               return _loc3_.getContent();
            }
            if(param2 == 1)
            {
               return _loc3_.getSmallContent();
            }
         }
         return null;
      }
      
      private function __dailyAwardHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = param1.pkg.readBoolean();
         var _loc3_:int = param1.pkg.readInt();
         if(_loc3_ == 0)
         {
            CalendarManager.getInstance().setDailyAwardState(_loc2_);
         }
         else if(_loc3_ != 1)
         {
            if(_loc3_ == 2)
            {
            }
         }
      }
      
      public function get checkEnterDungeon() : Boolean
      {
         if(Instance.Self.Grade < GameManager.MinLevelDuplicate)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.gradeLow",GameManager.MinLevelDuplicate));
            return false;
         }
         return true;
      }
      
      public function __checkCodePopup(param1:CrazyTankSocketEvent) : void
      {
         var checkCodeData:CheckCodeData = null;
         var bitmapReader:BitmapReader = null;
         checkCodeData = null;
         bitmapReader = null;
         checkCodeData = null;
         bitmapReader = null;
         var readComplete:Function = null;
         var type:int = 0;
         var msg:String = null;
         checkCodeData = null;
         var ba:ByteArray = null;
         bitmapReader = null;
         var e:CrazyTankSocketEvent = param1;
         readComplete = function(param1:Event):void
         {
            checkCodeData.pic = bitmapReader.bitmap;
            CheckCodeFrame.Instance.data = checkCodeData;
         };
         var checkCodeState:int = e.pkg.readByte();
         var backType:Boolean = e.pkg.readBoolean();
         if(checkCodeState == 1)
         {
            SoundManager.instance.play("058");
         }
         else if(checkCodeState == 2)
         {
            SoundManager.instance.play("057");
         }
         if(backType)
         {
            type = e.pkg.readByte();
            if(type == 1)
            {
               CheckCodeFrame.Instance.time = 51;
            }
            else
            {
               CheckCodeFrame.Instance.time = 60;
            }
            msg = e.pkg.readUTF();
            CheckCodeFrame.Instance.tip = msg;
            checkCodeData = new CheckCodeData();
            ba = new ByteArray();
            e.pkg.readBytes(ba,0,e.pkg.bytesAvailable);
            bitmapReader = new BitmapReader();
            bitmapReader.addEventListener(Event.COMPLETE,readComplete);
            bitmapReader.readByteArray(ba);
            CheckCodeFrame.Instance.isShowed = false;
            CheckCodeFrame.Instance.show();
            return;
         }
         CheckCodeFrame.Instance.close();
      }
      
      private function __buffObtain(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:Date = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:BuffInfo = null;
         var _loc10_:PackageIn = param1.pkg;
         if(_loc10_.clientId != this._self.ID)
         {
            return;
         }
         this._self.clearBuff();
         var _loc11_:int = _loc10_.readInt();
         var _loc12_:int = 0;
         while(_loc12_ < _loc11_)
         {
            _loc2_ = _loc10_.readInt();
            _loc3_ = _loc10_.readBoolean();
            _loc4_ = _loc10_.readDate();
            _loc5_ = _loc10_.readInt();
            _loc6_ = _loc10_.readInt();
            _loc7_ = _loc10_.readInt();
            _loc8_ = _loc10_.readInt();
            _loc9_ = new BuffInfo(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_);
            this._self.addBuff(_loc9_);
            _loc12_++;
         }
         param1.stopImmediatePropagation();
      }
      
      private function __buffUpdate(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:Date = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:BuffInfo = null;
         var _loc10_:PackageIn = param1.pkg;
         if(_loc10_.clientId != this._self.ID)
         {
            return;
         }
         var _loc11_:int = _loc10_.readInt();
         var _loc12_:uint = 0;
         while(_loc12_ < _loc11_)
         {
            _loc2_ = _loc10_.readInt();
            _loc3_ = _loc10_.readBoolean();
            _loc4_ = _loc10_.readDate();
            _loc5_ = _loc10_.readInt();
            _loc6_ = _loc10_.readInt();
            _loc7_ = _loc10_.readInt();
            _loc8_ = _loc10_.readInt();
            _loc9_ = new BuffInfo(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_);
            if(_loc3_)
            {
               this._self.addBuff(_loc9_);
            }
            else
            {
               this._self.buffInfo.remove(_loc9_.Type);
            }
            _loc12_++;
         }
         param1.stopImmediatePropagation();
      }
      
      public function findPlayerByNickName(param1:PlayerInfo, param2:String) : PlayerInfo
      {
         var _loc3_:PlayerInfo = null;
         if(Boolean(param2))
         {
            if(this._tempList[this._self.ZoneID] == null)
            {
               this._tempList[this._self.ZoneID] = new DictionaryData();
            }
            if(this._tempList[this._self.ZoneID][param2] != null)
            {
               return this._tempList[this._self.ZoneID][param2] as PlayerInfo;
            }
            for each(_loc3_ in this._tempList[this._self.ZoneID])
            {
               if(_loc3_.NickName == param2)
               {
                  return _loc3_;
               }
            }
            param1.NickName = param2;
            this._tempList[this._self.ZoneID][param2] = param1;
            return param1;
         }
         return param1;
      }
      
      public function findPlayer(param1:int, param2:int = -1, param3:String = "") : PlayerInfo
      {
         var _loc4_:PlayerInfo = null;
         var _loc5_:PlayerInfo = null;
         var _loc6_:PlayerInfo = null;
         if(param2 == -1 || param2 == this._self.ZoneID)
         {
            if(this._friendList[this._self.ZoneID] == null)
            {
               this._friendList[this._self.ZoneID] = new DictionaryData();
            }
            if(this._clubPlays[this._self.ZoneID] == null)
            {
               this._clubPlays[this._self.ZoneID] = new DictionaryData();
            }
            if(this._tempList[this._self.ZoneID] == null)
            {
               this._tempList[this._self.ZoneID] = new DictionaryData();
            }
            if(this._myAcademyPlayers == null)
            {
               this._myAcademyPlayers = new DictionaryData();
            }
            if(param1 == this._self.ID && (param2 == -1 || param2 == this._self.ZoneID))
            {
               return this._self;
            }
            if(Boolean(this._friendList[this._self.ZoneID][param1]))
            {
               return this._friendList[this._self.ZoneID][param1];
            }
            if(Boolean(this._clubPlays[this._self.ZoneID][param1]))
            {
               return this._clubPlays[this._self.ZoneID][param1];
            }
            if(Boolean(this._tempList[this._self.ZoneID][param3]))
            {
               return this._tempList[this._self.ZoneID][param3];
            }
            if(Boolean(this._myAcademyPlayers[param1]))
            {
               return this._myAcademyPlayers[param1];
            }
            if(Boolean(this._tempList[this._self.ZoneID][param1]))
            {
               if(Boolean(this._tempList[this._self.ZoneID][this._tempList[this._self.ZoneID][param1].NickName]))
               {
                  return this._tempList[this._self.ZoneID][this._tempList[this._self.ZoneID][param1].NickName];
               }
               return this._tempList[this._self.ZoneID][param1];
            }
            for each(_loc4_ in this._tempList[this._self.ZoneID])
            {
               if(_loc4_.ID == param1)
               {
                  this._tempList[this._self.ZoneID][param1] = _loc4_;
                  return _loc4_;
               }
            }
            _loc5_ = new PlayerInfo();
            _loc5_.ID = param1;
            _loc5_.ZoneID = this._self.ZoneID;
            this._tempList[this._self.ZoneID][param1] = _loc5_;
            return _loc5_;
         }
         if(param1 == this._self.ID && (param2 == this._self.ZoneID || this._self.ZoneID == 0))
         {
            return this._self;
         }
         if(Boolean(this._friendList[param2]) && Boolean(this._friendList[param2][param1]))
         {
            return this._friendList[param2][param1];
         }
         if(Boolean(this._clubPlays[param2]) && Boolean(this._clubPlays[param2][param1]))
         {
            return this._clubPlays[param2][param1];
         }
         if(Boolean(this._tempList[param2]) && Boolean(this._tempList[param2][param1]))
         {
            return this._tempList[param2][param1];
         }
         _loc6_ = new PlayerInfo();
         _loc6_.ID = param1;
         _loc6_.ZoneID = param2;
         if(this._tempList[param2] == null)
         {
            this._tempList[param2] = new DictionaryData();
         }
         this._tempList[param2][param1] = _loc6_;
         return _loc6_;
      }
      
      public function hasInMailTempList(param1:int) : Boolean
      {
         if(this._mailTempList[this._self.ZoneID] == null)
         {
            this._mailTempList[this._self.ZoneID] = new DictionaryData();
         }
         if(Boolean(this._mailTempList[this._self.ZoneID][param1]))
         {
            return true;
         }
         return false;
      }
      
      public function set mailTempList(param1:DictionaryData) : void
      {
         if(this._mailTempList == null)
         {
            this._mailTempList = new DictionaryData();
         }
         if(this._mailTempList[this._self.ZoneID] == null)
         {
            this._mailTempList[this._self.ZoneID] = new DictionaryData();
         }
         this._mailTempList[this._self.ZoneID] = param1;
      }
      
      public function hasInFriendList(param1:int) : Boolean
      {
         if(this._friendList[this._self.ZoneID] == null)
         {
            this._friendList[this._self.ZoneID] = new DictionaryData();
         }
         if(Boolean(this._friendList[this._self.ZoneID][param1]))
         {
            return true;
         }
         return false;
      }
      
      public function hasInClubPlays(param1:int) : Boolean
      {
         if(this._clubPlays[this._self.ZoneID] == null)
         {
            this._clubPlays[this._self.ZoneID] = new DictionaryData();
         }
         if(Boolean(this._clubPlays[this._self.ZoneID][param1]))
         {
            return true;
         }
         return false;
      }
      
      private function __selfPopChange(param1:PlayerPropertyEvent) : void
      {
         if(Boolean(param1.changedProperties["TotalCount"]))
         {
            switch(PlayerManager.Instance.Self.TotalCount)
            {
               case 1:
                  StatisticManager.Instance().startAction("gameOver1","yes");
                  break;
               case 3:
                  StatisticManager.Instance().startAction("gameOver3","yes");
                  break;
               case 5:
                  StatisticManager.Instance().startAction("gameOver5","yes");
                  break;
               case 10:
                  StatisticManager.Instance().startAction("gameOver10","yes");
            }
         }
         if(Boolean(param1.changedProperties["Grade"]))
         {
            TaskManager.requestCanAcceptTask();
         }
      }
   }
}
