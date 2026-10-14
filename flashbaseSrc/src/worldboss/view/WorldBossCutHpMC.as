package worldboss.view
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.setTimeout;
   
   public class WorldBossCutHpMC extends Sprite
   {
      
      public static const _space:int = 19;
       
      
      private var _num:Number;
      
      private var _type:int;
      
      private var _numBitmapArr:Array;
      
      public function WorldBossCutHpMC(param1:Number)
      {
         super();
         this._num = Math.abs(param1);
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:Bitmap = null;
         var _loc3_:Bitmap = null;
         _loc1_ = null;
         _loc1_ = null;
         this._numBitmapArr = new Array();
         var _loc2_:String = this._num.toString();
         _loc3_ = ComponentFactory.Instance.creatBitmap("worldboss.cutHP.valuNum10");
         this._numBitmapArr.push(_loc3_);
         _loc3_.alpha = 0;
         _loc3_.scaleX = 0.5;
         addChild(_loc3_);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc1_ = ComponentFactory.Instance.creatBitmap("worldboss.cutHP.valuNum" + _loc2_.charAt(_loc4_));
            _loc1_.x = _space * (_loc4_ + 1);
            _loc1_.alpha = 0;
            _loc1_.scaleX = 0.5;
            this._numBitmapArr.push(_loc1_);
            addChild(_loc1_);
            _loc4_++;
         }
         addEventListener(Event.ENTER_FRAME,this.actionOne);
      }
      
      private function actionOne(param1:Event) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._numBitmapArr.length)
         {
            if(this._numBitmapArr[_loc2_].alpha >= 1)
            {
               removeEventListener(Event.ENTER_FRAME,this.actionOne);
               setTimeout(this.actionTwo,500);
               return;
            }
            this._numBitmapArr[_loc2_].alpha += 0.2;
            this._numBitmapArr[_loc2_].scaleX += 0.1;
            this._numBitmapArr[_loc2_].x += 2;
            this._numBitmapArr[_loc2_].y -= 7;
            _loc2_++;
         }
      }
      
      private function actionTwo() : void
      {
         addEventListener(Event.ENTER_FRAME,this.actionTwoStart);
      }
      
      private function actionTwoStart(param1:Event) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._numBitmapArr.length)
         {
            if(this._numBitmapArr[_loc2_].alpha <= 0)
            {
               this.dispose();
               return;
            }
            this._numBitmapArr[_loc2_].alpha -= 0.2;
            this._numBitmapArr[_loc2_].y -= 7;
            _loc2_++;
         }
      }
      
      private function dispose() : void
      {
         var _loc1_:int = 0;
         removeEventListener(Event.ENTER_FRAME,this.actionTwoStart);
         if(Boolean(this._numBitmapArr))
         {
            _loc1_ = 0;
            while(_loc1_ < this._numBitmapArr.length)
            {
               removeChild(this._numBitmapArr[_loc1_]);
               this._numBitmapArr[_loc1_] = null;
               this._numBitmapArr.shift();
            }
            this._numBitmapArr = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
