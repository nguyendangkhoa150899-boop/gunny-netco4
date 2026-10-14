package bagAndInfo.bag
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class BagListView extends SimpleTileList
   {
      
      public static const BAG_CAPABILITY:int = 49;
       
      
      protected var _bagdata:BagInfo;
      
      protected var _cellNum:int;
      
      protected var _bagType:int;
      
      protected var _page:int;
      
      protected var _cells:Dictionary;
      
      protected var _cellMouseOverBg:Bitmap;
      
      protected var _cellVec:Array;
      
      private var _isSetFoodData:Boolean;
      
      private var _currentBagType:int;
      
      public function BagListView(param1:int, param2:int = 7, param3:int = 49)
      {
         this._cellNum = param3;
         this._bagType = param1;
         super(param2);
         _vSpace = 0;
         _hSpace = 0;
         this._cellVec = [];
         this.createCells();
      }
      
      protected function createCells() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._cells = new Dictionary();
         this._cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         _loc1_ = 0;
         while(_loc1_ < this._cellNum)
         {
            _loc2_ = BagCell(CellFactory.instance.createBagCell(_loc1_));
            _loc2_.mouseOverEffBoolean = false;
            addChild(_loc2_);
            _loc2_.bagType = this._bagType;
            _loc2_.addEventListener("interactive_click",this.__clickHandler);
            _loc2_.addEventListener("mouseOver",this._cellOverEff);
            _loc2_.addEventListener("mouseOut",this._cellOutEff);
            _loc2_.addEventListener("interactive_double_click",this.__doubleClickHandler);
            DoubleClickManager.Instance.enableDoubleClick(_loc2_);
            _loc2_.addEventListener("lockChanged",this.__cellChanged);
            this._cells[_loc2_.place] = _loc2_;
            this._cellVec.push(_loc2_);
            _loc1_++;
         }
      }
      
      protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         if((param1.currentTarget as BagCell).info != null)
         {
            SoundManager.instance.play("008");
            dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,param1.currentTarget));
         }
      }
      
      protected function __cellChanged(param1:Event) : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      protected function __clickHandler(param1:InteractiveEvent) : void
      {
         if((param1.currentTarget as BagCell).info != null)
         {
            dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,param1.currentTarget,false,false,param1.ctrlKey));
         }
      }
      
      protected function _cellOverEff(param1:MouseEvent) : void
      {
         BagCell(param1.currentTarget).onParentMouseOver(this._cellMouseOverBg);
      }
      
      protected function _cellOutEff(param1:MouseEvent) : void
      {
         BagCell(param1.currentTarget).onParentMouseOut();
      }
      
      public function setCellInfo(param1:int, param2:InventoryItemInfo) : void
      {
         if(!this._cells[param1])
         {
            return;
         }
         if(param2 == null)
         {
            this._cells[param1].info = null;
            return;
         }
         if(param2.Count == 0)
         {
            this._cells[param1].info = null;
         }
         else
         {
            this._cells[param1].info = param2;
         }
      }
      
      protected function clearDataCells() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:* = this._cells;
         for each(_loc1_ in this._cells)
         {
            _loc1_.info = null;
         }
      }
      
      public function set currentBagType(param1:int) : void
      {
         this._currentBagType = param1;
      }
      
      public function setData(param1:BagInfo) : void
      {
         var _loc2_:* = undefined;
         this._isSetFoodData = false;
         if(this._bagdata == param1 && param1.BagType != 0 && param1.BagType != 1)
         {
            return;
         }
         if(this._bagdata != null)
         {
            this._bagdata.removeEventListener("update",this.__updateGoods);
         }
         this.clearDataCells();
         this._bagdata = param1;
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         var _loc5_:* = this._bagdata.items;
         for(_loc2_ in this._bagdata.items)
         {
            if(this._cells[_loc2_] != null)
            {
               if(this._currentBagType == 5)
               {
                  if(this._bagdata.items[_loc2_].CategoryID == 50 || this._bagdata.items[_loc2_].CategoryID == 51 || this._bagdata.items[_loc2_].CategoryID == 52)
                  {
                     this._bagdata.items[_loc2_].isMoveSpace = true;
                     this._cells[_loc2_].info = this._bagdata.items[_loc2_];
                     _loc3_.push(this._cells[_loc2_]);
                  }
               }
               else
               {
                  this._bagdata.items[_loc2_].isMoveSpace = true;
                  this._cells[_loc2_].info = this._bagdata.items[_loc2_];
               }
            }
         }
         this._bagdata.addEventListener("update",this.__updateGoods);
         if(this._currentBagType == 5)
         {
            this._cellsSort(_loc3_);
         }
      }
      
      private function sortItems() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         var _loc5_:* = this._bagdata.items;
         for(_loc1_ in this._bagdata.items)
         {
            _loc2_ = this._bagdata.items[_loc1_];
            if(this._cells[_loc1_] != null && _loc2_)
            {
               if(_loc2_.CategoryID == 50 || _loc2_.CategoryID == 51 || _loc2_.CategoryID == 52)
               {
                  BaseCell(this._cells[_loc1_]).info = _loc2_;
                  _loc3_.push(this._cells[_loc1_]);
               }
            }
         }
         this._cellsSort(_loc3_);
      }
      
      private function _cellsSort(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         if(param1.length <= 0)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = Number(param1[_loc2_].x);
            _loc4_ = Number(param1[_loc2_].y);
            _loc5_ = this._cellVec.indexOf(param1[_loc2_]);
            _loc6_ = this._cellVec[_loc2_];
            param1[_loc2_].x = _loc6_.x;
            param1[_loc2_].y = _loc6_.y;
            _loc6_.x = _loc3_;
            _loc6_.y = _loc4_;
            this._cellVec[_loc2_] = param1[_loc2_];
            this._cellVec[_loc5_] = _loc6_;
            _loc2_++;
         }
      }
      
      protected function __updateFoodGoods(param1:BagEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:int = 0;
         var _loc7_:* = null;
         var _loc8_:* = null;
         var _loc9_:* = null;
         if(!this._bagdata)
         {
            return;
         }
         var _loc10_:Dictionary = param1.changedSlots;
         var _loc11_:int = 0;
         var _loc12_:* = _loc10_;
         for each(_loc2_ in _loc10_)
         {
            _loc6_ = -1;
            _loc7_ = null;
            _loc3_ = 0;
            _loc4_ = this._bagdata.items;
            for(_loc5_ in this._bagdata.items)
            {
               _loc8_ = this._bagdata.items[_loc5_] as InventoryItemInfo;
               if(_loc2_.ItemID == _loc8_.ItemID)
               {
                  _loc7_ = _loc2_;
                  _loc6_ = _loc5_;
                  break;
               }
            }
            if(_loc6_ != -1)
            {
               _loc9_ = this._bagdata.getItemAt(_loc6_);
               if(_loc9_)
               {
                  _loc9_.Count = _loc7_.Count;
                  if(Boolean(this._cells[_loc6_].info))
                  {
                     this.setCellInfo(_loc6_,null);
                  }
                  else
                  {
                     this.setCellInfo(_loc6_,_loc9_);
                  }
               }
               else
               {
                  this.setCellInfo(_loc6_,null);
               }
               dispatchEvent(new Event("change"));
            }
         }
      }
      
      protected function __updateGoods(param1:BagEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = null;
         var _loc6_:* = null;
         if(this._isSetFoodData)
         {
            this.__updateFoodGoods(param1);
         }
         else
         {
            _loc5_ = param1.changedSlots;
            _loc2_ = 0;
            _loc3_ = _loc5_;
            for each(_loc4_ in _loc5_)
            {
               _loc6_ = this._bagdata.getItemAt(_loc4_.Place);
               if(_loc6_)
               {
                  if(this._currentBagType == 5)
                  {
                     if(_loc6_.CategoryID != 50 && _loc6_.CategoryID != 51 && _loc6_.CategoryID != 52)
                     {
                        this.setCellInfo(_loc4_.Place,null);
                        continue;
                     }
                  }
                  this.setCellInfo(_loc6_.Place,_loc6_);
               }
               else
               {
                  this.setCellInfo(_loc4_.Place,null);
               }
               dispatchEvent(new Event("change"));
            }
         }
         if(this._currentBagType == 5)
         {
            this.sortItems();
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:* = undefined;
         if(this._bagdata != null)
         {
            this._bagdata.removeEventListener("update",this.__updateGoods);
            this._bagdata = null;
         }
         var _loc2_:int = 0;
         var _loc3_:* = this._cells;
         for each(_loc1_ in this._cells)
         {
            _loc1_.removeEventListener("interactive_click",this.__clickHandler);
            _loc1_.removeEventListener("lockChanged",this.__cellChanged);
            _loc1_.removeEventListener("mouseOver",this._cellOverEff);
            _loc1_.removeEventListener("mouseOut",this._cellOutEff);
            _loc1_.removeEventListener("interactive_double_click",this.__doubleClickHandler);
            DoubleClickManager.Instance.disableDoubleClick(_loc1_);
            _loc1_.dispose();
         }
         this._cells = null;
         this._cellVec = null;
         if(Boolean(this._cellMouseOverBg))
         {
            if(Boolean(this._cellMouseOverBg.parent))
            {
               this._cellMouseOverBg.parent.removeChild(this._cellMouseOverBg);
            }
            this._cellMouseOverBg.bitmapData.dispose();
         }
         this._cellMouseOverBg = null;
         super.dispose();
      }
      
      public function get cells() : Dictionary
      {
         return this._cells;
      }
      
      public function updateBankBag(param1:int) : void
      {
      }
      
      public function checkBankCell() : int
      {
         return 0;
      }
   }
}
