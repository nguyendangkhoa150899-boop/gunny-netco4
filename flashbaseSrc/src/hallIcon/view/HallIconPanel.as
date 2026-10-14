package hallIcon.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import hallIcon.HallIconManager;
   
   public class HallIconPanel extends Sprite implements Disposeable
   {
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
      
      public static const BOTTOM:String = "bottom";
       
      
      private var _mainIcon:DisplayObject;
      
      private var _mainIconString:String;
      
      private var _hotNumBg:Bitmap;
      
      private var _hotNum:FilterFrameText;
      
      private var _iconArray:Array;
      
      private var _iconBox:hallIcon.view.HallIconBox;
      
      private var direction:String;
      
      private var vNum:int;
      
      private var hNum:int;
      
      private var WHSize:Array;
      
      private var tweenLiteMax:TweenLite;
      
      private var tweenLiteSmall:TweenLite;
      
      private var isExpand:Boolean;
      
      public function HallIconPanel(param1:String, param2:String = "left", param3:int = -1, param4:int = -1, param5:Array = null)
      {
         super();
         this._mainIconString = param1;
         this.direction = param2;
         this.hNum = param3;
         this.vNum = param4;
         if(this.hNum == -1 && this.vNum == -1)
         {
            this.vNum = 1;
         }
         if(param5 == null)
         {
            param5 = [78,78];
         }
         this.WHSize = param5;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._mainIcon = ComponentFactory.Instance.creat(this._mainIconString);
         if(this._mainIcon is Sprite)
         {
            Sprite(this._mainIcon).buttonMode = true;
            Sprite(this._mainIcon).mouseChildren = false;
         }
         addChild(this._mainIcon);
         this._hotNumBg = ComponentFactory.Instance.creatBitmap("assets.hallIcon.hotNumBg");
         addChild(this._hotNumBg);
         this._hotNum = ComponentFactory.Instance.creatComponentByStylename("hallicon.hallIconPanel.hotNum");
         this._hotNum.text = "0";
         addChild(this._hotNum);
         this.updateHotNum();
         this._iconArray = new Array();
         this._iconBox = new hallIcon.view.HallIconBox();
         this._iconBox.visible = false;
         addChild(this._iconBox);
      }
      
      private function initEvent() : void
      {
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__mainIconHandler);
      }
      
      public function addIcon(param1:DisplayObject, param2:String, param3:int = 0, param4:Boolean = false) : DisplayObject
      {
         this._iconBox.addChild(param1);
         var _loc5_:Object = {};
         _loc5_.icon = param1;
         _loc5_.icontype = param2;
         _loc5_.orderId = param3;
         _loc5_.flag = param4;
         this._iconArray.push(_loc5_);
         this.arrange();
         return param1;
      }
      
      public function getIconByType(param1:String) : DisplayObject
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         while(_loc4_ < this._iconArray.length)
         {
            _loc3_ = String(this._iconArray[_loc4_].icontype);
            if(_loc3_ == param1)
            {
               _loc2_ = this._iconArray[_loc4_].icon;
               break;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function removeIconByType(param1:String) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < this._iconArray.length)
         {
            _loc3_ = String(this._iconArray[_loc5_].icontype);
            if(_loc3_ == param1)
            {
               _loc2_ = this._iconArray[_loc5_].icon;
               this._iconArray.splice(_loc5_,1);
               break;
            }
            _loc5_++;
         }
         if(Boolean(_loc2_))
         {
            _loc4_ = this._iconBox.getChildIndex(_loc2_);
            if(_loc4_ != -1)
            {
               this._iconBox.removeChildAt(_loc4_);
            }
         }
         if(Boolean(_loc2_))
         {
            ObjectUtils.disposeObject(_loc2_);
         }
         this.arrange();
      }
      
      public function arrange() : void
      {
         this.iconSortOn();
         this.updateIconsPos();
         if(this.isExpand)
         {
            this.updateDirectionPos();
         }
         this.updateHotNum();
      }
      
      private function updateIconsPos() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._iconArray.length)
         {
            _loc1_ = this._iconArray[_loc2_].icon;
            if(this.hNum == -1)
            {
               _loc1_.x = _loc2_ * this.WHSize[0];
            }
            else
            {
               _loc1_.x = int(_loc2_ % this.hNum) * this.WHSize[0];
            }
            if(this.vNum == -1)
            {
               _loc1_.y = int(_loc2_ / this.hNum) * this.WHSize[1];
            }
            else
            {
               _loc1_.y = _loc2_ * this.WHSize[1];
            }
            _loc2_++;
         }
      }
      
      private function updateDirectionPos() : void
      {
         if(this.direction == LEFT)
         {
            this._iconBox.x = -this.getIconSpriteWidth() - 10;
            this._iconBox.y = -(this.getIconSpriteHeight() - this.WHSize[1]) / 2;
         }
         else if(this.direction == RIGHT)
         {
            this._iconBox.x = this._mainIcon.x + this._mainIcon.width + 10;
            this._iconBox.y = -(this.getIconSpriteHeight() - this.WHSize[1]) / 2;
         }
         else if(this.direction == BOTTOM)
         {
            if(HallIconManager.instance.model.firstRechargeIsOpen && Boolean(this._iconArray[0].flag))
            {
               this._iconBox.x = -350;
            }
            else
            {
               this._iconBox.x = -(this.getIconSpriteWidth() - this.WHSize[0]);
            }
            this._iconBox.y = this._mainIcon.y + this.WHSize[1] + 5;
         }
      }
      
      public function iconSortOn() : void
      {
         if(this._iconArray.length > 1)
         {
            this._iconArray.sort(this.sortFunctin);
         }
      }
      
      private function sortFunctin(param1:Object, param2:Object) : Number
      {
         if(param1.orderId > param2.orderId)
         {
            return 1;
         }
         if(param1.orderId < param2.orderId)
         {
            return -1;
         }
         return 0;
      }
      
      public function expand(param1:Boolean) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         _loc2_ = NaN;
         _loc3_ = NaN;
         _loc2_ = NaN;
         _loc3_ = NaN;
         _loc2_ = NaN;
         if(this.isExpand != param1 && this._iconArray && this._iconArray.length > 0)
         {
            this.isExpand = param1;
            if(this.isExpand)
            {
               _loc3_ = 0;
               _loc2_ = 0;
               if(this.direction == LEFT)
               {
                  _loc3_ = -this.getIconSpriteWidth() - 10;
                  _loc2_ = -(this.getIconSpriteHeight() - this.WHSize[1]) / 2;
               }
               else if(this.direction == RIGHT)
               {
                  _loc3_ = this._mainIcon.x + this._mainIcon.width + 10;
                  _loc2_ = -(this.getIconSpriteHeight() - this.WHSize[1]) / 2;
               }
               else if(this.direction == BOTTOM)
               {
                  if(HallIconManager.instance.model.firstRechargeIsOpen && Boolean(this._iconArray[0].flag))
                  {
                     _loc3_ = -350;
                  }
                  else
                  {
                     _loc3_ = -(this.getIconSpriteWidth() - this.WHSize[0]);
                  }
                  _loc2_ = this._mainIcon.y + this.WHSize[1] + 5;
               }
               this._iconBox.x = this._mainIcon.x;
               this._iconBox.y = 0;
               this._iconBox.scaleX = 0;
               this._iconBox.scaleY = 0;
               this._iconBox.alpha = 0;
               this._iconBox.visible = true;
               this.tweenLiteMax = TweenLite.to(this._iconBox,0.2,{
                  "x":_loc3_,
                  "y":_loc2_,
                  "alpha":1,
                  "scaleX":1,
                  "scaleY":1,
                  "onComplete":this.tweenLiteMaxCloseComplete
               });
            }
            else
            {
               this.tweenLiteSmall = TweenLite.to(this._iconBox,0.2,{
                  "x":this._mainIcon.x,
                  "y":0,
                  "alpha":0,
                  "scaleX":0,
                  "scaleY":0,
                  "onComplete":this.tweenLiteSmallCloseComplete
               });
            }
         }
      }
      
      private function tweenLiteSmallCloseComplete() : void
      {
         this.killTweenLiteSmall();
         this._iconBox.visible = false;
      }
      
      private function tweenLiteMaxCloseComplete() : void
      {
         this.killTweenLiteMax();
      }
      
      private function getIconSpriteWidth() : Number
      {
         var _loc1_:Number = 0;
         if(this._iconArray.length == 0)
         {
            _loc1_ = 0;
         }
         else if(this.hNum == -1)
         {
            _loc1_ = this._iconArray.length * this.WHSize[0];
         }
         else if(this._iconArray.length >= this.hNum)
         {
            _loc1_ = this.hNum * this.WHSize[0];
         }
         else
         {
            _loc1_ = this._iconArray.length * this.WHSize[0];
         }
         return _loc1_;
      }
      
      private function getIconSpriteHeight() : Number
      {
         var _loc1_:int = 0;
         var _loc2_:Number = 0;
         if(this._iconArray.length == 0)
         {
            _loc2_ = 0;
         }
         else if(this.hNum == -1)
         {
            _loc2_ = Number(this.WHSize[1]);
         }
         else if(this._iconArray.length >= this.hNum)
         {
            _loc1_ = this._iconArray.length / this.hNum;
            if(Boolean(this._iconArray.length % this.hNum))
            {
               _loc1_ += 1;
            }
            _loc2_ = _loc1_ * this.WHSize[1];
         }
         else
         {
            _loc2_ = Number(this.WHSize[1]);
         }
         return _loc2_;
      }
      
      private function __mainIconHandler(param1:MouseEvent) : void
      {
         if(param1.target == this._mainIcon)
         {
            SoundManager.instance.play("008");
            if(Boolean(this._iconArray) && this._iconArray.length > 0)
            {
               if(this._iconBox.visible)
               {
                  this.expand(false);
               }
               else
               {
                  this.expand(true);
               }
            }
         }
         else
         {
            this.expand(false);
         }
      }
      
      private function updateHotNum() : void
      {
         var _loc1_:Boolean = false;
         if(Boolean(this._iconArray) && this._iconArray.length > 0)
         {
            _loc1_ = true;
            this._hotNum.text = this._iconArray.length + "";
         }
         else
         {
            this._hotNum.text = "0";
         }
         this._hotNumBg.visible = this._hotNum.visible = _loc1_;
      }
      
      public function get mainIcon() : DisplayObject
      {
         return this._mainIcon;
      }
      
      public function get count() : int
      {
         return this._iconArray.length;
      }
      
      override public function get height() : Number
      {
         if(Boolean(this._mainIcon))
         {
            return this._mainIcon.height;
         }
         return 0;
      }
      
      override public function get width() : Number
      {
         if(Boolean(this._mainIcon))
         {
            return this._mainIcon.width;
         }
         return 0;
      }
      
      private function killTweenLiteMax() : void
      {
         if(!this.tweenLiteMax)
         {
            return;
         }
         this.tweenLiteMax.kill();
         this.tweenLiteMax = null;
      }
      
      private function killTweenLiteSmall() : void
      {
         if(!this.tweenLiteSmall)
         {
            return;
         }
         this.tweenLiteSmall.kill();
         this.tweenLiteSmall = null;
      }
      
      private function removeEvent() : void
      {
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__mainIconHandler);
      }
      
      public function dispose() : void
      {
         this.killTweenLiteMax();
         this.killTweenLiteSmall();
         this.removeEvent();
         ObjectUtils.disposeObject(this._mainIcon);
         this._mainIcon = null;
         ObjectUtils.disposeObject(this._hotNumBg);
         this._hotNumBg = null;
         ObjectUtils.disposeObject(this._hotNum);
         this._hotNum = null;
         ObjectUtils.disposeObject(this._iconBox);
         this._iconBox = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this._iconArray = null;
         this.WHSize = null;
         this.direction = null;
         this._mainIconString = null;
         this.vNum = 0;
         this.hNum = 0;
      }
   }
}
