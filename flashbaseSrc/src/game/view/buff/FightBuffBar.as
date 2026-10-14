package game.view.buff
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.FightBuffInfo;
   import flash.display.Sprite;
   
   public class FightBuffBar extends Sprite implements Disposeable
   {
       
      
      private var _buffCells:Vector.<game.view.buff.BuffCell>;
      
      public function FightBuffBar()
      {
         this._buffCells = new Vector.<BuffCell>();
         super();
         mouseChildren = mouseEnabled = false;
      }
      
      private function clearBuff() : void
      {
         var _loc1_:game.view.buff.BuffCell = null;
         for each(_loc1_ in this._buffCells)
         {
            _loc1_.clearSelf();
         }
      }
      
      private function drawBuff() : void
      {
      }
      
      public function update(param1:Vector.<FightBuffInfo>) : void
      {
         var _loc3_:game.view.buff.BuffCell = null;
         var _loc2_:int = 0;
         _loc3_ = null;
         this.clearBuff();
         var _loc4_:int = int(param1.length);
         var _loc5_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            if(_loc2_ + 1 > this._buffCells.length)
            {
               _loc3_ = new game.view.buff.BuffCell();
               this._buffCells.push(_loc3_);
            }
            else
            {
               _loc3_ = this._buffCells[_loc2_];
            }
            _loc3_.setInfo(param1[_loc2_]);
            _loc3_.x = (_loc2_ & 3) * 24;
            _loc3_.y = -(_loc2_ >> 2) * 24;
            addChild(_loc3_);
            _loc2_++;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:game.view.buff.BuffCell = this._buffCells.shift();
         while(Boolean(_loc1_))
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = this._buffCells.shift();
         }
         this._buffCells = null;
      }
   }
}
