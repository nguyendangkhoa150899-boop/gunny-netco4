package giftSystem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import flash.display.Sprite;
   import giftSystem.element.GiftGoodItem;
   
   public class GiftGoodsListView extends Sprite implements Disposeable
   {
       
      
      private var _containerAll:VBox;
      
      private var _container:Vector.<HBox>;
      
      public function GiftGoodsListView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._container = new Vector.<HBox>();
         this._containerAll = ComponentFactory.Instance.creatComponentByStylename("GiftGoodsListView.containerAll");
         addChild(this._containerAll);
      }
      
      public function setList(param1:Vector.<ShopItemInfo>) : void
      {
         var _loc2_:GiftGoodItem = null;
         this.clear();
         this._container = new Vector.<HBox>();
         var _loc3_:int = 0;
         var _loc4_:int = param1.length < 6 ? int(param1.length) : int(6);
         var _loc5_:int = 0;
         while(_loc5_ < 6)
         {
            if(_loc5_ % 2 == 0)
            {
               _loc3_ = _loc5_ / 2;
               this._container[_loc3_] = ComponentFactory.Instance.creatComponentByStylename("GiftGoodsListView.container");
               this._containerAll.addChild(this._container[_loc3_]);
            }
            _loc2_ = new GiftGoodItem();
            if(_loc5_ < _loc4_)
            {
               _loc2_.info = param1[_loc5_];
            }
            this._container[_loc3_].addChild(_loc2_);
            _loc5_++;
         }
      }
      
      private function clear() : void
      {
         var _loc1_:int = 0;
         ObjectUtils.disposeAllChildren(this._containerAll);
         if(this._container.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < 3)
            {
               this._container[_loc1_] = null;
               _loc1_++;
            }
         }
         this._container = null;
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.clear();
         if(Boolean(this._containerAll))
         {
            ObjectUtils.disposeObject(this._containerAll);
         }
         this._containerAll = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
