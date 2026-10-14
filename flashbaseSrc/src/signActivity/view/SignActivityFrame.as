package signActivity.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.utils.Dictionary;
   import signActivity.SignActivityMgr;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GmActivityInfo;
   
   public class SignActivityFrame extends Frame
   {
       
      
      private var _bg:Bitmap;
      
      private var _day:int;
      
      private var _giftbagArray:Array;
      
      private var _activeTimeTxt:FilterFrameText;
      
      private var _helpTxt:FilterFrameText;
      
      private var _itemList:Vector.<SignActivityItem>;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _vBox:VBox;
      
      private var actId:String;
      
      private var _xmlData:GmActivityInfo;
      
      private var _giftInfoDic:Dictionary;
      
      private var _statusArr:Array;
      
      public function SignActivityFrame($day:int)
      {
         super();
         this._day = $day;
         this.initView();
         this.initEvent();
         this.initData();
         this.initGoods();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.signactivity.day" + this._day);
         addToContent(this._bg);
         this._activeTimeTxt = ComponentFactory.Instance.creatComponentByStylename("signActivityFrame.activeTimeTxt");
         this._activeTimeTxt.text = LanguageMgr.GetTranslation("signActivityFrame.activeTimeTxt",SignActivityMgr.instance.model.beginTime,SignActivityMgr.instance.model.endTime);
         addToContent(this._activeTimeTxt);
         this._helpTxt = ComponentFactory.Instance.creatComponentByStylename("signActivityFrame.helpTxt");
         this._helpTxt.text = "1. Trong thời gian hoạt động đăng nhập game được nhận thưởng." + "\n" + "2. Mỗi tài khoản chỉ được nhận thưởng điểm danh 1 lần." + "\n" + "3. Người chơi đăng nhập ngày N chỉ được nhận thưởng ngày N tương ứng."+ "\n" + "4. Liên tục đăng nhập 3 và 7 ngày sẽ nhận thêm thưởng tương ứng";//LanguageMgr.GetTranslation("signActivityFrame.helpTxt");
         addToContent(this._helpTxt);
         this._giftbagArray = SignActivityMgr.instance.model.giftbagArray;
         this._vBox = new VBox();
         this._vBox.spacing = 4;
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("signactivity.rightScrollPanel");
         addToContent(this._scrollPanel);
      }
      
      private function initData() : void
      {
         this._itemList = new Vector.<SignActivityItem>();
         this.actId = SignActivityMgr.instance.model.actId;
         this._xmlData = WonderfulActivityManager.Instance.getActivityDataById(this.actId);
         this._giftInfoDic = WonderfulActivityManager.Instance.getActivityInitDataById(this.actId).giftInfoDic;
         this._statusArr = WonderfulActivityManager.Instance.getActivityInitDataById(this.actId).statusArr;
      }
      
      private function initGoods() : void
      {
         var _loc4_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         if(!this._xmlData)
         {
            return;
         }
         var _loc1_:Array = this._xmlData.giftbagArray;
         _loc4_ = 0;
         while(_loc4_ < this._giftbagArray.length)
         {
            _loc3_ = this._giftbagArray[_loc4_].giftConditionArr[0].conditionValue;
            _loc2_ = ComponentFactory.Instance.creatCustomObject("SignActivityFrame.SignActivityItem",[this._day,_loc3_]);
            _loc2_.setGoods(_loc1_[_loc4_]);
            this._itemList.push(_loc2_);
            if((_loc1_[_loc4_] as GiftBagInfo).giftConditionArr[0].conditionIndex != 1 && this._day == 14)
            {
               PositionUtils.setPos(_loc2_,"signActivity.item2pos");
               this._vBox.addChild(_loc2_);
            }
            else
            {
               PositionUtils.setPos(_loc2_,"signActivity.item1pos");
               addToContent(_loc2_);
            }
            _loc4_++;
         }
         this._scrollPanel.setView(this._vBox);
         this._scrollPanel.invalidateViewport();
         this.refresh();
      }
      
      public function refresh() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ <= this._itemList.length - 1)
         {
            (this._itemList[_loc1_] as SignActivityItem).setStatus(this._statusArr,this._giftInfoDic,_loc1_);
            _loc1_++;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.__responseHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this.__responseHandler);
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == 0 || evt.responseCode == 1)
         {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.requestWonderfulActInit(2);
            WonderfulActivityManager.Instance.refreshIconStatus();
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:* = null;
         this.removeEvent();
         while(this._itemList.length)
         {
            _loc1_ = this._itemList.shift();
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         this._scrollPanel = null;
         this._vBox = null;
         SignActivityItem.length = 1;
         SignActivityItem.btnIndex = 1;
         SignActivityItem.btnBigIndex = 1;
         SignActivityItem.continuousGoodsIndex = 1;
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
      }
   }
}
