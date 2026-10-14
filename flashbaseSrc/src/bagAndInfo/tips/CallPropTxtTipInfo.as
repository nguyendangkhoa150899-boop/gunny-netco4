package bagAndInfo.tips
{
   public class CallPropTxtTipInfo
   {
       
      
      private var _atcAdd:int = 0;
      
      private var _defAdd:int = 0;
      
      private var _agiAdd:int = 0;
      
      private var _lukAdd:int = 0;
      
      private var _rank:String = "";
      
      public function CallPropTxtTipInfo()
      {
         super();
      }
      
      public function get Attack() : int
      {
         return this._atcAdd;
      }
      
      public function set Attack(param1:int) : void
      {
         this._atcAdd = param1;
      }
      
      public function get Defend() : int
      {
         return this._defAdd;
      }
      
      public function set Defend(param1:int) : void
      {
         this._defAdd = param1;
      }
      
      public function get Agility() : int
      {
         return this._agiAdd;
      }
      
      public function set Agility(param1:int) : void
      {
         this._agiAdd = param1;
      }
      
      public function get Lucky() : int
      {
         return this._lukAdd;
      }
      
      public function set Lucky(param1:int) : void
      {
         this._lukAdd = param1;
      }
      
      public function get Rank() : String
      {
         return this._rank;
      }
      
      public function set Rank(param1:String) : void
      {
         this._rank = param1;
      }
   }
}
