package AvatarCollection.view
{
   import AvatarCollection.AvatarCollectionManager;
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.list.IListModel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class AvatarCollectionUnitView extends Sprite implements Disposeable
   {
      
      public static const SELECTED_CHANGE:String = "avatarCollectionUnitView_selected_change";
       
      
      protected var _index:int;
      
      protected var _rightView:AvatarCollection.view.AvatarCollectionRightView;
      
      protected var _selectedBtn:SelectedButton;
      
      protected var _bg:DisplayObject;
      
      protected var _list:ListPanel;
      
      private var _dataList:Array;
      
      private var _selectedValue:AvatarCollectionUnitVo;
      
      private var _isFilter:Boolean = false;
      
      private var _isBuyFilter:Boolean = false;
      
      public function AvatarCollectionUnitView(param1:int, param2:AvatarCollection.view.AvatarCollectionRightView)
      {
         super();
         this._index = param1;
         this._rightView = param2;
         this.initView();
         this.initEvent();
         this.initData();
         this.initStatus();
      }
      
      public function set isBuyFilter(param1:Boolean) : void
      {
         this._isBuyFilter = param1;
         if(this._isBuyFilter)
         {
            this._isFilter = false;
         }
         this.refreshList();
      }
      
      public function set isFilter(param1:Boolean) : void
      {
         this._isFilter = param1;
         if(this._isFilter)
         {
            this._isBuyFilter = false;
         }
         this.refreshList();
      }
      
      private function initStatus() : void
      {
         var _loc1_:int = 0;
         if(AvatarCollectionManager.instance.isSkipFromHall)
         {
            _loc1_ = 0;
            while(_loc1_ < this._dataList.length)
            {
               if((this._dataList[_loc1_] as AvatarCollectionUnitVo).id == AvatarCollectionManager.instance.skipId)
               {
                  this.extendSelecteTheFirst();
                  break;
               }
               _loc1_++;
            }
         }
         else if(this._index == 1)
         {
            this.extendSelecteTheFirst();
         }
      }
      
      protected function initView() : void
      {
         this._selectedBtn = this.getSelectedBtn();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.avatarColl.selectUnitBg");
         this._bg.visible = false;
         this._list = ComponentFactory.Instance.creatComponentByStylename("avatarColl.unitCellList");
         this._list.visible = false;
         if(Boolean(this._selectedBtn))
         {
            addChild(this._selectedBtn);
         }
         addChild(this._bg);
         addChild(this._list);
      }
      
      private function initEvent() : void
      {
         if(Boolean(this._selectedBtn))
         {
            this._selectedBtn.addEventListener("click",this.clickHandler,false,0,true);
         }
         this._list.list.addEventListener("listItemClick",this.__itemClick);
         AvatarCollectionManager.instance.addEventListener("avatar_collection_refresh_view",this.toDoRefresh);
      }
      
      private function initData() : void
      {
         this._dataList = this.getDataList();
         this._list.vectorListModel.clear();
         this._list.vectorListModel.appendAll(this._dataList);
         this._list.list.updateListView();
      }
      
      private function toDoRefresh(param1:Event) : void
      {
         this.refreshList();
      }
      
      private function __itemClick(param1:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         this._selectedValue = param1.cellValue as AvatarCollectionUnitVo;
         if(Boolean(this._rightView))
         {
            this._rightView.refreshView(this._selectedValue);
         }
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.extendSelecteTheFirst();
         dispatchEvent(new Event("avatarCollectionUnitView_selected_change"));
      }
      
      public function extendSelecteTheFirst() : void
      {
         if(Boolean(this._selectedBtn))
         {
            this._selectedBtn.selected = true;
         }
         this.extendHandler();
         this.autoSelect();
      }
      
      private function extendHandler() : void
      {
         this._bg.visible = true;
         this._list.visible = true;
         if(Boolean(this._selectedBtn))
         {
            this._selectedBtn.enable = false;
         }
      }
      
      private function autoSelect() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:IListModel = this._list.list.model;
         var _loc5_:int = int(_loc4_.getSize());
         if(_loc5_ > 0)
         {
            if(!this._selectedValue)
            {
               if(AvatarCollectionManager.instance.isSkipFromHall)
               {
                  _loc1_ = 0;
                  while(_loc1_ < _loc5_)
                  {
                     if((_loc4_.getElementAt(_loc1_) as AvatarCollectionUnitVo).id == AvatarCollectionManager.instance.skipId)
                     {
                        this._selectedValue = _loc4_.getElementAt(_loc1_);
                        AvatarCollectionManager.instance.isSkipFromHall = false;
                        break;
                     }
                     _loc1_++;
                  }
               }
               else
               {
                  this._selectedValue = _loc4_.getElementAt(0) as AvatarCollectionUnitVo;
               }
            }
            _loc2_ = int(_loc4_.indexOf(this._selectedValue));
            _loc3_ = new IntPoint(0,_loc4_.getCellPosFromIndex(_loc2_));
            this._list.list.viewPosition = _loc3_;
            this._list.list.currentSelectedIndex = _loc2_;
         }
         else
         {
            this._selectedValue = null;
         }
         this._rightView.refreshView(this._selectedValue);
      }
      
      public function unextendHandler() : void
      {
         if(Boolean(this._selectedBtn))
         {
            this._selectedBtn.selected = false;
            this._selectedBtn.enable = true;
         }
         this._bg.visible = false;
         this._list.visible = false;
      }
      
      private function refreshList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = [];
         if(this._isFilter)
         {
            _loc1_ = int(this._dataList.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               if((this._dataList[_loc2_] as AvatarCollectionUnitVo).canActivityCount > 0)
               {
                  _loc5_.push(this._dataList[_loc2_]);
               }
               _loc2_++;
            }
         }
         else if(this._isBuyFilter)
         {
            _loc3_ = int(this._dataList.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if((this._dataList[_loc4_] as AvatarCollectionUnitVo).canBuyCount > 0)
               {
                  _loc5_.push(this._dataList[_loc4_]);
               }
               _loc4_++;
            }
         }
         else
         {
            _loc5_ = this._dataList;
         }
         this._list.vectorListModel.clear();
         this._list.vectorListModel.appendAll(_loc5_);
         this._list.list.updateListView();
         if(Boolean(this._selectedValue) && _loc5_.indexOf(this._selectedValue) == -1)
         {
            this._selectedValue = null;
         }
         if(this._list.visible)
         {
            this.autoSelect();
         }
      }
      
      private function getDataList() : Array
      {
         var _loc1_:* = null;
         switch(int(this._index) - 1)
         {
            case 0:
               _loc1_ = AvatarCollectionManager.instance.maleUnitList;
               break;
            case 1:
               _loc1_ = AvatarCollectionManager.instance.femaleUnitList;
               break;
            case 2:
               _loc1_ = AvatarCollectionManager.instance.weaponUnitList;
               break;
            default:
               _loc1_ = [];
         }
         return !!_loc1_ ? _loc1_ : [];
      }
      
      private function getSelectedBtn() : SelectedButton
      {
         var _loc1_:* = null;
         switch(int(this._index) - 1)
         {
            case 0:
               _loc1_ = ComponentFactory.Instance.creatComponentByStylename("avatarColl.maleBtn");
               break;
            case 1:
               _loc1_ = ComponentFactory.Instance.creatComponentByStylename("avatarColl.femaleBtn");
         }
         return _loc1_;
      }
      
      override public function get height() : Number
      {
         if(Boolean(this._selectedBtn) && Boolean(this._bg))
         {
            if(this._bg.visible)
            {
               return this._bg.y + this._bg.height;
            }
            return this._selectedBtn.height;
         }
         return super.height;
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._selectedBtn))
         {
            this._selectedBtn.removeEventListener("click",this.clickHandler);
         }
         this._list.list.removeEventListener("listItemClick",this.__itemClick);
         AvatarCollectionManager.instance.removeEventListener("avatar_collection_refresh_view",this.toDoRefresh);
      }
      
      public function dispose() : void
      {
         AvatarCollectionManager.instance.isSkipFromHall = false;
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._rightView = null;
         this._selectedBtn = null;
         this._bg = null;
         this._list = null;
         this._dataList = null;
         this._selectedValue = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get list() : ListPanel
      {
         return this._list;
      }
   }
}
