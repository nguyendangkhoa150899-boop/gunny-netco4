package newTitle.view
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.EffortManager;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   import newTitle.NewTitleControl;
   import newTitle.NewTitleManager;
   import newTitle.event.NewTitleEvent;
   
   public class NewTitleListView extends Sprite implements Disposeable
   {
       
      
      private var _list:ListPanel;
      
      public function NewTitleListView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._list = ComponentFactory.Instance.creatComponentByStylename("newTitle.list");
         addChild(this._list);
      }
      
      private function initEvent() : void
      {
         this._list.list.addEventListener("listItemClick",this.__onListItemClick);
      }
      
      protected function __onListItemClick(param1:ListItemEvent) : void
      {
         NewTitleControl.instance.dispatchEvent(new NewTitleEvent("titleItemClick",[param1.index]));
      }
      
      public function updateOwnTitleList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = EffortManager.Instance.getHonorArray();
         this._list.vectorListModel.clear();
         _loc1_ = 0;
         while(_loc1_ < _loc3_.length)
         {
            this._list.vectorListModel.append(_loc3_[_loc1_].Name,_loc1_);
            _loc1_++;
         }
         this._list.list.updateListView();
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            if(PlayerManager.Instance.Self.honor == _loc3_[_loc2_].Name)
            {
               this._list.setViewPosition(_loc2_);
               this._list.list.currentSelectedIndex = _loc2_;
               break;
            }
            _loc2_++;
         }
      }
      
      public function updateAllTitleList() : void
      {
         var _loc1_:int = 0;
         this._list.vectorListModel.clear();
         var _loc2_:Array = NewTitleManager.instance.titleArray;
         _loc1_ = 0;
         while(_loc1_ < _loc2_.length)
         {
            this._list.vectorListModel.append(_loc2_[_loc1_].Name,_loc1_);
            _loc1_++;
         }
         this._list.list.updateListView();
         this._list.list.currentSelectedIndex = 0;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._list))
         {
            this._list.removeEventListener("listItemClick",this.__onListItemClick);
            ObjectUtils.disposeObject(this._list);
            this._list = null;
         }
      }
   }
}
