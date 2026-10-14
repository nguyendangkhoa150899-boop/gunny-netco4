package AvatarCollection.view
{
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class AvatarCollectionPropertyView extends Sprite implements Disposeable
   {
       
      
      private var _propertyCellList:Vector.<AvatarCollection.view.AvatarCollectionPropertyCell>;
      
      private var _allPropertyView:AvatarCollection.view.AvatarCollectionAllPropertyView;
      
      private var _tip:AvatarCollection.view.AvatarCollectionPropertyTip;
      
      private var _tipSprite:Sprite;
      
      private var _completeStatus:int = -1;
      
      public function AvatarCollectionPropertyView()
      {
         super();
         this.x = 22;
         this.y = 252;
         this.mouseEnabled = false;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._propertyCellList = new Vector.<AvatarCollectionPropertyCell>();
         this._allPropertyView = new AvatarCollection.view.AvatarCollectionAllPropertyView();
         this._allPropertyView.x = 274;
         this._allPropertyView.y = 0;
         addChild(this._allPropertyView);
         _loc1_ = 0;
         while(_loc1_ < 7)
         {
            _loc2_ = new AvatarCollection.view.AvatarCollectionPropertyCell(_loc1_);
            _loc2_.x = int(_loc1_ / 4) * 110;
            _loc2_.y = _loc1_ % 4 * 25;
            addChild(_loc2_);
            this._propertyCellList.push(_loc2_);
            _loc1_++;
         }
         this._tip = new AvatarCollection.view.AvatarCollectionPropertyTip();
         this._tip.visible = false;
         PositionUtils.setPos(this._tip,"avatarColl.propertyView.tipPos");
         addChild(this._tip);
         this._tipSprite = new Sprite();
         this._tipSprite.graphics.beginFill(16711680,0);
         this._tipSprite.graphics.drawRect(-15,-20,242,122);
         this._tipSprite.graphics.endFill();
         addChild(this._tipSprite);
      }
      
      private function initEvent() : void
      {
         this._tipSprite.addEventListener("mouseOver",this.overHandler,false,0,true);
         this._tipSprite.addEventListener("mouseOut",this.outHandler,false,0,true);
      }
      
      private function overHandler(param1:MouseEvent) : void
      {
         if(this._completeStatus == 0 || this._completeStatus == 1)
         {
            this._tip.visible = true;
         }
      }
      
      private function outHandler(param1:MouseEvent) : void
      {
         this._tip.visible = false;
      }
      
      public function refreshView(param1:AvatarCollectionUnitVo) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(Boolean(param1))
         {
            _loc2_ = int(param1.totalItemList.length);
            _loc3_ = param1.totalActivityItemCount;
            if(_loc3_ < _loc2_ / 2)
            {
               this._completeStatus = 0;
               this._tip.refreshView(param1,1);
            }
            else if(_loc3_ == _loc2_)
            {
               this._completeStatus = 2;
            }
            else
            {
               this._completeStatus = 1;
               this._tip.refreshView(param1,2);
            }
         }
         else
         {
            this._completeStatus = -1;
         }
         for each(_loc4_ in this._propertyCellList)
         {
            _loc4_.refreshView(param1,this._completeStatus);
         }
         this._allPropertyView.refreshView();
      }
      
      private function removeEvent() : void
      {
         this._tipSprite.removeEventListener("mouseOver",this.overHandler);
         this._tipSprite.removeEventListener("mouseOut",this.outHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._propertyCellList = null;
         this._tip = null;
         this._tipSprite = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
