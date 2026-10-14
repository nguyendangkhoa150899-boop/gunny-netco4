package store.view.strength
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.QualityType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.utils.StaticFormula;
   import ddt.view.SimpleItem;
   import ddt.view.tips.GhostStarContainer;
   import ddt.view.tips.GoodTip;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.text.TextFormat;
   import road7th.utils.DateUtils;
   import road7th.utils.StringHelper;
   import store.equipGhost.EquipGhostManager;
   import store.equipGhost.data.GhostPropertyData;
   
   public class LaterEquipmentView extends Component
   {
      
      public static const enchantLevelTxtArr:Array = LanguageMgr.GetTranslation("enchant.levelTxt").split(",");
      
      public static const ITEM_ENCHANT_COLOR:uint = 13971455;
       
      
      private var _strengthenLevelImage:MovieImage;
      
      private var _fusionLevelImage:MovieImage;
      
      private var _boundImage:ScaleFrameImage;
      
      private var _nameTxt:FilterFrameText;
      
      private var _qualityItem:SimpleItem;
      
      private var _typeItem:SimpleItem;
      
      private var _mainPropertyItem:SimpleItem;
      
      private var _armAngleItem:SimpleItem;
      
      private var _otherHp:SimpleItem;
      
      private var _necklaceItem:FilterFrameText;
      
      private var _attackTxt:FilterFrameText;
      
      private var _defenseTxt:FilterFrameText;
      
      private var _agilityTxt:FilterFrameText;
      
      private var _luckTxt:FilterFrameText;
      
      private var _enchantLevelTxt:FilterFrameText;
      
      private var _enchantAttackTxt:FilterFrameText;
      
      private var _enchantDefenceTxt:FilterFrameText;
      
      private var _needLevelTxt:FilterFrameText;
      
      private var _needSexTxt:FilterFrameText;
      
      private var _holes:Vector.<FilterFrameText>;
      
      private var _upgradeType:FilterFrameText;
      
      private var _descriptionTxt:FilterFrameText;
      
      private var _bindTypeTxt:FilterFrameText;
      
      private var _remainTimeTxt:FilterFrameText;
      
      private var _goldRemainTimeTxt:FilterFrameText;
      
      private var _fightPropConsumeTxt:FilterFrameText;
      
      private var _boxTimeTxt:FilterFrameText;
      
      private var _limitGradeTxt:FilterFrameText;
      
      private var _info:ItemTemplateInfo;
      
      private var _bindImageOriginalPos:Point;
      
      private var _maxWidth:int;
      
      private var _minWidth:int = 220;
      
      private var _isArmed:Boolean;
      
      private var _displayList:Vector.<DisplayObject>;
      
      private var _displayIdx:int;
      
      private var _lines:Vector.<Image>;
      
      private var _lineIdx:int;
      
      private var _isReAdd:Boolean;
      
      private var _remainTimeBg:Bitmap;
      
      private var _tipbackgound:MutipleImage;
      
      private var _rightArrows:Bitmap;
      
      private var _autoGhostWidth:int;
      
      private var _ghostLV:int = -1;
      
      private var _ghostStartsContainer:GhostStarContainer = null;
      
      public function LaterEquipmentView()
      {
         this._holes = new Vector.<FilterFrameText>();
         super();
      }
      
      override protected function init() : void
      {
         this._lines = new Vector.<Image>();
         this._displayList = new Vector.<DisplayObject>();
         this._rightArrows = ComponentFactory.Instance.creatBitmap("asset.ddtstore.rightArrows");
         this._tipbackgound = ComponentFactory.Instance.creat("ddtstore.strengthTips.strengthenImageBG");
         this._strengthenLevelImage = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameMc");
         this._fusionLevelImage = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTrinketLevelMc");
         this._boundImage = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.BoundImage");
         this._bindImageOriginalPos = new Point(this._boundImage.x,this._boundImage.y);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameTxt");
         this._qualityItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.QualityItem");
         this._typeItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.TypeItem");
         this._mainPropertyItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.MainPropertyItem");
         this._armAngleItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.armAngleItem");
         this._otherHp = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.otherHp");
         this._necklaceItem = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._attackTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._defenseTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._agilityTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._luckTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._enchantLevelTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._enchantAttackTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._enchantDefenceTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._holes = new Vector.<FilterFrameText>();
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            this._holes.push(ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt"));
            _loc1_++;
         }
         this._needLevelTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._needSexTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._upgradeType = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._descriptionTxt = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.DescriptionTxt");
         this._bindTypeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._remainTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemDateTxt");
         this._goldRemainTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipGoldItemDateTxt");
         this._remainTimeBg = ComponentFactory.Instance.creatBitmap("asset.core.tip.restTime");
         this._fightPropConsumeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._boxTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._limitGradeTxt = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.LimitGradeTxt");
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         if(Boolean(param1))
         {
            if(param1 is GoodTipInfo)
            {
               _tipData = param1 as GoodTipInfo;
               this.showTip(_tipData.itemInfo,_tipData.typeIsSecond);
            }
            else if(param1 is ShopItemInfo)
            {
               _tipData = param1 as ShopItemInfo;
               this.showTip(_tipData.TemplateInfo);
            }
            visible = true;
         }
         else
         {
            _tipData = null;
            visible = false;
         }
      }
      
      public function showTip(param1:ItemTemplateInfo, param2:Boolean = false) : void
      {
         this._displayIdx = 0;
         this._displayList = new Vector.<DisplayObject>();
         this._lineIdx = 0;
         this._isReAdd = false;
         this._maxWidth = 0;
         this._autoGhostWidth = 0;
         this._info = param1;
         this.updateView();
      }
      
      private function updateView() : void
      {
         if(this._info == null)
         {
            return;
         }
         this.clear();
         this._isArmed = false;
         this.createItemName();
         this.createQualityItem();
         this.createCategoryItem();
         this.createMainProperty();
         this.seperateLine();
         this.createNecklaceItem();
         this.createProperties();
         this.seperateLine();
         this.createHoleItem();
         this.seperateLine();
         this.createOperationItem();
         this.seperateLine();
         this.createDescript();
         this.createBindType();
         this.createRemainTime();
         this.createGoldRemainTime();
         this.createFightPropConsume();
         this.createBoxTimeItem();
         this.addChildren();
         this.createStrenthLevel();
      }
      
      private function clear() : void
      {
         var _loc1_:DisplayObject = null;
         while(numChildren > 0)
         {
            _loc1_ = getChildAt(0) as DisplayObject;
            if(Boolean(_loc1_.parent))
            {
               _loc1_.parent.removeChild(_loc1_);
            }
         }
      }
      
      override protected function addChildren() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:int = int(this._displayList.length);
         var _loc3_:Point = new Point(4,4);
         var _loc4_:int = 6;
         var _loc5_:int = this._maxWidth;
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_)
         {
            _loc1_ = this._displayList[_loc6_] as DisplayObject;
            if(this._lines.indexOf(_loc1_ as Image) < 0 && _loc1_ != this._descriptionTxt)
            {
               _loc5_ = Math.max(_loc1_.width,_loc5_);
            }
            PositionUtils.setPos(_loc1_,_loc3_);
            addChild(_loc1_);
            _loc3_.y = _loc1_.y + _loc1_.height + _loc4_;
            _loc6_++;
         }
         this._maxWidth = Math.max(this._minWidth,_loc5_);
         if(this._descriptionTxt.width != this._maxWidth)
         {
            this._descriptionTxt.width = this._maxWidth;
            this._descriptionTxt.height = this._descriptionTxt.textHeight + 10;
            this.addChildren();
            return;
         }
         if(!this._isReAdd)
         {
            _loc6_ = 0;
            while(_loc6_ < this._lines.length)
            {
               this._lines[_loc6_].width = this._maxWidth;
               if(_loc6_ + 1 < this._lines.length && this._lines[_loc6_ + 1].parent != null && Math.abs(this._lines[_loc6_ + 1].y - this._lines[_loc6_].y) <= 10)
               {
                  this._displayList.splice(this._displayList.indexOf(this._lines[_loc6_ + 1]),1);
                  this._lines[_loc6_ + 1].parent.removeChild(this._lines[_loc6_ + 1]);
                  this._isReAdd = true;
               }
               _loc6_++;
            }
            if(this._isReAdd)
            {
               this.addChildren();
               return;
            }
         }
         if(Boolean(this._rightArrows))
         {
            addChildAt(this._rightArrows,0);
         }
         if(_loc2_ > 0)
         {
            this._tipbackgound.y = -5;
            _width = this._tipbackgound.width = this._maxWidth + 8;
            _height = this._tipbackgound.height = _loc1_.y + _loc1_.height + 18;
         }
         if(Boolean(this._tipbackgound))
         {
            addChildAt(this._tipbackgound,0);
         }
         if(Boolean(this._remainTimeBg.parent))
         {
            this._remainTimeBg.x = this._remainTimeTxt.x + 2;
            this._remainTimeBg.y = this._remainTimeTxt.y + 2;
            this._remainTimeBg.parent.addChildAt(this._remainTimeBg,1);
         }
         if(Boolean(this._remainTimeBg.parent))
         {
            this._goldRemainTimeTxt.x = this._remainTimeTxt.x + 2;
            this._goldRemainTimeTxt.y = this._remainTimeTxt.y + 22;
            this._remainTimeBg.parent.addChildAt(this._goldRemainTimeTxt,1);
         }
         this._rightArrows.x = 5 - this._rightArrows.width;
         this._rightArrows.y = (this.height - this._rightArrows.height) / 2;
      }
      
      private function createItemName() : void
      {
         var _loc1_:TextFormat = null;
         this._nameTxt.text = String(this._info.Name);
         var _loc2_:InventoryItemInfo = this._info as InventoryItemInfo;
         if(Boolean(_loc2_) && _loc2_.StrengthenLevel > 0)
         {
            if(_loc2_.isGold)
            {
               if(_loc2_.StrengthenLevel > PathManager.solveStrengthMax())
               {
                  this._nameTxt.text += LanguageMgr.GetTranslation("store.view.exalt.goodTips",_loc2_.StrengthenLevel - 12);
               }
               else
               {
                  this._nameTxt.text += LanguageMgr.GetTranslation("wishBead.StrengthenLevel");
               }
            }
            else if(_loc2_.StrengthenLevel <= PathManager.solveStrengthMax())
            {
               this._nameTxt.text += "(+" + (this._info as InventoryItemInfo).StrengthenLevel + ")";
            }
            else if(_loc2_.StrengthenLevel > PathManager.solveStrengthMax())
            {
               this._nameTxt.text += LanguageMgr.GetTranslation("store.view.exalt.goodTips",_loc2_.StrengthenLevel - 12);
            }
         }
         var _loc3_:int = this._nameTxt.text.indexOf("+");
         if(_loc3_ > 0)
         {
            _loc1_ = ComponentFactory.Instance.model.getSet("core.goodTip.ItemNameNumTxtFormat");
            this._nameTxt.setTextFormat(_loc1_,_loc3_,_loc3_ + 1);
         }
         this._nameTxt.textColor = QualityType.QUALITY_COLOR[this._info.Quality];
         var _loc4_:* = this._displayIdx++;
         this._displayList[_loc4_] = this._nameTxt;
      }
      
      private function createQualityItem() : void
      {
         var _loc1_:FilterFrameText = this._qualityItem.foreItems[0] as FilterFrameText;
         _loc1_.text = QualityType.QUALITY_STRING[this._info.Quality];
         _loc1_.textColor = QualityType.QUALITY_COLOR[this._info.Quality];
         var _loc2_:* = this._displayIdx++;
         this._displayList[_loc2_] = this._qualityItem;
         this._fusionLevelImage.x = _loc1_.x + _loc1_.width;
      }
      
      private function createCategoryItem() : void
      {
         var _loc1_:FilterFrameText = this._typeItem.foreItems[0] as FilterFrameText;
         var _loc2_:Array = EquipType.PARTNAME;
         _loc1_.text = !EquipType.PARTNAME[this._info.CategoryID] ? "" : String(EquipType.PARTNAME[this._info.CategoryID]);
         var _loc3_:* = this._displayIdx++;
         this._displayList[_loc3_] = this._typeItem;
      }
      
      private function createMainProperty() : void
      {
         var _loc11_:GoodTipInfo = null;
         var _loc1_:String = null;
         var _loc2_:TextFormat = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = "";
         var _loc6_:int = 0;
         var _loc7_:FilterFrameText = this._mainPropertyItem.foreItems[0] as FilterFrameText;
         var _loc8_:ScaleFrameImage = this._mainPropertyItem.backItem as ScaleFrameImage;
         var _loc9_:InventoryItemInfo = this._info as InventoryItemInfo;
         GhostStarContainer(this._mainPropertyItem.foreItems[1]).visible = false;
         GhostStarContainer(this._armAngleItem.foreItems[1]).visible = false;
         this._autoGhostWidth = 0;
         var _loc10_:GhostPropertyData = _loc9_ == null || _loc9_.Place > 30 || !EquipGhostManager.getInstance().isEquipGhosting() ? null : EquipGhostManager.getInstance().getPorpertyData(_loc9_,PlayerInfoViewControl.currentPlayer);
         var _loc12_:* = NaN;
         var _loc13_:* = NaN;
         var _loc14_:uint = 0;
         if((Boolean(_loc11_ = this._tipData as GoodTipInfo)) && EquipGhostManager.getInstance().isEquipGhosting())
         {
            if(_loc11_.ghostLv > 0 && _loc9_ && _loc9_.Place <= 30)
            {
               _loc10_ = EquipGhostManager.getInstance().getPropertyDataByLv(_loc9_,_loc11_.ghostLv);
            }
         }
         if(EquipType.isArm(this._info))
         {
            _loc12_ = 0;
            if(Boolean(_loc9_) && _loc9_.StrengthenLevel > 0)
            {
               _loc6_ = _loc9_.isGold ? int(_loc9_.StrengthenLevel + 1) : int(_loc9_.StrengthenLevel);
               _loc12_ = Number(StaticFormula.getHertAddition(int(_loc9_.Property7),_loc6_));
            }
            _loc8_.setFrame(1);
            _loc5_ = (_loc14_ = uint(_loc12_ + (!!_loc10_ ? _loc10_.mainProperty : 0))) > 0 ? "(+" + _loc14_ + ")" : "";
            _loc7_.text = " " + this._info.Property7.toString() + _loc5_;
            FilterFrameText(this._armAngleItem.foreItems[0]).text = "   " + this._info.Property5 + "°~" + this._info.Property6 + "°";
            var _loc15_:* = this._displayIdx++;
            this._displayList[_loc15_] = this._mainPropertyItem;
            var _loc16_:* = this._displayIdx++;
            this._displayList[_loc16_] = this._armAngleItem;
            if(_loc10_ != null)
            {
               this._ghostStartsContainer = this._armAngleItem.foreItems[1] as GhostStarContainer;
               this._ghostStartsContainer.x = this._armAngleItem.foreItems[0].width + this._armAngleItem.foreItems[0].x;
               this._ghostStartsContainer.y = this._armAngleItem.foreItems[0].y + 8;
               this._ghostStartsContainer.maxLv = EquipGhostManager.getInstance().model.topLvDic[this._info.CategoryID];
               this._ghostStartsContainer.level = _loc11_.ghostLv;
               this._ghostStartsContainer.visible = true;
               this._autoGhostWidth = this._ghostStartsContainer.x + this._ghostStartsContainer.width;
            }
         }
         else if(EquipType.isHead(this._info) || EquipType.isCloth(this._info))
         {
            _loc13_ = 0;
            if(Boolean(_loc9_) && _loc9_.StrengthenLevel > 0)
            {
               _loc6_ = _loc9_.isGold ? int(_loc9_.StrengthenLevel + 1) : int(_loc9_.StrengthenLevel);
               _loc13_ = Number(StaticFormula.getDefenseAddition(int(_loc9_.Property7),_loc6_));
            }
            _loc8_.setFrame(2);
            _loc5_ = (_loc14_ = uint(_loc13_ + (_loc10_ != null ? _loc10_.mainProperty : 0))) > 0 ? "(+" + _loc14_ + ")" : "";
            _loc7_.text = "   " + this._info.Property7.toString() + _loc5_;
            _loc15_ = this._displayIdx++;
            this._displayList[_loc15_] = this._mainPropertyItem;
            if(Boolean(_loc9_) && _loc9_.isGold)
            {
               FilterFrameText(this._otherHp.foreItems[0]).text = _loc9_.Boold.toString();
               _loc16_ = this._displayIdx++;
               this._displayList[_loc16_] = this._otherHp;
            }
            if(_loc10_ != null)
            {
               this._ghostStartsContainer = this._mainPropertyItem.foreItems[1] as GhostStarContainer;
               this._ghostStartsContainer.maxLv = EquipGhostManager.getInstance().model.topLvDic[this._info.CategoryID];
               this._ghostStartsContainer.x = this._mainPropertyItem.foreItems[0].width + this._mainPropertyItem.foreItems[0].x;
               this._ghostStartsContainer.y = this._mainPropertyItem.foreItems[0].y + 8;
               this._ghostStartsContainer.level = _loc11_.ghostLv;
               this._ghostStartsContainer.visible = true;
               this._autoGhostWidth = this._ghostStartsContainer.x + this._ghostStartsContainer.width;
            }
         }
         else if(StaticFormula.isDeputyWeapon(this._info) || this._info.CategoryID == EquipType.SPECIAL)
         {
            _loc1_ = " ";
            if(this._info.Property3 == "32")
            {
               if(Boolean(_loc9_) && _loc9_.StrengthenLevel > 0)
               {
                  _loc6_ = _loc9_.isGold ? int(_loc9_.StrengthenLevel + 1) : int(_loc9_.StrengthenLevel);
                  _loc5_ = "(+" + StaticFormula.getRecoverHPAddition(int(_loc9_.Property7),_loc6_) + ")";
               }
               _loc8_.setFrame(3);
               _loc1_ = "   ";
            }
            else
            {
               if(Boolean(_loc9_) && _loc9_.StrengthenLevel > 0)
               {
                  _loc6_ = _loc9_.isGold ? int(_loc9_.StrengthenLevel + 1) : int(_loc9_.StrengthenLevel);
                  _loc5_ = "(+" + StaticFormula.getDefenseAddition(int(_loc9_.Property7),_loc6_) + ")";
               }
               _loc8_.setFrame(4);
               _loc1_ = "            ";
            }
            _loc7_.text = _loc1_ + this._info.Property7.toString() + _loc5_;
            _loc15_ = this._displayIdx++;
            this._displayList[_loc15_] = this._mainPropertyItem;
         }
         if(Boolean(_loc7_) && _loc7_.text != "")
         {
            _loc2_ = ComponentFactory.Instance.model.getSet("ddt.store.view.exalt.LaterEquipmentViewTextTF");
            _loc3_ = _loc7_.text.indexOf("(");
            _loc4_ = _loc7_.text.indexOf(")") + 1;
            _loc7_.setTextFormat(_loc2_,_loc3_,_loc4_);
         }
      }
      
      private function createNecklaceItem() : void
      {
         if(this._info.CategoryID == 14)
         {
            this._necklaceItem.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.life") + ":" + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.advance") + this._info.Property1 + "%";
            this._necklaceItem.textColor = GoodTip.ITEM_NECKLACE_COLOR;
            var _loc1_:* = this._displayIdx++;
            this._displayList[_loc1_] = this._necklaceItem;
         }
         else if(this._info.CategoryID == EquipType.HEALSTONE)
         {
            this._necklaceItem.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.life") + ":" + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.reply") + this._info.Property2;
            this._necklaceItem.textColor = GoodTip.ITEM_NECKLACE_COLOR;
            _loc1_ = this._displayIdx++;
            this._displayList[_loc1_] = this._necklaceItem;
         }
      }
      
      private function setPurpleHtmlTxt(param1:String, param2:int, param3:String) : String
      {
         return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.setPurpleHtmlTxt",param1,param2,param3);
      }
      
      private function createProperties() : void
      {
         var _loc12_:GoodTipInfo = null;
         var _loc1_:InventoryItemInfo = null;
         var _loc2_:String = "";
         var _loc3_:String = "";
         var _loc4_:String = "";
         var _loc5_:String = "";
         var _loc6_:String = "";
         var _loc7_:String = "";
         var _loc8_:String = "";
         var _loc9_:String = "";
         if(this._info is InventoryItemInfo)
         {
            _loc1_ = this._info as InventoryItemInfo;
            if(_loc1_.AttackCompose > 0)
            {
               _loc2_ = "(+" + String(_loc1_.AttackCompose) + ")";
            }
            if(_loc1_.DefendCompose > 0)
            {
               _loc3_ = "(+" + String(_loc1_.DefendCompose) + ")";
            }
            if(_loc1_.AgilityCompose > 0)
            {
               _loc4_ = "(+" + String(_loc1_.AgilityCompose) + ")";
            }
            if(_loc1_.LuckCompose > 0)
            {
               _loc5_ = "(+" + String(_loc1_.LuckCompose) + ")";
            }
         }
         var _loc10_:InventoryItemInfo = this._info as InventoryItemInfo;
         var _loc11_:GhostPropertyData = _loc10_ == null || _loc10_.Place > 30 || !EquipGhostManager.getInstance().isEquipGhosting() ? null : EquipGhostManager.getInstance().getPorpertyData(_loc10_,PlayerInfoViewControl.currentPlayer);
         if(Boolean(_loc12_ = this._tipData as GoodTipInfo))
         {
            if(_loc12_.ghostLv > 0 && (_loc10_ != null && _loc10_.Place <= 30) && EquipGhostManager.getInstance().isEquipGhosting())
            {
               _loc11_ = EquipGhostManager.getInstance().getPropertyDataByLv(_loc10_,_loc12_.ghostLv);
            }
         }
         if(_loc11_ != null)
         {
            if(_loc11_.attack > 0)
            {
               _loc6_ = LanguageMgr.GetTranslation("equipGhost.tip",_loc11_.attack);
            }
            if(_loc11_.defend > 0)
            {
               _loc7_ = LanguageMgr.GetTranslation("equipGhost.tip",_loc11_.defend);
            }
            if(_loc11_.lucky > 0)
            {
               _loc8_ = LanguageMgr.GetTranslation("equipGhost.tip",_loc11_.lucky);
            }
            if(_loc11_.agility > 0)
            {
               _loc9_ = LanguageMgr.GetTranslation("equipGhost.tip",_loc11_.agility);
            }
         }
         if(this._info.Attack != 0)
         {
            this._attackTxt.htmlText = LanguageMgr.GetTranslation("goodTip.propertyStr",LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.fire") + ":" + String(this._info.Attack) + _loc2_) + _loc6_;
            var _loc13_:* = this._displayIdx++;
            this._displayList[_loc13_] = this._attackTxt;
         }
         if(this._info.Defence != 0)
         {
            this._defenseTxt.htmlText = LanguageMgr.GetTranslation("goodTip.propertyStr",LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.recovery") + ":" + String(this._info.Defence) + _loc3_) + _loc7_;
            _loc13_ = this._displayIdx++;
            this._displayList[_loc13_] = this._defenseTxt;
         }
         if(this._info.Agility != 0)
         {
            this._agilityTxt.htmlText = LanguageMgr.GetTranslation("goodTip.propertyStr",LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.agility") + ":" + String(this._info.Agility) + _loc4_) + _loc8_;
            _loc13_ = this._displayIdx++;
            this._displayList[_loc13_] = this._agilityTxt;
         }
         if(this._info.Luck != 0)
         {
            this._luckTxt.htmlText = LanguageMgr.GetTranslation("goodTip.propertyStr",LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.lucky") + ":" + String(this._info.Luck) + _loc5_) + _loc9_;
            _loc13_ = this._displayIdx++;
            this._displayList[_loc13_] = this._luckTxt;
         }
      }
      
      private function createHoleItem() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:FilterFrameText = null;
         var _loc8_:int = 0;
         if(!StringHelper.isNullOrEmpty(this._info.Hole))
         {
            _loc1_ = [];
            _loc2_ = this._info.Hole.split("|");
            _loc3_ = this._info as InventoryItemInfo;
            if(_loc2_.length > 0 && String(_loc2_[0]) != "" && _loc3_ != null)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_.length)
               {
                  _loc5_ = String(_loc2_[_loc4_]);
                  _loc6_ = _loc5_.split(",");
                  if(_loc4_ < 4)
                  {
                     if(int(_loc6_[0]) > 0 && int(_loc6_[0]) - _loc3_.StrengthenLevel <= 3 || this.getHole(_loc3_,_loc4_ + 1) >= 0)
                     {
                        _loc8_ = int(_loc6_[0]);
                        _loc7_ = this.createSingleHole(_loc3_,_loc4_,_loc8_,_loc6_[1]);
                        var _loc9_:* = this._displayIdx++;
                        this._displayList[_loc9_] = _loc7_;
                     }
                  }
                  else if(_loc3_["Hole" + (_loc4_ + 1) + "Level"] >= 1 || _loc3_["Hole" + (_loc4_ + 1)] > 0)
                  {
                     _loc7_ = this.createSingleHole(_loc3_,_loc4_,int.MAX_VALUE,_loc6_[1]);
                     _loc9_ = this._displayIdx++;
                     this._displayList[_loc9_] = _loc7_;
                  }
                  _loc4_++;
               }
            }
         }
      }
      
      private function createSingleHole(param1:InventoryItemInfo, param2:int, param3:int, param4:int) : FilterFrameText
      {
         var _loc5_:ItemTemplateInfo = null;
         var _loc6_:int = 0;
         var _loc7_:FilterFrameText = this._holes[param2];
         var _loc8_:int = this.getHole(param1,param2 + 1);
         if(param1.StrengthenLevel >= param3)
         {
            if(_loc8_ <= 0)
            {
               _loc7_.text = this.getHoleType(param4) + ":" + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holeenable");
               _loc7_.textColor = GoodTip.ITEM_HOLES_COLOR;
            }
            else
            {
               _loc5_ = ItemManager.Instance.getTemplateById(_loc8_);
               if(Boolean(_loc5_))
               {
                  _loc7_.text = _loc5_.Data;
                  _loc7_.textColor = GoodTip.ITEM_HOLE_RESERVE_COLOR;
               }
            }
         }
         else if(param2 >= 4)
         {
            _loc6_ = int(param1["Hole" + (param2 + 1) + "Level"]);
            if(_loc8_ > 0)
            {
               _loc5_ = ItemManager.Instance.getTemplateById(_loc8_);
               _loc7_.text = _loc5_.Data + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holeLv",param1["Hole" + (param2 + 1) + "Level"]);
               if(Math.floor(_loc5_.Level + 1 >> 1) <= _loc6_)
               {
                  _loc7_.textColor = GoodTip.ITEM_HOLE_RESERVE_COLOR;
               }
               else
               {
                  _loc7_.textColor = GoodTip.ITEM_HOLE_GREY_COLOR;
               }
            }
            else
            {
               _loc7_.text = this.getHoleType(param4) + StringHelper.format(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holeLv",param1["Hole" + (param2 + 1) + "Level"]));
               _loc7_.textColor = GoodTip.ITEM_HOLES_COLOR;
            }
         }
         else if(_loc8_ <= 0)
         {
            _loc7_.text = this.getHoleType(param4) + StringHelper.format(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holerequire"),param3.toString());
            _loc7_.textColor = GoodTip.ITEM_HOLE_GREY_COLOR;
         }
         else
         {
            _loc5_ = ItemManager.Instance.getTemplateById(_loc8_);
            if(Boolean(_loc5_))
            {
               _loc7_.text = _loc5_.Data + StringHelper.format(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holerequire"),param3.toString());
               _loc7_.textColor = GoodTip.ITEM_HOLE_GREY_COLOR;
            }
         }
         return _loc7_;
      }
      
      public function getHole(param1:InventoryItemInfo, param2:int) : int
      {
         return int(param1["Hole" + param2.toString()]);
      }
      
      private function getHoleType(param1:int) : String
      {
         switch(param1)
         {
            case 1:
               return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.trianglehole");
            case 2:
               return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.recthole");
            case 3:
               return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.ciclehole");
            default:
               return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.unknowhole");
         }
      }
      
      private function createOperationItem() : void
      {
         var _loc1_:uint = 0;
         if(this._info.NeedLevel > 1)
         {
            if(PlayerManager.Instance.Self.Grade >= this._info.NeedLevel)
            {
               _loc1_ = GoodTip.ITEM_NEED_LEVEL_COLOR;
            }
            else
            {
               _loc1_ = GoodTip.ITEM_NEED_LEVEL_FAILED_COLOR;
            }
            this._needLevelTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.need") + ":" + String(this._info.NeedLevel);
            this._needLevelTxt.textColor = _loc1_;
            var _loc3_:* = this._displayIdx++;
            this._displayList[_loc3_] = this._needLevelTxt;
         }
         if(this._info.NeedSex == 1)
         {
            this._needSexTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.man");
            this._needSexTxt.textColor = PlayerManager.Instance.Self.Sex ? uint(GoodTip.ITEM_NEED_SEX_COLOR) : uint(GoodTip.ITEM_NEED_SEX_FAILED_COLOR);
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._needSexTxt;
         }
         else if(this._info.NeedSex == 2)
         {
            this._needSexTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.woman");
            this._needSexTxt.textColor = PlayerManager.Instance.Self.Sex ? uint(GoodTip.ITEM_NEED_SEX_FAILED_COLOR) : uint(GoodTip.ITEM_NEED_SEX_COLOR);
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._needSexTxt;
         }
         var _loc2_:String = "";
         if(this._info.CanStrengthen && this._info.CanCompose)
         {
            _loc2_ = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.may");
            if(EquipType.isRongLing(this._info))
            {
               _loc2_ += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.melting");
            }
            this._upgradeType.text = _loc2_;
            this._upgradeType.textColor = GoodTip.ITEM_UPGRADE_TYPE_COLOR;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._upgradeType;
         }
         else if(this._info.CanCompose)
         {
            _loc2_ = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.compose");
            if(EquipType.isRongLing(this._info))
            {
               _loc2_ += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.melting");
            }
            this._upgradeType.text = _loc2_;
            this._upgradeType.textColor = GoodTip.ITEM_UPGRADE_TYPE_COLOR;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._upgradeType;
         }
         else if(this._info.CanStrengthen)
         {
            _loc2_ = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.strong");
            if(EquipType.isRongLing(this._info))
            {
               _loc2_ += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.melting");
            }
            this._upgradeType.text = _loc2_;
            this._upgradeType.textColor = GoodTip.ITEM_UPGRADE_TYPE_COLOR;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._upgradeType;
         }
         else if(EquipType.isRongLing(this._info))
         {
            _loc2_ += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.canmelting");
            this._upgradeType.text = _loc2_;
            this._upgradeType.textColor = GoodTip.ITEM_UPGRADE_TYPE_COLOR;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._upgradeType;
         }
      }
      
      private function createDescript() : void
      {
         if(this._info.Description == "")
         {
            return;
         }
         this._descriptionTxt.text = this._info.Description;
         this._descriptionTxt.height = this._descriptionTxt.textHeight + 10;
         var _loc1_:* = this._displayIdx++;
         this._displayList[_loc1_] = this._descriptionTxt;
      }
      
      private function ShowBound(param1:InventoryItemInfo) : Boolean
      {
         return param1.CategoryID != EquipType.SEED && param1.CategoryID != EquipType.MANURE && param1.CategoryID != EquipType.VEGETABLE;
      }
      
      private function createBindType() : void
      {
         var _loc1_:InventoryItemInfo = this._info as InventoryItemInfo;
         if(Boolean(_loc1_) && this.ShowBound(_loc1_))
         {
            this._boundImage.setFrame(_loc1_.IsBinds ? int(GoodTip.BOUND) : int(GoodTip.UNBOUND));
            PositionUtils.setPos(this._boundImage,this._bindImageOriginalPos);
            addChild(this._boundImage);
            if(!_loc1_.IsBinds)
            {
               if(_loc1_.BindType == 3)
               {
                  this._bindTypeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.bangding");
                  this._bindTypeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                  var _loc2_:* = this._displayIdx++;
                  this._displayList[_loc2_] = this._bindTypeTxt;
               }
               else if(this._info.BindType == 2)
               {
                  this._bindTypeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.zhuangbei");
                  this._bindTypeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                  _loc2_ = this._displayIdx++;
                  this._displayList[_loc2_] = this._bindTypeTxt;
               }
               else if(this._info.BindType == 4)
               {
                  if(Boolean(this._boundImage.parent))
                  {
                     this._boundImage.parent.removeChild(this._boundImage);
                  }
               }
            }
         }
         else if(Boolean(this._boundImage.parent))
         {
            this._boundImage.parent.removeChild(this._boundImage);
         }
      }
      
      private function createRemainTime() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         if(Boolean(this._remainTimeBg.parent))
         {
            this._remainTimeBg.parent.removeChild(this._remainTimeBg);
         }
         if(this._info is InventoryItemInfo)
         {
            _loc2_ = this._info as InventoryItemInfo;
            _loc3_ = _loc2_.getRemainDate();
            _loc4_ = _loc2_.getColorValidDate();
            _loc5_ = _loc2_.CategoryID == EquipType.ARM ? LanguageMgr.GetTranslation("bag.changeColor.tips.armName") : "";
            if(_loc4_ > 0 && _loc4_ != int.MAX_VALUE)
            {
               if(_loc4_ >= 1)
               {
                  this._remainTimeTxt.text = (_loc2_.IsUsed ? LanguageMgr.GetTranslation("bag.changeColor.tips.name") + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + Math.ceil(_loc4_) + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
                  this._remainTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                  var _loc7_:* = this._displayIdx++;
                  this._displayList[_loc7_] = this._remainTimeTxt;
               }
               else
               {
                  _loc6_ = Math.floor(_loc4_ * 24);
                  if(_loc6_ < 1)
                  {
                     _loc6_ = 1;
                  }
                  this._remainTimeTxt.text = (_loc2_.IsUsed ? LanguageMgr.GetTranslation("bag.changeColor.tips.name") + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + _loc6_ + LanguageMgr.GetTranslation("hours");
                  this._remainTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                  _loc7_ = this._displayIdx++;
                  this._displayList[_loc7_] = this._remainTimeTxt;
               }
            }
            if(_loc3_ == int.MAX_VALUE)
            {
               this._remainTimeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.use");
               this._remainTimeTxt.textColor = GoodTip.ITEM_ETERNAL_COLOR;
               _loc7_ = this._displayIdx++;
               this._displayList[_loc7_] = this._remainTimeTxt;
            }
            else if(_loc3_ > 0)
            {
               if(_loc3_ >= 1)
               {
                  _loc1_ = Math.ceil(_loc3_);
                  this._remainTimeTxt.text = (_loc2_.IsUsed ? _loc5_ + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + _loc1_ + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
                  this._remainTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                  _loc7_ = this._displayIdx++;
                  this._displayList[_loc7_] = this._remainTimeTxt;
               }
               else
               {
                  _loc1_ = Math.floor(_loc3_ * 24);
                  _loc1_ = _loc1_ < 1 ? Number(1) : Number(_loc1_);
                  this._remainTimeTxt.text = (_loc2_.IsUsed ? _loc5_ + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + _loc1_ + LanguageMgr.GetTranslation("hours");
                  this._remainTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                  _loc7_ = this._displayIdx++;
                  this._displayList[_loc7_] = this._remainTimeTxt;
               }
               addChild(this._remainTimeBg);
            }
            else if(!isNaN(_loc3_))
            {
               this._remainTimeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.over");
               this._remainTimeTxt.textColor = GoodTip.ITEM_PAST_DUE_COLOR;
               _loc7_ = this._displayIdx++;
               this._displayList[_loc7_] = this._remainTimeTxt;
            }
         }
      }
      
      private function createGoldRemainTime() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         if(Boolean(this._remainTimeBg.parent))
         {
            this._remainTimeBg.parent.removeChild(this._remainTimeBg);
         }
         if(this._info is InventoryItemInfo)
         {
            _loc2_ = this._info as InventoryItemInfo;
            _loc3_ = _loc2_.getGoldRemainDate();
            _loc4_ = _loc2_.goldValidDate;
            _loc5_ = _loc2_.goldBeginTime;
            if((this._info as InventoryItemInfo).isGold)
            {
               if(_loc3_ >= 1)
               {
                  _loc1_ = Math.ceil(_loc3_);
                  this._goldRemainTimeTxt.text = LanguageMgr.GetTranslation("wishBead.GoodsTipPanel.txt1") + _loc1_ + LanguageMgr.GetTranslation("wishBead.GoodsTipPanel.txt2");
               }
               else
               {
                  _loc1_ = Math.floor(_loc3_ * 24);
                  _loc1_ = _loc1_ < 1 ? Number(1) : Number(_loc1_);
                  this._goldRemainTimeTxt.text = LanguageMgr.GetTranslation("wishBead.GoodsTipPanel.txt1") + _loc1_ + LanguageMgr.GetTranslation("wishBead.GoodsTipPanel.txt3");
               }
               addChild(this._remainTimeBg);
               this._goldRemainTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
               var _loc6_:* = this._displayIdx++;
               this._displayList[_loc6_] = this._goldRemainTimeTxt;
            }
         }
      }
      
      private function createFightPropConsume() : void
      {
         if(this._info.CategoryID == EquipType.FRIGHTPROP)
         {
            this._fightPropConsumeTxt.text = " " + LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip.consume") + this._info.Property4;
            this._fightPropConsumeTxt.textColor = GoodTip.ITEM_FIGHT_PROP_CONSUME_COLOR;
            var _loc1_:* = this._displayIdx++;
            this._displayList[_loc1_] = this._fightPropConsumeTxt;
         }
      }
      
      private function createBoxTimeItem() : void
      {
         var _loc1_:Date = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(EquipType.isTimeBox(this._info))
         {
            _loc1_ = DateUtils.getDateByStr((this._info as InventoryItemInfo).BeginDate);
            _loc2_ = int(this._info.Property3) * 60 - (TimeManager.Instance.Now().getTime() - _loc1_.getTime()) / 1000;
            if(_loc2_ > 0)
            {
               _loc3_ = _loc2_ / 3600;
               _loc4_ = _loc2_ % 3600 / 60;
               _loc4_ = _loc4_ > 0 ? int(_loc4_) : int(1);
               this._boxTimeTxt.text = LanguageMgr.GetTranslation("ddt.userGuild.boxTip",_loc3_,_loc4_);
               this._boxTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
               var _loc5_:* = this._displayIdx++;
               this._displayList[_loc5_] = this._boxTimeTxt;
            }
         }
      }
      
      private function createStrenthLevel() : void
      {
         var _loc1_:InventoryItemInfo = this._info as InventoryItemInfo;
         if(Boolean(_loc1_) && _loc1_.StrengthenLevel > 0)
         {
            if(_loc1_.isGold)
            {
               this._strengthenLevelImage.setFrame(16);
            }
            else
            {
               this._strengthenLevelImage.setFrame(_loc1_.StrengthenLevel);
            }
            addChild(this._strengthenLevelImage);
            if(Boolean(this._boundImage.parent))
            {
               this._boundImage.x = this._strengthenLevelImage.x + this._strengthenLevelImage.displayWidth / 2 - this._boundImage.width / 2 - 8;
               this._boundImage.y = this._lines[0].y + 4;
            }
            this._maxWidth = Math.max(this._strengthenLevelImage.x + this._strengthenLevelImage.displayWidth,this._maxWidth);
            _width = this._tipbackgound.width = this._maxWidth + 8;
            if(Boolean(this._ghostStartsContainer))
            {
               this._ghostStartsContainer.x = this._strengthenLevelImage.x + (this._strengthenLevelImage.displayWidth - this._ghostStartsContainer.width >> 1) - 23;
               this._autoGhostWidth = this._ghostStartsContainer.x + this._ghostStartsContainer.width;
            }
         }
      }
      
      private function seperateLine() : void
      {
         var _loc1_:Image = null;
         ++this._lineIdx;
         if(this._lines.length < this._lineIdx)
         {
            _loc1_ = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
            this._lines.push(_loc1_);
         }
         var _loc2_:* = this._displayIdx++;
         this._displayList[_loc2_] = this._lines[this._lineIdx - 1];
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._rightArrows))
         {
            ObjectUtils.disposeObject(this._rightArrows);
         }
         this._rightArrows = null;
         if(Boolean(this._tipbackgound))
         {
            ObjectUtils.disposeObject(this._tipbackgound);
         }
         this._tipbackgound = null;
         if(Boolean(this._strengthenLevelImage))
         {
            ObjectUtils.disposeObject(this._strengthenLevelImage);
         }
         this._strengthenLevelImage = null;
         if(Boolean(this._fusionLevelImage))
         {
            ObjectUtils.disposeObject(this._fusionLevelImage);
         }
         this._fusionLevelImage = null;
         if(Boolean(this._boundImage))
         {
            ObjectUtils.disposeObject(this._boundImage);
         }
         this._boundImage = null;
         if(Boolean(this._nameTxt))
         {
            ObjectUtils.disposeObject(this._nameTxt);
         }
         this._nameTxt = null;
         if(Boolean(this._qualityItem))
         {
            ObjectUtils.disposeObject(this._qualityItem);
         }
         this._qualityItem = null;
         if(Boolean(this._typeItem))
         {
            ObjectUtils.disposeObject(this._typeItem);
         }
         this._typeItem = null;
         if(Boolean(this._mainPropertyItem))
         {
            ObjectUtils.disposeObject(this._mainPropertyItem);
         }
         this._mainPropertyItem = null;
         if(Boolean(this._armAngleItem))
         {
            ObjectUtils.disposeObject(this._armAngleItem);
         }
         this._armAngleItem = null;
         if(Boolean(this._otherHp))
         {
            ObjectUtils.disposeObject(this._otherHp);
         }
         this._otherHp = null;
         if(Boolean(this._necklaceItem))
         {
            ObjectUtils.disposeObject(this._necklaceItem);
         }
         this._necklaceItem = null;
         if(Boolean(this._attackTxt))
         {
            ObjectUtils.disposeObject(this._attackTxt);
         }
         this._attackTxt = null;
         if(Boolean(this._defenseTxt))
         {
            ObjectUtils.disposeObject(this._defenseTxt);
         }
         this._defenseTxt = null;
         if(Boolean(this._agilityTxt))
         {
            ObjectUtils.disposeObject(this._agilityTxt);
         }
         this._agilityTxt = null;
         if(Boolean(this._luckTxt))
         {
            ObjectUtils.disposeObject(this._luckTxt);
         }
         this._luckTxt = null;
         ObjectUtils.disposeObject(this._enchantLevelTxt);
         this._enchantLevelTxt = null;
         ObjectUtils.disposeObject(this._enchantAttackTxt);
         this._enchantAttackTxt = null;
         ObjectUtils.disposeObject(this._enchantDefenceTxt);
         this._enchantDefenceTxt = null;
         if(Boolean(this._needLevelTxt))
         {
            ObjectUtils.disposeObject(this._needLevelTxt);
         }
         this._needLevelTxt = null;
         if(Boolean(this._needSexTxt))
         {
            ObjectUtils.disposeObject(this._needSexTxt);
         }
         this._needSexTxt = null;
         if(Boolean(this._upgradeType))
         {
            ObjectUtils.disposeObject(this._upgradeType);
         }
         this._upgradeType = null;
         if(Boolean(this._descriptionTxt))
         {
            ObjectUtils.disposeObject(this._descriptionTxt);
         }
         this._descriptionTxt = null;
         if(Boolean(this._bindTypeTxt))
         {
            ObjectUtils.disposeObject(this._bindTypeTxt);
         }
         this._bindTypeTxt = null;
         if(Boolean(this._remainTimeTxt))
         {
            ObjectUtils.disposeObject(this._remainTimeTxt);
         }
         this._remainTimeTxt = null;
         if(Boolean(this._goldRemainTimeTxt))
         {
            ObjectUtils.disposeObject(this._goldRemainTimeTxt);
         }
         this._goldRemainTimeTxt = null;
         if(Boolean(this._fightPropConsumeTxt))
         {
            ObjectUtils.disposeObject(this._fightPropConsumeTxt);
         }
         this._fightPropConsumeTxt = null;
         if(Boolean(this._boxTimeTxt))
         {
            ObjectUtils.disposeObject(this._boxTimeTxt);
         }
         this._boxTimeTxt = null;
         if(Boolean(this._limitGradeTxt))
         {
            ObjectUtils.disposeObject(this._limitGradeTxt);
         }
         this._limitGradeTxt = null;
         if(Boolean(this._remainTimeBg))
         {
            ObjectUtils.disposeObject(this._remainTimeBg);
         }
         this._remainTimeBg = null;
         if(Boolean(this._tipbackgound))
         {
            ObjectUtils.disposeObject(this._tipbackgound);
         }
         this._tipbackgound = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
