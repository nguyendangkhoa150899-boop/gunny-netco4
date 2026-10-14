package chickActivation.view
{
   import chickActivation.ChickActivationManager;
   import chickActivation.event.ChickActivationEvent;
   import chickActivation.model.ChickActivationModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class ChickActivationLevelPacks extends Sprite implements Disposeable
   {
       
      
      public var packsLevelArr:Array;
      
      private var _arrData:Array;
      
      private var _progressLine1:Bitmap;
      
      private var _progressLine2:Bitmap;
      
      private var _drawProgress1Data:BitmapData;
      
      private var _drawProgress2Data:BitmapData;
      
      public function ChickActivationLevelPacks()
      {
         this.packsLevelArr = [{"level":5},{"level":10},{"level":25},{"level":30},{"level":40},{"level":45},{"level":48},{"level":50},{"level":55},{"level":60}];
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:LevelPacksComponent = null;
         var _loc3_:Bitmap = null;
         var _loc4_:MovieClip = null;
         _loc1_ = 0;
         _loc2_ = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc1_ = 0;
         _loc2_ = null;
         var _loc5_:GoodTipInfo = null;
         _loc3_ = null;
         _loc4_ = null;
         var _loc6_:InventoryItemInfo = null;
         this._progressLine1 = ComponentFactory.Instance.creatBitmap("assets.chickActivation.levelPacksProgressBg");
         PositionUtils.setPos(this._progressLine1,"chickActivation.progressLinePos1");
         addChild(this._progressLine1);
         this._progressLine2 = ComponentFactory.Instance.creatBitmap("assets.chickActivation.levelPacksProgressBg");
         PositionUtils.setPos(this._progressLine2,"chickActivation.progressLinePos2");
         addChild(this._progressLine2);
         this._drawProgress1Data = ComponentFactory.Instance.creatBitmapData("assets.chickActivation.levelPacksProgress1");
         this._drawProgress2Data = ComponentFactory.Instance.creatBitmapData("assets.chickActivation.levelPacksProgress2");
         var _loc7_:Array = ChickActivationManager.instance.model.itemInfoList[12];
         _loc1_ = 0;
         while(_loc1_ < this.packsLevelArr.length)
         {
            _loc2_ = new LevelPacksComponent();
            _loc5_ = new GoodTipInfo();
            if(Boolean(_loc7_))
            {
               _loc6_ = ChickActivationManager.instance.model.getInventoryItemInfo(_loc7_[_loc1_]);
               _loc5_.itemInfo = _loc6_;
            }
            _loc2_.tipData = _loc5_;
            _loc3_ = ComponentFactory.Instance.creatBitmap("assets.chickActivation.packsLevel_" + this.packsLevelArr[_loc1_].level);
            PositionUtils.setPos(_loc3_,"chickActivation.packsLevelBitmapPos");
            _loc4_ = ClassUtils.CreatInstance("assets.chickActivation.packsMovie");
            _loc4_.gotoAndStop(1);
            PositionUtils.setPos(_loc4_,"chickActivation.packsMoviePos");
            _loc4_.mouseChildren = false;
            _loc4_.mouseEnabled = false;
            _loc2_.levelIndex = _loc1_ + 1;
            _loc2_.addChild(_loc3_);
            _loc2_.addChild(_loc4_);
            _loc2_.x = _loc1_ % 5 * 116;
            _loc2_.y = int(_loc1_ / 5) * 80;
            addChild(_loc2_);
            this.packsLevelArr[_loc1_].movie = _loc4_;
            this.packsLevelArr[_loc1_].sp = _loc2_;
            _loc1_++;
         }
      }
      
      private function initEvent() : void
      {
         this.addEventListener(MouseEvent.CLICK,this.__levelItemsClickHandler);
      }
      
      private function __levelItemsClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:LevelPacksComponent = null;
         var _loc3_:int = 0;
         if(param1.target is LevelPacksComponent)
         {
            _loc2_ = LevelPacksComponent(param1.target);
            if(_loc2_.isGray)
            {
               _loc3_ = LevelPacksComponent(param1.target).levelIndex;
               dispatchEvent(new ChickActivationEvent(ChickActivationEvent.CLICK_LEVELPACKS,_loc3_));
            }
         }
      }
      
      public function update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:Boolean = false;
         var _loc7_:ChickActivationModel = ChickActivationManager.instance.model;
         var _loc8_:int = _loc7_.getRemainingDay();
         if(_loc7_.isKeyOpened > 0 && _loc8_ > 0)
         {
            _loc1_ = -1;
            _loc2_ = PlayerManager.Instance.Self.Grade;
            _loc3_ = 0;
            while(_loc3_ < this.packsLevelArr.length)
            {
               if(this.packsLevelArr[_loc3_].level <= _loc2_)
               {
                  _loc1_ = _loc3_;
               }
               _loc3_++;
            }
            if(_loc1_ == -1)
            {
               return;
            }
            if(_loc1_ > 4)
            {
               this.updateProgressLine(this._progressLine1,4);
               this.updateProgressLine(this._progressLine2,_loc1_ - 5);
            }
            else
            {
               this.updateProgressLine(this._progressLine1,_loc1_);
            }
            _loc4_ = 0;
            while(_loc4_ <= _loc1_)
            {
               _loc5_ = MovieClip(this.packsLevelArr[_loc4_].movie);
               _loc6_ = ChickActivationManager.instance.model.getGainLevel(_loc4_ + 1);
               if(_loc6_)
               {
                  _loc5_.gotoAndStop(1);
                  LevelPacksComponent(this.packsLevelArr[_loc4_].sp).buttonGrayFilters(_loc6_);
               }
               else
               {
                  _loc5_.gotoAndStop(2);
                  LevelPacksComponent(this.packsLevelArr[_loc4_].sp).buttonGrayFilters(_loc6_);
               }
               _loc4_++;
            }
         }
      }
      
      private function updateProgressLine(param1:Bitmap, param2:int) : void
      {
         if(param2 < 0)
         {
            return;
         }
         var _loc3_:Number = 116;
         var _loc4_:int = 0;
         while(_loc4_ <= param2)
         {
            param1.bitmapData.copyPixels(this._drawProgress1Data,this._drawProgress1Data.rect,new Point(_loc3_ * _loc4_,0),null,null,true);
            if(_loc4_ != 0)
            {
               param1.bitmapData.copyPixels(this._drawProgress2Data,this._drawProgress2Data.rect,new Point(_loc3_ * (_loc4_ - 1) + this._drawProgress1Data.width - 7,2),null,null,true);
            }
            _loc4_++;
         }
      }
      
      private function removeEvent() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.__levelItemsClickHandler);
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         this.removeEvent();
         if(Boolean(this.packsLevelArr))
         {
            _loc1_ = 0;
            while(_loc1_ < this.packsLevelArr.length)
            {
               if(Boolean(this.packsLevelArr[_loc1_].sp))
               {
                  ObjectUtils.disposeAllChildren(this.packsLevelArr[_loc1_].sp);
                  ObjectUtils.disposeObject(this.packsLevelArr[_loc1_].sp);
                  this.packsLevelArr[_loc1_].sp = null;
               }
               _loc1_++;
            }
            this.packsLevelArr = null;
         }
         ObjectUtils.disposeObject(this._progressLine1);
         this._progressLine1 = null;
         ObjectUtils.disposeObject(this._progressLine2);
         this._progressLine2 = null;
         ObjectUtils.disposeObject(this._drawProgress1Data);
         this._drawProgress1Data = null;
         ObjectUtils.disposeObject(this._drawProgress2Data);
         this._drawProgress2Data = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
