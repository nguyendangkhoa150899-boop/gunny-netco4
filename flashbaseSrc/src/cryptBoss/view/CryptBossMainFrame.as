package cryptBoss.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.utils.ObjectUtils;
   import cryptBoss.CryptBossManager;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.utils.HelpFrameUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import game.GameManager;
   
   public class CryptBossMainFrame extends Frame
   {
       
      
      private var _bg:Bitmap;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _itemVec:Vector.<cryptBoss.view.CryptBossItem>;
      
      public function CryptBossMainFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("cryptBoss.frame.titleTxt");
         this._helpBtn = HelpFrameUtils.Instance.simpleHelpButton(this,"cryptBoss.helpBtn",null,LanguageMgr.GetTranslation("ddt.ringstation.helpTitle"),"cryptBoss.helpTxt",424,484) as SimpleBitmapButton;
         this._bg = ComponentFactory.Instance.creat("asset.cryptBoss.bg");
         addToContent(this._bg);
         this.updateView();
      }
      
      public function updateView() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc1_:* = null;
         if(this._itemVec != null)
         {
            for each(_loc3_ in this._itemVec)
            {
               ObjectUtils.disposeObject(_loc3_);
               _loc3_ = null;
            }
            this._itemVec = null;
         }
         this._itemVec = new Vector.<CryptBossItem>();
         for each(_loc2_ in CryptBossManager.instance.openWeekDaysDic)
         {
            _loc1_ = new cryptBoss.view.CryptBossItem(_loc2_);
            this._itemVec.push(_loc1_);
            addToContent(_loc1_);
         }
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.__responseHandler);
         GameManager.Instance.addEventListener("StartLoading",this.__startLoading);
      }
      
      private function __startLoading(param1:Event) : void
      {
         StateManager.getInGame_Step_6 = true;
         ChatManager.Instance.input.faceEnabled = false;
         LayerManager.Instance.clearnGameDynamic();
         StateManager.setState("roomLoading",GameManager.Instance.Current);
         StateManager.getInGame_Step_7 = true;
      }
      
      protected function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            SoundManager.instance.play("008");
            CryptBossManager.instance.RoomType = 0;
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this.__responseHandler);
         GameManager.Instance.removeEventListener("StartLoading",this.__startLoading);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._itemVec = null;
         this._helpBtn = null;
         super.dispose();
      }
   }
}
