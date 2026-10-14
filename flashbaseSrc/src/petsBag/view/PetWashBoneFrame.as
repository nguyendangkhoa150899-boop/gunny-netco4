package petsBag.view
{
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   
   public class PetWashBoneFrame extends Frame
   {
       
      
      private var _view:petsBag.view.PetWashBoneView;
      
      public function PetWashBoneFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._view = new petsBag.view.PetWashBoneView();
         super.init();
         titleText = LanguageMgr.GetTranslation("ddt.pets.washBone.titleName");
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._view);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,3,true,1);
      }
      
      override protected function __onCloseClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         super.__onCloseClick(param1);
         this.dispose();
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._view);
         this._view = null;
         super.dispose();
      }
   }
}
