package wonderfulActivity.newActivity.mountsActivity
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.ItemManager;
   import flash.display.Sprite;
   
   public class MountAwardsItem extends Sprite implements Disposeable
   {
       
      
      private var _describeText:FilterFrameText;
      
      private var _bagCellContainer:Sprite;
      
      private var _cellItems:Vector.<BagCell>;
      
      private var _btnGetAwards:SimpleBitmapButton;
      
      private var _index:int;
      
      public function MountAwardsItem(param1:int)
      {
         super();
         this._index = param1;
      }
      
      public function init() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         this._describeText = ComponentFactory.Instance.creat("");
         this._describeText.text = "";
         addChild(this._describeText);
         this._bagCellContainer = new Sprite();
         this._cellItems = new Vector.<BagCell>();
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            this._cellItems[_loc1_] = new BagCell(0);
            this._cellItems[_loc1_].info = null;
            this._cellItems[_loc1_].x = _loc1_ * 60;
            this._bagCellContainer.addChild(this._cellItems[_loc1_]);
            _loc1_++;
         }
      }
      
      public function setData(param1:String, param2:Array, param3:int) : void
      {
         this._describeText.text = param1;
         var _loc4_:int = int(param2.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            this._cellItems[_loc5_].info = ItemManager.Instance.getTemplateById(param2[_loc5_]);
            _loc5_++;
         }
         while(_loc5_ < 3)
         {
            this._cellItems[_loc5_].info = null;
            _loc5_++;
         }
      }
      
      public function dispose() : void
      {
         var dis:Function = null;
         dis = function(param1:*, param2:int, param3:Vector.<BagCell>):void
         {
            param3[param2].dispose();
         };
         this._describeText = null;
         while(this._bagCellContainer.numChildren > 0)
         {
            this._bagCellContainer.removeChildAt(0);
         }
         this._cellItems.forEach(dis);
         this._cellItems = null;
         this._btnGetAwards.dispose();
      }
   }
}
