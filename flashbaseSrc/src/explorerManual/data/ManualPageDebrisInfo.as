package explorerManual.data
{
   import explorerManual.ExplorerManualManager;
   
   public class ManualPageDebrisInfo
   {
       
      
      private var _debris:Vector.<explorerManual.data.DebrisInfo>;
      
      public function ManualPageDebrisInfo()
      {
         super();
         this._debris = new Vector.<DebrisInfo>();
      }
      
      public function get debris() : Vector.<explorerManual.data.DebrisInfo>
      {
         return this._debris;
      }
      
      public function set debris(param1:Vector.<explorerManual.data.DebrisInfo>) : void
      {
         this._debris = param1;
      }
      
      public function getHaveDebrisByPageID(param1:int) : Array
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = [];
         var _loc6_:Array = ExplorerManualManager.instance.getDebrisByPageID(param1);
         var _loc7_:Vector.<explorerManual.data.DebrisInfo> = this.debris.sort(this.debrisSort);
         _loc3_ = 0;
         while(_loc3_ < _loc7_.length)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc6_.length)
            {
               if(_loc6_[_loc4_].ID == _loc7_[_loc3_].debrisID)
               {
                  _loc5_.push(_loc6_[_loc4_]);
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return _loc5_;
      }
      
      private function debrisSort(param1:explorerManual.data.DebrisInfo, param2:explorerManual.data.DebrisInfo) : Number
      {
         if(param1.date.getTime() < param2.date.getTime())
         {
            return -1;
         }
         if(param1.date.getTime() > param2.date.getTime())
         {
            return 1;
         }
         return 0;
      }
   }
}
