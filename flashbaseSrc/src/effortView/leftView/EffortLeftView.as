package effortView.leftView
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.events.EffortEvent;
   import ddt.manager.EffortManager;
   import ddt.manager.SoundManager;
   import effortView.EffortController;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class EffortLeftView extends Sprite implements Disposeable
   {
      
      public static const TITLE_NUM:int = 6;
       
      
      private var _effortCategoryTitleItem:effortView.leftView.EffortCategoryTitleItem;
      
      private var _effortCategoryTitleItemArray:Array;
      
      private var _controller:EffortController;
      
      public function EffortLeftView(param1:EffortController)
      {
         this._controller = param1;
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         var _loc1_:effortView.leftView.EffortCategoryTitleItem = null;
         this._effortCategoryTitleItemArray = [];
         var _loc2_:int = 0;
         while(_loc2_ <= TITLE_NUM)
         {
            _loc1_ = new effortView.leftView.EffortCategoryTitleItem(_loc2_);
            _loc1_.y = _loc2_ * _loc1_.contentHeight;
            _loc1_.addEventListener(MouseEvent.CLICK,this.__CategoryTitleClick);
            this._effortCategoryTitleItemArray.push(_loc1_);
            addChild(_loc1_);
            _loc2_++;
         }
         this._controller.currentRightViewType = this._controller.currentRightViewType;
         this.__rightChange();
      }
      
      private function __CategoryTitleClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._effortCategoryTitleItem)
         {
            this._effortCategoryTitleItem = param1.currentTarget as EffortCategoryTitleItem;
         }
         if(this._effortCategoryTitleItem != param1.currentTarget as EffortCategoryTitleItem)
         {
            this._effortCategoryTitleItem.selectState = false;
         }
         this._effortCategoryTitleItem = param1.currentTarget as EffortCategoryTitleItem;
         this._effortCategoryTitleItem.selectState = this._effortCategoryTitleItem.isExpand ? Boolean(false) : Boolean(true);
         var _loc2_:int = 1;
         while(_loc2_ <= TITLE_NUM)
         {
            (this._effortCategoryTitleItemArray[_loc2_] as EffortCategoryTitleItem).y = (this._effortCategoryTitleItemArray[_loc2_ - 1] as EffortCategoryTitleItem).contentHeight + (this._effortCategoryTitleItemArray[_loc2_ - 1] as EffortCategoryTitleItem).y;
            _loc2_++;
         }
         if(this._controller.currentRightViewType != (param1.currentTarget as EffortCategoryTitleItem).currentType)
         {
            this._controller.currentRightViewType = (param1.currentTarget as EffortCategoryTitleItem).currentType;
         }
         this.__rightChange();
      }
      
      private function initEvent() : void
      {
         EffortManager.Instance.addEventListener(EffortEvent.TYPE_CHANGED,this.__typeChanged);
         this._controller.addEventListener(Event.CHANGE,this.__rightChange);
      }
      
      private function __rightChange(param1:Event = null) : void
      {
         if(Boolean(this._effortCategoryTitleItem))
         {
            this._effortCategoryTitleItem.selectState = false;
         }
         this._effortCategoryTitleItem = this._effortCategoryTitleItemArray[this._controller.currentRightViewType] as EffortCategoryTitleItem;
         this._effortCategoryTitleItem.selectState = this._effortCategoryTitleItem.isExpand ? Boolean(false) : Boolean(true);
      }
      
      private function disposeItem() : void
      {
         if(!this._effortCategoryTitleItemArray)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._effortCategoryTitleItemArray.length)
         {
            (this._effortCategoryTitleItemArray[_loc1_] as EffortCategoryTitleItem).parent.removeChild(this._effortCategoryTitleItemArray[_loc1_] as EffortCategoryTitleItem);
            (this._effortCategoryTitleItemArray[_loc1_] as EffortCategoryTitleItem).removeEventListener(MouseEvent.CLICK,this.__CategoryTitleClick);
            (this._effortCategoryTitleItemArray[_loc1_] as EffortCategoryTitleItem).dispose();
            this._effortCategoryTitleItemArray[_loc1_] = null;
            _loc1_++;
         }
      }
      
      private function __typeChanged(param1:EffortEvent) : void
      {
         this._controller.currentRightViewType = this._controller.currentRightViewType;
      }
      
      public function dispose() : void
      {
         this.disposeItem();
         EffortManager.Instance.removeEventListener(EffortEvent.TYPE_CHANGED,this.__typeChanged);
         this._controller.removeEventListener(Event.CHANGE,this.__rightChange);
         if(Boolean(this._effortCategoryTitleItem))
         {
            this._effortCategoryTitleItem.dispose();
            this._effortCategoryTitleItem = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
