package calendar.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.DaylyGiveInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public class SignAwardFrame extends BaseAlerFrame
   {
       
      
      private var _back:DisplayObject;
      
      private var _awardCells:Vector.<calendar.view.SignAwardCell>;
      
      private var _awards:Array;
      
      private var _signCount:int;
      
      public function SignAwardFrame()
      {
         this._awardCells = new Vector.<SignAwardCell>();
         super();
         this.configUI();
      }
      
      private function __response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         removeEventListener(FrameEvent.RESPONSE,this.__response);
         ObjectUtils.disposeObject(this);
      }
      
      public function show(param1:int, param2:Array) : void
      {
         var _loc3_:int = 0;
         var _loc6_:calendar.view.SignAwardCell = null;
         var _loc7_:Point = null;
         _loc3_ = 0;
         var _loc4_:int = 0;
         var _loc5_:DaylyGiveInfo = null;
         _loc6_ = null;
         this._signCount = param1;
         this._awards = param2;
         _loc7_ = ComponentFactory.Instance.creatCustomObject("Calendar.SignAward.TopLeft");
         _loc3_ = 0;
         _loc4_ = 0;
         for each(_loc5_ in this._awards)
         {
            _loc6_ = ComponentFactory.Instance.creatCustomObject("SignAwardCell");
            this._awardCells.push(_loc6_);
            _loc6_.info = ItemManager.Instance.getTemplateById(_loc5_.TemplateID);
            _loc6_.setCount(_loc5_.Count);
            if(_loc4_ % 2 == 0)
            {
               _loc6_.x = _loc7_.x;
               _loc6_.y = _loc7_.y + _loc3_ * 60;
            }
            else
            {
               _loc6_.x = _loc7_.x + 132;
               _loc6_.y = _loc7_.y + _loc3_ * 60;
               _loc3_++;
            }
            addToContent(_loc6_);
            _loc4_++;
         }
         addEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function configUI() : void
      {
         info = new AlertInfo(LanguageMgr.GetTranslation("tank.calendar.sign.title"),LanguageMgr.GetTranslation("ok"),"",true,false);
         this._back = ComponentFactory.Instance.creatComponentByStylename("Calendar.SignAward.Back");
         addToContent(this._back);
      }
      
      override public function dispose() : void
      {
         while(this._awardCells.length > 0)
         {
            ObjectUtils.disposeObject(this._awardCells.shift());
         }
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         super.dispose();
      }
   }
}
