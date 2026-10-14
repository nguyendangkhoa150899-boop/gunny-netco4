package pyramid.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerConfigManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import pyramid.PyramidManager;
   
   public class PyramidTopBox extends Component
   {
       
      
      private var _topBoxMovie:MovieClip;
      
      private var _state:int;
      
      public function PyramidTopBox()
      {
         super();
         this.graphics.beginFill(16777215,0);
         this.graphics.drawRect(0,0,100,100);
         this.graphics.endFill();
         this.tipStyle = "ddt.view.tips.OneLineTip";
         this.tipDirctions = "7,3";
         this.tipGapH = 100;
         this.tipGapV = 50;
         var _loc1_:Array = ServerConfigManager.instance.pyramidTopMinMaxPoint;
         this.tipData = LanguageMgr.GetTranslation("ddt.pyramid.topBoxMovieTipsMsg",_loc1_[0],_loc1_[1]);
      }
      
      public function addTopBoxMovie(param1:Sprite) : void
      {
         this._topBoxMovie = ComponentFactory.Instance.creat("assets.pyramid.topBox");
         this._topBoxMovie.x = this.x;
         this._topBoxMovie.y = this.y;
         this._topBoxMovie.gotoAndStop(1);
         param1.addChild(this._topBoxMovie);
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      public function topBoxMovieMode(param1:int = 0) : void
      {
         if(PyramidManager.instance.movieLock && param1 == 0)
         {
            return;
         }
         this._state = param1;
         var _loc2_:Boolean = false;
         var _loc3_:MovieClip = this._topBoxMovie["box"];
         switch(param1)
         {
            case 0:
               _loc3_.gotoAndStop(1);
               break;
            case 1:
               _loc2_ = true;
               _loc3_.gotoAndStop(2);
               break;
            case 2:
               _loc2_ = false;
               PyramidManager.instance.movieLock = true;
               _loc3_.addFrameScript(_loc3_.totalFrames - 1,this.toBoxMoviePlayStop);
               _loc3_.gotoAndPlay(3);
               break;
            default:
               _loc3_.stop();
         }
         this.buttonMode = _loc2_;
      }
      
      private function toBoxMoviePlayStop() : void
      {
         PyramidManager.instance.movieLock = false;
         if(Boolean(this._topBoxMovie))
         {
            this.topBoxMovieMode(0);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.graphics.clear();
         ObjectUtils.disposeObject(this._topBoxMovie);
         this._topBoxMovie = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
