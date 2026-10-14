package game.view.control
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.LivingEvent;
   import ddt.utils.PositionUtils;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.model.LocalPlayer;
   import game.objects.SimpleBox;
   
   public class PsychicBar extends Sprite implements Disposeable
   {
       
      
      private var _self:LocalPlayer;
      
      private var _back:DisplayObject;
      
      private var _localPsychic:int;
      
      private var _numField:PsychicShape;
      
      private var _movie:MovieClip;
      
      private var _ghostBoxCenter:Point;
      
      private var _ghostBitmapPool:Object;
      
      private var _mouseArea:MouseArea;
      
      public function PsychicBar(param1:LocalPlayer)
      {
         this._ghostBitmapPool = new Object();
         this._self = param1;
         super();
         this.configUI();
         mouseEnabled = false;
      }
      
      private function configUI() : void
      {
         this._back = ComponentFactory.Instance.creatBitmap("asset.game.PsychicBar.back");
         addChild(this._back);
         this._ghostBoxCenter = new Point((this._back.width >> 1) - 20,(this._back.height >> 1) - 20);
         this._movie = ClassUtils.CreatInstance("asset.game.PsychicBar.movie");
         this._movie.mouseChildren = this._movie.mouseEnabled = false;
         PositionUtils.setPos(this._movie,"PsychicBar.MoviePos");
         addChild(this._movie);
         this._numField = new PsychicShape();
         this._numField.setNum(this._self.psychic);
         this._numField.x = this._back.width - this._numField.width >> 1;
         this._numField.y = this._back.height - this._numField.height >> 1;
         addChild(this._numField);
         this._mouseArea = new MouseArea(48);
         addChild(this._mouseArea);
      }
      
      private function addEvent() : void
      {
         this._self.addEventListener(LivingEvent.PSYCHIC_CHANGED,this.__psychicChanged);
         this._self.addEventListener(LivingEvent.BOX_PICK,this.__pickBox);
      }
      
      private function boxTweenComplete(param1:DisplayObject) : void
      {
         ObjectUtils.disposeObject(param1);
      }
      
      private function __pickBox(param1:LivingEvent) : void
      {
         var _loc2_:Shape = null;
         var _loc3_:Rectangle = null;
         _loc2_ = null;
         _loc3_ = null;
         var _loc4_:SimpleBox = param1.paras[0] as SimpleBox;
         if(_loc4_.isGhost)
         {
            _loc2_ = this.getGhostShape(_loc4_.subType);
            addChild(_loc2_);
            _loc3_ = _loc4_.getBounds(this);
            _loc2_.x = _loc3_.x;
            _loc2_.y = _loc3_.y;
            TweenLite.to(_loc2_,0.3 + 0.3 * Math.random(),{
               "x":this._ghostBoxCenter.x,
               "y":this._ghostBoxCenter.y,
               "onComplete":this.boxTweenComplete,
               "onCompleteParams":[_loc2_]
            });
         }
      }
      
      private function __psychicChanged(param1:LivingEvent) : void
      {
         this._numField.setNum(this._self.psychic);
         this._numField.x = this._back.width - this._numField.width >> 1;
         this._mouseArea.setPsychic(this._self.psychic);
      }
      
      private function removeEvent() : void
      {
         this._self.removeEventListener(LivingEvent.PSYCHIC_CHANGED,this.__psychicChanged);
         this._self.removeEventListener(LivingEvent.BOX_PICK,this.__pickBox);
      }
      
      public function enter() : void
      {
         this.addEvent();
      }
      
      public function leaving() : void
      {
         this.removeEvent();
      }
      
      public function dispose() : void
      {
         var _loc1_:* = null;
         var _loc2_:BitmapData = null;
         this.removeEvent();
         TweenLite.killTweensOf(this);
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._numField);
         this._numField = null;
         ObjectUtils.disposeObject(this._mouseArea);
         this._mouseArea = null;
         if(Boolean(this._movie))
         {
            this._movie.stop();
            ObjectUtils.disposeObject(this._movie);
            this._movie = null;
         }
         this._self = null;
         for(_loc1_ in this._ghostBitmapPool)
         {
            _loc2_ = this._ghostBitmapPool[_loc1_] as BitmapData;
            if(Boolean(_loc2_))
            {
               _loc2_.dispose();
            }
            delete this._ghostBitmapPool[_loc1_];
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function getGhostShape(param1:int) : Shape
      {
         var _loc2_:BitmapData = null;
         var _loc3_:MovieClip = null;
         var _loc4_:Shape = new Shape();
         var _loc5_:String = "ghost" + param1;
         if(this._ghostBitmapPool.hasOwnProperty(_loc5_))
         {
            _loc2_ = this._ghostBitmapPool[_loc5_];
         }
         else
         {
            _loc3_ = ClassUtils.CreatInstance("asset.game.GhostBox" + (param1 - 1)) as MovieClip;
            _loc3_.gotoAndStop("shot");
            _loc2_ = new BitmapData(_loc3_.width,_loc3_.height,true,0);
            _loc2_.draw(_loc3_);
            this._ghostBitmapPool[_loc5_] = _loc2_;
         }
         var _loc6_:Graphics = _loc4_.graphics;
         _loc6_.beginBitmapFill(_loc2_);
         _loc6_.drawRect(0,0,_loc2_.width,_loc2_.height);
         _loc6_.endFill();
         return _loc4_;
      }
   }
}

