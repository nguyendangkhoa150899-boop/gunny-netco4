package auctionHouse.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   
   public class AuctionAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Vector.<AuctionGoodsInfo>;
      
      public var total:int;
      
      public function AuctionAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:AuctionGoodsInfo = null;
         var _loc4_:XMLList = null;
         var _loc5_:InventoryItemInfo = null;
         this.list = new Vector.<AuctionGoodsInfo>();
         var _loc6_:XML = new XML(param1);
         var _loc7_:XMLList = _loc6_.Item;
         this.total = _loc6_.@total;
         if(_loc6_.@value == "true")
         {
            _loc2_ = 0;
            while(_loc2_ < _loc7_.length())
            {
               _loc3_ = new AuctionGoodsInfo();
               ObjectUtils.copyPorpertiesByXML(_loc3_,_loc7_[_loc2_]);
               _loc4_ = _loc7_[_loc2_].Item;
               if(_loc4_.length() > 0)
               {
                  _loc5_ = new InventoryItemInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc5_,_loc4_[0]);
                  ItemManager.fill(_loc5_);
                  _loc3_.BagItemInfo = _loc5_;
                  this.list.push(_loc3_);
               }
               _loc2_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc6_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
