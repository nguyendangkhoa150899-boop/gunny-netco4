package AvatarCollection.view
{
   import AvatarCollection.AvatarCollectionManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class AvatarCollectionLeftView extends Sprite implements Disposeable
   {
       
      
      private var _rightView:AvatarCollection.view.AvatarCollectionRightView;
      
      private var _decorateSelect:SelectedTextButton;
      
      private var _weaponSelect:SelectedTextButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _vbox:VBox;
      
      private var _unitList:Vector.<AvatarCollection.view.AvatarCollectionUnitView>;
      
      private var _costumeList:Vector.<AvatarCollection.view.AvatarCollectionUnitView>;
      
      private var _weaponList:Vector.<AvatarCollection.view.AvatarCollectionUnitView>;
      
      private var _weaponView:AvatarCollection.view.AvatarCollectionUnitWeaponView;
      
      public function AvatarCollectionLeftView(param1:AvatarCollection.view.AvatarCollectionRightView)
      {
         this._rightView = param1;
         super();
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         this._decorateSelect = ComponentFactory.Instance.creatComponentByStylename("avatarColl.menuSelectBtn");
         this._decorateSelect.text = LanguageMgr.GetTranslation("avatarCollection.select.decorate");
         PositionUtils.setPos(this._decorateSelect,"avatarColl.decorateSelectPos");
         this._weaponSelect = ComponentFactory.Instance.creatComponentByStylename("avatarColl.menuSelectBtn");
         this._weaponSelect.text = LanguageMgr.GetTranslation("avatarCollection.select.weapon");
         PositionUtils.setPos(this._weaponSelect,"avatarColl.weaponSelectPos");
         addChild(this._decorateSelect);
         addChild(this._weaponSelect);
         this._vbox = new VBox();
         PositionUtils.setPos(this._vbox,"avatarColl.mainView.vboxPos");
         this._vbox.spacing = 2;
         this._unitList = new Vector.<AvatarCollectionUnitView>();
         this._costumeList = new Vector.<AvatarCollectionUnitView>();
         _loc2_ = 1;
         while(_loc2_ <= 2)
         {
            _loc1_ = new AvatarCollection.view.AvatarCollectionUnitView(_loc2_,this._rightView);
            _loc1_.addEventListener("avatarCollectionUnitView_selected_change",this.clickRefreshView,false,0,true);
            this._vbox.addChild(_loc1_);
            this._unitList.push(_loc1_);
            this._costumeList.push(_loc1_);
            _loc2_++;
         }
         addChild(this._vbox);
         this._weaponList = new Vector.<AvatarCollectionUnitView>();
         this._weaponView = new AvatarCollection.view.AvatarCollectionUnitWeaponView(3,this._rightView);
         addChild(this._weaponView);
         PositionUtils.setPos(this._weaponView,"avatarColl.leftUnitViewPos");
         this._unitList.push(this._weaponView);
         this._weaponList.push(this._weaponView);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._decorateSelect);
         this._btnGroup.addSelectItem(this._weaponSelect);
         this._btnGroup.addEventListener("change",this.__changeHandler);
         this._btnGroup.selectIndex = 0;
      }
      
      private function __changeHandler(param1:Event) : void
      {
         AvatarCollectionManager.instance.resetListCellData();
         AvatarCollectionManager.instance.pageType = this._btnGroup.selectIndex;
         this._rightView.selectedAllBtn = false;
         switch(int(this._btnGroup.selectIndex))
         {
            case 0:
               this._weaponView.visible = false;
               this._vbox.visible = true;
               this._unitList[0].extendSelecteTheFirst();
               this.refreshView(this._unitList[0]);
               break;
            case 1:
               this._vbox.visible = false;
               this._weaponView.extendSelecteTheFirst();
               this._weaponView.visible = true;
         }
      }
      
      public function reset(param1:String) : void
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in this._unitList)
         {
            _loc2_[param1] = false;
         }
      }
      
      public function canBuyChange(param1:Boolean) : void
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in this._unitList)
         {
            _loc2_.isBuyFilter = param1;
         }
      }
      
      public function canActivityChange(param1:Boolean) : void
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in this._unitList)
         {
            _loc2_.isFilter = param1;
         }
      }
      
      private function clickRefreshView(param1:Event) : void
      {
         var _loc2_:AvatarCollection.view.AvatarCollectionUnitView = param1.target as AvatarCollectionUnitView;
         this.refreshView(_loc2_);
      }
      
      private function refreshView(param1:AvatarCollection.view.AvatarCollectionUnitView) : void
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in this._unitList)
         {
            if(_loc2_ != param1)
            {
               _loc2_.unextendHandler();
            }
         }
         this._vbox.arrange();
      }
      
      public function get unitList() : Vector.<AvatarCollection.view.AvatarCollectionUnitView>
      {
         if(AvatarCollectionManager.instance.pageType == 0)
         {
            return this._costumeList;
         }
         return this._weaponList;
      }
      
      public function dispose() : void
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in this._unitList)
         {
            _loc1_.removeEventListener("avatarCollectionUnitView_selected_change",this.clickRefreshView);
         }
         this._btnGroup.removeEventListener("change",this.__changeHandler);
         ObjectUtils.disposeObject(this._btnGroup);
         ObjectUtils.disposeAllChildren(this);
         this._weaponList = null;
         this._costumeList = null;
         this._rightView = null;
         this._vbox = null;
         this._unitList = null;
         this._decorateSelect = null;
         this._weaponSelect = null;
         this._btnGroup = null;
      }
   }
}
