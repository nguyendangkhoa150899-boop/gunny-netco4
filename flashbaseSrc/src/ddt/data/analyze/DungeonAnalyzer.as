package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.map.DungeonInfo;
   
   public class DungeonAnalyzer extends DataAnalyzer
   {
      
      private static const PATH:String = "LoadPVEItems.xml";
       
      
      public var list:Vector.<DungeonInfo>;
      
      public function DungeonAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:DungeonInfo = null;
         var _loc5_:XML = new XML(param1);
         if(_loc5_.@value == "true")
         {
            this.list = new Vector.<DungeonInfo>();
            _loc2_ = _loc5_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new DungeonInfo();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               if(_loc4_.Name != "")
               {
                  this.list.push(_loc4_);
               }
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
