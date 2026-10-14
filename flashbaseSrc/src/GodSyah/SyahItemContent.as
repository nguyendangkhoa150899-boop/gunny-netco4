package GodSyah
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class SyahItemContent extends Sprite
   {
       
      
      private var _leftBtn:BaseButton;
      
      private var _rightBtn:BaseButton;
      
      private var _cellVec:Vector.<GodSyah.SyahSelfCell>;
      
      private var _index:int = -1;
      
      private var _content:Sprite;
      
      private var _alphaArr:Array;
      
      private var _tip:ScaleBitmapImage;
      
      private var _txt:FilterFrameText;
      
      public function SyahItemContent()
      {
         this._cellVec = new Vector.<SyahSelfCell>();
         super();
         this._buildUI();
         this._addEvent();
         this.showContent();
         this._configEvent();
      }
      
      private function _buildUI() : void
      {
         var _loc1_:GodSyah.SyahSelfCell = null;
         this._leftBtn = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahView.leftBtn");
         this._rightBtn = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahView.rightBtn");
         this._content = new Sprite();
         addChild(this._leftBtn);
         addChild(this._rightBtn);
         addChild(this._content);
         var _loc2_:Vector.<SyahMode> = SyahManager.Instance.syahItemVec;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc1_ = ComponentFactory.Instance.creatCustomObject("godSyah.syahview.syahselfcell");
            _loc1_.shineEnable = _loc2_[_loc3_].isHold && _loc2_[_loc3_].isValid;
            _loc1_.info = SyahManager.Instance.cellItems[_loc3_];
            this._cellVec.push(_loc1_);
            _loc3_++;
         }
         if(this._cellVec.length < 7)
         {
            this._leftBtn.visible = false;
            this._rightBtn.visible = false;
         }
      }
      
      private function _addEvent() : void
      {
         this._leftBtn.addEventListener(MouseEvent.CLICK,this.__changeItem);
         this._rightBtn.addEventListener(MouseEvent.CLICK,this.__changeItem);
      }
      
      private function __changeItem(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = 0;
         _loc3_ = 0;
         _loc2_ = 0;
         var _loc4_:int = 0;
         _loc3_ = 0;
         var _loc5_:int = 0;
         switch(param1.target)
         {
            case this._leftBtn:
               if(this._index > 5)
               {
                  this._removeAllChild();
                  _loc2_ = this._index - 6;
                  _loc4_ = 0;
                  while(_loc4_ < 6)
                  {
                     this._content.addChild(this._cellVec[_loc2_]);
                     this._cellVec[_loc2_].x = 4 + _loc4_ * 57;
                     this._cellVec[_loc2_].y = 4;
                     if(SyahManager.Instance.getSyahModeByInfo(this._cellVec[_loc2_].info).isHold == false)
                     {
                        this._alphaArr[_loc4_].visible = true;
                        this._alphaArr[_loc4_].ishold = false;
                     }
                     else if(SyahManager.Instance.getSyahModeByInfo(this._cellVec[_loc2_].info).isValid == false)
                     {
                        this._alphaArr[_loc4_].visible = true;
                        this._alphaArr[_loc4_].isvalid = false;
                     }
                     else
                     {
                        this._alphaArr[_loc4_].visible = false;
                     }
                     _loc2_++;
                     _loc4_++;
                  }
                  --this._index;
               }
               break;
            case this._rightBtn:
               if(this._index + 1 != this._cellVec.length)
               {
                  this._removeAllChild();
                  _loc3_ = this._index - 4;
                  _loc5_ = 0;
                  while(_loc5_ < 6)
                  {
                     this._content.addChild(this._cellVec[_loc3_]);
                     this._cellVec[_loc3_].x = 4 + _loc5_ * 57;
                     this._cellVec[_loc3_].y = 4;
                     if(SyahManager.Instance.getSyahModeByInfo(this._cellVec[_loc3_].info).isHold == false)
                     {
                        this._alphaArr[_loc5_].visible = true;
                        this._alphaArr[_loc5_].ishold = false;
                     }
                     else if(SyahManager.Instance.getSyahModeByInfo(this._cellVec[_loc3_].info).isValid == false)
                     {
                        this._alphaArr[_loc5_].visible = true;
                        this._alphaArr[_loc5_].isvalid = false;
                     }
                     else
                     {
                        this._alphaArr[_loc5_].visible = false;
                     }
                     _loc3_++;
                     _loc5_++;
                  }
                  ++this._index;
               }
         }
      }
      
      public function showContent() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         _loc1_ = 0;
         _loc2_ = null;
         _loc1_ = 0;
         _loc2_ = null;
         this._alphaArr = new Array();
         _loc1_ = 0;
         while(_loc1_ < this._cellVec.length)
         {
            if(this._index >= 5)
            {
               return;
            }
            this._content.addChild(this._cellVec[_loc1_]);
            this._cellVec[_loc1_].x = 4 + _loc1_ * 57;
            this._cellVec[_loc1_].y = 4;
            ++this._index;
            _loc2_ = new MovieClip();
            _loc2_.graphics.beginFill(16711680,0);
            _loc2_.graphics.drawRect(0,0,47,47);
            _loc2_.graphics.endFill();
            addChild(_loc2_);
            _loc2_.visible = false;
            _loc2_.x = 3 + _loc1_ * 57;
            _loc2_.y = 3;
            this._alphaArr[_loc1_] = _loc2_;
            _loc2_.ishold = _loc2_.isvalid = true;
            if(SyahManager.Instance.getSyahModeByInfo(this._cellVec[_loc1_].info).isHold == false)
            {
               _loc2_.visible = true;
               _loc2_.ishold = false;
            }
            else if(SyahManager.Instance.getSyahModeByInfo(this._cellVec[_loc1_].info).isValid == false)
            {
               _loc2_.visible = true;
               _loc2_.isvalid = false;
            }
            _loc1_++;
         }
      }
      
      private function _configEvent() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._alphaArr.length)
         {
            this._alphaArr[_loc1_].addEventListener(MouseEvent.MOUSE_OVER,this.__overAlphaArea);
            this._alphaArr[_loc1_].addEventListener(MouseEvent.MOUSE_OUT,this.__outAlphaArea);
            _loc1_++;
         }
      }
      
      private function __overAlphaArea(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = null;
         _loc2_ = null;
         _loc2_ = param1.target as MovieClip;
         if(this._tip == null)
         {
            this._tip = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
         }
         if(this._txt == null)
         {
            this._txt = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahview.tip.txt");
         }
         if(_loc2_.ishold == false)
         {
            this._txt.text = LanguageMgr.GetTranslation("ddt.GodSyah.syahview.tiptext1");
         }
         else if(_loc2_.isvalid == false)
         {
            this._txt.text = LanguageMgr.GetTranslation("ddt.GodSyah.syahview.tiptext2");
         }
         this._txt.x = 10;
         this._txt.y = 10;
         this._tip.width = this._txt.width + 10;
         this._tip.height = this._txt.height + 20;
         this._tip.x = _loc2_.x + _loc2_.width / 2 - this._tip.width / 2;
         this._tip.y = _loc2_.y - this._tip.height - 10;
         this._tip.addChild(this._txt);
         addChild(this._tip);
      }
      
      private function __outAlphaArea(param1:MouseEvent) : void
      {
         if(Boolean(this._tip))
         {
            this._txt.text = "";
            this._txt = null;
            removeChild(this._tip);
            this._tip = null;
         }
      }
      
      private function _removeAllChild() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._content.numChildren)
         {
            this._content.removeChildAt(0);
            _loc1_++;
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._leftBtn))
         {
            ObjectUtils.disposeObject(this._leftBtn);
            this._leftBtn = null;
         }
         if(Boolean(this._rightBtn))
         {
            ObjectUtils.disposeObject(this._rightBtn);
            this._rightBtn = null;
         }
         if(Boolean(this._content))
         {
            ObjectUtils.disposeObject(this._content);
            this._content = null;
         }
         if(Boolean(this._tip))
         {
            ObjectUtils.disposeObject(this._tip);
            this._tip = null;
         }
         if(Boolean(this._txt))
         {
            ObjectUtils.disposeObject(this._txt);
            this._txt = null;
         }
      }
   }
}
