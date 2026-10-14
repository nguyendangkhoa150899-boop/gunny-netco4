package wonderfulActivity.items
{
   import activeEvents.data.ActiveEventsInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class LimitListItem extends Sprite
   {
      
      public static const ITEM_CHANGE:String = "itemChange";
       
      
      private var _info:ActiveEventsInfo;
      
      private var _btn:ScaleFrameImage;
      
      private var _txt:FilterFrameText;
      
      private var _isSeleted:Boolean;
      
      private var _func:Function;
      
      private var _selecetHander:Function;
      
      private var icon:Bitmap;
      
      public function LimitListItem(param1:ActiveEventsInfo, param2:Function, param3:Function)
      {
         super();
         this._info = param1;
         this._func = param2;
         this._selecetHander = param3;
         this.initView();
         this.initIcon();
      }
      
      private function initView() : void
      {
         this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.left.back");
         addEventListener(MouseEvent.CLICK,this.clickHander);
         addChild(this._btn);
         buttonMode = true;
         useHandCursor = true;
         this.initTxt();
      }
      
      public function setSelectBtn(param1:Boolean) : void
      {
         this._isSeleted = param1;
         DisplayUtils.setFrame(this._btn,this._isSeleted ? int(2) : int(1));
         this.initTxt();
         dispatchEvent(new Event(ITEM_CHANGE));
      }
      
      private function initTxt() : void
      {
         if(Boolean(this._txt))
         {
            ObjectUtils.disposeObject(this._txt);
            this._txt = null;
         }
         if(this._isSeleted)
         {
            this._txt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.left.seleBtnTxt");
         }
         else
         {
            this._txt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.left.unseleBtnTxt");
         }
         this._txt.text = this.changeTitle();
         addChild(this._txt);
      }
      
      private function changeTitle() : String
      {
         var _loc1_:String = "";
         var _loc2_:String = "  " + this._info.Title;
         if(_loc2_.length > 11)
         {
            _loc1_ = _loc2_.substr(0,8) + "...";
         }
         else
         {
            _loc1_ = _loc2_;
         }
         return _loc1_;
      }
      
      public function initRightView() : Function
      {
         return this._func(this._info);
      }
      
      protected function clickHander(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._isSeleted)
         {
            return;
         }
         if(this._func != null)
         {
            this._func(this._info);
         }
         if(this._selecetHander != null)
         {
            this._selecetHander();
         }
         this.setSelectBtn(true);
         this.initTxt();
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.clickHander);
         ObjectUtils.disposeObject(this._btn);
         ObjectUtils.disposeObject(this._txt);
         ObjectUtils.disposeObject(this.icon);
         this._txt = null;
         this._btn = null;
         this._func = null;
         this.icon = null;
      }
      
      private function initIcon() : void
      {
         if(Boolean(this.icon))
         {
            ObjectUtils.disposeObject(this.icon);
            this.icon = null;
         }
         var _loc1_:int = this._info.IconID;
         if(_loc1_ == 1)
         {
            this.icon = ComponentFactory.Instance.creat("wonderfulactivity.left.icon_chongzhi");
         }
         else if(_loc1_ == 2)
         {
            this.icon = ComponentFactory.Instance.creat("wonderfulactivity.left.icon_qita");
         }
         else if(_loc1_ == 3)
         {
            this.icon = ComponentFactory.Instance.creat("wonderfulactivity.left.icon_duihuan");
         }
         else if(_loc1_ == 4)
         {
            this.icon = ComponentFactory.Instance.creat("wonderfulactivity.left.icon_hunli");
         }
         else if(_loc1_ == 5)
         {
            this.icon = ComponentFactory.Instance.creat("wonderfulactivity.left.icon_lingqu");
         }
         else if(_loc1_ == 6)
         {
            this.icon = ComponentFactory.Instance.creat("wonderfulactivity.left.icon_xiaofei");
         }
         if(this.icon == null)
         {
            return;
         }
         PositionUtils.setPos(this.icon,"wonderfulactivity.left.iconPos");
         addChild(this.icon);
      }
   }
}
