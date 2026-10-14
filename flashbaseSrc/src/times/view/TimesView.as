package times.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import times.TimesController;
   import times.data.TimesEvent;
   import times.data.TimesPicInfo;
   
   public class TimesView extends Sprite implements Disposeable
   {
       
      
      private var _controller:TimesController;
      
      private var _bg:Bitmap;
      
      private var _closeBtn:SimpleBitmapButton;
      
      private var _contentViews:Vector.<times.view.TimesContentView>;
      
      private var _thumbnailView:times.view.TimesThumbnailView;
      
      private var _dateView:times.view.TimesDateView;
      
      private var _menuView:times.view.TimesMenuView;
      
      public function TimesView()
      {
         super();
         this.init();
      }
      
      public function init() : void
      {
         this._controller = TimesController.Instance;
         this._contentViews = new Vector.<TimesContentView>(4);
         this._bg = ComponentFactory.Instance.creatBitmap("asset.times.Bg");
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("times.CloseBtn");
         this._thumbnailView = ComponentFactory.Instance.creatCustomObject("times.TimesThumbnailView",[this._controller]);
         this._dateView = ComponentFactory.Instance.creatCustomObject("times.DateView");
         this._menuView = ComponentFactory.Instance.creatCustomObject("times.MenuView");
         var _loc1_:int = 0;
         while(_loc1_ < this._contentViews.length)
         {
            this._contentViews[_loc1_] = new times.view.TimesContentView();
            this._contentViews[_loc1_].init(this._controller.model.contentInfos[_loc1_]);
            _loc1_++;
         }
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.__closeClick);
         addChild(this._bg);
         addChild(this._closeBtn);
         addChild(this._thumbnailView);
         addChild(this._dateView);
         addChild(this._menuView);
         this._controller.initView(this,this._thumbnailView,this._contentViews);
      }
      
      public function menuSelected(param1:int) : void
      {
         this._menuView.selected = param1;
      }
      
      private function __closeClick(param1:MouseEvent) : void
      {
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.__closeClick);
         this._controller.dispatchEvent(new TimesEvent(TimesEvent.CLOSE_VIEW));
      }
      
      public function updateGuildViewPoint(param1:Point) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TimesPicInfo = null;
         var _loc4_:int = 0;
         if(param1.x == -1 && param1.y == -1)
         {
            this._thumbnailView.pointIdx = _loc4_;
            return;
         }
         var _loc5_:int = 0;
         while(_loc5_ < this._controller.model.contentInfos.length)
         {
            _loc2_ = 0;
            while(_loc2_ < this._controller.model.contentInfos[_loc5_].length)
            {
               _loc3_ = this._controller.model.contentInfos[_loc5_][_loc2_];
               if(param1.x == _loc3_.category && param1.y == _loc3_.page)
               {
                  this._thumbnailView.pointIdx = _loc4_ + 1;
                  return;
               }
               _loc4_++;
               _loc2_++;
            }
            _loc5_++;
         }
      }
      
      public function dispose() : void
      {
         this._controller = null;
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.__closeClick);
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._closeBtn);
         this._closeBtn = null;
         ObjectUtils.disposeObject(this._dateView);
         this._dateView = null;
         ObjectUtils.disposeObject(this._menuView);
         this._menuView = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._contentViews.length)
         {
            ObjectUtils.disposeObject(this._contentViews[_loc1_]);
            this._contentViews[_loc1_] = null;
            _loc1_++;
         }
         this._contentViews = null;
         ObjectUtils.disposeObject(this._thumbnailView);
         this._thumbnailView = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
