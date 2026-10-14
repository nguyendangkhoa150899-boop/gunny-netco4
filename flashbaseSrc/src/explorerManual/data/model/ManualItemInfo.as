package explorerManual.data.model
{
   public class ManualItemInfo
   {
       
      
      private var _level:int;
      
      private var _name:String;
      
      private var _describe:String;
      
      private var _magicAttack:int;
      
      private var _magicResistance:int;
      
      private var _Boost:int;
      
      public function ManualItemInfo()
      {
         super();
      }
      
      public function get Boost() : int
      {
         return this._Boost;
      }
      
      public function set Boost(param1:int) : void
      {
         this._Boost = param1;
      }
      
      public function get MagicResistance() : int
      {
         return this._magicResistance;
      }
      
      public function set MagicResistance(param1:int) : void
      {
         this._magicResistance = param1;
      }
      
      public function get MagicAttack() : int
      {
         return this._magicAttack;
      }
      
      public function set MagicAttack(param1:int) : void
      {
         this._magicAttack = param1;
      }
      
      public function get Describe() : String
      {
         return this._describe;
      }
      
      public function set Describe(param1:String) : void
      {
         this._describe = param1;
      }
      
      public function get Name() : String
      {
         return this._name;
      }
      
      public function set Name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get Level() : int
      {
         return this._level;
      }
      
      public function set Level(param1:int) : void
      {
         this._level = param1;
      }
   }
}
