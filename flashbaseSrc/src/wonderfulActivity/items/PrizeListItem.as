package wonderfulActivity.items
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import wonderfulActivity.data.GiftRewardInfo;
   
   public class PrizeListItem extends Sprite implements Disposeable
   {
       
      
      private var index:int;
      
      private var _bg:Bitmap;
      
      private var _bagCell:BagCell;
      
      public function PrizeListItem()
      {
         super();
      }
      
      public function initView(param1:int) : void
      {
         this.index = param1;
         this._bg = ComponentFactory.Instance.creat("wonderful.accumulative.itemBG");
         addChild(this._bg);
         this._bagCell = new BagCell(param1);
         PositionUtils.setPos(this._bagCell,"wonderful.Accumulative.bagCellPos");
         this._bagCell.visible = false;
         addChild(this._bagCell);
      }
      
      public function setCellData(param1:GiftRewardInfo) : void
      {
         if(!param1)
         {
            this._bagCell.visible = false;
            return;
         }
         this._bagCell.visible = true;
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         _loc2_.TemplateID = param1.templateId;
         _loc2_ = ItemManager.fill(_loc2_);
         _loc2_.IsBinds = param1.isBind;
         _loc2_.ValidDate = param1.validDate;
         var _loc3_:Array = param1.property.split(",");
         _loc2_._StrengthenLevel = parseInt(_loc3_[0]);
         _loc2_.AttackCompose = parseInt(_loc3_[1]);
         _loc2_.DefendCompose = parseInt(_loc3_[2]);
         _loc2_.AgilityCompose = parseInt(_loc3_[3]);
         _loc2_.LuckCompose = parseInt(_loc3_[4]);
         this._bagCell.info = _loc2_;
         this._bagCell.setCount(param1.count);
         this._bagCell.setBgVisible(false);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._bagCell))
         {
            ObjectUtils.disposeObject(this._bagCell);
         }
         this._bagCell = null;
      }
   }
}
