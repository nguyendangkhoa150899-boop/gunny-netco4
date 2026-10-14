package wonderfulActivity.views
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.list.IListModel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.ActivityCellVo;
   import wonderfulActivity.event.WonderfulActivityEvent;
   
   public class ActivityLeftUnitView extends Sprite implements Disposeable
   {
      
      public static const TYPE_WONDER:int = 2;
      
      public static const TYPE_LIMINT:int = 1;
      
      public static const TYPE_NEWSERVER:int = 3;
      
      public static const TYPE_EXCHANGE:int = 4;
       
      
      private var _selectedBtn:SelectedButton;
      
      private var _bg:ScaleBitmapImage;
      
      private var _list:ListPanel;
      
      private var _type:int;
      
      private var dataList:Array;
      
      private var _selectedValue:ActivityCellVo;
      
      private var _updateFun:Function;
      
      private var _currentID:String;
      
      private var hasClickSound:Boolean = true;
      
      public function ActivityLeftUnitView(param1:int)
      {
         this._currentID = "-1";
         super();
         this._type = param1;
         this.initView();
         this.initEvent();
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function setData(param1:Array, param2:Function) : void
      {
         this.dataList = param1;
         this._updateFun = param2;
         this.initData();
      }
      
      private function initView() : void
      {
         this._selectedBtn = this.getSelectedBtn();
         addChild(this._selectedBtn);
         this._bg = ComponentFactory.Instance.creatComponentByStylename("wonderful.leftview.listBG");
         this._bg.visible = false;
         addChild(this._bg);
         this._list = ComponentFactory.Instance.creatComponentByStylename("wonderful.leftview.unitCellList");
         this._list.visible = false;
         addChild(this._list);
      }
      
      private function initEvent() : void
      {
         this._selectedBtn.addEventListener(MouseEvent.CLICK,this.__selectedBtnClick);
         this._list.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
      }
      
      public function initData() : void
      {
         this._list.vectorListModel.clear();
         this._list.vectorListModel.appendAll(this.dataList);
         this._list.list.updateListView();
      }
      
      private function getSelectedBtn() : SelectedButton
      {
         var _loc1_:SelectedButton = null;
         switch(this._type)
         {
            case TYPE_WONDER:
               _loc1_ = ComponentFactory.Instance.creatComponentByStylename("wonderful.leftview.wonderfulSelectedBtn");
               break;
            case TYPE_LIMINT:
               _loc1_ = ComponentFactory.Instance.creatComponentByStylename("wonderful.leftview.limitSelectedBtn");
               break;
            case TYPE_NEWSERVER:
               _loc1_ = ComponentFactory.Instance.creatComponentByStylename("wonderful.leftview.newServerSelectedBtn");
               break;
            case TYPE_EXCHANGE:
               _loc1_ = ComponentFactory.Instance.creatComponentByStylename("wonderful.leftview.exchangeActSelectedBtn");
         }
         return _loc1_;
      }
      
      private function __selectedBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._bg.visible = this._selectedBtn.selected;
         this._list.visible = this._selectedBtn.selected;
         this.extendSelecteTheFirst();
         dispatchEvent(new WonderfulActivityEvent(WonderfulActivityEvent.SELECTED_CHANGE));
      }
      
      private function __itemClick(param1:ListItemEvent) : void
      {
         this._selectedValue = param1.cellValue as ActivityCellVo;
         if(this._selectedValue.id == this._currentID)
         {
            return;
         }
         this._currentID = this._selectedValue.id;
         if(this.hasClickSound)
         {
            SoundManager.instance.play("008");
         }
         this.hasClickSound = true;
         this._updateFun(this._selectedValue.id);
      }
      
      public function extendSelecteTheFirst() : void
      {
         this.hasClickSound = false;
         this._currentID = "-1";
         this.extendHandler();
         this.autoSelect();
      }
      
      private function autoSelect() : void
      {
         var _loc1_:int = 0;
         var _loc2_:IntPoint = null;
         var _loc3_:int = 0;
         var _loc4_:IListModel = this._list.list.model;
         var _loc5_:int = int(_loc4_.getSize());
         if(_loc5_ > 0)
         {
            if(WonderfulActivityManager.Instance.isSkipFromHall)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc5_)
               {
                  if(WonderfulActivityManager.Instance.skipType == (_loc4_.getElementAt(_loc3_) as ActivityCellVo).id)
                  {
                     this._selectedValue = _loc4_.getElementAt(_loc3_) as ActivityCellVo;
                     WonderfulActivityManager.Instance.isSkipFromHall = false;
                     break;
                  }
                  _loc3_++;
               }
               if(!this._selectedValue)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wonderfulActivity.close"));
                  WonderfulActivityManager.Instance.isSkipFromHall = false;
                  this._selectedValue = _loc4_.getElementAt(0) as ActivityCellVo;
               }
            }
            else if(!this._selectedValue)
            {
               this._selectedValue = _loc4_.getElementAt(0) as ActivityCellVo;
            }
            _loc1_ = this.getIndexInModel(this._selectedValue.id);
            if(_loc1_ < 0)
            {
               _loc1_ = 0;
            }
            _loc2_ = new IntPoint(0,_loc4_.getCellPosFromIndex(_loc1_));
            this._list.list.viewPosition = _loc2_;
            this._list.list.currentSelectedIndex = _loc1_;
         }
         else
         {
            this._selectedValue = null;
         }
      }
      
      private function getIndexInModel(param1:String) : int
      {
         var _loc2_:IListModel = this._list.list.model;
         var _loc3_:int = 0;
         while(_loc3_ <= _loc2_.getSize() - 1)
         {
            if(_loc2_.getElementAt(_loc3_).id == param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      private function extendHandler() : void
      {
         this._selectedBtn.selected = true;
         this._selectedBtn.enable = false;
         this._list.visible = true;
         this._bg.visible = true;
      }
      
      public function unextendHandler() : void
      {
         this._selectedBtn.selected = false;
         this._selectedBtn.enable = true;
         this._bg.visible = false;
         this._list.visible = false;
      }
      
      public function getModelSize() : int
      {
         return this._list.list.model.getSize();
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
            this._selectedBtn.removeEventListener(MouseEvent.CLICK,this.__selectedBtnClick);
         }
         if(Boolean(this._list) && Boolean(this._list.list))
         {
            this._list.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._selectedBtn))
         {
            ObjectUtils.disposeObject(this._selectedBtn);
         }
         this._selectedBtn = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
      }
      
      public function get bg() : ScaleBitmapImage
      {
         return this._bg;
      }
      
      public function set bg(param1:ScaleBitmapImage) : void
      {
         this._bg = param1;
      }
      
      public function get list() : ListPanel
      {
         return this._list;
      }
      
      public function set list(param1:ListPanel) : void
      {
         this._list = param1;
      }
   }
}
