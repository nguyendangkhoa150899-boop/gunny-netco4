package explorerManual.view.chapter
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import explorerManual.data.ManualLevelProInfo;
   import flash.display.Sprite;
   
   public class ManualPropertyView extends Sprite implements Disposeable
   {
       
      
      private var _titleTxt:FilterFrameText;
      
      private var _magicAttack:FilterFrameText;
      
      private var _magicResistance:FilterFrameText;
      
      private var _boost:FilterFrameText;
      
      private var _proInfo:ManualLevelProInfo;
      
      public function ManualPropertyView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("explorerManual.manualProperty.titleTxt");
         addChild(this._titleTxt);
         PositionUtils.setPos(this._titleTxt,"explorerManual.proTtilePos");
         this._magicAttack = ComponentFactory.Instance.creatComponentByStylename("explorerManual.manualProperty.proNameTxt");
         addChild(this._magicAttack);
         PositionUtils.setPos(this._magicAttack,"explorerManual.magicAttackPos");
         this._magicResistance = ComponentFactory.Instance.creatComponentByStylename("explorerManual.manualProperty.proNameTxt");
         addChild(this._magicResistance);
         PositionUtils.setPos(this._magicResistance,"explorerManual.magicResistancePos");
         this._boost = ComponentFactory.Instance.creatComponentByStylename("explorerManual.manualProperty.proNameTxt");
         addChild(this._boost);
         PositionUtils.setPos(this._boost,"explorerManual.boostPos");
      }
      
      public function set info(param1:ManualLevelProInfo) : void
      {
         this._proInfo = param1;
         this.update();
      }
      
      private function update() : void
      {
         if(this._proInfo == null)
         {
            return;
         }
         if(Boolean(this._titleTxt))
         {
            this._titleTxt.text = this._proInfo.name;
         }
         if(Boolean(this._magicAttack))
         {
            this._magicAttack.text = LanguageMgr.GetTranslation("explorerManual.magicAttackAdd") + this._proInfo.magicAttack;
         }
         if(Boolean(this._magicResistance))
         {
            this._magicResistance.text = LanguageMgr.GetTranslation("explorerManual.magicResistanceAdd") + this._proInfo.magicResistance;
         }
         if(Boolean(this._boost))
         {
            this._boost.text = LanguageMgr.GetTranslation("explorerManual.allPagePro") + "+" + this._proInfo.boost + "%";
         }
      }
      
      public function dispose() : void
      {
         this._proInfo = null;
         if(Boolean(this._titleTxt))
         {
            ObjectUtils.disposeObject(this._titleTxt);
         }
         this._titleTxt = null;
         if(Boolean(this._magicAttack))
         {
            ObjectUtils.disposeObject(this._magicAttack);
         }
         this._magicAttack = null;
         if(Boolean(this._magicResistance))
         {
            ObjectUtils.disposeObject(this._magicResistance);
         }
         this._magicResistance = null;
         if(Boolean(this._boost))
         {
            ObjectUtils.disposeObject(this._boost);
         }
         this._boost = null;
      }
   }
}
