package AvatarCollection.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import road7th.data.DictionaryData;
   
   public class AvatarCollectionItemDataAnalyzer extends DataAnalyzer
   {
       
      
      private var _maleItemDic:DictionaryData;
      
      private var _femaleItemDic:DictionaryData;
      
      private var _weaponItemDic:DictionaryData;
      
      private var _maleItemList:Vector.<AvatarCollection.data.AvatarCollectionItemVo>;
      
      private var _femaleItemList:Vector.<AvatarCollection.data.AvatarCollectionItemVo>;
      
      private var _weaponItemList:Vector.<AvatarCollection.data.AvatarCollectionItemVo>;
      
      private var _allGoodsTemplateIDlist:DictionaryData;
      
      private var _realItemIdDic:DictionaryData;
      
      public function AvatarCollectionItemDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:XML = new XML(param1);
         this._maleItemDic = new DictionaryData();
         this._femaleItemDic = new DictionaryData();
         this._weaponItemDic = new DictionaryData();
         this._allGoodsTemplateIDlist = new DictionaryData();
         this._maleItemList = new Vector.<AvatarCollectionItemVo>();
         this._femaleItemList = new Vector.<AvatarCollectionItemVo>();
         this._weaponItemList = new Vector.<AvatarCollectionItemVo>();
         this._realItemIdDic = new DictionaryData();
         if(_loc9_.@value == "true")
         {
            _loc2_ = _loc9_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new AvatarCollection.data.AvatarCollectionItemVo();
               _loc4_.id = _loc2_[_loc3_].@ID;
               _loc4_.itemId = _loc2_[_loc3_].@TemplateID;
               _loc4_.proArea = _loc2_[_loc3_].@Description;
               _loc4_.needGold = _loc2_[_loc3_].@Cost;
               _loc4_.sex = _loc2_[_loc3_].@Sex;
               _loc4_.Type = _loc2_[_loc3_].@Type;
               _loc4_.OtherTemplateID = _loc2_[_loc3_].@OtherTemplateID;
               _loc5_ = int(_loc4_.id);
               if(_loc4_.Type == 1)
               {
                  if(_loc4_.sex == 1)
                  {
                     if(!this._maleItemDic[_loc5_])
                     {
                        this._maleItemDic[_loc5_] = new DictionaryData();
                     }
                     this._maleItemDic[_loc5_].add(_loc4_.itemId,_loc4_);
                     this._maleItemList.push(_loc4_);
                  }
                  else
                  {
                     if(!this._femaleItemDic[_loc5_])
                     {
                        this._femaleItemDic[_loc5_] = new DictionaryData();
                     }
                     this._femaleItemDic[_loc5_].add(_loc4_.itemId,_loc4_);
                     this._femaleItemList.push(_loc4_);
                  }
               }
               else
               {
                  if(!this._weaponItemDic[_loc5_])
                  {
                     this._weaponItemDic[_loc5_] = new DictionaryData();
                  }
                  this._weaponItemDic[_loc5_].add(_loc4_.itemId,_loc4_);
                  this._weaponItemList.push(_loc4_);
               }
               this._allGoodsTemplateIDlist[_loc4_.itemId] = true;
               _loc6_ = _loc4_.OtherTemplateID == "" ? [] : _loc4_.OtherTemplateID.split("|");
               _loc7_ = 0;
               while(_loc7_ < _loc6_.length)
               {
                  _loc8_ = int(_loc6_[_loc7_]);
                  if(_loc8_ != 0)
                  {
                     this._realItemIdDic.add(_loc8_,_loc4_.itemId);
                  }
                  _loc7_++;
               }
               this._realItemIdDic.add(_loc4_.itemId,_loc4_.itemId);
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc9_.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function get weaponItemDic() : DictionaryData
      {
         return this._weaponItemDic;
      }
      
      public function get maleItemDic() : DictionaryData
      {
         return this._maleItemDic;
      }
      
      public function get femaleItemDic() : DictionaryData
      {
         return this._femaleItemDic;
      }
      
      public function get maleItemList() : Vector.<AvatarCollection.data.AvatarCollectionItemVo>
      {
         return this._maleItemList;
      }
      
      public function get femaleItemList() : Vector.<AvatarCollection.data.AvatarCollectionItemVo>
      {
         return this._femaleItemList;
      }
      
      public function get weaponItemList() : Vector.<AvatarCollection.data.AvatarCollectionItemVo>
      {
         return this._weaponItemList;
      }
      
      public function get allGoodsTemplateIDlist() : DictionaryData
      {
         return this._allGoodsTemplateIDlist;
      }
      
      public function get realItemIdDic() : DictionaryData
      {
         return this._realItemIdDic;
      }
   }
}
