package hallIcon.view
{
   import GodSyah.SyahManager;
   import HappyRecharge.HappyRechargeManager;
   import accumulativeLogin.AccumulativeManager;
   import catchbeast.CatchBeastManager;
   import chickActivation.ChickActivationManager;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import cryptBoss.CryptBossManager;
   import ddt.manager.BossBoxManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.bossbox.SmallBoxButton;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import godCardRaise.GodCardRaiseManager;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import hallIcon.event.HallIconEvent;
   import hallIcon.info.HallIconInfo;
   import littleGame.LittleGameManager;
   import newChickenBox.controller.NewChickenBoxManager;
   import noviceactivity.NoviceActivityManager;
   import pyramid.PyramidManager;
   import roulette.LeftGunRouletteManager;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   import wonderfulActivity.WonderfulActivityManager;
   import signActivity.SignActivityMgr;
   
   public class HallRightIconView extends Sprite implements Disposeable
   {
       
      
      private var _iconBox:HBox;
      
      private var _boxButton:SmallBoxButton;
      
      private var _wonderFulPlay:hallIcon.view.HallIconPanel;
      
      private var _activity:hallIcon.view.HallIconPanel;
      
      private var _lastCreatTime:Number;
      
      private var _showArrowSp:Sprite;
      
      public function HallRightIconView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._showArrowSp = new Sprite();
         addChild(this._showArrowSp);
         this._iconBox = new HBox();
         this._iconBox.spacing = 5;
         addChild(this._iconBox);
         this.updateActivityIcon();
         this.updateWonderfulPlayIcon();
		 SignActivityMgr.instance.showIcon();
         this.checkShowBossBox();
      }
      
      private function initEvent() : void
      {
         HallIconManager.instance.model.addEventListener(HallIconEvent.UPDATE_RIGHTICON_VIEW,this.__updateIconViewHandler);
         HallIconManager.instance.model.addEventListener(HallIconEvent.UPDATE_BATCH_RIGHTICON_VIEW,this.__updateBatchIconViewHandler);
         HallIconManager.instance.addEventListener(HallIconEvent.CHECK_HALLICONEXPERIENCEOPEN,this.__checkHallIconExperienceOpenHandler);
      }
      
      private function addChildBox(param1:DisplayObject) : void
      {
         this._iconBox.addChild(param1);
         this._iconBox.arrange();
         this._iconBox.x = -this._iconBox.width;
      }
      
      private function __updateBatchIconViewHandler(param1:HallIconEvent) : void
      {
         var _loc2_:HallIconInfo = null;
         var _loc3_:Dictionary = HallIconManager.instance.model.cacheRightIconDic;
         for each(_loc2_ in _loc3_)
         {
            this.updateIconView(_loc2_);
         }
      }
      
      private function __updateIconViewHandler(param1:HallIconEvent) : void
      {
         var _loc2_:HallIconInfo = HallIconInfo(param1.data);
         this.updateIconView(_loc2_);
      }
      
      private function updateIconView(param1:HallIconInfo) : void
      {
         if(param1.halltype == HallIcon.WONDERFULPLAY && Boolean(this._wonderFulPlay))
         {
            this.commonUpdateIconPanelView(this._wonderFulPlay,param1,false);
         }
         else if(param1.halltype == HallIcon.ACTIVITY && Boolean(this._activity))
         {
            this.commonUpdateIconPanelView(this._activity,param1,true);
         }
         else
         {
            switch(param1.icontype)
            {
               case HallIconType.WONDERFULPLAY:
                  this.updateWonderfulPlayIcon();
                  break;
               case HallIconType.ACTIVITY:
                  this.updateActivityIcon();
				  SignActivityMgr.instance.showIcon();
            }
         }
      }
      
      private function commonUpdateIconPanelView(param1:hallIcon.view.HallIconPanel, param2:HallIconInfo, param3:Boolean = false) : void
      {
         var _loc4_:HallIcon = null;
         if(param2.isopen)
         {
            _loc4_ = param1.getIconByType(param2.icontype) as HallIcon;
            if(!_loc4_)
            {
               _loc4_ = param1.addIcon(this.createHallIconPanelIcon(param2),param2.icontype,param2.orderid,param3) as HallIcon;
            }
            _loc4_.updateIcon(param2);
         }
         else
         {
            param1.removeIconByType(param2.icontype);
         }
         param1.arrange();
      }
      
      private function updateWonderfulPlayIcon() : void
      {
         if(HallIconManager.instance.model.wonderFulPlayIsOpen)
         {
            if(this._wonderFulPlay == null)
            {
               this._wonderFulPlay = new hallIcon.view.HallIconPanel("assets.hallIcon.wonderfulPlayIcon",HallIconPanel.BOTTOM,6);
               this._wonderFulPlay.addEventListener(MouseEvent.CLICK,this.__wonderFulPlayClickHandler);
               this.addChildBox(this._wonderFulPlay);
            }
         }
         else
         {
            this.removeWonderfulPlayIcon();
         }
      }
      
      private function checkShowBossBox() : void
      {
         if(BossBoxManager.instance.isShowBoxButton())
         {
            if(this._boxButton == null)
            {
               this._boxButton = new SmallBoxButton(SmallBoxButton.HALL_POINT);
            }
            this.addChildBox(this._boxButton);
         }
         else
         {
            this.removeBossBox();
         }
      }
      
      private function __wonderFulPlayClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:HallIcon = null;
         if(Boolean(this._wonderFulPlay) && param1.target == this._wonderFulPlay.mainIcon)
         {
            this.topIndex();
            this.checkNoneActivity(this._wonderFulPlay.count);
            this.checkRightIconTaskClickHandler(HallIcon.WONDERFULPLAY);
            return;
         }
         if(getTimer() - this._lastCreatTime < 1000)
         {
            return;
         }
         this._lastCreatTime = getTimer();
         if(param1.target is HallIcon)
         {
            _loc2_ = param1.target as HallIcon;
            if(_loc2_.iconInfo.halltype == HallIcon.WONDERFULPLAY)
            {
               switch(_loc2_.iconInfo.icontype)
               {
                  case HallIconType.WORLDBOSSENTRANCE1:
                  case HallIconType.WORLDBOSSENTRANCE4:
                     SoundManager.instance.play("003");
                     StateManager.setState(StateType.WORLDBOSS_AWARD);
                     break;
                  case HallIconType.LITTLEGAMENOTE:
                     SoundManager.instance.play("008");
                     if(LittleGameManager.Instance.hasActive())
                     {
                        StateManager.setState(StateType.LITTLEHALL);
                     }
                     else
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthBoxIconTips.labelII"));
                     }
                     break;
                  case HallIconType.CONSORTIABATTLE:
                     SoundManager.instance.play("008");
                     if(ConsortiaBattleManager.instance.isCanEnter)
                     {
                        GameInSocketOut.sendSingleRoomBegin(4);
                     }
                     else if(PlayerManager.Instance.Self.ConsortiaID != 0)
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.cannotEnterTxt"));
                     }
                     else
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.cannotEnterTxt2"));
                     }
                     break;
                  case HallIconType.CRYPT_BOSS:
                     if(PlayerManager.Instance.Self.Grade < 30)
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",30));
                        return;
                     }
                     CryptBossManager.instance.show();
                     break;
               }
            }
         }
      }
      
      private function updateActivityIcon() : void
      {
         if(HallIconManager.instance.model.activityIsOpen)
         {
            if(this._activity == null)
            {
               this._activity = new hallIcon.view.HallIconPanel("assets.hallIcon.activityIcon",HallIconPanel.BOTTOM,6);
               this._activity.addEventListener(MouseEvent.CLICK,this.__activityClickHandler);
               this.addChildBox(this._activity);
            }
         }
         else
         {
            this.removeActivityIcon();
         }
      }
      
      private function __activityClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:HallIcon = null;
         if(Boolean(this._activity) && param1.target == this._activity.mainIcon)
         {
            this.topIndex();
            this.checkNoneActivity(this._activity.count);
            this.checkRightIconTaskClickHandler(HallIcon.ACTIVITY);
            return;
         }
         if(getTimer() - this._lastCreatTime < 1000)
         {
            return;
         }
         this._lastCreatTime = getTimer();
         if(param1.target is HallIcon)
         {
            _loc2_ = param1.target as HallIcon;
            if(_loc2_.iconInfo.halltype == HallIcon.ACTIVITY)
            {
               switch(_loc2_.iconInfo.icontype)
               {
                  case HallIconType.ACCUMULATIVE_LOGIN:
                     AccumulativeManager.instance.showFrame();
                     break;
                  case HallIconType.PYRAMID:
                     PyramidManager.instance.onClickPyramidIcon(param1);
                     break;
                  case HallIconType.LIMITACTIVITY:
                     SoundManager.instance.play("008");
                     WonderfulActivityManager.Instance.clickWonderfulActView = true;
                     SocketManager.Instance.out.requestWonderfulActInit(1);
                     break;
                  case HallIconType.LEFTGUNROULETTE:
                     LeftGunRouletteManager.instance.showTurnplate();
                     break;
                  case HallIconType.WelfareCenterIcon:
                     NoviceActivityManager.instance.show();
                     break;
                  case HallIconType.HAPPYRECHARGE:
                     SoundManager.instance.play("008");
                     HappyRechargeManager.instance.loadResource();
                     break;
                  case HallIconType.SYAH:
                     SoundManager.instance.play("008");
                     SyahManager.Instance.showFrame();
                     break;
                  case HallIconType.NEWCHICKENBOX:
                     NewChickenBoxManager.instance.enterNewBoxView(param1);
                     break;
                  case HallIconType.GODCARD:
                     SoundManager.instance.play("008");
                     GodCardRaiseManager.Instance.show();
                     break;
                  case HallIconType.CATCHBEAST:
                     CatchBeastManager.instance.show();
                     break;
                  case HallIconType.CHICKACTIVATION:
                     SoundManager.instance.play("008");
                     if(PlayerManager.Instance.Self.Grade < 16)
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",16));
                        return;
                     }
                     ChickActivationManager.instance.showFrame();
                     break;
				 case HallIconType.SIGNACTIVITY:
					 SocketManager.Instance.out.requestWonderfulActInit(2);
					 WonderfulActivityManager.Instance.refreshIconStatus();
					 SoundManager.instance.play("008");
					 SignActivityMgr.instance.show();
					 break;
               }
            }
         }
      }
      
      public function createHallIconPanelIcon(param1:HallIconInfo) : HallIcon
      {
         var _loc2_:String = null;
         switch(param1.icontype)
         {
            case HallIconType.ACCUMULATIVE_LOGIN:
               _loc2_ = "assets.hallIcon.accumulativeLoginIcon";
               break;
            case HallIconType.PYRAMID:
               _loc2_ = "assets.hallIcon.pyramidIcon";
               break;
            case HallIconType.LIMITACTIVITY:
               _loc2_ = "assets.hallIcon.limitActivityIcon";
               break;
            case HallIconType.LEFTGUNROULETTE:
               _loc2_ = "assets.hallIcon.rouletteGunIcon";
               break;
            case HallIconType.LITTLEGAMENOTE:
               _loc2_ = "assets.hallIcon.littleGameNoteIcon";
               break;
            case HallIconType.CONSORTIABATTLE:
               _loc2_ = "assets.hallIcon.consortiaBattleEntryIcon";
               break;
            //case HallIconType.WelfareCenterIcon:
               //_loc2_ = "asset.hallIcon.welfareCenterIcon";
               //break;
            case HallIconType.WORLDBOSSENTRANCE1:
               _loc2_ = "assets.hallIcon.worldBossEntrance_1";
               break;
            case HallIconType.WORLDBOSSENTRANCE4:
               _loc2_ = "assets.hallIcon.worldBossEntrance_4";
               break;
            case HallIconType.HAPPYRECHARGE:
               _loc2_ = "assets.hallIcon.happyRecharge";
               break;
            case HallIconType.SYAH:
               _loc2_ = "assets.hallIcon.syahIcon";
               break;
            case HallIconType.CRYPT_BOSS:
               _loc2_ = "asset.ddthall.cryptBoss";
               break;
            case HallIconType.NEWCHICKENBOX:
               _loc2_ = "assets.hallIcon.newChickenBoxIcon";
               break;
            //case HallIconType.GODCARD:
               //_loc2_ = "assets.hallIcon.godCard";
               //break;
            case HallIconType.CATCHBEAST:
               _loc2_ = "asset.hallIcon.catchBeastIcon";
               break;
            case HallIconType.CHICKACTIVATION:
               _loc2_ = "assets.hallIcon.chickActivationIcon";
			   break;
		   case HallIconType.SIGNACTIVITY:
			   _loc2_ = "assets.hallIcon.signActivity";
			   break;
         }
         return new HallIcon(_loc2_,param1);
      }
      
      public function getIconByType(param1:int, param2:String) : DisplayObject
      {
         if(param1 == HallIcon.WONDERFULPLAY && Boolean(this._wonderFulPlay))
         {
            return this._wonderFulPlay.getIconByType(param2);
         }
         if(param1 == HallIcon.ACTIVITY && Boolean(this._activity))
         {
            return this._activity.getIconByType(param2);
         }
         return null;
      }
      
      private function topIndex() : void
      {
         if(Boolean(this.parent) && this.parent.numChildren > 1)
         {
            this.parent.setChildIndex(this,this.parent.numChildren - 1);
         }
      }
      
      private function checkNoneActivity(param1:int) : void
      {
         if(param1 <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.calendar.NoneActivity"));
         }
      }
      
      public function __checkHallIconExperienceOpenHandler(param1:HallIconEvent) : void
      {
         this.updateRightIconTaskArrow();
      }
      
      private function updateRightIconTaskArrow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Object = HallIconManager.instance.model.cacheRightIconTask;
         if(_loc3_ && !_loc3_.isCompleted && SharedManager.Instance.halliconExperienceStep < 2)
         {
            _loc1_ = SharedManager.Instance.halliconExperienceStep;
            _loc2_ = 1;
            if(this._iconBox.numChildren == 3)
            {
               _loc2_ = 2;
            }
            else if(this._iconBox.numChildren == 4)
            {
               _loc2_ = 3;
            }
            else if(this._iconBox.numChildren == 5)
            {
               _loc2_ = 4;
            }
            if(_loc1_ == 1)
            {
               _loc2_ += 1;
            }
            NewHandContainer.Instance.showArrow(ArrowType.HALLICON_EXPERIENCE,-90,"hallIcon.hallIconExperiencePos" + _loc2_,"assets.hallIcon.experienceClickTxt","hallIcon.hallIconExperienceTxt" + _loc2_,this._showArrowSp,0,true);
         }
         else if(NewHandContainer.Instance.hasArrow(ArrowType.HALLICON_EXPERIENCE))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.HALLICON_EXPERIENCE);
         }
      }
      
      private function checkRightIconTaskClickHandler(param1:int) : void
      {
         if(!HallIconManager.instance.model.cacheRightIconTask)
         {
            return;
         }
         if(param1 == HallIcon.WONDERFULPLAY && SharedManager.Instance.halliconExperienceStep == 0)
         {
            SharedManager.Instance.halliconExperienceStep = 1;
            this.updateRightIconTaskArrow();
            SharedManager.Instance.save();
         }
         else if(param1 == HallIcon.ACTIVITY && SharedManager.Instance.halliconExperienceStep == 1)
         {
            SharedManager.Instance.halliconExperienceStep = 2;
            this.updateRightIconTaskArrow();
            SharedManager.Instance.halliconExperienceStep = 0;
            SharedManager.Instance.save();
         }
      }
      
      private function removeEvent() : void
      {
         HallIconManager.instance.model.removeEventListener(HallIconEvent.UPDATE_RIGHTICON_VIEW,this.__updateIconViewHandler);
         HallIconManager.instance.model.removeEventListener(HallIconEvent.UPDATE_BATCH_RIGHTICON_VIEW,this.__updateBatchIconViewHandler);
         HallIconManager.instance.removeEventListener(HallIconEvent.CHECK_HALLICONEXPERIENCEOPEN,this.__checkHallIconExperienceOpenHandler);
      }
      
      private function removeWonderfulPlayIcon() : void
      {
         if(Boolean(this._wonderFulPlay))
         {
            this._wonderFulPlay.removeEventListener(MouseEvent.CLICK,this.__wonderFulPlayClickHandler);
            ObjectUtils.disposeObject(this._wonderFulPlay);
            this._wonderFulPlay = null;
         }
      }
      
      private function removeActivityIcon() : void
      {
         if(Boolean(this._activity))
         {
            this._activity.removeEventListener(MouseEvent.CLICK,this.__activityClickHandler);
            ObjectUtils.disposeObject(this._activity);
            this._activity = null;
         }
      }
      
      private function removeBossBox() : void
      {
         if(Boolean(this._boxButton))
         {
            ObjectUtils.disposeAllChildren(this._boxButton);
            ObjectUtils.disposeObject(this._boxButton);
            this._boxButton = null;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeWonderfulPlayIcon();
         this.removeActivityIcon();
         this.removeBossBox();
         if(NewHandContainer.Instance.hasArrow(ArrowType.HALLICON_EXPERIENCE))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.HALLICON_EXPERIENCE);
         }
         if(Boolean(this._showArrowSp))
         {
            ObjectUtils.disposeAllChildren(this._showArrowSp);
            ObjectUtils.disposeObject(this._showArrowSp);
            this._showArrowSp = null;
         }
         if(Boolean(this._iconBox))
         {
            ObjectUtils.disposeAllChildren(this._iconBox);
            ObjectUtils.disposeObject(this._iconBox);
            this._iconBox = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
