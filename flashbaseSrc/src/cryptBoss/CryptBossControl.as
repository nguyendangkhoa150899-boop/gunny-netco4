package cryptBoss
{
   import com.pickgliss.events.ComponentEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import cryptBoss.event.CryptBossEvent;
   import cryptBoss.view.CryptBossMainFrame;
   import ddt.data.map.DungeonInfo;
   import ddt.manager.MapManager;
   import ddt.view.UIModuleSmallLoading;
   
   public class CryptBossControl
   {
      
      private static var _instance:cryptBoss.CryptBossControl;
      
      public static var loadComplete:Boolean = false;
       
      
      private var _cryptBossFrame:CryptBossMainFrame;
      
      public function CryptBossControl()
      {
         super();
      }
      
      public static function get instance() : cryptBoss.CryptBossControl
      {
         if(!_instance)
         {
            _instance = new cryptBoss.CryptBossControl();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         CryptBossManager.instance.addEventListener("cryptBossOpenView",this.__onOpenView);
         CryptBossManager.instance.addEventListener("cryptBossOpenView",this.__onUpdateView);
      }
      
      protected function __onUpdateView(param1:CryptBossEvent) : void
      {
         if(Boolean(this._cryptBossFrame))
         {
            this._cryptBossFrame.updateView();
         }
      }
      
      protected function __onOpenView(param1:CryptBossEvent) : void
      {
         this.show();
      }
      
      public function show() : void
      {
         if(loadComplete)
         {
            this.showFrame();
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleLoader.Instance.addEventListener("uiModuleComplete",this.loadCompleteHandler);
            UIModuleLoader.Instance.addEventListener("uiMoudleProgress",this.onUimoduleLoadProgress);
            UIModuleLoader.Instance.addUIModuleImp("cryptBoss");
         }
      }
      
      private function loadCompleteHandler(param1:UIModuleEvent) : void
      {
         if(param1.module == "cryptBoss")
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener("uiModuleComplete",this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener("uiMoudleProgress",this.onUimoduleLoadProgress);
            loadComplete = true;
            this.show();
         }
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == "horse")
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function showFrame() : void
      {
         if(!this._cryptBossFrame)
         {
            this._cryptBossFrame = ComponentFactory.Instance.creatComponentByStylename("CryptBossMainFrame");
            this._cryptBossFrame.addEventListener("dispose",this.frameDisposeHandler,false,0,true);
            LayerManager.Instance.addToLayer(this._cryptBossFrame,3,true,1);
         }
      }
      
      public function getTemplateIdArr(param1:int, param2:int) : Array
      {
         var _loc3_:DungeonInfo = MapManager.getDungeonInfo(param1);
         switch(int(param2) - 1)
         {
            case 0:
               return _loc3_.SimpleTemplateIds.split(",");
            case 1:
               return _loc3_.NormalTemplateIds.split(",");
            case 2:
               return _loc3_.HardTemplateIds.split(",");
            case 3:
               return _loc3_.TerrorTemplateIds.split(",");
            case 4:
               return _loc3_.NightmareTemplateIds.split(",");
            default:
               return [];
         }
      }
      
      private function frameDisposeHandler(param1:ComponentEvent) : void
      {
         if(Boolean(this._cryptBossFrame))
         {
            this._cryptBossFrame.removeEventListener("dispose",this.frameDisposeHandler);
         }
         this._cryptBossFrame = null;
      }
   }
}
