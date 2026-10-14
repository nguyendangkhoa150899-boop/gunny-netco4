package exitPrompt
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class MissionSprite extends Sprite implements Disposeable
   {
       
      
      public var oldHeight:int;
      
      private const BG_X:int = 4;
      
      public const BG_Y:int = -37;
      
      private const BG_WIDTH:int = 315;
      
      private var _arr:Array;
      
      public function MissionSprite(param1:Array)
      {
         super();
         this._arr = param1;
         this._init(this._arr);
      }
      
      private function _init(param1:Array) : void
      {
         var _loc2_:ScaleBitmapImage = null;
         var _loc3_:FilterFrameText = null;
         var _loc4_:FilterFrameText = null;
         var _loc5_:int = 0;
         _loc2_ = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            _loc3_ = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.MissionText0");
            _loc3_.text = param1[_loc5_][0] as String;
            _loc3_.y = _loc3_.height * _loc5_ * 3 / 2;
            addChild(_loc3_);
            _loc4_ = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.MissionText1");
            _loc4_.text = param1[_loc5_][1] as String;
            _loc4_.y = _loc4_.height * _loc5_ * 3 / 2;
            addChild(_loc4_);
            _loc5_++;
         }
         this.oldHeight = height;
         _loc2_ = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.MissionBG");
         addChild(_loc2_);
         _loc2_.x = this.BG_X;
         _loc2_.y = this.BG_Y;
         _loc2_.width = this.BG_WIDTH;
         _loc2_.height = this.height - this.BG_Y;
         setChildIndex(_loc2_,0);
      }
      
      public function get content() : Array
      {
         return this._arr;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
      }
   }
}
