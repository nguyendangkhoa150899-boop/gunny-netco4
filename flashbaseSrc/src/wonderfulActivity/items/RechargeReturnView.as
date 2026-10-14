package wonderfulActivity.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.ActivityTypeData;
   import wonderfulActivity.data.CanGetData;
   import wonderfulActivity.views.IRightView;
   
   public class RechargeReturnView extends Sprite implements IRightView
   {
       
      
      private var _goldLine:Bitmap;
      
      private var _tittle:Bitmap;
      
      private var _goldStone:Bitmap;
      
      private var _back:Bitmap;
      
      private var _vbox:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _downBack:Bitmap;
      
      private var _limitTime:Bitmap;
      
      private var _type:int;
      
      private var _downTxt:FilterFrameText;
      
      private var _list:Vector.<ActivityTypeData>;
      
      private var _listRightItem:Vector.<wonderfulActivity.items.RightListItem>;
      
      private var _timerTxt:FilterFrameText;
      
      private var _helpIcon:ScaleBitmapImage;
      
      private var _data:ActivityTypeData;
      
      private var startData:Date;
      
      private var endData:Date;
      
      private var nowdate:Date;
      
      private var _stateList:Vector.<CanGetData>;
      
      private var _isTimerOver:Boolean = false;
      
      public function RechargeReturnView(param1:int = 0, param2:ActivityTypeData = null)
      {
         super();
         this._type = param1;
         this._data = param2;
         this._stateList = WonderfulActivityManager.Instance._stateList;
      }
      
      public function setState(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = int(this._listRightItem.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this._listRightItem[_loc3_].getItemID() == param2)
            {
               if(param1 > 0)
               {
                  this._listRightItem[_loc3_].initBtnState(1,param1);
                  this._listRightItem[_loc3_].setBtnTxt(param1);
               }
               else if(param1 == -1)
               {
                  this._listRightItem[_loc3_].initBtnState();
                  this.applyGray(this._listRightItem[_loc3_].getBtn());
               }
               else
               {
                  this._listRightItem[_loc3_].initBtnState(0);
                  this.applyGray(this._listRightItem[_loc3_].getBtn());
                  this._listRightItem[_loc3_].getBtn().mouseEnabled = false;
                  this._listRightItem[_loc3_].getBtn().mouseChildren = false;
               }
               break;
            }
            _loc3_++;
         }
      }
      
      public function init() : void
      {
         var _loc1_:int = 0;
         this._goldLine = ComponentFactory.Instance.creat("wonderfulactivity.libao.goldLine");
         addChild(this._goldLine);
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.fame.back");
         addChild(this._back);
         this._goldStone = ComponentFactory.Instance.creat("wonderfulactivity.libao.gold");
         addChild(this._goldStone);
         this._downBack = ComponentFactory.Instance.creat("wonderfulactivity.right.back");
         addChild(this._downBack);
         this._timerTxt = ComponentFactory.Instance.creat("wonderfulactivity.right.timeTxt");
         addChild(this._timerTxt);
         this._downTxt = ComponentFactory.Instance.creat("wonderfulactivity.right.desTxt");
         addChild(this._downTxt);
         if(this._type == 1)
         {
            this._tittle = ComponentFactory.Instance.creat("wonderfulactivity.rechargeTille1");
            this._list = WonderfulActivityManager.Instance.activityRechargeList;
            this._downTxt.text = LanguageMgr.GetTranslation("wonderfulActivityManager.btnTxt7",WonderfulActivityManager.Instance.chongZhiScore);
         }
         else
         {
            this._helpIcon = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.helpImg");
            this._helpIcon.tipData = LanguageMgr.GetTranslation("wonderfulActivityManager.btnTxt8_tip");
            addChild(this._helpIcon);
            this._tittle = ComponentFactory.Instance.creat("wonderfulactivity.rechargeTille2");
            this._list = WonderfulActivityManager.Instance.activityExpList;
            _loc1_ = WonderfulActivityManager.Instance.xiaoFeiScore;
            this._downTxt.text = LanguageMgr.GetTranslation("wonderfulActivityManager.btnTxt8",WonderfulActivityManager.Instance.xiaoFeiScore);
         }
         addChild(this._tittle);
         this._limitTime = ComponentFactory.Instance.creat("wonderfulactivity.limit");
         addChild(this._limitTime);
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.left.vBox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.scrollpanel");
         this._scrollPanel.setView(this._vbox);
         this._scrollPanel.invalidateViewport();
         addChild(this._scrollPanel);
         this._listRightItem = new Vector.<RightListItem>();
         this.initItem();
         this.initTimer();
      }
      
      private function applyGray(param1:DisplayObject) : void
      {
         var _loc2_:Array = new Array();
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0,0,0,1,0]);
         this.applyFilter(param1,_loc2_);
      }
      
      private function applyFilter(param1:DisplayObject, param2:Array) : void
      {
         var _loc3_:ColorMatrixFilter = new ColorMatrixFilter(param2);
         var _loc4_:Array = new Array();
         _loc4_.push(_loc3_);
         param1.filters = _loc4_;
      }
      
      private function initTimer() : void
      {
         this.startData = this._data.StartTime;
         this.endData = this._data.EndTime;
         this.rechargeTimerHander();
         WonderfulActivityManager.Instance.addTimerFun("recharge",this.rechargeTimerHander);
      }
      
      private function rechargeTimerHander() : void
      {
         this.nowdate = TimeManager.Instance.Now();
         var _loc1_:String = WonderfulActivityManager.Instance.getTimeDiff(this.endData,this.nowdate);
         this._timerTxt.text = _loc1_;
         if(_loc1_ == "0")
         {
            this.dispose();
            WonderfulActivityManager.Instance.delTimerFun("recharge");
            SocketManager.Instance.out.sendWonderfulActivity(0,-1);
            WonderfulActivityManager.Instance.currView = "-1";
         }
      }
      
      private function initItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:wonderfulActivity.items.RightListItem = null;
         var _loc4_:int = int(this._list.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc1_ = 0;
            while(_loc1_ < this._stateList.length)
            {
               if(this._list[_loc5_].ID == this._stateList[_loc1_].id)
               {
                  _loc2_ = _loc5_ % 2;
                  _loc3_ = new wonderfulActivity.items.RightListItem(_loc2_,this._list[_loc5_]);
                  if(this._stateList[_loc1_].num == 0)
                  {
                     _loc3_.initBtnState(0);
                     this.applyGray(_loc3_.getBtn());
                     _loc3_.getBtn().mouseEnabled = false;
                  }
                  else if(this._stateList[_loc1_].num == -1)
                  {
                     _loc3_.initBtnState();
                     this.applyGray(_loc3_.getBtn());
                     _loc3_.getBtn().mouseEnabled = false;
                  }
                  else if(this._stateList[_loc1_].num >= 1)
                  {
                     _loc3_.initBtnState(1,this._stateList[_loc1_].num);
                     _loc3_.setBtnTxt(this._stateList[_loc1_].num);
                  }
                  this._listRightItem.push(_loc3_);
                  this._vbox.addChild(_loc3_);
                  break;
               }
               _loc1_++;
            }
            _loc5_++;
         }
         this._scrollPanel.invalidateViewport();
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function dispose() : void
      {
         WonderfulActivityManager.Instance.delTimerFun("recharge");
         while(Boolean(this.numChildren))
         {
            ObjectUtils.disposeObject(this.getChildAt(0));
         }
         if(Boolean(parent))
         {
            ObjectUtils.disposeObject(this);
         }
      }
   }
}
