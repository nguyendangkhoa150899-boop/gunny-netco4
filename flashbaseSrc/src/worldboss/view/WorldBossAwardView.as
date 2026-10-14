package worldboss.view
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class WorldBossAwardView extends Sprite implements Disposeable
   {
       
      
      private var _leftView:worldboss.view.WorldBossAwardOptionLeftView;
      
      private var _rightView:worldboss.view.WorldBossAwardOptionRightView;
      
      public function WorldBossAwardView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._leftView = new worldboss.view.WorldBossAwardOptionLeftView();
         addChild(this._leftView);
         this._rightView = new worldboss.view.WorldBossAwardOptionRightView();
         addChild(this._rightView);
      }
      
      private function addEvent() : void
      {
         this._rightView.addEventListener(Event.CLOSE,this.__gotoBack);
      }
      
      private function __gotoBack(param1:Event) : void
      {
         this.dispose();
      }
      
      public function dispose() : void
      {
         if(Boolean(this._leftView))
         {
            ObjectUtils.disposeObject(this._leftView);
         }
         this._leftView = null;
         if(Boolean(this._rightView))
         {
            ObjectUtils.disposeObject(this._rightView);
         }
         this._rightView = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
