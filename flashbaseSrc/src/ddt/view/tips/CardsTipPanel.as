package ddt.view.tips
{
   import cardSystem.CardControl;
   import cardSystem.data.CardInfo;
   import cardSystem.data.SetsInfo;
   import cardSystem.data.SetsPropertyInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.QualityType;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import road7th.data.DictionaryData;
   
   public class CardsTipPanel extends BaseTip implements ITip, Disposeable
   {
      
      public static const THISWIDTH:int = 380;
      
      public static const CARDTYPE:Array = [LanguageMgr.GetTranslation("BrowseLeftMenuView.equipCard"),LanguageMgr.GetTranslation("BrowseLeftMenuView.freakCard")];
      
      public static const CARDTYPE_VICE_MAIN:Array = [LanguageMgr.GetTranslation("ddt.cardSystem.CardsTipPanel.vice"),LanguageMgr.GetTranslation("ddt.cardSystem.CardsTipPanel.main")];
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _cardName:FilterFrameText;
      
      private var _cardType:Bitmap;
      
      private var _cardTypeDetail:FilterFrameText;
      
      private var _cardLevel:Bitmap;
      
      private var _cardLevelDetail:FilterFrameText;
      
      private var _rule1:ScaleBitmapImage;
      
      private var _band:ScaleFrameImage;
      
      private var _propVec:Vector.<FilterFrameText>;
      
      private var _rule2:ScaleBitmapImage;
      
      private var _setsName:FilterFrameText;
      
      private var _setsPropVec:Vector.<FilterFrameText>;
      
      private var _validity:FilterFrameText;
      
      private var _cardInfo:CardInfo;
      
      private var _thisHeight:int;
      
      public function CardsTipPanel()
      {
         super();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         this._cardName = null;
         this._cardType = null;
         this._cardTypeDetail = null;
         this._cardLevel = null;
         this._rule1 = null;
         this._band = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._propVec.length)
         {
            this._propVec[_loc1_] = null;
            _loc1_++;
         }
         this._propVec = null;
         this._rule2 = null;
         this._setsName = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._setsPropVec.length)
         {
            this._setsPropVec[_loc2_] = null;
            _loc2_++;
         }
         this._setsPropVec = null;
         this._validity = null;
         this._cardInfo = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
         this._rule1 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._rule2 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._band = ComponentFactory.Instance.creatComponentByStylename("tipPanel.band");
         this._cardName = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.name");
         this._cardType = ComponentFactory.Instance.creatBitmap("asset.core.tip.GoodsType");
         PositionUtils.setPos(this._cardType,"CardsTipPanel.typePos");
         this._cardTypeDetail = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.typeDetail");
         this._cardLevel = ComponentFactory.Instance.creatBitmap("asset.core.tip.GoodsLevel");
         PositionUtils.setPos(this._cardLevel,"core.cardLevelBmp.pos");
         this._cardLevelDetail = ComponentFactory.Instance.creatComponentByStylename("cardSystem.level.big");
         PositionUtils.setPos(this._cardLevelDetail,"core.cardLevel.pos");
         this._propVec = new Vector.<FilterFrameText>(4);
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            this._propVec[_loc1_] = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.basePropTitle");
            _loc1_++;
         }
         this._setsName = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.basePropTitle");
         this._setsPropVec = new Vector.<FilterFrameText>(4);
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            this._setsPropVec[_loc2_] = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.setsPropText");
            _loc2_++;
         }
         this._validity = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.basePropTitle");
         super.init();
         super.tipbackgound = this._bg;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._cardName);
         addChild(this._cardType);
         addChild(this._cardTypeDetail);
         addChild(this._cardLevel);
         addChild(this._cardLevelDetail);
         addChild(this._rule1);
         addChild(this._band);
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            addChild(this._propVec[_loc1_]);
            _loc1_++;
         }
         addChild(this._rule2);
         addChild(this._setsName);
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            addChild(this._setsPropVec[_loc2_]);
            _loc2_++;
         }
         addChild(this._validity);
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         if(Boolean(param1))
         {
            this._cardInfo = param1 as CardInfo;
            this.visible = true;
            _tipData = this._cardInfo;
            this.upview();
         }
         else
         {
            this.visible = false;
            _tipData = null;
         }
      }
      
      private function upview() : void
      {
         this._thisHeight = 0;
         this.showHeadPart();
         this.showMiddlePart();
         this.showButtomPart();
         this.upBackground();
      }
      
      private function showHeadPart() : void
      {
         this._cardName.text = this._cardInfo.templateInfo.Name;
         this._cardTypeDetail.text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.typeDetail",CARDTYPE[int(this._cardInfo.templateInfo.Property6)],CARDTYPE_VICE_MAIN[this._cardInfo.templateInfo.Property8]);
         this._cardLevelDetail.text = this._cardInfo.Level < 10 ? "0" + this._cardInfo.Level : this._cardInfo.Level.toString();
         this._band.setFrame(this._cardInfo.templateInfo.BindType == 0 ? int(2) : int(1));
         var _loc1_:int = this._cardInfo.Level == 30 ? int(3) : (this._cardInfo.Level >= 20 ? int(2) : (this._cardInfo.Level >= 10 ? int(1) : int(0)));
         if(this._cardInfo.Level == 0)
         {
            this._cardName.textColor = 16777215;
         }
         else
         {
            this._cardName.textColor = QualityType.QUALITY_COLOR[_loc1_ + 1];
         }
         this._rule1.x = this._cardName.x;
         this._rule1.y = this._cardLevel.y + this._cardLevelDetail.textHeight + 10;
         this._thisHeight = this._rule1.y + this._rule1.height;
      }
      
      private function showMiddlePart() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         var _loc2_:Array = new Array();
         if(this._cardInfo.templateInfo.Attack != 0)
         {
            _loc2_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Attack",this._cardInfo.realAttack) + (this._cardInfo.Attack != 0 ? "(" + (this._cardInfo.Attack > 0 ? "+" + this._cardInfo.Attack : this._cardInfo.Attack) + ")" : ""));
         }
         if(this._cardInfo.templateInfo.Defence != 0)
         {
            _loc2_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Defence",this._cardInfo.realDefence) + (this._cardInfo.Defence != 0 ? "(" + (this._cardInfo.Defence > 0 ? "+" + this._cardInfo.Defence : this._cardInfo.Defence) + ")" : ""));
         }
         if(this._cardInfo.templateInfo.Agility != 0)
         {
            _loc2_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Agility",this._cardInfo.realAgility) + (this._cardInfo.Agility != 0 ? "(" + (this._cardInfo.Agility > 0 ? "+" + this._cardInfo.Agility : this._cardInfo.Agility) + ")" : ""));
         }
         if(this._cardInfo.templateInfo.Luck != 0)
         {
            _loc2_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Luck",this._cardInfo.realLuck) + (this._cardInfo.Luck != 0 ? "(" + (this._cardInfo.Luck > 0 ? "+" + this._cardInfo.Luck : this._cardInfo.Luck) + ")" : ""));
         }
         if(parseInt(this._cardInfo.templateInfo.Property4) != 0)
         {
            _loc2_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Gamage",this._cardInfo.realDamage) + (this._cardInfo.Damage != 0 ? "(" + (this._cardInfo.Damage > 0 ? "+" + this._cardInfo.Damage : this._cardInfo.Damage) + ")" : ""));
         }
         if(parseInt(this._cardInfo.templateInfo.Property5) != 0)
         {
            _loc2_.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Guard",this._cardInfo.realGuard) + (this._cardInfo.Guard != 0 ? "(" + (this._cardInfo.Guard > 0 ? "+" + this._cardInfo.Guard : this._cardInfo.Guard) + ")" : ""));
         }
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            if(_loc1_ < _loc2_.length)
            {
               this._propVec[_loc1_].visible = true;
               this._propVec[_loc1_].text = _loc2_[_loc1_];
               this._propVec[_loc1_].textColor = QualityType.QUALITY_COLOR[5];
               this._propVec[_loc1_].y = this._rule1.y + this._rule1.height + 8 + 24 * _loc1_;
               if(_loc1_ == _loc2_.length - 1)
               {
                  this._rule2.x = this._propVec[_loc1_].x;
                  this._rule2.y = this._propVec[_loc1_].y + this._propVec[_loc1_].textHeight + 12;
               }
            }
            else
            {
               this._propVec[_loc1_].visible = false;
            }
            _loc1_++;
         }
         this._thisHeight = this._rule2.y + this._rule2.height;
      }
      
      private function showButtomPart() : void
      {
         var _loc1_:CardInfo = null;
         var _loc2_:Vector.<int> = null;
         var _loc3_:DictionaryData = null;
         var _loc4_:CardInfo = null;
         var _loc5_:int = 0;
         var _loc6_:Vector.<SetsInfo> = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         var _loc13_:Vector.<int> = new Vector.<int>();
         var _loc14_:PlayerInfo = PlayerManager.Instance.findPlayer(this._cardInfo.UserID);
         var _loc15_:DictionaryData = _loc14_.cardEquipDic;
         for each(_loc1_ in _loc15_)
         {
            if(_loc1_.templateInfo.Property7 == this._cardInfo.templateInfo.Property7 && _loc1_.Count > -1)
            {
               _loc13_.push(_loc1_.Level);
            }
         }
         _loc13_.sort(this.compareFun);
         _loc2_ = new Vector.<int>();
         _loc3_ = _loc14_.cardBagDic;
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.templateInfo.Property7 == this._cardInfo.templateInfo.Property7)
            {
               _loc2_.push(_loc4_.Level);
            }
         }
         _loc2_.sort(this.compareFun);
         _loc5_ = 0;
         _loc6_ = CardControl.Instance.model.setsSortRuleVector;
         _loc7_ = int(_loc6_.length);
         _loc8_ = "";
         _loc9_ = 0;
         while(_loc9_ < _loc7_)
         {
            if(_loc6_[_loc9_].ID == this._cardInfo.templateInfo.Property7)
            {
               _loc5_ = int(_loc6_[_loc9_].cardIdVec.length);
               _loc8_ = _loc6_[_loc9_].name;
               break;
            }
            _loc9_++;
         }
         this._setsName.text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.setsName",_loc8_,_loc13_.length,_loc5_);
         if(_loc13_.length > 0)
         {
            this._setsName.textColor = 16777215;
         }
         else
         {
            this._setsName.textColor = 10066329;
         }
         this._setsName.y = this._thisHeight + 5;
         this._thisHeight = this._setsName.y + this._setsName.textHeight;
         var _loc16_:Vector.<SetsPropertyInfo> = CardControl.Instance.model.setsList[this._cardInfo.templateInfo.Property7];
         var _loc17_:int = int(_loc16_.length);
         var _loc18_:int = 0;
         while(_loc18_ < 4)
         {
            if(_loc18_ < _loc17_)
            {
               this._setsPropVec[_loc18_].visible = true;
               _loc10_ = _loc16_[_loc18_].value.split("|");
               _loc11_ = "";
               _loc12_ = _loc16_[_loc18_].condition;
               if(_loc13_.length >= _loc12_)
               {
                  if(_loc10_.length == 4)
                  {
                     _loc11_ = _loc13_[_loc12_ - 1] == 30 ? String(_loc10_[3]) : (_loc13_[_loc12_ - 1] >= 20 ? String(_loc10_[2]) : (_loc13_[_loc12_ - 1] >= 10 ? String(_loc10_[1]) : String(_loc10_[0])));
                  }
                  else
                  {
                     _loc11_ = String(_loc10_[0]);
                  }
                  this._setsPropVec[_loc18_].text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.equip",_loc12_) + "\n    " + _loc16_[_loc18_].Description.replace("{0}",_loc11_);
                  this._setsPropVec[_loc18_].textColor = QualityType.QUALITY_COLOR[2];
               }
               else
               {
                  if(_loc10_.length == 4)
                  {
                     if(_loc2_.length >= _loc12_)
                     {
                        _loc11_ = _loc2_[_loc12_ - 1] == 30 ? String(_loc10_[3]) : (_loc2_[_loc12_ - 1] >= 20 ? String(_loc10_[2]) : (_loc2_[_loc12_ - 1] >= 10 ? String(_loc10_[1]) : String(_loc10_[0])));
                     }
                     else
                     {
                        _loc11_ = String(_loc10_[0]);
                     }
                  }
                  else
                  {
                     _loc11_ = String(_loc10_[0]);
                  }
                  this._setsPropVec[_loc18_].text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.equip",_loc12_) + "\n    " + _loc16_[_loc18_].Description.replace("{0}",_loc11_);
                  this._setsPropVec[_loc18_].textColor = 10066329;
               }
               this._setsPropVec[_loc18_].y = this._thisHeight + 4;
               this._thisHeight = this._setsPropVec[_loc18_].y + this._setsPropVec[_loc18_].textHeight;
            }
            else
            {
               this._setsPropVec[_loc18_].visible = false;
            }
            _loc18_++;
         }
         this._validity.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.use");
         this._validity.textColor = 16776960;
         this._validity.y = this._thisHeight + 10;
         this._thisHeight = this._validity.y + this._validity.textHeight;
      }
      
      private function compareFun(param1:int, param2:int) : Number
      {
         if(param1 < param2)
         {
            return 1;
         }
         if(param1 > param2)
         {
            return -1;
         }
         return 0;
      }
      
      private function upBackground() : void
      {
         this._bg.height = this._thisHeight + 13;
         this._bg.width = THISWIDTH;
         this.updateWH();
      }
      
      private function updateWH() : void
      {
         _width = this._bg.width;
         _height = this._bg.height;
      }
   }
}
