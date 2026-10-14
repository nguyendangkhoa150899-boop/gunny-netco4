package HappyRecharge
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.geom.Point;
   
   public class HappyRechargeSpecialItemTip extends BaseTip
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _titleTxt:FilterFrameText;
      
      private var _bodyTxt:FilterFrameText;
      
      private var _line:ScaleBitmapImage;
      
      public function HappyRechargeSpecialItemTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("mainframe.specialitemtip.titleTxt");
         this._bodyTxt = ComponentFactory.Instance.creatComponentByStylename("mainframe.specialitemtip.bodyTxt");
         this._line = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._line.width = 180;
         PositionUtils.setPos(this._line,"mainframe.specialitemtip.line.pos");
         addChild(this._line);
         var _loc1_:Point = PositionUtils.creatPoint("mainframe.specialitemtip.tipwidthandheight");
         this.setBGWidth(_loc1_.x);
         this.setBGHeight(_loc1_.y);
         this.tipbackgound = this._bg;
      }
      
      public function setBGWidth(param1:int = 0) : void
      {
         this._bg.width = param1;
      }
      
      public function setBGHeight(param1:int = 0) : void
      {
         this._bg.height = param1;
      }
      
      override public function set tipData(param1:Object) : void
      {
         super.tipData = param1;
         var _loc2_:HappyRechargeSpecialItemTipInfo = param1 as HappyRechargeSpecialItemTipInfo;
         this._titleTxt.text = _loc2_._title;
         this._bodyTxt.htmlText = _loc2_._body;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(Boolean(this._titleTxt))
         {
            addChild(this._titleTxt);
         }
         if(Boolean(this._line))
         {
            addChild(this._line);
         }
         if(Boolean(this._bodyTxt))
         {
            addChild(this._bodyTxt);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(Boolean(this._titleTxt))
         {
            ObjectUtils.disposeObject(this._titleTxt);
            this._titleTxt = null;
         }
         if(Boolean(this._line))
         {
            ObjectUtils.disposeObject(this._line);
            this._line = null;
         }
         if(Boolean(this._bodyTxt))
         {
            ObjectUtils.disposeObject(this._bodyTxt);
            this._bodyTxt = null;
         }
      }
   }
}
