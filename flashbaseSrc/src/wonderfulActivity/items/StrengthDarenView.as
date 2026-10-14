package wonderfulActivity.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.WonderfulActivityTypeData;
   import wonderfulActivity.views.IRightView;
   
   public class StrengthDarenView extends Sprite implements IRightView
   {
       
      
      private var _back:Bitmap;
      
      private var _activityTimeTxt:FilterFrameText;
      
      private var _activityInfo:GmActivityInfo;
      
      private var _giftInfoDic:Dictionary;
      
      private var _statusArr:Array;
      
      private var _strengthGradeArr:Array;
      
      private var _listStrengthItem:Vector.<wonderfulActivity.items.StrengthDarenItem>;
      
      private var _vbox:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      public function StrengthDarenView()
      {
         super();
      }
      
      public function setState(param1:int, param2:int) : void
      {
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function init() : void
      {
         this.initView();
         this.initData();
         this.initViewWithData();
      }
      
      private function initViewWithData() : void
      {
         var _loc1_:wonderfulActivity.items.StrengthDarenItem = null;
         if(!this._activityInfo)
         {
            return;
         }
         var _loc2_:Array = [this._activityInfo.beginTime.split(" ")[0],this._activityInfo.endTime.split(" ")[0]];
         this._activityTimeTxt.text = _loc2_[0] + "-" + _loc2_[1];
         var _loc3_:int = 0;
         while(_loc3_ < this._activityInfo.giftbagArray.length)
         {
            _loc1_ = new wonderfulActivity.items.StrengthDarenItem(_loc3_ % 2,this._activityInfo.activityId,this._activityInfo.giftbagArray[_loc3_],this._giftInfoDic[this._activityInfo.giftbagArray[_loc3_].giftbagId],this._statusArr);
            this._listStrengthItem.push(_loc1_);
            this._vbox.addChild(_loc1_);
            _loc3_++;
         }
         this._scrollPanel.invalidateViewport();
      }
      
      private function initData() : void
      {
         var _loc1_:GmActivityInfo = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this._strengthGradeArr = new Array();
         this._listStrengthItem = new Vector.<StrengthDarenItem>();
         for each(_loc1_ in WonderfulActivityManager.Instance.activityData)
         {
            if(_loc1_.activityType == WonderfulActivityTypeData.STRENGTHEN_ACTIVITY && _loc1_.activityChildType == WonderfulActivityTypeData.STRENGTHEN_DAREN)
            {
               this._activityInfo = _loc1_;
               if(Boolean(WonderfulActivityManager.Instance.activityInitData[_loc1_.activityId]))
               {
                  this._giftInfoDic = WonderfulActivityManager.Instance.activityInitData[_loc1_.activityId]["giftInfoDic"];
                  this._statusArr = WonderfulActivityManager.Instance.activityInitData[_loc1_.activityId]["statusArr"];
               }
               _loc2_ = 0;
               while(_loc2_ < _loc1_.giftbagArray.length)
               {
                  _loc3_ = 0;
                  while(_loc3_ < _loc1_.giftbagArray[_loc2_].giftConditionArr.length)
                  {
                     if(_loc1_.giftbagArray[_loc2_].giftConditionArr[_loc3_].conditionIndex == 0)
                     {
                        this._strengthGradeArr.push(_loc1_.giftbagArray[_loc2_].giftConditionArr[_loc3_].conditionValue);
                     }
                     _loc3_++;
                  }
                  _loc2_++;
               }
            }
         }
      }
      
      private function initView() : void
      {
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.strength.back");
         addChild(this._back);
         this._activityTimeTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.activetimeTxt");
         addChild(this._activityTimeTxt);
         PositionUtils.setPos(this._activityTimeTxt,"wonderful.strengthdaren.activetime.pos");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.left.vBox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.scrollpanel");
         this._vbox.spacing = 3;
         PositionUtils.setPos(this._scrollPanel,"wonderful.scrollPanel.pos");
         this._scrollPanel.height = 285;
         this._scrollPanel.setView(this._vbox);
         this._scrollPanel.invalidateViewport();
         addChild(this._scrollPanel);
      }
      
      public function setData(param1:* = null) : void
      {
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._listStrengthItem.length)
         {
            ObjectUtils.disposeObject(this._listStrengthItem[_loc1_]);
            this._listStrengthItem[_loc1_] = null;
            _loc1_++;
         }
         this._listStrengthItem = null;
         if(Boolean(this._vbox))
         {
            ObjectUtils.disposeObject(this._vbox);
            this._vbox = null;
         }
         ObjectUtils.disposeObject(this._scrollPanel);
         this._scrollPanel = null;
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._activityTimeTxt);
         this._activityTimeTxt = null;
         if(Boolean(parent))
         {
            ObjectUtils.disposeObject(this);
         }
      }
   }
}
