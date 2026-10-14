package worldboss.view
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import worldboss.WorldBossManager;
   
   public class WorldBossIcon extends Sprite
   {
       
      
      private var _dragon:MovieClip;
      
      public function WorldBossIcon()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(WorldBossManager.Instance.iconEnterPath,BaseLoader.MODULE_LOADER);
         _loc1_.addEventListener(LoaderEvent.COMPLETE,this.onIconLoadedComplete);
         LoaderManager.Instance.startLoad(_loc1_);
      }
      
      private function onIconLoadedComplete(param1:Event) : void
      {
         this._dragon = ComponentFactory.Instance.creat("asset.hall.worldBossEntrance-1");
         this._dragon.buttonMode = true;
         addChild(this._dragon);
         if(Boolean(WorldBossManager.Instance.bossInfo))
         {
            this._dragon.gotoAndStop(WorldBossManager.Instance.bossInfo.fightOver ? 2 : 1);
         }
         else
         {
            this._dragon.gotoAndStop(1);
         }
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         this._dragon.addEventListener(MouseEvent.CLICK,this.__enterBossRoom);
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._dragon))
         {
            this._dragon.removeEventListener(MouseEvent.CLICK,this.__enterBossRoom);
         }
      }
      
      private function __enterBossRoom(param1:MouseEvent) : void
      {
         SoundManager.instance.play("003");
         StateManager.setState(StateType.WORLDBOSS_AWARD);
      }
      
      public function setFrame(param1:int) : void
      {
         if(Boolean(this._dragon))
         {
            this._dragon.gotoAndStop(param1);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            this.parent.removeChild(this);
         }
         this._dragon = null;
      }
   }
}
