package explorerManual.view.shop
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import explorerManual.ExplorerManualController;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ExplorerManualShop extends Frame
   {
      
      private static const MAXNUM:int = 4;
       
      
      private var _ctrl:ExplorerManualController;
      
      private var _bg:Bitmap;
      
      private var _titleIcon:Bitmap;
      
      private var _descTxt:FilterFrameText;
      
      private var _pageTxt:FilterFrameText;
      
      private var _explorerNum:FilterFrameText;
      
      private var _explorerPointIcon:Bitmap;
      
      private var _explorerPointValaue:FilterFrameText;
      
      private var _manualTxt:FilterFrameText;
      
      private var _goodsInfoList:Vector.<ShopItemInfo>;
      
      private var _shopCellList:Vector.<explorerManual.view.shop.ManualShopCell>;
      
      private var _totlePage:int;
      
      private var _currentPage:int;
      
      private var _foreBtn:SimpleBitmapButton;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _inputBg:Scale9CornerImage;
      
      private var _inputBg1:Scale9CornerImage;
      
      public function ExplorerManualShop(param1:ExplorerManualController)
      {
         this._ctrl = param1;
         this.initData();
         super();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,3,true,1);
         this.initEvent();
      }
      
      private function initData() : void
      {
         this._goodsInfoList = ShopManager.Instance.getValidGoodByType(109);
         var _loc1_:int = int(this._goodsInfoList.length);
         this._totlePage = Math.ceil(_loc1_ / 4);
         this._currentPage = 1;
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this._response);
         this._foreBtn.addEventListener("click",this.__changePageHandler);
         this._nextBtn.addEventListener("click",this.__changePageHandler);
         PlayerManager.Instance.Self.addEventListener("propertychange",this.__propertyChangeHandler);
      }
      
      private function _response(param1:FrameEvent) : void
      {
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this._response);
         this._foreBtn.removeEventListener("click",this.__changePageHandler);
         this._nextBtn.removeEventListener("click",this.__changePageHandler);
         PlayerManager.Instance.Self.removeEventListener("propertychange",this.__propertyChangeHandler);
      }
      
      private function __propertyChangeHandler(param1:PlayerPropertyEvent) : void
      {
         if(Boolean(param1.changedProperties["jampsCurrency"]))
         {
            this.updateJampsCurrency();
         }
      }
      
      private function updateJampsCurrency() : void
      {
         this._explorerPointValaue.text = PlayerManager.Instance.Self.jampsCurrency.toString();
      }
      
      private function __changePageHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:SimpleBitmapButton = param1.currentTarget as SimpleBitmapButton;
         switch(_loc2_)
         {
            case this._foreBtn:
               if(this._currentPage <= 1)
               {
                  this._currentPage = this._totlePage;
               }
               else
               {
                  --this._currentPage;
               }
               break;
            case this._nextBtn:
               if(this._currentPage >= this._totlePage)
               {
                  this._currentPage = 1;
               }
               else
               {
                  ++this._currentPage;
               }
         }
         this.refreshView();
      }
      
      override protected function init() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         super.init();
         titleText = LanguageMgr.GetTranslation("explorerManual.manualShop.titleTxt");
         this._bg = ComponentFactory.Instance.creat("asset.explorerManual.shop.bgAsset");
         addToContent(this._bg);
         this._titleIcon = ComponentFactory.Instance.creat("asset.explorerManual.shop.exchangeShop.txtIcon");
         this._descTxt = ComponentFactory.Instance.creatComponentByStylename("explorerManual.shop.descText");
         this._descTxt.text = LanguageMgr.GetTranslation("explorerManual.shop.desc.text");
         this._explorerNum = ComponentFactory.Instance.creatComponentByStylename("explorerManual.shop.explorerNum");
         this._explorerNum.text = LanguageMgr.GetTranslation("explorerManual.shop.explorerNum");
         PositionUtils.setPos(this._explorerNum,"explorerManual.manualShop.manualTxt.pos");
         this._manualTxt = ComponentFactory.Instance.creatComponentByStylename("explorerManual.shop.explorerNum");
         this._manualTxt.text = LanguageMgr.GetTranslation("explorerManual.shop.manualTxt");
         this._explorerPointIcon = ComponentFactory.Instance.creat("asset.explorerManual.shop.explorerPoint.txtIcon");
         this._explorerPointValaue = ComponentFactory.Instance.creatComponentByStylename("explorerManual.shop.explorerPointValue");
         this._explorerPointValaue.text = "100";
         this._pageTxt = ComponentFactory.Instance.creatComponentByStylename("explorerManual.pageTxt");
         this._foreBtn = ComponentFactory.Instance.creatComponentByStylename("explorerManual.foreBtn");
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("explorerManual.nextBtn");
         this._inputBg = ComponentFactory.Instance.creat("explorerManual.inputBg");
         this._inputBg1 = ComponentFactory.Instance.creat("explorerManual.inputBg");
         PositionUtils.setPos(this._inputBg1,"explorerManual.manualShop.explorerValuepos");
         this._shopCellList = new Vector.<ManualShopCell>(4);
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            _loc1_ = new explorerManual.view.shop.ManualShopCell();
            _loc1_.x = 24 + _loc2_ % 2 * (_loc1_.width + 3);
            _loc1_.y = 173 + int(_loc2_ / 2) * (_loc1_.height + 2);
            addToContent(_loc1_);
            this._shopCellList[_loc2_] = _loc1_;
            _loc2_++;
         }
         this.updateJampsCurrency();
         this.refreshView();
      }
      
      private function refreshView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this._pageTxt.text = this._currentPage + "/" + this._totlePage;
         var _loc3_:int = (this._currentPage - 1) * 4;
         var _loc4_:int = int(this._goodsInfoList.length);
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = _loc3_ + _loc1_;
            if(_loc2_ >= _loc4_)
            {
               this._shopCellList[_loc1_].visible = false;
            }
            else
            {
               this._shopCellList[_loc1_].visible = true;
               this._shopCellList[_loc1_].refreshShow(this._goodsInfoList[_loc2_]);
            }
            _loc1_++;
         }
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(Boolean(this._titleIcon))
         {
            addToContent(this._titleIcon);
         }
         if(Boolean(this._descTxt))
         {
            addToContent(this._descTxt);
         }
         if(Boolean(this._explorerNum))
         {
            addToContent(this._explorerNum);
         }
         if(Boolean(this._manualTxt))
         {
            addToContent(this._manualTxt);
         }
         if(Boolean(this._foreBtn))
         {
            addToContent(this._foreBtn);
         }
         if(Boolean(this._nextBtn))
         {
            addToContent(this._nextBtn);
         }
         if(Boolean(this._explorerPointIcon))
         {
            addToContent(this._explorerPointIcon);
         }
         if(Boolean(this._inputBg))
         {
            addToContent(this._inputBg);
         }
         if(Boolean(this._inputBg1))
         {
            addToContent(this._inputBg1);
         }
         if(Boolean(this._explorerPointValaue))
         {
            addToContent(this._explorerPointValaue);
         }
         if(Boolean(this._pageTxt))
         {
            addToContent(this._pageTxt);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._manualTxt);
         this._manualTxt = null;
         ObjectUtils.disposeObject(this._titleIcon);
         this._titleIcon = null;
         ObjectUtils.disposeObject(this._explorerNum);
         this._explorerNum = null;
         ObjectUtils.disposeObject(this._descTxt);
         this._descTxt = null;
         ObjectUtils.disposeObject(this._pageTxt);
         this._pageTxt = null;
         ObjectUtils.disposeObject(this._nextBtn);
         this._nextBtn = null;
         ObjectUtils.disposeObject(this._inputBg);
         this._inputBg = null;
         ObjectUtils.disposeObject(this._foreBtn);
         this._foreBtn = null;
         while(Boolean(this._shopCellList) && this._shopCellList.length > 0)
         {
            ObjectUtils.disposeObject(this._shopCellList.shift());
         }
         this._shopCellList = null;
         this._goodsInfoList = null;
         this._ctrl = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
