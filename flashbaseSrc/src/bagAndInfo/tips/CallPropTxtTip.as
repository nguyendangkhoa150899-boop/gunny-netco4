package bagAndInfo.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   
   public class CallPropTxtTip extends BaseTip
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _tempData:Object;
      
      private var _oriW:int;
      
      private var _oriH:int;
      
      private var _attack:FilterFrameText;
      
      private var _attackValue:FilterFrameText;
      
      private var _defense:FilterFrameText;
      
      private var _defenseValue:FilterFrameText;
      
      private var _agility:FilterFrameText;
      
      private var _agilityValue:FilterFrameText;
      
      private var _lucky:FilterFrameText;
      
      private var _luckyValue:FilterFrameText;
      
      public var lukAdd:int = 0;
      
      public function CallPropTxtTip()
      {
         super();
         visible = false;
      }
      
      override protected function init() : void
      {
         visible = false;
         mouseChildren = false;
         mouseEnabled = false;
         super.init();
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this._attack = ComponentFactory.Instance.creatComponentByStylename("ddtbagandinfo.Calltip.ability");
         this._defense = ComponentFactory.Instance.creatComponentByStylename("ddtbagandinfo.Calltip.ability");
         this._agility = ComponentFactory.Instance.creatComponentByStylename("ddtbagandinfo.Calltip.ability");
         this._lucky = ComponentFactory.Instance.creatComponentByStylename("ddtbagandinfo.Calltip.ability");
         this._attackValue = ComponentFactory.Instance.creatComponentByStylename("ddtbagandinfo.Calltip.ability");
         this._defenseValue = ComponentFactory.Instance.creatComponentByStylename("ddtbagandinfo.Calltip.ability");
         this._agilityValue = ComponentFactory.Instance.creatComponentByStylename("ddtbagandinfo.Calltip.ability");
         this._luckyValue = ComponentFactory.Instance.creatComponentByStylename("ddtbagandinfo.Calltip.ability");
         this._attack.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.attack");
         this._defense.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.defense");
         this._agility.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.agility");
         this._lucky.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.lucky");
         this._attackValue.text = "+999";
         this._defenseValue.text = "+999";
         this._agilityValue.text = "+999";
         this._luckyValue.text = "+999";
         PositionUtils.setPos(this._attack,"Call.tip.attack.Pos");
         PositionUtils.setPos(this._defense,"Call.tip.defense.Pos");
         PositionUtils.setPos(this._agility,"Call.tip.agility.Pos");
         PositionUtils.setPos(this._lucky,"Call.tip.lucky.Pos");
         PositionUtils.setPos(this._attackValue,"Call.tip.attackValue.Pos");
         PositionUtils.setPos(this._defenseValue,"Call.tip.defenseValue.Pos");
         PositionUtils.setPos(this._agilityValue,"Call.tip.agilityValue.Pos");
         PositionUtils.setPos(this._luckyValue,"Call.tip.luckyValue.Pos");
         addChild(this._attack);
         addChild(this._defense);
         addChild(this._agility);
         addChild(this._lucky);
         addChild(this._attackValue);
         addChild(this._defenseValue);
         addChild(this._agilityValue);
         addChild(this._luckyValue);
         this.setBGWidth(150);
         this.setBGHeight(130);
         this.tipbackgound = this._bg;
      }
      
      public function setBGWidth(param1:int = 0) : void
      {
         this._bg.width = param1;
      }
      
      public function setBGHeight(param1:int = 0) : void
      {
         this._bg.height = param1;
      }
      
      private function _buildTipInfo(param1:String) : void
      {
      }
      
      override public function set tipData(param1:Object) : void
      {
         if(param1 == null)
         {
            return;
         }
         visible = false;
         super.tipData = param1;
         this.atcAddValueText(param1.Attack);
         this.defAddValueText(param1.Defend);
         this.agiAddValueText(param1.Agility);
         this.lukAddValueText(param1.Lucky);
         var _loc2_:int = param1.Attack + param1.Defend + param1.Agility + param1.Lucky;
         if(_loc2_ > 0)
         {
            visible = true;
         }
      }
      
      private function atcAddValueText(param1:int) : void
      {
         this._attackValue.text = "+" + String(param1);
      }
      
      private function defAddValueText(param1:int) : void
      {
         this._defenseValue.text = "+" + String(param1);
      }
      
      private function agiAddValueText(param1:int) : void
      {
         this._agilityValue.text = "+" + String(param1);
      }
      
      private function lukAddValueText(param1:int) : void
      {
         this._luckyValue.text = "+" + String(param1);
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(Boolean(this._attack))
         {
            addChild(this._attack);
         }
         if(Boolean(this._defense))
         {
            addChild(this._defense);
         }
         if(Boolean(this._agility))
         {
            addChild(this._agility);
         }
         if(Boolean(this._lucky))
         {
            addChild(this._lucky);
         }
         if(Boolean(this._attackValue))
         {
            addChild(this._attackValue);
         }
         if(Boolean(this._defenseValue))
         {
            addChild(this._defenseValue);
         }
         if(Boolean(this._agilityValue))
         {
            addChild(this._agilityValue);
         }
         if(Boolean(this._luckyValue))
         {
            addChild(this._luckyValue);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(Boolean(this._attack))
         {
            ObjectUtils.disposeObject(this._attack);
            this._attack = null;
         }
         if(Boolean(this._defense))
         {
            ObjectUtils.disposeObject(this._defense);
            this._defense = null;
         }
         if(Boolean(this._agility))
         {
            ObjectUtils.disposeObject(this._agility);
            this._agility = null;
         }
         if(Boolean(this._lucky))
         {
            ObjectUtils.disposeObject(this._lucky);
            this._lucky = null;
         }
         if(Boolean(this._attackValue))
         {
            ObjectUtils.disposeObject(this._attackValue);
            this._attackValue = null;
         }
         if(Boolean(this._defenseValue))
         {
            ObjectUtils.disposeObject(this._defenseValue);
            this._defenseValue = null;
         }
         if(Boolean(this._agilityValue))
         {
            ObjectUtils.disposeObject(this._agilityValue);
            this._agilityValue = null;
         }
         if(Boolean(this._luckyValue))
         {
            ObjectUtils.disposeObject(this._luckyValue);
            this._luckyValue = null;
         }
      }
   }
}
