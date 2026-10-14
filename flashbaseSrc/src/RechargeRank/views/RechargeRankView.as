package RechargeRank.views
{
   import RechargeRank.RechargeRankManager;
   import RechargeRank.data.RechargeRankVo;
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
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.views.IRightView;
   
   public class RechargeRankView extends Sprite implements IRightView
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
      
      public function RechargeRankView()
      {
         super();
      }
      
      public function init() : void
      {
         RechargeRankManager.instance.view = this;
         this.initView();
         this.updateView();
         this.initTimer();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("wonderfulactivity.rechargeRank.bg");
         addChild(this._bg);
         this._dateTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.rechargeRank.dateTxt");
         addChild(this._dateTxt);
         this._checkBg = ComponentFactory.Instance.creatComponentByStylename("wonderful.rechargeRank.checkBg");
         addChild(this._checkBg);
         this._checkBg.tipStyle = "ddt.view.tips.OneLineTip";
         this._checkBg.tipDirctions = "0";
         this._checkTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.rechargeRank.checkTxt");
         addChild(this._checkTxt);
         this._checkTxt.text = LanguageMgr.GetTranslation("rechargeRank.checkConsume");
         this._outOfRankLabel = ComponentFactory.Instance.creatComponentByStylename("wonderful.rechargeRank.labelTxt");
         addChild(this._outOfRankLabel);
         this._outOfRankLabel.text = LanguageMgr.GetTranslation("rechargeRank.outOfRankLabel",100,6000);
         this._outOfRankLabel.visible = false;
         this._myRankLabel = ComponentFactory.Instance.creatComponentByStylename("wonderful.rechargeRank.myRankLabel");
         addChild(this._myRankLabel);
         this._myRankLabel.text = LanguageMgr.GetTranslation("rechargeRank.myRank");
         this._rankLabelTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.rechargeRank.labelTxt2");
         addChild(this._rankLabelTxt);
         this._rankLabelTxt.text = LanguageMgr.GetTranslation("rechargeRank.rankLabel",5000);
         this._rankTxtBg = ComponentFactory.Instance.creatComponentByStylename("wonderful.rechargeRank.rankBg");
         addChild(this._rankTxtBg);
         this._rankTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.rechargeRank.rankTxt");
         addChild(this._rankTxt);
         this._rankTxt.text = "20";
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("wonderful.rechargeRank.vBox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("wonderful.rechargeRank.scrollpanel");
         this._scrollPanel.setView(this._vbox);
         addChild(this._scrollPanel);
      }
      
      public function updateView() : void
      {
         var _loc6_:Array = null;
         var _loc1_:* = 0;
         var _loc2_:RechargeRankVo = null;
         var _loc3_:GmActivityInfo = RechargeRankManager.instance.xmlData;
         var _loc4_:String = this.dateTrim(_loc3_.beginTime);
         var _loc5_:String = this.dateTrim(_loc3_.endTime);
         this._dateTxt.text = _loc4_ + "-" + _loc5_;
         this._checkBg.tipData = LanguageMgr.GetTranslation("rechargeRank.helpTxt",_loc3_.remain2);
         _loc6_ = RechargeRankManager.instance.rankList;
         _loc1_ = RechargeRankManager.instance.myConsume;
         this._myRank = -1;
         var _loc7_:int = 0;
         while(_loc7_ <= _loc6_.length - 1)
         {
            _loc2_ = _loc6_[_loc7_] as RechargeRankVo;
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
               _loc8_ = (_loc6_[this._myRank - 1] as RechargeRankVo).consume - _loc1_ + 1;
               this._rankLabelTxt.text = LanguageMgr.GetTranslation("rechargeRank.rankLabel",_loc8_);
            }
            if(RechargeRankManager.instance.status == 2)
            {
               this._rankLabelTxt.visible = true;
               this._rankLabelTxt.textColor = 16711680;
               this._rankLabelTxt.text = LanguageMgr.GetTranslation("rechargeRank.over");
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
               _loc8_ = (_loc6_[_loc6_.length - 1] as RechargeRankVo).consume - _loc1_ + 1;
            }
            else
            {
               _loc8_ = 1;
            }
            this._outOfRankLabel.text = LanguageMgr.GetTranslation("rechargeRank.outOfRank");
            this._rankLabelTxt.text = LanguageMgr.GetTranslation("rechargeRank.outOfRankLabel",_loc1_,_loc8_);
            if(RechargeRankManager.instance.status == 2)
            {
               this._rankLabelTxt.visible = true;
               this._rankLabelTxt.textColor = 16711680;
               this._rankLabelTxt.text = LanguageMgr.GetTranslation("rechargeRank.over");
            }
         }
         this.updateItems();
      }
      
      private function updateItems() : void
      {
         var _loc1_:RechargeRankItem = null;
         var _loc2_:Array = RechargeRankManager.instance.rankList;
         var _loc3_:Array = RechargeRankManager.instance.xmlData.giftbagArray;
         this._vbox.removeAllChild();
         var _loc4_:int = 0;
         while(_loc4_ <= _loc2_.length - 1)
         {
            _loc1_ = new RechargeRankItem(_loc4_);
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
         var _loc1_:Date = DateUtils.getDateByStr(RechargeRankManager.instance.xmlData.endTime);
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
                  SocketManager.Instance.out.updateRechargeRank();
               }
            }
            else if(this.refreshCount >= 30)
            {
               this.refreshCount = 0;
               SocketManager.Instance.out.updateRechargeRank();
            }
         }
         else
         {
            WonderfulActivityManager.Instance.delTimerFun("consumeRank");
         }
      }
      
      public function dispose() : void
      {
         RechargeRankManager.instance.view = null;
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
