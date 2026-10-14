package cryptBoss.view
{
   import com.pickgliss.events.ComponentEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import cryptBoss.data.CryptBossItemInfo;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CryptBossItem extends Sprite implements Disposeable
   {
       
      
      private var _info:CryptBossItemInfo;
      
      private var _iconMovie:MovieClip;
      
      private var _clickSp:Sprite;
      
      private var _lightStarVec:Vector.<Bitmap>;
      
      private var _isOpen:Boolean;
      
      private var _setFrame:cryptBoss.view.CryptBossSetFrame;
      
      public function CryptBossItem(param1:CryptBossItemInfo)
      {
         super();
         this._info = param1;
         this._lightStarVec = new Vector.<Bitmap>();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:* = null;
         var _loc8_:Array = this._info.openWeekDaysArr;
         var _loc9_:int = TimeManager.Instance.currentDay;
         _loc5_ = 0;
         while(_loc5_ < _loc8_.length)
         {
            if(_loc8_[_loc5_] == _loc9_)
            {
               this._isOpen = true;
               break;
            }
            _loc5_++;
         }
         this._iconMovie = ComponentFactory.Instance.creat("asset.cryptBoss.light.icon" + this._info.id);
         this._clickSp = new Sprite();
         if(this._isOpen)
         {
            _loc1_ = "cryptBoss.open.starPos";
            _loc2_ = 25;
            _loc3_ = 166;
            _loc4_ = 170;
            this._iconMovie.gotoAndStop(2);
            PositionUtils.setPos(this,"cryptBoss.open.itemPos" + this._info.id);
         }
         else
         {
            _loc1_ = "cryptBoss.notOpen.starPos";
            _loc2_ = 24;
            _loc3_ = _loc4_ = 100;
            this._iconMovie.gotoAndStop(1);
            PositionUtils.setPos(this,"cryptBoss.notOpen.itemPos" + this._info.id);
         }
         this._clickSp.graphics.beginFill(16777215,0);
         this._clickSp.graphics.drawRect(0,0,_loc3_,_loc4_);
         this._clickSp.graphics.endFill();
         this._clickSp.buttonMode = true;
         addChild(this._iconMovie);
         addChild(this._clickSp);
         _loc6_ = 0;
         while(_loc6_ < this._info.star)
         {
            _loc7_ = ComponentFactory.Instance.creat("asset.cryptBoss.star");
            if(_loc6_ == 0)
            {
               PositionUtils.setPos(_loc7_,_loc1_);
            }
            else
            {
               _loc7_.x += this._lightStarVec[0].x + _loc6_ * _loc2_;
               _loc7_.y = this._lightStarVec[0].y;
            }
            addChild(_loc7_);
            this._lightStarVec.push(_loc7_);
            _loc6_++;
         }
      }
      
      private function initEvent() : void
      {
         this._clickSp.addEventListener("click",this.__fightSetHandler);
      }
      
      public function get info() : CryptBossItemInfo
      {
         return this._info;
      }
      
      protected function __fightSetHandler(param1:MouseEvent) : void
      {
         if(!this._isOpen)
         {
            return;
         }
         SoundManager.instance.playButtonSound();
         this._setFrame = ComponentFactory.Instance.creatCustomObject("CryptBossSetFrame",[this._info]);
         this._setFrame.addEventListener("dispose",this.frameDisposeHandler,false,0,true);
         LayerManager.Instance.addToLayer(this._setFrame,3,true,1);
      }
      
      private function frameDisposeHandler(param1:ComponentEvent) : void
      {
         if(Boolean(this._setFrame))
         {
            this._setFrame.removeEventListener("dispose",this.frameDisposeHandler);
         }
         this._setFrame = null;
      }
      
      private function removeEvent() : void
      {
         this._clickSp.removeEventListener("click",this.__fightSetHandler);
      }
      
      public function dispose() : void
      {
         var _loc1_:* = undefined;
         this.removeEvent();
         this._iconMovie.stop();
         removeChild(this._iconMovie);
         this._iconMovie = null;
         for each(_loc1_ in this._lightStarVec)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         this._clickSp.graphics.clear();
         removeChild(this._clickSp);
         this._info = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
