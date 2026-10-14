package ddt.utils
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class HelperHelpBtnCreate implements Disposeable
   {
       
      
      public var helpBtnStyleName:String = "coreii.helpBtn";
      
      public var width:Number = 404;
      
      public var height:Number = 484;
      
      private var _scrollPanel:ListPanel;
      
      private var _content:Sprite;
      
      private var _helpBtn:SimpleBitmapButton;
      
      public function HelperHelpBtnCreate()
      {
         super();
      }
      
      public function create(param1:Sprite, param2:String, param3:* = null, param4:* = null, param5:String = "") : void
      {
         param3 == null && (param3 = new Point(30,50));
         param5 == null && (param5 = "AlertDialog.help");
         if(param4 == null)
         {
            if(param1.parent is Frame)
            {
               param4 = new Point(param1.parent.width - 100,-37);
            }
            else
            {
               param4 = new Point(300,-37);
            }
         }
         CoreScrollPanelCell.content = ComponentFactory.Instance.creat(param2);
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("coreii.help.scrollPanel");
         this._scrollPanel.factoryStyle = "com.pickgliss.ui.controls.cell.SimpleListCellFactory|ddt.utils.CoreScrollPanelCell,451,451";
         this._scrollPanel.vectorListModel.clear();
         this._scrollPanel.vectorListModel.appendAll([{}]);
         this._scrollPanel.list.updateListView();
         this._content = new Sprite();
         this._content.addChild(this._scrollPanel);
         PositionUtils.setPos(this._content,param3);
         this._helpBtn = HelpFrameUtils.Instance.simpleHelpButton(param1,this.helpBtnStyleName,null,param5,this._content,this.width,this.height) as SimpleBitmapButton;
         PositionUtils.setPos(this._helpBtn,param4);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._helpBtn);
         ObjectUtils.disposeObject(this._scrollPanel);
         ObjectUtils.disposeObject(this._content);
         this._helpBtn = null;
         this._scrollPanel = null;
         this._content = null;
      }
   }
}
