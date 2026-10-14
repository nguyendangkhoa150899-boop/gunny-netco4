package latentEnergy
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.TimeManager;
   import ddt.view.tips.GoodTip;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   
   public class LatentEnergyPreTip extends GoodTip
   {
       
      
      private var _rightArrow:Bitmap;
      
      private var _laterGoodTip:GoodTip;
      
      public function LatentEnergyPreTip()
      {
         super();
      }
      
      override public function set tipData(param1:Object) : void
      {
         super.tipData = param1;
         if(!param1)
         {
            return;
         }
         var _loc2_:GoodTipInfo = this.getPreGoodTipInfo(param1 as GoodTipInfo);
         if(!_loc2_)
         {
            return;
         }
         if(!this._rightArrow)
         {
            this._rightArrow = ComponentFactory.Instance.creatBitmap("asset.ddtstore.rightArrows");
            this._rightArrow.x = this.width - 10;
            this._rightArrow.y = (this.height - this._rightArrow.height) / 2;
         }
         if(!this._laterGoodTip)
         {
            this._laterGoodTip = new GoodTip();
            this._laterGoodTip.x = _tipbackgound.x + _tipbackgound.width + 35;
         }
         addChild(this._laterGoodTip);
         this._laterGoodTip.tipData = _loc2_;
         addChild(this._rightArrow);
         _width = this._laterGoodTip.x + this._laterGoodTip.width;
         _height = this._laterGoodTip.height;
      }
      
      protected function getPreGoodTipInfo(param1:GoodTipInfo) : GoodTipInfo
      {
         var _loc2_:Date = null;
         var _loc3_:InventoryItemInfo = param1.itemInfo as InventoryItemInfo;
         var _loc4_:GoodTipInfo = new GoodTipInfo();
         var _loc5_:InventoryItemInfo = new InventoryItemInfo();
         ObjectUtils.copyProperties(_loc5_,_loc3_);
         _loc5_.gemstoneList = _loc3_.gemstoneList;
         _loc5_.IsBinds = true;
         var _loc6_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(param1.latentEnergyItemId);
         if(!_loc6_)
         {
            return null;
         }
         var _loc7_:String = _loc6_.Property3;
         _loc5_.latentEnergyCurStr = _loc7_ + "," + _loc7_ + "," + _loc7_ + "," + _loc7_;
         if(_loc3_.isHasLatentEnergy)
         {
            _loc5_.latentEnergyEndTime = _loc3_.latentEnergyEndTime;
         }
         else
         {
            _loc2_ = new Date(TimeManager.Instance.Now().getTime() + int(_loc6_.Property4) * TimeManager.DAY_TICKS - TimeManager.HOUR_TICKS);
            _loc5_.latentEnergyEndTime = _loc2_;
         }
         _loc4_.itemInfo = _loc5_;
         return _loc4_;
      }
   }
}
