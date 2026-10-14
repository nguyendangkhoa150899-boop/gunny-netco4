package wonderfulActivity.items
{
   import bagAndInfo.cell.BagCell;
   import com.greensock.TweenLite;
   import com.greensock.easing.Quad;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PetInfoManager;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import pet.date.PetTemplateInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   
   public class GiftBagItem extends Sprite implements Disposeable
   {
      
      public static const MOUSE_ON_GLOW_FILTER:Array = [new GlowFilter(16776960,1,8,8,2,2)];
       
      
      private var _type:int;
      
      private var _index:int;
      
      private var _bg:Bitmap;
      
      private var _giftBagIcon:Bitmap;
      
      private var _tipSprite:Component;
      
      private var _baseTip:GoodTipInfo;
      
      private var _cell:BagCell;
      
      public function GiftBagItem(param1:int, param2:int)
      {
         super();
         this._type = param1;
         this._index = param2 == 0 ? int(1) : int(param2);
         this.initView();
         this.addEvents();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("wonderful.accumulative.itemBG");
         addChild(this._bg);
      }
      
      private function initGiftView() : void
      {
         this._tipSprite = new Component();
         addChild(this._tipSprite);
         this._giftBagIcon = ComponentFactory.Instance.creat("wonderfulactivity.giftBag" + this._index);
         this._tipSprite.addChild(this._giftBagIcon);
         this._giftBagIcon.scaleX = 0.7;
         this._giftBagIcon.scaleY = 0.7;
         this._giftBagIcon.smoothing = true;
         this._baseTip = new GoodTipInfo();
         var _loc1_:ItemTemplateInfo = new ItemTemplateInfo();
         _loc1_.Quality = 4;
         _loc1_.CategoryID = 11;
         _loc1_.Name = this._type == 0 ? LanguageMgr.GetTranslation("returnActivity.rechargeGiftName") : LanguageMgr.GetTranslation("returnActivity.consumeGiftName");
         this._baseTip.itemInfo = _loc1_;
         this._tipSprite.width = this._giftBagIcon.width;
         this._tipSprite.height = this._giftBagIcon.height;
         this._tipSprite.tipStyle = "core.GoodsTip";
         this._tipSprite.tipDirctions = "7";
         this._tipSprite.tipData = this._baseTip;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(param1)
         {
            if(Boolean(this._giftBagIcon))
            {
               TweenLite.to(this._giftBagIcon,0.25,{
                  "x":-6,
                  "y":-5,
                  "scaleX":0.85,
                  "scaleY":0.85,
                  "ease":Quad.easeOut
               });
               this._giftBagIcon.filters = MOUSE_ON_GLOW_FILTER;
            }
            else
            {
               TweenLite.to(this._cell,0.25,{
                  "x":-2,
                  "y":-2,
                  "scaleX":0.85,
                  "scaleY":0.85,
                  "ease":Quad.easeOut
               });
               this._cell.filters = MOUSE_ON_GLOW_FILTER;
            }
         }
         else if(Boolean(this._giftBagIcon))
         {
            TweenLite.to(this._giftBagIcon,0.25,{
               "x":0,
               "y":0,
               "scaleX":0.7,
               "scaleY":0.7,
               "ease":Quad.easeOut
            });
            this._giftBagIcon.filters = null;
         }
         else
         {
            TweenLite.to(this._cell,0.25,{
               "x":3,
               "y":3,
               "scaleX":0.7,
               "scaleY":0.7,
               "ease":Quad.easeOut
            });
            this._cell.filters = null;
         }
      }
      
      public function setData(param1:Vector.<GiftRewardInfo>) : void
      {
         this.updateGiftView(param1);
      }
      
      private function updateGoodsView(param1:GiftRewardInfo) : void
      {
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         _loc2_.TemplateID = param1.templateId;
         _loc2_ = ItemManager.fill(_loc2_);
         _loc2_.ValidDate = param1.validDate;
         _loc2_.Count = param1.count;
         _loc2_.IsBinds = param1.isBind;
         var _loc3_:Shape = new Shape();
         _loc3_.graphics.beginFill(0,0);
         _loc3_.graphics.drawRect(0,0,66,66);
         _loc3_.graphics.endFill();
         this._cell = new BagCell(0,_loc2_,true,_loc3_,false);
         this._cell.y = 3;
         this._cell.x = 3;
         this._cell.setContentSize(66,66);
         this._cell.scaleX = 0.7;
         this._cell.scaleY = 0.7;
         addChild(this._cell);
      }
      
      private function updateGiftView(param1:Vector.<GiftRewardInfo>) : void
      {
         var _loc2_:GiftRewardInfo = null;
         var _loc3_:String = null;
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:PetTemplateInfo = null;
         this.initGiftView();
         var _loc6_:Vector.<GiftRewardInfo> = param1;
         this._baseTip.itemInfo.Description = "";
         var _loc7_:int = 0;
         while(_loc7_ <= _loc6_.length - 1)
         {
            _loc2_ = _loc6_[_loc7_];
            _loc3_ = "";
            _loc4_ = new InventoryItemInfo();
            _loc4_.TemplateID = _loc2_.templateId;
            _loc4_ = ItemManager.fill(_loc4_);
            if(EquipType.isPetEgg(_loc4_.CategoryID))
            {
               _loc5_ = PetInfoManager.getPetByTemplateID(parseInt(_loc4_.Property5));
               _loc3_ = LanguageMgr.GetTranslation("returnActivity.petTxt",_loc5_.StarLevel,_loc5_.Name);
            }
            else
            {
               _loc3_ = _loc4_.Name;
            }
            if(this._baseTip.itemInfo.Description != "")
            {
               this._baseTip.itemInfo.Description += "、";
            }
            this._baseTip.itemInfo.Description += _loc3_ + " x" + _loc2_.count;
            _loc7_++;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._giftBagIcon);
         this._giftBagIcon = null;
         ObjectUtils.disposeObject(this._tipSprite);
         this._tipSprite = null;
         ObjectUtils.disposeObject(this._cell);
         this._cell = null;
      }
      
      private function addEvents() : void
      {
      }
      
      private function removeEvents() : void
      {
      }
      
      public function get index() : int
      {
         return this._index;
      }
   }
}
