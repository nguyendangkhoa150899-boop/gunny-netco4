package ddt.manager
{
   import bagAndInfo.cell.BaseCell;
   import com.greensock.TimelineLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Sine;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.TweenVars;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import road7th.utils.MovieClipWrapper;
   
   public class DropGoodsManager implements Disposeable
   {
      
      private static var _isEmailAniam:Boolean = true;
       
      
      public var parentContainer:DisplayObjectContainer;
      
      public var beginPoint:Point;
      
      public var endPoint:Point;
      
      private var goodsList:Vector.<ItemTemplateInfo>;
      
      private var timeOutIdArr:Array;
      
      private var tweenArr:Array;
      
      private var intervalId:uint;
      
      private var goodsTipList:Vector.<ItemTemplateInfo>;
      
      private var _info:InventoryItemInfo;
      
      public function DropGoodsManager(param1:Point, param2:Point)
      {
         super();
         this.parentContainer = StageReferance.stage;
         this.beginPoint = param1;
         this.endPoint = param2;
         this.goodsList = new Vector.<ItemTemplateInfo>();
         this.goodsTipList = new Vector.<ItemTemplateInfo>();
         this.timeOutIdArr = new Array();
         this.tweenArr = new Array();
      }
      
      public static function play(param1:Array, param2:Point = null, param3:Point = null, param4:Boolean = false) : void
      {
         var _loc5_:ItemTemplateInfo = null;
         var _loc6_:BaseCell = null;
         var _loc7_:uint = 0;
         _isEmailAniam = param4;
         if(param2 == null)
         {
            param2 = ComponentFactory.Instance.creatCustomObject("dropGoodsManager.beginPoint");
         }
         if(param3 == null)
         {
            param3 = ComponentFactory.Instance.creatCustomObject("dropGoodsManager.bagPoint");
         }
         var _loc8_:DropGoodsManager = new DropGoodsManager(param2,param3);
         _loc8_.setGoodsList(param1);
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_.goodsList.length)
         {
            _loc5_ = _loc8_.goodsList[_loc9_];
            _loc6_ = new BaseCell(new Sprite(),_loc5_);
            _loc6_.setContentSize(48,48);
            _loc7_ = setTimeout(_loc8_.packUp,200 + _loc9_ * 200,_loc6_,_loc8_.onCompletePackUp);
            _loc8_.timeOutIdArr.push(_loc7_);
            _loc9_++;
         }
      }
      
      private function onPetCompletePackUp(param1:DisplayObject) : void
      {
         ObjectUtils.disposeObject(param1);
         this.dispose();
      }
      
      private function packUp(param1:DisplayObject, param2:Function) : void
      {
         clearTimeout(this.timeOutIdArr.shift());
         param1.x = this.beginPoint.x;
         param1.y = this.beginPoint.y;
         param1.alpha = 0.5;
         param1.scaleX = 0.85;
         param1.scaleY = 0.85;
         this.parentContainer.addChild(param1);
         var _loc3_:Point = this.endPoint;
         var _loc4_:Point = new Point(this.beginPoint.x - (this.beginPoint.x - _loc3_.x) / 2,this.beginPoint.y - 100);
         var _loc5_:Point = new Point(_loc4_.x - (_loc4_.x - this.beginPoint.x) / 2,this.beginPoint.y - 60);
         var _loc6_:Point = new Point(_loc3_.x - (_loc3_.x - _loc4_.x) / 2,this.beginPoint.y + 30);
         var _loc7_:TweenVars = ComponentFactory.Instance.creatCustomObject("dropGoodsManager.tweenVars1") as TweenVars;
         var _loc8_:TweenVars = ComponentFactory.Instance.creatCustomObject("dropGoodsManager.tweenVars2") as TweenVars;
         var _loc9_:TimelineLite = new TimelineLite();
         _loc9_.append(TweenMax.to(param1,_loc7_.duration,{
            "alpha":_loc7_.alpha,
            "scaleX":_loc7_.scaleX,
            "scaleY":_loc7_.scaleY,
            "bezierThrough":[{
               "x":_loc5_.x,
               "y":_loc5_.y
            },{
               "x":_loc4_.x,
               "y":_loc4_.y
            }],
            "ease":Sine.easeInOut
         }));
         _loc9_.append(TweenMax.to(param1,_loc8_.duration,{
            "alpha":_loc8_.alpha,
            "scaleX":_loc8_.scaleX,
            "scaleY":_loc8_.scaleY,
            "bezierThrough":[{
               "x":_loc6_.x,
               "y":_loc6_.y
            },{
               "x":_loc3_.x,
               "y":_loc3_.y
            }],
            "ease":Sine.easeInOut,
            "onComplete":param2,
            "onCompleteParams":[param1]
         }));
         this.tweenArr.push(_loc9_);
      }
      
      private function onCompletePackUp(param1:DisplayObject) : void
      {
         var _loc2_:MovieClipWrapper = null;
         var _loc3_:MovieClipWrapper = null;
         if(Boolean(param1) && this.parentContainer.contains(param1))
         {
            ObjectUtils.disposeObject(param1);
            param1 = null;
         }
         SoundManager.instance.play("008");
         if(this.tweenArr.length > 0)
         {
            this.tweenArr.shift().clear();
         }
         else
         {
            this.dispose();
         }
      }
      
      private function getBagAniam() : MovieClipWrapper
      {
         var _loc1_:MovieClip = null;
         _loc1_ = null;
         _loc1_ = null;
         _loc1_ = ClassUtils.CreatInstance("asset.toolbar.GlowAniAccect") as MovieClip;
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("dropGoods.bagPoint");
         _loc1_.x = _loc2_.x;
         _loc1_.y = _loc2_.y;
         return new MovieClipWrapper(_loc1_,true,true);
      }
      
      private function getEmailAniam() : MovieClipWrapper
      {
         var _loc1_:MovieClip = null;
         _loc1_ = null;
         var _loc2_:Point = null;
         _loc1_ = ClassUtils.CreatInstance("asset.toolbar.GlowAniAccect") as MovieClip;
         _loc2_ = ComponentFactory.Instance.creatCustomObject("dropGoods.emailPoint");
         _loc1_.x = _loc2_.x;
         _loc1_.y = _loc2_.y;
         return new MovieClipWrapper(_loc1_,true,true);
      }
      
      private function setGoodsList(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Array = new Array();
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = 0;
            while(true)
            {
               if(_loc3_ >= this.goodsList.length)
               {
                  _loc5_ = 0;
                  _loc6_ = new Object();
                  _loc3_ = 0;
                  while(_loc3_ < param1.length)
                  {
                     if(param1[_loc2_].TemplateID == param1[_loc3_].TemplateID)
                     {
                        _loc5_++;
                     }
                     _loc3_++;
                  }
                  _loc6_.item = param1[_loc2_];
                  _loc6_.count = _loc5_;
                  _loc9_.push(_loc6_);
                  break;
               }
               if(param1[_loc2_].TemplateID == this.goodsList[_loc3_].TemplateID)
               {
                  break;
               }
               _loc3_++;
            }
            _loc2_++;
         }
         if(_loc9_.length > 7)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc9_.length && _loc2_ < 10)
            {
               this.goodsList.push(_loc9_[_loc2_].item);
               _loc2_++;
            }
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < _loc9_.length)
            {
               _loc7_ = int(_loc9_[_loc2_].count);
               if(_loc7_ == 1)
               {
                  this.goodsList.push(_loc9_[_loc2_].item);
               }
               else if(_loc7_ > 1 && _loc7_ <= 3)
               {
                  _loc4_ = Math.random() * 2 + 2;
                  _loc8_ = 0;
                  while(_loc8_ < _loc4_)
                  {
                     this.goodsList.push(_loc9_[_loc2_].item);
                     _loc8_++;
                  }
               }
               else if(_loc7_ > 3)
               {
                  _loc4_ = Math.random() * 3 + 2;
                  _loc8_ = 0;
                  while(_loc8_ < _loc4_)
                  {
                     this.goodsList.push(_loc9_[_loc2_].item);
                     _loc8_++;
                  }
               }
               _loc2_++;
            }
         }
      }
      
      public function dispose() : void
      {
         this.parentContainer = null;
         this.beginPoint = null;
         this.endPoint = null;
         this.goodsList = null;
         this.timeOutIdArr = null;
         while(this.tweenArr.length > 0)
         {
            this.tweenArr.shift().clear();
         }
         this.tweenArr = null;
         this.goodsTipList = null;
         this._info = null;
      }
   }
}
