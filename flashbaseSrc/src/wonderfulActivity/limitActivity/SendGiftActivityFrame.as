package wonderfulActivity.limitActivity
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.SendGiftInfo;
   
   public class SendGiftActivityFrame extends Frame
   {
       
      
      private var _bg:Bitmap;
      
      private var sendBtn:SimpleBitmapButton;
      
      private var _info:GmActivityInfo;
      
      private var _goodContent:Sprite;
      
      private var _prizeHBox:HBox;
      
      private var _activityBox:Sprite;
      
      public var nowId:String;
      
      public function SendGiftActivityFrame()
      {
         super();
         this.initview();
         this.addEvent();
      }
      
      private function initview() : void
      {
         titleText = LanguageMgr.GetTranslation("ddt.sendGiftActivityFrame.title");
         this._bg = ComponentFactory.Instance.creat("wonderful.sendGiftActivity.bg");
         addToContent(this._bg);
         this.sendBtn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.sendGiftFrame.sendBtn");
         addToContent(this.sendBtn);
         this._prizeHBox = ComponentFactory.Instance.creatComponentByStylename("wonderful.sendGiftActivity.Hbox");
         addToContent(this._prizeHBox);
         this._activityBox = new Sprite();
         addToContent(this._activityBox);
      }
      
      public function setData(param1:GmActivityInfo) : void
      {
         var _loc8_:ActivityItem = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:GiftRewardInfo = null;
         var _loc5_:GiftItem = null;
         var _loc6_:Date = null;
         var _loc7_:GmActivityInfo = null;
         _loc8_ = null;
         this._info = param1;
         this.nowId = this._info.activityId;
         var _loc9_:int = 0;
         while(_loc9_ < this._info.giftbagArray.length)
         {
            _loc3_ = 0;
            while(_loc3_ < this._info.giftbagArray[_loc9_].giftRewardArr.length)
            {
               _loc4_ = new GiftRewardInfo();
               _loc4_ = this._info.giftbagArray[_loc9_].giftRewardArr[_loc3_];
               _loc5_ = new GiftItem();
               _loc5_.initView(_loc3_ + _loc9_ * this._info.giftbagArray[_loc9_].giftRewardArr.length);
               _loc5_.setCellData(_loc4_);
               this._prizeHBox.addChild(_loc5_);
               _loc3_++;
            }
            _loc9_++;
         }
         this._prizeHBox.x = (this.width - this._prizeHBox.width) / 2;
         var _loc10_:Array = this._info.remain2.split("|");
         _loc2_ = 0;
         _loc9_ = 0;
         while(_loc9_ < _loc10_.length)
         {
            _loc6_ = TimeManager.Instance.Now();
            _loc7_ = WonderfulActivityManager.Instance.activityData[_loc10_[_loc9_]];
            if(Boolean(_loc7_))
            {
               if(!(_loc6_.time < Date.parse(_loc7_.beginShowTime) || _loc6_.time > Date.parse(_loc7_.endShowTime)))
               {
                  _loc8_ = new ActivityItem();
                  _loc8_.setData(_loc10_[_loc9_]);
                  _loc8_.x = 22;
                  _loc8_.y = 282 + 34 * _loc2_;
                  this._activityBox.addChild(_loc8_);
                  _loc2_++;
               }
            }
            _loc9_++;
         }
      }
      
      public function setBtnFalse() : void
      {
         if(Boolean(this.sendBtn))
         {
            this.sendBtn.enable = false;
            this.sendBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      private function addEvent() : void
      {
         this.sendBtn.addEventListener(MouseEvent.CLICK,this.__sendBtnClickHandler);
         addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function __sendBtnClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         var _loc3_:SendGiftInfo = new SendGiftInfo();
         _loc3_.activityId = this._info.activityId;
         var _loc4_:Array = new Array();
         _loc4_.push(this._info.giftbagArray[0].giftbagId);
         _loc3_.giftIdArr = _loc4_;
         _loc2_.push(_loc3_);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(_loc2_);
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         this.sendBtn.removeEventListener(MouseEvent.CLICK,this.__sendBtnClickHandler);
         removeEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this.sendBtn);
         this.sendBtn = null;
         ObjectUtils.disposeObject(this._goodContent);
         this._goodContent = null;
         ObjectUtils.disposeObject(this._prizeHBox);
         this._prizeHBox = null;
         ObjectUtils.disposeObject(this._activityBox);
         this._activityBox = null;
      }
   }
}

import bagAndInfo.cell.BagCell;
import com.pickgliss.ui.ComponentFactory;
import com.pickgliss.ui.core.Disposeable;
import com.pickgliss.utils.ObjectUtils;
import ddt.data.goods.InventoryItemInfo;
import ddt.manager.ItemManager;
import ddt.utils.PositionUtils;
import flash.display.Bitmap;
import flash.display.Sprite;
import wonderfulActivity.data.GiftRewardInfo;

