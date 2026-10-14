package ddt.states
{
   import com.greensock.TweenLite;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.QQtipsManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import pet.sprite.PetSpriteController;
   import trainer.view.NewHandContainer;
   
   public class BaseStateView extends Sprite
   {
       
      
      private var _prepared:Boolean;
      
      private var _container:Sprite;
      
      private var _timer:Timer;
      
      private var _size:int = 60;
      
      private var _completed:int = 0;
      
      private var _shapes:Vector.<DisplayObject>;
      
      private var _oldStageWidth:int;
      
      public function BaseStateView()
      {
         super();
         this._container = new Sprite();
      }
      
      public function get prepared() : Boolean
      {
         return this._prepared;
      }
      
      public function check(param1:String) : Boolean
      {
         return true;
      }
      
      public function prepare() : void
      {
         this._prepared = true;
      }
      
      public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         if(this.getType() != StateType.ROOM_LOADING)
         {
            SoundManager.instance.playMusic("062",true,false);
         }
         QQtipsManager.instance.checkStateView(this.getType());
         this.playEnterMovie();
         PetSpriteController.Instance.showPetSprite(true,false);
      }
      
      private function playEnterMovie() : void
      {
         this._completed = 0;
         if(this._shapes == null || StageReferance.stageWidth != this._oldStageWidth)
         {
            this.createShapes();
            this._oldStageWidth = StageReferance.stageWidth;
         }
         this.rebackInitState();
         this._container.visible = true;
         LayerManager.Instance.addToLayer(this._container,LayerManager.STAGE_TOP_LAYER,false,0,true);
         this._timer = new Timer(20);
         this._timer.addEventListener(TimerEvent.TIMER,this.__tick);
         this._timer.start();
      }
      
      private function createShapes() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Bitmap = null;
         var _loc5_:BitmapData = new BitmapData(this._size,this._size,false,0);
         if(Boolean(this._shapes))
         {
            _loc3_ = 0;
            while(_loc3_ < this._shapes.length)
            {
               ObjectUtils.disposeObject(this._shapes[_loc3_]);
               this._shapes[_loc3_] = null;
               _loc3_++;
            }
            this._shapes = null;
         }
         this._shapes = new Vector.<DisplayObject>();
         do
         {
            _loc2_ = 0;
            do
            {
               _loc4_ = new Bitmap(_loc5_);
               this._shapes.push(_loc4_);
               _loc2_ += this._size;
            }
            while(_loc2_ < StageReferance.stageHeight);
            
            _loc1_ += this._size;
         }
         while(_loc1_ < StageReferance.stageWidth);
         
      }
      
      private function rebackInitState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         _loc2_ = 0;
         _loc1_ = 0;
         var _loc3_:int = 0;
         _loc2_ = 0;
         _loc1_ = 0;
         do
         {
            _loc2_ = 0;
            do
            {
               this._shapes[_loc1_].width = this._size;
               this._shapes[_loc1_].height = this._size;
               this._shapes[_loc1_].x = _loc3_;
               this._shapes[_loc1_].y = _loc2_;
               this._shapes[_loc1_].alpha = 1;
               this._container.addChild(this._shapes[_loc1_]);
               _loc2_ += this._size;
               _loc1_++;
            }
            while(_loc2_ < StageReferance.stageHeight);
            
            _loc3_ += this._size;
         }
         while(_loc3_ < StageReferance.stageWidth);
         
      }
      
      private function __tick(param1:TimerEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:DisplayObject = null;
         var _loc6_:int = this._timer.currentCount - 1;
         if(_loc6_ >= 0)
         {
            if(this._size * _loc6_ < StageReferance.stageWidth)
            {
               _loc2_ = Math.floor(StageReferance.stageHeight / this._size);
               _loc3_ = this._size >> 1;
               _loc4_ = 0;
               while(_loc4_ < _loc2_)
               {
                  _loc5_ = this._shapes[_loc4_ + _loc2_ * _loc6_];
                  TweenLite.to(_loc5_,0.7,{
                     "x":_loc5_.x + _loc3_,
                     "y":_loc5_.y + _loc3_,
                     "width":0,
                     "height":0,
                     "alpha":0,
                     "onComplete":this.shapeTweenComplete
                  });
                  _loc4_++;
               }
            }
            else
            {
               this._timer.stop();
               this._timer.removeEventListener(TimerEvent.TIMER,this.__tick);
            }
         }
      }
      
      private function shapeTweenComplete() : void
      {
         ++this._completed;
         if(this._completed >= this._shapes.length)
         {
            this._container.visible = false;
         }
      }
      
      public function addedToStage() : void
      {
      }
      
      public function leaving(param1:BaseStateView) : void
      {
         NewHandContainer.Instance.clearArrowByID(-1);
         PetSpriteController.Instance.hidePetSprite(true,false);
      }
      
      public function checkDispose(param1:String) : void
      {
         var _loc2_:StateCreater = new StateCreater();
         var _loc3_:Array = _loc2_.getNeededUIModuleByType(param1).split(",");
         _loc2_ = null;
         _loc3_ = null;
      }
      
      public function removedFromStage() : void
      {
      }
      
      public function getView() : DisplayObject
      {
         return this;
      }
      
      public function getType() : String
      {
         return StateType.DEAFULT;
      }
      
      public function getBackType() : String
      {
         return "";
      }
      
      public function goBack() : Boolean
      {
         return false;
      }
      
      public function fadingComplete() : void
      {
      }
      
      public function dispose() : void
      {
      }
      
      public function refresh() : void
      {
         this.playEnterMovie();
      }
   }
}
