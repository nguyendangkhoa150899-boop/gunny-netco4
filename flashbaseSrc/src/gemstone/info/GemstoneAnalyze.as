package gemstone.info
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class GemstoneAnalyze extends DataAnalyzer
   {
       
      
      public var gInfoList:Vector.<gemstone.info.GemstoneStaticInfo>;
      
      public function GemstoneAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:gemstone.info.GemstoneStaticInfo = null;
         this.gInfoList = new Vector.<GemstoneStaticInfo>();
         var _loc3_:XML = new XML(param1);
         var _loc4_:int = _loc3_.item.length();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = new gemstone.info.GemstoneStaticInfo();
            _loc2_.fightSpiritIcon = _loc3_.item.@FightSpiritID;
            _loc2_.fightSpiritIcon = _loc3_.item.@FightSpiritIcon;
            _loc2_.agility = _loc3_.item.@agility;
            _loc2_.level = _loc3_.item.@level;
            _loc2_.luck = _loc3_.item.@luck;
            _loc2_.Exp = _loc3_.item.@Exp;
            _loc2_.attack = _loc3_.item.@attack;
            _loc2_.defence = _loc3_.item.@defence;
            this.gInfoList.push(_loc2_);
            _loc5_++;
         }
      }
   }
}
