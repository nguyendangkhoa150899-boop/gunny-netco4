package godCardRaise.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import flash.display.Sprite;
   import godCardRaise.GodCardRaiseManager;
   import godCardRaise.info.GodCardPointRewardListInfo;
   import road7th.utils.DateUtils;
   
   public class GodCardRaiseScoreView extends Sprite implements Disposeable
   {
       
      
      private var _bg:MutipleImage;
      
      private var _timeTxt:FilterFrameText;
      
      private var _contentTxt:FilterFrameText;
      
      private var _msgTxt:FilterFrameText;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _awards:Sprite;
      
      public function GodCardRaiseScoreView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseScoreView.bg");
         addChild(this._bg);
         this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseScoreView.timeTxt");
         this._timeTxt.text = this.getCurrentTimeStr();
         addChild(this._timeTxt);
         this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseScoreView.contentTxt");
         this._contentTxt.text = LanguageMgr.GetTranslation("godCardRaiseScoreView.contentTxtMsg");
         addChild(this._contentTxt);
         this._msgTxt = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseScoreView.msgTxt");
         this._msgTxt.text = "" + GodCardRaiseManager.Instance.model.score;
         addChild(this._msgTxt);
         this._awards = new Sprite();
         this._scrollPanel = ComponentFactory.Instance.creat("godCardRaiseScoreView.scrollPanel");
         this._scrollPanel.setView(this._awards);
         addChild(this._scrollPanel);
         this.addAwards();
      }
      
      private function getCurrentTimeStr() : String
      {
         var _loc1_:Number = (GodCardRaiseManager.Instance.dataEnd.time - TimeManager.Instance.Now().time) / 1000 + 86400;
         var _loc2_:Array = DateUtils.dateTimeRemainArr(_loc1_);
         return LanguageMgr.GetTranslation("tank.timeRemain.msg1",_loc2_[0],_loc2_[1],_loc2_[2]);
      }
      
      private function initEvent() : void
      {
      }
      
      private function addAwards() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:Vector.<GodCardPointRewardListInfo> = GodCardRaiseManager.Instance.godCardPointRewardList;
         _loc1_ = 0;
         while(_loc1_ < _loc4_.length)
         {
            _loc2_ = _loc4_[_loc1_];
            _loc3_ = new GodCardRaiseScoreViewItem(_loc2_);
            _loc3_.y = _loc1_ * 65;
            this._awards.addChild(_loc3_);
            _loc1_++;
         }
         this._scrollPanel.invalidateViewport();
      }
      
      private function updateAwards() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         if(Boolean(this._awards))
         {
            _loc1_ = 0;
            while(_loc1_ < this._awards.numChildren)
            {
               _loc2_ = this._awards.getChildAt(_loc1_) as GodCardRaiseScoreViewItem;
               _loc2_.updateView();
               _loc1_++;
            }
         }
      }
      
      public function updateTime() : void
      {
         if(Boolean(this._timeTxt))
         {
            this._timeTxt.text = this.getCurrentTimeStr();
         }
      }
      
      public function updateView() : void
      {
         if(Boolean(this._msgTxt))
         {
            this._msgTxt.text = "" + GodCardRaiseManager.Instance.model.score;
         }
         this.updateAwards();
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this._awards);
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._timeTxt = null;
         this._contentTxt = null;
         this._msgTxt = null;
         this._scrollPanel = null;
         this._awards = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
