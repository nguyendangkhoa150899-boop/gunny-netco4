package shop.manager
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.NumberSelecter;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import shop.view.ShopCartItem;
   import shop.view.ShopPresentClearingFrame;
   
   public class ShopGiftsManager
   {
      
      private static var _instance:shop.manager.ShopGiftsManager;
       
      
      private var _frame:Frame;
      
      private var _shopCartItem:ShopCartItem;
      
      private var _commodityPricesText1:FilterFrameText;
      
      private var _commodityPricesText2:FilterFrameText;
      
      private var _commodityPricesText3:FilterFrameText;
      
      private var _giftsBtn:BaseButton;
      
      private var _numberSelecter:NumberSelecter;
      
      private var _goodsID:int;
      
      private var _shopPresentClearingFrame:ShopPresentClearingFrame;
      
      private var _isDiscountType:Boolean = true;
      
      private var _type:int = 0;
      
      public function ShopGiftsManager()
      {
         super();
      }
      
      public static function get Instance() : shop.manager.ShopGiftsManager
      {
         if(_instance == null)
         {
            _instance = new shop.manager.ShopGiftsManager();
         }
         return _instance;
      }
      
      public function buy(param1:int, param2:Boolean = false, param3:int = 1) : void
      {
         if(Boolean(this._frame))
         {
            return;
         }
         this._goodsID = param1;
         this._isDiscountType = param2;
         this._type = param3;
         this.initView();
         this.addEvent();
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function initView() : void
      {
         var _loc1_:ShopCarItemInfo = null;
         this._frame = ComponentFactory.Instance.creatComponentByStylename("core.shop.CheckOutViewFrame");
         this._frame.titleText = LanguageMgr.GetTranslation("shop.view.present");
         var _loc2_:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("core.shop.CheckOutViewBg");
         this._frame.addToContent(_loc2_);
         this._giftsBtn = ComponentFactory.Instance.creatComponentByStylename("core.shop.GiftsBtn");
         this._frame.addToContent(this._giftsBtn);
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.shop.CheckOutViewBg");
         PositionUtils.setPos(_loc3_,"shop.CheckOutViewBgPos");
         this._frame.addToContent(_loc3_);
         var _loc4_:ScaleBitmapImage = ComponentFactory.Instance.creatComponentByStylename("core.shop.NumberSelecterTextBg");
         PositionUtils.setPos(_loc4_,"shop.NumberSelecterTextBgPos");
         this._frame.addToContent(_loc4_);
         var _loc5_:ShopItemInfo = null;
         if(!this._isDiscountType)
         {
            _loc5_ = ShopManager.Instance.getShopItemByGoodsID(this._goodsID);
            if(_loc5_ == null)
            {
               _loc5_ = ShopManager.Instance.getGoodsByTemplateID(this._goodsID);
            }
         }
         _loc1_ = new ShopCarItemInfo(_loc5_.GoodsID,_loc5_.TemplateID);
         ObjectUtils.copyProperties(_loc1_,_loc5_);
         this._shopCartItem = new ShopCartItem();
         PositionUtils.setPos(this._shopCartItem,"shop.shopCartItemPos");
         this._shopCartItem.closeBtn.visible = false;
         this._shopCartItem.shopItemInfo = _loc1_;
         this._shopCartItem.setColor(_loc1_.Color);
         this._frame.addToContent(this._shopCartItem);
         var _loc6_:GradientText = ComponentFactory.Instance.creatComponentByStylename("vipName");
         PositionUtils.setPos(_loc6_,"shop.ShopBuyManagerTextImgPos");
         _loc6_.text = LanguageMgr.GetTranslation("shop.manager.ShopBuyManager.textImg");
         this._frame.addToContent(_loc6_);
         this._numberSelecter = ComponentFactory.Instance.creatComponentByStylename("core.shop.NumberSelecter");
         this._frame.addToContent(this._numberSelecter);
         this._commodityPricesText1 = ComponentFactory.Instance.creatComponentByStylename("core.shop.CommodityPricesText");
         PositionUtils.setPos(this._commodityPricesText1,"shop.commodityPricesText1Pos");
         this._commodityPricesText1.text = "0";
         this._frame.addToContent(this._commodityPricesText1);
         this._commodityPricesText2 = ComponentFactory.Instance.creatComponentByStylename("core.shop.CommodityPricesText");
         PositionUtils.setPos(this._commodityPricesText2,"shop.commodityPricesText2Pos");
         this._commodityPricesText2.text = "0";
         this._frame.addToContent(this._commodityPricesText2);
         this._commodityPricesText3 = ComponentFactory.Instance.creatComponentByStylename("core.shop.CommodityPricesText");
         PositionUtils.setPos(this._commodityPricesText3,"shop.commodityPricesText3Pos");
         this._commodityPricesText3.text = "0";
         this._frame.addToContent(this._commodityPricesText3);
         this.updateCommodityPrices();
      }
      
      private function addEvent() : void
      {
         this._giftsBtn.addEventListener(MouseEvent.CLICK,this.__giftsBtnClick);
         this._numberSelecter.addEventListener(Event.CHANGE,this.__numberSelecterChange);
         this._shopCartItem.addEventListener(ShopCartItem.CONDITION_CHANGE,this.__shopCartItemChange);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GOODS_PRESENT,this.onPresent);
      }
      
      private function removeEvent() : void
      {
         this._giftsBtn.removeEventListener(MouseEvent.CLICK,this.__giftsBtnClick);
         this._numberSelecter.removeEventListener(Event.CHANGE,this.__numberSelecterChange);
         this._shopCartItem.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__shopCartItemChange);
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GOODS_PRESENT,this.onPresent);
      }
      
      private function updateCommodityPrices() : void
      {
         this._commodityPricesText1.text = (this._shopCartItem.shopItemInfo.getCurrentPrice().moneyValue * this._numberSelecter.currentValue).toString();
         this._commodityPricesText2.text = (this._shopCartItem.shopItemInfo.getCurrentPrice().giftValue * this._numberSelecter.currentValue).toString();
         this._commodityPricesText3.text = (this._shopCartItem.shopItemInfo.getCurrentPrice().medalValue * this._numberSelecter.currentValue).toString();
      }
      
      protected function __giftsBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._shopPresentClearingFrame = ComponentFactory.Instance.creatComponentByStylename("core.shop.ShopPresentClearingFrame");
         this._shopPresentClearingFrame.show();
         this._shopPresentClearingFrame.presentBtn.addEventListener(MouseEvent.CLICK,this.__presentBtnClick);
         this._shopPresentClearingFrame.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            StageReferance.stage.focus = this._frame;
         }
      }
      
      protected function __presentBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:ShopCarItemInfo = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._shopPresentClearingFrame.nameInput.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.give"));
            return;
         }
         if(FilterWordManager.IsNullorEmpty(this._shopPresentClearingFrame.nameInput.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.space"));
            return;
         }
         var _loc3_:int = this._shopCartItem.shopItemInfo.getCurrentPrice().moneyValue;
         if(PlayerManager.Instance.Self.Money < _loc3_ && _loc3_ != 0)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         this._shopPresentClearingFrame.presentBtn.enable = false;
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         var _loc7_:Array = new Array();
         var _loc8_:Array = new Array();
         var _loc9_:int = 0;
         while(_loc9_ < this._numberSelecter.currentValue)
         {
            _loc2_ = this._shopCartItem.shopItemInfo;
            _loc4_.push(_loc2_.GoodsID);
            _loc5_.push(_loc2_.currentBuyType);
            _loc6_.push(_loc2_.Color);
            _loc7_.push("");
            _loc8_.push("");
            _loc9_++;
         }
         var _loc10_:String = FilterWordManager.filterWrod(this._shopPresentClearingFrame.textArea.text);
         SocketManager.Instance.out.sendPresentGoods(_loc4_,_loc5_,_loc6_,_loc10_,this._shopPresentClearingFrame.nameInput.text);
      }
      
      protected function onPresent(param1:CrazyTankSocketEvent) : void
      {
         this._shopPresentClearingFrame.presentBtn.enable = true;
         this._shopPresentClearingFrame.presentBtn.removeEventListener(MouseEvent.CLICK,this.__presentBtnClick);
         this._shopPresentClearingFrame.dispose();
         this._shopPresentClearingFrame = null;
         var _loc2_:Boolean = param1.pkg.readBoolean();
         this.dispose();
      }
      
      protected function __numberSelecterChange(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this.updateCommodityPrices();
      }
      
      protected function __shopCartItemChange(param1:Event) : void
      {
         this.updateCommodityPrices();
      }
      
      protected function __framePesponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
         }
      }
      
      private function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._frame);
         this._frame = null;
         ObjectUtils.disposeObject(this._shopCartItem);
         this._shopCartItem = null;
         ObjectUtils.disposeObject(this._commodityPricesText1);
         this._commodityPricesText1 = null;
         ObjectUtils.disposeObject(this._commodityPricesText2);
         this._commodityPricesText1 = null;
         ObjectUtils.disposeObject(this._commodityPricesText3);
         this._commodityPricesText1 = null;
         ObjectUtils.disposeObject(this._giftsBtn);
         this._giftsBtn = null;
         ObjectUtils.disposeObject(this._numberSelecter);
         this._numberSelecter = null;
      }
   }
}
