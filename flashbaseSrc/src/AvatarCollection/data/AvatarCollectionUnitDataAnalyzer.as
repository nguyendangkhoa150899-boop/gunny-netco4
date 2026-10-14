package AvatarCollection.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import road7th.data.DictionaryData;
   
   public class AvatarCollectionUnitDataAnalyzer extends DataAnalyzer
   {
       
      
      private var _maleUnitDic:DictionaryData;
      
      private var _femaleUnitDic:DictionaryData;
      
      private var _weaponUnitDic:DictionaryData;
      
      public function AvatarCollectionUnitDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:XML = new XML(param1);
         this._maleUnitDic = new DictionaryData();
         this._femaleUnitDic = new DictionaryData();
         this._weaponUnitDic = new DictionaryData();
         if(_loc5_.@value == "true")
         {
            _loc2_ = _loc5_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new AvatarCollectionUnitVo();
               _loc4_.id = _loc2_[_loc3_].@ID;
               _loc4_.sex = _loc2_[_loc3_].@Sex;
               _loc4_.name = _loc2_[_loc3_].@Name;
               _loc4_.Attack = _loc2_[_loc3_].@Attack;
               _loc4_.Defence = _loc2_[_loc3_].@Defend;
               _loc4_.Agility = _loc2_[_loc3_].@Agility;
               _loc4_.Luck = _loc2_[_loc3_].@Luck;
               _loc4_.Damage = _loc2_[_loc3_].@Damage;
               _loc4_.Guard = _loc2_[_loc3_].@Guard;
               _loc4_.Blood = _loc2_[_loc3_].@Blood;
               _loc4_.needHonor = _loc2_[_loc3_].@Cost;
               _loc4_.Type = _loc2_[_loc3_].@Type;
               if(_loc4_.Type == 1)
               {
                  if(_loc4_.sex == 1)
                  {
                     this._maleUnitDic.add(_loc4_.id,_loc4_);
                  }
                  else
                  {
                     this._femaleUnitDic.add(_loc4_.id,_loc4_);
                  }
               }
               else if(_loc4_.Type == 2)
               {
                  this._weaponUnitDic.add(_loc4_.id,_loc4_);
               }
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc5_.@message;
            onAnalyzeError();
         }
      }
      
      public function get maleUnitDic() : DictionaryData
      {
         return this._maleUnitDic;
      }
      
      public function get femaleUnitDic() : DictionaryData
      {
         return this._femaleUnitDic;
      }
      
      public function get weaponUnitDic() : DictionaryData
      {
         return this._weaponUnitDic;
      }
   }
}
