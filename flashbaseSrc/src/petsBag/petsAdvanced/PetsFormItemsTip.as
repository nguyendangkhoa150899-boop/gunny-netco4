package petsBag.petsAdvanced
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITransformableTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class PetsFormItemsTip extends Sprite implements ITransformableTip
   {
       
      
      protected var _bg:ScaleBitmapImage;
      
      protected var _title:FilterFrameText;
      
      protected var _data:Object;
      
      protected var _tipWidth:int;
      
      protected var _tipHeight:int;
      
      private var _rule:ScaleBitmapImage;
      
      private var _itemVec:Vector.<petsBag.petsAdvanced.PetsFormItemsTipItem>;
      
      public function PetsFormItemsTip()
      {
         super();
         this.init();
      }
      
      protected function init() : void
      {
         var _loc1_:petsBag.petsAdvanced.PetsFormItemsTipItem = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.petsTip.bg");
         addChild(this._bg);
         this._title = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.petsTip.titleTxt");
         addChild(this._title);
         this._rule = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._rule.width = this._bg.width;
         addChild(this._rule);
         PositionUtils.setPos(this._rule,"hall.tip.rule.pos");
         this._itemVec = new Vector.<PetsFormItemsTipItem>();
         var _loc2_:int = 1;
         while(_loc2_ < 5)
         {
            _loc1_ = new petsBag.petsAdvanced.PetsFormItemsTipItem(_loc2_);
            addChild(_loc1_);
            this._itemVec.push(_loc1_);
            _loc2_++;
         }
      }
      
      public function get tipData() : Object
      {
         return this._data;
      }
      
      public function set tipData(param1:Object) : void
      {
         if(param1 != null)
         {
            this._data = param1;
            this._title.text = this._data["title"];
            this._itemVec[0].isActive = this._data["isActive"];
            this._itemVec[0].value = this._data["state"];
            this._itemVec[1].value = this._data["activeValue"];
            this._itemVec[2].value = this._data["propertyValue"];
            this._itemVec[3].value = this._data["getValue"];
         }
      }
      
      public function get tipWidth() : int
      {
         return this._tipWidth;
      }
      
      public function set tipWidth(param1:int) : void
      {
         this._tipWidth = param1;
      }
      
      public function get tipHeight() : int
      {
         return this._bg.height;
      }
      
      public function set tipHeight(param1:int) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         var _loc1_:petsBag.petsAdvanced.PetsFormItemsTipItem = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._title);
         this._title = null;
         ObjectUtils.disposeObject(this._rule);
         this._rule = null;
         for each(_loc1_ in this._itemVec)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         this._itemVec = null;
         this._data = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
