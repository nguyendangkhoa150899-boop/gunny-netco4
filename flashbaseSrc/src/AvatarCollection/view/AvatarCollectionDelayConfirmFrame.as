package AvatarCollection.view
{
   import AvatarCollection.AvatarCollectionManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.NumberSelecter;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   
   public class AvatarCollectionDelayConfirmFrame extends BaseAlerFrame
   {
       
      
      private var _numberSelecter:NumberSelecter;
      
      private var _text:FilterFrameText;
      
      private var _needFoodText:FilterFrameText;
      
      private var _dayHonour:int;
      
      private var count:Number;
      
      public function AvatarCollectionDelayConfirmFrame()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         var _loc1_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("avatarCollection.delayConfirmFrame.titleTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         _loc1_.moveEnable = false;
         info = _loc1_;
         this.escEnable = true;
         this._text = ComponentFactory.Instance.creatComponentByStylename("avatarColl.delayConfirmFrame.dayNameTxt");
         this._text.text = LanguageMgr.GetTranslation("avatarCollection.delayConfirmFrame.dayNameTxt");
         this._numberSelecter = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.NumberSelecter");
         this._numberSelecter.addEventListener("change",this.__seleterChange);
         PositionUtils.setPos(this._numberSelecter,"avatarColl.delayConfirmFrame.numberSelecterPos");
         this._needFoodText = ComponentFactory.Instance.creatComponentByStylename("avatarColl.delayConfirmFrame.promptTxt");
         addToContent(this._text);
         addToContent(this._numberSelecter);
         addToContent(this._needFoodText);
      }
      
      private function __seleterChange(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this._needFoodText.htmlText = LanguageMgr.GetTranslation("avatarCollection.delayConfirmFrame.promptTxt",this._numberSelecter.currentValue * this._dayHonour,this.count);
      }
      
      public function show(param1:int, param2:int) : void
      {
         this.count = AvatarCollectionManager.instance.getDelayTimeCollectionCount();
         this._dayHonour = param1;
         this._needFoodText.htmlText = LanguageMgr.GetTranslation("avatarCollection.delayConfirmFrame.promptTxt",this._dayHonour,this.count);
         this._numberSelecter.valueLimit = "1,99";
      }
      
      public function get selectValue() : int
      {
         return this._numberSelecter.currentValue;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._numberSelecter = null;
         this._text = null;
         this._needFoodText = null;
      }
   }
}
