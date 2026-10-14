package store.view.embed
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.TransformableComponent;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   
   public class HoleExpBar extends TransformableComponent
   {
      
      private static const P_Rate:String = "p_rate";
       
      
      private var thickness:int = 3;
      
      private var _rate:Number = 0;
      
      private var _back:BitmapData;
      
      private var _thumb:BitmapData;
      
      private var _rateField:FilterFrameText;
      
      public function HoleExpBar()
      {
         super();
         this.configUI();
      }
      
      private function configUI() : void
      {
         this._back = ComponentFactory.Instance.creatBitmapData("asset.store.embed.HoleExpBack");
         this._thumb = ComponentFactory.Instance.creatBitmapData("asset.store.embed.HoleExpThumb");
         this._rateField = ComponentFactory.Instance.creatComponentByStylename("store.embed.ExpRateField");
         addChild(this._rateField);
         _width = this._back.width;
         _height = this._back.height;
         this.draw();
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
      }
      
      override public function draw() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Matrix = null;
         super.draw();
         var _loc3_:Graphics = graphics;
         _loc3_.clear();
         _loc3_.beginBitmapFill(this._back);
         _loc3_.drawRect(0,0,_width,_height);
         _loc3_.endFill();
         if(_width > this.thickness * 3 && _height > this.thickness * 3 && this._rate > 0)
         {
            _loc1_ = _width - this.thickness * 2;
            _loc2_ = new Matrix();
            _loc2_.translate(this.thickness,this.thickness);
            _loc3_.beginBitmapFill(this._thumb,_loc2_);
            _loc3_.drawRect(this.thickness,this.thickness,_loc1_ * this._rate,_height - this.thickness * 2);
            _loc3_.endFill();
         }
         this._rateField.text = int(this._rate * 100) + "%";
      }
      
      public function setProgress(param1:int, param2:int = 100) : void
      {
         this._rate = param1 / param2;
         this._rate = this._rate > 1 ? Number(1) : Number(this._rate);
         onPropertiesChanged(P_Rate);
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._back))
         {
            ObjectUtils.disposeObject(this._back);
            this._back = null;
         }
         if(Boolean(this._thumb))
         {
            ObjectUtils.disposeObject(this._thumb);
            this._thumb = null;
         }
         if(Boolean(this._rateField))
         {
            ObjectUtils.disposeObject(this._rateField);
         }
         this._rateField = null;
         super.dispose();
      }
   }
}
