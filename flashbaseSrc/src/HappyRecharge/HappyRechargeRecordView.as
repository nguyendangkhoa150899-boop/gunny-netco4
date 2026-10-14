package HappyRecharge
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class HappyRechargeRecordView extends Sprite implements Disposeable
   {
       
      
      private var _conText:FilterFrameText;
      
      private var _type:int;
      
      public function HappyRechargeRecordView(param1:int = 10)
      {
         super();
         this._type = param1;
         this.initText();
      }
      
      private function initText() : void
      {
         if(this._type >= 10 && this._type <= 12)
         {
            switch(int(this._type) - 10)
            {
               case 0:
               case 1:
                  this._conText = ComponentFactory.Instance.creatComponentByStylename("mainframe.record.commondTxt");
                  break;
               case 2:
                  this._conText = ComponentFactory.Instance.creatComponentByStylename("mainframe.record.specialTxt");
            }
            addChild(this._conText);
         }
      }
      
      public function setText(param1:String, param2:String, param3:int) : void
      {
         if(Boolean(this._conText))
         {
            this._conText.text = LanguageMgr.GetTranslation("happyRecharge.mainFrame.record" + this._type,param1,param2,param3);
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._conText);
         this._conText = null;
      }
   }
}
