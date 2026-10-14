package petsBag.view.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   
   public class PetWashBoneGrade extends Sprite implements Disposeable
   {
       
      
      private var _levBg:Bitmap;
      
      private var _gradeImg:ScaleFrameImage;
      
      public function PetWashBoneGrade()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._levBg = ComponentFactory.Instance.creat("asset.petsBage.washBone.levBg");
         addChild(this._levBg);
         this._gradeImg = ComponentFactory.Instance.creatComponentByStylename("petsBag.washBone.petGrade");
         addChild(this._gradeImg);
         this._gradeImg.setFrame(0);
      }
      
      public function set info(param1:PetInfo) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = PetBagController.instance().getPetQualityIndex(param1.petGraded);
         this._gradeImg.setFrame(_loc2_ + 1);
         var _loc3_:* = this._levBg.width - this._gradeImg.width >> 1;
         this._gradeImg.x = _loc3_;
         this._gradeImg.y = 3;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._levBg);
         this._levBg = null;
         ObjectUtils.disposeObject(this._gradeImg);
         this._gradeImg = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
