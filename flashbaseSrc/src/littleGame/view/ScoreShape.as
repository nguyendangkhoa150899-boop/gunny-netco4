package littleGame.view
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.ddt_internal;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import littleGame.LittleGameManager;
   
   public class ScoreShape extends Bitmap implements Disposeable
   {
      
      ddt_internal static const size:int = 22;
       
      
      private var _style:int;
      
      public function ScoreShape(param1:int = 0)
      {
         this._style = param1;
         super(null,"auto",true);
      }
      
      public function setScore(param1:int) : void
      {
         var _loc2_:BitmapData = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = param1.toString();
         if(this._style == 1)
         {
            _loc2_ = LittleGameManager.Instance.Current.ddt_internal::bigNum;
         }
         else
         {
            _loc2_ = LittleGameManager.Instance.Current.ddt_internal::normalNum;
         }
         _loc3_ = _loc2_.width / 11;
         _loc4_ = _loc2_.height;
         var _loc6_:BitmapData = new BitmapData((_loc5_.length + 1) * _loc3_,_loc4_,true,0);
         var _loc7_:Rectangle = new Rectangle(_loc2_.width - _loc3_,0,_loc3_,_loc4_);
         _loc6_.copyPixels(_loc2_,_loc7_,new Point(0,0));
         var _loc8_:int = _loc5_.length;
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            _loc7_.x = int(_loc5_.substr(_loc9_,1)) * _loc3_;
            _loc6_.copyPixels(_loc2_,_loc7_,new Point(_loc3_ * (_loc9_ + 1),0));
            _loc9_++;
         }
         if(Boolean(bitmapData))
         {
            bitmapData.dispose();
         }
         bitmapData = _loc6_;
      }
      
      public function dispose() : void
      {
         if(Boolean(bitmapData))
         {
            bitmapData.dispose();
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
