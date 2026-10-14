package farm
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.MD5;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import farm.analyzer.FarmFriendListAnalyzer;
   import farm.analyzer.FoodComposeListAnalyzer;
   import farm.analyzer.SuperPetFoodPriceAnalyzer;
   import farm.control.*;
   import farm.event.FarmEvent;
   import farm.modelx.FieldVO;
   import farm.modelx.SuperPetFoodPriceInfo;
   import farm.view.*;
   import farm.viewx.FarmBuyFieldView;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.net.URLVariables;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   
   public class FarmModelController extends EventDispatcher
   {
      
      private static var _instance:farm.FarmModelController;
       
      
      private var _model:farm.FarmModel;
      
      private var _timer:Timer;
      
      private var _canGoFarm:Boolean = true;
      
      private var _landInfoVector:Vector.<FieldVO>;
      
      public var gropPrice:int;
      
      public var midAutumnFlag:Boolean;
      
      public function FarmModelController()
      {
         super();
      }
      
      public static function get instance() : farm.FarmModelController
      {
         return _instance = _instance || new farm.FarmModelController();
      }
      
      public function setup() : void
      {
         this._model = new farm.FarmModel();
         this._landInfoVector = new Vector.<FieldVO>();
         this.initEvent();
         FarmComposeHouseController.instance().setup();
      }
      
      public function get model() : farm.FarmModel
      {
         return this._model;
      }
      
      public function stopTimer() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
         }
         this._canGoFarm = true;
      }
      
      public function startTimer() : void
      {
         if(this._timer == null)
         {
            this._timer = new Timer(1000);
            this._timer.addEventListener(TimerEvent.TIMER,this.__timerhandler);
         }
         this._timer.reset();
         this._timer.start();
      }
      
      public function sendEnterFarmPkg(param1:int) : void
      {
         SocketManager.Instance.out.enterFarm(param1);
         if(param1 == PlayerManager.Instance.Self.ID)
         {
            this.startTimer();
         }
      }
      
      public function arrange() : void
      {
         SocketManager.Instance.out.arrange(this._model.currentFarmerId);
      }
      
      public function goFarm(param1:int, param2:String) : void
      {
         if(PlayerManager.Instance.Self.ID == param1 && PlayerManager.Instance.Self.Grade < 25)
         {
            MessageTipManager.getInstance().show("Bạn cần đạt cấp độ 25 để vào nông trại.");
            return;
         }
         if(this._canGoFarm)
         {
            this._model.currentFarmerName = param2;
            this.sendEnterFarmPkg(param1);
            this._canGoFarm = false;
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.goFarm.internal"));
         }
      }
      
      public function sowSeed(param1:int, param2:int) : void
      {
         SocketManager.Instance.out.seeding(param1,param2);
      }
      
      public function accelerateField(param1:int, param2:int, param3:int) : void
      {
         SocketManager.Instance.out.doMature(param1,param2,param3);
      }
      
      public function getHarvest(param1:int) : void
      {
         SocketManager.Instance.out.toGather(this.model.currentFarmerId,param1);
      }
      
      public function payField(param1:Array, param2:int, param3:Boolean) : void
      {
         SocketManager.Instance.out.toSpread(param1,param2,param3);
      }
      
      public function updateFriendListStolen() : void
      {
         FarmModelController.instance.updateSetupFriendListStolen(this.model.currentFarmerId);
      }
      
      public function setupFoodComposeList(param1:FoodComposeListAnalyzer) : void
      {
         dispatchEvent(new FarmEvent(FarmEvent.FOOD_COMPOSE_LISE_READY));
      }
      
      public function killCrop(param1:int) : void
      {
         SocketManager.Instance.out.toKillCrop(param1);
      }
      
      public function farmHelperSetSwitch(param1:Array, param2:Boolean) : void
      {
         SocketManager.Instance.out.toFarmHelper(param1,param2);
      }
      
      public function helperRenewMoney(param1:int, param2:Boolean) : void
      {
         SocketManager.Instance.out.toHelperRenewMoney(param1,param2);
      }
      
      public function exitFarm(param1:int) : void
      {
         SocketManager.Instance.out.exitFarm(param1);
      }
      
      public function openPayFieldFrame(param1:int) : void
      {
         var _loc2_:FarmBuyFieldView = new FarmBuyFieldView(param1);
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FARM_LAND_INFO,this.__onFarmLandInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ENTER_FARM,this.__onEnterFarm);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAIN_FIELD,this.__gainFieldHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SEEDING,this.__onSeeding);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PAY_FIELD,this.__payField);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DO_MATURE,this.__onDoMature);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HELPER_SWITCH,this.__onHelperSwitch);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.KILL_CROP,this.__onKillCrop);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HELPER_PAY,this.__onHelperPay);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_EXIT_FARM,this.__onExitFarm);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_PET_EXP_ITEM,this.__updateBuyExpExpNum);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ARRANGE_FRIEND_FARM,this.__arrangeFriendFarmHandler);
      }
      
      private function __arrangeFriendFarmHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.arrange" + _loc2_));
         if(_loc2_ == 0)
         {
            this._model.isArrange = true;
         }
         else
         {
            this._model.isArrange = false;
         }
         dispatchEvent(new FarmEvent(FarmEvent.ARRANGE_FRIEND_FARM));
      }
      
      protected function __onFarmLandInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:FieldVO = null;
         if(this._landInfoVector.length > 0)
         {
            this._landInfoVector = new Vector.<FieldVO>();
         }
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:int = _loc3_.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = new FieldVO();
            _loc2_.fieldID = _loc3_.readInt();
            _loc2_.seedID = _loc3_.readInt();
            _loc2_.plantTime = _loc3_.readDate();
            _loc3_.readInt();
            _loc2_.AccelerateTime = _loc3_.readInt();
            this._landInfoVector.push(_loc2_);
            _loc5_++;
         }
         this.midAutumnFlag = _loc3_.readBoolean();
         this.model.selfFieldsInfo = this._landInfoVector;
      }
      
      protected function __updateBuyExpExpNum(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._model.buyExpRemainNum = _loc2_.readInt();
         dispatchEvent(new FarmEvent(FarmEvent.UPDATE_BUY_EXP_REMAIN_NUM));
      }
      
      private function __timerhandler(param1:TimerEvent) : void
      {
         this._timer.currentCount % 120 == 0;
         if(this._timer.currentCount % 120 == 0)
         {
         }
         if(this._timer.currentCount % 60 == 0)
         {
            dispatchEvent(new FarmEvent(FarmEvent.FRUSH_FIELD));
         }
         if(this._timer.currentCount % 2 == 0)
         {
            this._canGoFarm = true;
         }
      }
      
      private function __onEnterFarm(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Date = null;
         var _loc5_:Date = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:FieldVO = null;
         var _loc10_:FieldVO = null;
         this.model.fieldsInfo = null;
         this.model.fieldsInfo = new Vector.<FieldVO>();
         var _loc11_:PackageIn = param1.pkg;
         this._model.currentFarmerId = _loc11_.readInt();
         var _loc12_:Boolean = _loc11_.readBoolean();
         var _loc13_:int = _loc11_.readInt();
         var _loc14_:Date = _loc11_.readDate();
         var _loc15_:int = _loc11_.readInt();
         var _loc16_:int = _loc11_.readInt();
         var _loc17_:int = _loc11_.readInt();
         var _loc18_:int = _loc11_.readInt();
         this.model.helperArray = new Array();
         this.model.helperArray.push(_loc12_);
         this.model.helperArray.push(_loc13_);
         this.model.helperArray.push(_loc14_);
         this.model.helperArray.push(_loc15_);
         this.model.helperArray.push(_loc16_);
         this.model.helperArray.push(_loc17_);
         var _loc19_:int = 0;
         while(_loc19_ < _loc18_)
         {
            _loc2_ = _loc11_.readInt();
            _loc3_ = _loc11_.readInt();
            _loc4_ = _loc11_.readDate();
            _loc5_ = _loc11_.readDate();
            _loc6_ = _loc11_.readInt();
            _loc7_ = _loc11_.readInt();
            _loc8_ = _loc11_.readInt();
            if(this.model.getfieldInfoById(_loc2_) == null)
            {
               _loc9_ = new FieldVO();
               _loc9_.fieldID = _loc2_;
               _loc9_.seedID = _loc3_;
               _loc9_.payTime = _loc4_;
               _loc9_.plantTime = _loc5_;
               _loc9_.fieldValidDate = _loc7_;
               _loc9_.AccelerateTime = _loc8_;
               _loc9_.gainCount = _loc6_;
               _loc9_.autoSeedID = _loc13_;
               _loc9_.isAutomatic = _loc12_;
               this.model.fieldsInfo.push(_loc9_);
            }
            else
            {
               _loc10_ = this.model.getfieldInfoById(_loc2_);
               _loc10_.seedID = _loc3_;
               _loc10_.payTime = _loc4_;
               _loc10_.plantTime = _loc5_;
               _loc10_.fieldValidDate = _loc7_;
               _loc10_.AccelerateTime = _loc8_;
               _loc10_.gainCount = _loc6_;
               _loc10_.autoSeedID = _loc13_;
               _loc10_.isAutomatic = _loc12_;
            }
            _loc19_++;
         }
         if(this._model.currentFarmerId == PlayerManager.Instance.Self.ID)
         {
            this.gropPrice = _loc11_.readInt();
            this._model.payFieldMoney = _loc11_.readUTF();
            this._model.payAutoMoney = _loc11_.readUTF();
            this._model.autoPayTime = _loc11_.readDate();
            this._model.autoValidDate = _loc11_.readInt();
            this._model.vipLimitLevel = _loc11_.readInt();
            this._model.selfFieldsInfo = this._model.fieldsInfo.concat();
            this._model.isAutoId = _loc13_;
            this._model.buyExpRemainNum = _loc11_.readInt();
            PlayerManager.Instance.Self.isFarmHelper = _loc12_;
         }
         else
         {
            this._model.isArrange = _loc11_.readBoolean();
         }
         StateManager.setState(StateType.FARM);
         dispatchEvent(new FarmEvent(FarmEvent.FIELDS_INFO_READY));
      }
      
      private function __gainFieldHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:FieldVO = null;
         var _loc3_:Boolean = param1.pkg.readBoolean();
         if(_loc3_)
         {
            this.model.gainFieldId = param1.pkg.readInt();
            _loc2_ = this.model.getfieldInfoById(this.model.gainFieldId);
            _loc2_.seedID = param1.pkg.readInt();
            _loc2_.plantTime = param1.pkg.readDate();
            _loc2_.gainCount = param1.pkg.readInt();
            _loc2_.AccelerateTime = param1.pkg.readInt();
            dispatchEvent(new FarmEvent(FarmEvent.GAIN_FIELD));
         }
      }
      
      private function __payField(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Date = null;
         var _loc5_:Date = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:FieldVO = null;
         var _loc10_:FieldVO = null;
         var _loc11_:PackageIn = param1.pkg;
         this._model.currentFarmerId = _loc11_.readInt();
         var _loc12_:int = param1.pkg.readInt();
         var _loc13_:int = 0;
         while(_loc13_ < _loc12_)
         {
            _loc2_ = _loc11_.readInt();
            _loc3_ = _loc11_.readInt();
            _loc4_ = _loc11_.readDate();
            _loc5_ = _loc11_.readDate();
            _loc6_ = _loc11_.readInt();
            _loc7_ = _loc11_.readInt();
            _loc8_ = _loc11_.readInt();
            if(this.model.getfieldInfoById(_loc2_) == null)
            {
               _loc9_ = new FieldVO();
               _loc9_.fieldID = _loc2_;
               _loc9_.seedID = _loc3_;
               _loc9_.payTime = _loc4_;
               _loc9_.plantTime = _loc5_;
               _loc9_.fieldValidDate = _loc7_;
               _loc9_.AccelerateTime = _loc8_;
               _loc9_.gainCount = _loc6_;
               this.model.fieldsInfo.push(_loc9_);
            }
            else
            {
               _loc10_ = this.model.getfieldInfoById(_loc2_);
               _loc10_.seedID = _loc3_;
               _loc10_.payTime = _loc4_;
               _loc10_.plantTime = _loc5_;
               _loc10_.fieldValidDate = _loc7_;
               _loc10_.AccelerateTime = _loc8_;
               _loc10_.gainCount = _loc6_;
            }
            dispatchEvent(new FarmEvent(FarmEvent.FIELDS_INFO_READY));
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.payField.success"));
            _loc13_++;
         }
      }
      
      private function __onSeeding(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:Date = _loc2_.readDate();
         var _loc6_:Date = _loc2_.readDate();
         var _loc7_:int = _loc2_.readInt();
         var _loc8_:int = _loc2_.readInt();
         var _loc9_:FieldVO = this.model.getfieldInfoById(_loc3_);
         _loc9_.seedID = _loc4_;
         _loc9_.plantTime = _loc5_;
         _loc9_.gainCount = _loc7_;
         this.model.seedingFieldInfo = _loc9_;
         dispatchEvent(new FarmEvent(FarmEvent.HAS_SEEDING));
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.seeding.success"));
      }
      
      private function __onDoMature(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:FieldVO = null;
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1.pkg.readBoolean();
            if(_loc2_)
            {
               this.model.matureId = param1.pkg.readInt();
               _loc3_ = this.model.getfieldInfoById(this.model.matureId);
               _loc3_.gainCount = param1.pkg.readInt();
               _loc3_.AccelerateTime = param1.pkg.readInt();
               dispatchEvent(new FarmEvent(FarmEvent.ACCELERATE_FIELD));
            }
            _loc5_++;
         }
      }
      
      private function __onKillCrop(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:FieldVO = null;
         var _loc5_:Boolean = param1.pkg.readBoolean();
         if(_loc5_)
         {
            this.model.killCropId = param1.pkg.readInt();
            _loc2_ = param1.pkg.readInt();
            _loc3_ = param1.pkg.readInt();
            _loc4_ = this.model.getfieldInfoById(this.model.killCropId);
            _loc4_.seedID = _loc2_;
            _loc4_.AccelerateTime = _loc3_;
            dispatchEvent(new FarmEvent(FarmEvent.KILLCROP_FIELD));
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.killCrop.success"));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.killCrop.fail"));
         }
      }
      
      private function __onHelperSwitch(param1:CrazyTankSocketEvent) : void
      {
         this.model.helperArray = new Array();
         var _loc2_:Boolean = param1.pkg.readBoolean();
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:Date = param1.pkg.readDate();
         var _loc5_:int = param1.pkg.readInt();
         var _loc6_:int = param1.pkg.readInt();
         var _loc7_:int = param1.pkg.readInt();
         this.model.helperArray.push(_loc2_);
         this.model.helperArray.push(_loc3_);
         this.model.helperArray.push(_loc4_);
         this.model.helperArray.push(_loc5_);
         this.model.helperArray.push(_loc6_);
         this.model.helperArray.push(_loc7_);
         PlayerManager.Instance.Self.isFarmHelper = _loc2_;
         if(_loc2_)
         {
            dispatchEvent(new FarmEvent(FarmEvent.BEGIN_HELPER));
         }
         else
         {
            dispatchEvent(new FarmEvent(FarmEvent.STOP_HELPER));
         }
      }
      
      private function __onHelperPay(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Date = param1.pkg.readDate();
         var _loc3_:int = param1.pkg.readInt();
         this.model.autoPayTime = _loc2_;
         this.model.autoValidDate = _loc3_;
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farms.helperMoneyComfirmPnlSuccess"));
         this.model.dispatchEvent(new FarmEvent(FarmEvent.PAY_HELPER));
      }
      
      private function __onExitFarm(param1:CrazyTankSocketEvent) : void
      {
      }
      
      public function updateSetupFriendListLoader() : void
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["selfid"] = PlayerManager.Instance.Self.ID;
         _loc1_["key"] = MD5.hash(PlayerManager.Instance.Account.Password);
         _loc1_["rnd"] = Math.random();
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("FarmGetUserFieldInfos.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.updateSetupFriendListLoaderFailure");
         _loc2_.analyzer = new FarmFriendListAnalyzer(this.setupFriendList);
         LoaderManager.Instance.startLoad(_loc2_);
      }
      
      public function updateSetupFriendListStolen(param1:int) : void
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_["selfid"] = PlayerManager.Instance.Self.ID;
         _loc2_["key"] = MD5.hash(PlayerManager.Instance.Account.Password);
         _loc2_["friendID"] = param1;
         _loc2_["rnd"] = Math.random();
         var _loc3_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("FarmGetUserFieldInfosSingle.ashx"),BaseLoader.REQUEST_LOADER,_loc2_);
         _loc3_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.updateSetupFriendListLoaderFailure");
         _loc3_.analyzer = new FarmFriendListAnalyzer(this.setupFriendStolen);
         LoaderManager.Instance.startLoad(_loc3_);
      }
      
      public function creatSuperPetFoodPriceList() : void
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath(SuperPetFoodPriceAnalyzer.Path),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadSpuerPetFoodPricetListComposeListFail");
         _loc1_.analyzer = new SuperPetFoodPriceAnalyzer(this.setupSuperPetFoodPriceList);
         _loc1_.addEventListener(LoaderEvent.COMPLETE,this.__onloadSpuerPetFoodPricetListComplete);
         LoaderManager.Instance.startLoad(_loc1_);
      }
      
      protected function __onloadSpuerPetFoodPricetListComplete(param1:LoaderEvent) : void
      {
         dispatchEvent(new FarmEvent(FarmEvent.LOADER_SUPER_PET_FOOD_PRICET_LIST));
      }
      
      public function setupSuperPetFoodPriceList(param1:SuperPetFoodPriceAnalyzer) : void
      {
         this.model.priceList = param1.list;
         dispatchEvent(new FarmEvent(FarmEvent.LOADER_SUPER_PET_FOOD_PRICET_LIST));
      }
      
      public function setupFriendList(param1:FarmFriendListAnalyzer) : void
      {
         this.model.friendStateList = param1.list;
         dispatchEvent(new FarmEvent(FarmEvent.FRIEND_INFO_READY));
      }
      
      public function setupFriendStolen(param1:FarmFriendListAnalyzer) : void
      {
         this.model.friendStateListStolenInfo = param1.list;
         dispatchEvent(new FarmEvent(FarmEvent.FRIENDLIST_UPDATESTOLEN));
      }
      
      public function getCurrentMoney() : int
      {
         var _loc1_:int = 21 - this.model.buyExpRemainNum;
         var _loc2_:int = 0;
         while(_loc2_ < this.model.priceList.length)
         {
            if(this.model.priceList[_loc2_].Count == _loc1_)
            {
               return this.model.priceList[_loc2_].Money;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public function getCurrentSuperPetFoodPriceInfo() : SuperPetFoodPriceInfo
      {
         var _loc1_:int = 21 - this.model.buyExpRemainNum;
         var _loc2_:int = 0;
         while(_loc2_ < this.model.priceList.length)
         {
            if(this.model.priceList[_loc2_].Count == _loc1_)
            {
               return this.model.priceList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
   }
}
