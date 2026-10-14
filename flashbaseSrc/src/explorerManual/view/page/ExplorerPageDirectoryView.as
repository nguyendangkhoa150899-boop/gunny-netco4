package explorerManual.view.page
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CEvent;
   import ddt.manager.LanguageMgr;
   import explorerManual.ExplorerManualController;
   import explorerManual.data.ExplorerManualInfo;
   import explorerManual.data.model.ManualPageItemInfo;
   import flash.events.Event;
   import flash.events.TextEvent;
   
   public class ExplorerPageDirectoryView extends ExplorerPageRightViewBase
   {
      
      public static const DIRECTIONRY_TURN:String = "directionryTurn";
       
      
      private var _curAllPage:Array;
      
      private var _itemVbox:VBox;
      
      private var _dirTitleTxt:FilterFrameText;
      
      public function ExplorerPageDirectoryView(param1:int, param2:ExplorerManualInfo, param3:ExplorerManualController)
      {
         super(param1,param2,param3);
      }
      
      override protected function initView() : void
      {
         super.initView();
         UICreatShortcut.creatAndAdd("asset.explorerManual.pageDirectory.titleIcon",this);
         this._dirTitleTxt = UICreatShortcut.creatTextAndAdd("explorerManual.pageDicView.chapteTitleTxt",LanguageMgr.GetTranslation("explorerManual.directionyTitle.txt"),this);
         this._itemVbox = ComponentFactory.Instance.creatComponentByStylename("explorerManual.pageDirectoryView.itemVBox");
         addChild(this._itemVbox);
         _hasPieces.visible = false;
         _piecesPregress.visible = false;
      }
      
      override protected function __modelUpdateHandler(param1:Event) : void
      {
      }
      
      override public function set pageInfo(param1:ManualPageItemInfo) : void
      {
         _pageInfo = param1;
      }
      
      public function parentView(param1:ExplorerPageView) : void
      {
      }
      
      public function initDirectory(param1:Array) : void
      {
         this._curAllPage = param1;
         this.clearVBox();
         this.createDic();
      }
      
      private function clearVBox() : void
      {
         var _loc1_:* = null;
         if(Boolean(this._itemVbox))
         {
            while(this._itemVbox.numChildren > 0)
            {
               _loc1_ = this._itemVbox.getChildAt(0) as ExplorerPageDirectorItemView;
               _loc1_.removeEventListener("directorItemClick",this.itemClick_Handler);
               ObjectUtils.disposeObject(this._itemVbox.getChildAt(0));
            }
         }
      }
      
      private function itemLinkClick_Handler(param1:TextEvent) : void
      {
      }
      
      private function createDic() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         if(this._curAllPage == null || this._curAllPage.length <= 0)
         {
            return;
         }
         var _loc4_:int = int(this._curAllPage.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if((_loc1_ = this._curAllPage[_loc3_]).Sort != 0)
            {
               _loc2_ = new ExplorerPageDirectorItemView(_loc3_,_model);
               _loc2_.info = this._curAllPage[_loc3_];
               _loc2_.addEventListener("directorItemClick",this.itemClick_Handler);
               this._itemVbox.addChild(_loc2_);
            }
            _loc3_++;
         }
      }
      
      private function itemClick_Handler(param1:CEvent) : void
      {
         this.dispatchEvent(new CEvent("directionryTurn",param1.data));
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.clearVBox();
         this._curAllPage = null;
         ObjectUtils.disposeObject(this._dirTitleTxt);
         this._dirTitleTxt = null;
      }
   }
}
