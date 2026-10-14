package game.actions.SkillActions
{
   import com.pickgliss.effect.BaseEffect;
   import game.GameManager;
   import game.animations.IAnimate;
   import game.model.Living;
   import game.model.Player;
   import game.objects.MirariType;
   import game.view.effects.MirariEffectIconManager;
   import road7th.comm.PackageIn;
   
   public class ResolveHurtAction extends SkillAction
   {
       
      
      private var _pkg:PackageIn;
      
      private var _scr:Living;
      
      public function ResolveHurtAction(param1:IAnimate, param2:Living, param3:PackageIn)
      {
         this._pkg = param3;
         this._scr = param2;
         super(param1);
      }
      
      override protected function finish() : void
      {
         var _loc1_:Player = null;
         var _loc2_:BaseEffect = null;
         var _loc3_:Living = null;
         var _loc4_:int = this._pkg.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = GameManager.Instance.Current.findLiving(this._pkg.readInt());
            if(_loc3_.isPlayer() && _loc3_.isLiving)
            {
               _loc1_ = Player(_loc3_);
               _loc1_.handleMirariEffect(MirariEffectIconManager.getInstance().createEffectIcon(MirariType.ResolveHurt));
            }
            _loc5_++;
         }
         _loc1_ = Player(this._scr);
         _loc1_.handleMirariEffect(MirariEffectIconManager.getInstance().createEffectIcon(MirariType.ResolveHurt));
         super.finish();
      }
   }
}
