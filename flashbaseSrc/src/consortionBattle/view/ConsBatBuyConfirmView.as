package consortionBattle.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.SimpleAlert;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class ConsBatBuyConfirmView extends SimpleAlert
   {
       
      
      private var _scb:SelectedCheckButton;
      
      public function ConsBatBuyConfirmView()
      {
         super();
      }
      
      public function get isNoPrompt() : Boolean
      {
         return this._scb.selected;
      }
      
      override public function set info(param1:AlertInfo) : void
      {
         super.info = param1;
         this._scb = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.buyConfirmNo.scb");
         addToContent(this._scb);
         this._scb.text = LanguageMgr.GetTranslation("ddt.consortiaBattle.buyConfirm.noAlertTxt");
         if(!_seleContent)
         {
            _seleContent = new Sprite();
            addToContent(_seleContent);
            _seleContent.x = this.width / 2 - _seleContent.width / 2 - _seleContent.parent.x;
            _seleContent.y = _textField.height + _textField.y - 95;
         }
         _seleContent.y += 28;
         this._scb.x = _seleContent.x + (_seleContent.width - this._scb.width) / 2;
      }
      
      public function resetPoint(param1:int, param2:int) : void
      {
         _seleContent.x = param1;
         _seleContent.y = param2;
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(!_seleContent)
         {
            return;
         }
         _backgound.width = Math.max(_width,_seleContent.width + 14);
         _backgound.height = _height + 31;
         _submitButton.y += 31;
         _cancelButton.y += 31;
      }
   }
}
