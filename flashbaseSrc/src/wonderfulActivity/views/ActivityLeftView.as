package wonderfulActivity.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.event.WonderfulActivityEvent;
   
   public class ActivityLeftView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _vbox:VBox;
      
      private var _unitList:Vector.<wonderfulActivity.views.ActivityLeftUnitView>;
      
      private var tempArray:Array;
      
      private var _rightFun:Function;
      
      private var selectedUnitIndex:int;
      
      private var _isNewServerExist:Boolean = false;
      
      public function ActivityLeftView()
      {
         super();
         this.initView();
         this.selectedUnitIndex = -1;
      }
      
      public function setRightView(param1:Function) : void
      {
         this._rightFun = param1;
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("wonderful.leftview.BG");
         addChild(this._bg);
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("wonderful.leftview.vbox");
         this._unitList = new Vector.<ActivityLeftUnitView>();
         addChild(this._vbox);
      }
      
      public function addUnitByType(param1:Array, param2:int) : void
      {
         var _loc3_:wonderfulActivity.views.ActivityLeftUnitView = this.getLeftUnitView(param2);
         if(_loc3_ == null)
         {
            _loc3_ = new wonderfulActivity.views.ActivityLeftUnitView(param2);
            _loc3_.addEventListener(WonderfulActivityEvent.SELECTED_CHANGE,this.refreshView);
            this._vbox.addChild(_loc3_);
            this._unitList.push(_loc3_);
         }
         this.setBgHeight(_loc3_);
         _loc3_.setData(param1,this._rightFun);
         this._vbox.refreshChildPos();
      }
      
      private function setBgHeight(param1:wonderfulActivity.views.ActivityLeftUnitView) : void
      {
         if(this.isNewServerExist)
         {
            param1.bg.height = 300;
            param1.list.height = 280;
         }
         else
         {
            param1.bg.height = 360;
            param1.list.height = 340;
         }
      }
      
      public function checkNewServerExist() : void
      {
         var _loc1_:wonderfulActivity.views.ActivityLeftUnitView = this.getLeftUnitView(3);
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._vbox.numChildren)
         {
            if(this._vbox.getChildAt(_loc2_) == _loc1_)
            {
               this._vbox.removeChildAt(_loc2_);
               this._unitList[_loc2_].removeEventListener(WonderfulActivityEvent.SELECTED_CHANGE,this.refreshView);
               this._unitList.splice(this._unitList.indexOf(this._unitList[_loc2_]),1);
               ObjectUtils.disposeObject(_loc1_);
               _loc1_ = null;
               break;
            }
            _loc2_++;
         }
         this._vbox.refreshChildPos();
      }
      
      public function extendUnitView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.selectedUnitIndex < 0)
         {
            if(WonderfulActivityManager.Instance.isSkipFromHall)
            {
               _loc1_ = 0;
               while(_loc1_ <= this._unitList.length - 1)
               {
                  if(this._unitList[_loc1_].type == WonderfulActivityManager.Instance.leftUnitViewType && this._unitList[_loc1_].getModelSize() > 0)
                  {
                     _loc3_ = _loc1_;
                     break;
                  }
                  _loc3_ = 2;
                  _loc1_++;
               }
            }
            else
            {
               _loc2_ = 0;
               while(_loc2_ <= this._unitList.length - 1)
               {
                  if(this._unitList[_loc2_].getModelSize() > 0)
                  {
                     _loc3_ = _loc2_;
                     break;
                  }
                  _loc2_++;
               }
            }
         }
         else
         {
            if(this.selectedUnitIndex > this._unitList.length - 1)
            {
               this.selectedUnitIndex = 0;
            }
            _loc3_ = this.selectedUnitIndex;
         }
         (this._unitList[_loc3_] as ActivityLeftUnitView).extendSelecteTheFirst();
         var _loc4_:int = 0;
         while(_loc4_ <= this._unitList.length - 1)
         {
            if(_loc4_ != _loc3_)
            {
               (this._unitList[_loc4_] as ActivityLeftUnitView).unextendHandler();
            }
            _loc4_++;
         }
         this._vbox.refreshChildPos();
      }
      
      private function getLeftUnitView(param1:int) : wonderfulActivity.views.ActivityLeftUnitView
      {
         var _loc2_:int = 0;
         while(_loc2_ <= this._unitList.length - 1)
         {
            if(param1 == this._unitList[_loc2_].type)
            {
               return this._unitList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      private function refreshView(param1:WonderfulActivityEvent) : void
      {
         var _loc2_:wonderfulActivity.views.ActivityLeftUnitView = param1.target as ActivityLeftUnitView;
         var _loc3_:int = 0;
         while(_loc3_ <= this._unitList.length - 1)
         {
            if(this._unitList[_loc3_] == _loc2_)
            {
               this.selectedUnitIndex = _loc3_;
            }
            else
            {
               this._unitList[_loc3_].unextendHandler();
            }
            _loc3_++;
         }
         this._vbox.arrange();
      }
      
      private function removeEvent() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ <= this._unitList.length - 1)
         {
            this._unitList[_loc1_].removeEventListener(WonderfulActivityEvent.SELECTED_CHANGE,this.refreshView);
            _loc1_++;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:wonderfulActivity.views.ActivityLeftUnitView = null;
         this.removeEvent();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._vbox))
         {
            ObjectUtils.disposeObject(this._vbox);
         }
         this._vbox = null;
         if(Boolean(this._unitList))
         {
            for each(_loc1_ in this._unitList)
            {
               ObjectUtils.disposeObject(_loc1_);
               _loc1_ = null;
            }
         }
         this._unitList = null;
      }
      
      public function get isNewServerExist() : Boolean
      {
         return this._isNewServerExist;
      }
      
      public function set isNewServerExist(param1:Boolean) : void
      {
         this._isNewServerExist = param1;
      }
   }
}
