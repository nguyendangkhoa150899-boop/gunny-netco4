package wonderfulActivity.items
{
   import com.gskinner.geom.ColorMatrix;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   
   public class AccumulativeItem extends Component implements Disposeable
   {
       
      
      private var _box:MovieClip;
      
      private var _numberBG:Bitmap;
      
      private var _number:FilterFrameText;
      
      private var _progressPoint:Bitmap;
      
      private var _questionMark:FilterFrameText;
      
      private var glintFilter:GlowFilter;
      
      private var lightFilter:ColorMatrixFilter;
      
      private var grayFilters:Array;
      
      public var index:int;
      
      private var tempfilters:Array;
      
      private var glintFlag:Boolean = true;
      
      public function AccumulativeItem()
      {
         this.tempfilters = [];
         super();
         this.initFilter();
      }
      
      private function initFilter() : void
      {
         this.tempfilters = [];
         this.grayFilters = ComponentFactory.Instance.creatFilters("grayFilter");
         var _loc1_:ColorMatrix = new ColorMatrix();
         this.lightFilter = new ColorMatrixFilter();
         _loc1_.adjustColor(50,4,4,2);
         this.lightFilter.matrix = _loc1_;
      }
      
      public function initView(param1:int) : void
      {
         this.index = param1;
         this._numberBG = ComponentFactory.Instance.creat("wonderful.accumulative.numberBG");
         addChild(this._numberBG);
         this._questionMark = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulative.questionMark");
         this._questionMark.text = "?";
         addChild(this._questionMark);
         this._number = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulative.number");
         this._number.visible = false;
         addChild(this._number);
         this._box = ComponentFactory.Instance.creat("wonderful.accumulative.box");
         PositionUtils.setPos(this._box,"wonderful.Accumulative.boxPos");
         this._box.gotoAndStop(param1);
         this._progressPoint = ComponentFactory.Instance.creat("wonderful.accumulative.progress1");
         this._progressPoint.visible = false;
         addChild(this._progressPoint);
         addChild(this._box);
      }
      
      public function lightProgressPoint() : void
      {
         this._progressPoint.visible = true;
      }
      
      public function setNumber(param1:int) : void
      {
         this._questionMark.visible = false;
         this._number.visible = true;
         var _loc2_:int = 0;
         if(param1 >= 100000)
         {
            _loc2_ = Math.floor(param1 / 10000);
            this._number.text = _loc2_.toString() + "w";
         }
         else
         {
            this._number.text = param1.toString();
         }
      }
      
      public function turnGray(param1:Boolean) : void
      {
         this.glint(false);
         var _loc2_:int = this.tempfilters.indexOf(this.lightFilter);
         if(_loc2_ >= 0)
         {
            this.tempfilters = [this.lightFilter];
         }
         else
         {
            this.tempfilters = [];
         }
         if(param1)
         {
            this.tempfilters = this.tempfilters.concat(this.grayFilters);
         }
         this._box.filters = this.tempfilters;
      }
      
      public function turnLight(param1:Boolean) : void
      {
         var _loc2_:int = this.tempfilters.indexOf(this.lightFilter);
         if(param1)
         {
            if(_loc2_ == -1)
            {
               this.tempfilters.push(this.lightFilter);
            }
         }
         else if(_loc2_ >= 0)
         {
            this.tempfilters.splice(_loc2_,1);
         }
         if(Boolean(this.glintFilter))
         {
            this._box.filters = this.tempfilters.concat(this.glintFilter);
         }
         else
         {
            this._box.filters = this.tempfilters;
         }
      }
      
      public function glint(param1:Boolean) : void
      {
         if(param1)
         {
            addEventListener(Event.ENTER_FRAME,this.__enterFrame);
            this.glintFilter = new GlowFilter(16768512,1,10,10,2.7,3);
            this._box.filters = this.tempfilters.concat(this.glintFilter);
         }
         else
         {
            if(hasEventListener(Event.ENTER_FRAME))
            {
               removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
            }
            this._box.filters = this.tempfilters;
            this.glintFilter = null;
         }
      }
      
      private function __enterFrame(param1:Event) : void
      {
         if(this.glintFlag)
         {
            this.glintFilter.blurX -= 0.17;
            this.glintFilter.blurY -= 0.17;
            this.glintFilter.strength -= 0.1;
            if(this.glintFilter.blurX < 8)
            {
               this.glintFlag = false;
            }
         }
         else
         {
            this.glintFilter.blurX += 0.17;
            this.glintFilter.blurY += 0.17;
            this.glintFilter.strength += 0.1;
            if(this.glintFilter.blurX > 10)
            {
               this.glintFlag = true;
            }
         }
         this._box.filters = this.tempfilters.concat(this.glintFilter);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._number))
         {
            ObjectUtils.disposeObject(this._number);
         }
         this._number = null;
         if(Boolean(this._numberBG))
         {
            ObjectUtils.disposeObject(this._numberBG);
         }
         this._numberBG = null;
         if(Boolean(this._box))
         {
            ObjectUtils.disposeObject(this._box);
         }
         this._box = null;
         super.dispose();
      }
      
      public function get box() : MovieClip
      {
         return this._box;
      }
   }
}
