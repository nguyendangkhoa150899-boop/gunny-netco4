package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.manager.BossBoxManager;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import road7th.data.DictionaryData;
   
   public class BoxTempInfoAnalyzer extends DataAnalyzer
   {
       
      
      public var inventoryItemList:DictionaryData;
      
      private var _boxTemplateID:Dictionary;
      
      public var caddyBoxGoodsInfo:Vector.<BoxGoodsTempInfo>;
      
      public var caddyTempIDList:DictionaryData;
      
      public var beadTempInfoList:DictionaryData;
      
      public var exploitTemplateIDs:Dictionary;
      
      public function BoxTempInfoAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:BoxGoodsTempInfo = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:BoxGoodsTempInfo = null;
         var _loc7_:BoxGoodsTempInfo = null;
         var _loc8_:Array = null;
         var _loc9_:uint = uint(getTimer());
         var _loc10_:XML = new XML(param1);
         var _loc11_:XMLList = _loc10_..Item;
         this.inventoryItemList = new DictionaryData();
         this.caddyTempIDList = new DictionaryData();
         this.beadTempInfoList = new DictionaryData();
         this.caddyBoxGoodsInfo = new Vector.<BoxGoodsTempInfo>();
         this._boxTemplateID = BossBoxManager.instance.boxTemplateID;
         this.exploitTemplateIDs = BossBoxManager.instance.exploitTemplateIDs;
         this.initDictionaryData();
         if(_loc10_.@value == "true")
         {
            _loc3_ = 0;
            while(_loc3_ < _loc11_.length())
            {
               _loc4_ = _loc11_[_loc3_].@ID;
               _loc5_ = int(_loc11_[_loc3_].@TemplateId);
               if(int(_loc4_) == EquipType.CADDY)
               {
                  _loc6_ = new BoxGoodsTempInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc6_,_loc11_[_loc3_]);
                  this.caddyBoxGoodsInfo.push(_loc6_);
                  this.caddyTempIDList.add(_loc6_.TemplateId,_loc6_);
               }
               else if(int(_loc4_) == EquipType.BEAD_ATTACK || int(_loc4_) == EquipType.BEAD_DEFENSE || int(_loc4_) == EquipType.BEAD_ATTRIBUTE)
               {
                  _loc7_ = new BoxGoodsTempInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc7_,_loc11_[_loc3_]);
                  this.beadTempInfoList[_loc4_].push(_loc7_);
               }
               if(Boolean(this._boxTemplateID[_loc4_]))
               {
                  _loc2_ = new BoxGoodsTempInfo();
                  _loc8_ = new Array();
                  ObjectUtils.copyPorpertiesByXML(_loc2_,_loc11_[_loc3_]);
                  this.inventoryItemList[_loc4_].push(_loc2_);
               }
               if(Boolean(this.exploitTemplateIDs[_loc4_]))
               {
                  _loc2_ = new BoxGoodsTempInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc2_,_loc11_[_loc3_]);
                  this.exploitTemplateIDs[_loc4_].push(_loc2_);
               }
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc10_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      private function initDictionaryData() : void
      {
         var _loc1_:String = null;
         var _loc2_:Array = null;
         for each(_loc1_ in this._boxTemplateID)
         {
            _loc2_ = new Array();
            this.inventoryItemList.add(_loc1_,_loc2_);
         }
         this.beadTempInfoList.add(EquipType.BEAD_ATTACK,new Vector.<BoxGoodsTempInfo>());
         this.beadTempInfoList.add(EquipType.BEAD_DEFENSE,new Vector.<BoxGoodsTempInfo>());
         this.beadTempInfoList.add(EquipType.BEAD_ATTRIBUTE,new Vector.<BoxGoodsTempInfo>());
      }
   }
}
