package consortionBattle.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   
   public class ConsortiaBattleEntryBtn extends Sprite implements Disposeable
   {
       
      
      private var _btn:MovieClip;
      
      private var _isOpen:Boolean;
      
      public function ConsortiaBattleEntryBtn()
      {
         super();
         this.x = 47;
         this.y = 217;
         if(ConsortiaBattleManager.instance.isLoadIconMapComplete)
         {
            this.initThis();
         }
         else
         {
            ConsortiaBattleManager.instance.addEventListener(ConsortiaBattleManager.ICON_AND_MAP_LOAD_COMPLETE,this.resLoadComplete);
         }
      }
      
      public function setEnble(param1:Boolean) : void
      {
         this._isOpen = param1;
         mouseChildren = param1;
         mouseEnabled = param1;
         if(param1)
         {
            this.reGray(this);
            this.playAllMc(this._btn);
         }
         else
         {
            this.applyGray(this);
         }
      }
      
      public function reGray(param1:DisplayObject) : void
      {
         param1.filters = null;
      }
      
      public function applyGray(param1:DisplayObject) : void
      {
         var _loc2_:Array = new Array();
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0,0,0,1,0]);
         this.applyFilter(param1,_loc2_);
      }
      
      private function applyFilter(param1:DisplayObject, param2:Array) : void
      {
         var _loc3_:ColorMatrixFilter = new ColorMatrixFilter(param2);
         var _loc4_:Array = new Array();
         _loc4_.push(_loc3_);
         param1.filters = _loc4_;
      }
      
      private function initThis() : void
      {
         this._btn = ComponentFactory.Instance.creat("assets.hallIcon.consortiaBattleEntryIcon");
         this._btn.gotoAndStop(1);
         this._btn.buttonMode = true;
         addChild(this._btn);
         this._btn.addEventListener(MouseEvent.CLICK,this.clickhandler,false,0,true);
         ConsortiaBattleManager.instance.addEventListener(ConsortiaBattleManager.CLOSE,this.closeHandler);
         if(!this._isOpen)
         {
            this.stopAllMc(this._btn);
         }
      }
      
      private function playAllMc(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         if(Boolean(param1))
         {
            while(Boolean(param1.numChildren - _loc3_))
            {
               if(param1.getChildAt(_loc3_) is MovieClip)
               {
                  _loc2_ = param1.getChildAt(_loc3_) as MovieClip;
                  _loc2_.play();
                  this.playAllMc(_loc2_);
               }
               _loc3_++;
            }
         }
      }
      
      private function stopAllMc(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         if(Boolean(param1))
         {
            while(Boolean(param1.numChildren - _loc3_))
            {
               if(param1.getChildAt(_loc3_) is MovieClip)
               {
                  _loc2_ = param1.getChildAt(_loc3_) as MovieClip;
                  _loc2_.stop();
                  this.stopAllMc(_loc2_);
               }
               _loc3_++;
            }
         }
      }
      
      private function clickhandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(ConsortiaBattleManager.instance.isCanEnter)
         {
            GameInSocketOut.sendSingleRoomBegin(4);
         }
         else if(PlayerManager.Instance.Self.ConsortiaID != 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.cannotEnterTxt"));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.cannotEnterTxt2"));
         }
      }
      
      private function resLoadComplete(param1:Event) : void
      {
         ConsortiaBattleManager.instance.removeEventListener(ConsortiaBattleManager.ICON_AND_MAP_LOAD_COMPLETE,this.resLoadComplete);
         this.initThis();
      }
      
      private function closeHandler(param1:Event) : void
      {
         this.closeDispose();
         ConsortiaBattleManager.instance.addEventListener(ConsortiaBattleManager.ICON_AND_MAP_LOAD_COMPLETE,this.resLoadComplete);
      }
      
      private function closeDispose() : void
      {
         ConsortiaBattleManager.instance.removeEventListener(ConsortiaBattleManager.CLOSE,this.closeHandler);
         if(Boolean(this._btn))
         {
            this._btn.removeEventListener(MouseEvent.CLICK,this.clickhandler);
            this._btn.gotoAndStop(2);
         }
         ObjectUtils.disposeAllChildren(this);
         this._btn = null;
      }
      
      public function dispose() : void
      {
         ConsortiaBattleManager.instance.removeEventListener(ConsortiaBattleManager.ICON_AND_MAP_LOAD_COMPLETE,this.resLoadComplete);
         this.closeDispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
