package ddt.data.analyze
{
   import calendar.view.goodsExchange.GoodsExchangeInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class ActiveExchangeAnalyzer extends DataAnalyzer
   {
       
      
      private var _list:Array;
      
      private var _xml:XML;
      
      public function ActiveExchangeAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:GoodsExchangeInfo = null;
         this._xml = new XML(param1);
         this._list = new Array();
         var _loc4_:XMLList = this._xml..Item;
         if(this._xml.@value == "true")
         {
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length())
            {
               _loc3_ = new GoodsExchangeInfo();
               ObjectUtils.copyPorpertiesByXML(_loc3_,_loc4_[_loc2_]);
               this._list.push(_loc3_);
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
      
      public function get list() : Array
      {
         return this._list.slice(0);
      }
   }
}
