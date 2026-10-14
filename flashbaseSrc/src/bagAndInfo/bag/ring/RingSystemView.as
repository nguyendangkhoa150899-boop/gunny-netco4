package bagAndInfo.bag.ring
{
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.bag.ring.data.RingSystemData;
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.HelpFrameUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class RingSystemView extends Frame
   {
       
      
      private var _helpBtn:BaseButton;
      
      private var _bg:Bitmap;
      
      private var _progress:bagAndInfo.bag.ring.RingSystemLevel;
      
      private var _ringCell:BagCell;
      
      private var _currentData:FilterFrameText;
      
      private var _nextData:FilterFrameText;
      
      private var _infoText:FilterFrameText;
      
      private var _coupleNum:bagAndInfo.bag.ring.RingSystemFilterInfo;
      
      private var _dungeonNum:bagAndInfo.bag.ring.RingSystemFilterInfo;
      
      private var _propsNum:bagAndInfo.bag.ring.RingSystemFilterInfo;
      
      private var _skill:ScaleFrameImage;
      
      public function RingSystemView()
      {
         super();
         this.initView();
         this.initEvent();
         this.sendPkg();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("ddt.bagandinfo.ringSystem.titleText");
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.RingSystem.helpBtn");
         addToContent(this._helpBtn);
         this._bg = ComponentFactory.Instance.creat("asset.bagAndInfo.bag.RingSystemView.bg");
         addToContent(this._bg);
         this._progress = new bagAndInfo.bag.ring.RingSystemLevel();
         PositionUtils.setPos(this._progress,"bagAndInfo.RingSystem.ProgressPos");
         addToContent(this._progress);
         this._ringCell = new BagCell(0,PlayerManager.Instance.Self.Bag.items[16]);
         this._ringCell.setBgVisible(false);
         this._ringCell.setContentSize(70,70);
         PositionUtils.setPos(this._ringCell,"bagAndInfo.RingSystem.ringPos");
         addToContent(this._ringCell);
         this._currentData = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.RingSystemView.currentData");
         addToContent(this._currentData);
         this._nextData = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.RingSystemView.nextData");
         addToContent(this._nextData);
         this._skill = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.RingSystemView.skill");
         this._skill.width = 56;
         this._skill.height = 56;
         addToContent(this._skill);
         this._infoText = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.RingSystemView.infoText");
         this._infoText.text = LanguageMgr.GetTranslation("ddt.bagandinfo.ringSystem.infoText2");
         PositionUtils.setPos(this._infoText,"bagAndInfo.RingSystem.skillPos");
         addToContent(this._infoText);
         this._coupleNum = new bagAndInfo.bag.ring.RingSystemFilterInfo(1);
         PositionUtils.setPos(this._coupleNum,"bagAndInfo.RingSystem.couplePos");
         addToContent(this._coupleNum);
         this._dungeonNum = new bagAndInfo.bag.ring.RingSystemFilterInfo(2);
         PositionUtils.setPos(this._dungeonNum,"bagAndInfo.RingSystem.dungeonPos");
         addToContent(this._dungeonNum);
         this._propsNum = new bagAndInfo.bag.ring.RingSystemFilterInfo(2);
         PositionUtils.setPos(this._propsNum,"bagAndInfo.RingSystem.propsPos");
         addToContent(this._propsNum);
         this.setViewInfo();
         this.setSkillTipData();
      }
      
      private function initEvent() : void
      {
         this._helpBtn.addEventListener("click",this.__onHelpClick);
         PlayerManager.Instance.Self.addEventListener("propertychange",this.__onUpdateProperty);
      }
      
      protected function __onHelpClick(param1:MouseEvent) : void
      {
         HelpFrameUtils.Instance.simpleHelpFrame(LanguageMgr.GetTranslation("ddt.consortia.bossFrame.helpTitle"),ComponentFactory.Instance.creat("asset.bagAndInfo.bag.RingSystem.heopInfo"),408,488);
      }
      
      protected function setViewInfo() : void
      {
         var _loc1_:RingSystemData = BagAndInfoManager.Instance.getCurrentRingData();
         this._currentData.text = _loc1_.Attack + "%\n" + _loc1_.Defence + "%\n" + _loc1_.Agility + "%\n" + _loc1_.Luck + "%";
         var _loc2_:RingSystemData = BagAndInfoManager.Instance.RingData[_loc1_.Level + 1];
         if(_loc2_ != null)
         {
            this._nextData.text = _loc2_.Attack + "%\n" + _loc2_.Defence + "%\n" + _loc2_.Agility + "%\n" + _loc2_.Luck + "%";
         }
         else
         {
            PlayerManager.Instance.Self.RingExp = _loc1_.Exp;
         }
         var _loc3_:int = !!_loc2_ ? _loc2_.Exp : int(_loc1_.Exp);
         ConsoleLog.write("RingExp = " + PlayerManager.Instance.Self.RingExp);
         ConsoleLog.write("_loc3_.Exp = " + _loc1_.Exp);
         ConsoleLog.write("Exp = " + (PlayerManager.Instance.Self.RingExp - _loc1_.Exp));
         ConsoleLog.write("Level = " + _loc1_.Level);
         ConsoleLog.write("Total = " + (_loc3_ - _loc1_.Exp));
         this._progress.setProgress(PlayerManager.Instance.Self.RingExp - _loc1_.Exp,_loc1_.Level,_loc3_ - _loc1_.Exp);
      }
      
      private function setSkillTipData() : void
      {
         var _loc4_:int = 0;
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         _loc4_ = BagAndInfoManager.Instance.getCurrentRingData().Level / 10;
         if(_loc4_ == 0)
         {
            _loc1_ = ConsortionModelControl.Instance.model.getskillInfoWithTypeAndLevel(0,1)[0];
            (_loc2_ = {})["name"] = _loc1_.name;
            _loc2_["content"] = LanguageMgr.GetTranslation("tank.bagAndInfo.ringSkill.notGet");
         }
         else
         {
            _loc1_ = ConsortionModelControl.Instance.model.getskillInfoWithTypeAndLevel(0,_loc4_)[0];
            (_loc2_ = {})["name"] = _loc1_.name + "Lv" + _loc4_;
            _loc2_["content"] = _loc1_.descript.replace("{0}",_loc1_.value);
         }
         if(_loc4_ < RingSystemData.TotalLevel * 0.1)
         {
            _loc3_ = ConsortionModelControl.Instance.model.getskillInfoWithTypeAndLevel(0,_loc4_ + 1)[0];
            _loc2_["nextLevel"] = LanguageMgr.GetTranslation("tank.bagAndInfo.ringSkill.nextLevel",_loc3_.name,_loc4_ + 1,_loc3_.descript.replace("{0}",_loc3_.value));
            _loc2_["limitLevel"] = LanguageMgr.GetTranslation("tank.bagAndInfo.ringSkill.nextUnLock",(_loc4_ + 1) * 10);
         }
         else
         {
            _loc2_["nextLevel"] = LanguageMgr.GetTranslation("tank.bagAndInfo.ringSkill.fullLevel");
            _loc2_["limitLevel"] = "";
         }
         this._skill.tipData = _loc2_;
         if(_loc4_ <= 0)
         {
            this._skill.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      private function __onUpdateProperty(param1:PlayerPropertyEvent) : void
      {
         var _loc2_:* = null;
         if(Boolean(param1.changedProperties["ringUseNum"]))
         {
            _loc2_ = PlayerManager.Instance.Self.ringUseNum;
            this._coupleNum.setInfoText({
               "info":this.getSurplusCount(_loc2_[0],20) + "/20",
               "tipData":LanguageMgr.GetTranslation("ddt.bagandinfo.ringSystem.infoText3")
            });
            this._dungeonNum.setInfoText({
               "info":this.getSurplusCount(_loc2_[1],4) + "/4",
               "tipData":LanguageMgr.GetTranslation("ddt.bagandinfo.ringSystem.infoText4")
            });
            this._propsNum.setInfoText({
               "info":this.getSurplusCount(_loc2_[2],5) + "/5",
               "tipData":LanguageMgr.GetTranslation("ddt.bagandinfo.ringSystem.infoText5")
            });
         }
      }
      
      private function getSurplusCount(param1:int, param2:int) : int
      {
         return param2 - param1;
      }
      
      private function sendPkg() : void
      {
         SocketManager.Instance.out.getPlayerSpecialProperty(2);
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.removeEventListener("propertychange",this.__onUpdateProperty);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
      }
   }
}
