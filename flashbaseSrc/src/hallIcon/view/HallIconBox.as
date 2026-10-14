package hallIcon.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class HallIconBox extends Sprite implements Disposeable
   {
       
      
      private var _iconSprite:Sprite;
      
      private var _iconSpriteBg:ScaleBitmapImage;
      
      public function HallIconBox()
      {
         super();
         this._iconSpriteBg = ComponentFactory.Instance.creatComponentByStylename("hallIconPanel.iconSpriteBg");
         super.addChild(this._iconSpriteBg);
         this._iconSprite = new Sprite();
         super.addChild(this._iconSprite);
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         return this._iconSprite.addChild(param1);
      }
      
      override public function getChildIndex(param1:DisplayObject) : int
      {
         return this._iconSprite.getChildIndex(param1);
      }
      
      override public function removeChildAt(param1:int) : DisplayObject
      {
         return this._iconSprite.removeChildAt(param1);
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = param1;
         this.updateBg();
      }
      
      override public function set y(param1:Number) : void
      {
         super.y = param1;
         this.updateBg();
      }
      
      override public function get numChildren() : int
      {
         return this._iconSprite.numChildren;
      }
      
      private function updateBg() : void
      {
         this._iconSpriteBg.width = this._iconSprite.width + 12;
         this._iconSpriteBg.height = this._iconSprite.height + 10;
         this._iconSpriteBg.x = this._iconSprite.x - 12;
         this._iconSpriteBg.y = this._iconSprite.y - 10;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this._iconSprite);
         ObjectUtils.disposeObject(this._iconSprite);
         this._iconSprite = null;
         ObjectUtils.disposeObject(this._iconSpriteBg);
         this._iconSpriteBg = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
