package com.pickgliss.ui.controls.alert
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.vo.AlertInfo;
   
   public class SimpleAlertWithNotShowAgain extends SimpleAlert
   {
       
      
      private var _scb:SelectedCheckButton;
      
      public function SimpleAlertWithNotShowAgain()
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
         this._scb = ComponentFactory.Instance.creatComponentByStylename("ddtGame.buyConfirmNo.scb");
         addToContent(this._scb);
         this._scb.text = "Không nhắc nữa";
         if(info.type == 0)
         {
            this._scb.x = (this.width - this._scb.width - 30) / 2;
            this._scb.y = _textField.height + _textField.y - 95 + 35 - 5 - this._scb.height + 46;
         }
         else
         {
            this._scb.x = 15;
            this._scb.y = 60;
         }
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(!_seleContent)
         {
            return;
         }
         _backgound.width = Math.max(_width,_seleContent.width + 14);
         _backgound.height = _height + 40;
         _submitButton.y += 40;
         _cancelButton.y += 40;
      }
      
      override protected function layoutFrameRect() : void
      {
         this.height -= 30;
         super.layoutFrameRect();
         this.height += 30;
      }
   }
}
