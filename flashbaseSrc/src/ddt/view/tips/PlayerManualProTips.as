package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import explorerManual.ExplorerManualManager;
   import explorerManual.data.ManualProType;
   import explorerManual.data.model.ManualItemInfo;
   import explorerManual.data.model.PlayerManualProInfo;
   
   public class PlayerManualProTips extends BaseTip
   {
       
      
      private var _title:FilterFrameText;
      
      private var _tipContainer:VBox;
      
      public function PlayerManualProTips()
      {
         super();
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      override protected function init() : void
      {
         super.init();
         tipbackgound = ComponentFactory.Instance.creat("core.simpleSuitTipsBg");
         _tipbackgound.width = 140;
         _tipbackgound.height = 220;
         this._title = ComponentFactory.Instance.creatComponentByStylename("explorerManual.playerManual.titleText");
         addChild(this._title);
         this._tipContainer = new VBox();
         this._tipContainer.spacing = 4;
         this._tipContainer.y = 37;
         this._tipContainer.x = 10;
         addChild(this._tipContainer);
      }
      
      override public function set tipData(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         if(Boolean(this._tipContainer))
         {
            this._tipContainer.clearAllChild();
         }
         var _loc4_:PlayerManualProInfo = param1 as PlayerManualProInfo;
         var _loc5_:ManualItemInfo = ExplorerManualManager.instance.getManualInfoByManualLev(Math.max(_loc4_.manual_Level,1));
         this._title.text = _loc5_.Name;
         var _loc6_:Array = LanguageMgr.GetTranslation("explorerManual.manualAllPro.name").split(",");
         var _loc7_:Array = ManualProType.proArr;
         _loc3_ = 0;
         while(_loc3_ < _loc7_.length)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("explorerManual.playerManual.propertyText");
            this._tipContainer.addChild(_loc2_);
            _loc2_.htmlText = _loc6_[_loc3_] + " <font color=\'#76ff80\'>+" + _loc4_[_loc7_[_loc3_]] + "</font>";
            _loc3_++;
         }
         this._tipContainer.arrange();
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._title))
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         removeChildren();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
