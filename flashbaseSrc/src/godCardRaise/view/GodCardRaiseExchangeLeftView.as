package godCardRaise.view
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import godCardRaise.info.GodCardListGroupInfo;
   
   public class GodCardRaiseExchangeLeftView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _list:ListPanel;
      
      private var dataList:Array;
      
      private var _updateFun:Function;
      
      private var _selectedValue:GodCardListGroupInfo;
      
      private var _currentID:int;
      
      public function GodCardRaiseExchangeLeftView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.godCardRaiseExchangeLeftView.bg");
         addChild(this._bg);
         this._list = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseExchangeLeftView.unitCellList");
         addChild(this._list);
      }
      
      private function initEvent() : void
      {
         this._list.list.addEventListener("listItemClick",this.__itemClick);
      }
      
      public function setData(param1:Array, param2:Function) : void
      {
         this.dataList = param1;
         this._updateFun = param2;
         this.initData();
         this._list.list.currentSelectedIndex = 0;
      }
      
      public function initData() : void
      {
         this._list.vectorListModel.clear();
         this._list.vectorListModel.appendAll(this.dataList);
         this._list.list.updateListView();
      }
      
      public function updateView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = null;
         if(Boolean(this._list) && Boolean(this._list.list))
         {
            _loc4_ = this._list.list.cell;
            _loc1_ = 0;
            _loc2_ = _loc4_;
            for each(_loc3_ in _loc4_)
            {
               _loc5_ = _loc3_ as GodCardRaiseExchangeLeftCell;
               _loc5_.updateView();
            }
         }
      }
      
      private function __itemClick(param1:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         this._selectedValue = param1.cellValue as GodCardListGroupInfo;
         if(this._selectedValue.GroupID == this._currentID)
         {
            return;
         }
         this._currentID = this._selectedValue.GroupID;
         this._updateFun(this._selectedValue);
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._list))
         {
            this._list.list.removeEventListener("listItemClick",this.__itemClick);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._list = null;
         this.dataList = null;
         this._updateFun = null;
         this._selectedValue = null;
         this._currentID = 0;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
