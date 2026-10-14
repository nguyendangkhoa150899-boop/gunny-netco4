package ddt.command
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.CheckMoneyUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class QuickBuyAlertBase extends Frame
   {
       
      
      protected var _bg:Image;
      
      protected var _number:ddt.command.NumberSelecter;
      
      protected var _selectedBtn:SelectedCheckButton;
      
      protected var _selectedBandBtn:SelectedCheckButton;
      
      protected var _totalTipText:FilterFrameText;
      
      protected var totalText:FilterFrameText;
      
      protected var _moneyTxt:FilterFrameText;
      
      protected var _bandMoney:FilterFrameText;
      
      protected var _submitButton:TextButton;
      
      protected var _movieBack:MovieClip;
      
      protected var _sprite:Sprite;
      
      protected var _cell:BagCell;
      
      protected var _perPrice:int;
      
      protected var _isBand:Boolean;
      
      protected var _shopGoodsId:int;
      
      public function QuickBuyAlertBase()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      protected function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtcore.CellBg");
         addToContent(this._bg);
         this._number = ComponentFactory.Instance.creatCustomObject("ddtcore.numberSelecter");
         addToContent(this._number);
         this._totalTipText = ComponentFactory.Instance.creatComponentByStylename("ddtcore.TotalTipsText");
         this._totalTipText.text = LanguageMgr.GetTranslation("ddt.QuickFrame.TotalTipText");
         addToContent(this._totalTipText);
         this.totalText = ComponentFactory.Instance.creatComponentByStylename("ddtcore.TotalText");
         addToContent(this.totalText);
         this._sprite = new Sprite();
         addToContent(this._sprite);
         this._movieBack = ComponentFactory.Instance.creat("asset.core.stranDown");
         this._movieBack.x = 176;
         this._movieBack.y = 116;
         this._sprite.addChild(this._movieBack);
         this._selectedBtn = ComponentFactory.Instance.creatComponentByStylename("vip.core.selectBtn");
         this._selectedBtn.enable = true;
         this._selectedBtn.selected = false;
         this._selectedBtn.x = 83;
         this._selectedBtn.y = 101;
         this._sprite.addChild(this._selectedBtn);
         this._isBand = true;
         this._selectedBandBtn = ComponentFactory.Instance.creatComponentByStylename("vip.core.selectBtn");
         this._selectedBandBtn.enable = false;
         this._selectedBandBtn.selected = true;
         this._selectedBandBtn.x = 183;
         this._selectedBandBtn.y = 101;
         this._sprite.addChild(this._selectedBandBtn);
         this._moneyTxt = ComponentFactory.Instance.creatComponentByStylename("vip.core.bandMoney");
         this._moneyTxt.x = 55;
         this._moneyTxt.y = 107;
         this._moneyTxt.text = LanguageMgr.GetTranslation("ddt.money");
         this._sprite.addChild(this._moneyTxt);
         this._bandMoney = ComponentFactory.Instance.creatComponentByStylename("vip.core.bandMoney");
         this._bandMoney.x = 173;
         this._bandMoney.y = 107;
         this._bandMoney.text = LanguageMgr.GetTranslation("ddt.bandMoney");
         this._sprite.addChild(this._bandMoney);
         this._cell = new BagCell(0);
         this._cell.x = 33;
         this._cell.y = 35;
         addToContent(this._cell);
         this.refreshNumText();
         this._submitButton = ComponentFactory.Instance.creatComponentByStylename("core.quickEnter");
         this._submitButton.text = LanguageMgr.GetTranslation("store.view.shortcutBuy.buyBtn");
         addToContent(this._submitButton);
         this._submitButton.y = 141;
      }
      
      protected function initEvents() : void
      {
         addEventListener("response",this.__frameEventHandler);
         this._selectedBtn.addEventListener("click",this.seletedHander);
         this._selectedBandBtn.addEventListener("click",this.selectedBandHander);
         this._number.addEventListener("change",this.selectHandler);
         this._submitButton.addEventListener("click",this.__buy);
      }
      
      protected function __buy(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         CheckMoneyUtils.instance.checkMoney(this._isBand,this.getNeedMoney(),this.onCheckComplete);
      }
      
      protected function onCheckComplete() : void
      {
         this.submit(CheckMoneyUtils.instance.isBind);
         this.dispose();
      }
      
      protected function getNeedMoney() : int
      {
         return this._perPrice * this._number.number;
      }
      
      protected function submit(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:Array = [];
         var _loc8_:Array = [];
         var _loc9_:Array = [];
         _loc2_ = 0;
         while(_loc2_ <= this._number.number - 1)
         {
            _loc3_.push(this._shopGoodsId);
            _loc4_.push(1);
            _loc5_.push("");
            _loc6_.push(false);
            _loc7_.push("");
            _loc8_.push(-1);
            _loc9_.push(param1);
            _loc2_++;
         }
         SocketManager.Instance.out.sendBuyGoods(_loc3_,_loc4_,_loc5_,_loc8_,_loc6_,_loc7_,0,null,_loc9_);
      }
      
      protected function selectedBandHander(param1:MouseEvent) : void
      {
         if(this._selectedBandBtn.selected)
         {
            this._isBand = true;
            this._selectedBandBtn.enable = false;
            this._selectedBtn.selected = false;
            this._selectedBtn.enable = true;
         }
         else
         {
            this._isBand = false;
         }
         this.refreshNumText();
      }
      
      protected function seletedHander(param1:MouseEvent) : void
      {
         if(this._selectedBtn.selected)
         {
            this._isBand = false;
            this._selectedBandBtn.selected = false;
            this._selectedBandBtn.enable = true;
            this._selectedBtn.enable = false;
         }
         else
         {
            this._isBand = true;
         }
         this.refreshNumText();
      }
      
      private function selectHandler(param1:Event) : void
      {
         this.refreshNumText();
      }
      
      protected function refreshNumText() : void
      {
         var _loc1_:String = String(this._number.number * this._perPrice);
         var _loc2_:String = this._isBand ? LanguageMgr.GetTranslation("ddtMoney") : LanguageMgr.GetTranslation("money");
         this.totalText.text = _loc1_ + " " + _loc2_;
      }
      
      public function setData(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:InventoryItemInfo = null;
         this._perPrice = param3;
         this._shopGoodsId = param2;
         (_loc4_ = new InventoryItemInfo()).TemplateID = param1;
         ItemManager.fill(_loc4_);
         _loc4_.BindType = 4;
         this._cell.info = _loc4_;
         this._cell.setCountNotVisible();
         this._cell.setBgVisible(false);
         this.refreshNumText();
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(int(param1.responseCode))
         {
            case 0:
            case 1:
               this.dispose();
         }
      }
      
      private function removeEvnets() : void
      {
         removeEventListener("response",this.__frameEventHandler);
         this._selectedBtn.removeEventListener("click",this.seletedHander);
         this._selectedBandBtn.removeEventListener("click",this.selectedBandHander);
         this._number.removeEventListener("change",this.selectHandler);
         this._submitButton.removeEventListener("click",this.__buy);
      }
      
      public function get number() : ddt.command.NumberSelecter
      {
         return this._number;
      }
      
      public function set number(param1:ddt.command.NumberSelecter) : void
      {
         this._number = param1;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvnets();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._selectedBtn);
         this._selectedBtn = null;
         ObjectUtils.disposeObject(this._selectedBandBtn);
         this._selectedBandBtn = null;
         ObjectUtils.disposeObject(this._totalTipText);
         this._totalTipText = null;
         ObjectUtils.disposeObject(this.totalText);
         this.totalText = null;
         ObjectUtils.disposeObject(this._moneyTxt);
         this._moneyTxt = null;
         ObjectUtils.disposeObject(this._bandMoney);
         this._bandMoney = null;
         ObjectUtils.disposeObject(this._submitButton);
         this._submitButton = null;
         ObjectUtils.disposeObject(this._movieBack);
         this._movieBack = null;
         ObjectUtils.disposeObject(this._cell);
         this._cell = null;
      }
   }
}
