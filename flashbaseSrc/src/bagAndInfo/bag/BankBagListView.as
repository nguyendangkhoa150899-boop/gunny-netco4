package bagAndInfo.bag
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.events.CellEvent;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class BankBagListView extends BagListView
   {
      
      private static var MAX_LINE_NUM:int = 10;
       
      
      public function BankBagListView(param1:int)
      {
         super(param1,MAX_LINE_NUM);
      }
      
      override protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         if((param1.currentTarget as BagCell).info != null)
         {
            dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,param1.currentTarget));
         }
      }
      
      override protected function __clickHandler(param1:InteractiveEvent) : void
      {
         if(Boolean(param1.currentTarget))
         {
            dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,param1.currentTarget,false,false));
         }
      }
      
      private function __resultHandler(param1:MouseEvent) : void
      {
      }
      
      override protected function createCells() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         _cells = new Dictionary();
         _loc1_ = 0;
         while(_loc1_ < MAX_LINE_NUM)
         {
            _loc2_ = 0;
            while(_loc2_ < MAX_LINE_NUM)
            {
               _loc3_ = _loc1_ * MAX_LINE_NUM + _loc2_;
               _loc4_ = CellFactory.instance.createBagCell(_loc3_) as BagCell;
               addChild(_loc4_);
               _loc4_.bagType = _bagType;
               _loc4_.addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
               _loc4_.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
               DoubleClickManager.Instance.enableDoubleClick(_loc4_);
               _loc4_.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
               _cells[_loc4_.place] = _loc4_;
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      public function checkConsortiaStoreCell() : int
      {
         var _loc3_:* = undefined;
         var _loc1_:int = 0;
         var _loc2_:* = _cells;
         for each(_loc3_ in _cells)
         {
            if(!_loc3_.info)
            {
               return 0;
            }
         }
         return 3;
      }
      
      override public function dispose() : void
      {
         var _loc3_:* = undefined;
         var _loc1_:int = 0;
         var _loc2_:* = _cells;
         for each(_loc3_ in _cells)
         {
            _loc3_.removeEventListener("interactive_click",this.__clickHandler);
            _loc3_.removeEventListener("interactive_double_click",this.__doubleClickHandler);
            _loc3_.removeEventListener("lockChanged",__cellChanged);
         }
         super.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
