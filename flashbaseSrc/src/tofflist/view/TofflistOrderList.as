package tofflist.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import flash.display.Sprite;
   import tofflist.TofflistEvent;
   import tofflist.TofflistModel;
   
   public class TofflistOrderList extends Sprite implements Disposeable
   {
       
      
      private var _currenItem:tofflist.view.TofflistOrderItem;
      
      private var _items:Vector.<tofflist.view.TofflistOrderItem>;
      
      private var _list:VBox;
      
      public function TofflistOrderList()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      public function dispose() : void
      {
         this.clearList();
         this._items = null;
         ObjectUtils.disposeObject(this._currenItem);
         this._currenItem = null;
         ObjectUtils.disposeObject(this._list);
         this._list = null;
      }
      
      public function items(param1:Array, param2:int = 1) : void
      {
         var _loc3_:tofflist.view.TofflistOrderItem = null;
         var _loc4_:tofflist.view.TofflistOrderItem = null;
         this.clearList();
         if(!param1 || param1.length == 0)
         {
            return;
         }
         var _loc5_:int = param1.length > param2 * 8 ? int(param2 * 8) : int(param1.length);
         var _loc6_:int = (param2 - 1) * 8;
         while(_loc6_ < _loc5_)
         {
            _loc3_ = ComponentFactory.Instance.creatCustomObject("tofflist.orderItem");
            _loc3_.index = _loc6_ + 1;
            _loc3_.info = param1[_loc6_];
            this._list.addChild(_loc3_);
            this._items.push(_loc3_);
            _loc3_.addEventListener(TofflistEvent.TOFFLIST_ITEM_SELECT,this.__itemChange);
            _loc6_++;
         }
         if(this._list.getChildAt(0) is TofflistOrderItem)
         {
            _loc4_ = this._list.getChildAt(0) as TofflistOrderItem;
            _loc4_.isSelect = true;
         }
         else
         {
            TofflistModel.currentText = "";
            TofflistModel.currentIndex = 0;
            TofflistModel.currentPlayerInfo = null;
         }
      }
      
      private function __itemChange(param1:TofflistEvent) : void
      {
         if(Boolean(this._currenItem))
         {
            this._currenItem.isSelect = false;
         }
         this._currenItem = param1.data as TofflistOrderItem;
         TofflistModel.currentConsortiaInfo = this._currenItem.consortiaInfo;
         TofflistModel.currentText = this._currenItem.currentText;
         TofflistModel.currentIndex = this._currenItem.index;
         TofflistModel.currentPlayerInfo = this._currenItem.info as PlayerInfo;
      }
      
      private function addEvent() : void
      {
      }
      
      public function clearList() : void
      {
         var _loc1_:tofflist.view.TofflistOrderItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._items.length)
         {
            _loc1_ = this._items[_loc2_] as TofflistOrderItem;
            _loc1_.removeEventListener(TofflistEvent.TOFFLIST_ITEM_SELECT,this.__itemChange);
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
            _loc2_++;
         }
         this._items = new Vector.<TofflistOrderItem>();
         this._currenItem = null;
         TofflistModel.currentText = "";
         TofflistModel.currentIndex = 0;
         TofflistModel.currentPlayerInfo = null;
      }
      
      private function init() : void
      {
         this._list = new VBox();
         this._list.spacing = -3.5;
         addChild(this._list);
         this._items = new Vector.<TofflistOrderItem>();
      }
   }
}
