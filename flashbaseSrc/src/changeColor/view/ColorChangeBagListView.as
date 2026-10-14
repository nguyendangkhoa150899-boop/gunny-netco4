package changeColor.view
{
   import bagAndInfo.bag.BagListView;
   import bagAndInfo.cell.BagCell;
   import changeColor.ChangeColorCellEvent;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.PlayerManager;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class ColorChangeBagListView extends BagListView
   {
       
      
      public function ColorChangeBagListView()
      {
         super(1);
      }
      
      override protected function createCells() : void
      {
         var _loc1_:ChangeColorBagCell = null;
         _cells = new Dictionary();
         var _loc2_:int = 0;
         while(_loc2_ < 49)
         {
            _loc1_ = new ChangeColorBagCell(_loc2_);
            addChild(_loc1_);
            _loc1_.bagType = _bagType;
            _loc1_.addEventListener(MouseEvent.CLICK,this.__cellClick);
            _loc1_.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
            _cells[_loc1_.place] = _loc1_;
            _loc2_++;
         }
      }
      
      override public function setData(param1:BagInfo) : void
      {
         var _loc2_:* = null;
         if(_bagdata == param1)
         {
            return;
         }
         if(_bagdata != null)
         {
            _bagdata.removeEventListener(BagEvent.UPDATE,this.__updateGoodsII);
         }
         _bagdata = param1;
         var _loc3_:int = 0;
         for(_loc2_ in _bagdata.items)
         {
            _cells[_loc3_++].info = _bagdata.items[_loc2_];
         }
         _bagdata.addEventListener(BagEvent.UPDATE,this.__updateGoodsII);
      }
      
      private function __updateGoodsII(param1:BagEvent) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:Dictionary = param1.changedSlots;
         for each(_loc2_ in _loc4_)
         {
            _loc3_ = PlayerManager.Instance.Self.Bag.getItemAt(_loc2_.Place);
            if(Boolean(_loc3_))
            {
               this.updateItem(_loc3_);
            }
            else
            {
               this.removeBagItem(_loc2_);
            }
         }
      }
      
      public function updateItem(param1:InventoryItemInfo) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 49)
         {
            if(Boolean(_cells[_loc2_].itemInfo) && _cells[_loc2_].itemInfo.Place == param1.Place)
            {
               _cells[_loc2_].info = param1;
               return;
            }
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < 49)
         {
            if(_cells[_loc3_].itemInfo == null)
            {
               _cells[_loc3_].info = param1;
               return;
            }
            _loc3_++;
         }
      }
      
      public function removeBagItem(param1:InventoryItemInfo) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 49)
         {
            if(Boolean(_cells[_loc2_].itemInfo) && _cells[_loc2_].itemInfo.Place == param1.Place)
            {
               _cells[_loc2_].info = null;
               return;
            }
            _loc2_++;
         }
      }
      
      private function __cellClick(param1:MouseEvent) : void
      {
         if((param1.currentTarget as BagCell).locked == false && (param1.currentTarget as BagCell).info != null)
         {
            dispatchEvent(new ChangeColorCellEvent(ChangeColorCellEvent.CLICK,param1.currentTarget as BagCell,true));
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:* = null;
         if(_bagdata != null)
         {
            _bagdata.removeEventListener(BagEvent.UPDATE,this.__updateGoodsII);
            _bagdata = null;
         }
         for(_loc1_ in _cells)
         {
            _cells[_loc1_].removeEventListener(MouseEvent.CLICK,this.__cellClick);
            _cells[_loc1_].removeEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
            _cells[_loc1_].dispose();
            _cells[_loc1_] = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
