package farm.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import farm.modelx.FramFriendStateInfo;
   import farm.modelx.SimpleLandStateInfo;
   import road7th.data.DictionaryData;
   import road7th.utils.DateUtils;
   
   public class FarmFriendListAnalyzer extends DataAnalyzer
   {
       
      
      public var list:DictionaryData;
      
      public function FarmFriendListAnalyzer(param1:Function)
      {
         this.list = new DictionaryData();
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XML = null;
         var _loc3_:FramFriendStateInfo = null;
         var _loc4_:Vector.<SimpleLandStateInfo> = null;
         var _loc5_:XMLList = null;
         var _loc6_:XML = null;
         var _loc7_:SimpleLandStateInfo = null;
         var _loc8_:XML = XML(param1);
         var _loc9_:XMLList = _loc8_.Item;
         for each(_loc2_ in _loc9_)
         {
            _loc3_ = new FramFriendStateInfo();
            _loc3_.id = _loc2_.@UserID;
            _loc4_ = new Vector.<SimpleLandStateInfo>();
            _loc5_ = _loc2_.Item;
            for each(_loc6_ in _loc5_)
            {
               _loc7_ = new SimpleLandStateInfo();
               _loc7_.seedId = _loc6_.@SeedID;
               _loc7_.AccelerateDate = _loc6_.@AcclerateDate;
               _loc7_.plantTime = DateUtils.decodeDated(_loc6_.@GrowTime);
               _loc7_.isStolen = _loc6_.@IsCanStolen == "true" ? Boolean(true) : Boolean(false);
               _loc4_.push(_loc7_);
            }
            _loc3_.setLandStateVec = _loc4_;
            this.list.add(_loc3_.id,_loc3_);
         }
         onAnalyzeComplete();
      }
   }
}
