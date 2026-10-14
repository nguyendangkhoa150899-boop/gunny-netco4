package petsBag.view.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.PetconfigAnalyzer;
   import ddt.events.CEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   
   public class PetWashBoneProItem extends Sprite implements Disposeable
   {
      
      public static const CLICK_LOCK:String = "clickLock";
       
      
      private var _proType:String;
      
      private var _lockImg:ScaleFrameImage;
      
      private var _proName:FilterFrameText;
      
      private var _proMaxValue:FilterFrameText;
      
      private var _isLock:Boolean = false;
      
      private var _petInfo:PetInfo;
      
      private var _proState:ScaleFrameImage;
      
      private var _oldProValue:int;
      
      public function PetWashBoneProItem(param1:String, param2:PetInfo)
      {
         this._proType = param1;
         this._petInfo = param2;
         this._isLock = false;
         this._oldProValue = -1;
         super();
         this.initView();
         this.initEvent();
         this.initData();
      }
      
      private function initView() : void
      {
         this._lockImg = ComponentFactory.Instance.creatComponentByStylename("petsBag.washBone.proItem.lockImg");
         addChild(this._lockImg);
         this._lockImg.setFrame(1);
         this._proName = ComponentFactory.Instance.creatComponentByStylename("petsBag.washBone.proItem.name");
         addChild(this._proName);
         this._proState = ComponentFactory.Instance.creatComponentByStylename("petsBag.washBone.proItem.stateIcon");
         addChild(this._proState);
         this._proState.setFrame(2);
         this._proState.visible = false;
         this._proMaxValue = ComponentFactory.Instance.creatComponentByStylename("petsBag.washBone.proMaxValue");
         addChild(this._proMaxValue);
      }
      
      private function initData() : void
      {
         this.update(this._petInfo);
      }
      
      private function initEvent() : void
      {
         if(Boolean(this._lockImg))
         {
            this._lockImg.addEventListener("click",this.__lockClickHandler);
         }
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._lockImg))
         {
            this._lockImg.removeEventListener("click",this.__lockClickHandler);
         }
      }
      
      private function __lockClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.isLock = !this.isLock;
         this.dispatchEvent(new CEvent("clickLock",this));
      }
      
      public function update(param1:PetInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1 == null)
         {
            return;
         }
         this._petInfo = param1;
         var _loc5_:Number = PetconfigAnalyzer.PetCofnig.PropertiesRate;
         if(Boolean(this._petInfo) && this._petInfo.hasOwnProperty(this._proType))
         {
            _loc2_ = int(this._petInfo[this._proType]);
         }
         this._proName.text = LanguageMgr.GetTranslation("ddt.pets.washBone.pro" + this._proType,(_loc2_ / _loc5_).toFixed(2));
         if(this._petInfo.hasOwnProperty(this._proType + "Datum"))
         {
            _loc3_ = int(this._petInfo[this._proType + "Datum"]);
            _loc4_ = PetBagController.instance().getPetQualityIndex(_loc3_);
            this._proName.setFrame(_loc4_ + 1);
         }
         this._proState.visible = this._oldProValue >= 0;
         if(int(_loc2_) > this._oldProValue)
         {
            this._proState.setFrame(3);
         }
         else if(int(_loc2_) == this._oldProValue)
         {
            this._proState.setFrame(2);
         }
         else
         {
            this._proState.setFrame(1);
         }
         var _loc6_:int = this._petInfo.hasOwnProperty("High" + this._proType) ? int(this._petInfo["High" + this._proType]) : 0;
         this._proMaxValue.text = (_loc6_ / _loc5_).toFixed(2);
         this._oldProValue = int(_loc2_);
      }
      
      public function set isLock(param1:Boolean) : void
      {
         this._isLock = param1;
         this._lockImg.setFrame(this.isLock ? 2 : 1);
      }
      
      public function get isLock() : Boolean
      {
         return this._isLock;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._lockImg);
         this._lockImg = null;
         ObjectUtils.disposeObject(this._proName);
         this._proName = null;
         ObjectUtils.disposeObject(this._proMaxValue);
         this._proMaxValue = null;
         ObjectUtils.disposeObject(this._proState);
         this._proState = null;
         this._petInfo = null;
      }
   }
}
