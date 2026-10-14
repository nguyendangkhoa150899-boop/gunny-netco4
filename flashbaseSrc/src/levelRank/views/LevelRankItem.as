package levelRank.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import levelRank.data.LevelRankVo;
   import vip.VipController;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.items.PrizeListItem;
   
   public class LevelRankItem extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _topThreeIcon:ScaleFrameImage;
      
      private var _placeTxt:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _nameTxt:FilterFrameText;
      
      private var _numTxt:FilterFrameText;
      
      private var _prizeHBox:HBox;
      
      private var index:int;
      
      private var vo:LevelRankVo;
      
      public function LevelRankItem(param1:int)
      {
         super();
         this.index = param1;
         this.initView();
      }
      
      private function initView() : void
      {
         switch(this.index % 2)
         {
            case 0:
               this._bg = ComponentFactory.Instance.creat("wonderfulactivity.itemBg0");
               break;
            case 1:
               this._bg = ComponentFactory.Instance.creat("wonderfulactivity.itemBg1");
         }
         addChild(this._bg);
         this._topThreeIcon = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.topThree");
         addChild(this._topThreeIcon);
         this._topThreeIcon.visible = false;
         this._placeTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.placeTxt");
         this._placeTxt.text = "4th";
         addChild(this._placeTxt);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.nameTxt");
         this._nameTxt.text = "小妹也带刀";
         addChild(this._nameTxt);
         this._numTxt = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.numTxt");
         this._numTxt.text = "10000";
         addChild(this._numTxt);
         this._prizeHBox = ComponentFactory.Instance.creatComponentByStylename("wonderful.consumeRank.hbox");
         addChild(this._prizeHBox);
      }
      
      public function setData(param1:LevelRankVo, param2:GiftBagInfo) : void
      {
         var _loc3_:GiftRewardInfo = null;
         var _loc4_:PrizeListItem = null;
         this.vo = param1;
         this.setRankNum(this.index + 1);
         this.addNickName();
         this._numTxt.text = param1.consume.toString();
         if(!param2)
         {
            return;
         }
         var _loc5_:Vector.<GiftRewardInfo> = param2.giftRewardArr;
         var _loc6_:int = 0;
         while(_loc6_ <= _loc5_.length - 1)
         {
            _loc3_ = _loc5_[_loc6_];
            _loc4_ = new PrizeListItem();
            _loc4_.initView(_loc6_);
            _loc4_.setCellData(_loc3_);
            this._prizeHBox.addChild(_loc4_);
            _loc6_++;
         }
      }
      
      private function setRankNum(param1:int) : void
      {
         if(param1 <= 3)
         {
            this._placeTxt.visible = false;
            this._topThreeIcon.visible = true;
            this._topThreeIcon.setFrame(param1);
         }
         else
         {
            this._placeTxt.visible = true;
            this._topThreeIcon.visible = false;
            this._placeTxt.text = param1 + "th";
         }
      }
      
      private function addNickName() : void
      {
         var _loc1_:TextFormat = null;
         if(Boolean(this._vipName))
         {
            this._vipName.dispose();
            this._vipName = null;
         }
         this._nameTxt.visible = !this.vo.isVIP;
         if(this.vo.isVIP)
         {
            this._vipName = VipController.instance.getVipNameTxt(1,1);
            _loc1_ = new TextFormat();
            _loc1_.align = "center";
            _loc1_.bold = true;
            this._vipName.textField.defaultTextFormat = _loc1_;
            this._vipName.textSize = 16;
            this._vipName.textField.width = this._nameTxt.width;
            this._vipName.x = this._nameTxt.x;
            this._vipName.y = this._nameTxt.y;
            this._vipName.text = this.vo.name;
            addChild(this._vipName);
         }
         else
         {
            this._nameTxt.text = this.vo.name;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
      }
   }
}
