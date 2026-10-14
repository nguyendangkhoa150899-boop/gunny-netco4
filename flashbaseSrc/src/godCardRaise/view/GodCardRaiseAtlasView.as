package godCardRaise.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import godCardRaise.GodCardRaiseManager;
   import godCardRaise.info.GodCardListInfo;
   
   public class GodCardRaiseAtlasView extends Sprite implements Disposeable
   {
       
      
      private var _bg:MutipleImage;
      
      private var _selectGroup:SelectedButtonGroup;
      
      private var _whiteCardBtn:SelectedButton;
      
      private var _greenCardBtn:SelectedButton;
      
      private var _blueCardBtn:SelectedButton;
      
      private var _purpleCardBtn:SelectedButton;
      
      private var _goldCardBtn:SelectedButton;
      
      private var _whiteCards:Sprite;
      
      private var _greenCards:Sprite;
      
      private var _blueCards:Sprite;
      
      private var _purpleCards:Sprite;
      
      private var _goldCards:Sprite;
      
      private var _currentCards:Sprite;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _myClipTxt:FilterFrameText;
      
      public function GodCardRaiseAtlasView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseAtlasView.bg");
         addChild(this._bg);
         this._myClipTxt = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseAtlasView.myClipTxt");
         this._myClipTxt.text = GodCardRaiseManager.Instance.model.chipCount + "";
         addChild(this._myClipTxt);
         this._whiteCardBtn = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseAtlasView.whiteCardBtn");
         addChild(this._whiteCardBtn);
         this._greenCardBtn = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseAtlasView.greenCardBtn");
         addChild(this._greenCardBtn);
         this._blueCardBtn = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseAtlasView.blueCardBtn");
         addChild(this._blueCardBtn);
         this._purpleCardBtn = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseAtlasView.purpleCardBtn");
         addChild(this._purpleCardBtn);
         this._goldCardBtn = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseAtlasView.goldCardBtn");
         addChild(this._goldCardBtn);
         this._selectGroup = new SelectedButtonGroup();
         this._selectGroup.addSelectItem(this._whiteCardBtn);
         this._selectGroup.addSelectItem(this._greenCardBtn);
         this._selectGroup.addSelectItem(this._blueCardBtn);
         this._selectGroup.addSelectItem(this._purpleCardBtn);
         this._selectGroup.addSelectItem(this._goldCardBtn);
         this._selectGroup.selectIndex = 0;
         this._scrollPanel = ComponentFactory.Instance.creat("godCardRaiseAtlasView.scrollPanel");
         addChild(this._scrollPanel);
         this.getView();
      }
      
      private function __selectGroupHandler(param1:Event) : void
      {
         SoundManager.instance.playButtonSound();
         this.getView();
      }
      
      private function getView() : void
      {
         if(Boolean(this._whiteCards))
         {
            this._whiteCards.visible = false;
         }
         if(Boolean(this._greenCards))
         {
            this._greenCards.visible = false;
         }
         if(Boolean(this._blueCards))
         {
            this._blueCards.visible = false;
         }
         if(Boolean(this._purpleCards))
         {
            this._purpleCards.visible = false;
         }
         if(Boolean(this._goldCards))
         {
            this._goldCards.visible = false;
         }
         if(this._selectGroup.selectIndex == 1)
         {
            if(Boolean(this._greenCards))
            {
               this._greenCards.visible = true;
            }
            else
            {
               this._greenCards = new Sprite();
               addChild(this._greenCards);
               this.addGodCardRaiseAtlasCards(this._greenCards,1);
            }
            this._scrollPanel.setView(this._greenCards);
            this._currentCards = this._greenCards;
         }
         else if(this._selectGroup.selectIndex == 2)
         {
            if(Boolean(this._blueCards))
            {
               this._blueCards.visible = true;
            }
            else
            {
               this._blueCards = new Sprite();
               addChild(this._blueCards);
               this.addGodCardRaiseAtlasCards(this._blueCards,2);
            }
            this._scrollPanel.setView(this._blueCards);
            this._currentCards = this._blueCards;
         }
         else if(this._selectGroup.selectIndex == 3)
         {
            if(Boolean(this._purpleCards))
            {
               this._purpleCards.visible = true;
            }
            else
            {
               this._purpleCards = new Sprite();
               addChild(this._purpleCards);
               this.addGodCardRaiseAtlasCards(this._purpleCards,3);
            }
            this._scrollPanel.setView(this._purpleCards);
            this._currentCards = this._purpleCards;
         }
         else if(this._selectGroup.selectIndex == 4)
         {
            if(Boolean(this._goldCards))
            {
               this._goldCards.visible = true;
            }
            else
            {
               this._goldCards = new Sprite();
               addChild(this._goldCards);
               this.addGodCardRaiseAtlasCards(this._goldCards,4);
            }
            this._scrollPanel.setView(this._goldCards);
            this._currentCards = this._goldCards;
         }
         else
         {
            if(Boolean(this._whiteCards))
            {
               this._whiteCards.visible = true;
            }
            else
            {
               this._whiteCards = new Sprite();
               addChild(this._whiteCards);
               this.addGodCardRaiseAtlasCards(this._whiteCards,0);
            }
            this._scrollPanel.setView(this._whiteCards);
            this._currentCards = this._whiteCards;
         }
         this._scrollPanel.invalidateViewport();
         if(Boolean(this._currentCards))
         {
            this.updateCards(this._currentCards);
         }
      }
      
      private function addGodCardRaiseAtlasCards(param1:Sprite, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:Array = GodCardRaiseManager.Instance.getGodCardListInfoListByLevel(param2);
         if(Boolean(_loc6_))
         {
            _loc3_ = 0;
            while(_loc3_ < _loc6_.length)
            {
               _loc4_ = _loc6_[_loc3_] as GodCardListInfo;
               _loc5_ = new GodCardRaiseAtlasCard();
               _loc5_.info = _loc4_;
               _loc5_.x = _loc3_ % 4 * 166;
               _loc5_.y = int(_loc3_ / 4) * 260;
               param1.addChild(_loc5_);
               _loc3_++;
            }
         }
      }
      
      public function updateView() : void
      {
         if(Boolean(this._myClipTxt))
         {
            this._myClipTxt.text = GodCardRaiseManager.Instance.model.chipCount + "";
         }
         if(Boolean(this._currentCards))
         {
            this.updateCards(this._currentCards);
         }
      }
      
      private function updateCards(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         _loc2_ = 0;
         while(_loc2_ < param1.numChildren)
         {
            _loc3_ = param1.getChildAt(_loc2_) as GodCardRaiseAtlasCard;
            _loc3_.updateView();
            _loc2_++;
         }
      }
      
      private function initEvent() : void
      {
         this._selectGroup.addEventListener("change",this.__selectGroupHandler);
      }
      
      private function removeEvent() : void
      {
         this._selectGroup.removeEventListener("change",this.__selectGroupHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this._whiteCards);
         ObjectUtils.disposeAllChildren(this._greenCards);
         ObjectUtils.disposeAllChildren(this._blueCards);
         ObjectUtils.disposeAllChildren(this._purpleCards);
         ObjectUtils.disposeAllChildren(this._goldCards);
         ObjectUtils.disposeAllChildren(this);
         this._whiteCards = null;
         this._greenCards = null;
         this._blueCards = null;
         this._purpleCards = null;
         this._goldCards = null;
         this._whiteCardBtn = null;
         this._greenCardBtn = null;
         this._blueCardBtn = null;
         this._purpleCardBtn = null;
         this._goldCardBtn = null;
         this._selectGroup = null;
         this._scrollPanel = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
