package pet.date
{
   import com.pickgliss.loader.ModuleLoader;
   import ddt.manager.ServerConfigManager;
   import flash.events.Event;
   import road7th.data.DictionaryData;
   
   public class PetInfo extends PetTemplateInfo
   {
      
      public static const HUNGER_CHANGED:String = "hunger";
      
      public static const GP_CHANGED:String = "gp";
      
      public static const FULL_MAX_VALUE:int = 10000;
       
      
      public var ID:int;
      
      public var UserID:int;
      
      public var equipList:DictionaryData;
      
      private var _skills:DictionaryData;
      
      private var _equipedSkills:DictionaryData;
      
      public var Attack:int;
      
      public var Defence:int;
      
      public var Luck:int;
      
      public var Agility:int;
      
      public var Blood:int;
      
      public var Damage:int;
      
      public var Guard:int;
      
      public var AttackGrow:int;
      
      public var DefenceGrow:int;
      
      public var LuckGrow:int;
      
      public var AgilityGrow:int;
      
      public var BloodGrow:int;
      
      public var DamageGrow:int;
      
      public var GuardGrow:int;
      
      public var currentStarExp:int;
      
      public var Level:int;
      
      private var _gp:int;
      
      public var MaxGP:int;
      
      private var _hunger:int;
      
      public var MaxActiveSkillCount:int;
      
      public var MaxStaticSkillCount:int;
      
      public var MaxSkillCount:int;
      
      public var PaySkillCount:int;
      
      public var Place:int;
      
      public var FightPower:int = 100;
      
      public var IsEquip:Boolean;
      
      public var PetHappyStar:int;
      
      public function PetInfo()
      {
         super();
         this.equipList = new DictionaryData();
         this._skills = new DictionaryData();
         this._equipedSkills = new DictionaryData();
      }
      
      public function get equipdSkills() : DictionaryData
      {
         return this._equipedSkills;
      }
      
      public function set GP(param1:int) : void
      {
         if(this._gp == param1)
         {
            return;
         }
         this._gp = param1;
         dispatchEvent(new Event(GP_CHANGED));
      }
      
      public function get GP() : int
      {
         return this._gp;
      }
      
      public function set Hunger(param1:int) : void
      {
         if(param1 == this._hunger)
         {
            return;
         }
         this._hunger = param1;
         dispatchEvent(new Event(HUNGER_CHANGED));
      }
      
      public function get Hunger() : int
      {
         return this._hunger;
      }
      
      public function get skills() : Array
      {
         return this._skills.list.concat();
      }
      
      public function addSkill(param1:PetSkill) : void
      {
         this._skills.add(param1.ID,param1);
      }
      
      public function clearSkills() : void
      {
         this._skills.clear();
      }
      
      public function clearEquipedSkills() : void
      {
         this._equipedSkills.clear();
      }
      
      public function removeSkillByID(param1:int) : void
      {
         this._skills.remove(param1);
      }
      
      public function hasSkill(param1:int) : Boolean
      {
         return Boolean(this._skills[param1]);
      }
      
      public function get actionMovieName() : String
      {
         return "pet.asset.game." + GameAssetUrl;
      }
      
      public function get assetReady() : Boolean
      {
         return ModuleLoader.hasDefinition(this.actionMovieName);
      }
      
      public function getPetQualityIndex(param1:Number) : int
      {
         var _loc2_:int = 0;
         var _loc3_:Array = ServerConfigManager.instance.petQualityConfig;
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            if(param1 <= _loc3_[_loc2_])
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return _loc3_.length - 1;
      }
      
      public function get BloodGrowDatum() : int
      {
         return int(Number((this.BloodGrow - LowBloodGrow) * 100) / Number(HighBloodGrow - LowBloodGrow));
      }
      
      public function get AttackGrowDatum() : int
      {
         return int(Number((this.AttackGrow - LowAttackGrow) * 100) / Number(HighAttackGrow - LowAttackGrow));
      }
      
      public function get DefenceGrowDatum() : int
      {
         return int(Number((this.DefenceGrow - LowDefenceGrow) * 100) / Number(HighDefenceGrow - LowDefenceGrow));
      }
      
      public function get AgilityGrowDatum() : int
      {
         return int(Number((this.AgilityGrow - LowAgilityGrow) * 100) / Number(HighAgilityGrow - LowAgilityGrow));
      }
      
      public function get LuckGrowDatum() : int
      {
         return int(Number((this.LuckGrow - LowLuckGrow) * 100) / Number(HighLuckGrow - LowLuckGrow));
      }
      
      public function get petGraded() : Number
      {
         var _loc1_:Number = Number((this.BloodGrow - LowBloodGrow) * 100) / Number(HighBloodGrow - LowBloodGrow);
         var _loc2_:Number = Number((this.AttackGrow - LowAttackGrow) * 100) / Number(HighAttackGrow - LowAttackGrow);
         var _loc3_:Number = Number((this.DefenceGrow - LowDefenceGrow) * 100) / Number(HighDefenceGrow - LowDefenceGrow);
         var _loc4_:Number = Number((this.AgilityGrow - LowAgilityGrow) * 100) / Number(HighAgilityGrow - LowAgilityGrow);
         var _loc5_:Number = Number((this.LuckGrow - LowLuckGrow) * 100) / Number(HighLuckGrow - LowLuckGrow);
         return (_loc1_ + _loc2_ + _loc3_ + _loc4_ + _loc5_) / 5;
      }
   }
}
