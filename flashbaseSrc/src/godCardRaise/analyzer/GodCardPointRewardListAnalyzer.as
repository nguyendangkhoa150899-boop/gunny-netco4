package godCardRaise.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import godCardRaise.info.GodCardPointRewardListInfo;
   
   public class GodCardPointRewardListAnalyzer extends DataAnalyzer
   {
       
      
      private var _list:Vector.<GodCardPointRewardListInfo>;
      
      public function GodCardPointRewardListAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:XML = new XML(param1);
         this._list = new Vector.<GodCardPointRewardListInfo>();
         if(_loc5_.@value == "true")
         {
            _loc2_ = _loc5_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new GodCardPointRewardListInfo();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               this._list.push(_loc4_);
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc5_.@message;
            onAnalyzeError();
         }
      }
      
      public function get list() : Vector.<GodCardPointRewardListInfo>
      {
         return this._list;
      }
   }
}
