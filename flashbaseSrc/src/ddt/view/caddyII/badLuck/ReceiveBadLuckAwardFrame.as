package ddt.view.caddyII.badLuck
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.InventoryItemAnalyzer;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.RouletteManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   
   public class ReceiveBadLuckAwardFrame extends BaseAlerFrame
   {
       
      
      private var _bg:Scale9CornerImage;
      
      private var _bg2:Scale9CornerImage;
      
      private var _bg3:ScaleBitmapImage;
      
      private var _bg4:ScaleBitmapImage;
      
      private var _bg5:MutipleImage;
      
      private var _bg6:Bitmap;
      
      private var _bg7:Bitmap;
      
      private var _titleBit:Bitmap;
      
      private var _list:VBox;
      
      private var _panel:ScrollPanel;
      
      private var _itemList:Vector.<ddt.view.caddyII.badLuck.ReceiveBadLuckItem>;
      
      private var _goodList:Vector.<InventoryItemInfo>;
      
      private var _dataList:Vector.<Object>;
      
      public function ReceiveBadLuckAwardFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var _loc1_:ddt.view.caddyII.badLuck.ReceiveBadLuckItem = null;
         var _loc2_:AlertInfo = new AlertInfo();
         _loc2_.submitLabel = LanguageMgr.GetTranslation("ok");
         _loc2_.showCancel = false;
         info = _loc2_;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("caddy.RBadLuckBGI");
         this._titleBit = ComponentFactory.Instance.creatBitmap("asset.RBadLuck.FontTitle");
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("caddy.RBadLuckBGII");
         this._bg3 = ComponentFactory.Instance.creatComponentByStylename("caddy.RBadLuckBGIII");
         this._bg4 = ComponentFactory.Instance.creatComponentByStylename("caddy.RBadLuckBGV");
         this._bg5 = ComponentFactory.Instance.creatComponentByStylename("caddy.RbadLuckTitle");
         this._bg6 = ComponentFactory.Instance.creatBitmap("asset.RBadLuck.FontR");
         this._bg7 = ComponentFactory.Instance.creatBitmap("asset.RBadLuck.FontRbadEx");
         addToContent(this._bg);
         addToContent(this._titleBit);
         addToContent(this._bg2);
         addToContent(this._bg3);
         addToContent(this._bg4);
         addToContent(this._bg5);
         addToContent(this._bg6);
         addToContent(this._bg7);
         this._list = ComponentFactory.Instance.creatComponentByStylename("caddy.RbadLuckBox");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("caddy.RbadLuckScrollpanel");
         this._panel.setView(this._list);
         this._panel.invalidateViewport();
         addToContent(this._panel);
         this._itemList = new Vector.<ReceiveBadLuckItem>();
         var _loc3_:int = 0;
         while(_loc3_ < 10)
         {
            _loc1_ = ComponentFactory.Instance.creatCustomObject("card.ReceiveBadLuckItem");
            this._list.addChild(_loc1_);
            this._itemList.push(_loc1_);
            _loc3_++;
         }
         this._panel.invalidateViewport();
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function creatItemTempleteLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("User_LotteryRank.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGoodsTemplateFailure");
         _loc1_.analyzer = new InventoryItemAnalyzer(this.__loadComplete);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoaderManager.Instance.startLoad(_loc1_);
         return _loc1_;
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:String = param1.loader.loadErrorMessage;
         if(Boolean(param1.loader.analyzer))
         {
            if(param1.loader.analyzer.message != null)
            {
               _loc2_ = param1.loader.loadErrorMessage + "\n" + param1.loader.analyzer.message;
            }
         }
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),_loc2_,LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"));
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function __loadComplete(param1:InventoryItemAnalyzer) : void
      {
         RouletteManager.instance.goodList = this._goodList = param1.list;
         this.updateData();
      }
      
      private function updateData() : void
      {
         var _loc1_:InventoryItemInfo = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Date = TimeManager.Instance.Now();
         for each(_loc1_ in this._goodList)
         {
            _loc1_.BeginDate = _loc4_.fullYear + "-" + (_loc4_.month + 1) + "-" + _loc4_.date + " " + _loc4_.hours + ":" + _loc4_.minutes + ":" + _loc4_.seconds;
         }
         _loc2_ = 0;
         while(_loc2_ < 10 && _loc2_ < this._goodList.length)
         {
            if(this._dataList == null || _loc2_ >= this._dataList.length || this._dataList[_loc2_] == null)
            {
               _loc3_ = "MyName";
            }
            else
            {
               _loc3_ = String(this._dataList[_loc2_].Nickname);
            }
            this._itemList[_loc2_].update(_loc2_,_loc3_,this._goodList[_loc2_]);
            _loc2_++;
         }
      }
      
      private function __response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            ObjectUtils.disposeObject(this);
         }
      }
      
      public function set dataList(param1:Vector.<Object>) : void
      {
         this._dataList = param1;
      }
      
      public function show() : void
      {
         if(RouletteManager.instance.goodList == null)
         {
            this.creatItemTempleteLoader();
         }
         else
         {
            this._goodList = RouletteManager.instance.goodList;
            this.updateData();
         }
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         var _loc1_:ddt.view.caddyII.badLuck.ReceiveBadLuckItem = null;
         this.removeEvents();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._bg2))
         {
            ObjectUtils.disposeObject(this._bg2);
         }
         this._bg2 = null;
         if(Boolean(this._bg3))
         {
            ObjectUtils.disposeObject(this._bg3);
         }
         this._bg3 = null;
         if(Boolean(this._bg4))
         {
            ObjectUtils.disposeObject(this._bg4);
         }
         this._bg4 = null;
         if(Boolean(this._bg5))
         {
            ObjectUtils.disposeObject(this._bg5);
         }
         this._bg5 = null;
         if(Boolean(this._bg6))
         {
            ObjectUtils.disposeObject(this._bg6);
         }
         this._bg6 = null;
         if(Boolean(this._bg7))
         {
            ObjectUtils.disposeObject(this._bg7);
         }
         this._bg7 = null;
         if(Boolean(this._titleBit))
         {
            ObjectUtils.disposeObject(this._titleBit);
         }
         this._titleBit = null;
         for each(_loc1_ in this._itemList)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._panel))
         {
            ObjectUtils.disposeObject(this._panel);
         }
         this._panel = null;
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
