package bagAndInfo.bag
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.ItemEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.view.PropItemView;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class KeyDefaultSetPanel extends Sprite
   {
       
      
      private var _bg:Bitmap;
      
      private var alphaClickArea:Sprite;
      
      private var _icon:Array;
      
      public var selectedItemID:int = 0;
      
      public function KeyDefaultSetPanel()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc1_:ItemTemplateInfo = null;
         var _loc2_:KeySetItem = null;
         var _loc3_:Point = ComponentFactory.Instance.creatCustomObject("bagAndInfo.bag.KeySet.KeyTL");
         var _loc4_:Point = ComponentFactory.Instance.creatCustomObject("bagAndInfo.bag.KeySet.KeyRect");
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.__removeToStage);
         this.alphaClickArea = new Sprite();
         this._bg = ComponentFactory.Instance.creatBitmap("bagAndInfo.bag.keySetBGAsset");
         addChild(this._bg);
         this._icon = [];
         var _loc5_:Array = SharedManager.KEY_SET_ABLE;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc1_ = ItemManager.Instance.getTemplateById(_loc5_[_loc6_]);
            if(Boolean(_loc1_))
            {
               _loc2_ = new KeySetItem(_loc5_[_loc6_],0,_loc5_[_loc6_],PropItemView.createView(_loc1_.Pic,40,40));
               _loc2_.addEventListener(ItemEvent.ITEM_CLICK,this.onItemClick);
               _loc2_.x = _loc3_.x + (_loc6_ < 4 ? _loc6_ * _loc4_.x : (_loc6_ - 4) * _loc4_.x);
               _loc2_.y = _loc3_.y + (_loc6_ < 4 ? 0 : Math.floor(_loc6_ / 4) * _loc4_.y);
               _loc2_.setClick(true,false,true);
               _loc2_.height = _loc2_.width = 40;
               _loc2_.setBackgroundVisible(false);
               addChild(_loc2_);
               this._icon.push(_loc2_);
            }
            _loc6_++;
         }
      }
      
      private function __addToStage(param1:Event) : void
      {
         this.alphaClickArea.graphics.beginFill(16711935,0);
         this.alphaClickArea.graphics.drawRect(-3000,-3000,6000,6000);
         addChildAt(this.alphaClickArea,0);
         this.alphaClickArea.addEventListener(MouseEvent.CLICK,this.clickHide);
      }
      
      private function __removeToStage(param1:Event) : void
      {
         this.alphaClickArea.graphics.clear();
         this.alphaClickArea.removeEventListener(MouseEvent.CLICK,this.clickHide);
      }
      
      private function clickHide(param1:MouseEvent) : void
      {
         this.hide();
      }
      
      public function hide() : void
      {
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:KeySetItem = null;
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.__removeToStage);
         while(this._icon.length > 0)
         {
            _loc1_ = this._icon.shift() as KeySetItem;
            if(Boolean(_loc1_))
            {
               _loc1_.removeEventListener(ItemEvent.ITEM_CLICK,this.onItemClick);
               _loc1_.dispose();
            }
            _loc1_ = null;
         }
         this._icon = null;
         if(Boolean(this.alphaClickArea))
         {
            this.alphaClickArea.removeEventListener(MouseEvent.CLICK,this.clickHide);
            this.alphaClickArea.graphics.clear();
            if(Boolean(this.alphaClickArea.parent))
            {
               this.alphaClickArea.parent.removeChild(this.alphaClickArea);
            }
         }
         this.alphaClickArea = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function onItemClick(param1:ItemEvent) : void
      {
         SoundManager.instance.play("008");
         this.selectedItemID = param1.index;
         this.hide();
         dispatchEvent(new Event(Event.SELECT));
      }
   }
}
