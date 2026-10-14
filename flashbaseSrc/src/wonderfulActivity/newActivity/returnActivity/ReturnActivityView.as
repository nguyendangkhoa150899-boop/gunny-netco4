package wonderfulActivity.newActivity.returnActivity
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import road7th.utils.DateUtils;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.views.IRightView;
   
   public class ReturnActivityView extends Sprite implements IRightView
   {
       
      
      private var _goldLine:Bitmap;
      
      private var _tittle:Bitmap;
      
      private var _goldStone:Bitmap;
      
      private var _back:Bitmap;
      
      private var _vbox:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _downBack:Bitmap;
      
      private var _limitTime:Bitmap;
      
      private var _downTxt:FilterFrameText;
      
      private var _timerTxt:FilterFrameText;
      
      private var _helpIcon:ScaleBitmapImage;
      
      private var _rightItemList:Vector.<wonderfulActivity.newActivity.returnActivity.ReturnListItem>;
      
      private var _type:int;
      
      private var actId:String;
      
      private var nowDate:Date;
      
      private var endDate:Date;
      
      private var _xmlData:GmActivityInfo;
      
      private var _giftInfoDic:Dictionary;
      
      private var _statusArr:Array;
      
      private var _canSelect:Boolean;
      
      public function ReturnActivityView(param1:int, param2:String)
      {
         this._type = param1;
         this.actId = param2;
         super();
      }
      
      public function init() : void
      {
         this.initData();
         this.initView();
         this.initTimer();
      }
      
      private function initData() : void
      {
         this._rightItemList = new Vector.<ReturnListItem>();
         this._xmlData = WonderfulActivityManager.Instance.getActivityDataById(this.actId);
         this._giftInfoDic = WonderfulActivityManager.Instance.getActivityInitDataById(this.actId).giftInfoDic;
         this._statusArr = WonderfulActivityManager.Instance.getActivityInitDataById(this.actId).statusArr;
      }
      
      private function initView() : void
      {
         this._goldLine = ComponentFactory.Instance.creat("wonderfulactivity.libao.goldLine");
         addChild(this._goldLine);
         if(Boolean(this._xmlData))
         {
            this._canSelect = this.checkReward(this._xmlData.giftbagArray);
         }
         if(this._canSelect)
         {
            this._back = ComponentFactory.Instance.creat("wonderfulactivity.fame.back");
         }
         else
         {
            this._back = ComponentFactory.Instance.creat("wonderfulactivity.fame.back2");
         }
         addChild(this._back);
         this._goldStone = ComponentFactory.Instance.creat("wonderfulactivity.libao.gold");
         addChild(this._goldStone);
         this._downBack = ComponentFactory.Instance.creat("wonderfulactivity.right.back");
         addChild(this._downBack);
         this._downTxt = ComponentFactory.Instance.creat("wonderfulactivity.right.desTxt");
         addChild(this._downTxt);
         switch(this._type)
         {
            case 0:
               this._tittle = ComponentFactory.Instance.creat("wonderfulactivity.rechargeTille1");
               this._downTxt.text = LanguageMgr.GetTranslation("wonderfulActivityManager.btnTxt7",this._statusArr[0].statusValue);
               break;
            case 1:
               this._helpIcon = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.helpImg");
               this._helpIcon.tipData = LanguageMgr.GetTranslation("wonderfulActivityManager.btnTxt8_tip");
               addChild(this._helpIcon);
               this._tittle = ComponentFactory.Instance.creat("wonderfulactivity.rechargeTille2");
               this._downTxt.text = LanguageMgr.GetTranslation("wonderfulActivityManager.btnTxt8",this._statusArr[0].statusValue);
               break;
            case 2:
               this._tittle = ComponentFactory.Instance.creat("wonderfulactivity.oneOffPayTitle");
               break;
            case 3:
               this._helpIcon = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.helpImg");
               this._helpIcon.tipData = LanguageMgr.GetTranslation("wonderfulActivity.oneOffInTimeTip");
               addChild(this._helpIcon);
               this._tittle = ComponentFactory.Instance.creat("wonderfulactivity.oneOffInTimeTitle");
         }
         addChild(this._tittle);
         this._limitTime = ComponentFactory.Instance.creat("wonderfulactivity.limit");
         addChild(this._limitTime);
         this._timerTxt = ComponentFactory.Instance.creat("wonderfulactivity.right.timeTxt");
         addChild(this._timerTxt);
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.left.vBox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.scrollpanel");
         this._scrollPanel.setView(this._vbox);
         addChild(this._scrollPanel);
         this.initItem();
      }
      
      private function checkReward(param1:Array) : Boolean
      {
         var _loc2_:GiftBagInfo = null;
         var _loc3_:GiftRewardInfo = null;
         for each(_loc2_ in param1)
         {
            for each(_loc3_ in _loc2_.giftRewardArr)
            {
               if(_loc3_.rewardType != 0)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function initItem() : void
      {
         var _loc1_:wonderfulActivity.newActivity.returnActivity.ReturnListItem = null;
         if(!this._xmlData)
         {
            return;
         }
         var _loc2_:Array = this._xmlData.giftbagArray;
         var _loc3_:int = 0;
         while(_loc3_ <= _loc2_.length - 1)
         {
            _loc1_ = new wonderfulActivity.newActivity.returnActivity.ReturnListItem(this._type,_loc3_ % 2,this.actId);
            _loc1_.setData(this._xmlData.desc,_loc2_[_loc3_],this._canSelect);
            this._rightItemList.push(_loc1_);
            this._vbox.addChild(_loc1_);
            _loc3_++;
         }
         this._scrollPanel.invalidateViewport();
         this.refresh();
      }
      
      public function refresh() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ <= this._rightItemList.length - 1)
         {
            (this._rightItemList[_loc1_] as ReturnListItem).setStatus(this._statusArr,this._giftInfoDic);
            _loc1_++;
         }
      }
      
      private function initTimer() : void
      {
         if(!this._xmlData)
         {
            return;
         }
         this.endDate = DateUtils.getDateByStr(this._xmlData.endTime);
         this.returnTimerHander();
         WonderfulActivityManager.Instance.addTimerFun("returnActivity",this.returnTimerHander);
      }
      
      private function returnTimerHander() : void
      {
         this.nowDate = TimeManager.Instance.Now();
         var _loc1_:String = WonderfulActivityManager.Instance.getTimeDiff(this.endDate,this.nowDate);
         if(Boolean(this._timerTxt))
         {
            this._timerTxt.text = _loc1_;
         }
         if(_loc1_ == "0")
         {
            this.dispose();
            WonderfulActivityManager.Instance.delTimerFun("returnActivity");
            WonderfulActivityManager.Instance.currView = "-1";
         }
      }
      
      public function dispose() : void
      {
         WonderfulActivityManager.Instance.delTimerFun("returnActivity");
         ObjectUtils.disposeObject(this._goldLine);
         this._goldLine = null;
         ObjectUtils.disposeObject(this._tittle);
         this._tittle = null;
         ObjectUtils.disposeObject(this._goldStone);
         this._goldStone = null;
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._scrollPanel);
         this._scrollPanel = null;
         ObjectUtils.disposeObject(this._downBack);
         this._downBack = null;
         ObjectUtils.disposeObject(this._limitTime);
         this._limitTime = null;
         ObjectUtils.disposeObject(this._downTxt);
         this._downTxt = null;
         ObjectUtils.disposeObject(this._timerTxt);
         this._timerTxt = null;
         ObjectUtils.disposeObject(this._helpIcon);
         this._helpIcon = null;
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function setState(param1:int, param2:int) : void
      {
      }
      
      public function updateAwardState() : void
      {
         this._giftInfoDic = WonderfulActivityManager.Instance.getActivityInitDataById(this.actId).giftInfoDic;
         this._statusArr = WonderfulActivityManager.Instance.getActivityInitDataById(this.actId).statusArr;
         this.refresh();
      }
   }
}
