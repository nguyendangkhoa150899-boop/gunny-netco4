package consortionBattle.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class ConsBatScoreViewListCell extends Sprite implements Disposeable, IListCell
   {
       
      
      private var _data:Object;
      
      private var _nameTxt:FilterFrameText;
      
      private var _scoreTxt:FilterFrameText;
      
      public function ConsBatScoreViewListCell()
      {
         super();
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.scoreView.cellTxt");
         this._scoreTxt = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.scoreView.cellTxt");
         PositionUtils.setPos(this._scoreTxt,"consortiaBattle.scoreView.cellScoreTxtPos");
         addChild(this._nameTxt);
         addChild(this._scoreTxt);
      }
      
      private function update() : void
      {
         var _loc1_:uint = 0;
         this._nameTxt.text = this._data.rank + "." + this._data.name;
         this._scoreTxt.text = this._data.score;
         switch(this._data.rank)
         {
            case 1:
               _loc1_ = 16775296;
               break;
            case 2:
               _loc1_ = 967126;
               break;
            case 3:
               _loc1_ = 1292038;
               break;
            default:
               _loc1_ = 16777215;
         }
         this._nameTxt.textColor = _loc1_;
         this._scoreTxt.textColor = _loc1_;
      }
      
      public function getCellValue() : *
      {
         return this._data;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._data = param1;
         this.update();
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._nameTxt = null;
         this._scoreTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
