package cardSystem.view.cardCollect
{
   import cardSystem.CardControl;
   import cardSystem.data.SetsInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class CollectBagView extends Sprite implements Disposeable
   {
      
      public static const SELECT:String = "selected";
       
      
      private var _container:VBox;
      
      private var _collectItemVector:Vector.<cardSystem.view.cardCollect.CollectBagItem>;
      
      private var _turnPage:cardSystem.view.cardCollect.CollectTurnPage;
      
      private var _currentCollectItem:cardSystem.view.cardCollect.CollectBagItem;
      
      public function CollectBagView()
      {
         super();
         this.initView();
      }
      
      public function get currentItemSetsInfo() : SetsInfo
      {
         return this._currentCollectItem.setsInfo;
      }
      
      private function initView() : void
      {
         this._container = ComponentFactory.Instance.creatComponentByStylename("CollectBagView.container");
         this._turnPage = ComponentFactory.Instance.creatCustomObject("CollectTurnPage");
         addChild(this._container);
         addChild(this._turnPage);
         this._collectItemVector = new Vector.<CollectBagItem>(3);
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this._collectItemVector[_loc1_] = new cardSystem.view.cardCollect.CollectBagItem();
            this._container.addChild(this._collectItemVector[_loc1_]);
            _loc1_++;
         }
         this._turnPage.addEventListener(Event.CHANGE,this.__turnPage);
         this._turnPage.maxPage = Math.ceil(CardControl.Instance.model.setsSortRuleVector.length / 3);
         this._turnPage.page = 1;
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:cardSystem.view.cardCollect.CollectBagItem = param1.currentTarget as CollectBagItem;
         this.seleted(_loc2_);
      }
      
      private function seleted(param1:cardSystem.view.cardCollect.CollectBagItem) : void
      {
         this._currentCollectItem = param1;
         this._currentCollectItem.seleted = true;
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            if(this._collectItemVector[_loc2_] != this._currentCollectItem)
            {
               this._collectItemVector[_loc2_].seleted = false;
            }
            _loc2_++;
         }
         dispatchEvent(new Event(SELECT));
      }
      
      private function setPage(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         var _loc3_:Vector.<SetsInfo> = CardControl.Instance.model.setsSortRuleVector;
         var _loc4_:int = int(_loc3_.length);
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            if((param1 - 1) * 3 + _loc2_ < _loc4_)
            {
               this._collectItemVector[_loc2_].setsInfo = _loc3_[(param1 - 1) * 3 + _loc2_];
               this._collectItemVector[_loc2_].setSetsDate(CardControl.Instance.model.getSetsCardFromCardBag(_loc3_[(param1 - 1) * 3 + _loc2_].ID));
               this._collectItemVector[_loc2_].addEventListener(MouseEvent.CLICK,this.__clickHandler);
               this._collectItemVector[_loc2_].addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
               this._collectItemVector[_loc2_].addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
            }
            else
            {
               this._collectItemVector[_loc2_].setsInfo = null;
               this._collectItemVector[_loc2_].mouseEnabled = false;
               this._collectItemVector[_loc2_].removeEventListener(MouseEvent.CLICK,this.__clickHandler);
               this._collectItemVector[_loc2_].removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
               this._collectItemVector[_loc2_].removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
            }
            _loc2_++;
         }
         this.seleted(this._collectItemVector[0]);
      }
      
      private function __overHandler(param1:MouseEvent) : void
      {
         (param1.currentTarget as CollectBagItem).filters = ComponentFactory.Instance.creatFilters("lightFilter");
      }
      
      private function __outHandler(param1:MouseEvent) : void
      {
         (param1.currentTarget as CollectBagItem).filters = null;
      }
      
      private function removeEvent() : void
      {
         this._turnPage.removeEventListener(Event.CHANGE,this.__turnPage);
      }
      
      protected function __turnPage(param1:Event) : void
      {
         this.setPage(this._turnPage.page);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            if(Boolean(this._collectItemVector[_loc1_]))
            {
               this._collectItemVector[_loc1_].removeEventListener(MouseEvent.CLICK,this.__clickHandler);
               this._collectItemVector[_loc1_].removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
               this._collectItemVector[_loc1_].removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
               this._collectItemVector[_loc1_].dispose();
            }
            this._collectItemVector[_loc1_] = null;
            _loc1_++;
         }
         this._currentCollectItem = null;
         if(Boolean(this._turnPage))
         {
            this._turnPage.dispose();
         }
         this._turnPage = null;
         if(Boolean(this._container))
         {
            ObjectUtils.disposeObject(this._container);
         }
         this._container = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
