package GodSyah
{
   public class SyahMode
   {
       
      
      private var _syahID:int;
      
      private var _attack:int;
      
      private var _defense:int;
      
      private var _agility:int;
      
      private var _lucky:int;
      
      private var _hp:int;
      
      private var _armor:int;
      
      private var _damage:int;
      
      private var _isHold:Boolean;
      
      private var _isValid:Boolean;
      
      private var _level:int;
      
      private var _isGold:Boolean;
      
      private var _valid:String;
      
      public function SyahMode()
      {
         super();
      }
      
      public function get attack() : int
      {
         return this._attack;
      }
      
      public function set attack(param1:int) : void
      {
         this._attack = param1;
      }
      
      public function get defense() : int
      {
         return this._defense;
      }
      
      public function set defense(param1:int) : void
      {
         this._defense = param1;
      }
      
      public function get agility() : int
      {
         return this._agility;
      }
      
      public function set agility(param1:int) : void
      {
         this._agility = param1;
      }
      
      public function get lucky() : int
      {
         return this._lucky;
      }
      
      public function set lucky(param1:int) : void
      {
         this._lucky = param1;
      }
      
      public function get hp() : int
      {
         return this._hp;
      }
      
      public function set hp(param1:int) : void
      {
         this._hp = param1;
      }
      
      public function get armor() : int
      {
         return this._armor;
      }
      
      public function set armor(param1:int) : void
      {
         this._armor = param1;
      }
      
      public function get damage() : int
      {
         return this._damage;
      }
      
      public function set damage(param1:int) : void
      {
         this._damage = param1;
      }
      
      public function get isHold() : Boolean
      {
         return this._isHold;
      }
      
      public function set isHold(param1:Boolean) : void
      {
         this._isHold = param1;
      }
      
      public function get syahID() : int
      {
         return this._syahID;
      }
      
      public function set syahID(param1:int) : void
      {
         this._syahID = param1;
      }
      
      public function get isValid() : Boolean
      {
         return this._isValid;
      }
      
      public function set isValid(param1:Boolean) : void
      {
         this._isValid = param1;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function set level(param1:int) : void
      {
         this._level = param1;
      }
      
      public function get isGold() : Boolean
      {
         return this._isGold;
      }
      
      public function set isGold(param1:Boolean) : void
      {
         this._isGold = param1;
      }
      
      public function get valid() : String
      {
         return this._valid;
      }
      
      public function set valid(param1:String) : void
      {
         this._valid = param1;
      }
   }
}
