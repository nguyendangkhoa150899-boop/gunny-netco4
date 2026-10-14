package ddt.view.caddyII.badLuck
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.RouletteManager;
   import ddt.manager.SocketManager;
   import ddt.view.caddyII.CaddyEvent;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class CaddyBadLuckView extends Sprite implements Disposeable
   {
       
      
      private var _bg:MutipleImage;
      
      private var _title:MutipleImage;
      
      protected var _list:VBox;
      
      protected var _panel:ScrollPanel;
      
      private var _itemList:Vector.<ddt.view.caddyII.badLuck.BadLuckItem>;
      
      private var _dataList:Vector.<Object>;
      
      private var _timer:Timer;
      
      public function CaddyBadLuckView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var _loc1_:ddt.view.caddyII.badLuck.BadLuckItem = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuckBg2");
         this._title = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.badLuckTitle");
         this._list = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuckBox");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuckScrollpanel");
         this._panel.setView(this._list);
         this._panel.invalidateViewport();
         addChild(this._bg);
         addChild(this._title);
         addChild(this._panel);
         this._itemList = new Vector.<BadLuckItem>();
         var _loc2_:int = 0;
         while(_loc2_ < 10)
         {
            _loc1_ = ComponentFactory.Instance.creatCustomObject("card.BadLuckItem");
            this._list.addChild(_loc1_);
            this._itemList.push(_loc1_);
            _loc2_++;
         }
         this._panel.invalidateViewport();
         this._dataList = new Vector.<Object>();
         this._timer = new Timer(30 * 60 * 1000,-1);
         this._timer.start();
         this.requestData();
      }
      
      private function initEvents() : void
      {
         this._timer.addEventListener(TimerEvent.TIMER,this.__oneTimer);
         RouletteManager.instance.addEventListener(CaddyEvent.UPDATE_BADLUCK,this.__getBadLuckHandler);
      }
      
      private function removeEvents() : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER,this.__oneTimer);
         RouletteManager.instance.removeEventListener(CaddyEvent.UPDATE_BADLUCK,this.__getBadLuckHandler);
      }
      
      private function __oneTimer(param1:TimerEvent) : void
      {
         this.requestData();
      }
      
      private function requestData() : void
      {
         SocketManager.Instance.out.sendQequestBadLuck();
      }
      
      private function __getBadLuckHandler(param1:CaddyEvent) : void
      {
         this._dataList = param1.dataList;
         this.updateData();
      }
      
      private function updateData() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         while(_loc2_ < 10 && _loc2_ < this._dataList.length)
         {
            _loc1_ = this._dataList[_loc2_];
            this._itemList[_loc2_].update(_loc2_,_loc1_["Nickname"],_loc1_["Count"]);
            _loc2_++;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:ddt.view.caddyII.badLuck.BadLuckItem = null;
         this.removeEvents();
         for each(_loc1_ in this._itemList)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         this._dataList = null;
         this._itemList = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._title))
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._panel))
         {
            ObjectUtils.disposeObject(this._panel);
         }
         this._panel = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
