package wonderfulActivity.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import wonderfulActivity.data.ActivityTypeData;
   
   public class RightListItem extends Sprite implements Disposeable
   {
       
      
      private var _back:MovieClip;
      
      private var _nameTxt:FilterFrameText;
      
      private var _goodContent:Sprite;
      
      private var _btn:SimpleBitmapButton;
      
      private var _btnTxt:FilterFrameText;
      
      private var _tipsBtn:Bitmap;
      
      private var _data:ActivityTypeData;
      
      public function RightListItem(param1:int, param2:ActivityTypeData)
      {
         super();
         this._data = param2;
         this.init(param1,param2);
      }
      
      public function getItemID() : int
      {
         return this._data.ID;
      }
      
      private function init(param1:int, param2:ActivityTypeData) : void
      {
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.listItem");
         addChild(this._back);
         if(param1 == 1)
         {
            this._back.gotoAndStop(1);
         }
         else
         {
            this._back.gotoAndStop(2);
         }
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.left.nameTxt");
         addChild(this._nameTxt);
         this._nameTxt.text = param2.Description.replace(/\{\d+\}/,param2.Condition);
         this._nameTxt.y = this._back.height / 2 - this._nameTxt.height / 2;
         this.initGoods(param2);
      }
      
      public function getBtn() : SimpleBitmapButton
      {
         return this._btn;
      }
      
      public function initBtnState(param1:int = 1, param2:int = 0) : void
      {
         this.clearBtn();
         if(param1 == 0)
         {
            if(this._data.RegetType == 0)
            {
               this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.bigGetBtn");
               addChild(this._btn);
               this._btnTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.btnTxt");
               this._btn.addChild(this._btnTxt);
               this._tipsBtn = ComponentFactory.Instance.creat("wonderfulactivity.can.repeat");
               this._btn.addChild(this._tipsBtn);
            }
            else
            {
               this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.overBtn");
               addChild(this._btn);
            }
            return;
         }
         if(this._data.RegetType == 0)
         {
            if(param2 == 0)
            {
               this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.bigGetBtn");
            }
            else
            {
               this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.smallGetBtn");
            }
            this._btnTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.btnTxt");
            this._btn.addChild(this._btnTxt);
            this._tipsBtn = ComponentFactory.Instance.creat("wonderfulactivity.can.repeat");
            this._btn.addChild(this._tipsBtn);
         }
         else
         {
            this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.bigGetBtn");
         }
         addChild(this._btn);
         this._btn.addEventListener(MouseEvent.CLICK,this.btnHandler);
      }
      
      public function setBtnTxt(param1:int) : void
      {
         if(Boolean(this._btnTxt))
         {
            this._btnTxt.text = "(" + param1 + ")";
         }
      }
      
      private function btnHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendWonderfulActivity(1,this._data.ID);
      }
      
      private function initGoods(param1:ActivityTypeData) : void
      {
      }
      
      private function clearBtn() : void
      {
         if(!this._btn)
         {
            return;
         }
         while(Boolean(this._btn.numChildren))
         {
            ObjectUtils.disposeObject(this._btn.getChildAt(0));
         }
         this._btn = null;
      }
      
      public function dispose() : void
      {
         while(Boolean(this._goodContent.numChildren))
         {
            ObjectUtils.disposeObject(this._goodContent.getChildAt(0));
         }
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         this._goodContent = null;
         this._back = null;
         this._nameTxt = null;
         this._btn = null;
         this._btnTxt = null;
         this._tipsBtn = null;
      }
   }
}
