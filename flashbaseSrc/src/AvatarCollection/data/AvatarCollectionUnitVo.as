package AvatarCollection.data
{
   import AvatarCollection.AvatarCollectionManager;
   import com.pickgliss.ui.controls.cell.INotSameHeightListCellData;
   
   public class AvatarCollectionUnitVo implements INotSameHeightListCellData
   {
       
      
      private var _selected:Boolean = false;
      
      private var _id:int;
      
      public var sex:int;
      
      public var name:String;
      
      public var Attack:int;
      
      public var Defence:int;
      
      public var Agility:int;
      
      public var Luck:int;
      
      public var Blood:int;
      
      public var Damage:int;
      
      public var Guard:int;
      
      public var needHonor:int;
      
      public var endTime:Date;
      
      public var Type:int = 1;
      
      public function AvatarCollectionUnitVo()
      {
         super();
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         var _loc2_:int = this.totalItemList.length / 2;
         if(this.totalActivityItemCount >= _loc2_)
         {
            this._selected = param1;
         }
         else
         {
            this._selected = false;
         }
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function get totalItemList() : Array
      {
         return AvatarCollectionManager.instance.getItemListById(this.sex,this.id,this.Type);
      }
      
      public function get totalActivityItemCount() : int
      {
         var _loc3_:* = undefined;
         var _loc1_:Array = this.totalItemList;
         var _loc2_:int = 0;
         for each(_loc3_ in _loc1_)
         {
            if(Boolean(_loc3_.isActivity))
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
      
      public function get canActivityCount() : int
      {
         var _loc3_:* = undefined;
         var _loc1_:Array = this.totalItemList;
         var _loc2_:int = 0;
         for each(_loc3_ in _loc1_)
         {
            if(!_loc3_.isActivity && Boolean(_loc3_.isHas))
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
      
      public function get canBuyCount() : int
      {
         var _loc3_:* = undefined;
         var _loc1_:Array = this.totalItemList;
         var _loc2_:int = 0;
         for each(_loc3_ in _loc1_)
         {
            if(!_loc3_.isActivity && !_loc3_.isHas && _loc3_.canBuyStatus == 1)
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
      
      public function getCellHeight() : Number
      {
         return 37;
      }
   }
}
