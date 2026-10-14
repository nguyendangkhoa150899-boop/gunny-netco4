package explorerManual.view.chapter
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.BagEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import explorerManual.ExplorerManualController;
   import explorerManual.ExplorerManualManager;
   import explorerManual.data.ExplorerManualInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import shop.view.BuySingleGoodsView;
   
   public class ExplorerChapterLeftView extends Sprite implements Disposeable
   {
       
      
      private var _manualIcon:Bitmap;
      
      private var _curPro:explorerManual.view.chapter.ManualPropertyView;
      
      private var _nextPro:explorerManual.view.chapter.ManualPropertyView;
      
      private var _progressBar:explorerManual.view.chapter.ManualPropertyPrgress;
      
      private var _startUpgradeBtn:BaseButton;
      
      private var _autoUpgradeBtn:BaseButton;
      
      private var _materialSelectBtn:SelectedCheckButton;
      
      private var _model:ExplorerManualInfo;
      
      private var _ctrl:ExplorerManualController;
      
      private var _conditionTxt:FilterFrameText;
      
      private var _materialIcon:Bitmap;
      
      private var _materialCount:FilterFrameText;
      
      private var _maxIcon:Bitmap;
      
      private var _clickNum:Number = 0;
      
      private var iconSprite:Sprite;
      
      public function ExplorerChapterLeftView(param1:ExplorerManualInfo, param2:ExplorerManualController)
      {
         super();
         this._model = param1;
         this._ctrl = param2;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._manualIcon = ComponentFactory.Instance.creat("asset.explorerManual.manualIcon1");
         addChild(this._manualIcon);
         PositionUtils.setPos(this._manualIcon,"explorerManual.leftChapter.manualIconPos");
         this._curPro = new explorerManual.view.chapter.ManualPropertyView();
         addChild(this._curPro);
         PositionUtils.setPos(this._curPro,"explorerManual.curProViewPos");
         this._nextPro = new explorerManual.view.chapter.ManualPropertyView();
         addChild(this._nextPro);
         PositionUtils.setPos(this._nextPro,"explorerManual.nextProViewPos");
         this._maxIcon = ComponentFactory.Instance.creat("asset.explorerManual.maxLev");
         this._maxIcon.visible = false;
         addChild(this._maxIcon);
         this._progressBar = new explorerManual.view.chapter.ManualPropertyPrgress(this._model);
         addChild(this._progressBar);
         PositionUtils.setPos(this._progressBar,"explorerManual.progressBarPos");
         this._materialCount = ComponentFactory.Instance.creatComponentByStylename("explorerManual.upgradeMaterial.numberTxt");
         addChild(this._materialCount);
         this._materialSelectBtn = ComponentFactory.Instance.creatComponentByStylename("explorerManual.materialsNotEnough.selectBtn");
         addChild(this._materialSelectBtn);
         this._materialSelectBtn.text = LanguageMgr.GetTranslation("explorerManual.chapterView.materialNotEnough");
         this._startUpgradeBtn = ComponentFactory.Instance.creatComponentByStylename("explorerManual.manualLeft.startUpdateBtn");
         addChild(this._startUpgradeBtn);
         this._startUpgradeBtn.enable = false;
         this._autoUpgradeBtn = ComponentFactory.Instance.creatComponentByStylename("explorerManual.manualLeft.autoUpdateBtn");
         addChild(this._autoUpgradeBtn);
         this._autoUpgradeBtn.enable = false;
         this._conditionTxt = ComponentFactory.Instance.creatComponentByStylename("explorerManual.upgradeCondition.txt");
         addChild(this._conditionTxt);
      }
      
      private function initEvent() : void
      {
         if(Boolean(this._model))
         {
            this._model.addEventListener("manualModelUpdate",this.__modelUpdateHandler);
            this._model.addEventListener("manualProUpdate",this.__manualProUpdateHandler);
            this._model.addEventListener("manualProgressUpdate",this.__manualProgressUpdateHandler);
            this._model.addEventListener("manualLevelChangle",this.__manualLevelChangle);
         }
         if(Boolean(this._materialSelectBtn))
         {
            this._materialSelectBtn.addEventListener("click",this.__materialSelectClickHandler);
         }
         if(Boolean(this._ctrl))
         {
            this._ctrl.addEventListener("upgradeComplete",this.__manualUpgradeComplete);
         }
         if(Boolean(this._startUpgradeBtn))
         {
            this._startUpgradeBtn.addEventListener("click",this.__startUpgradeHandler);
         }
         if(Boolean(this._autoUpgradeBtn))
         {
            this._autoUpgradeBtn.addEventListener("click",this.__autoUpgradeHandler);
         }
         PlayerManager.Instance.Self.PropBag.addEventListener("update",this.__updateBag);
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._model))
         {
            this._model.removeEventListener("manualModelUpdate",this.__modelUpdateHandler);
            this._model.removeEventListener("manualProUpdate",this.__manualProUpdateHandler);
            this._model.removeEventListener("manualProgressUpdate",this.__manualProgressUpdateHandler);
            this._model.removeEventListener("manualLevelChangle",this.__manualLevelChangle);
         }
         if(Boolean(this._materialSelectBtn))
         {
            this._materialSelectBtn.removeEventListener("click",this.__materialSelectClickHandler);
         }
         if(Boolean(this._ctrl))
         {
            this._ctrl.removeEventListener("upgradeComplete",this.__manualUpgradeComplete);
         }
         if(Boolean(this._startUpgradeBtn))
         {
            this._startUpgradeBtn.removeEventListener("click",this.__startUpgradeHandler);
         }
         if(Boolean(this._autoUpgradeBtn))
         {
            this._autoUpgradeBtn.removeEventListener("click",this.__autoUpgradeHandler);
         }
         PlayerManager.Instance.Self.PropBag.removeEventListener("update",this.__updateBag);
      }
      
      private function __materialSelectClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(this._materialSelectBtn.selected)
         {
            _loc2_ = ShopManager.Instance.getShopItemByGoodsID(this._model.upgradeCondition.materialCondition.Parameter3);
            _loc3_ = LanguageMgr.GetTranslation("explorerManual.materialBuy.prompt",_loc2_.getItemPrice(0).bothMoneyValue);
            AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc3_,LanguageMgr.GetTranslation("ok"),"",true,true,false,2);
         }
      }
      
      private function __startUpgradeHandler(param1:MouseEvent) : void
      {
         if(this.checkCanClick())
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(Boolean(this._ctrl))
            {
               if(this._materialSelectBtn.selected || this.isCanUpgrade())
               {
                  this._ctrl.startUpgrade(this._materialSelectBtn.selected,false);
               }
            }
         }
      }
      
      private function __manualUpgradeComplete(param1:Event) : void
      {
      }
      
      private function __autoUpgradeHandler(param1:MouseEvent) : void
      {
         if(this.checkCanClick())
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(Boolean(this._ctrl))
            {
               if(this._materialSelectBtn.selected || this.isCanUpgrade())
               {
                  this._ctrl.autoUpgrade(this._materialSelectBtn.selected,false,true);
               }
            }
         }
      }
      
      private function isCanUpgrade() : Boolean
      {
         var _loc1_:int = this._model.upgradeCondition.materialCondition.Parameter2;
         var _loc2_:int = PlayerManager.Instance.Self.getBag(1).getItemCountByTemplateId(this._model.upgradeCondition.materialCondition.Parameter1);
         var _loc3_:* = _loc2_ >= _loc1_;
         if(!_loc3_)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("explorerManual.chapterView.upgradeMaterialNotEnough"));
         }
         return _loc3_;
      }
      
      private function checkCanClick() : Boolean
      {
         var _loc1_:Number = new Date().time;
         if(_loc1_ - this._clickNum < 1000)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"),0,true);
            return false;
         }
         this._clickNum = _loc1_;
         return true;
      }
      
      private function __manualProgressUpdateHandler(param1:Event) : void
      {
         this.updateProgress();
      }
      
      private function __manualProUpdateHandler(param1:Event) : void
      {
         this.updatePro();
      }
      
      private function __modelUpdateHandler(param1:Event) : void
      {
         this.updatePro();
         this.updateProgress();
         this.updateUpgradeMaterial();
         this.updateManualIcon();
         this.updateManualConditionDes();
      }
      
      private function __manualLevelChangle(param1:Event) : void
      {
         this.updateUpgradeMaterial();
         this.updateManualIcon();
         this.updateManualConditionDes();
      }
      
      private function updateManualConditionDes() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this._conditionTxt.text = LanguageMgr.GetTranslation("explorerManual.manualUpgradeCondition.txt");
         var _loc3_:* = true;
         if(this._model.upgradeCondition.upgradeCondition != null)
         {
            _loc1_ = this._model.upgradeCondition.targetCount;
            _loc2_ = this._model.conditionCount;
            this._conditionTxt.text += this._model.upgradeCondition.upgradeCondition.Describe + " " + (_loc2_ + "/" + _loc1_);
         }
         else
         {
            this._conditionTxt.text += LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.new");
            _loc2_ = 0;
            _loc1_ = 1;
            _loc3_ = ExplorerManualManager.instance.getManualProInfoByLev(this._model.manualLev + 1) == null;
            if(Boolean(this.iconSprite) && _loc3_)
            {
               this.iconSprite.removeEventListener("click",this.__materialClickHandler);
               this.iconSprite.buttonMode = false;
               this.iconSprite.mouseEnabled = false;
            }
         }
         this.updateBtn(_loc2_ >= _loc1_ || !_loc3_);
      }
      
      private function updateBtn(param1:Boolean) : void
      {
         if(Boolean(this._startUpgradeBtn) && Boolean(this._autoUpgradeBtn))
         {
            this._startUpgradeBtn.enable = this._autoUpgradeBtn.enable = param1;
            this._materialSelectBtn.enable = param1;
         }
      }
      
      private function updateManualIcon() : void
      {
         if(Boolean(this._manualIcon))
         {
            ObjectUtils.disposeObject(this._manualIcon);
            this._manualIcon = null;
         }
         var _loc1_:int = Math.min(int((this._model.manualLev - 1) / 5) + 1,4);
         this._manualIcon = ComponentFactory.Instance.creat("asset.explorerManual.manualIcon" + _loc1_);
         addChild(this._manualIcon);
         PositionUtils.setPos(this._manualIcon,"explorerManual.leftChapter.manualIconPos");
      }
      
      private function updateUpgradeMaterial() : void
      {
         if(Boolean(this.iconSprite))
         {
            this.iconSprite.removeEventListener("click",this.__materialClickHandler);
            this.iconSprite.removeChildren();
            if(Boolean(this.iconSprite.parent))
            {
               this.iconSprite.parent.removeChild(this.iconSprite);
            }
         }
         this._materialIcon = null;
         this.iconSprite = new Sprite();
         this.iconSprite.buttonMode = true;
         this.iconSprite.mouseEnabled = true;
         addChild(this.iconSprite);
         this.iconSprite.x = 112;
         this.iconSprite.y = 398;
         var _loc1_:int = this._model.upgradeCondition.materialCondition == null ? 11183 : this._model.upgradeCondition.materialCondition.Parameter1;
         this._materialIcon = ComponentFactory.Instance.creat("asset.explorerManual.upgradeMaterial" + _loc1_);
         this.iconSprite.addChild(this._materialIcon);
         this.iconSprite.addEventListener("click",this.__materialClickHandler);
         this.updateMaterialCount();
      }
      
      private function updateMaterialCount() : void
      {
         if(this._model.upgradeCondition.materialCondition == null)
         {
            this._materialCount.htmlText = "0/0";
         }
         else
         {
            this._materialCount.htmlText = this.getMaterCountTxt;
         }
      }
      
      private function get getMaterCountTxt() : String
      {
         var _loc1_:* = null;
         var _loc2_:int = this._model.upgradeCondition.materialCondition.Parameter2;
         var _loc3_:int = PlayerManager.Instance.Self.getBag(1).getItemCountByTemplateId(this._model.upgradeCondition.materialCondition.Parameter1);
         if(_loc2_ > _loc3_)
         {
            _loc1_ = "<FONT FACE=\'Arial\' SIZE=\'14\' COLOR=\'#FF0000\' ><B>" + _loc3_ + "</B></FONT>" + "/" + _loc2_;
         }
         else
         {
            _loc1_ = _loc3_ + "/" + _loc2_;
         }
         return _loc1_;
      }
      
      private function __materialClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:BuySingleGoodsView = new BuySingleGoodsView();
         LayerManager.Instance.addToLayer(_loc2_,3,true,1);
         _loc2_.isDisCount = false;
         _loc2_.goodsID = int(this._model.upgradeCondition.materialCondition.Parameter3);
         _loc2_.numberSelecter.valueLimit = "";
      }
      
      private function __updateBag(param1:BagEvent) : void
      {
         this.updateMaterialCount();
      }
      
      private function updatePro() : void
      {
         if(Boolean(this._curPro))
         {
            this._curPro.info = this._model.curPro;
         }
         if(Boolean(this._nextPro))
         {
            this._nextPro.info = this._model.nextPro;
         }
         if(this._model.nextPro == null)
         {
            this.updateBtn(false);
            this._maxIcon.visible = true;
            this._nextPro.visible = false;
         }
      }
      
      private function updateProgress() : void
      {
         if(Boolean(this._progressBar))
         {
            this._progressBar.setProgress(this._model.progress,this._model.proLevMaxProgress);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._curPro);
         this._curPro = null;
         ObjectUtils.disposeObject(this._manualIcon);
         this._manualIcon = null;
         if(Boolean(this.iconSprite))
         {
            this.iconSprite.removeEventListener("click",this.__materialClickHandler);
            this.iconSprite.removeChildren();
            if(Boolean(this.iconSprite.parent))
            {
               this.iconSprite.parent.removeChild(this.iconSprite);
            }
         }
         ObjectUtils.disposeObject(this._nextPro);
         this._nextPro = null;
         ObjectUtils.disposeObject(this._progressBar);
         this._progressBar = null;
         ObjectUtils.disposeObject(this._materialSelectBtn);
         this._materialSelectBtn = null;
         ObjectUtils.disposeObject(this._startUpgradeBtn);
         this._startUpgradeBtn = null;
         ObjectUtils.disposeObject(this._autoUpgradeBtn);
         this._autoUpgradeBtn = null;
      }
   }
}
