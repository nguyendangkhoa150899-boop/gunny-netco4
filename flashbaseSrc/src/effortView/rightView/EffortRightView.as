package effortView.rightView
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.data.effort.EffortInfo;
   import ddt.events.EffortEvent;
   import ddt.manager.EffortManager;
   import ddt.manager.SoundManager;
   import effortView.EffortController;
   import flash.display.Sprite;
   
   public class EffortRightView extends Sprite implements Disposeable
   {
       
      
      private var _listPanel:ListPanel;
      
      private var _currentSelectItem:EffortInfo;
      
      private var _currentListArray:Array;
      
      private var _controller:EffortController;
      
      public function EffortRightView(param1:EffortController)
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._listPanel = ComponentFactory.Instance.creatComponentByStylename("effortView.effortlistPanel");
         this._listPanel.vScrollProxy = ScrollPanel.AUTO;
         this.getNearCompleteEfforts(EffortManager.Instance.currentEffortList);
         this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListItemClick);
         addChild(this._listPanel);
      }
      
      private function initEvent() : void
      {
         EffortManager.Instance.addEventListener(EffortEvent.LIST_CHANGED,this.__listChanged);
      }
      
      private function __listChanged(param1:EffortEvent) : void
      {
         this.getNearCompleteEfforts(EffortManager.Instance.currentEffortList);
      }
      
      private function getNearCompleteEfforts(param1:Array) : void
      {
         if(EffortManager.Instance.isSelf)
         {
            this.getSelfNearCompleteEfforts(param1);
         }
         else
         {
            this.getOtherNearCompleteEfforts(param1);
         }
      }
      
      private function getSelfNearCompleteEfforts(param1:Array) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(Boolean((param1[_loc4_] as EffortInfo).CompleteStateInfo))
            {
               _loc2_ = [];
               _loc2_ = EffortManager.Instance.getCompleteNextEffort(param1[_loc4_].ID);
               if(Boolean(_loc2_[0]))
               {
                  _loc3_.push(_loc2_[_loc2_.length - 1]);
               }
            }
            else
            {
               _loc3_.push(param1[_loc4_]);
            }
            _loc4_++;
         }
         this.setCurrentList(_loc3_);
      }
      
      private function getOtherNearCompleteEfforts(param1:Array) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(EffortManager.Instance.tempEffortIsComplete((param1[_loc4_] as EffortInfo).ID))
            {
               _loc2_ = [];
               _loc2_ = EffortManager.Instance.getTempCompleteNextEffort(param1[_loc4_].ID);
               if(Boolean(_loc2_[0]))
               {
                  _loc3_.push(_loc2_[_loc2_.length - 1]);
               }
            }
            else
            {
               _loc3_.push(param1[_loc4_]);
            }
            _loc4_++;
         }
         this.setCurrentList(_loc3_);
      }
      
      public function setCurrentList(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this._currentListArray = [];
         var _loc4_:Array = param1;
         var _loc5_:Array = [];
         _loc4_.sortOn("ID",Array.DESCENDING);
         if(EffortManager.Instance.isSelf)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length)
            {
               if(Boolean((_loc4_[_loc2_] as EffortInfo).CompleteStateInfo))
               {
                  this._currentListArray.unshift(_loc4_[_loc2_]);
               }
               else
               {
                  _loc5_.unshift(_loc4_[_loc2_]);
               }
               _loc2_++;
            }
            this._currentListArray = this._currentListArray.concat(_loc5_);
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < _loc4_.length)
            {
               if(EffortManager.Instance.tempEffortIsComplete(_loc4_[_loc3_].ID))
               {
                  this._currentListArray.unshift(_loc4_[_loc3_]);
               }
               else
               {
                  _loc5_.unshift(_loc4_[_loc3_]);
               }
               _loc3_++;
            }
            this._currentListArray = this._currentListArray.concat(_loc5_);
         }
         this.updateCurrentList();
      }
      
      private function updateCurrentList() : void
      {
         this._listPanel.vectorListModel.clear();
         this._listPanel.vectorListModel.appendAll(this._currentListArray);
         this._listPanel.list.updateListView();
      }
      
      private function __onListItemClick(param1:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._currentSelectItem)
         {
            this._currentSelectItem = param1.cellValue as EffortInfo;
         }
         if(this._currentSelectItem != param1.cellValue as EffortInfo)
         {
            this._currentSelectItem.isSelect = false;
         }
         this._currentSelectItem = param1.cellValue as EffortInfo;
         this._currentSelectItem.isSelect = true;
         this._listPanel.list.updateListView();
      }
      
      public function dispose() : void
      {
         if(Boolean(this._currentSelectItem))
         {
            this._currentSelectItem.isSelect = false;
         }
         EffortManager.Instance.removeEventListener(EffortEvent.LIST_CHANGED,this.__listChanged);
         if(Boolean(this._listPanel) && Boolean(this._listPanel.parent))
         {
            this._listPanel.vectorListModel.clear();
            this._listPanel.parent.removeChild(this._listPanel);
            this._listPanel.dispose();
            this._listPanel = null;
         }
         if(Boolean(this) && Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
