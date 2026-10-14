package pyramid.view
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.InviteManager;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   
   public class PyramidSystem extends BaseStateView
   {
       
      
      private var _pyramidView:pyramid.view.PyramidView;
      
      public function PyramidSystem()
      {
         super();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         InviteManager.Instance.enabled = false;
         this._pyramidView = new pyramid.view.PyramidView();
         addChild(this._pyramidView);
         KeyboardShortcutsManager.Instance.forbiddenFull();
         super.enter(param1,param2);
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         InviteManager.Instance.enabled = true;
         KeyboardShortcutsManager.Instance.cancelForbidden();
         if(Boolean(this._pyramidView))
         {
            ObjectUtils.disposeObject(this._pyramidView);
         }
         this._pyramidView = null;
         super.leaving(param1);
      }
      
      override public function getType() : String
      {
         return StateType.PYRAMID;
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this._pyramidView);
         this._pyramidView = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
