package auctionHouse.view
{
   import bagAndInfo.bag.BagListView;
   import bagAndInfo.bag.BagPageButton;
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.PlayerManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class AuctionBagListView extends BagListView
   {
       
      
      public var _startIndex:int;
      
      public var _stopIndex:int;
      
      protected var _pageUpBtn:BagPageButton;
      
      protected var _pageDownBtn:BagPageButton;
      
      public function AuctionBagListView(param1:int, param2:int = 31, param3:int = 80, param4:int = 7, param5:int = 1)
      {
         this._startIndex = param2;
         this._stopIndex = param3;
         _page = param5;
         this.initPageBtn();
         super(param1,param4);
      }
      
      private function initPageBtn() : void
      {
         this._pageUpBtn = ComponentFactory.Instance.creatComponentByStylename("core.bag.upBtn");
         this._pageUpBtn.addEventListener("click",this.__onPageChange);
         this._pageDownBtn = ComponentFactory.Instance.creatComponentByStylename("core.bag.downBtn");
         this._pageDownBtn.addEventListener("click",this.__onPageChange);
      }
      
      override public function setData(param1:BagInfo) : void
      {
         var _loc2_:* = undefined;
         if(_bagdata != null)
         {
            _bagdata.removeEventListener("update",this.__updateGoods);
         }
         _bagdata = param1;
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         var _loc5_:* = _bagdata.items;
         for(_loc2_ in _bagdata.items)
         {
            if(_cells[_loc2_] != null && _bagdata.items[_loc2_].IsBinds == false && _bagdata.items[_loc2_].TemplateID != 112262 && _bagdata.items[_loc2_].TemplateID != 112323)
            {
               _cells[_loc2_].info = _bagdata.items[_loc2_];
               _loc3_.push(_cells[_loc2_]);
            }
         }
         _bagdata.addEventListener("update",this.__updateGoods);
         this._cellsSort(_loc3_);
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
            this.setData(PlayerManager.Instance.Self.PropBag);
         }
         else
         {
            _page = 1;
            this._startIndex = 0;
            this._stopIndex = 48;
            _cellVec = [];
            this.createCells();
            this.setData(PlayerManager.Instance.Self.PropBag);
         }
      }
      
      override protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         if((param1.currentTarget as BagCell).info != null)
         {
            dispatchEvent(new CellEvent("doubleclick",param1.currentTarget));
         }
      }
      
      override protected function __clickHandler(param1:InteractiveEvent) : void
      {
         if(Boolean(param1.currentTarget))
         {
            dispatchEvent(new CellEvent("itemclick",param1.currentTarget,false,false));
         }
      }
      
      override protected function __updateGoods(param1:BagEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = null;
         var _loc4_:Dictionary = param1.changedSlots;
         var _loc5_:int = 0;
         var _loc6_:* = _loc4_;
         for each(_loc2_ in _loc4_)
         {
            _loc3_ = _bagdata.getItemAt(_loc2_.Place);
            if(_loc3_ && _loc3_.IsBinds == false)
            {
               setCellInfo(_loc3_.Place,_loc3_);
            }
            else
            {
               setCellInfo(_loc2_.Place,null);
            }
            dispatchEvent(new Event("change"));
         }
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
            _loc5_ = _cellVec.indexOf(param1[_loc2_]);
            _loc6_ = _cellVec[_loc2_];
            param1[_loc2_].x = _loc6_.x;
            param1[_loc2_].y = _loc6_.y;
            _loc6_.x = _loc3_;
            _loc6_.y = _loc4_;
            _cellVec[_loc2_] = param1[_loc2_];
            _cellVec[_loc5_] = _loc6_;
            _loc2_++;
         }
      }
      
      override public function dispose() : void
      {
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
