package explorerManual.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CEvent;
   import explorerManual.ExplorerManualManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ManualRightMenu extends Sprite implements Disposeable
   {
      
      public static const ITEM_CLICK:String = "itemClick";
       
      
      private var _selectBtn:explorerManual.view.ManualMenuItem;
      
      private var _vbox:VBox;
      
      private var _items:Array;
      
      private var _btnGroups:SelectedButtonGroup;
      
      public function ManualRightMenu()
      {
         this._items = [0,1001,1002,1003,1004,1005];
         super();
         this._btnGroups = new SelectedButtonGroup();
         this.initView();
      }
      
      private function initView() : void
      {
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("explorerManual.manualRightMenu.vBox");
         addChild(this._vbox);
         this.initMenu();
      }
      
      private function __itemClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         if(param1.target is ManualMenuItem)
         {
            _loc2_ = param1.target as ManualMenuItem;
            this.dispatchEvent(new CEvent("itemClick",_loc2_.chapter));
            _loc2_.isHaveNewDebris = false;
            ExplorerManualManager.instance.removeNewDebris(_loc2_.chapter);
         }
      }
      
      private function initMenu() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this._items.length)
         {
            this._selectBtn = ComponentFactory.Instance.creatComponentByStylename("explorerManual.manualRightMenu.selBtn" + _loc1_);
            this._selectBtn.chapter = this._items[_loc1_];
            this._selectBtn.isHaveNewDebris = ExplorerManualManager.instance.isHaveNewDebris(this._items[_loc1_]);
            this._selectBtn.addEventListener("click",this.__itemClickHandler);
            this._vbox.addChild(this._selectBtn);
            this._btnGroups.addSelectItem(this._selectBtn);
            _loc1_++;
         }
      }
      
      public function set selectItem(param1:int) : void
      {
         this._btnGroups.selectIndex = this._items.indexOf(param1);
      }
      
      public function dispose() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         if(Boolean(this._vbox))
         {
            _loc2_ = 0;
            while(_loc2_ < this._vbox.numChildren)
            {
               if(this._vbox.getChildAt(_loc2_) is ManualMenuItem)
               {
                  _loc1_ = this._vbox.getChildAt(_loc2_) as ManualMenuItem;
                  _loc1_.removeEventListener("click",this.__itemClickHandler);
                  ObjectUtils.disposeObject(_loc1_);
               }
               _loc2_++;
            }
         }
         ObjectUtils.removeChildAllChildren(this._vbox);
         this._vbox = null;
         if(Boolean(this._btnGroups))
         {
            this._btnGroups.dispose();
         }
         this._btnGroups = null;
         this._selectBtn = null;
      }
   }
}
