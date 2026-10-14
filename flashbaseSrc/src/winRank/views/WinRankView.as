package winRank.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import road7th.utils.DateUtils;
   import winRank.WinRankManager;
   import winRank.data.WinRankVo;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.views.IRightView;
   
   public class WinRankView extends Sprite implements IRightView
   {
       
      
      private var _bg:Bitmap;
      
      private var _dateTxt:FilterFrameText;
      
      private var _checkTxt:FilterFrameText;
      
      private var _checkBg:ScaleBitmapImage;
      
      private var _outOfRankLabel:FilterFrameText;
      
      private var _myRankLabel:FilterFrameText;
      
      private var _rankLabelTxt:FilterFrameText;
      
      private var _rankTxtBg:Scale9CornerImage;
      
      private var _rankTxt:FilterFrameText;
      
      private var _vbox:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _myRank:int;
      
      private var refreshCount:int = 0;
      
      public function WinRankView()
      {
         super();
      }
      
      public function init() : void
      {
         WinRankManager.instance.view = this;
         this.initView();
         this.updateView();
         this.initTimer();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("wonderfulactivity.winRank.bg");
         addChild(this._bg);
         this._dateTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.dateTxt");
         addChild(this._dateTxt);
         this._checkBg = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.checkBg");
         addChild(this._checkBg);
         this._checkBg.tipStyle = "ddt.view.tips.OneLineTip";
         this._checkBg.tipDirctions = "0";
         this._checkTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.checkTxt");
         addChild(this._checkTxt);
         this._checkTxt.text = LanguageMgr.GetTranslation("consumeRank.checkConsume");
         this._outOfRankLabel = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.labelTxt");
         addChild(this._outOfRankLabel);
         this._outOfRankLabel.text = LanguageMgr.GetTranslation("consumeRank.outOfRankLabel",100,6000);
         this._outOfRankLabel.visible = false;
         this._myRankLabel = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.myRankLabel");
         addChild(this._myRankLabel);
         this._myRankLabel.text = LanguageMgr.GetTranslation("consumeRank.myRank");
         this._rankLabelTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.labelTxt2");
         addChild(this._rankLabelTxt);
         this._rankLabelTxt.text = LanguageMgr.GetTranslation("winRank.rankLabel",5000);
         this._rankTxtBg = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.rankBg");
         addChild(this._rankTxtBg);
         this._rankTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.rankTxt");
         addChild(this._rankTxt);
         this._rankTxt.text = "20";
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.vBox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.scrollpanel");
         this._scrollPanel.setView(this._vbox);
         addChild(this._scrollPanel);
      }
      
      public function updateView() : void
      {
         var _loc6_:Array = null;
         var _loc1_:* = 0;
         var _loc2_:WinRankVo = null;
         var _loc3_:GmActivityInfo = WinRankManager.instance.xmlData;
         var _loc4_:String = this.dateTrim(_loc3_.beginTime);
         var _loc5_:String = this.dateTrim(_loc3_.endTime);
         this._dateTxt.text = _loc4_ + "-" + _loc5_;
         this._checkBg.tipData = LanguageMgr.GetTranslation("winRank.helpTxt",_loc3_.remain2);
         _loc6_ = WinRankManager.instance.rankList;
         _loc1_ = WinRankManager.instance.myConsume;
         this._myRank = -1;
         var _loc7_:int = 0;
         while(_loc7_ <= _loc6_.length - 1)
         {
            _loc2_ = _loc6_[_loc7_] as WinRankVo;
            if(_loc2_.userId == PlayerManager.Instance.Self.ID)
            {
               this._myRank = _loc7_;
               break;
            }
            _loc7_++;
         }
         var _loc8_:int = 0;
         if(this._myRank >= 0)
         {
            this._outOfRankLabel.visible = false;
            this._myRankLabel.visible = true;
            this._rankTxtBg.visible = true;
            this._rankTxt.visible = true;
            this._rankTxt.text = String(this._myRank + 1);
            if(this._myRank == 0)
            {
               this._rankLabelTxt.visible = false;
            }
            else
            {
               this._rankLabelTxt.visible = true;
               _loc8_ = (_loc6_[this._myRank - 1] as WinRankVo).consume - _loc1_ + 1;
               this._rankLabelTxt.text = LanguageMgr.GetTranslation("winRank.rankLabel",_loc8_);
            }
            if(WinRankManager.instance.status == 2)
            {
               this._rankLabelTxt.visible = true;
               this._rankLabelTxt.textColor = 16711680;
               this._rankLabelTxt.text = LanguageMgr.GetTranslation("consumeRank.over");
            }
         }
         else
         {
            this._myRankLabel.visible = false;
            this._rankTxtBg.visible = false;
            this._rankTxt.visible = false;
            this._rankLabelTxt.visible = true;
            this._outOfRankLabel.visible = true;
            if(_loc6_.length > 0)
            {
               _loc8_ = (_loc6_[_loc6_.length - 1] as WinRankVo).consume - _loc1_ + 1;
            }
            else
            {
               _loc8_ = 1;
            }
            this._outOfRankLabel.text = LanguageMgr.GetTranslation("win.outOfRank");
            this._rankLabelTxt.text = LanguageMgr.GetTranslation("winRank.outOfRankLabel",_loc1_,_loc8_);
            if(WinRankManager.instance.status == 2)
            {
               this._rankLabelTxt.visible = true;
               this._rankLabelTxt.textColor = 16711680;
               this._rankLabelTxt.text = LanguageMgr.GetTranslation("consumeRank.over");
            }
         }
         this.updateItems();
      }
      
      private function updateItems() : void
      {
         var _loc1_:WinRankItem = null;
         var _loc2_:Array = WinRankManager.instance.rankList;
         var _loc3_:Array = WinRankManager.instance.xmlData.giftbagArray;
         this._vbox.removeAllChild();
         var _loc4_:int = 0;
         while(_loc4_ <= _loc2_.length - 1)
         {
            _loc1_ = new WinRankItem(_loc4_);
            _loc1_.setData(_loc2_[_loc4_],_loc3_[_loc4_]);
            this._vbox.addChild(_loc1_);
            _loc4_++;
         }
         this._scrollPanel.invalidateViewport();
      }
      
      private function dateTrim(param1:String) : String
      {
         var _loc2_:String = "";
         var _loc3_:Array = param1.split(" ");
         return _loc3_[0] + " " + _loc3_[1].slice(0,5);
      }
      
      private function initTimer() : void
      {
         WonderfulActivityManager.Instance.addTimerFun("consumeRank",this.consumeRankTimerHandler);
      }
      
      private function consumeRankTimerHandler() : void
      {
         var _loc1_:Date = DateUtils.getDateByStr(WinRankManager.instance.xmlData.endTime);
         var _loc2_:Date = TimeManager.Instance.Now();
         var _loc3_:Number = Math.round((_loc1_.getTime() - _loc2_.getTime()) / 1000);
         if(_loc3_ > 0)
         {
            ++this.refreshCount;
            if(_loc3_ >= 60 * 60)
            {
               if(this.refreshCount >= 5 * 60)
               {
                  this.refreshCount = 0;
                  SocketManager.Instance.out.updateWinRank();
               }
            }
            else if(this.refreshCount >= 30)
            {
               this.refreshCount = 0;
               SocketManager.Instance.out.updateWinRank();
            }
         }
         else
         {
            WonderfulActivityManager.Instance.delTimerFun("consumeRank");
         }
      }
      
      public function dispose() : void
      {
         WinRankManager.instance.view = null;
         WonderfulActivityManager.Instance.delTimerFun("consumeRank");
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._dateTxt);
         this._dateTxt = null;
         ObjectUtils.disposeObject(this._checkTxt);
         this._checkTxt = null;
         ObjectUtils.disposeObject(this._checkBg);
         this._checkBg = null;
         ObjectUtils.disposeObject(this._outOfRankLabel);
         this._outOfRankLabel = null;
         ObjectUtils.disposeObject(this._rankLabelTxt);
         this._rankLabelTxt = null;
         ObjectUtils.disposeObject(this._rankTxt);
         this._rankTxt = null;
         ObjectUtils.disposeObject(this._rankTxtBg);
         this._rankTxtBg = null;
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function setState(param1:int, param2:int) : void
      {
      }
   }
}
