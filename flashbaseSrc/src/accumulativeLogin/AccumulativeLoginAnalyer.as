package accumulativeLogin
{
   import accumulativeLogin.data.AccumulativeLoginRewardData;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   
   public class AccumulativeLoginAnalyer extends DataAnalyzer
   {
       
      
      private var _accumulativeloginDataDic:Dictionary;
      
      public function AccumulativeLoginAnalyer(param1:Function)
      {
         super(param1);
         this._accumulativeloginDataDic = new Dictionary();
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:AccumulativeLoginRewardData = null;
         var _loc6_:AccumulativeLoginRewardData = null;
         var _loc7_:XML = new XML(param1);
         if(_loc7_.@value == "true")
         {
            _loc2_ = _loc7_..Item;
            _loc3_ = new Array();
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length())
            {
               _loc6_ = new AccumulativeLoginRewardData();
               ObjectUtils.copyPorpertiesByXML(_loc6_,_loc2_[_loc4_]);
               _loc3_.push(_loc6_);
               _loc4_++;
            }
            for each(_loc5_ in _loc3_)
            {
               if(!this._accumulativeloginDataDic[_loc5_.Count])
               {
                  this._accumulativeloginDataDic[_loc5_.Count] = new Array();
               }
               this._accumulativeloginDataDic[_loc5_.Count].push(_loc5_);
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc7_.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function get accumulativeloginDataDic() : Dictionary
      {
         return this._accumulativeloginDataDic;
      }
   }
}
