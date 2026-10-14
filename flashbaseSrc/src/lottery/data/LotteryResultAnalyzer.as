package lottery.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import road7th.utils.StringHelper;
   
   public class LotteryResultAnalyzer extends DataAnalyzer
   {
       
      
      public var lotteryResultList:Vector.<lottery.data.LotteryCardResultVO>;
      
      public function LotteryResultAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:lottery.data.LotteryCardResultVO = null;
         var _loc5_:XMLList = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         this.lotteryResultList = new Vector.<LotteryCardResultVO>();
         var _loc8_:XML = new XML(param1);
         if(_loc8_.@value == "true")
         {
            _loc2_ = _loc8_.WealthDivine;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new lottery.data.LotteryCardResultVO();
               _loc4_.resultIds = this.analyzeNumber(String(_loc2_[_loc3_].@num));
               if(Boolean(_loc8_.page[_loc3_]))
               {
                  _loc5_ = _loc8_.page[_loc3_].PlayerDivineNum;
                  _loc6_ = new Array();
                  _loc7_ = 0;
                  while(_loc7_ < _loc5_.length())
                  {
                     _loc6_ = _loc6_.concat(this.analyzeNumber(String(_loc5_[_loc7_].@num)));
                     _loc7_++;
                  }
                  _loc4_.selfChooseIds = _loc6_;
                  this.lotteryResultList.push(_loc4_);
               }
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc8_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      private function analyzeNumber(param1:String) : Array
      {
         if(StringHelper.isNullOrEmpty(param1))
         {
            return [];
         }
         var _loc2_:Array = param1.split(",");
         if(_loc2_.indexOf(0) > -1 || _loc2_.indexOf("0") > -1)
         {
            return [];
         }
         return _loc2_;
      }
   }
}
