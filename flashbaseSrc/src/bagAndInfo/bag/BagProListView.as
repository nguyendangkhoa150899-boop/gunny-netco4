package bagAndInfo.bag
{
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.cell.CellFactory;
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CellEvent;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class BagProListView extends BagListView
   {
       
      
      public var _startIndex:int;
      
      public var _stopIndex:int;
      
      protected var _pageUpBtn:bagAndInfo.bag.BagPageButton;
      
      protected var _pageDownBtn:bagAndInfo.bag.BagPageButton;
      
      public function BagProListView(param1:int, param2:int = 31, param3:int = 80, param4:int = 7, param5:int = 1)
      {
         this._startIndex = param2;
         this._stopIndex = param3;
         _page = param5;
         this.initPageBtn();
         BagAndInfoManager.Instance.addEventListener("bagpage",this.__pageChange);
         super(param1,param4);
      }
      
      private function initPageBtn() : void
      {
         this._pageUpBtn = ComponentFactory.Instance.creatComponentByStylename("core.bag.upBtn");
         this._pageUpBtn.addEventListener("click",this.__onPageChange);
         this._pageDownBtn = ComponentFactory.Instance.creatComponentByStylename("core.bag.downBtn");
         this._pageDownBtn.addEventListener("click",this.__onPageChange);
      }
      
      override protected function createCells() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         _cells = new Dictionary();
         _cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         _loc1_ = this._startIndex;
         while(_loc1_ < this._stopIndex)
         {
            _loc2_ = CellFactory.instance.createBagCell(_loc1_) as BagCell;
            _loc2_.mouseOverEffBoolean = false;
            addChild(_loc2_);
            _loc2_.addEventListener("interactive_click",this.__clickHandler);
            _loc2_.addEventListener("mouseOver",_cellOverEff);
            _loc2_.addEventListener("mouseOut",_cellOutEff);
            _loc2_.addEventListener("interactive_double_click",this.__doubleClickHandler);
            DoubleClickManager.Instance.enableDoubleClick(_loc2_);
            _loc2_.addEventListener("lockChanged",__cellChanged);
            _loc2_.bagType = _bagType;
            _loc2_.addEventListener("lockChanged",__cellChanged);
            _cells[_loc2_.place] = _loc2_;
            _cellVec.push(_loc2_);
            _loc1_++;
         }
         if(_loc1_ == this._stopIndex)
         {
            if(_page == 1)
            {
               if(Boolean(this._pageDownBtn) && Boolean(this._pageDownBtn.parent))
               {
                  this._pageDownBtn.parent.removeChild(this._pageDownBtn);
               }
               addChild(this._pageUpBtn);
            }
            else if(_page == 2)
            {
               if(Boolean(this._pageUpBtn) && Boolean(this._pageUpBtn.parent))
               {
                  this._pageUpBtn.parent.removeChild(this._pageUpBtn);
               }
               addChild(this._pageDownBtn);
            }
         }
      }
      
      override protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         if((param1.currentTarget as BagCell).info != null)
         {
            SoundManager.instance.play("008");
            dispatchEvent(new CellEvent("doubleclick",param1.currentTarget));
         }
      }
      
      override protected function __clickHandler(param1:InteractiveEvent) : void
      {
         if((param1.currentTarget as BagCell).info != null)
         {
            dispatchEvent(new CellEvent("itemclick",param1.currentTarget,false,false,param1.ctrlKey));
         }
      }
      
      protected function __pageChange(param1:CellEvent) : void
      {
         var _loc2_:DragEffect = param1.data as DragEffect;
         if(!(_loc2_.data is InventoryItemInfo) || _loc2_.data.BagType != 1)
         {
            return;
         }
         DragManager.startDrag(_loc2_.source.getSource(),_loc2_.data,(_loc2_.source as BaseCell).createDragImg(),stage.mouseX,stage.mouseY,"move",false);
         this.__onPageChange(null);
      }
      
      private function __onPageChange(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:int = 0;
         var _loc7_:* = _cells;
         for each(_loc2_ in _cells)
         {
            _loc2_.removeEventListener("interactive_click",this.__clickHandler);
            _loc2_.removeEventListener("interactive_double_click",this.__doubleClickHandler);
            DoubleClickManager.Instance.disableDoubleClick(_loc2_);
            _loc2_.removeEventListener("lockChanged",__cellChanged);
         }
         _loc3_ = 0;
         _loc4_ = _cells;
         for each(_loc5_ in _cells)
         {
            _loc5_.removeEventListener("interactive_click",this.__clickHandler);
            _loc5_.removeEventListener("lockChanged",__cellChanged);
            _loc5_.removeEventListener("mouseOver",_cellOverEff);
            _loc5_.removeEventListener("mouseOut",_cellOutEff);
            _loc5_.removeEventListener("interactive_double_click",this.__doubleClickHandler);
            DoubleClickManager.Instance.disableDoubleClick(_loc5_);
            _loc5_.dispose();
         }
         _cells = null;
         _cellVec = null;
         if(_page == 1)
         {
            _page = 2;
            this._startIndex = 48;
            this._stopIndex = 96;
            _cellVec = [];
            this.createCells();
            setData(PlayerManager.Instance.Self.PropBag);
         }
         else
         {
            _page = 1;
            this._startIndex = 0;
            this._stopIndex = 48;
            _cellVec = [];
            this.createCells();
            setData(PlayerManager.Instance.Self.PropBag);
         }
      }
      
      override public function setCellInfo(param1:int, param2:InventoryItemInfo) : void
      {
         if(param1 >= this._startIndex && param1 < this._stopIndex)
         {
            if(param2 == null)
            {
               _cells[param1].info = null;
               return;
            }
            if(param2.Count == 0)
            {
               _cells[param1].info = null;
            }
            else
            {
               _cells[param1].info = param2;
            }
         }
      }
      
      override public function dispose() : void
      {
         BagAndInfoManager.Instance.removeEventListener("bagpage",this.__pageChange);
         if(Boolean(this._pageUpBtn))
         {
            this._pageUpBtn.removeEventListener("click",this.__onPageChange);
            ObjectUtils.disposeObject(this._pageUpBtn);
            this._pageUpBtn = null;
         }
         if(Boolean(this._pageDownBtn))
         {
            this._pageDownBtn.removeEventListener("click",this.__onPageChange);
            ObjectUtils.disposeObject(this._pageDownBtn);
            this._pageDownBtn = null;
         }
         super.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
