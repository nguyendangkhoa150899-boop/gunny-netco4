package godCardRaise.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import godCardRaise.GodCardRaiseManager;
   
   public class GodCardRaiseExchangeView extends Sprite implements Disposeable
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _leftView:godCardRaise.view.GodCardRaiseExchangeLeftView;
      
      private var _rightView:godCardRaise.view.GodCardRaiseExchangeRightView;
      
      public function GodCardRaiseExchangeView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseExchangeView.bg");
         addChild(this._bg);
         this._leftView = new godCardRaise.view.GodCardRaiseExchangeLeftView();
         PositionUtils.setPos(this._leftView,"godCardRaiseExchangeView.godCardRaiseExchangeLeftViewPos");
         addChild(this._leftView);
         this._rightView = new godCardRaise.view.GodCardRaiseExchangeRightView();
         PositionUtils.setPos(this._rightView,"godCardRaiseExchangeView.godCardRaiseExchangeRightViewPos");
         addChild(this._rightView);
         this._leftView.setData(GodCardRaiseManager.Instance.godCardListGroupInfoList,this._rightView.changeView);
      }
      
      public function updateView() : void
      {
         if(Boolean(this._leftView))
         {
            this._leftView.updateView();
         }
         if(Boolean(this._rightView))
         {
            this._rightView.updateView();
         }
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._leftView = null;
         this._rightView = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
