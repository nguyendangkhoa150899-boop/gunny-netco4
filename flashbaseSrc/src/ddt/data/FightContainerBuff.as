package ddt.data
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.view.tips.BuffTipInfo;
   
   public class FightContainerBuff extends ddt.data.FightBuffInfo implements Disposeable
   {
       
      
      private var _buffs:Vector.<ddt.data.FightBuffInfo>;
      
      public function FightContainerBuff(param1:int)
      {
         this._buffs = new Vector.<FightBuffInfo>();
         super(param1);
         type = BuffType.Container;
      }
      
      public function addPayBuff(param1:ddt.data.FightBuffInfo) : void
      {
         this._buffs.push(param1);
      }
      
      public function get tipData() : Object
      {
         var _loc1_:BuffInfo = null;
         var _loc2_:ddt.data.FightBuffInfo = null;
         var _loc3_:BuffTipInfo = new BuffTipInfo();
         _loc3_.isActive = true;
         _loc3_.describe = LanguageMgr.GetTranslation("tank.view.buff.PayBuff.Note");
         _loc3_.name = LanguageMgr.GetTranslation("tank.view.buff.PayBuff.Name");
         _loc3_.isFree = false;
         var _loc4_:Vector.<BuffInfo> = new Vector.<BuffInfo>();
         for each(_loc2_ in this._buffs)
         {
            if(_loc2_.isSelf)
            {
               _loc1_ = PlayerManager.Instance.Self.getBuff(_loc2_.id);
               _loc1_.calculatePayBuffValidDay();
            }
            else
            {
               _loc1_ = new BuffInfo(_loc2_.id);
               _loc1_.day = _loc2_.data;
               _loc1_.isSelf = false;
            }
            _loc4_.push(_loc1_);
         }
         _loc3_.linkBuffs = _loc4_;
         return _loc3_;
      }
      
      public function dispose() : void
      {
         this._buffs.length = 0;
      }
   }
}
