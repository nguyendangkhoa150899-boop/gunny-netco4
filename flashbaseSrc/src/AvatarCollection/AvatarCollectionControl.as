package AvatarCollection
{
   import AvatarCollection.view.AvatarCollectionMainView;
   import AvatarCollection.view.AvatarCollectionUnitListCell;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CEvent;
   import ddt.loader.LoaderCreate;
   import ddt.utils.HelperDataModuleLoad;
   import flash.display.Sprite;
   
   public class AvatarCollectionControl
   {
      
      private static var _instance:AvatarCollection.AvatarCollectionControl;
       
      
      private var _view:AvatarCollectionMainView;
      
      public function AvatarCollectionControl()
      {
         super();
      }
      
      public static function get instance() : AvatarCollection.AvatarCollectionControl
      {
         if(!_instance)
         {
            _instance = new AvatarCollection.AvatarCollectionControl();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         AvatarCollectionManager.instance.addEventListener(CEvent.OPEN_VIEW,this.__onOpenView);
      }
      
      private function __onOpenView(param1:CEvent) : void
      {
         new HelperDataModuleLoad().loadDataModule([LoaderCreate.Instance.createAvatarCollectionUnitDataLoader()],this.createFrame,[param1]);
      }
      
      private function createFrame(param1:CEvent) : void
      {
         var _loc2_:* = null;
         if(!this._view)
         {
            _loc2_ = param1.data.parent as Sprite;
            this._view = new AvatarCollectionMainView();
            _loc2_.addChild(this._view);
            AvatarCollectionManager.instance.addEventListener("closeView",this.__onCloseView);
            AvatarCollectionManager.instance.addEventListener("visible",this.__onVisible);
            AvatarCollectionManager.instance.addEventListener("avatar_collection_select_all",this.__onSelectAll);
            AvatarCollectionManager.instance.addEventListener("reset_left",this.__onResetLeft);
         }
      }
      
      protected function __onResetLeft(param1:CEvent) : void
      {
         this._view.reset();
      }
      
      protected function __onSelectAll(param1:CEvent) : void
      {
         var _loc2_:Vector.<IListCell> = null;
         var _loc3_:AvatarCollectionUnitListCell = null;
         var _loc4_:int = int(this._view.unitList.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = this._view.unitList[_loc5_].list.list.cell;
            for each(_loc3_ in _loc2_)
            {
               _loc3_.select = param1.data;
            }
            _loc5_++;
         }
      }
      
      private function __onVisible(param1:CEvent) : void
      {
         if(Boolean(this._view))
         {
            this._view.visible = param1.data.visible;
         }
      }
      
      private function __onCloseView(param1:CEvent) : void
      {
         AvatarCollectionManager.instance.removeEventListener("closeView",this.__onCloseView);
         AvatarCollectionManager.instance.removeEventListener("visible",this.__onVisible);
         ObjectUtils.disposeObject(this._view);
         this._view = null;
      }
   }
}
