package gemstone.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import ddt.manager.LanguageMgr;
   import ddt.view.SimpleItem;
   import flash.display.DisplayObject;
   import gemstone.info.GemstoneStaticInfo;
   
   public class GemstoneTip extends BaseTip
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _tempData:Object;
      
      private var _fiSoulName:FilterFrameText;
      
      private var _quality:SimpleItem;
      
      private var _type:SimpleItem;
      
      private var _attack:FilterFrameText;
      
      private var _defense:FilterFrameText;
      
      private var _agility:FilterFrameText;
      
      private var _luck:FilterFrameText;
      
      private var _grade1:FilterFrameText;
      
      private var _grade2:FilterFrameText;
      
      private var _grade3:FilterFrameText;
      
      private var _forever:FilterFrameText;
      
      private var _displayList:Vector.<DisplayObject>;
      
      public function GemstoneTip()
      {
         super();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
      }
      
      override public function set tipData(param1:Object) : void
      {
         this._tempData = param1;
         if(!this._tempData)
         {
            return;
         }
         this._displayList = new Vector.<DisplayObject>();
         this.updateView();
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
      
      private function updateView() : void
      {
         var _loc1_:GemstonTipItem = null;
         var _loc2_:Object = null;
         this.clear();
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this._bg.width = 300;
         this._bg.height = 200;
         this.tipbackgound = this._bg;
         this._fiSoulName = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameTxt");
         this._displayList.push(this._fiSoulName);
         var _loc3_:Vector.<GemstoneStaticInfo> = this._tempData as Vector.<GemstoneStaticInfo>;
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         var _loc6_:String = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.GoldenAddAttack");
         var _loc7_:String = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.GoldenReduceDamage");
         while(_loc5_ < _loc4_)
         {
            if(_loc3_[_loc5_].attack != 0)
            {
               _loc2_ = new Object();
               _loc2_.id = _loc3_[_loc5_].id;
               if(_loc3_[_loc5_].level == 6)
               {
                  _loc2_.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstoneAtc",String(_loc3_[_loc5_].attack) + _loc6_);
               }
               else
               {
                  _loc2_.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.redGemstoneAtc",_loc3_[_loc5_].level,String(_loc3_[_loc5_].attack));
               }
               this._fiSoulName.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.redGemstone");
               _loc1_ = new GemstonTipItem();
               _loc1_.setInfo(_loc2_);
               this._displayList.push(_loc1_);
            }
            else if(_loc3_[_loc5_].defence != 0)
            {
               this._fiSoulName.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.bluGemstone");
               _loc2_ = new Object();
               _loc2_.id = _loc3_[_loc5_].id;
               if(_loc3_[_loc5_].level == 6)
               {
                  _loc2_.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstoneDef",String(_loc3_[_loc5_].defence) + _loc7_);
               }
               else
               {
                  _loc2_.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.bluGemstoneDef",_loc3_[_loc5_].level,String(_loc3_[_loc5_].defence));
               }
               _loc1_ = new GemstonTipItem();
               _loc1_.setInfo(_loc2_);
               this._displayList.push(_loc1_);
            }
            else if(_loc3_[_loc5_].agility != 0)
            {
               this._fiSoulName.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.gesGemstone");
               _loc2_ = new Object();
               _loc2_.id = _loc3_[_loc5_].id;
               if(_loc3_[_loc5_].level == 6)
               {
                  _loc2_.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstoneAgi",String(_loc3_[_loc5_].agility) + _loc6_);
               }
               else
               {
                  _loc2_.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.gesGemstoneAgi",_loc3_[_loc5_].level,String(_loc3_[_loc5_].agility));
               }
               _loc1_ = new GemstonTipItem();
               _loc1_.setInfo(_loc2_);
               this._displayList.push(_loc1_);
            }
            else if(_loc3_[_loc5_].luck != 0)
            {
               this._fiSoulName.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.yelGemstone");
               _loc2_ = new Object();
               _loc2_.id = _loc3_[_loc5_].id;
               if(_loc3_[_loc5_].level == 6)
               {
                  _loc2_.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstoneLuk",String(_loc3_[_loc5_].luck) + _loc7_);
               }
               else
               {
                  _loc2_.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.yelGemstoneLuk",_loc3_[_loc5_].level,String(_loc3_[_loc5_].luck));
               }
               _loc1_ = new GemstonTipItem();
               _loc1_.setInfo(_loc2_);
               this._displayList.push(_loc1_);
            }
            else if(_loc3_[_loc5_].blood != 0)
            {
               this._fiSoulName.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.purpleGemstone");
               _loc2_ = new Object();
               _loc2_.id = _loc3_[_loc5_].id;
               if(_loc3_[_loc5_].level == 6)
               {
                  _loc2_.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstoneHp",String(_loc3_[_loc5_].blood) + _loc7_);
               }
               else
               {
                  _loc2_.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.purpleGemstoneLuk",_loc3_[_loc5_].level,String(_loc3_[_loc5_].blood));
               }
               _loc1_ = new GemstonTipItem();
               _loc1_.setInfo(_loc2_);
               this._displayList.push(_loc1_);
            }
            _loc5_++;
         }
         this.initPos();
      }
      
      override public function get tipData() : Object
      {
         return this._tempData;
      }
      
      override protected function init() : void
      {
      }
      
      private function initPos() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = int(this._displayList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this._displayList[_loc1_].y = _loc1_ * 30 + 5;
            this._displayList[_loc1_].x = 5;
            addChild(this._displayList[_loc1_] as DisplayObject);
            _loc1_++;
         }
         if(this._displayList.length > 0)
         {
            this._bg.height = this._displayList[this._displayList.length - 1].y + 40;
         }
         else
         {
            this._bg.height = 40;
         }
      }
   }
}
