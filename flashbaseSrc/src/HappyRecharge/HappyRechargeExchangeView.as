package HappyRecharge
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class HappyRechargeExchangeView extends Sprite implements Disposeable
   {
       
      
      private var _cell:BagCell;
      
      private var _dirTxt:FilterFrameText;
      
      private var _numTxt:FilterFrameText;
      
      private var _ticket:Bitmap;
      
      private var _exchangeBtn:SimpleBitmapButton;
      
      private var _selfCount:int;
      
      private var _needCount:int;
      
      public function HappyRechargeExchangeView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._createCell();
         this._dirTxt = ComponentFactory.Instance.creatComponentByStylename("exchangeview.dirTxt");
         this._dirTxt.text = LanguageMgr.GetTranslation("happyRecharge.exchangeView.dirTxt");
         addChild(this._dirTxt);
         this._numTxt = ComponentFactory.Instance.creatComponentByStylename("exchangeview.numTxt");
         this._numTxt.text = LanguageMgr.GetTranslation("happyRecharge.exchangeView.numTxt",0,0);
         addChild(this._numTxt);
         this._ticket = ComponentFactory.Instance.creatBitmap("happyRecharge.exchangeView.ticket");
         PositionUtils.setPos(this._ticket,"exchangeView.ticket.pos");
         addChild(this._ticket);
         this._exchangeBtn = ComponentFactory.Instance.creatComponentByStylename("exchangeview.exchangeBtn");
         addChild(this._exchangeBtn);
         this._exchangeBtn.enable = false;
      }
      
      private function initEvent() : void
      {
         this._exchangeBtn.addEventListener("click",this.__exchangeHandler);
         HappyRechargeManager.instance.addEventListener("HAPPYRECHARGE_UPDATE_TICKET",this.__updateTicketHandler);
      }
      
      private function removeEvent() : void
      {
         this._exchangeBtn.removeEventListener("click",this.__exchangeHandler);
         HappyRechargeManager.instance.removeEventListener("HAPPYRECHARGE_UPDATE_TICKET",this.__updateTicketHandler);
      }
      
      private function __exchangeHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(HappyRechargeManager.instance.mouseClickEnable)
         {
            if(this._selfCount >= this._needCount)
            {
               SocketManager.Instance.out.happyRechargeExchange(this._needCount,this._cell.info.TemplateID);
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("happyRecharge.mainFrame.ticketless"));
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("happyRecharge.mainFrame.inrolling"));
         }
      }
      
      private function __updateTicketHandler(param1:Event) : void
      {
         this.refreshView(HappyRechargeManager.instance.ticketCount);
      }
      
      private function _createCell() : void
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(61440,0);
         _loc1_.graphics.drawRect(0,0,33,33);
         _loc1_.graphics.endFill();
         this._cell = new BagCell(0,null,true,_loc1_,false);
         addChild(this._cell);
         this._cell.setContentSize(33,33);
         PositionUtils.setPos(this._cell,"exchangeView.cell.pos");
      }
      
      private function updateBtnEnable() : void
      {
         this._exchangeBtn.enable = this._selfCount >= this._needCount ? true : false;
      }
      
      public function setInfo(param1:ItemTemplateInfo, param2:int, param3:int, param4:int) : void
      {
         this._cell.info = param1;
         this._cell.PicPos = new Point(2,2);
         this._selfCount = param3;
         this._needCount = param4;
         this._numTxt.text = LanguageMgr.GetTranslation("happyRecharge.exchangeView.numTxt",this._selfCount,this._needCount);
         this.updateBtnEnable();
      }
      
      public function refreshView(param1:int) : void
      {
         this._selfCount = param1;
         this._numTxt.text = LanguageMgr.GetTranslation("happyRecharge.exchangeView.numTxt",this._selfCount,this._needCount);
         this.updateBtnEnable();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._cell);
         this._cell = null;
         ObjectUtils.disposeObject(this._dirTxt);
         this._dirTxt = null;
         ObjectUtils.disposeObject(this._numTxt);
         this._numTxt = null;
         ObjectUtils.disposeObject(this._ticket);
         this._ticket = null;
         ObjectUtils.disposeObject(this._exchangeBtn);
         this._exchangeBtn = null;
      }
   }
}
