package godCardRaise.view
{
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import godCardRaise.GodCardRaiseManager;
   import godCardRaise.info.GodCardListInfo;
   
   public class GodCardRaiseExchangeRightCard extends Sprite implements Disposeable
   {
       
      
      private var _info:Object;
      
      private var _cradInfo:GodCardListInfo;
      
      private var _countTxt:FilterFrameText;
      
      private var _loaderPic:DisplayLoader;
      
      private var _picBmp:Bitmap;
      
      public function GodCardRaiseExchangeRightCard(param1:Object)
      {
         super();
         this._info = param1;
         this._cradInfo = GodCardRaiseManager.Instance.godCardListInfoList[this._info.cardId];
         this.initView();
      }
      
      private function initView() : void
      {
         this._countTxt = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseExchangeRightCard.countTxt");
         addChild(this._countTxt);
         this._loaderPic = LoadResourceManager.Instance.createLoader(PathManager.solveGodCardRaisePath(this._cradInfo.Pic),0);
         this._loaderPic.addEventListener("complete",this.__picComplete);
         LoadResourceManager.Instance.startLoad(this._loaderPic);
         this.updateView();
      }
      
      private function __picComplete(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener("complete",this.__picComplete);
         if(param1.loader.isSuccess)
         {
            this._picBmp = param1.loader.content as Bitmap;
            addChild(this._picBmp);
         }
      }
      
      public function updateView() : void
      {
         var _loc1_:int = int(GodCardRaiseManager.Instance.model.cards[this._info.cardId]);
         this._countTxt.text = LanguageMgr.GetTranslation("godCardRaiseExchangeRightCard.countTxtMsg",_loc1_,this._info.cardCount);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._loaderPic))
         {
            this._loaderPic.removeEventListener("complete",this.__picComplete);
            this._loaderPic = null;
         }
         ObjectUtils.disposeAllChildren(this);
         this._countTxt = null;
         this._info = null;
         this._cradInfo = null;
         this._picBmp = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
