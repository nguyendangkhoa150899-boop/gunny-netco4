package roomLoading.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import game.GameManager;
   import room.model.RoomPlayer;
   import room.view.RoomViewerItem;
   
   public class RoomLoadingViewerItem extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _viewerItems:Vector.<RoomViewerItem>;
      
      public function RoomLoadingViewerItem()
      {
         super();
         this.init();
      }
      
      public function init() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         this._viewerItems = new Vector.<RoomViewerItem>();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.roomLoading.ViewerItemBg");
         var _loc2_:Vector.<RoomPlayer> = this.findViewers();
         _loc1_ = 0;
         while(_loc1_ < _loc2_.length)
         {
            this._viewerItems.push(new RoomViewerItem(_loc2_[_loc1_].place));
            this._viewerItems[_loc1_].loadingMode = true;
            this._viewerItems[_loc1_].info = _loc2_[_loc1_];
            this._viewerItems[_loc1_].mouseEnabled = this._viewerItems[_loc1_].mouseChildren = false;
            PositionUtils.setPos(this._viewerItems[_loc1_],"asset.roomLoading.ViewerItemPos_" + String(_loc1_));
            addChild(this._viewerItems[_loc1_]);
            _loc1_++;
         }
         addChildAt(this._bg,0);
      }
      
      private function findViewers() : Vector.<RoomPlayer>
      {
         var _loc1_:RoomPlayer = null;
         var _loc2_:Array = GameManager.Instance.Current.roomPlayers;
         var _loc3_:Vector.<RoomPlayer> = new Vector.<RoomPlayer>();
         for each(_loc1_ in _loc2_)
         {
            if(_loc1_.isViewer)
            {
               _loc3_.push(_loc1_);
            }
         }
         return _loc3_;
      }
      
      public function dispose() : void
      {
         var _loc1_:RoomViewerItem = null;
         if(Boolean(this._bg))
         {
            this._bg.parent.removeChild(this._bg);
            this._bg.bitmapData.dispose();
            this._bg = null;
         }
         for each(_loc1_ in this._viewerItems)
         {
            _loc1_.dispose();
            _loc1_ = null;
         }
         this._viewerItems = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
