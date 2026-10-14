package wonderfulActivity.limitActivity
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.ActivityCellVo;
   import wonderfulActivity.event.WonderfulActivityEvent;
   
   public class LimitActivityLeftView extends Sprite implements Disposeable
   {
       
      
      private var _bg:MovieClip;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _vbox:VBox;
      
      private var _unitDic:Dictionary;
      
      private var _rightFun:Function;
      
      private var selectedUnitId:String = "";
      
      public function LimitActivityLeftView()
      {
         super();
         this.initView();
      }
      
      public function setRightView(param1:Function) : void
      {
         this._rightFun = param1;
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("wonderful.limitActivity.LargeBackgroundBg");
         addChild(this._bg);
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("wonderful.limitActivity.leftScrollpanel");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("wonderful.leftview.vbox");
         this._scrollPanel.setView(this._vbox);
         addChild(this._scrollPanel);
         this._scrollPanel.invalidateViewport();
         this._unitDic = new Dictionary();
      }
      
      public function setData(param1:Array) : void
      {
         var _loc2_:ActivityCellVo = null;
         var _loc3_:LimitActivityLeftUnit = null;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc2_ = param1[_loc5_] as ActivityCellVo;
            _loc3_ = this._unitDic[_loc2_.id];
            if(_loc3_ == null)
            {
               _loc3_ = new LimitActivityLeftUnit(_loc2_.id,_loc2_.activityName);
               _loc3_.addEventListener(WonderfulActivityEvent.SELECTED_CHANGE,this.refreshView);
               this._vbox.addChild(_loc3_);
               this._unitDic[_loc2_.id] = _loc3_;
            }
            _loc4_ = Boolean(WonderfulActivityManager.Instance.stateDic[_loc2_.viewType]);
            _loc3_.showCanGetReward(_loc4_);
            _loc5_++;
         }
         if(this.selectedUnitId == "" && param1.length > 0)
         {
            this.selectedUnitId = param1[0].id;
            if(this._rightFun != null)
            {
               this._rightFun(this.selectedUnitId);
               if(Boolean(this._unitDic[this.selectedUnitId]))
               {
                  this._unitDic[this.selectedUnitId].selected = true;
               }
            }
         }
         this._vbox.refreshChildPos();
         this._scrollPanel.invalidateViewport();
         if(WonderfulActivityManager.Instance.selectId != "" && Boolean(this._unitDic[WonderfulActivityManager.Instance.selectId]))
         {
            (this._unitDic[WonderfulActivityManager.Instance.selectId] as LimitActivityLeftUnit).dispatchEvent(new WonderfulActivityEvent(WonderfulActivityEvent.SELECTED_CHANGE));
            WonderfulActivityManager.Instance.selectId = "";
         }
      }
      
      private function refreshView(param1:WonderfulActivityEvent) : void
      {
         var _loc2_:LimitActivityLeftUnit = null;
         var _loc3_:LimitActivityLeftUnit = null;
         for each(_loc2_ in this._unitDic)
         {
            _loc2_.selected = false;
         }
         _loc3_ = param1.target as LimitActivityLeftUnit;
         _loc3_.selected = true;
         this.selectedUnitId = _loc3_.id;
         if(this._rightFun != null)
         {
            this._rightFun(this.selectedUnitId);
         }
         this._vbox.arrange();
         this._scrollPanel.invalidateViewport();
      }
      
      private function removeEvent() : void
      {
         var _loc1_:LimitActivityLeftUnit = null;
         for each(_loc1_ in this._unitDic)
         {
            _loc1_.removeEventListener(WonderfulActivityEvent.SELECTED_CHANGE,this.refreshView);
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:LimitActivityLeftUnit = null;
         this.removeEvent();
         if(Boolean(this._bg))
         {
            this._bg.stop();
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(Boolean(this._vbox))
         {
            ObjectUtils.disposeObject(this._vbox);
         }
         this._vbox = null;
         if(Boolean(this._scrollPanel))
         {
            ObjectUtils.disposeAllChildren(this._scrollPanel);
            ObjectUtils.disposeObject(this._scrollPanel);
            this._scrollPanel = null;
         }
         if(Boolean(this._unitDic))
         {
            for each(_loc1_ in this._unitDic)
            {
               ObjectUtils.disposeObject(_loc1_);
               _loc1_ = null;
            }
         }
         this._unitDic = null;
      }
   }
}
