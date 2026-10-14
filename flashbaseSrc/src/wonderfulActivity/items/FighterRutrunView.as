package wonderfulActivity.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LeavePageManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.ActivityTypeData;
   import wonderfulActivity.views.IRightView;
   
   public class FighterRutrunView extends Sprite implements IRightView
   {
       
      
      private var _tittle:Bitmap;
      
      private var _goldLine:Bitmap;
      
      private var _back:Bitmap;
      
      private var _goldStone:Bitmap;
      
      private var _btn:SimpleBitmapButton;
      
      private var _treeImage2:ScaleBitmapImage;
      
      private var _data:ActivityTypeData;
      
      private var _goodsContents:Sprite;
      
      private var _timerTxt:FilterFrameText;
      
      private var startData:Date;
      
      private var endData:Date;
      
      private var nowdate:Date;
      
      private var _downBack:ScaleBitmapImage;
      
      public function FighterRutrunView(param1:ActivityTypeData)
      {
         super();
         this._data = param1;
      }
      
      public function setState(param1:int, param2:int) : void
      {
      }
      
      private function initTimer() : void
      {
         this.startData = this._data.StartTime;
         this.endData = this._data.EndTime;
         this.fightTimerHander();
         WonderfulActivityManager.Instance.addTimerFun("fighter",this.fightTimerHander);
      }
      
      private function fightTimerHander() : void
      {
         this.nowdate = TimeManager.Instance.Now();
         var _loc1_:String = WonderfulActivityManager.Instance.getTimeDiff(this.endData,this.nowdate);
         this._timerTxt.text = _loc1_;
         if(_loc1_ == "0")
         {
            this.dispose();
            WonderfulActivityManager.Instance.delTimerFun("fighter");
            SocketManager.Instance.out.sendWonderfulActivity(0,-1);
            WonderfulActivityManager.Instance.currView = "-1";
         }
      }
      
      public function init() : void
      {
         this._tittle = ComponentFactory.Instance.creat("wonderfulactivity.rechargeTille3");
         addChild(this._tittle);
         this._goldLine = ComponentFactory.Instance.creat("wonderfulactivity.libao.goldLine");
         addChild(this._goldLine);
         this._downBack = ComponentFactory.Instance.creat("wonderfulactivity.scale9cornerImageTree");
         this._downBack.width = 476;
         this._downBack.height = 340;
         this._downBack.x = 253;
         this._downBack.y = 111;
         addChild(this._downBack);
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.fighter.back");
         addChild(this._back);
         this._treeImage2 = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.rightBottomBgImg");
         addChild(this._treeImage2);
         this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.gotoRechargeBtn");
         this._btn.addEventListener(MouseEvent.CLICK,this.__gotoRechargeHandler);
         addChild(this._btn);
         this._goldStone = ComponentFactory.Instance.creat("wonderfulactivity.libao.gold");
         addChild(this._goldStone);
         this._timerTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.farmetimeTxt");
         this._timerTxt.x = 374;
         this._timerTxt.y = 260;
         addChild(this._timerTxt);
         this._goodsContents = new Sprite();
         addChild(this._goodsContents);
         this._goodsContents.x = 282;
         this._goodsContents.y = 369;
         this.initGoods();
         this.initTimer();
      }
      
      private function initGoods() : void
      {
      }
      
      private function __gotoRechargeHandler(param1:MouseEvent) : void
      {
         LeavePageManager.leaveToFillPath();
      }
      
      public function dispose() : void
      {
         WonderfulActivityManager.Instance.delTimerFun("fighter");
         while(Boolean(this._goodsContents.numChildren))
         {
            ObjectUtils.disposeObject(this._goodsContents.getChildAt(0));
         }
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(Boolean(this._btn))
         {
            this._btn.removeEventListener(MouseEvent.CLICK,this.__gotoRechargeHandler);
            ObjectUtils.disposeObject(this._btn);
            this._btn = null;
         }
      }
      
      public function content() : Sprite
      {
         return this;
      }
   }
}
