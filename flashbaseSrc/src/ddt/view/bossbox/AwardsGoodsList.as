package ddt.view.bossbox
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.MessageTipManager;
   import flash.display.Sprite;
   
   public class AwardsGoodsList extends Sprite implements Disposeable
   {
       
      
      private var _goodsList:Array;
      
      private var _list:SimpleTileList;
      
      private var panel:ScrollPanel;
      
      private var _cells:Array;
      
      public function AwardsGoodsList()
      {
         super();
         this.initList();
      }
      
      protected function initList() : void
      {
         this._list = new SimpleTileList(2);
         this._list.vSpace = 12;
         this._list.hSpace = 110;
         this.panel = ComponentFactory.Instance.creat("TimeBoxScrollpanel");
         addChild(this.panel);
      }
      
      public function show(param1:Array) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:BoxAwardsCell = null;
         var _loc4_:BoxGoodsTempInfo = null;
         this._goodsList = param1;
         this._cells = new Array();
         this._list.beginChanges();
         var _loc5_:int = 0;
         while(_loc5_ < this._goodsList.length)
         {
            if(this._goodsList[_loc5_] is InventoryItemInfo)
            {
               _loc2_ = this._goodsList[_loc5_];
               _loc2_.IsJudge = true;
            }
            else
            {
               _loc4_ = this._goodsList[_loc5_] as BoxGoodsTempInfo;
               _loc2_ = this.getTemplateInfo(_loc4_.TemplateId) as InventoryItemInfo;
               _loc2_.IsBinds = _loc4_.IsBind;
               _loc2_.LuckCompose = _loc4_.LuckCompose;
               _loc2_.DefendCompose = _loc4_.DefendCompose;
               _loc2_.AttackCompose = _loc4_.AttackCompose;
               _loc2_.AgilityCompose = _loc4_.AgilityCompose;
               _loc2_.StrengthenLevel = _loc4_.StrengthenLevel;
               _loc2_.ValidDate = _loc4_.ItemValid;
               _loc2_.IsJudge = true;
               _loc2_.Count = _loc4_.ItemCount;
            }
            _loc3_ = ComponentFactory.Instance.creatCustomObject("bossbox.BoxAwardsCell");
            _loc3_.info = _loc2_;
            _loc3_.count = _loc2_.Count;
            this._list.addChild(_loc3_);
            this._cells.push(_loc3_);
            _loc5_++;
         }
         this._list.commitChanges();
         this.panel.beginChanges();
         this.panel.setView(this._list);
         this.panel.hScrollProxy = ScrollPanel.OFF;
         this.panel.vScrollProxy = this._goodsList.length > 6 ? int(ScrollPanel.ON) : int(ScrollPanel.OFF);
         this.panel.commitChanges();
      }
      
      public function showForVipLevelUpAward(param1:Array) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:VipBoxAwardsCell = null;
         var _loc4_:BoxGoodsTempInfo = null;
         this._goodsList = param1;
         this._cells = new Array();
         this._list.dispose();
         this._list = new SimpleTileList(3);
         this._list.vSpace = 12;
         this._list.hSpace = 110;
         this._list.beginChanges();
         var _loc5_:int = 0;
         while(_loc5_ < this._goodsList.length)
         {
            if(this._goodsList[_loc5_] is InventoryItemInfo)
            {
               _loc2_ = this._goodsList[_loc5_];
               _loc2_.IsJudge = true;
            }
            else
            {
               _loc4_ = this._goodsList[_loc5_] as BoxGoodsTempInfo;
               _loc2_ = this.getTemplateInfo(_loc4_.TemplateId) as InventoryItemInfo;
               _loc2_.IsBinds = _loc4_.IsBind;
               _loc2_.LuckCompose = _loc4_.LuckCompose;
               _loc2_.DefendCompose = _loc4_.DefendCompose;
               _loc2_.AttackCompose = _loc4_.AttackCompose;
               _loc2_.AgilityCompose = _loc4_.AgilityCompose;
               _loc2_.StrengthenLevel = _loc4_.StrengthenLevel;
               _loc2_.ValidDate = _loc4_.ItemValid;
               _loc2_.IsJudge = true;
               _loc2_.Count = _loc4_.ItemCount;
            }
            _loc3_ = ComponentFactory.Instance.creatCustomObject("vip.BoxAwardsCell");
            _loc3_.info = _loc2_;
            _loc3_.count = _loc2_.Count;
            this._list.addChild(_loc3_);
            this._cells.push(_loc3_);
            _loc5_++;
         }
         this._list.commitChanges();
         this.panel.beginChanges();
         this.panel.width = 488;
         this.panel.height = 178;
         this.panel.setView(this._list);
         this.panel.hScrollProxy = ScrollPanel.OFF;
         this.panel.vScrollProxy = ScrollPanel.OFF;
         this.panel.commitChanges();
      }
      
      public function showForVipAward(param1:Array) : void
      {
         var _loc2_:BoxAwardsCell = null;
         var _loc3_:int = 0;
         _loc2_ = null;
         this._goodsList = param1;
         this._cells = new Array();
         this._list.dispose();
         this._list = new SimpleTileList(3);
         this._list.vSpace = 12;
         this._list.hSpace = 110;
         this._list.beginChanges();
         _loc3_ = 0;
         if(param1 != null)
         {
            while(_loc3_ < this._goodsList.length)
            {
               _loc2_ = ComponentFactory.Instance.creatCustomObject("bossbox.BoxAwardsCell");
               _loc2_.mouseChildren = false;
               _loc2_.mouseEnabled = false;
               _loc2_.info = ItemManager.Instance.getTemplateById(BoxGoodsTempInfo(this._goodsList[_loc3_]).TemplateId);
               _loc2_.count = 1;
               _loc2_.itemName = ItemManager.Instance.getTemplateById(BoxGoodsTempInfo(this._goodsList[_loc3_]).TemplateId).Name + "X" + String(BoxGoodsTempInfo(this._goodsList[_loc3_]).ItemCount);
               this._list.addChild(_loc2_);
               this._cells.push(_loc2_);
               _loc3_++;
            }
         }
         else
         {
            MessageTipManager.getInstance().show("Bạn Gì Gì Đấy Đẹp Trai Ơi... Mau Mau Tăng Lên VIP1 Điii!!!");
         }
         this._list.commitChanges();
         this.panel.beginChanges();
         this.panel.width = 488;
         this.panel.height = 178;
         this.panel.setView(this._list);
         this.panel.hScrollProxy = ScrollPanel.OFF;
         this.panel.vScrollProxy = ScrollPanel.OFF;
         this.panel.commitChanges();
      }
      
      private function getTemplateInfo(param1:int) : InventoryItemInfo
      {
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         _loc2_.TemplateID = param1;
         ItemManager.fill(_loc2_);
         return _loc2_;
      }
      
      public function dispose() : void
      {
         var _loc1_:BoxAwardsCell = null;
         for each(_loc1_ in this._cells)
         {
            _loc1_.dispose();
         }
         this._cells.splice(0,this._cells.length);
         this._cells = null;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this.panel))
         {
            ObjectUtils.disposeObject(this.panel);
         }
         this.panel = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
