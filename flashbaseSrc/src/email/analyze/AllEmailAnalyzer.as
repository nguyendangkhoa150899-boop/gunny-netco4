package email.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import email.data.EmailInfo;
   import flash.utils.describeType;
   
   public class AllEmailAnalyzer extends DataAnalyzer
   {
       
      
      private var _list:Array;
      
      public function AllEmailAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         var _loc5_:int = 0;
         var _loc6_:EmailInfo = null;
         var _loc7_:XMLList = null;
         var _loc8_:int = 0;
         var _loc9_:InventoryItemInfo = null;
         var _loc10_:InventoryItemInfo = null;
         this._list = new Array();
         var _loc11_:XML = new XML(param1);
         if(_loc11_.@value == "true")
         {
            _loc2_ = _loc11_.Item;
            _loc3_ = describeType(new EmailInfo());
            _loc4_ = describeType(new InventoryItemInfo());
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length())
            {
               _loc6_ = new EmailInfo();
               ObjectUtils.copyPorpertiesByXML(_loc6_,_loc2_[_loc5_]);
               _loc7_ = _loc2_[_loc5_].Item;
               _loc8_ = 0;
               while(_loc8_ < _loc7_.length())
               {
                  _loc9_ = new InventoryItemInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc9_,_loc7_[_loc8_]);
                  _loc10_ = ItemManager.fill(_loc9_);
                  _loc6_["Annex" + this.getAnnexPos(_loc6_,_loc9_)] = _loc9_;
                  _loc6_.UserID = _loc10_.UserID;
                  _loc8_++;
               }
               if(!SharedManager.Instance.deleteMail[PlayerManager.Instance.Self.ID] || SharedManager.Instance.deleteMail[PlayerManager.Instance.Self.ID].indexOf(_loc6_.ID) < 0)
               {
                  this._list.push(_loc6_);
               }
               _loc5_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc11_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      public function get list() : Array
      {
         this._list.reverse();
         return this._list;
      }
      
      private function getAnnexPos(param1:EmailInfo, param2:InventoryItemInfo) : int
      {
         var _loc3_:uint = 1;
         while(_loc3_ <= 5)
         {
            if(param1["Annex" + _loc3_ + "ID"] == param2.ItemID)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return 1;
      }
   }
}
