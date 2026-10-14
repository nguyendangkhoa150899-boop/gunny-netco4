package AvatarCollection.view
{
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class AvatarCollectionRightView extends Sprite implements Disposeable
   {
       
      
      private var _data:AvatarCollectionUnitVo;
      
      private var _itemListView:AvatarCollection.view.AvatarCollectionItemListView;
      
      private var _propertyView:AvatarCollection.view.AvatarCollectionPropertyView;
      
      private var _moneyView:AvatarCollection.view.AvatarCollectionMoneyView;
      
      private var _timeView:AvatarCollection.view.AvatarCollectionTimeView;
      
      public function AvatarCollectionRightView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._itemListView = new AvatarCollection.view.AvatarCollectionItemListView();
         addChild(this._itemListView);
         this._moneyView = new AvatarCollection.view.AvatarCollectionMoneyView();
         addChild(this._moneyView);
         this._timeView = new AvatarCollection.view.AvatarCollectionTimeView();
         addChild(this._timeView);
         this._propertyView = new AvatarCollection.view.AvatarCollectionPropertyView();
         addChild(this._propertyView);
      }
      
      public function refreshView(param1:AvatarCollectionUnitVo) : void
      {
         this._itemListView.refreshView(!!param1 ? param1.totalItemList : null);
         this._propertyView.refreshView(param1);
         this._timeView.refreshView(param1);
      }
      
      public function set selectedAllBtn(param1:Boolean) : void
      {
         this._timeView.selected = param1;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._data = null;
         this._itemListView = null;
         this._propertyView = null;
         this._moneyView = null;
         this._timeView = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
