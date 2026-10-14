package latentEnergy
{
   import bagAndInfo.bag.BagListView;
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.interfaces.ICell;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class LatentEnergyBagListView extends BagListView
   {
       
      
      public function LatentEnergyBagListView(param1:int, param2:int = 7, param3:int = 49)
      {
         super(param1,param2,param3);
         if(param1 == BagInfo.EQUIPBAG)
         {
            LatentEnergyManager.instance.addEventListener(LatentEnergyManager.EQUIP_MOVE,this.equipMoveHandler);
            LatentEnergyManager.instance.addEventListener(LatentEnergyManager.EQUIP_MOVE2,this.equipMoveHandler2);
         }
         else
         {
            LatentEnergyManager.instance.addEventListener(LatentEnergyManager.ITEM_MOVE,this.equipMoveHandler);
            LatentEnergyManager.instance.addEventListener(LatentEnergyManager.ITEM_MOVE2,this.equipMoveHandler2);
         }
      }
      
      override protected function createCells() : void
      {
         var _loc1_:LatentEnergyEquipListCell = null;
         _cells = new Dictionary();
         _cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         var _loc2_:int = 0;
         while(_loc2_ < _cellNum)
         {
            _loc1_ = this.createBagCell(_loc2_);
            _loc1_.mouseOverEffBoolean = false;
            addChild(_loc1_);
            _loc1_.bagType = _bagType;
            _loc1_.addEventListener(InteractiveEvent.CLICK,__clickHandler);
            _loc1_.addEventListener(MouseEvent.MOUSE_OVER,_cellOverEff);
            _loc1_.addEventListener(MouseEvent.MOUSE_OUT,_cellOutEff);
            _loc1_.addEventListener(InteractiveEvent.DOUBLE_CLICK,__doubleClickHandler);
            DoubleClickManager.Instance.enableDoubleClick(_loc1_);
            _loc1_.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
            _cells[_loc1_.place] = _loc1_;
            _cellVec.push(_loc1_);
            _loc2_++;
         }
      }
      
      private function createBagCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true) : LatentEnergyEquipListCell
      {
         var _loc4_:LatentEnergyEquipListCell = new LatentEnergyEquipListCell(param1,param2,param3);
         this.fillTipProp(_loc4_);
         return _loc4_;
      }
      
      private function fillTipProp(param1:ICell) : void
      {
         param1.tipDirctions = "7,6,2,1,5,4,0,3,6";
         param1.tipGapV = 10;
         param1.tipGapH = 10;
         param1.tipStyle = "core.GoodsTip";
      }
      
      private function equipMoveHandler(param1:LatentEnergyEvent) : void
      {
         var _loc2_:InventoryItemInfo = param1.info;
         var _loc3_:int = 0;
         while(_loc3_ < _cellNum)
         {
            if(_cells[_loc3_].info == _loc2_)
            {
               _cells[_loc3_].info = null;
               break;
            }
            _loc3_++;
         }
      }
      
      private function equipMoveHandler2(param1:LatentEnergyEvent) : void
      {
         var _loc2_:BagCell = null;
         var _loc3_:InventoryItemInfo = param1.info;
         if(param1.moveType == 2)
         {
            for each(_loc2_ in _cells)
            {
               if(_loc2_.info == _loc3_)
               {
                  return;
               }
            }
         }
         var _loc4_:int = 0;
         while(_loc4_ < _cellNum)
         {
            if(!_cells[_loc4_].info)
            {
               _cells[_loc4_].info = _loc3_;
               break;
            }
            _loc4_++;
         }
      }
      
      private function clearDataCells2() : void
      {
         var _loc1_:BagCell = null;
         for each(_loc1_ in _cells)
         {
            _loc1_.info = null;
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
            _bagdata.removeEventListener(BagEvent.UPDATE,__updateGoods);
         }
         this.clearDataCells2();
         _bagdata = param1;
         var _loc3_:int = 0;
         for(_loc2_ in _bagdata.items)
         {
            if(_cells[_loc3_] != null)
            {
               _bagdata.items[_loc2_].isMoveSpace = true;
               _cells[_loc3_].info = _bagdata.items[_loc2_];
            }
            _loc3_++;
         }
         _bagdata.addEventListener(BagEvent.UPDATE,__updateGoods);
      }
      
      override public function dispose() : void
      {
         LatentEnergyManager.instance.removeEventListener(LatentEnergyManager.EQUIP_MOVE,this.equipMoveHandler);
         LatentEnergyManager.instance.removeEventListener(LatentEnergyManager.EQUIP_MOVE2,this.equipMoveHandler2);
         LatentEnergyManager.instance.removeEventListener(LatentEnergyManager.ITEM_MOVE,this.equipMoveHandler);
         LatentEnergyManager.instance.removeEventListener(LatentEnergyManager.ITEM_MOVE2,this.equipMoveHandler2);
         super.dispose();
      }
   }
}
