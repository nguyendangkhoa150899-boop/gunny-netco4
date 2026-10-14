package wonderfulActivity.items
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftCurInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.data.SendGiftInfo;
   
   public class StrengthDarenItem extends Sprite implements Disposeable
   {
       
      
      private var _back:MovieClip;
      
      private var _icon:Bitmap;
      
      private var _nameTxt:FilterFrameText;
      
      private var _goodContent:Sprite;
      
      private var _btn:SimpleBitmapButton;
      
      private var _data:GiftBagInfo;
      
      private var _giftcurInfo:GiftCurInfo;
      
      private var _strengthGrade:int;
      
      private var _statusArr:Array;
      
      private var _activityId:String;
      
      public function StrengthDarenItem(param1:int, param2:String, param3:GiftBagInfo, param4:GiftCurInfo, param5:Array)
      {
         super();
         this._activityId = param2;
         this._data = param3;
         this._giftcurInfo = param4;
         this._strengthGrade = param5[0].statusValue;
         this._statusArr = param5;
         this.initView(param1);
      }
      
      private function initView(param1:int = 1) : void
      {
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.newListItem");
         addChild(this._back);
         if(param1 == 1)
         {
            this._back.gotoAndStop(1);
         }
         else
         {
            this._back.gotoAndStop(2);
         }
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.strength.nameTxt");
         addChild(this._nameTxt);
         this._nameTxt.text = LanguageMgr.GetTranslation("wonderfulActivity.strength.nameTxt",this._data.giftConditionArr[0].conditionValue);
         this._icon = ComponentFactory.Instance.creat("wonderfulactivity.strength" + this._data.giftConditionArr[0].conditionValue);
         addChild(this._icon);
         this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.bigGetBtn");
         PositionUtils.setPos(this._icon,"wonderful.strengthdaren.iconPos");
         if(this._strengthGrade < this._data.giftConditionArr[0].conditionValue || this.checkBtnState())
         {
            this._btn.enable = false;
         }
         else
         {
            this._btn.enable = true;
         }
         addChild(this._btn);
         this._btn.addEventListener(MouseEvent.CLICK,this.btnHandler);
         this.initGoods();
      }
      
      private function checkBtnState() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         while(_loc2_ < this._statusArr.length)
         {
            if(this._statusArr[_loc2_].statusID == this._data.giftConditionArr[0].conditionValue)
            {
               _loc1_ = true;
               if(this._statusArr[_loc2_].statusValue == 0)
               {
                  return true;
               }
            }
            _loc2_++;
         }
         if(!_loc1_)
         {
            return true;
         }
         return false;
      }
      
      private function btnHandler(param1:MouseEvent) : void
      {
         this._btn.enable = false;
         addChild(this._btn);
         SoundManager.instance.play("008");
         var _loc2_:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         var _loc3_:SendGiftInfo = new SendGiftInfo();
         _loc3_.activityId = this._activityId;
         var _loc4_:Array = new Array();
         _loc4_.push(this._data.giftbagId);
         _loc3_.giftIdArr = _loc4_;
         _loc2_.push(_loc3_);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(_loc2_);
      }
      
      private function initGoods() : void
      {
         var _loc1_:BagCell = null;
         var _loc2_:Bitmap = null;
         _loc1_ = null;
         _loc2_ = null;
         this._goodContent = new Sprite();
         addChild(this._goodContent);
         var _loc3_:int = 0;
         while(_loc3_ < this._data.giftRewardArr.length)
         {
            _loc1_ = this.createBagCell(0,this._data.giftRewardArr[_loc3_]);
            _loc2_ = ComponentFactory.Instance.creat("wonderfulactivity.goods.back");
            _loc2_.x = (_loc2_.width + 5) * _loc3_;
            _loc1_.x = _loc2_.width / 2 - _loc1_.width / 2 + _loc2_.x + 2;
            _loc1_.y = _loc2_.height / 2 - _loc1_.height / 2 + 1;
            this._goodContent.addChild(_loc2_);
            this._goodContent.addChild(_loc1_);
            _loc3_++;
         }
         this._goodContent.x = 142;
         this._goodContent.y = 9;
      }
      
      private function createBagCell(param1:int, param2:GiftRewardInfo) : BagCell
      {
         var _loc3_:InventoryItemInfo = new InventoryItemInfo();
         _loc3_.TemplateID = param2.templateId;
         _loc3_ = ItemManager.fill(_loc3_);
         _loc3_.IsBinds = param2.isBind;
         _loc3_.ValidDate = param2.validDate;
         var _loc4_:Array = param2.property.split(",");
         _loc3_._StrengthenLevel = parseInt(_loc4_[0]);
         _loc3_.AttackCompose = parseInt(_loc4_[1]);
         _loc3_.DefendCompose = parseInt(_loc4_[2]);
         _loc3_.AgilityCompose = parseInt(_loc4_[3]);
         _loc3_.LuckCompose = parseInt(_loc4_[4]);
         var _loc5_:BagCell = new BagCell(param1);
         _loc5_.info = _loc3_;
         _loc5_.setCount(param2.count);
         _loc5_.setBgVisible(false);
         return _loc5_;
      }
      
      public function dispose() : void
      {
         this._btn.removeEventListener(MouseEvent.CLICK,this.btnHandler);
         while(Boolean(this._goodContent.numChildren))
         {
            ObjectUtils.disposeObject(this._goodContent.getChildAt(0));
         }
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(Boolean(parent))
         {
            ObjectUtils.disposeObject(this);
         }
         this._goodContent = null;
         this._back = null;
         this._nameTxt = null;
         this._btn = null;
         this._icon = null;
      }
   }
}
