package pyramid.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import pyramid.PyramidManager;
   import pyramid.event.PyramidEvent;
   
   public class PyramidShopView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _goodItemContainerAll:Sprite;
      
      private var _currentPageInput:Scale9CornerImage;
      
      private var _currentPageTxt:FilterFrameText;
      
      private var _firstPageBtn:BaseButton;
      
      private var _prePageBtn:BaseButton;
      
      private var _nextPageBtn:BaseButton;
      
      private var _endPageBtn:BaseButton;
      
      private var _navigationBarContainer:Sprite;
      
      private var _goodItems:Vector.<pyramid.view.PyramidShopItem>;
      
      private var SHOP_ITEM_NUM:int = 8;
      
      private var CURRENT_PAGE:int = 1;
      
      public function PyramidShopView()
      {
         super();
         this.initView();
         this.initEvent();
         this.loadList();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc3_:Number = NaN;
         _loc1_ = 0;
         var _loc2_:Number = NaN;
         _loc3_ = NaN;
         this._bg = ComponentFactory.Instance.creatBitmap("assets.pyramid.shopViewBg");
         addChild(this._bg);
         this._goodItemContainerAll = ComponentFactory.Instance.creatCustomObject("pyramid.view.goodItemContainerAll");
         addChild(this._goodItemContainerAll);
         this._navigationBarContainer = ComponentFactory.Instance.creatCustomObject("pyramid.view.navigationBarContainer");
         addChild(this._navigationBarContainer);
         this._firstPageBtn = UICreatShortcut.creatAndAdd("shopktt.BtnFirstPage",this._navigationBarContainer);
         this._prePageBtn = UICreatShortcut.creatAndAdd("shopktt.BtnPrePage",this._navigationBarContainer);
         this._nextPageBtn = UICreatShortcut.creatAndAdd("shopktt.BtnNextPage",this._navigationBarContainer);
         this._endPageBtn = UICreatShortcut.creatAndAdd("shopktt.BtnEndPage",this._navigationBarContainer);
         this._currentPageInput = UICreatShortcut.creatAndAdd("shopktt.CurrentPageInput",this._navigationBarContainer);
         this._currentPageTxt = UICreatShortcut.creatAndAdd("shopktt.CurrentPage",this._navigationBarContainer);
         this._goodItems = new Vector.<PyramidShopItem>();
         _loc1_ = 0;
         while(_loc1_ < this.SHOP_ITEM_NUM)
         {
            this._goodItems[_loc1_] = ComponentFactory.Instance.creatCustomObject("pyramid.view.pyramidShopItem");
            _loc2_ = this._goodItems[_loc1_].width;
            _loc3_ = this._goodItems[_loc1_].height;
            _loc2_ *= int(_loc1_ % 2);
            _loc3_ *= int(_loc1_ / 2);
            this._goodItems[_loc1_].x = _loc2_;
            this._goodItems[_loc1_].y = _loc3_ + _loc1_ / 2 * 2;
            this._goodItemContainerAll.addChild(this._goodItems[_loc1_]);
            _loc1_++;
         }
      }
      
      public function loadList() : void
      {
         this.setList(ShopManager.Instance.getValidSortedGoodsByType(this.getType(),this.CURRENT_PAGE));
      }
      
      public function setList(param1:Vector.<ShopItemInfo>) : void
      {
         this.clearitems();
         var _loc2_:int = 0;
         while(_loc2_ < this.SHOP_ITEM_NUM)
         {
            if(!param1)
            {
               break;
            }
            if(_loc2_ < param1.length && Boolean(param1[_loc2_]))
            {
               this._goodItems[_loc2_].shopItemInfo = param1[_loc2_];
            }
            _loc2_++;
         }
         this._currentPageTxt.text = this.CURRENT_PAGE + "/" + ShopManager.Instance.getResultPages(this.getType());
      }
      
      private function initEvent() : void
      {
         this._prePageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._firstPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._endPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         PyramidManager.instance.model.addEventListener(PyramidEvent.START_OR_STOP,this.__stopScoreUpdateHandler);
         PyramidManager.instance.model.addEventListener(PyramidEvent.DATA_CHANGE,this.__dataChangeHandler);
      }
      
      private function __stopScoreUpdateHandler(param1:PyramidEvent) : void
      {
         this.updateShopItemGreyState();
      }
      
      private function __dataChangeHandler(param1:PyramidEvent) : void
      {
         this.updateShopItemGreyState();
      }
      
      private function updateShopItemGreyState() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this._goodItems))
         {
            _loc1_ = 0;
            while(_loc1_ < this._goodItems.length)
            {
               this._goodItems[_loc1_].updateGreyState();
               _loc1_++;
            }
         }
      }
      
      private function __pageBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(ShopManager.Instance.getResultPages(this.getType()) == 0)
         {
            return;
         }
         switch(param1.currentTarget)
         {
            case this._firstPageBtn:
               if(this.CURRENT_PAGE != 1)
               {
                  this.CURRENT_PAGE = 1;
               }
               break;
            case this._prePageBtn:
               if(this.CURRENT_PAGE == 1)
               {
                  this.CURRENT_PAGE = ShopManager.Instance.getResultPages(this.getType()) + 1;
               }
               --this.CURRENT_PAGE;
               break;
            case this._nextPageBtn:
               if(this.CURRENT_PAGE == ShopManager.Instance.getResultPages(this.getType()))
               {
                  this.CURRENT_PAGE = 0;
               }
               ++this.CURRENT_PAGE;
               break;
            case this._endPageBtn:
               if(this.CURRENT_PAGE != ShopManager.Instance.getResultPages(this.getType()))
               {
                  this.CURRENT_PAGE = ShopManager.Instance.getResultPages(this.getType());
               }
         }
         this.loadList();
      }
      
      private function clearitems() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.SHOP_ITEM_NUM)
         {
            this._goodItems[_loc1_].shopItemInfo = null;
            _loc1_++;
         }
      }
      
      public function getType() : int
      {
         return 98;
      }
      
      private function removeEvent() : void
      {
         this._prePageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._firstPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._endPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         PyramidManager.instance.model.removeEventListener(PyramidEvent.START_OR_STOP,this.__stopScoreUpdateHandler);
         PyramidManager.instance.model.removeEventListener(PyramidEvent.DATA_CHANGE,this.__dataChangeHandler);
      }
      
      private function disposeItems() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._goodItems.length)
         {
            ObjectUtils.disposeObject(this._goodItems[_loc1_]);
            this._goodItems[_loc1_] = null;
            _loc1_++;
         }
         this._goodItems = null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.disposeItems();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeAllChildren(this._goodItemContainerAll);
         ObjectUtils.disposeObject(this._goodItemContainerAll);
         this._goodItemContainerAll = null;
         ObjectUtils.disposeObject(this._currentPageInput);
         this._currentPageInput = null;
         ObjectUtils.disposeObject(this._currentPageTxt);
         this._currentPageTxt = null;
         ObjectUtils.disposeObject(this._firstPageBtn);
         this._firstPageBtn = null;
         ObjectUtils.disposeObject(this._prePageBtn);
         this._prePageBtn = null;
         ObjectUtils.disposeObject(this._nextPageBtn);
         this._nextPageBtn = null;
         ObjectUtils.disposeObject(this._endPageBtn);
         this._endPageBtn = null;
         ObjectUtils.disposeAllChildren(this._navigationBarContainer);
         ObjectUtils.disposeObject(this._navigationBarContainer);
         this._navigationBarContainer = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