class GiftItem extends Sprite implements Disposeable
{
    
   
   private var index:int;
   
   private var _bg:Bitmap;
   
   private var _bagCell:BagCell;
   
   public function GiftItem()
   {
      super();
   }
   
   public function initView(param1:int) : void
   {
      this.index = param1;
      this._bg = ComponentFactory.Instance.creat("wonderful.sendGiftActivity.frame");
      addChild(this._bg);
      this._bagCell = new BagCell(param1);
      this._bagCell.height = 70;
      this._bagCell.width = 70;
      PositionUtils.setPos(this._bagCell,"wonderful.SendGiftative.bagCellPos");
      this._bagCell.visible = false;
      addChild(this._bagCell);
   }
   
   public function setCellData(param1:GiftRewardInfo) : void
   {
      if(!param1)
      {
         this._bagCell.visible = false;
         return;
      }
      this._bagCell.visible = true;
      var _loc2_:InventoryItemInfo = new InventoryItemInfo();
      _loc2_.TemplateID = param1.templateId;
      _loc2_ = ItemManager.fill(_loc2_);
      _loc2_.IsBinds = param1.isBind;
      _loc2_.ValidDate = param1.validDate;
      var _loc3_:Array = param1.property.split(",");
      _loc2_._StrengthenLevel = parseInt(_loc3_[0]);
      _loc2_.AttackCompose = parseInt(_loc3_[1]);
      _loc2_.DefendCompose = parseInt(_loc3_[2]);
      _loc2_.AgilityCompose = parseInt(_loc3_[3]);
      _loc2_.LuckCompose = parseInt(_loc3_[4]);
      this._bagCell.info = _loc2_;
      this._bagCell.setCount(param1.count);
      this._bagCell.setBgVisible(false);
   }
   
   public function dispose() : void
   {
      if(Boolean(this._bg))
      {
         ObjectUtils.disposeObject(this._bg);
      }
      this._bg = null;
      if(Boolean(this._bagCell))
      {
         ObjectUtils.disposeObject(this._bagCell);
      }
      this._bagCell = null;
   }
}

import com.pickgliss.ui.ComponentFactory;
import com.pickgliss.ui.controls.TextButton;
import com.pickgliss.ui.core.Disposeable;
import com.pickgliss.ui.text.FilterFrameText;
import com.pickgliss.utils.ObjectUtils;
import ddt.manager.LanguageMgr;
import ddt.manager.SocketManager;
import ddt.manager.SoundManager;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import wonderfulActivity.WonderfulActivityManager;

class ActivityItem extends Sprite implements Disposeable
{
    
   
   private var txtBtn:TextButton;
   
   private var nameTxt:FilterFrameText;
   
   private var _id:String;
   
   public function ActivityItem()
   {
      super();
      this.txtBtn = ComponentFactory.Instance.creatComponentByStylename("wonderfull.sendGiftActivity.check");
      this.txtBtn.text = LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.view");
      addChild(this.txtBtn);
      this.nameTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfull.sendGiftActivity.nameTxt");
      addChild(this.nameTxt);
      this.nameTxt.mouseEnabled = true;
      this.nameTxt.addEventListener(TextEvent.LINK,this.linkhandler);
      this.txtBtn.addEventListener(MouseEvent.CLICK,this.clickhandler);
   }
   
   private function linkhandler(param1:TextEvent) : void
   {
      SoundManager.instance.play("008");
      WonderfulActivityManager.Instance.selectId = this._id;
      WonderfulActivityManager.Instance.clickWonderfulActView = true;
      SocketManager.Instance.out.requestWonderfulActInit(1);
   }
   
   private function clickhandler(param1:MouseEvent) : void
   {
      SoundManager.instance.play("008");
      WonderfulActivityManager.Instance.selectId = this._id;
      WonderfulActivityManager.Instance.clickWonderfulActView = true;
      SocketManager.Instance.out.requestWonderfulActInit(1);
   }
   
   public function setData(param1:String) : void
   {
      this._id = param1;
      var _loc2_:String = String(WonderfulActivityManager.Instance.activityData[param1].activityName);
      if(_loc2_.length > 40)
      {
         this.nameTxt.htmlText = "<a href=\'event:\'>" + _loc2_.substr(0,40) + "...</a>";
      }
      else
      {
         this.nameTxt.htmlText = "<a href=\'event:\'>" + _loc2_ + "</a>";
      }
   }
   
   public function dispose() : void
   {
      this.nameTxt.removeEventListener(TextEvent.LINK,this.linkhandler);
      this.txtBtn.removeEventListener(MouseEvent.CLICK,this.clickhandler);
      if(Boolean(this.txtBtn))
      {
         ObjectUtils.disposeObject(this.txtBtn);
      }
      this.txtBtn = null;
      if(Boolean(this.nameTxt))
      {
         ObjectUtils.disposeObject(this.nameTxt);
      }
      this.nameTxt = null;
   }
}
