package bagAndInfo.info
{
   import bagAndInfo.BagAndGiftFrame;
   import cardSystem.view.cardEquip.CardEquipView;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import petsBag.view.PetsBagOtherView;
   import texpSystem.view.TexpInfoView;
   
   public class PlayerInfoFrame extends Frame
   {
       
      
      private var _BG:Scale9CornerImage;
      
      private var _view:bagAndInfo.info.PlayerInfoView;
      
      private var _texpView:TexpInfoView;
      
      private var _cardEquip:CardEquipView;
      
      private var _info:PlayerInfo;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _infoBtn:SelectedButton;
      
      private var _texpBtn:SelectedButton;
      
      private var _cardBtn:SelectedButton;
      
      private var _openTexp:Boolean;
      
      private var _openCard:Boolean;
      
      private var _petsView:PetsBagOtherView;
      
      private var _petBtn:SelectedButton;
      
      public function PlayerInfoFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this.escEnable = true;
         this.enterEnable = true;
         this._BG = ComponentFactory.Instance.creatComponentByStylename("PlayerInfoFrame.bg");
         this._infoBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.infoBtn");
         this._texpBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.texpBtn");
         this._petBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.petBtn");
         this._cardBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.cardBtn");
         PositionUtils.setPos(this._infoBtn,"PlayerInfoFrame.infoBtnPos");
         PositionUtils.setPos(this._texpBtn,"PlayerInfoFrame.texpBtnPos");
         PositionUtils.setPos(this._petBtn,"PlayerInfoFrame.petBtnPos");
         PositionUtils.setPos(this._cardBtn,"PlayerInfoFrame.cardBtnPos");
         addToContent(this._BG);
         addToContent(this._infoBtn);
         addToContent(this._petBtn);
         addToContent(this._cardBtn);
         addToContent(this._texpBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._infoBtn);
         this._btnGroup.addSelectItem(this._petBtn);
         this._btnGroup.addSelectItem(this._cardBtn);
         this._btnGroup.addSelectItem(this._texpBtn);
         this._btnGroup.selectIndex = 0;
      }
      
      private function initEvent() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._infoBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._petBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._cardBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._texpBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
      }
      
      private function __soundPlayer(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __changeHandler(param1:Event) : void
      {
         switch(this._btnGroup.selectIndex)
         {
            case BagAndGiftFrame.BAGANDINFO:
               this.showInfoFrame();
               break;
            case BagAndGiftFrame.GIFTVIEW:
               PlayerInfoViewControl.isOpenFromBag = false;
               this.showPetsView();
               break;
            case BagAndGiftFrame.CARDVIEW:
               if(!this._openCard)
               {
                  SocketManager.Instance.out.getPlayerCardInfo(this._info.ID);
                  this._openCard = true;
               }
               this.showCardEquip();
               break;
            case BagAndGiftFrame.TEXPVIEW:
               this.showTexpFrame();
         }
      }
      
      private function setVisible(param1:int) : void
      {
         this._view.visible = param1 == BagAndGiftFrame.BAGANDINFO || param1 == BagAndGiftFrame.CARDVIEW;
         if(Boolean(this._texpView))
         {
            this._texpView.visible = param1 == BagAndGiftFrame.TEXPVIEW;
         }
         if(Boolean(this._petsView))
         {
            this._petsView.visible = param1 == BagAndGiftFrame.PETVIEW;
         }
         if(this._view.visible)
         {
            this._view.switchShowII(param1 == BagAndGiftFrame.CARDVIEW);
         }
      }
      
      private function showCardEquip() : void
      {
         if(this._view == null)
         {
            this._view = ComponentFactory.Instance.creatCustomObject("bag.PersonalInfoView");
            this._view.showSelfOperation = false;
            addToContent(this._view);
         }
         if(Boolean(this._info))
         {
            this._view.info = this._info;
         }
         this.setVisible(BagAndGiftFrame.CARDVIEW);
      }
      
      private function showInfoFrame() : void
      {
         if(this._view == null)
         {
            this._view = ComponentFactory.Instance.creatCustomObject("bag.PersonalInfoView");
            this._view.showSelfOperation = false;
            addToContent(this._view);
         }
         if(Boolean(this._info))
         {
            this._view.info = this._info;
         }
         this.setVisible(BagAndGiftFrame.BAGANDINFO);
      }
      
      private function showTexpFrame() : void
      {
         try
         {
            if(this._texpView == null)
            {
               this._texpView = ComponentFactory.Instance.creatCustomObject("texpSystem.texpInfoView.main");
               addToContent(this._texpView);
            }
            if(Boolean(this._info))
            {
               this._texpView.info = this._info;
            }
            this.setVisible(BagAndGiftFrame.TEXPVIEW);
            return;
         }
         catch(e:Error)
         {
            UIModuleLoader.Instance.addUIModlue(UIModuleTypes.TEXP_SYSTEM);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__createTexp);
            return;
         }
      }
      
      private function __createTexp(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.TEXP_SYSTEM)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createTexp);
            this.showTexpFrame();
         }
      }
      
      private function showPetsView() : void
      {
         try
         {
            if(this._petsView == null)
            {
               this._petsView = ComponentFactory.Instance.creatCustomObject("petsBagOtherPnl.otherVIP");
               addToContent(this._petsView);
            }
            if(Boolean(this._info))
            {
               this._petsView.infoPlayer = this._info;
            }
            this.setVisible(BagAndGiftFrame.PETVIEW);
            return;
         }
         catch(e:Error)
         {
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.PETS_BAG);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__createPets);
            return;
         }
      }
      
      private function __createPets(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.PETS_BAG)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createPets);
            this.showPetsView();
         }
      }
      
      private function removeEvent() : void
      {
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._infoBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._texpBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._petBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._cardBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._btnGroup.selectIndex = 0;
         this.__changeHandler(null);
      }
      
      public function set info(param1:PlayerInfo) : void
      {
         this._info = param1;
         if(Boolean(this._view))
         {
            this._view.info = this._info;
         }
         if(Boolean(this._texpView))
         {
            this._texpView.info = this._info;
         }
         if(Boolean(this._petsView))
         {
            this._petsView.infoPlayer = this._info;
         }
         if(this._info.Grade < 25 || StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._petBtn.enable = false;
         }
         else
         {
            this._petBtn.enable = true;
         }
         if(this._info.Grade < 20 || StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._cardBtn.enable = false;
         }
         else
         {
            this._cardBtn.enable = true;
         }
         if(this._info.Grade < 10 || StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._texpBtn.enable = false;
         }
         else
         {
            this._texpBtn.enable = true;
         }
      }
      
      public function setAchivEnable(param1:Boolean) : void
      {
         this._view.setAchvEnable(param1);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this._info = null;
         if(Boolean(this._BG))
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(Boolean(this._infoBtn))
         {
            ObjectUtils.disposeObject(this._infoBtn);
         }
         this._infoBtn = null;
         if(Boolean(this._texpBtn))
         {
            ObjectUtils.disposeObject(this._texpBtn);
         }
         this._texpBtn = null;
         if(Boolean(this._petBtn))
         {
            ObjectUtils.disposeObject(this._petBtn);
            this._petBtn = null;
         }
         if(Boolean(this._cardBtn))
         {
            ObjectUtils.disposeObject(this._cardBtn);
         }
         this._cardBtn = null;
         if(Boolean(this._btnGroup))
         {
            ObjectUtils.disposeObject(this._btnGroup);
         }
         this._btnGroup = null;
         if(Boolean(this._view))
         {
            this._view.dispose();
         }
         this._view = null;
         if(Boolean(this._texpView))
         {
            this._texpView.dispose();
         }
         this._texpView = null;
         if(Boolean(this._petsView))
         {
            this._petsView.dispose();
            this._petsView = null;
         }
         PlayerInfoViewControl.clearView();
         super.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
