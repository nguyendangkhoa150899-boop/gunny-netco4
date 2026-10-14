package wonderfulActivity.newActivity.ExchangeAct
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.event.ActivityEvent;
   
   public class ExchangeGoodsCell extends BaseCell
   {
       
      
      private var _gooodsExchangeInfo:GiftRewardInfo;
      
      private var _countText:FilterFrameText;
      
      private var _type:Boolean;
      
      private var _haveCount:int;
      
      private var _needCount:int;
      
      private var _haveCountTemp:int;
      
      private var _num:int;
      
      private var _id:int;
      
      public function ExchangeGoodsCell(param1:GiftRewardInfo, param2:int = -1, param3:Boolean = true, param4:int = -1, param5:int = 1)
      {
         var _loc6_:ItemTemplateInfo = null;
         var _loc7_:InventoryItemInfo = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         this.intEvent();
         this._gooodsExchangeInfo = param1;
         this._type = param3;
         this._id = param4;
         this._num = param5;
         if(Boolean(param1) && (param2 == 3 || param2 == 4))
         {
            if(param2 == 4)
            {
               if(this._type)
               {
                  _bg = ComponentFactory.Instance.creatBitmap("asset.activity.wordBg");
               }
               else
               {
                  _bg = ComponentFactory.Instance.creatBitmap("asset.activity.seedBg");
               }
               _bg.alpha = 0;
            }
            else
            {
               _bg = ComponentFactory.Instance.creatBitmap("asset.activity.seedBg");
            }
         }
         else
         {
            _bg = ComponentFactory.Instance.creatBitmap("ddtcalendar.exchange.cellBg");
         }
         this._countText = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.cellCount");
         if(this._gooodsExchangeInfo == null)
         {
            _info = null;
            this._countText.text = "";
         }
         else
         {
            _loc6_ = ItemManager.Instance.getTemplateById(this._gooodsExchangeInfo.templateId);
            _loc7_ = new InventoryItemInfo();
            _loc7_.TemplateID = _loc6_.TemplateID;
            ItemManager.fill(_loc7_);
            _loc8_ = this._gooodsExchangeInfo.property.split(",");
            _loc7_._StrengthenLevel = parseInt(_loc8_[0]);
            _loc7_.AttackCompose = parseInt(_loc8_[1]);
            _loc7_.DefendCompose = parseInt(_loc8_[2]);
            _loc7_.AgilityCompose = parseInt(_loc8_[3]);
            _loc7_.LuckCompose = parseInt(_loc8_[4]);
            _loc7_.IsBinds = true;
            _loc7_.isShowBind = this._type != true;
            _info = _loc7_;
            if(this._type)
            {
               _loc9_ = param1.templateId;
               if(_loc7_.CanStrengthen)
               {
                  this._haveCount = PlayerManager.Instance.Self.findItemCount(_loc9_,_loc7_._StrengthenLevel);
               }
               else
               {
                  this._haveCount = PlayerManager.Instance.Self.findItemCount(_loc9_);
               }
               if(this._haveCount == 0)
               {
                  this._haveCount = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(_loc9_);
               }
               this._countText.text = this._haveCount.toString() + "/" + (this._gooodsExchangeInfo.count * this._num).toString();
            }
            else
            {
               this._countText.text = (this._gooodsExchangeInfo.count * this._num).toString();
            }
         }
         this._haveCountTemp = this._haveCount;
         super(_bg,_info);
         addChild(this._countText);
      }
      
      public function get itemInfo() : InventoryItemInfo
      {
         var _loc1_:Array = PlayerManager.Instance.Self.Bag.findItemsByTempleteID(this._gooodsExchangeInfo.templateId);
         if(_loc1_.length == 0)
         {
            _loc1_ = PlayerManager.Instance.Self.PropBag.findItemsByTempleteID(this._gooodsExchangeInfo.templateId);
         }
         return _loc1_[0];
      }
      
      private function intEvent() : void
      {
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.__updateCount);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.__updateCount);
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.AFTERDEL,this.__updateCount);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.AFTERDEL,this.__updateCount);
      }
      
      private function __updateCount(param1:BagEvent) : void
      {
         var _loc2_:ActivityEvent = null;
         if(!this._gooodsExchangeInfo)
         {
            return;
         }
         var _loc3_:int = this._gooodsExchangeInfo.templateId;
         var _loc4_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(this._gooodsExchangeInfo.templateId);
         var _loc5_:InventoryItemInfo = new InventoryItemInfo();
         _loc5_.TemplateID = _loc4_.TemplateID;
         ItemManager.fill(_loc5_);
         var _loc6_:Array = this._gooodsExchangeInfo.property.split(",");
         _loc5_._StrengthenLevel = parseInt(_loc6_[0]);
         _loc5_.AttackCompose = parseInt(_loc6_[1]);
         _loc5_.DefendCompose = parseInt(_loc6_[2]);
         _loc5_.AgilityCompose = parseInt(_loc6_[3]);
         _loc5_.LuckCompose = parseInt(_loc6_[4]);
         _loc5_.IsBinds = true;
         _loc5_.isShowBind = this._type != true;
         if(_loc5_.CanStrengthen)
         {
            this._haveCount = PlayerManager.Instance.Self.findItemCount(_loc3_,_loc5_.StrengthenLevel);
         }
         else
         {
            this._haveCount = PlayerManager.Instance.Self.findItemCount(_loc3_);
         }
         if(this._haveCount == 0)
         {
            this._haveCount = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(_loc3_);
         }
         if(!this._countText)
         {
            this._countText = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.cellCount");
            addChild(this._countText);
         }
         if(this._haveCountTemp != this._haveCount)
         {
            this._haveCountTemp = this._haveCount;
            _loc2_ = new ActivityEvent(ActivityEvent.UPDATE_COUNT);
            _loc2_.id = this._id;
            dispatchEvent(_loc2_);
         }
         if(this._type)
         {
            this._countText.text = this._haveCount.toString() + "/" + (this._gooodsExchangeInfo.count * 1).toString();
         }
         else
         {
            this._countText.text = (this._gooodsExchangeInfo.count * 1).toString();
         }
      }
      
      public function get haveCount() : int
      {
         return this._haveCount;
      }
      
      public function get needCount() : int
      {
         return this._needCount = int(this.haveCount / this._gooodsExchangeInfo.count);
      }
      
      override public function dispose() : void
      {
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.__updateCount);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.__updateCount);
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.AFTERDEL,this.__updateCount);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.AFTERDEL,this.__updateCount);
         super.dispose();
         if(Boolean(this._countText))
         {
            ObjectUtils.disposeObject(this._countText);
         }
         this._countText = null;
      }
   }
}
