package store.forge.wishBead
{
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   
   public class WishBeadLeftDragSprite extends Sprite implements IAcceptDrag
   {
       
      
      public function WishBeadLeftDragSprite()
      {
         super();
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         var _loc2_:String = null;
         DragManager.acceptDrag(this,DragEffect.NONE);
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc3_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(_loc3_.BagType == BagInfo.EQUIPBAG)
         {
            _loc2_ = WishBeadManager.EQUIP_MOVE;
         }
         else
         {
            _loc2_ = WishBeadManager.ITEM_MOVE;
         }
         var _loc4_:WishBeadEvent = new WishBeadEvent(_loc2_);
         _loc4_.info = _loc3_;
         _loc4_.moveType = 1;
         WishBeadManager.instance.dispatchEvent(_loc4_);
      }
   }
}
