package cardSystem.view.cardEquip
{
   import bagAndInfo.cell.DragEffect;
   import cardSystem.data.CardInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.display.Sprite;
   import road7th.data.DictionaryData;
   
   public class CardEquipDragArea extends Sprite implements IAcceptDrag
   {
       
      
      private var _view:cardSystem.view.cardEquip.CardEquipView;
      
      public function CardEquipDragArea(param1:cardSystem.view.cardEquip.CardEquipView)
      {
         super();
         this._view = param1;
         this.init();
      }
      
      private function init() : void
      {
         graphics.beginFill(65280,0);
         graphics.drawRect(-9,6,397,257);
         graphics.endFill();
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         var _loc2_:DictionaryData = null;
         var _loc3_:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            return;
         }
         var _loc4_:CardInfo = param1.data as CardInfo;
         if(Boolean(_loc4_))
         {
            if(_loc4_.templateInfo.Property8 == "1")
            {
               SocketManager.Instance.out.sendMoveCards(_loc4_.Place,0);
               param1.action = DragEffect.NONE;
            }
            else
            {
               _loc2_ = PlayerManager.Instance.Self.cardEquipDic;
               _loc3_ = 1;
               while(_loc3_ < 5)
               {
                  if((_loc2_[_loc3_] == null || _loc2_[_loc3_].Count < 0) && this._view._equipCells[_loc3_].open)
                  {
                     SocketManager.Instance.out.sendMoveCards(_loc4_.Place,_loc3_);
                     param1.action = DragEffect.NONE;
                     break;
                  }
                  if(_loc3_ == 4)
                  {
                     SocketManager.Instance.out.sendMoveCards(_loc4_.Place,1);
                     param1.action = DragEffect.NONE;
                  }
                  _loc3_++;
               }
               DragManager.acceptDrag(this);
            }
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
