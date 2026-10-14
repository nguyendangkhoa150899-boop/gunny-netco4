package littleGame.actions
{
   import littleGame.LittleGameManager;
   import littleGame.data.Grid;
   import littleGame.model.LittleLiving;
   import littleGame.model.LittlePlayer;
   import littleGame.model.LittleSelf;
   import littleGame.model.Scenario;
   import road7th.comm.PackageIn;
   
   public class InhaleAction extends LittleLivingMoveAction
   {
       
      
      private var _life:int = 0;
      
      private var _lifeTime:int = 0;
      
      private var _x:int;
      
      private var _y:int;
      
      private var _dx:int;
      
      private var _dy:int;
      
      private var _endAction:String;
      
      private var _direction:String;
      
      private var _headType:int;
      
      public function InhaleAction()
      {
         super(null,null,null);
      }
      
      override public function parsePackege(param1:Scenario, param2:PackageIn = null) : void
      {
         var _loc3_:int = 0;
         _scene = param1;
         _grid = _scene != null ? _scene.grid : null;
         _loc3_ = param2.readInt();
         this._endAction = param2.readUTF();
         this._direction = param2.readUTF();
         this._life = param2.readInt();
         this._dx = param2.readInt();
         this._dy = param2.readInt();
         _living = _scene != null ? _scene.findLiving(_loc3_) : null;
         if(_living != null)
         {
            _living.act(this);
            if(Boolean(_living))
            {
               _living.dx = this._dx;
               _living.dy = this._dy;
            }
         }
      }
      
      override public function prepare() : void
      {
         if(Boolean(_living))
         {
            _path = LittleGameManager.Instance.fillPath(_living,_grid,_living.pos.x,_living.pos.y,this._dx,this._dy);
            _living.dx = this._dx;
            _living.dy = this._dy;
            if(_path == null)
            {
               this.finish();
            }
            else
            {
               _living.MotionState = 1;
               if(_living.isSelf)
               {
                  LittleSelf(_living).inhaled = true;
               }
            }
         }
         this._headType = Math.random() * 10000 % 3;
         super.prepare();
      }
      
      public function toString() : String
      {
         return "[InhaleAction_" + _living + ":(dx:" + this._dx + ";dy:" + this._dy + ";len:" + (_path == null ? "" : _path.length) + ";life:" + this._life + ";endAction:" + this._endAction + ")]";
      }
      
      override public function execute() : void
      {
         if(Boolean(_living) && _living.lock)
         {
            this.finish();
         }
         else if(Boolean(_living) && this._life > 0)
         {
            _living.direction = this._direction;
            if(_living.isPlayer)
            {
               LittlePlayer(_living).headType = this._headType;
            }
            _living.doAction(this._endAction);
            ++this._lifeTime;
            if(this._lifeTime >= this._life)
            {
               this.finish();
            }
         }
         else if(Boolean(_living))
         {
            super.execute();
         }
      }
      
      override protected function finish() : void
      {
         _isFinished = true;
         if(this._life > 0)
         {
            _living.MotionState = 2;
            _living.doAction("stand");
         }
         else
         {
            _living.direction = this._direction;
            if(_living.isPlayer)
            {
               LittlePlayer(_living).headType = this._headType;
            }
            _living.doAction(this._endAction);
         }
         _living = null;
      }
   }
}
