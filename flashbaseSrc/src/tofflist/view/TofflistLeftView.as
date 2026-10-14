package tofflist.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class TofflistLeftView extends Sprite implements Disposeable
   {
       
      
      private var _chatFrame:Sprite;
      
      private var _currentPlayer:tofflist.view.TofflistLeftCurrentCharcter;
      
      private var _leftInfo:tofflist.view.TofflistLeftInfoView;
      
      public function TofflistLeftView()
      {
         super();
         this.init();
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._currentPlayer = null;
         this._leftInfo = null;
         this._chatFrame = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function updateTime(param1:String) : void
      {
         if(Boolean(param1))
         {
            this._leftInfo.updateTimeTxt.text = LanguageMgr.GetTranslation("tank.tofflist.view.lastUpdateTime") + param1;
         }
         else
         {
            this._leftInfo.updateTimeTxt.text = "";
         }
      }
      
      private function init() : void
      {
         this._leftInfo = ComponentFactory.Instance.creatCustomObject("tofflist.leftInfoView");
         addChild(this._leftInfo);
         this._currentPlayer = new tofflist.view.TofflistLeftCurrentCharcter();
         addChild(this._currentPlayer);
         ChatManager.Instance.state = ChatManager.CHAT_TOFFLIST_VIEW;
         this._chatFrame = ChatManager.Instance.view;
         addChild(this._chatFrame);
      }
   }
}
