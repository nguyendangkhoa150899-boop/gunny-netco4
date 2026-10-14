package AvatarCollection.view
{
   import AvatarCollection.AvatarCollectionManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class AvatarCollectionMainView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _rightView:AvatarCollection.view.AvatarCollectionRightView;
      
      private var _canActivitySCB:SelectedCheckButton;
      
      private var _canBuySCB:SelectedCheckButton;
      
      private var _leftView:AvatarCollection.view.AvatarCollectionLeftView;
      
      public function AvatarCollectionMainView()
      {
         super();
         this.x = -1;
         this.y = 48;
         AvatarCollectionManager.instance.initShopItemInfoList();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.avatarCollMainView.bg");
         this._rightView = new AvatarCollection.view.AvatarCollectionRightView();
         PositionUtils.setPos(this._rightView,"avatarColl.mainView.rightViewPos");
         this._leftView = new AvatarCollection.view.AvatarCollectionLeftView(this._rightView);
         PositionUtils.setPos(this._leftView,"avatarColl.mainView.leftViewPos");
         this._canActivitySCB = ComponentFactory.Instance.creatComponentByStylename("avatarColl.canActivitySCB");
         this._canBuySCB = ComponentFactory.Instance.creatComponentByStylename("avatarColl.canBuySCB");
         addChild(this._bg);
         addChild(this._canActivitySCB);
         addChild(this._canBuySCB);
         addChild(this._leftView);
         addChild(this._rightView);
      }
      
      private function initEvent() : void
      {
         this._canActivitySCB.addEventListener("click",this.canActivityChangeHandler,false,0,true);
         this._canBuySCB.addEventListener("click",this.canBuyChangeHandler,false,0,true);
      }
      
      public function reset() : void
      {
         var _loc1_:* = null;
         if(this._canBuySCB.selected)
         {
            this._canBuySCB.selected = false;
            _loc1_ = "isBuyFilter";
         }
         else if(this._canActivitySCB.selected)
         {
            this._canActivitySCB.selected = false;
            _loc1_ = "isFilter";
         }
         if(_loc1_ != null)
         {
            this._leftView.reset(_loc1_);
         }
      }
      
      private function canBuyChangeHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._leftView.canBuyChange(this._canBuySCB.selected);
         if(this._canBuySCB.selected)
         {
            AvatarCollectionManager.instance.selectAllClicked(false);
            AvatarCollectionManager.instance.listState("canBuy");
            this._canActivitySCB.selected = false;
         }
         else
         {
            AvatarCollectionManager.instance.listState("normal");
         }
      }
      
      private function canActivityChangeHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._leftView.canActivityChange(this._canActivitySCB.selected);
         if(this._canActivitySCB.selected)
         {
            AvatarCollectionManager.instance.selectAllClicked(false);
            AvatarCollectionManager.instance.listState("canActivity");
            this._canBuySCB.selected = false;
         }
         else
         {
            AvatarCollectionManager.instance.listState("normal");
         }
      }
      
      private function removeEvent() : void
      {
         this._canActivitySCB.removeEventListener("click",this.canActivityChangeHandler);
         this._canBuySCB.removeEventListener("click",this.canBuyChangeHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._leftView = null;
         this._rightView = null;
         this._canActivitySCB = null;
         this._canBuySCB = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get unitList() : Vector.<AvatarCollectionUnitView>
      {
         return this._leftView.unitList;
      }
   }
}
