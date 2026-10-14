package explorerManual.view.chapter
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import explorerManual.data.ExplorerManualInfo;
   import flash.display.Bitmap;
   
   public class ManualPropertyPrgress extends Component
   {
       
      
      protected var _progressLabel:FilterFrameText;
      
      protected var _proBitmap:Bitmap;
      
      protected var _proBitMask:Bitmap;
      
      protected var _value:Number = 0;
      
      protected var _max:Number = 100;
      
      private var _oldValue:Number = 0;
      
      private var _isInit:Boolean = false;
      
      private var _model:ExplorerManualInfo;
      
      public function ManualPropertyPrgress(param1:ExplorerManualInfo)
      {
         super();
         this._model = param1;
         _width = _height = 10;
         this.initView();
      }
      
      private function initView() : void
      {
         this._proBitMask = ComponentFactory.Instance.creat("asset.explorerManual.progressAsset");
         this._proBitMask.width = 0;
         addChild(this._proBitMask);
         this._proBitmap = ComponentFactory.Instance.creat("asset.explorerManual.progressAsset");
         addChild(this._proBitmap);
         this._proBitmap.mask = this._proBitMask;
         this._progressLabel = ComponentFactory.Instance.creatComponentByStylename("explorerManual.chapterLeft.progressText");
         addChild(this._progressLabel);
      }
      
      public function setProgress(param1:Number, param2:Number) : void
      {
         this._oldValue = this._value;
         this._value = param1;
         this._max = param2;
         this.drawProgress();
      }
      
      protected function drawProgress() : void
      {
         var _loc1_:int = 0;
         if(this._value <= 0 && this._isInit)
         {
            _loc1_ = 225;
         }
         else
         {
            _loc1_ = 225 * this._value / this._max;
         }
         var _loc2_:Number = Number(this._progressLabel.text);
         var _loc3_:Number = this._value == 0 ? this._max : Number(this._value);
         var _loc4_:Number = (_loc3_ - _loc2_) / 25;
         TweenLite.to(this._proBitMask,1,{
            "width":_loc1_,
            "onUpdate":this.updateLabel,
            "onUpdateParams":[_loc4_],
            "onComplete":this.updateComplete
         });
      }
      
      private function updateLabel(param1:int) : void
      {
         if(this._isInit)
         {
            this._progressLabel.text = (int(this._progressLabel.text) + param1).toString();
         }
      }
      
      private function updateComplete() : void
      {
         if(this._value == 0)
         {
            this._proBitMask.width = 0;
         }
         this._progressLabel.text = this._value.toString();
         this._model.proLevMaxProgress = this._model.maxProgress;
         this._isInit = true;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._proBitMask))
         {
            TweenLite.killTweensOf(this._proBitMask);
            ObjectUtils.disposeObject(this._proBitMask);
            this._proBitMask = null;
         }
         ObjectUtils.disposeObject(this._proBitmap);
         this._proBitmap = null;
         ObjectUtils.disposeObject(this._progressLabel);
         this._progressLabel = null;
         this._model = null;
         super.dispose();
      }
   }
}
