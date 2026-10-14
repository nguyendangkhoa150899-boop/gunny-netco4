package store.view.strength.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import store.view.strength.vo.ItemStrengthenGoodsInfo;
   
   public class ItemStrengthenGoodsInfoAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Dictionary;
      
      private var _xml:XML;
      
      public function ItemStrengthenGoodsInfoAnalyzer(param1:Function)
      {
         this.list = new Dictionary();
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ItemStrengthenGoodsInfo = null;
         this._xml = new XML(param1);
         this.list = new Dictionary();
         var _loc4_:XMLList = this._xml..Item;
         if(this._xml.@value == "true")
         {
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length())
            {
               _loc3_ = new ItemStrengthenGoodsInfo();
               ObjectUtils.copyPorpertiesByXML(_loc3_,_loc4_[_loc2_]);
               this.list[_loc3_.CurrentEquip + "," + _loc3_.Level] = _loc3_;
               _loc2_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
