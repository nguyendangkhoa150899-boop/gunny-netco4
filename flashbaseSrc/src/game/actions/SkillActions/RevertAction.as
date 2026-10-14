package game.actions.SkillActions
{
   import game.GameManager;
   import game.animations.IAnimate;
   import game.model.Living;
   import road7th.comm.PackageIn;
   
   public class RevertAction extends SkillAction
   {
       
      
      private var _pkg:PackageIn;
      
      private var _src:Living;
      
      public function RevertAction(param1:IAnimate, param2:Living, param3:PackageIn)
      {
         this._pkg = param3;
         this._src = param2;
         super(param1);
      }
      
      override protected function finish() : void
      {
         var _loc1_:Living = null;
         var _loc2_:int = this._pkg.readInt();
         var _loc3_:Vector.<Living> = new Vector.<Living>();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_.push(GameManager.Instance.Current.findLiving(this._pkg.readInt()));
            _loc4_++;
         }
         var _loc5_:int = this._pkg.readInt();
         for each(_loc1_ in _loc3_)
         {
            _loc1_.updateBlood(_loc1_.blood + _loc5_,0,_loc5_);
         }
         super.finish();
      }
   }
}
