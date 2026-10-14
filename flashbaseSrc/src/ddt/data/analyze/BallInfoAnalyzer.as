package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BallInfo;
   
   public class BallInfoAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Vector.<BallInfo>;
      
      public function BallInfoAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:BallInfo = null;
         var _loc5_:XML = new XML(param1);
         this.list = new Vector.<BallInfo>();
         if(_loc5_.@value == "true")
         {
            _loc2_ = _loc5_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new BallInfo();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               _loc4_.blastOutID = _loc2_[_loc3_].@BombPartical;
               _loc4_.craterID = _loc2_[_loc3_].@Crater;
               _loc4_.FlyingPartical = _loc2_[_loc3_].@FlyingPartical;
               this.list.push(_loc4_);
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc5_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
