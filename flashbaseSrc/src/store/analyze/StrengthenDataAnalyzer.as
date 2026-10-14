package store.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import flash.utils.Dictionary;
   
   public class StrengthenDataAnalyzer extends DataAnalyzer
   {
       
      
      public var _strengthData:Vector.<Dictionary>;
      
      private var _xml:XML;
      
      public function StrengthenDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         this._xml = new XML(param1);
         this.initData();
         var _loc6_:XMLList = this._xml.Item;
         if(this._xml.@value == "true")
         {
            _loc2_ = 0;
            while(_loc2_ < _loc6_.length())
            {
               _loc3_ = int(_loc6_[_loc2_].@TemplateID);
               _loc4_ = int(_loc6_[_loc2_].@StrengthenLevel);
               _loc5_ = int(_loc6_[_loc2_].@Data);
               this._strengthData[_loc4_][_loc3_] = _loc5_;
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
      
      private function initData() : void
      {
         var _loc1_:Dictionary = null;
         this._strengthData = new Vector.<Dictionary>();
         var _loc2_:int = 0;
         while(_loc2_ <= 12)
         {
            _loc1_ = new Dictionary();
            this._strengthData.push(_loc1_);
            _loc2_++;
         }
      }
   }
}
