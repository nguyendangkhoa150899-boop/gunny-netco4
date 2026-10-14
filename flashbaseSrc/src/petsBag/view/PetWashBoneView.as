package petsBag.view
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.events.BagEvent;
   import ddt.events.CEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   import petsBag.view.item.PetBigItem;
   import petsBag.view.item.PetWashBoneGrade;
   import petsBag.view.item.PetWashBoneProItem;
   import petsBag.view.item.StarBar;
   import road7th.data.DictionaryData;
   
   public class PetWashBoneView extends Sprite implements Disposeable
   {
      
      private static const LOCK_COUNT:int = 4;
       
      
      protected var _bg:Bitmap;
      
      private var _starBar:StarBar;
      
      private var _petBigItem:PetBigItem;
      
      private var _petName:FilterFrameText;
      
      private var _lv:Bitmap;
      
      private var _lvTxt:FilterFrameText;
      
      private var _petGrade:PetWashBoneGrade;
      
      private var _goodCell:BagCell;
      
      private var _proGrowTxt:FilterFrameText;
      
      private var _proMaxTxt:FilterFrameText;
      
      private var _descTxt:FilterFrameText;
      
      private var _curPetInfo:PetInfo;
      
      private var _proItems:Array;
      
      private var _proVBox:VBox;
      
      private var _washBoneBtn:BaseButton;
      
      private var prosArr:Array;
      
      private var _confirmFrame:BaseAlerFrame;
      
      private var _haveWashBoneCount:int;
      
      private var _gradeArr:Array;
      
      public function PetWashBoneView()
      {
         this._gradeArr = ["B","A","S","SS","SSS"];
         this._proItems = [];
         this.prosArr = ["BloodGrow","AttackGrow","DefenceGrow","AgilityGrow","LuckGrow"];
         super();
         this.initView();
         this.initEvent();
         this.updateData();
      }
      
      protected function initView() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         this._curPetInfo = PetBagController.instance().petModel.currentPetInfo;
         this._bg = ComponentFactory.Instance.creat("asset.petsBage.washBone.bg");
         addChild(this._bg);
         this._petName = ComponentFactory.Instance.creatComponentByStylename("petsBag.text.PetName");
         addChild(this._petName);
         PositionUtils.setPos(this._petName,"petsBagView.washBone.petNamePos");
         this._lv = ComponentFactory.Instance.creatBitmap("assets.petsBag.Lv");
         addChild(this._lv);
         PositionUtils.setPos(this._lv,"petsBagView.washBone.petLevPos");
         this._lvTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.text.Lv");
         addChild(this._lvTxt);
         PositionUtils.setPos(this._lvTxt,"petsBagView.washBone.petLevTxtPos");
         this._starBar = new StarBar();
         addChild(this._starBar);
         PositionUtils.setPos(this._starBar,"petsBagView.washBone.petStarPos");
         this._petBigItem = ComponentFactory.Instance.creat("petsBag.petBigItem");
         this._petBigItem.initTips();
         PositionUtils.setPos(this._petBigItem,"petsBagView.washBone.petItesPos");
         addChild(this._petBigItem);
         this._petGrade = new PetWashBoneGrade();
         addChild(this._petGrade);
         PositionUtils.setPos(this._petGrade,"petsBag.washBone.petGradePos");
         this._proGrowTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.washBone.proGrowTxt");
         addChild(this._proGrowTxt);
         this._proGrowTxt.text = LanguageMgr.GetTranslation("ddt.pets.washBone.proGrowTxt");
         this._proMaxTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.washBone.proGrowTxt");
         addChild(this._proMaxTxt);
         PositionUtils.setPos(this._proMaxTxt,"petsBag.washBone.petProMaxValueTxtPos");
         this._proMaxTxt.text = LanguageMgr.GetTranslation("ddt.pets.washBone.proMaxTxt");
         this._proVBox = ComponentFactory.Instance.creatComponentByStylename("petsBag.washBone.proItemHBox");
         addChild(this._proVBox);
         this._washBoneBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.washBone.washBoneBtn");
         addChild(this._washBoneBtn);
         var _loc3_:Array = PetBagController.instance().getWashProLockByPetID(this._curPetInfo);
         _loc2_ = 0;
         while(_loc2_ < 5)
         {
            _loc1_ = new PetWashBoneProItem(this.prosArr[_loc2_],this._curPetInfo);
            _loc1_.isLock = _loc3_[_loc2_];
            _loc1_.addEventListener("clickLock",this.__updateCostCount);
            this._proVBox.addChild(_loc1_);
            this._proItems.push(_loc1_);
            _loc2_++;
         }
         this._goodCell = CellFactory.instance.createBagCell(0,ItemManager.fillByID(12656),false) as BagCell;
         this._goodCell.info.BindType = 4;
         this._goodCell.setContentSize(59,59);
         this._goodCell.setBgVisible(false);
         this._goodCell.PicPos = new Point(0,0);
         addChild(this._goodCell);
         PositionUtils.setPos(this._goodCell,"petsBagView.washBone.goodCellPos");
         this._descTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.washBone.descTxt");
         addChild(this._descTxt);
         this._descTxt.text = LanguageMgr.GetTranslation("ddt.pets.washBone.descTxt");
         this.updateCellCount();
      }
      
      private function __updateCostCount(param1:CEvent) : void
      {
         var _loc2_:PetWashBoneProItem = param1.data as PetWashBoneProItem;
         if(this.getProLockCount > 4)
         {
            _loc2_.isLock = false;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.pets.washBone.proLockMaxCountMsg"));
            return;
         }
         this.updateCellCount();
      }
      
      private function updateCellCount() : void
      {
         this._goodCell.setCount(this.getWashBoneCount + "/" + this.getProLockCost);
         this._goodCell.refreshTbxPos();
      }
      
      private function __washBoneHandler(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._curPetInfo != null && this.goodCountEnough)
         {
            if(PetBagController.instance().activateAlertFrameShow)
            {
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.pets.washBone.alertConfigMsg"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,2,null,"SimpleAlert",60,false);
               _loc2_.addEventListener("response",this.__onAlertFrame);
               _loc2_.setIsShowTheLog(true,LanguageMgr.GetTranslation("notAlertAgain"));
            }
            else
            {
               this.sendWashBone();
            }
         }
      }
      
      protected function __onSelectCheckClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:SelectedCheckButton = param1.currentTarget as SelectedCheckButton;
         PetBagController.instance().activateAlertFrameShow = !_loc2_.selected;
      }
      
      private function __onAlertFrame(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener("response",this.__onAlertFrame);
         if(param1.responseCode == 2 || param1.responseCode == 3)
         {
            this.sendWashBone();
         }
         _loc2_.dispose();
      }
      
      private function updatePetPro(param1:CEvent) : void
      {
         var _loc2_:* = undefined;
         if(Boolean(this._proItems) && this._proItems.length > 0)
         {
            this._curPetInfo = PetBagController.instance().petModel.currentPetInfo;
            for each(_loc2_ in this._proItems)
            {
               _loc2_.update(this._curPetInfo);
            }
            this.updateData();
         }
      }
      
      protected function __updateBag(param1:BagEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:BagInfo = param1.target as BagInfo;
         var _loc3_:Dictionary = param1.changedSlots;
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.TemplateID == 12656)
            {
               this.updateCellCount();
            }
         }
      }
      
      private function updateData() : void
      {
         if(this._curPetInfo == null)
         {
            return;
         }
         this._starBar.starNum(!!this._curPetInfo ? this._curPetInfo.StarLevel : 0);
         this._petBigItem.info = this._curPetInfo;
         if(Boolean(this._petBigItem.fightImg))
         {
            this._petBigItem.fightImg.visible = false;
         }
         this._petGrade.info = this._curPetInfo;
         this._petName.text = this._curPetInfo.Name;
         this._lvTxt.text = !!this._curPetInfo ? this._curPetInfo.Level.toString() : "";
      }
      
      private function sendWashBone() : void
      {
         var _loc1_:Array = this.getProLockState();
         PetBagController.instance().addPetWashProItemLock(this._curPetInfo.ID,_loc1_);
         PetBagController.instance().sendPetWashBone(this._curPetInfo.Place,_loc1_[0],_loc1_[1],_loc1_[2],_loc1_[3],_loc1_[4]);
      }
      
      private function getProLockState() : Array
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:Array = [0,0,0,0,0];
         if(this._proItems == null || this._proItems.length <= 0)
         {
            return _loc3_;
         }
         _loc2_ = 0;
         while(_loc2_ < this._proItems.length)
         {
            _loc1_ = this._proItems[_loc2_] as PetWashBoneProItem;
            if(Boolean(_loc1_.isLock))
            {
               _loc3_[_loc2_] = 1;
            }
            else
            {
               _loc3_[_loc2_] = 0;
            }
            _loc2_++;
         }
         return _loc3_;
      }
      
      private function get goodCountEnough() : Boolean
      {
         var _loc2_:int = 0;
         var _loc1_:DictionaryData = ServerConfigManager.instance.petWashCost;
         if((_loc2_ = this.getProLockCount) > 4)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.pets.washBone.proLockMaxCountMsg"));
            return false;
         }
         if(_loc1_.length < _loc2_)
         {
            return false;
         }
         var _loc3_:int = int(_loc1_[_loc2_]);
         var _loc4_:int = this.getWashBoneCount;
         if(_loc3_ > _loc4_)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.pets.washBone.goodEnoughMsg"));
            return false;
         }
         return true;
      }
      
      private function get getWashBoneCount() : int
      {
         var _loc1_:BagInfo = PlayerManager.Instance.Self.getBag(1);
         return int(_loc1_.getItemCountByTemplateId(this._goodCell.info.TemplateID));
      }
      
      private function get getProLockCount() : int
      {
         var result:Array = this.getProLockState().filter((function():*
         {
            var isManager:* = undefined;
            return isManager = function(param1:*, param2:int, param3:Array):Boolean
            {
               return param1 == 1;
            };
         })());
         return result.length;
      }
      
      private function get getProLockCost() : int
      {
         var _loc1_:int = this.getProLockCount;
         var _loc2_:DictionaryData = ServerConfigManager.instance.petWashCost;
         if(_loc2_.length <= 0)
         {
            return 5;
         }
         return int(_loc2_[_loc1_]);
      }
      
      private function initEvent() : void
      {
         this._washBoneBtn.addEventListener("click",this.__washBoneHandler);
         PlayerManager.Instance.Self.PropBag.addEventListener("update",this.__updateBag);
         PlayerManager.Instance.addEventListener("updatePet",this.updatePetPro);
      }
      
      private function removeEvent() : void
      {
         this._washBoneBtn.removeEventListener("click",this.__washBoneHandler);
         PlayerManager.Instance.Self.PropBag.removeEventListener("update",this.__updateBag);
         PlayerManager.Instance.removeEventListener("updatePet",this.updatePetPro);
      }
      
      public function dispose() : void
      {
         var _loc1_:* = null;
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._petBigItem);
         this._petBigItem = null;
         ObjectUtils.disposeObject(this._starBar);
         this._starBar = null;
         ObjectUtils.disposeObject(this._petName);
         this._petName = null;
         ObjectUtils.disposeObject(this._lvTxt);
         this._lvTxt = null;
         ObjectUtils.disposeObject(this._petGrade);
         this._petGrade = null;
         ObjectUtils.disposeObject(this._goodCell);
         this._goodCell = null;
         ObjectUtils.disposeObject(this._descTxt);
         this._descTxt = null;
         ObjectUtils.disposeObject(this._washBoneBtn);
         this._washBoneBtn = null;
         ObjectUtils.disposeObject(this._lv);
         this._lv = null;
         ObjectUtils.disposeObject(this._proGrowTxt);
         this._proGrowTxt = null;
         ObjectUtils.disposeObject(this._proMaxTxt);
         this._proMaxTxt = null;
         ObjectUtils.disposeObject(this._confirmFrame);
         this._confirmFrame = null;
         this._gradeArr = null;
         this._curPetInfo = null;
         while(Boolean(this._proItems) && this._proItems.length > 0)
         {
            _loc1_ = this._proItems.shift();
            _loc1_.removeEventListener("clickLock",this.__updateCostCount);
            ObjectUtils.disposeObject(_loc1_);
         }
         this._proItems = null;
         ObjectUtils.disposeObject(this._proVBox);
         this._proVBox = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
