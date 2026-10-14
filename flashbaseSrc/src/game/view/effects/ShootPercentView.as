package game.view.effects
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.GameManager;
   
   public class ShootPercentView extends Sprite
   {
       
      
      private var _type:int;
      
      private var _isAdd:Boolean;
      
      private var _picBmp:Bitmap;
      
      private var add:Boolean = true;
      
      private var tmp:int = 0;
      
      public function ShootPercentView(param1:int, param2:int = 1, param3:Boolean = false)
      {
         super();
         this._type = param2;
         this._isAdd = param3;
         this._picBmp = this.getPercent(param1);
         this.addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         if(this._picBmp != null)
         {
            addChild(this._picBmp);
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._picBmp))
         {
            removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
            this._picBmp.bitmapData.dispose();
            removeChild(this._picBmp);
            this._picBmp = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function __addToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         if(this._picBmp == null)
         {
            return;
         }
         if(this._type == 1)
         {
            this._picBmp.x = -70;
            this._picBmp.y = -20;
         }
         else
         {
            this._picBmp.scaleX = this._picBmp.scaleY = 0.5;
         }
         this._picBmp.alpha = 0;
         addEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      private function __enterFrame(param1:Event) : void
      {
         if(this._type == 1)
         {
            this.doShowType1();
         }
         else
         {
            this.doShowType2();
         }
      }
      
      private function doShowType1() : void
      {
         if(this._picBmp.alpha > 0.95)
         {
            ++this.tmp;
            if(this.tmp == 20)
            {
               this.add = false;
               this._picBmp.alpha = 0.9;
            }
         }
         if(this._picBmp.alpha < 1)
         {
            if(this.add)
            {
               this._picBmp.y -= 8;
               this._picBmp.alpha += 0.22;
            }
            else
            {
               this._picBmp.y -= 6;
               this._picBmp.alpha -= 0.1;
            }
         }
         if(this._picBmp.alpha < 0.05)
         {
            this.dispose();
         }
      }
      
      private function doShowType2() : void
      {
         if(this._picBmp.alpha > 0.95)
         {
            ++this.tmp;
            if(this.tmp == 20)
            {
               this.add = false;
               this._picBmp.alpha = 0.9;
            }
         }
         if(this._picBmp.alpha < 1)
         {
            if(this.add)
            {
               this._picBmp.scaleX = this._picBmp.scaleY = this._picBmp.scaleY + 0.24;
               this._picBmp.alpha += 0.4;
            }
            else
            {
               this._picBmp.scaleX = this._picBmp.scaleY = this._picBmp.scaleY + 0.125;
               this._picBmp.alpha -= 0.15;
            }
            this._picBmp.x = -this._picBmp.width / 2 + 10;
            this._picBmp.y = -this._picBmp.height / 2;
         }
         if(this._picBmp.alpha < 0.05)
         {
            this.dispose();
         }
      }
      
      public function getPercent(param1:int) : Bitmap
      {
         var _loc2_:Array = null;
         var _loc3_:Bitmap = null;
         var _loc4_:Bitmap = null;
         _loc2_ = null;
         _loc3_ = null;
         _loc4_ = null;
         var _loc5_:Bitmap = null;
         if(param1 > 99999999)
         {
            return null;
         }
         var _loc6_:Sprite = new Sprite();
         _loc2_ = new Array();
         _loc2_ = [0,0,0,0];
         _loc6_.mouseChildren = _loc6_.mouseEnabled = false;
         if(this._type == 2)
         {
            if(!this._isAdd)
            {
               _loc3_ = ComponentFactory.Instance.creatBitmap("asset.game.redNumberBackgoundAsset") as Bitmap;
               _loc3_.x += 5;
               _loc3_.y = -10;
               _loc2_.push(_loc3_);
            }
         }
         var _loc7_:String = String(param1);
         var _loc8_:int = _loc7_.length;
         var _loc9_:int = 33 + (4 - _loc8_) * 10;
         if(this._isAdd)
         {
            _loc7_ = " " + _loc7_;
            _loc8_ += 1;
            _loc9_ -= 10;
            _loc4_ = ComponentFactory.Instance.creatBitmap("asset.game.addBloodIconAsset") as Bitmap;
            _loc4_.x = _loc9_;
            _loc4_.y = 20;
            _loc2_.push(_loc4_);
         }
         var _loc10_:int = this._isAdd ? int(1) : int(0);
         while(_loc10_ < _loc8_)
         {
            if(this._isAdd)
            {
               _loc5_ = GameManager.Instance.numCreater.createGreenNum(int(_loc7_.charAt(_loc10_)));
            }
            else
            {
               _loc5_ = GameManager.Instance.numCreater.createRedNum(int(_loc7_.charAt(_loc10_)));
            }
            _loc5_.smoothing = true;
            _loc5_.x = _loc9_ + _loc10_ * 20;
            _loc5_.y = 20;
            _loc2_.push(_loc5_);
            _loc10_++;
         }
         _loc2_ = this.returnNum(_loc2_);
         var _loc11_:BitmapData = new BitmapData(_loc2_[2],_loc2_[3],true,0);
         this._picBmp = new Bitmap(_loc11_,"auto",true);
         _loc10_ = 4;
         while(_loc10_ < _loc2_.length)
         {
            _loc11_.copyPixels(_loc2_[_loc10_].bitmapData,new Rectangle(0,0,_loc2_[_loc10_].width,_loc2_[_loc10_].height),new Point(_loc2_[_loc10_].x - _loc2_[0],_loc2_[_loc10_].y - _loc2_[1]),null,null,true);
            _loc10_++;
         }
         this._picBmp.x = _loc2_[0];
         this._picBmp.y = _loc2_[1];
         _loc2_ = null;
         return this._picBmp;
      }
      
      private function returnNum(param1:Array) : Array
      {
         var _loc2_:int = 4;
         while(_loc2_ < param1.length)
         {
            param1[0] = param1[0] > param1[_loc2_].x ? param1[_loc2_].x : param1[0];
            param1[1] = param1[1] > param1[_loc2_].y ? param1[_loc2_].y : param1[1];
            param1[2] = param1[2] > param1[_loc2_].width + param1[_loc2_].x ? param1[2] : param1[_loc2_].width + param1[_loc2_].x;
            param1[3] = param1[3] > param1[_loc2_].height + param1[_loc2_].y ? param1[3] : param1[_loc2_].height + param1[_loc2_].y;
            _loc2_++;
         }
         param1[2] -= param1[0];
         param1[3] -= param1[1];
         return param1;
      }
   }
}
