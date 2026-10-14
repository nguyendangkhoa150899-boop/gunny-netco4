package cardSystem.analyze
{
   import cardSystem.data.CardPropIncreaseInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import road7th.data.DictionaryData;
   
   public class CardPropIncreaseRuleAnalyzer extends DataAnalyzer
   {
       
      
      private var _levelIncre:DictionaryData;
      
      public var propIncreaseDic:DictionaryData;
      
      public function CardPropIncreaseRuleAnalyzer(param1:Function)
      {
         super(param1);
         this.propIncreaseDic = new DictionaryData();
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:CardPropIncreaseInfo = null;
         var _loc5_:String = null;
         var _loc6_:XML = new XML(param1);
         if(_loc6_.@value == "true")
         {
            _loc2_ = _loc6_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new CardPropIncreaseInfo();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               _loc5_ = _loc2_[_loc3_].@Id;
               if(this.propIncreaseDic[_loc5_] == null)
               {
                  this.propIncreaseDic[_loc5_] = new DictionaryData();
                  this.propIncreaseDic[_loc5_].add(_loc4_.Level,_loc4_);
               }
               else
               {
                  this.propIncreaseDic[_loc5_].add(_loc4_.Level,_loc4_);
               }
               _loc3_++;
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
