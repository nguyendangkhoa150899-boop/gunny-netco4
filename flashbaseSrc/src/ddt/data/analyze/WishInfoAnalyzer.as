package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import store.forge.wishBead.WishChangeInfo;
   
   public class WishInfoAnalyzer extends DataAnalyzer
   {
       
      
      public var _wishChangeInfo:Vector.<WishChangeInfo>;
      
      public function WishInfoAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:WishChangeInfo = null;
         var _loc4_:XML = new XML(param1);
         var _loc5_:XMLList = _loc4_..item;
         this._wishChangeInfo = new Vector.<WishChangeInfo>();
         if(_loc4_.@value == "true")
         {
            _loc2_ = 0;
            while(_loc2_ < _loc5_.length())
            {
               _loc3_ = new WishChangeInfo();
               ObjectUtils.copyPorpertiesByXML(_loc3_,_loc5_[_loc2_]);
               this._wishChangeInfo.push(_loc3_);
               _loc2_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc4_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
