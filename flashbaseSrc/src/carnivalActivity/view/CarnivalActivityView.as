package carnivalActivity.view
{
   import baglocked.BaglockedManager;
   import carnivalActivity.CarnivalActivityManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftCurInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.SendGiftInfo;
   import wonderfulActivity.data.WonderfulActivityTypeData;
   import wonderfulActivity.views.IRightView;
   
   public class CarnivalActivityView extends Sprite implements IRightView
   {
       
      
      private var _bg:Bitmap;
      
      private var _titleBg:Bitmap;
      
      private var _titleTxt:FilterFrameText;
      
      private var _closeTimeTxt:FilterFrameText;
      
      private var _timeTxt:FilterFrameText;
      
      private var _timer:Timer;
      
      private var _sumTime:Number = 0;
      
      private var _sumTimeStr:String;
      
      private var _actTxt:FilterFrameText;
      
      private var _actTimeTxt:FilterFrameText;
      
      private var _getTxt:FilterFrameText;
      
      private var _getTimeTxt:FilterFrameText;
      
      private var _descSp:Sprite;
      
      private var _descTxt:FilterFrameText;
      
      private var _allDescBg:ScaleBitmapImage;
      
      private var _allDescTxt:FilterFrameText;
      
      private var _buyBg:Bitmap;
      
      private var _priceTxt:FilterFrameText;
      
      private var _buyCountTxt:FilterFrameText;
      
      private var _dailyBuyBg:Bitmap;
      
      private var _buyBtn:TextButton;
      
      private var _gift:carnivalActivity.view.CarnivalActivityGift;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _vBox:VBox;
      
      private var _type:int;
      
      private var _childType:int;
      
      private var _item:GmActivityInfo;
      
      private var _buyGiftItem:GmActivityInfo;
      
      private var _buyGiftCurInfo:GiftCurInfo;
      
      private var _buyCount:int;
      
      private var _hasBuyGift:Boolean = false;
      
      private var _buyGiftLimitType:int;
      
      private var _buyGiftLimitCount:int;
      
      private var _buyGiftType:int;
      
      private var _buyGiftPrice:int;
      
      private var _buyGiftActId:String = "";
      
      private var _giftInfoVec:Vector.<GiftBagInfo>;
      
      private var _infoVec:Vector.<GmActivityInfo>;
      
      private var _itemVec:Vector.<carnivalActivity.view.CarnivalActivityItem>;
      
      private var _id:String;
      
      public function CarnivalActivityView(param1:int, param2:int = 0, param3:String = "")
      {
         this._type = param1;
         this._childType = param2;
         this._id = param3;
         this._itemVec = new Vector.<CarnivalActivityItem>();
         super();
      }
      
      public function init() : void
      {
         this.initData();
         if(this._item == null)
         {
            return;
         }
         this.initView();
         this.initEvent();
         this.updateTime();
      }
      
      private function initData() : void
      {
         var _loc1_:GmActivityInfo = null;
         var _loc2_:int = 0;
         var _loc3_:GmActivityInfo = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         this._giftInfoVec = new Vector.<GiftBagInfo>();
         this._infoVec = new Vector.<GmActivityInfo>();
         for each(_loc1_ in WonderfulActivityManager.Instance.activityData)
         {
            if(_loc1_.activityType == this._type && _loc1_.activityType == WonderfulActivityTypeData.DAILY_GIFT)
            {
               this.initItem(_loc1_);
            }
            else if(this._childType == WonderfulActivityTypeData.CARNIVAL_ROOKIE && _loc1_.activityType == this._type && (_loc1_.activityChildType == WonderfulActivityTypeData.CARNIVAL_ROOKIE || _loc1_.activityChildType == WonderfulActivityTypeData.CARNIVAL_ROOKIE + 8))
            {
               this.initItem(_loc1_);
            }
            else if(_loc1_.activityType == WonderfulActivityTypeData.GOD_TEMPLE && _loc1_.activityChildType == WonderfulActivityTypeData.GOD_TEMPLE_LEVEL_UP && WonderfulActivityManager.Instance.leftViewInfoDic[_loc1_.activityId] != null)
            {
               if(this._id == _loc1_.activityId)
               {
                  this.initItem(_loc1_);
                  break;
               }
            }
            else if(_loc1_.activityType == this._type && _loc1_.activityChildType == this._childType)
            {
               this.initItem(_loc1_);
               break;
            }
         }
         CarnivalActivityManager.instance.currentType = this._type;
         CarnivalActivityManager.instance.currentChildType = this._childType;
         _loc2_ = 0;
         while(_loc2_ < this._infoVec.length)
         {
            _loc4_ = 0;
            while(_loc4_ < this._infoVec[_loc2_].giftbagArray.length)
            {
               if(this._infoVec[_loc2_].giftbagArray[_loc4_].rewardMark == 100)
               {
                  _loc5_ = 0;
                  while(_loc5_ < this._infoVec[_loc2_].giftbagArray[_loc4_].giftConditionArr.length)
                  {
                     if(this._infoVec[_loc2_].giftbagArray[_loc4_].giftConditionArr[_loc5_].conditionIndex == 101 && this._infoVec[_loc2_].giftbagArray[_loc4_].giftConditionArr[_loc5_].conditionValue == 1)
                     {
                        this._hasBuyGift = true;
                        this._buyGiftActId = this._infoVec[_loc2_].giftbagArray[_loc4_].giftConditionArr[_loc5_].remain2;
                        break;
                     }
                     _loc5_++;
                  }
               }
               if(this._hasBuyGift)
               {
                  break;
               }
               _loc4_++;
            }
            _loc2_++;
         }
         for each(_loc3_ in WonderfulActivityManager.Instance.activityData)
         {
            if(_loc3_.activityId == this._buyGiftActId)
            {
               this._buyGiftItem = _loc3_;
               this._buyGiftLimitType = this._buyGiftItem.giftbagArray[0].giftConditionArr[0].conditionValue;
               this._buyGiftLimitCount = this._buyGiftItem.giftbagArray[0].giftConditionArr[1].conditionValue;
               this._buyGiftType = this._buyGiftItem.giftbagArray[0].giftConditionArr[2].conditionValue;
               this._buyGiftPrice = this._buyGiftItem.giftbagArray[0].giftConditionArr[3].conditionValue;
               break;
            }
         }
      }
      
      private function initItem(param1:GmActivityInfo) : void
      {
         if(!this._item)
         {
            this._item = param1;
         }
         if(this._sumTime == 0)
         {
            this._sumTime = Date.parse(param1.endTime) - new Date().time;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.giftbagArray.length)
         {
            this._giftInfoVec.push(param1.giftbagArray[_loc2_]);
            _loc2_++;
         }
         this._infoVec.push(param1);
      }
      
      private function updateTime() : void
      {
         var _loc1_:int = this._sumTime <= 0 ? int(0) : int(this._sumTime / (1000 * 60 * 60));
         var _loc2_:int = this._sumTime <= 0 ? int(0) : int((this._sumTime / (1000 * 60 * 60) - _loc1_) * 60);
         var _loc3_:String = "";
         if(_loc1_ < 10)
         {
            _loc3_ += "0" + _loc1_;
         }
         else
         {
            _loc3_ += _loc1_;
         }
         _loc3_ += LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.hour");
         if(_loc2_ < 10)
         {
            _loc3_ += "0" + _loc2_;
         }
         else
         {
            _loc3_ += _loc2_;
         }
         _loc3_ += LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.minute");
         this._timeTxt.text = _loc3_;
      }
      
      protected function __timerHandler(param1:TimerEvent) : void
      {
         this._sumTime -= 1000 * 60;
         this.updateTime();
      }
      
      private function initView() : void
      {
         var _loc8_:String = null;
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:GiftRewardInfo = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:carnivalActivity.view.CarnivalActivityItem = null;
         CarnivalActivityManager.instance.getBeginTime = Date.parse(this._item.beginShowTime);
         CarnivalActivityManager.instance.getEndTime = Date.parse(this._item.endShowTime);
         CarnivalActivityManager.instance.actBeginTime = Date.parse(this._item.beginTime);
         CarnivalActivityManager.instance.actEndTime = Date.parse(this._item.endTime);
         this._bg = ComponentFactory.Instance.creat("carnicalAct.bg");
         addChild(this._bg);
         if(this._type == WonderfulActivityTypeData.MOUNT_MASTER)
         {
            this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.mountDarenTxt");
            addChild(this._titleTxt);
            this._titleTxt.text = "Vua thú cưỡi";
         }
         else if(this._type == WonderfulActivityTypeData.GOD_TEMPLE)
         {
            this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.mountDarenTxt");
            addChild(this._titleTxt);
            this._titleTxt.text = "Tăng Cấp Miếu Thần";
         }
         else
         {
            if(this._type == WonderfulActivityTypeData.CARNIVAL_ACTIVITY)
            {
               this._titleBg = ComponentFactory.Instance.creat("carnicalAct.title" + this._childType);
               PositionUtils.setPos(this._titleBg,"carnivalAct.titlePos" + this._childType);
            }
            else
            {
               this._titleBg = ComponentFactory.Instance.creat("carnicalAct.title" + this._type);
               PositionUtils.setPos(this._titleBg,"carnivalAct.titlePos" + this._type);
            }
            addChild(this._titleBg);
         }
         this._closeTimeTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.closeTimeTxt");
         addChild(this._closeTimeTxt);
         this._closeTimeTxt.text = LanguageMgr.GetTranslation("carnival.closeTimeTxt");
         this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.timeTxt");
         addChild(this._timeTxt);
         this._actTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.actTxt");
         addChild(this._actTxt);
         this._actTxt.text = LanguageMgr.GetTranslation("tank.calendar.GoodsExchangeView.actTimeText");
         this._actTimeTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.actTimeTxt");
         addChild(this._actTimeTxt);
         this._actTimeTxt.text = this._item.beginTime.split(" ")[0] + "-" + this._item.endTime.split(" ")[0];
         this._getTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.getTxt");
         addChild(this._getTxt);
         this._getTxt.text = LanguageMgr.GetTranslation("carnival.getTimeTxt");
         this._getTimeTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.getTimeTxt");
         addChild(this._getTimeTxt);
         this._getTimeTxt.text = this._item.beginShowTime.split(" ")[0] + "-" + this._item.endShowTime.split(" ")[0];
         this._descTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.descTxt");
         this._descSp = new Sprite();
         this._descSp.addChild(this._descTxt);
         _loc8_ = this._item.desc;
         this._descTxt.text = _loc8_;
         addChild(this._descSp);
         this._allDescBg = ComponentFactory.Instance.creatComponentByStylename("core.commonTipBg");
         this._allDescBg.x = this._descTxt.x;
         this._allDescBg.y = this._descTxt.y + 25;
         this._allDescTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.allDescTxt");
         this._allDescTxt.text = _loc8_;
         this._allDescBg.width = this._allDescTxt.width + 16;
         this._allDescBg.height = this._allDescTxt.height + 8;
         this._allDescTxt.x = this._allDescBg.x + 8;
         this._allDescTxt.y = this._allDescBg.y + 4;
         this._allDescBg.visible = this._allDescTxt.visible = false;
         if(this._hasBuyGift)
         {
            this._buyBg = ComponentFactory.Instance.creat("carnicalAct.buyItem");
            addChild(this._buyBg);
            this._priceTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.priceTxt");
            addChild(this._priceTxt);
            this._priceTxt.text = this._buyGiftPrice + LanguageMgr.GetTranslation("carnival.buyGiftTypeTxt" + (this._buyGiftType == -1 ? 2 : 1));
            if(this._buyGiftLimitType != 3)
            {
               if(this._buyGiftLimitType == 1)
               {
                  this._dailyBuyBg = ComponentFactory.Instance.creat("carnivalAct.dailyBuyBg");
                  addChild(this._dailyBuyBg);
               }
               this._buyCountTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.buyCountTxt");
            }
            else
            {
               this._priceTxt.y += 9;
            }
            this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.buyBtn");
            addChild(this._buyBtn);
            this._buyBtn.text = LanguageMgr.GetTranslation("store.Strength.BuyButtonText");
            this._gift = new carnivalActivity.view.CarnivalActivityGift();
            this._gift.tipStyle = "ddt.view.tips.OneLineTip";
            this._gift.tipDirctions = "2,7,5";
            _loc1_ = LanguageMgr.GetTranslation("ddt.bagandinfo.awardsTitle") + "\n";
            _loc2_ = 0;
            while(_loc2_ < this._buyGiftItem.giftbagArray.length)
            {
               _loc3_ = 0;
               while(_loc3_ < this._buyGiftItem.giftbagArray[_loc2_].giftRewardArr.length)
               {
                  _loc4_ = this._buyGiftItem.giftbagArray[_loc2_].giftRewardArr[_loc3_];
                  _loc5_ = ItemManager.Instance.getTemplateById(_loc4_.templateId).Name;
                  _loc1_ += _loc5_ + "x" + _loc4_.count + (_loc3_ == this._buyGiftItem.giftbagArray[_loc2_].giftRewardArr.length - 1 ? "" : "、\n");
                  _loc3_++;
               }
               _loc2_++;
            }
            this._gift.tipData = _loc1_;
            this._gift.x = this._buyBg.x + 12;
            this._gift.y = this._buyBg.y + 11;
            addChild(this._gift);
         }
         else
         {
            this._actTxt.x += 125;
            this._actTimeTxt.x += 130;
            this._getTxt.x += 125;
            this._getTimeTxt.x += 130;
            this._descSp.x += 125;
            this._allDescBg.x += 125;
            this._allDescTxt.x += 125;
         }
         this._vBox = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.vbox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.scroll");
         this._scrollPanel.setView(this._vBox);
         addChild(this._scrollPanel);
         var _loc9_:int = 0;
         while(_loc9_ < this._infoVec.length)
         {
            _loc6_ = 0;
            while(_loc6_ < this._infoVec[_loc9_].giftbagArray.length)
            {
               if(this._infoVec[_loc9_].giftbagArray[_loc6_].rewardMark != 100)
               {
                  switch(this._type)
                  {
                     case WonderfulActivityTypeData.WHOLEPEOPLE_VIP:
                        _loc7_ = new WholePeopleVipActItem(this._type,this._infoVec[_loc9_].giftbagArray[_loc6_],_loc6_ % 2);
                        break;
                     case WonderfulActivityTypeData.WHOLEPEOPLE_PET:
                        _loc7_ = new WholePeoplePetActItem(this._type,this._infoVec[_loc9_].giftbagArray[_loc6_],_loc6_ % 2);
                        break;
                     case WonderfulActivityTypeData.DAILY_GIFT:
                        _loc7_ = new DailyGiftItem(this._type,this._infoVec[_loc9_].giftbagArray[_loc6_],_loc6_ % 2);
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_ROOKIE:
                        _loc7_ = new RookieItem(this._type,this._infoVec[_loc9_].giftbagArray[_loc6_],_loc6_ % 2);
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_ACTIVITY:
                        if(this._childType == WonderfulActivityTypeData.CARNIVAL_ROOKIE)
                        {
                           _loc7_ = new RookieItem(this._type,this._infoVec[_loc9_].giftbagArray[_loc6_],_loc6_ % 2);
                        }
                        else
                        {
                           _loc7_ = new carnivalActivity.view.CarnivalActivityItem(this._type,this._infoVec[_loc9_].giftbagArray[_loc6_],_loc6_ % 2);
                        }
                  }
                  this._itemVec.push(_loc7_);
                  this._vBox.addChild(_loc7_);
               }
               _loc6_++;
            }
            _loc9_++;
         }
         this._scrollPanel.invalidateViewport();
         if(this._childType == 1)
         {
            this._timeTxt.x = 421;
            this._timeTxt.y = 175;
            this._closeTimeTxt.x = 418;
            this._closeTimeTxt.y = 159;
            if(!this._hasBuyGift)
            {
               this._closeTimeTxt.x += 216;
               this._closeTimeTxt.y = 154;
               this._timeTxt.x += 216;
               this._timeTxt.y = 170;
            }
         }
         this._timer = new Timer(1000 * 60,int(this._sumTime / 1000));
         this._timer.addEventListener(TimerEvent.TIMER,this.__timerHandler);
         this._timer.start();
         addChild(this._allDescBg);
         addChild(this._allDescTxt);
         this.updateView();
      }
      
      public function updateView() : void
      {
         var _loc1_:carnivalActivity.view.CarnivalActivityItem = null;
         for each(_loc1_ in this._itemVec)
         {
            _loc1_.updateView();
         }
         if(!this._buyGiftItem)
         {
            return;
         }
         if(Boolean(WonderfulActivityManager.Instance.activityInitData[this._buyGiftItem.activityId]) && Boolean(WonderfulActivityManager.Instance.activityInitData[this._buyGiftItem.activityId].giftInfoDic[this._buyGiftItem.giftbagArray[0].giftbagId]))
         {
            this._buyGiftCurInfo = WonderfulActivityManager.Instance.activityInitData[this._buyGiftItem.activityId].giftInfoDic[this._buyGiftItem.giftbagArray[0].giftbagId];
         }
         if(this._buyGiftLimitType != 3)
         {
            if(Boolean(this._buyGiftCurInfo))
            {
               this._buyCount = this._buyGiftLimitCount - this._buyGiftCurInfo.times;
            }
            else
            {
               this._buyCount = this._buyGiftLimitCount;
            }
            this._buyBtn.enable = this._buyCount > 0;
         }
         else
         {
            this._buyBtn.enable = true;
         }
         if(Boolean(this._buyCountTxt))
         {
            this._buyCountTxt.text = LanguageMgr.GetTranslation("carnival.awardBuyCountTxt",this._buyCount + "/" + this._buyGiftLimitCount);
         }
      }
      
      private function initEvent() : void
      {
         if(Boolean(this._buyBtn))
         {
            this._buyBtn.addEventListener(MouseEvent.CLICK,this.__buyGiftPackHandler);
         }
         this._descSp.addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this._descSp.addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         WonderfulActivityManager.Instance.addEventListener(WonderfulActivityManager.UPDATE_MOUNT_MASTER,this.__updateMountMaster);
      }
      
      private function __updateMountMaster(param1:Event) : void
      {
         this.updateView();
      }
      
      protected function __outHandler(param1:MouseEvent) : void
      {
         this._allDescTxt.visible = false;
         this._allDescBg.visible = false;
      }
      
      protected function __overHandler(param1:MouseEvent) : void
      {
         this._allDescTxt.visible = true;
         this._allDescBg.visible = true;
      }
      
      protected function __buyGiftPackHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.playButtonSound();
         if(!this._buyGiftItem)
         {
            return;
         }
         if(this._buyGiftType == -8)
         {
            _loc2_ = AlertManager.NOSELECTBTN;
         }
         else
         {
            _loc2_ = AlertManager.SELECTBTN;
         }
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("carnival.awardGiftBuyTxt",this._buyGiftPrice),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",60,false,_loc2_);
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__alertBuyGift);
      }
      
      protected function buyGift(param1:Boolean) : void
      {
         var _loc2_:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         var _loc3_:SendGiftInfo = new SendGiftInfo();
         _loc3_.activityId = this._buyGiftItem.activityId;
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < this._buyGiftItem.giftbagArray.length)
         {
            _loc4_.push(this._buyGiftItem.giftbagArray[_loc5_].giftbagId + "," + (param1 ? -9 : -8));
            _loc5_++;
         }
         _loc3_.giftIdArr = _loc4_;
         _loc2_.push(_loc3_);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(_loc2_);
      }
      
      protected function __alertBuyGift(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         var _loc3_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc3_.removeEventListener(FrameEvent.RESPONSE,this.__alertBuyGift);
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  ObjectUtils.disposeObject(param1.currentTarget);
                  return;
               }
               if(_loc3_.isBand)
               {
                  if(!this.checkMoney(true))
                  {
                     _loc3_.dispose();
                     _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("buried.alertInfo.noBindMoney"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
                     _loc2_.addEventListener(FrameEvent.RESPONSE,this.onResponseHander);
                     return;
                  }
               }
               else if(!this.checkMoney(false))
               {
                  _loc3_.dispose();
                  _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
                  _loc2_.addEventListener(FrameEvent.RESPONSE,this._response);
                  return;
               }
               this.buyGift(_loc3_.isBand);
               break;
         }
         _loc3_.dispose();
      }
      
      private function _response(param1:FrameEvent) : void
      {
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._response);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function onResponseHander(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.onResponseHander);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(!this.checkMoney(false))
            {
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               _loc2_.addEventListener(FrameEvent.RESPONSE,this._response);
               return;
            }
            this.buyGift(false);
         }
         param1.currentTarget.dispose();
      }
      
      private function checkMoney(param1:Boolean) : Boolean
      {
         if(param1)
         {
            if(PlayerManager.Instance.Self.Gift < this._buyGiftPrice)
            {
               return false;
            }
         }
         else if(PlayerManager.Instance.Self.Money < this._buyGiftPrice)
         {
            return false;
         }
         return true;
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._buyBtn))
         {
            this._buyBtn.removeEventListener(MouseEvent.CLICK,this.__buyGiftPackHandler);
         }
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__timerHandler);
         }
         if(Boolean(this._descSp))
         {
            this._descSp.removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
            this._descSp.removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         }
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function setState(param1:int, param2:int) : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._titleBg);
         this._titleBg = null;
         ObjectUtils.disposeObject(this._closeTimeTxt);
         this._closeTimeTxt = null;
         ObjectUtils.disposeObject(this._timeTxt);
         this._timeTxt = null;
         ObjectUtils.disposeObject(this._actTxt);
         this._actTxt = null;
         ObjectUtils.disposeObject(this._actTimeTxt);
         this._actTimeTxt = null;
         ObjectUtils.disposeObject(this._getTxt);
         this._getTxt = null;
         ObjectUtils.disposeObject(this._getTimeTxt);
         this._getTimeTxt = null;
         ObjectUtils.disposeObject(this._descTxt);
         this._descTxt = null;
         ObjectUtils.disposeObject(this._priceTxt);
         this._priceTxt = null;
         ObjectUtils.disposeObject(this._buyCountTxt);
         this._buyCountTxt = null;
         ObjectUtils.disposeObject(this._dailyBuyBg);
         this._dailyBuyBg = null;
         ObjectUtils.disposeObject(this._scrollPanel);
         this._scrollPanel = null;
         ObjectUtils.disposeObject(this._buyBtn);
         this._buyBtn = null;
         ObjectUtils.disposeObject(this._gift);
         this._gift = null;
         ObjectUtils.disposeObject(this._buyBg);
         this._buyBg = null;
         ObjectUtils.disposeObject(this._allDescBg);
         this._allDescBg = null;
         ObjectUtils.disposeObject(this._allDescTxt);
         this._allDescTxt = null;
         ObjectUtils.disposeObject(this._descSp);
         this._descSp = null;
         ObjectUtils.disposeObject(this._titleTxt);
         this._titleTxt = null;
         this._itemVec = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
