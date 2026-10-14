package AvatarCollection.view
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class AvatarCollectionItemListView extends Sprite implements Disposeable
   {
       
      
      private var _itemList:Vector.<AvatarCollection.view.AvatarCollectionItemCell>;
      
      private var _dataList:Array;
      
      public function AvatarCollectionItemListView()
      {
         super();
         this.x = 29;
         this.y = 25;
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._itemList = new Vector.<AvatarCollectionItemCell>();
         _loc1_ = 0;
         while(_loc1_ < 12)
         {
            _loc2_ = new AvatarCollection.view.AvatarCollectionItemCell();
            _loc2_.x = _loc1_ % 6 * 84;
            _loc2_.y = int(_loc1_ / 6) * 87;
            addChild(_loc2_);
            this._itemList.push(_loc2_);
            _loc1_++;
         }
      }
      
      public function refreshView(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         this._dataList = param1;
         var _loc4_:int = !!this._dataList ? int(this._dataList.length) : 0;
         _loc2_ = 0;
         while(_loc2_ < 12)
         {
            _loc3_ = null;
            if(_loc2_ < _loc4_)
            {
               _loc3_ = this._dataList[_loc2_];
            }
            this._itemList[_loc2_].refreshView(_loc3_);
            _loc2_++;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._itemList = null;
         this._dataList = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
