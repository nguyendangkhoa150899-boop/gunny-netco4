package godCardRaise.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.NumberSelecter;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.events.Event;
   import godCardRaise.info.GodCardListInfo;
   
   public class GodCardRaiseAtlasCardAlert extends BaseAlerFrame
   {
       
      
      private var _alertInfo:AlertInfo;
      
      private var _numberSelecter:NumberSelecter;
      
      private var _contentTxt:FilterFrameText;
      
      private var _useClipCountTxt:FilterFrameText;
      
      private var _type:int;
      
      private var _godCardListInfo:GodCardListInfo;
      
      public function GodCardRaiseAtlasCardAlert()
      {
         super();
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         this._alertInfo.submitLabel = LanguageMgr.GetTranslation("ok");
         this._alertInfo.cancelLabel = LanguageMgr.GetTranslation("cancel");
         this._alertInfo.moveEnable = false;
         this._alertInfo.enterEnable = false;
         info = this._alertInfo;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._numberSelecter = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseAtlasCard.NumberSelecter");
         addToContent(this._numberSelecter);
         this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseAtlasCard.contentTxt");
         addToContent(this._contentTxt);
         this._useClipCountTxt = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseAtlasCard.useClipCountTxt");
         addToContent(this._useClipCountTxt);
      }
      
      private function initEvent() : void
      {
         this._numberSelecter.addEventListener(Event.CHANGE,this.__numberSelecterHandler);
      }
      
      private function __numberSelecterHandler(param1:Event) : void
      {
         if(this._type == 1)
         {
            this._useClipCountTxt.text = LanguageMgr.GetTranslation("godCardRaiseAtlasCard.smashMsg3",this._numberSelecter.currentValue,int(this._numberSelecter.currentValue * this._godCardListInfo.Decompose));
         }
         else
         {
            this._useClipCountTxt.text = LanguageMgr.GetTranslation("godCardRaiseAtlasCard.compositeMsg3",this._numberSelecter.currentValue,int(this._numberSelecter.currentValue * this._godCardListInfo.Composition));
         }
      }
      
      public function set setType(param1:int) : void
      {
         this._type = param1;
         if(this._type == 1)
         {
            this._useClipCountTxt.text = LanguageMgr.GetTranslation("godCardRaiseAtlasCard.smashMsg3",1,this._godCardListInfo.Decompose);
         }
         else
         {
            this._useClipCountTxt.text = LanguageMgr.GetTranslation("godCardRaiseAtlasCard.compositeMsg3",1,this._godCardListInfo.Composition);
         }
      }
      
      public function set setInfo(param1:GodCardListInfo) : void
      {
         this._godCardListInfo = param1;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,2,true,1);
      }
      
      public function get count() : Number
      {
         return this._numberSelecter.currentValue;
      }
      
      public function set valueLimit(param1:String) : void
      {
         this._numberSelecter.valueLimit = param1;
      }
      
      private function removeEvent() : void
      {
         this._numberSelecter.removeEventListener("change",this.__numberSelecterHandler);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._numberSelecter);
         ObjectUtils.disposeObject(this._contentTxt);
         ObjectUtils.disposeObject(this._useClipCountTxt);
         this._numberSelecter = null;
         this._contentTxt = null;
         this._useClipCountTxt = null;
         this._godCardListInfo = null;
         super.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
