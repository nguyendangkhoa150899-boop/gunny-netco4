package catchbeast
{
   import catchbeast.view.CatchBeastView;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class CatchBeastControl extends EventDispatcher
   {
      
      public static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
      
      private static var _instance:catchbeast.CatchBeastControl;
       
      
      private var _catchBeastView:CatchBeastView;
      
      public function CatchBeastControl()
      {
         super();
      }
      
      public static function get instance() : catchbeast.CatchBeastControl
      {
         if(!_instance)
         {
            _instance = new catchbeast.CatchBeastControl();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         CatchBeastManager.instance.addEventListener("catchBeastOpenView",this.__onOpenView);
      }
      
      protected function __onOpenView(param1:Event) : void
      {
         this.show();
      }
      
      private function show() : void
      {
         if(loadComplete)
         {
            this.showCatchBeastFrame();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener("close",this.__onClose);
            UIModuleLoader.Instance.addEventListener("uiMoudleProgress",this.__progressShow);
            UIModuleLoader.Instance.addEventListener("uiModuleComplete",this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp("catchbeast");
         }
      }
      
      public function hide() : void
      {
         CatchBeastManager.instance.RoomType = 0;
         if(this._catchBeastView != null)
         {
            this._catchBeastView.dispose();
         }
         this._catchBeastView = null;
      }
      
      private function __complainShow(param1:UIModuleEvent) : void
      {
         if(param1.module == "catchbeast")
         {
            UIModuleSmallLoading.Instance.removeEventListener("close",this.__onClose);
            UIModuleLoader.Instance.removeEventListener("uiMoudleProgress",this.__progressShow);
            UIModuleLoader.Instance.removeEventListener("uiModuleComplete",this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            useFirst = false;
            this.show();
         }
      }
      
      private function __progressShow(param1:UIModuleEvent) : void
      {
         if(param1.module == "catchbeast")
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      protected function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener("close",this.__onClose);
         UIModuleLoader.Instance.removeEventListener("uiMoudleProgress",this.__progressShow);
         UIModuleLoader.Instance.removeEventListener("uiModuleComplete",this.__complainShow);
      }
      
      private function showCatchBeastFrame() : void
      {
         this._catchBeastView = ComponentFactory.Instance.creatComponentByStylename("catchBeast.CatchBeastView");
         this._catchBeastView.show();
      }
   }
}
