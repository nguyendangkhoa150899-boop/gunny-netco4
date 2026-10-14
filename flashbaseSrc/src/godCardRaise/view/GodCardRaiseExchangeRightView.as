package godCardRaise.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import godCardRaise.GodCardRaiseManager;
   import godCardRaise.info.GodCardListGroupInfo;
   
   public class GodCardRaiseExchangeRightView extends Sprite implements Disposeable
   {
      
      private static var notAlertAgain:Boolean;
       
      
      private var _rightBg:Bitmap;
      
      private var _exchangeCellBg:Bitmap;
      
      private var _exchangeCell:BagCell;
      
      private var _exchangeBtn:BaseButton;
      
      private var _remainCountTxt:FilterFrameText;
      
      private var _cards:Sprite;
      
      private var _info:GodCardListGroupInfo;
      
      private var _canUseUniversalCard:Boolean;
      
      public function GodCardRaiseExchangeRightView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._rightBg = ComponentFactory.Instance.creatBitmap("asset.godCardRaiseExchangeView.rightBg");
         addChild(this._rightBg);
         this._exchangeCellBg = ComponentFactory.Instance.creatBitmap("asset.godCardRaiseExchangeRightView.exchangeCellBg");
         addChild(this._exchangeCellBg);
         this._exchangeBtn = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseExchangeRightView.exchangeCellBtn");
         addChild(this._exchangeBtn);
         this._remainCountTxt = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseExchangeRightView.remainCountTxt");
         addChild(this._remainCountTxt);
         this._cards = new Sprite();
         PositionUtils.setPos(this._cards,"godCardRaiseExchangeRightView.cardsPos");
         addChild(this._cards);
         this._exchangeCell = new BagCell(0);
         PositionUtils.setPos(this._exchangeCell,"godCardRaiseExchangeRightView.cellPos");
         addChild(this._exchangeCell);
         this._exchangeCell.setBgVisible(false);
      }
      
      public function changeView(param1:GodCardListGroupInfo) : void
      {
         this.reset();
         this._info = param1;
         this.addCards();
         this.updateView();
      }
      
      private function addCards() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         _loc1_ = 0;
         while(_loc1_ < this._info.Cards.length)
         {
            _loc2_ = new GodCardRaiseExchangeRightCard(this._info.Cards[_loc1_]);
            _loc2_.x = _loc1_ * 166;
            this._cards.addChild(_loc2_);
            _loc1_++;
         }
      }
      
      public function updateView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         _loc1_ = 0;
         while(_loc1_ < this._cards.numChildren)
         {
            _loc2_ = this._cards.getChildAt(_loc1_) as GodCardRaiseExchangeRightCard;
            _loc2_.updateView();
            _loc1_++;
         }
         this._cards.x = (this._rightBg.width - this._info.Cards.length * 166) / 2;
         var _loc3_:int = int(GodCardRaiseManager.Instance.model.groups[this._info.GroupID]);
         this._remainCountTxt.text = LanguageMgr.GetTranslation("godCardRaiseExchangeRightView.remainCountTxtMsg",this._info.ExchangeTimes - _loc3_,this._info.ExchangeTimes);
         var _loc4_:InventoryItemInfo = new InventoryItemInfo();
         _loc4_.TemplateID = this._info.GiftID;
         ItemManager.fill(_loc4_);
         _loc4_.IsBinds = true;
         this._exchangeCell.info = _loc4_;
         this._exchangeCell.setCountNotVisible();
         var _loc5_:int = GodCardRaiseManager.Instance.calculateExchangeCount(this._info);
         if(this._info.ExchangeTimes - _loc3_ <= 0)
         {
            this._exchangeBtn.enable = false;
         }
         else if(_loc5_ != 0 && _loc5_ + GodCardRaiseManager.Instance.getMyCardCount(13) >= this._info.Cards.length)
         {
            this._exchangeBtn.enable = true;
            this._canUseUniversalCard = _loc5_ != this._info.Cards.length;
         }
         else
         {
            this._exchangeBtn.enable = false;
         }
      }
      
      private function reset() : void
      {
         ObjectUtils.disposeAllChildren(this._cards);
      }
      
      private function initEvent() : void
      {
         this._exchangeBtn.addEventListener("click",this.__exchangeBtnHandler);
      }
      
      private function __exchangeBtnHandler(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:* = null;
         SoundManager.instance.playButtonSound();
         if(this._canUseUniversalCard)
         {
            if(notAlertAgain)
            {
               GameInSocketOut.sendGodCardExchange(this._info.GroupID,true);
               return;
            }
            _loc2_ = LanguageMgr.GetTranslation("godCardRaise.universalCardTips");
            _loc3_ = [];
            _loc4_ = 0;
            while(_loc4_ < this._info.Cards.length)
            {
               _loc5_ = this._info.Cards[_loc4_];
               _loc6_ = int(_loc5_["cardId"]);
               _loc7_ = int(_loc5_["cardCount"]);
               _loc8_ = GodCardRaiseManager.Instance.getMyCardCount(_loc6_);
               if(_loc8_ < _loc7_)
               {
                  _loc2_ += LanguageMgr.GetTranslation("godCardRaise.universalCardReplace",GodCardRaiseManager.Instance.godCardListInfoList[_loc6_].Name);
               }
               _loc4_++;
            }
            _loc2_ = _loc2_.substr(0,_loc2_.length - 1) + "?";
            _loc9_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,1,null);
            _loc9_.setIsShowTheLog(true,LanguageMgr.GetTranslation("notAlertAgain"));
            _loc9_.selectedCheckButton.addEventListener("click",this.__onSelectCheckClick);
            _loc9_.addEventListener("response",this.__onAlertConfirm);
         }
         else
         {
            GameInSocketOut.sendGodCardExchange(this._info.GroupID);
         }
      }
      
      protected function __onSelectCheckClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:SelectedCheckButton = param1.currentTarget as SelectedCheckButton;
         notAlertAgain = _loc2_.selected;
      }
      
      protected function __onAlertConfirm(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener("response",this.__onAlertConfirm);
         if(param1.responseCode == 2 || param1.responseCode == 3)
         {
            GameInSocketOut.sendGodCardExchange(this._info.GroupID,true);
         }
         _loc2_.dispose();
      }
      
      private function removeEvent() : void
      {
         this._exchangeBtn.removeEventListener("click",this.__exchangeBtnHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this._cards);
         ObjectUtils.disposeAllChildren(this);
         this._cards = null;
         this._rightBg = null;
         this._exchangeCellBg = null;
         this._exchangeCell = null;
         this._exchangeBtn = null;
         this._info = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
