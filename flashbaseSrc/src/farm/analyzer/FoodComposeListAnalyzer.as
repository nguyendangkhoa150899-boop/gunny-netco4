package farm.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import farm.view.compose.vo.FoodComposeListTemplateInfo;
   import flash.utils.Dictionary;
   
   public class FoodComposeListAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Dictionary;
      
      private var _listDetail:Vector.<FoodComposeListTemplateInfo>;
      
      public function FoodComposeListAnalyzer(param1:Function)
      {
         this.list = new Dictionary();
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:XML = null;
         var _loc4_:FoodComposeListTemplateInfo = null;
         var _loc5_:XML = XML(param1);
         var _loc6_:XMLList = _loc5_..Item;
         for each(_loc3_ in _loc6_)
         {
            _loc4_ = new FoodComposeListTemplateInfo();
            ObjectUtils.copyPorpertiesByXML(_loc4_,_loc3_);
            if(_loc2_ != _loc4_.FoodID)
            {
               _loc2_ = _loc4_.FoodID;
               this._listDetail = new Vector.<FoodComposeListTemplateInfo>();
               this._listDetail.push(_loc4_);
            }
            else if(_loc2_ == _loc4_.FoodID)
            {
               this._listDetail.push(_loc4_);
            }
            this.list[_loc2_] = this._listDetail;
         }
         onAnalyzeComplete();
      }
   }
}
