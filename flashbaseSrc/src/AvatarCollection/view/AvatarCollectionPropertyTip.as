package AvatarCollection.view
{
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class AvatarCollectionPropertyTip extends Sprite implements Disposeable
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _line:ScaleBitmapImage;
      
      private var _titleTxt:FilterFrameText;
      
      private var _valueTxtList:Vector.<FilterFrameText>;
      
      private var _titleStrList:Array;
      
      public function AvatarCollectionPropertyTip()
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         super();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
         this._bg.width = 230;
         this._bg.height = 205;
         addChild(this._bg);
         this._line = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._line.width = 220;
         this._line.x = 4;
         this._line.y = 36;
         addChild(this._line);
         this._titleStrList = LanguageMgr.GetTranslation("avatarCollection.propertyTipTitleTxt").split(",");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.propertyTip.titleTxt");
         addChild(this._titleTxt);
         this._valueTxtList = new Vector.<FilterFrameText>();
         var _loc4_:Array = LanguageMgr.GetTranslation("avatarCollection.propertyNameTxt").split(",");
         _loc1_ = 0;
         while(_loc1_ < 7)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("avatarColl.propertyTip.nameTxt");
            _loc2_.text = _loc4_[_loc1_] + "：";
            _loc2_.x = 15;
            _loc2_.y = _loc1_ * 20 + 46;
            addChild(_loc2_);
            _loc3_ = ComponentFactory.Instance.creatComponentByStylename("avatarColl.propertyTip.valueTxt");
            _loc3_.text = "0";
            _loc3_.x = 103;
            _loc3_.y = _loc1_ * 20 + 46;
            addChild(_loc3_);
            this._valueTxtList.push(_loc3_);
            _loc1_++;
         }
      }
      
      public function refreshView(param1:AvatarCollectionUnitVo, param2:int) : void
      {
         this._valueTxtList[0].text = (param1.Attack * param2).toString();
         this._valueTxtList[1].text = (param1.Defence * param2).toString();
         this._valueTxtList[2].text = (param1.Agility * param2).toString();
         this._valueTxtList[3].text = (param1.Luck * param2).toString();
         this._valueTxtList[4].text = (param1.Damage * param2).toString();
         this._valueTxtList[5].text = (param1.Guard * param2).toString();
         this._valueTxtList[6].text = (param1.Blood * param2).toString();
         this._titleTxt.text = this._titleStrList[param2 - 1];
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._line = null;
         this._titleTxt = null;
         this._valueTxtList = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
