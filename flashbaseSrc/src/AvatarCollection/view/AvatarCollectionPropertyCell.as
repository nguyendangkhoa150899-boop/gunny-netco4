package AvatarCollection.view
{
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import road7th.data.DictionaryData;
   
   public class AvatarCollectionPropertyCell extends Sprite implements Disposeable
   {
       
      
      private var _bg:MovieClip;
      
      private var _nameTxt:FilterFrameText;
      
      private var _valueTxt:FilterFrameText;
      
      private var _index:int;
      
      public function AvatarCollectionPropertyCell(param1:int)
      {
         super();
         this._index = param1;
         this._bg = ComponentFactory.Instance.creat("asset.avatarColl.propertyBg");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.propertyCell.nameTxt");
         var _loc2_:Array = LanguageMgr.GetTranslation("avatarCollection.propertyNameTxt").split(",");
         this._nameTxt.text = _loc2_[this._index];
         this._valueTxt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.propertyCell.valueTxt");
         this._valueTxt.text = "0";
         PositionUtils.setPos(this._bg,this._valueTxt);
         addChild(this._bg);
         addChild(this._nameTxt);
         addChild(this._valueTxt);
      }
      
      public function refreshView(param1:AvatarCollectionUnitVo, param2:int) : void
      {
         if(param2 == -1)
         {
            this._valueTxt.text = "";
            return;
         }
         if(param2 == 0)
         {
            this._valueTxt.text = "0";
            return;
         }
         var _loc3_:int = 0;
         switch(int(this._index))
         {
            case 0:
               _loc3_ = param1.Attack;
               break;
            case 1:
               _loc3_ = param1.Defence;
               break;
            case 2:
               _loc3_ = param1.Agility;
               break;
            case 3:
               _loc3_ = param1.Luck;
               break;
            case 4:
               _loc3_ = param1.Damage;
               break;
            case 5:
               _loc3_ = param1.Guard;
               break;
            case 6:
               _loc3_ = param1.Blood;
         }
         var _loc4_:int = param2 == 2 ? _loc3_ * 2 : _loc3_;
         this._valueTxt.text = _loc4_.toString();
      }
      
      public function refreshAllProperty(param1:AvatarCollectionUnitVo) : void
      {
         var _loc2_:int = 0;
         switch(int(this._index))
         {
            case 0:
               _loc2_ = param1.Attack;
               break;
            case 1:
               _loc2_ = param1.Defence;
               break;
            case 2:
               _loc2_ = param1.Agility;
               break;
            case 3:
               _loc2_ = param1.Luck;
               break;
            case 4:
               _loc2_ = param1.Damage;
               break;
            case 5:
               _loc2_ = param1.Guard;
               break;
            case 6:
               _loc2_ = param1.Blood;
         }
         var _loc3_:Array = ["Attack","Defence","Agility","Luck","Damage","Armor","HP"];
         var _loc4_:DictionaryData = PlayerManager.Instance.Self.getPropertyAdditionByType(_loc3_[this._index]);
         this._valueTxt.text = (!!_loc4_ ? _loc4_["Avatar"] : 0) + "/" + _loc2_.toString();
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._nameTxt = null;
         this._valueTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
