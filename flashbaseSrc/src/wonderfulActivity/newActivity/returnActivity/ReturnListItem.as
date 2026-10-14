package wonderfulActivity.newActivity.returnActivity
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftChildInfo;
   import wonderfulActivity.data.GiftCurInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.data.PlayerCurInfo;
   import wonderfulActivity.data.SendGiftInfo;
   import wonderfulActivity.items.GiftBagItem;
   import wonderfulActivity.items.PrizeListItem;
   
   public class ReturnListItem extends Sprite implements Disposeable
   {
       
      
      private var _back:MovieClip;
      
      private var _nameTxt:FilterFrameText;
      
      private var _prizeHBox:HBox;
      
      private var _btn:SimpleBitmapButton;
      
      private var _btnTxt:FilterFrameText;
      
      private var _tipsBtn:Bitmap;
      
      private var _type:int;
      
      private var _bgType:int;
      
      private var _actId:String;
      
      private var giftInfo:GiftBagInfo;
      
      private var condition:int;
      
      private var condition2:int;
      
      private var _canSelect:Boolean;
      
      private var _selectedIndex:int;
      
      private var _prizeArr:Array;
      
      public function ReturnListItem(param1:int, param2:int, param3:String)
      {
         super();
         this._type = param1;
         this._bgType = param2;
         this._actId = param3;
         this.initView();
      }
      
      private function initView() : void
      {
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.listItem");
         addChild(this._back);
         if(this._bgType == 0)
         {
            this._back.gotoAndStop(1);
         }
         else
         {
            this._back.gotoAndStop(2);
         }
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.returnItem.nameTxt");
         addChild(this._nameTxt);
         this._nameTxt.y = this._back.height / 2 - this._nameTxt.height / 2;
         this._prizeHBox = ComponentFactory.Instance.creatComponentByStylename("wonderful.returnActivity.Hbox");
         addChild(this._prizeHBox);
      }
      
      public function setData(param1:String, param2:GiftBagInfo, param3:Boolean) : void
      {
         var _loc4_:Dictionary = null;
         var _loc5_:int = 0;
         var _loc6_:GiftBagItem = null;
         var _loc7_:GiftRewardInfo = null;
         var _loc8_:PrizeListItem = null;
         this.giftInfo = param2;
         this.condition = this.giftInfo.giftConditionArr[0].conditionValue;
         param1 = param1.replace(/\{0\}/g,this.condition);
         this.condition2 = this.giftInfo.giftConditionArr[1].conditionValue;
         if(this.condition2 == -1)
         {
            param1 = param1.replace(/-\{1\}/g,LanguageMgr.GetTranslation("wonderfulActivity.above"));
         }
         else
         {
            param1 = param1.replace(/\{1\}/g,this.condition2);
         }
         this._nameTxt.text = param1;
         this._nameTxt.y = this._back.height / 2 - this._nameTxt.height / 2;
         var _loc9_:Vector.<GiftRewardInfo> = this.giftInfo.giftRewardArr;
         this._canSelect = param3;
         this._prizeArr = [];
         if(this._canSelect)
         {
            _loc4_ = this.classifyReward(_loc9_);
            _loc5_ = 0;
            while(_loc5_ <= 3)
            {
               if(Boolean(_loc4_[_loc5_.toString()]))
               {
                  _loc6_ = new GiftBagItem(this._type,_loc5_);
                  _loc6_.addEventListener(MouseEvent.CLICK,this.__itemClick);
                  this._prizeHBox.addChild(_loc6_);
                  _loc6_.setData(_loc4_[_loc5_]);
                  this._prizeArr.push(_loc6_);
               }
               _loc5_++;
            }
            if(this._prizeArr.length == 1)
            {
               (this._prizeArr[0] as GiftBagItem).selected = true;
            }
         }
         else
         {
            _loc5_ = 0;
            while(_loc5_ <= _loc9_.length - 1)
            {
               _loc7_ = _loc9_[_loc5_];
               _loc8_ = new PrizeListItem();
               _loc8_.initView(_loc5_);
               _loc8_.setCellData(_loc7_);
               this._prizeHBox.addChild(_loc8_);
               this._prizeArr.push(_loc8_);
               _loc5_++;
            }
         }
      }
      
      protected function __itemClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:int = 0;
         while(_loc2_ <= this._prizeArr.length - 1)
         {
            this._prizeArr[_loc2_].selected = false;
            _loc2_++;
         }
         var _loc3_:GiftBagItem = param1.currentTarget as GiftBagItem;
         _loc3_.selected = true;
         this._selectedIndex = _loc3_.index;
      }
      
      private function classifyReward(param1:Vector.<GiftRewardInfo>) : Dictionary
      {
         var _loc2_:GiftRewardInfo = null;
         var _loc3_:Dictionary = new Dictionary();
         for each(_loc2_ in param1)
         {
            if(!_loc3_[_loc2_.rewardType])
            {
               _loc3_[_loc2_.rewardType] = new Vector.<GiftRewardInfo>();
            }
            (_loc3_[_loc2_.rewardType] as Vector.<GiftRewardInfo>).push(_loc2_);
         }
         return _loc3_;
      }
      
      public function setStatus(param1:Array, param2:Dictionary) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:PlayerCurInfo = null;
         this.clearBtn();
         var _loc6_:int = (param2[this.giftInfo.giftbagId] as GiftCurInfo).times;
         var _loc7_:int = this.giftInfo.giftConditionArr[2].conditionValue;
         if(this._type == 2 || this._type == 3)
         {
            for each(_loc5_ in param1)
            {
               if(_loc5_.statusID == this.condition)
               {
                  _loc3_ = _loc5_.statusValue - _loc6_;
               }
            }
         }
         else
         {
            _loc4_ = int(param1[0].statusValue);
            _loc3_ = int(Math.floor(_loc4_ / this.condition)) - _loc6_;
         }
         if(_loc7_ == 0)
         {
            if(_loc3_ > 0)
            {
               this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.smallGetBtn");
               addChild(this._btn);
               this._btnTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.btnTxt");
               this._btnTxt.text = "(" + _loc3_ + ")";
               this._btn.addChild(this._btnTxt);
               this._tipsBtn = ComponentFactory.Instance.creat("wonderfulactivity.can.repeat");
               this._btn.addChild(this._tipsBtn);
               this._btn.addEventListener(MouseEvent.CLICK,this.getRewardBtnClick);
            }
            else
            {
               this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.bigGetBtn");
               addChild(this._btn);
               this._tipsBtn = ComponentFactory.Instance.creat("wonderfulactivity.can.repeat");
               this._tipsBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               this._btn.addChild(this._tipsBtn);
               this._btn.enable = false;
            }
         }
         else if(_loc6_ == 0)
         {
            this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.bigGetBtn");
            addChild(this._btn);
            this._btn.enable = false;
            if(_loc3_ > 0)
            {
               this._btn.enable = true;
               this._btn.addEventListener(MouseEvent.CLICK,this.getRewardBtnClick);
            }
         }
         else
         {
            this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.overBtn");
            this._btn.enable = false;
            addChild(this._btn);
         }
      }
      
      protected function getRewardBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._canSelect)
         {
            if(this._selectedIndex <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wonderfulActivity.choosePrizeFirst"));
               return;
            }
         }
         var _loc2_:SendGiftInfo = new SendGiftInfo();
         _loc2_.activityId = this._actId;
         var _loc3_:GiftChildInfo = new GiftChildInfo();
         _loc3_.giftId = this.giftInfo.giftbagId;
         _loc3_.index = this._selectedIndex;
         _loc2_.giftIdArr = [_loc3_];
         var _loc4_:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         _loc4_.push(_loc2_);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(_loc4_);
         this._btn.enable = false;
      }
      
      private function clearBtn() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._btn);
         this._btn = null;
         ObjectUtils.disposeObject(this._btnTxt);
         this._btnTxt = null;
         ObjectUtils.disposeObject(this._tipsBtn);
         this._tipsBtn = null;
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._btn))
         {
            this._btn.removeEventListener(MouseEvent.CLICK,this.getRewardBtnClick);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         var _loc1_:int = 0;
         while(_loc1_ <= this._prizeArr.length - 1)
         {
            this._prizeArr[_loc1_].removeEventListener(MouseEvent.CLICK,this.__itemClick);
            ObjectUtils.disposeObject(this._prizeArr[_loc1_]);
            this._prizeArr[_loc1_] = null;
            _loc1_++;
         }
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._nameTxt);
         this._nameTxt = null;
         ObjectUtils.disposeObject(this._prizeHBox);
         this._prizeHBox = null;
         ObjectUtils.disposeObject(this._btn);
         this._btn = null;
         ObjectUtils.disposeObject(this._btnTxt);
         this._btnTxt = null;
         ObjectUtils.disposeObject(this._tipsBtn);
         this._tipsBtn = null;
      }
   }
}