import com.pickgliss.ui.core.Disposeable;
import com.pickgliss.utils.ObjectUtils;
import ddt.display.BitmapShape;
import ddt.manager.BitmapManager;
import flash.display.Sprite;

class PsychicShape extends Sprite implements Disposeable
{
    
   
   private var _nums:Vector.<BitmapShape>;
   
   private var _num:int = 0;
   
   private var _bitmapMgr:BitmapManager;
   
   public function PsychicShape()
   {
      this._nums = new Vector.<BitmapShape>();
      super();
      this._bitmapMgr = BitmapManager.getBitmapMgr(BitmapManager.GameView);
      mouseChildren = mouseEnabled = false;
      this.draw();
   }
   
   private function draw() : void
   {
      var _loc1_:BitmapShape = null;
      this.clear();
      var _loc2_:String = String(this._num.toString());
      var _loc3_:int = _loc2_.length;
      var _loc4_:int = 0;
      while(_loc4_ < _loc3_)
      {
         _loc1_ = this._bitmapMgr.creatBitmapShape("asset.game.PsychicBar.Num" + _loc2_.substr(_loc4_,1));
         if(_loc4_ > 0)
         {
            _loc1_.x = this._nums[_loc4_ - 1].x + this._nums[_loc4_ - 1].width;
         }
         addChild(_loc1_);
         this._nums.push(_loc1_);
         _loc4_++;
      }
   }
   
   private function clear() : void
   {
      var _loc1_:BitmapShape = this._nums.shift();
      while(Boolean(_loc1_))
      {
         _loc1_.dispose();
         _loc1_ = this._nums.shift();
      }
   }
   
   public function setNum(param1:int) : void
   {
      if(this._num != param1)
      {
         this._num = param1;
         this.draw();
      }
   }
   
   public function dispose() : void
   {
      this.clear();
      ObjectUtils.disposeObject(this._bitmapMgr);
      this._bitmapMgr = null;
      if(Boolean(parent))
      {
         parent.removeChild(this);
      }
   }
}

import com.pickgliss.ui.ComponentFactory;
import com.pickgliss.ui.LayerManager;
import com.pickgliss.ui.core.Disposeable;
import com.pickgliss.utils.ObjectUtils;
import ddt.manager.LanguageMgr;
import ddt.view.tips.ChangeNumToolTip;
import ddt.view.tips.ChangeNumToolTipInfo;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import game.model.Player;

class MouseArea extends Sprite implements Disposeable
{
    
   
   private var _tipData:String;
   
   private var _tipPanel:ChangeNumToolTip;
   
   private var _tipInfo:ChangeNumToolTipInfo;
   
   public function MouseArea(param1:int)
   {
      super();
      var _loc2_:Graphics = graphics;
      _loc2_.beginFill(0,0);
      _loc2_.drawCircle(param1,param1,param1);
      _loc2_.endFill();
      this.addTip();
      this.addEvent();
   }
   
   public function setPsychic(param1:int) : void
   {
      this._tipInfo.current = param1;
      this._tipPanel.tipData = this._tipInfo;
   }
   
   private function addEvent() : void
   {
      addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
      addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
   }
   
   private function removeEvent() : void
   {
      removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
      removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
   }
   
   public function dispose() : void
   {
      this.removeEvent();
      this.__mouseOut(null);
      ObjectUtils.disposeObject(this._tipPanel);
      this._tipPanel = null;
      if(Boolean(parent))
      {
         parent.removeChild(this);
      }
   }
   
   private function addTip() : void
   {
      this._tipPanel = new ChangeNumToolTip();
      this._tipInfo = new ChangeNumToolTipInfo();
      this._tipInfo.currentTxt = ComponentFactory.Instance.creatComponentByStylename("game.DanderStrip.currentTxt");
      this._tipInfo.title = LanguageMgr.GetTranslation("tank.game.PsychicBar.Title");
      this._tipInfo.current = 0;
      this._tipInfo.total = Player.MaxPsychic;
      this._tipInfo.content = LanguageMgr.GetTranslation("tank.game.PsychicBar.Content");
      this._tipPanel.tipData = this._tipInfo;
      this._tipPanel.mouseChildren = false;
      this._tipPanel.mouseEnabled = false;
   }
   
   private function __mouseOut(param1:MouseEvent) : void
   {
      if(Boolean(this._tipPanel) && Boolean(this._tipPanel.parent))
      {
         this._tipPanel.parent.removeChild(this._tipPanel);
      }
   }
   
   private function __mouseOver(param1:MouseEvent) : void
   {
      var _loc2_:Rectangle = null;
      _loc2_ = getBounds(LayerManager.Instance.getLayerByType(LayerManager.STAGE_TOP_LAYER));
      this._tipPanel.x = _loc2_.right;
      this._tipPanel.y = _loc2_.top - this._tipPanel.height;
      LayerManager.Instance.addToLayer(this._tipPanel,LayerManager.STAGE_TOP_LAYER,false);
   }
}
