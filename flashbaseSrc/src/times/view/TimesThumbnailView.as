package times.view
{
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import times.TimesController;
   import times.data.TimesPicInfo;
   
   public class TimesThumbnailView extends Sprite implements Disposeable
   {
       
      
      private var _controller:TimesController;
      
      private var _pointArr:Vector.<times.view.TimesThumbnailPoint>;
      
      private var _spacing:int;
      
      private var _pointGroup:SelectedButtonGroup;
      
      private var _pointIdx:int;
      
      public function TimesThumbnailView(param1:TimesController)
      {
         super();
         this._controller = param1;
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TimesPicInfo = null;
         var _loc4_:times.view.TimesThumbnailPoint = null;
         this._pointGroup = new SelectedButtonGroup();
         this._pointArr = new Vector.<TimesThumbnailPoint>();
         var _loc5_:Vector.<int> = new Vector.<int>();
         var _loc6_:int = 0;
         var _loc7_:Array = this._controller.model.contentInfos;
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_.length)
         {
            _loc5_.push(_loc7_[_loc8_].length);
            _loc1_ += _loc5_[_loc8_];
            _loc8_++;
         }
         if(_loc1_ != 0)
         {
            this._spacing = 360 / (_loc1_ - 1);
         }
         var _loc9_:int = 0;
         while(_loc9_ < _loc7_.length)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc5_[_loc9_])
            {
               _loc3_ = new TimesPicInfo();
               _loc3_.targetCategory = _loc9_;
               _loc3_.targetPage = _loc2_;
               _loc4_ = new times.view.TimesThumbnailPoint(_loc3_);
               _loc4_.tipStyle = "times.view.TimesThumbnailPointTip";
               _loc4_.tipDirctions = "0";
               _loc4_.tipGapV = 10;
               _loc4_.tipData = {
                  "isRevertTip":Boolean(_loc6_ > _loc1_ / 2),
                  "category":_loc9_,
                  "page":_loc2_
               };
               _loc4_.x = _loc6_++ * this._spacing;
               this._pointGroup.addSelectItem(_loc4_);
               addChild(_loc4_);
               this._pointArr.push(_loc4_);
               _loc2_++;
            }
            _loc9_++;
         }
         this._pointGroup.selectIndex = 0;
      }
      
      public function set pointIdx(param1:int) : void
      {
         if(this._pointIdx == param1)
         {
            return;
         }
         this._pointArr[this._pointIdx].pointPlay("rollOut");
         this._pointIdx = param1;
         this._pointArr[this._pointIdx].pointStop("selected");
         this._pointGroup.selectIndex = this._pointIdx;
      }
      
      public function dispose() : void
      {
         this._controller = null;
         ObjectUtils.disposeObject(this._pointGroup);
         this._pointGroup = null;
         this._pointArr = null;
         this._controller = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
