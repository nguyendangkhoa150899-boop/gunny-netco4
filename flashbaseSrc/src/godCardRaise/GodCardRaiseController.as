package godCardRaise
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CEvent;
   import godCardRaise.view.GodCardRaiseMainView;
   
   public class GodCardRaiseController
   {
      
      private static var instance:godCardRaise.GodCardRaiseController;
       
      
      private var _manager:godCardRaise.GodCardRaiseManager;
      
      private var _godCardRaiseMainView:GodCardRaiseMainView;
      
      public function GodCardRaiseController()
      {
         super();
      }
      
      public static function get Instance() : godCardRaise.GodCardRaiseController
      {
         if(!instance)
         {
            instance = new godCardRaise.GodCardRaiseController();
         }
         return instance;
      }
      
      public function setup() : void
      {
         this._manager = GodCardRaiseManager.Instance;
         GodCardRaiseManager.Instance.addEventListener("godCardRaise_show_view",this.onShowView);
         GodCardRaiseManager.Instance.addEventListener("closeView",this.onCloseView);
      }
      
      private function onShowView(param1:CEvent) : void
      {
         if(Boolean(this._godCardRaiseMainView))
         {
            ObjectUtils.disposeObject(this._godCardRaiseMainView);
            this._godCardRaiseMainView = null;
         }
         this._godCardRaiseMainView = ComponentFactory.Instance.creatComponentByStylename("godCardRaise.frame");
         LayerManager.Instance.addToLayer(this._godCardRaiseMainView,3,true,1);
      }
      
      private function onCloseView(param1:CEvent) : void
      {
         if(Boolean(this._godCardRaiseMainView))
         {
            ObjectUtils.disposeObject(this._godCardRaiseMainView);
            this._godCardRaiseMainView = null;
         }
      }
   }
}
