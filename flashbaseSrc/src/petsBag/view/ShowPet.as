package petsBag.view
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.info.PersonalInfoDragInArea;
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CellEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   import petsBag.view.item.PetBigItem;
   import petsBag.view.item.PetEquipItem;
   import petsBag.view.item.PetWashBoneGrade;
   import petsBag.view.item.StarBar;
   
   public class ShowPet extends Sprite implements Disposeable
   {
      
      public static var isPetEquip:Boolean;
       
      
      private var _starBar:StarBar;
      
      private var _petGrade:PetWashBoneGrade;
      
      private var _petBigItem:PetBigItem;
      
      private var _equipLockBitmapData:BitmapData;
      
      private var _vbox:VBox;
      
      private var _equipList:Array;
      
      private var _currentPetIndex:int;
      
      private var _dragDropArea:PersonalInfoDragInArea;
      
      public function ShowPet()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc1_:PetEquipItem = null;
         this._dragDropArea = new PersonalInfoDragInArea();
         this._equipList = new Array();
         this._vbox = ComponentFactory.Instance.creatCustomObject("petsBag.showPet.vbox");
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc1_ = new PetEquipItem(_loc2_);
            _loc1_.id = _loc2_;
            _loc1_.addEventListener(CellEvent.DOUBLE_CLICK,this.doubleClickHander);
            _loc1_.addEventListener(CellEvent.ITEM_CLICK,this.onClickHander);
            this._vbox.addChild(_loc1_);
            this._equipList.push(_loc1_);
            _loc2_++;
         }
         this._starBar = new StarBar();
         this._starBar.x = this._vbox.x + this._vbox.width;
         this._starBar.y = 9;
         addChild(this._starBar);
         this._petBigItem = ComponentFactory.Instance.creat("petsBag.petBigItem");
         this._petBigItem.initTips();
         this._petGrade = new PetWashBoneGrade();
         addChild(this._petGrade);
         PositionUtils.setPos(this._petGrade,"petsBag.petGradePos");
         addChild(this._dragDropArea);
         addChild(this._petBigItem);
         addChild(this._vbox);
      }
      
      private function __showPetTip(param1:Event) : void
      {
         if(isPetEquip == true)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ShowPet.Tip"));
         }
      }
      
      private function onClickHander(param1:CellEvent) : void
      {
         var _loc2_:BagCell = null;
         if(PlayerInfoViewControl.isOpenFromBag)
         {
            _loc2_ = param1.data as BagCell;
            PetBagController.instance().isEquip = true;
            _loc2_.dragStart();
         }
      }
      
      private function doubleClickHander(param1:CellEvent) : void
      {
         if(PlayerInfoViewControl.isOpenFromBag)
         {
            SocketManager.Instance.out.delPetEquip(PetBagController.instance().petModel.currentPetInfo.Place,param1.currentTarget.id);
         }
      }
      
      public function addPetEquip(param1:InventoryItemInfo) : void
      {
         this.getBagCell(param1.Place).initBagCell(param1);
      }
      
      public function getBagCell(param1:int) : PetEquipItem
      {
         return this._equipList[param1] as PetEquipItem;
      }
      
      public function delPetEquip(param1:int) : void
      {
         if(Boolean(this.getBagCell(param1)))
         {
            this.getBagCell(param1).clearBagCell();
         }
      }
      
      public function update() : void
      {
         var _loc1_:InventoryItemInfo = null;
         var _loc2_:InventoryItemInfo = null;
         this.clearCell();
         var _loc3_:PetInfo = PetBagController.instance().petModel.currentPetInfo;
         this._petGrade.visible = _loc3_ != null;
         if(!_loc3_)
         {
            this._starBar.starNum(Boolean(_loc3_) ? int(_loc3_.StarLevel) : int(0));
            this._petBigItem.info = _loc3_;
            return;
         }
         this._starBar.starNum(Boolean(_loc3_) ? int(_loc3_.StarLevel) : int(0));
         this._petBigItem.info = _loc3_;
         var _loc4_:int = 0;
         while(_loc4_ < 3)
         {
            _loc1_ = _loc3_.equipList[_loc4_];
            if(Boolean(_loc1_))
            {
               _loc2_ = ItemManager.fill(_loc1_) as InventoryItemInfo;
               this.addPetEquip(_loc1_);
            }
            _loc4_++;
         }
         this._petGrade.info = _loc3_;
      }
      
      public function update2(param1:PetInfo) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:InventoryItemInfo = null;
         this.clearCell();
         var _loc4_:* = param1;
         this._petGrade.visible = _loc4_ != null;
         if(!_loc4_)
         {
            this._starBar.starNum(Boolean(_loc4_) ? int(_loc4_.StarLevel) : int(0));
            this._petBigItem.info = _loc4_;
            return;
         }
         this._starBar.starNum(Boolean(_loc4_) ? int(_loc4_.StarLevel) : int(0));
         this._petBigItem.info = _loc4_;
         var _loc5_:int = 0;
         while(_loc5_ < 3)
         {
            _loc2_ = _loc4_.equipList[_loc5_];
            if(Boolean(_loc2_))
            {
               _loc3_ = ItemManager.fill(_loc2_) as InventoryItemInfo;
               this.addPetEquip(_loc2_);
            }
            _loc5_++;
         }
         this._petGrade.info = _loc4_;
      }
      
      private function removeEvent() : void
      {
         var _loc1_:int = int(this._equipList.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this.getBagCell(this._equipList[_loc2_]).removeEventListener(CellEvent.DOUBLE_CLICK,this.doubleClickHander);
            _loc2_++;
         }
      }
      
      private function clearCell() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this.delPetEquip(_loc1_);
            _loc1_++;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._petBigItem))
         {
            ObjectUtils.disposeObject(this._petBigItem);
            this._petBigItem = null;
         }
         if(Boolean(this._equipLockBitmapData))
         {
            ObjectUtils.disposeObject(this._equipLockBitmapData);
            this._equipLockBitmapData = null;
         }
         if(Boolean(this._vbox))
         {
            ObjectUtils.disposeAllChildren(this._vbox);
            ObjectUtils.disposeObject(this._vbox);
            this._vbox = null;
         }
         if(Boolean(this._starBar))
         {
            ObjectUtils.disposeObject(this._starBar);
            this._starBar = null;
         }
         ObjectUtils.disposeObject(this._petGrade);
         this._petGrade = null;
         ObjectUtils.disposeAllChildren(this);
      }
   }
}
