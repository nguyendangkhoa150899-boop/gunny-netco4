package im
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.core.Disposeable;
   import consortion.ConsortionModelControl;
   import consortion.event.ConsortionEvent;
   import ddt.data.player.ConsortiaPlayerInfo;
   import flash.display.Sprite;
   
   public class ConsortiaListView extends Sprite implements Disposeable
   {
       
      
      private var _list:ListPanel;
      
      private var _consortiaPlayerArray:Array;
      
      private var _currentItem:ConsortiaPlayerInfo;
      
      private var _pos:int;
      
      public function ConsortiaListView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._list = ComponentFactory.Instance.creat("IM.ConsortiaListPanel");
         this._list.vScrollProxy = ScrollPanel.AUTO;
         addChild(this._list);
         this._list.list.updateListView();
         this._list.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this.update();
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MEMBER_ADD,this.__updateList);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MEMBER_REMOVE,this.__updateList);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MEMBER_UPDATA,this.__updateList);
      }
      
      private function __updateList(param1:ConsortionEvent) : void
      {
         this._pos = this._list.list.viewPosition.y;
         this.update();
         var _loc2_:IntPoint = new IntPoint(0,this._pos);
         this._list.list.viewPosition = _loc2_;
      }
      
      private function __itemClick(param1:ListItemEvent) : void
      {
         if(!this._currentItem)
         {
            this._currentItem = param1.cellValue as ConsortiaPlayerInfo;
            this._currentItem.isSelected = true;
         }
         else if(this._currentItem != param1.cellValue as ConsortiaPlayerInfo)
         {
            this._currentItem.isSelected = false;
            this._currentItem = param1.cellValue as ConsortiaPlayerInfo;
            this._currentItem.isSelected = true;
         }
         this._list.list.updateListView();
      }
      
      private function update() : void
      {
         var _loc1_:ConsortiaPlayerInfo = null;
         this._consortiaPlayerArray = [];
         this._consortiaPlayerArray = ConsortionModelControl.Instance.model.onlineConsortiaMemberList;
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < this._consortiaPlayerArray.length)
         {
            _loc1_ = this._consortiaPlayerArray[_loc4_] as ConsortiaPlayerInfo;
            if(_loc1_.IsVIP)
            {
               _loc2_.push(_loc1_);
            }
            else
            {
               _loc3_.push(_loc1_);
            }
            _loc4_++;
         }
         _loc2_ = _loc2_.sortOn("Grade",Array.NUMERIC | Array.DESCENDING);
         _loc3_ = _loc3_.sortOn("Grade",Array.NUMERIC | Array.DESCENDING);
         this._consortiaPlayerArray = _loc2_.concat(_loc3_);
         var _loc5_:Array = ConsortionModelControl.Instance.model.offlineConsortiaMemberList;
         _loc5_ = _loc5_.sortOn("Grade",Array.NUMERIC | Array.DESCENDING);
         this._consortiaPlayerArray = this._consortiaPlayerArray.concat(_loc5_);
         this._list.vectorListModel.clear();
         this._list.vectorListModel.appendAll(this._consortiaPlayerArray);
         this._list.list.updateListView();
      }
      
      public function dispose() : void
      {
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MEMBER_ADD,this.__updateList);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MEMBER_REMOVE,this.__updateList);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MEMBER_UPDATA,this.__updateList);
         if(Boolean(this._list) && Boolean(this._list.parent))
         {
            this._list.parent.removeChild(this._list);
            this._list.dispose();
            this._list = null;
         }
         if(Boolean(this._currentItem))
         {
            this._currentItem.isSelected = false;
         }
      }
   }
}
