package gemstone
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.EventDispatcher;
   import gemstone.info.GemstListInfo;
   import gemstone.info.GemstonInitInfo;
   import gemstone.info.GemstoneAnalyze;
   import gemstone.info.GemstoneInfo;
   import gemstone.info.GemstoneStaticInfo;
   import gemstone.info.GemstoneUpGradeInfo;
   import gemstone.items.ExpBar;
   import gemstone.items.GemstoneContent;
   import gemstone.items.Item;
   
   public class GemstoneManager extends EventDispatcher
   {
      
      private static var _instance:gemstone.GemstoneManager;
      
      public static const SuitPLACE:int = 11;
      
      public static const GlassPPLACE:int = 5;
      
      public static const HariPPLACE:int = 2;
      
      public static const FacePLACE:int = 3;
      
      public static const DecorationPLACE:int = 13;
      
      public static const ID1:int = 100001;
      
      public static const ID2:int = 100002;
      
      public static const ID3:int = 100003;
      
      public static const ID4:int = 100004;
      
      public static const ID5:int = 100005;
       
      
      private var _gemstoneFrame:gemstone.GemstoneFrame;
      
      private var _stoneInfoList:Vector.<GemstoneInfo>;
      
      private var _stoneItemList:Vector.<Item>;
      
      private var _stoneContentGroupList:Array;
      
      private var _stoneContentList:Array;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      private var _loader:BaseLoader;
      
      private var _redUrl:String;
      
      private var _bulUrl:String;
      
      private var _greUrl:String;
      
      private var _yelUrl:String;
      
      private var _purpleUrl:String;
      
      private var _upGradeList:Vector.<GemstoneUpGradeInfo>;
      
      public var redInfoList:Vector.<GemstoneStaticInfo>;
      
      public var bluInfoList:Vector.<GemstoneStaticInfo>;
      
      public var greInfoList:Vector.<GemstoneStaticInfo>;
      
      public var yelInfoList:Vector.<GemstoneStaticInfo>;
      
      public var purpleInfoList:Vector.<GemstoneStaticInfo>;
      
      public var curstatiDataList:Vector.<GemstoneStaticInfo>;
      
      public var curItem:GemstoneContent;
      
      public var curGemstoneUpInfo:GemstoneUpGradeInfo;
      
      private var _gInfoList:Object;
      
      public var suitList:Vector.<GemstListInfo>;
      
      public var glassList:Vector.<GemstListInfo>;
      
      public var hariList:Vector.<GemstListInfo>;
      
      public var faceList:Vector.<GemstListInfo>;
      
      public var decorationList:Vector.<GemstListInfo>;
      
      public var curMaxLevel:uint;
      
      public function GemstoneManager()
      {
         this.suitList = new Vector.<GemstListInfo>();
         this.glassList = new Vector.<GemstListInfo>();
         this.hariList = new Vector.<GemstListInfo>();
         this.faceList = new Vector.<GemstListInfo>();
         this.decorationList = new Vector.<GemstListInfo>();
         super();
         this._upGradeList = new Vector.<GemstoneUpGradeInfo>();
      }
      
      public static function get Instance() : gemstone.GemstoneManager
      {
         if(_instance == null)
         {
            _instance = new gemstone.GemstoneManager();
         }
         return _instance;
      }
      
      public function loaderData() : void
      {
         this._loader = LoadResourceManager.Instance.creatAndStartLoad(PathManager.solveRequestPath("FightSpiritTemplateList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.loaderComplete);
      }
      
      private function compeleteHander(param1:GemstoneAnalyze) : void
      {
      }
      
      private function loaderComplete(param1:LoaderEvent) : void
      {
         var _loc2_:GemstoneStaticInfo = null;
         this.redInfoList = new Vector.<GemstoneStaticInfo>();
         this.bluInfoList = new Vector.<GemstoneStaticInfo>();
         this.greInfoList = new Vector.<GemstoneStaticInfo>();
         this.yelInfoList = new Vector.<GemstoneStaticInfo>();
         this.purpleInfoList = new Vector.<GemstoneStaticInfo>();
         this._gInfoList = new Vector.<GemstoneStaticInfo>();
         var _loc3_:XML = new XML(param1.loader.content);
         var _loc4_:int = _loc3_.item.length();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = new GemstoneStaticInfo();
            _loc2_.id = _loc3_.item[_loc5_].@FightSpiritID;
            _loc2_.fightSpiritIcon = _loc3_.item[_loc5_].@FightSpiritIcon;
            _loc2_.attack = _loc3_.item[_loc5_].@Attack;
            _loc2_.level = _loc3_.item[_loc5_].@Level;
            _loc2_.luck = _loc3_.item[_loc5_].@Lucky;
            _loc2_.Exp = _loc3_.item[_loc5_].@Exp;
            _loc2_.agility = _loc3_.item[_loc5_].@Agility;
            _loc2_.defence = _loc3_.item[_loc5_].@Defence;
            _loc2_.blood = _loc3_.item[_loc5_].@Blood;
            this._gInfoList.push(_loc2_);
            if(_loc2_.id == ID1)
            {
               GemstoneManager.Instance.setRedUrl(_loc2_.fightSpiritIcon);
               this.redInfoList.push(_loc2_);
            }
            else if(_loc2_.id == ID2)
            {
               GemstoneManager.Instance.setBulUrl(_loc2_.fightSpiritIcon);
               this.bluInfoList.push(_loc2_);
            }
            else if(_loc2_.id == ID3)
            {
               GemstoneManager.Instance.setGreUrl(_loc2_.fightSpiritIcon);
               this.greInfoList.push(_loc2_);
            }
            else if(_loc2_.id == ID4)
            {
               GemstoneManager.Instance.setYelUrl(_loc2_.fightSpiritIcon);
               this.yelInfoList.push(_loc2_);
            }
            else if(_loc2_.id == ID5)
            {
               GemstoneManager.Instance.setPurpleUrl(_loc2_.fightSpiritIcon);
               this.purpleInfoList.push(_loc2_);
            }
            _loc5_++;
         }
         this.curMaxLevel = this.bluInfoList.length - 1;
      }
      
      public function initView() : gemstone.GemstoneFrame
      {
         this._gemstoneFrame = ComponentFactory.Instance.creatCustomObject("gemstoneFrame");
         return this._gemstoneFrame;
      }
      
      public function initFrame(param1:gemstone.GemstoneFrame) : void
      {
         this._gemstoneFrame = param1;
      }
      
      public function clearFrame() : void
      {
         this._gemstoneFrame = null;
      }
      
      public function upDataFitCount() : void
      {
         if(Boolean(this._gemstoneFrame))
         {
            this._gemstoneFrame.upDatafitCount();
         }
      }
      
      public function get gemstoneFrame() : gemstone.GemstoneFrame
      {
         return this._gemstoneFrame;
      }
      
      public function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_FIGHT_SPIRIT_UP,this.playerFigSpiritUp);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHT_SPIRIT_INIT,this.playerFigSpiritinit);
      }
      
      private function playerFigSpiritinit(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:GemstonInitInfo = null;
         var _loc3_:Array = null;
         var _loc4_:Vector.<GemstListInfo> = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:GemstListInfo = null;
         var _loc8_:Boolean = param1.pkg.readBoolean();
         var _loc9_:int = param1.pkg.readInt();
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_)
         {
            _loc2_ = new GemstonInitInfo();
            _loc2_.userId = param1.pkg.readInt();
            _loc2_.figSpiritId = param1.pkg.readInt();
            _loc2_.figSpiritIdValue = param1.pkg.readUTF();
            _loc2_.equipPlace = param1.pkg.readInt();
            _loc3_ = this.rezArr(_loc2_.figSpiritIdValue);
            _loc4_ = new Vector.<GemstListInfo>();
            _loc5_ = 0;
            while(_loc5_ < 3)
            {
               _loc6_ = _loc3_[_loc5_].split(",");
               _loc7_ = new GemstListInfo();
               _loc7_.fightSpiritId = _loc2_.figSpiritId;
               _loc7_.level = _loc6_[0];
               _loc7_.exp = _loc6_[1];
               _loc7_.place = _loc6_[2];
               _loc4_.push(_loc7_);
               _loc5_++;
            }
            _loc2_.list = _loc4_;
            switch(_loc2_.equipPlace)
            {
               case SuitPLACE:
                  this.suitList = _loc4_;
                  break;
               case GlassPPLACE:
                  this.glassList = _loc4_;
                  break;
               case HariPPLACE:
                  this.hariList = _loc4_;
                  break;
               case FacePLACE:
                  this.faceList = _loc4_;
                  break;
               case DecorationPLACE:
                  this.decorationList = _loc4_;
                  break;
            }
            _loc10_++;
         }
      }
      
      private function rezArr(param1:String) : Array
      {
         return param1.split("|");
      }
      
      protected function playerFigSpiritUp(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:GemstListInfo = null;
         var _loc4_:GemstoneUpGradeInfo = new GemstoneUpGradeInfo();
         _loc4_.isUp = param1.pkg.readBoolean();
         _loc4_.isMaxLevel = param1.pkg.readBoolean();
         _loc4_.isFall = param1.pkg.readBoolean();
         _loc4_.num = param1.pkg.readInt();
         var _loc5_:Vector.<GemstListInfo> = new Vector.<GemstListInfo>();
         var _loc6_:int = param1.pkg.readInt();
         while(_loc2_ < _loc6_)
         {
            _loc3_ = new GemstListInfo();
            _loc3_.fightSpiritId = param1.pkg.readInt();
            _loc3_.level = param1.pkg.readInt();
            _loc3_.exp = param1.pkg.readInt();
            _loc3_.place = param1.pkg.readInt();
            _loc5_.push(_loc3_);
            _loc2_++;
         }
         _loc4_.equipPlace = param1.pkg.readInt();
         _loc4_.dir = param1.pkg.readInt();
         _loc4_.list = _loc5_;
         this.setGemstoneListInfo(_loc4_);
         if(Boolean(this._gemstoneFrame))
         {
            this._gemstoneFrame.upDatafitCount();
            this._gemstoneFrame.gemstoneAction(_loc4_);
         }
      }
      
      public function loadGemstoneModule(param1:Function = null, param2:Array = null) : void
      {
         this._funcParams = param2;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,param1);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.GEMSTONE_SYS);
      }
      
      public function get expBar() : ExpBar
      {
         return this._gemstoneFrame.expBar;
      }
      
      public function getRedUrl() : String
      {
         return this._redUrl;
      }
      
      public function getYelUrl() : String
      {
         return this._yelUrl;
      }
      
      public function getPurpleUrl() : String
      {
         return this._purpleUrl;
      }
      
      public function getBulUrl() : String
      {
         return this._bulUrl;
      }
      
      public function getGreUrl() : String
      {
         return this._greUrl;
      }
      
      public function setRedUrl(param1:String) : void
      {
         this._redUrl = param1;
      }
      
      public function setYelUrl(param1:String) : void
      {
         this._yelUrl = param1;
      }
      
      public function setBulUrl(param1:String) : void
      {
         this._bulUrl = param1;
      }
      
      public function setGreUrl(param1:String) : void
      {
         this._greUrl = param1;
      }
      
      public function setPurpleUrl(param1:String) : void
      {
         this._purpleUrl = param1;
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.GEMSTONE_SYS)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      public function getSelfList(param1:int) : Vector.<GemstListInfo>
      {
         if(param1 == GemstoneManager.DecorationPLACE)
         {
            return this.decorationList;
         }
         if(param1 == GemstoneManager.FacePLACE)
         {
            return this.faceList;
         }
         if(param1 == GemstoneManager.GlassPPLACE)
         {
            return this.glassList;
         }
         if(param1 == GemstoneManager.HariPPLACE)
         {
            return this.hariList;
         }
         if(param1 == GemstoneManager.SuitPLACE)
         {
            return this.suitList;
         }
         return null;
      }
      
      public function getByPlayerInfoList(param1:int, param2:int) : Vector.<GemstListInfo>
      {
         var _loc3_:Vector.<GemstonInitInfo> = null;
         var _loc4_:PlayerInfo = PlayerManager.Instance.findPlayer(param2);
         if(_loc4_ is SelfInfo)
         {
            return this.getSelfList(param1);
         }
         _loc3_ = _loc4_.gemstoneList;
         if(Boolean(this.getPlaceByGemstonInitInfo(param1,_loc3_)))
         {
            return this.getPlaceByGemstonInitInfo(param1,_loc3_).list;
         }
         return null;
      }
      
      public function setGemstoneListInfo(param1:GemstoneUpGradeInfo) : void
      {
         if(param1.equipPlace == GemstoneManager.FacePLACE)
         {
            this.faceList = param1.list;
         }
         else if(param1.equipPlace == GemstoneManager.SuitPLACE)
         {
            this.suitList = param1.list;
         }
         else if(param1.equipPlace == GemstoneManager.GlassPPLACE)
         {
            this.glassList = param1.list;
         }
         else if(param1.equipPlace == GemstoneManager.DecorationPLACE)
         {
            this.decorationList = param1.list;
         }
         else if(param1.equipPlace == GemstoneManager.HariPPLACE)
         {
            this.hariList = param1.list;
         }
      }
      
      public function getPlaceByGemstonInitInfo(param1:int, param2:Vector.<GemstonInitInfo>) : GemstonInitInfo
      {
         if(!param2 || param2.length <= 0)
         {
            return null;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            if(param2[_loc3_].equipPlace == param1)
            {
               return param2[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
   }
}
