package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   import im.info.CustomInfo;
   
   public class FriendGroupTip extends Sprite implements Disposeable
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _vbox:VBox;
      
      private var _itemArr:Array;
      
      public function FriendGroupTip()
      {
         super();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("friendsGroupTip.bg");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("friendsGroupTip.ItemContainer");
         addChild(this._bg);
         addChild(this._vbox);
         this._itemArr = new Array();
      }
      
      public function update(param1:String) : void
      {
         var _loc2_:FriendGroupTItem = null;
         this.clearItem();
         var _loc3_:Vector.<CustomInfo> = PlayerManager.Instance.customList;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length - 1)
         {
            _loc2_ = new FriendGroupTItem();
            _loc2_.info = _loc3_[_loc4_];
            _loc2_.NickName = param1;
            this._vbox.addChild(_loc2_);
            this._itemArr.push(_loc2_);
            _loc4_++;
         }
         this._bg.height = _loc3_.length * 21;
      }
      
      private function clearItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._itemArr.length)
         {
            if(Boolean(this._itemArr[_loc1_]))
            {
               ObjectUtils.disposeObject(this._itemArr[_loc1_]);
            }
            this._itemArr[_loc1_] = null;
            _loc1_++;
         }
         this._itemArr = new Array();
      }
      
      public function dispose() : void
      {
         this.clearItem();
         this._itemArr = null;
         if(Boolean(this._vbox))
         {
            ObjectUtils.disposeObject(this._vbox);
         }
         this._vbox = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
