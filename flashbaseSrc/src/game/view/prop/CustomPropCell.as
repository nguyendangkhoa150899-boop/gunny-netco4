package game.view.prop
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.PropInfo;
   import ddt.events.FightPropEevnt;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import game.GameManager;
   import game.view.control.FightControlBar;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class CustomPropCell extends PropCell
   {
       
      
      private var _deleteBtn:SimpleBitmapButton;
      
      private var _type:int;
      
      private var _lockIcon:Bitmap;
      
      private var _isLock:Boolean = false;
      
      public function CustomPropCell(param1:String, param2:int, param3:int)
      {
         super(param1,param2);
         this._type = param3;
         mouseChildren = false;
         if(Boolean(this._type))
         {
            _tipInfo.valueType = null;
         }
      }
      
      public function set isLock(param1:Boolean) : void
      {
         if(param1)
         {
            this._lockIcon.visible = true;
            this.info = null;
         }
         else
         {
            this._lockIcon.visible = false;
         }
         this._isLock = param1;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this._deleteBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.deletePropBtn");
         this._lockIcon = ComponentFactory.Instance.creatBitmap("asset.game.onlyLockIcon");
         this._lockIcon.visible = false;
         addChild(this._lockIcon);
      }
      
      override protected function drawLayer() : void
      {
      }
      
      override protected function __mouseOut(param1:MouseEvent) : void
      {
         if(Boolean(this._deleteBtn.parent))
         {
            removeChild(this._deleteBtn);
         }
         x = _x;
         y = _y;
         scaleX = scaleY = 1;
         _shortcutKeyShape.scaleX = _shortcutKeyShape.scaleY = 1;
         if(Boolean(_tweenMax))
         {
            _tweenMax.pause();
         }
         filters = null;
      }
      
      override protected function __mouseOver(param1:MouseEvent) : void
      {
         if(GameManager.Instance.Current.mapIndex != 1405)
         {
            if(_info && !(RoomManager.Instance.current && RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM) && _info.TemplateID != 10471)
            {
               addChild(this._deleteBtn);
            }
         }
         super.__mouseOver(param1);
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         addEventListener(MouseEvent.CLICK,this.__clicked);
      }
      
      private function __deleteClick(param1:MouseEvent) : void
      {
      }
      
      private function deleteContainMouse() : Boolean
      {
         var _loc1_:Rectangle = this._deleteBtn.getBounds(this);
         return _loc1_.contains(mouseX,mouseY);
      }
      
      private function deleteProp() : void
      {
         dispatchEvent(new FightPropEevnt(FightPropEevnt.DELETEPROP));
      }
      
      private function __clicked(param1:MouseEvent) : void
      {
         StageReferance.stage.focus = null;
         if(Boolean(this._deleteBtn.parent) && this.deleteContainMouse())
         {
            this.deleteProp();
         }
         else
         {
            this.useProp();
         }
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         if(_enabled != param1)
         {
            _enabled = param1;
            if(!_enabled)
            {
               if(Boolean(_asset))
               {
                  _asset.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               }
               this.__mouseOut(null);
            }
            else if(Boolean(_asset))
            {
               _asset.filters = null;
            }
         }
      }
      
      override public function useProp() : void
      {
         if(_info != null)
         {
            dispatchEvent(new FightPropEevnt(FightPropEevnt.USEPROP));
         }
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         removeEventListener(MouseEvent.CLICK,this.__clicked);
      }
      
      override public function set info(param1:PropInfo) : void
      {
         super.info = param1;
         if(this._isLock)
         {
            return;
         }
         if(_info == null)
         {
            this.__mouseOut(null);
         }
      }
      
      override public function setPossiton(param1:int, param2:int) : void
      {
         super.setPossiton(param1,param2);
         this.x = _x;
         this.y = _y;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._deleteBtn))
         {
            ObjectUtils.disposeObject(this._deleteBtn);
            this._deleteBtn = null;
         }
         ObjectUtils.disposeObject(this._lockIcon);
         this._lockIcon = null;
         super.dispose();
      }
      
      override public function get tipDirctions() : String
      {
         if(this._type != FightControlBar.LIVE)
         {
            return "4,5,7,1,6,2";
         }
         return super.tipDirctions;
      }
   }
}
