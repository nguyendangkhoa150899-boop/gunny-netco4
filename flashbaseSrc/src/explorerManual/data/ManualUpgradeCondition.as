package explorerManual.data
{
   import explorerManual.data.model.ManualUpgradeInfo;
   
   public class ManualUpgradeCondition extends UpgradeConditonBase
   {
       
      
      public function ManualUpgradeCondition()
      {
         super();
      }
      
      override public function get materialCondition() : ManualUpgradeInfo
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         if(_conditions == null)
         {
            return null;
         }
         _loc2_ = 0;
         while(_loc2_ < _conditions.length)
         {
            if(_conditions[_loc2_].ConditionType == 1)
            {
               _loc1_ = _conditions[_loc2_];
               break;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      override public function get upgradeCondition() : ManualUpgradeInfo
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         if(_conditions == null)
         {
            return null;
         }
         _loc2_ = 0;
         while(_loc2_ < _conditions.length)
         {
            if(_conditions[_loc2_].ConditionType != 1)
            {
               _loc1_ = _conditions[_loc2_];
               break;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      override public function get targetCount() : int
      {
         var _loc1_:int = 0;
         var _loc2_:ManualUpgradeInfo = this.upgradeCondition;
         if(_loc2_ == null)
         {
            return 0;
         }
         switch(int(_loc2_.ConditionType) - 2)
         {
            case 0:
            case 5:
            case 6:
               _loc1_ = _loc2_.Parameter1;
               break;
            case 1:
            case 3:
               _loc1_ = _loc2_.Parameter2;
               break;
            case 2:
            case 4:
               _loc1_ = 1;
         }
         return _loc1_;
      }
   }
}
