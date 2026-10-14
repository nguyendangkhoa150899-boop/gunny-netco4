package explorerManual.data.model
{
   public class ManualUpgradeInfo
   {
       
      
      private var _manualLevel:int;
      
      private var _describe:String;
      
      private var _conditionType:int;
      
      private var _parameter1:int;
      
      private var _parameter2:int;
      
      private var _parameter3:int;
      
      public function ManualUpgradeInfo()
      {
         super();
      }
      
      public function get Parameter3() : int
      {
         return this._parameter3;
      }
      
      public function set Parameter3(param1:int) : void
      {
         this._parameter3 = param1;
      }
      
      public function get Parameter2() : int
      {
         return this._parameter2;
      }
      
      public function set Parameter2(param1:int) : void
      {
         this._parameter2 = param1;
      }
      
      public function get Parameter1() : int
      {
         return this._parameter1;
      }
      
      public function set Parameter1(param1:int) : void
      {
         this._parameter1 = param1;
      }
      
      public function get ConditionType() : int
      {
         return this._conditionType;
      }
      
      public function set ConditionType(param1:int) : void
      {
         this._conditionType = param1;
      }
      
      public function get Describe() : String
      {
         return this._describe;
      }
      
      public function set Describe(param1:String) : void
      {
         this._describe = param1;
      }
      
      public function get ManualLevel() : int
      {
         return this._manualLevel;
      }
      
      public function set ManualLevel(param1:int) : void
      {
         this._manualLevel = param1;
      }
   }
}
