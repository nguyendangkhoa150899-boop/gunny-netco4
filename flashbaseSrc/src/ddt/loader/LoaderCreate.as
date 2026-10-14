package ddt.loader
{
   import AvatarCollection.AvatarCollectionManager;
   import AvatarCollection.data.AvatarCollectionItemDataAnalyzer;
   import AvatarCollection.data.AvatarCollectionUnitDataAnalyzer;
   import chickActivation.ChickActivationManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.TextLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.ActivitySystemItemsDataAnalyzer;
   import ddt.data.analyze.FineSuitAnalyze;
   import ddt.manager.FineSuitManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PathManager;
   import explorerManual.ExplorerManualManager;
   import explorerManual.analyzer.ChapterItemAnalyzer;
   import explorerManual.analyzer.ManualDebrisAnalyzer;
   import explorerManual.analyzer.ManualItemAnalyzer;
   import explorerManual.analyzer.ManualPageItemAnalyzer;
   import explorerManual.analyzer.ManualUpgradeAnalyzer;
   import flash.net.URLVariables;
   import godCardRaise.GodCardRaiseManager;
   import godCardRaise.analyzer.GodCardListAnalyzer;
   import godCardRaise.analyzer.GodCardListGroupAnalyzer;
   import godCardRaise.analyzer.GodCardPointRewardListAnalyzer;
   import pyramid.PyramidManager;
   import wonderfulActivity.WonderfulActAnalyer;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.WonderfulGMActAnalyer;
   
   public class LoaderCreate
   {
      
      private static var _instance:ddt.loader.LoaderCreate;
       
      
      private var _reloadCount:int = 0;
      
      private var _reloadQuestCount:int = 0;
      
      private var _rechargeCount:int = 0;
      
      private var _actReloadeCount:int = 0;
      
      public function LoaderCreate()
      {
         super();
      }
      
      public static function get Instance() : ddt.loader.LoaderCreate
      {
         if(_instance == null)
         {
            _instance = new ddt.loader.LoaderCreate();
         }
         return _instance;
      }
      
      public function loadWonderfulActivityXml() : BaseLoader
      {
         ++this._actReloadeCount;
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["rnd"] = TextLoader.TextLoaderKey + this._actReloadeCount.toString();
         var _loc2_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("GmActivityInfo.xml"),BaseLoader.COMPRESS_TEXT_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.wonderfulActiveInfoFail");
         _loc2_.analyzer = new WonderfulGMActAnalyer(WonderfulActivityManager.Instance.wonderfulGMActiveInfo);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function creatWondActiveLoader() : BaseLoader
      {
         ++this._rechargeCount;
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["rnd"] = TextLoader.TextLoaderKey + this._rechargeCount.toString();
         var _loc2_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("LoadChargeActiveTemplate.xml"),BaseLoader.COMPRESS_TEXT_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.wondActInfoFail");
         _loc2_.analyzer = new WonderfulActAnalyer(WonderfulActivityManager.Instance.wonderfulActiveType);
         return _loc2_;
      }
      
      public function createFineSuitInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("SetsBuildTemp.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadSuitInfoFail");
         _loc1_.analyzer = new FineSuitAnalyze(FineSuitManager.Instance.setup);
         return _loc1_;
      }
      
      public function creatGodCardListTemplate() : BaseLoader
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["rnd"] = Math.random();
         var _loc2_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("GodCardList.xml"),5,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.godCardListTemplate.error");
         _loc2_.analyzer = new GodCardListAnalyzer(GodCardRaiseManager.Instance.loadGodCardListTemplate);
         return _loc2_;
      }
      
      public function creatGodCardListGroup() : BaseLoader
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["rnd"] = Math.random();
         var _loc2_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("GodCardListGroup.ashx"),7,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.godCardListGroup.error");
         _loc2_.analyzer = new GodCardListGroupAnalyzer(GodCardRaiseManager.Instance.loadGodCardListGroup);
         return _loc2_;
      }
      
      public function creatGodCardPointRewardList() : BaseLoader
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["rnd"] = Math.random();
         var _loc2_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("GodCardPointRewardList.ashx"),7,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.godCardPointRewardList.error");
         _loc2_.analyzer = new GodCardPointRewardListAnalyzer(GodCardRaiseManager.Instance.loadGodCardPointRewardList);
         return _loc2_;
      }
      
      public function createActivitySystemItemsLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ActivitySystemItems.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.activitySystemItemsInfoFail");
         _loc1_.analyzer = new ActivitySystemItemsDataAnalyzer(this.activitySystemItemsDataHandler);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createAvatarCollectionUnitDataLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ClothPropertyTemplateInfo.xml"),5);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.AvatarCollectionUnitDataFail");
         _loc1_.analyzer = new AvatarCollectionUnitDataAnalyzer(AvatarCollectionManager.instance.unitListDataSetup);
         return _loc1_;
      }
      
      public function createAvatarCollectionItemDataLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ClothGroupTemplateInfo.xml"),5);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.AvatarCollectionItemDataFail");
         _loc1_.analyzer = new AvatarCollectionItemDataAnalyzer(AvatarCollectionManager.instance.itemListDataSetup);
         return _loc1_;
      }
      
      public function createManaualDebrisData() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("JampsDebrisItemList.xml"),5);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("explorerManual.manualTempleteData.loadFail") + "_碎片";
         _loc1_.analyzer = new ManualDebrisAnalyzer(ExplorerManualManager.instance.initDebrisData);
         return _loc1_;
      }
      
      public function createChapterItemData() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("JampsChapterItemList.xml"),5);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("explorerManual.manualTempleteData.loadFail") + "_章节";
         _loc1_.analyzer = new ChapterItemAnalyzer(ExplorerManualManager.instance.initChapterData);
         return _loc1_;
      }
      
      public function createManualItemData() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("JampsManualItemList.xml"),5);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("explorerManual.manualTempleteData.loadFail") + "_手册项";
         _loc1_.analyzer = new ManualItemAnalyzer(ExplorerManualManager.instance.initManualItemData);
         return _loc1_;
      }
      
      public function createManualUpgradeData() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("JampsUpgradeItemList.xml"),5);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("explorerManual.manualTempleteData.loadFail") + "_升级";
         _loc1_.analyzer = new ManualUpgradeAnalyzer(ExplorerManualManager.instance.initManualUpgradeData);
         return _loc1_;
      }
      
      public function createPageItemData() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("JampsPageItemList.xml"),5);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("explorerManual.manualTempleteData.loadFail") + "_页";
         _loc1_.analyzer = new ManualPageItemAnalyzer(ExplorerManualManager.instance.initPageItemData);
         return _loc1_;
      }
      
      private function activitySystemItemsDataHandler(param1:DataAnalyzer) : void
      {
         var _loc2_:ActivitySystemItemsDataAnalyzer = null;
         if(param1 is ActivitySystemItemsDataAnalyzer)
         {
            _loc2_ = param1 as ActivitySystemItemsDataAnalyzer;
            PyramidManager.instance.templateDataSetup(_loc2_.pyramidSystemDataList);
            ChickActivationManager.instance.templateDataSetup(_loc2_.chickActivationDataList);
         }
      }
      
      public function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:String = param1.loader.loadErrorMessage;
         if(Boolean(param1.loader.analyzer))
         {
            if(param1.loader.analyzer.message != null)
            {
               _loc2_ = param1.loader.loadErrorMessage + "\n" + param1.loader.analyzer.message;
            }
         }
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),_loc2_,LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"));
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
   }
}
