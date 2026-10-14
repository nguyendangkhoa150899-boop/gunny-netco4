package explorerManual.data
{
   import explorerManual.data.model.ManualItemInfo;
   
   public class ManualLevelProInfo
   {
       
      
      public var name:String;
      
      public var magicAttack:int;
      
      public var magicResistance:int;
      
      private var _boost:int;
      
      public function ManualLevelProInfo()
      {
         super();
      }
      
      public function get boost() : int
      {
         return this._boost;
      }
      
      public function set boost(param1:int) : void
      {
         this._boost = param1;
      }
      
      public function update(param1:ManualItemInfo) : void
      {
         this.magicAttack = param1.MagicAttack;
         this.magicResistance = param1.MagicResistance;
         this.boost = param1.Boost;
         this.name = param1.Name;
      }
   }
}
